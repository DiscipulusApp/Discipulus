import 'package:collection/collection.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class GradeStatistics {
  bool isAlltimeHighest;
  bool isAlltimeLowest;

  // Schoolyear
  bool isHighestOfYear;
  bool isLowestOfYear;

  //Subject
  bool isHighestOfSubject; // Only of current year
  bool isHighestOfSubjectGlobal;
  bool isLowestOfSubject; // Only of current year
  bool isLowestOfSubjectGlobal;

  /// The time between your new highest and your old highest
  DateTime? highestSinceGlobal;
  DateTime? highestSinceSubjectGlobal;

  /// The time between your new lowest and your old lowest
  DateTime? lowestSinceGlobal;
  DateTime? lowestSinceSubjectGlobal;

  GradeStatistics({
    this.isHighestOfYear = false,
    this.isAlltimeHighest = false,
    this.isAlltimeLowest = false,
    this.isHighestOfSubject = false,
    this.isHighestOfSubjectGlobal = false,
    this.isLowestOfSubject = false,
    this.isLowestOfSubjectGlobal = false,
    this.isLowestOfYear = false,
    this.highestSinceGlobal,
    this.highestSinceSubjectGlobal,
    this.lowestSinceGlobal,
    this.lowestSinceSubjectGlobal,
  });
}

extension GradeExtension on Grade {
  /// Computes a [GradeStatistics] object
  Future<GradeStatistics> get gradeStatistics async {
    Future<bool> isHighestOrLowest(
        QueryBuilder<Grade, Grade, QAfterFilterCondition> query,
        {bool highest = true}) async {
      // Since Magister stores thier grades in Strings,
      // and parsing all the string is really expensive
      // we have to correct for when the user scores a 10
      if (cijferStr == "10,0") {
        // User scored a ten, that is always the highest
        return highest;
      } else if (await query.numericalGrades.cijferStrEqualTo("10,0").count() >
          0) {
        // If the current grade is not a ten, but a ten does exist,
        // it is not the highest
        return false;
      }

      late final QueryBuilder<Grade, Grade, QAfterSortBy> sorted;
      if (highest) {
        // Sort by highest
        sorted = query.numericalGrades.sortByCijferStrDesc();
      } else {
        // Sort by lowest
        sorted = query.numericalGrades.sortByCijferStr();
      }

      // Check if current grade is the highest
      return (await sorted.findFirst())?.cijferStr == cijferStr;
    }

    Future<DateTime?> timeCheck(
        QueryBuilder<Grade, Grade, QAfterFilterCondition> query,
        {bool highest = true,
        bool disableRecordCheck = false}) async {
      // Check if the grade is a record grade
      if (await isHighestOrLowest(query, highest: highest) ||
          disableRecordCheck) {
        late final QueryBuilder<Grade, Grade, QAfterSortBy> sorted;

        if (highest) {
          // If it is higher it should return the last grade that was the record highest
          sorted = query.numericalGrades
              .datumIngevoerdLessThan(datumIngevoerd)
              .cijferStrLessThan(cijferStr, include: true)
              .not()
              .cijferStrEqualTo("10,0")
              .sortByCijferStrDesc();
        } else {
          // If its the lowest it should return the latest grade that was lower than this one
          sorted = query.numericalGrades
              .datumIngevoerdLessThan(datumIngevoerd)
              .cijferStrLessThan(cijferStr, include: true)
              .not()
              .cijferStrEqualTo("10,0")
              .sortByDatumIngevoerdDesc();
        }

        return await sorted.datumIngevoerdProperty().findFirst() ??
            datumIngevoerd;
      }
      return null;
    }

    // Find all grades
    QueryBuilder<Grade, Grade, QAfterFilterCondition> globalGrades = isar.grades
        .filter()
        .schoolyear((q) => q.profile(
            (q) => q.uuidEqualTo(schoolyear.value!.profile.value!.uuid)))
        .numericalGrades;

    // Find related subjects
    List<int> relatedUUIDs =
        (await subject.value!.relatedSchoolyears).map((e) => e.uuid).toList();
    QueryBuilder<Grade, Grade, QAfterFilterCondition> relatedSubjects =
        globalGrades.subject(
            (q) => q.anyOf(relatedUUIDs, (q, uuid) => q.uuidEqualTo(uuid)));

    GradeStatistics statistics = GradeStatistics(
      // Global
      isAlltimeHighest: await isHighestOrLowest(globalGrades),
      isAlltimeLowest: await isHighestOrLowest(globalGrades, highest: false),
      // Schoolyear

      isHighestOfYear:
          await isHighestOrLowest(schoolyear.value!.grades.filter()),
      isLowestOfYear: await isHighestOrLowest(schoolyear.value!.grades.filter(),
          highest: false),

      // Subject in schoolyear
      isHighestOfSubject:
          await isHighestOrLowest(subject.value!.grades.filter()),
      isLowestOfSubject: await isHighestOrLowest(subject.value!.grades.filter(),
          highest: false),

      // Subject Global
      isHighestOfSubjectGlobal: await isHighestOrLowest(relatedSubjects),
      isLowestOfSubjectGlobal:
          await isHighestOrLowest(relatedSubjects, highest: false),

      // Times
      highestSinceGlobal: await timeCheck(globalGrades),
      highestSinceSubjectGlobal: await timeCheck(relatedSubjects),
    );

    // Since showing dates within a schoolyear is not that interesting,
    // we will only show record-dates when something is the lowest of the year
    // or lowest of a subject
    return statistics
      ..lowestSinceGlobal = await timeCheck(globalGrades,
          highest: false, disableRecordCheck: statistics.isLowestOfYear)
      ..lowestSinceSubjectGlobal = await timeCheck(relatedSubjects,
          highest: false, disableRecordCheck: statistics.isLowestOfSubject);
  }
}

///
///   Grades extensions
///
///     You know, when they are a collective
///

extension GradeListExtension on Iterable<Grade> {
  /// Removes grades that are not numbers
  List<Grade> get numericalGrades =>
      useable.where((Grade grade) => grade.grade != -1).toList();

  /// Removes grade-types that are not used, such as averages
  List<Grade> get useable => where(
          (Grade grade) => grade.cijferKolom.kolomSoort == 1 && grade.isEnabled)
      .toList();

  /// Gets the average for list of grades, whilst keeping the weights in mind.
  double get average {
    List<Grade> grades = numericalGrades;

    // Check if this list of grades contains grades from multiple subjects
    if (any((e) => e.subject.value?.uuid != first.subject.value?.uuid)) {
      // The average contains different subjects, so it needs to be calculated
      // in a different way
      Set<int> subjectsUUIDs =
          grades.map((e) => e.subject.value?.uuid).nonNulls.toSet();
      return [
        for (int subjectUUID in subjectsUUIDs)
          where((e) => e.subject.value?.uuid == subjectUUID).average
      ].average;
    }

    // The grades are from one soul subject, so we can just calculate the average
    // by doing this.
    return grades.map((e) => e.grade * (e.weight ?? 1)).sum /
        grades.map((e) => e.weight ?? 1).sum;
  }
}

extension GradeQueryEntensionBeforeFilterCondition
    on QueryBuilder<Grade, Grade, QFilterCondition> {
  /// Gets all the grades that are a specific grade when rounded.
  QueryBuilder<Grade, Grade, QAfterFilterCondition> roundedGrades(int grade) =>
      group((q) => group((q) => q.cijferStrMatches("$grade,?").and().group(
                (q) => q
                    .cijferStrMatches("?,0")
                    .or()
                    .cijferStrMatches("?,1")
                    .or()
                    .cijferStrMatches("?,2")
                    .or()
                    .cijferStrMatches("?,3")
                    .or()
                    .cijferStrMatches("?,4"),
              ))
          .or()
          .group((q) => q.cijferStrMatches("${grade - 1},?").and().group(
                (q) => q
                    .cijferStrMatches("?,5")
                    .or()
                    .cijferStrMatches("?,6")
                    .or()
                    .cijferStrMatches("?,7")
                    .or()
                    .cijferStrMatches("?,8")
                    .or()
                    .cijferStrMatches("?,9"),
              ))
          .or()
          .optional(
            grade == 10,
            (q) => q.cijferStrMatches("10*"),
          ));

  /// Filters non-grade grades, such as averages and removes disabled grades by default.
  QueryBuilder<Grade, Grade, QAfterFilterCondition> useable(
          {bool showDisabled = false}) =>
      optional(
        !showDisabled,
        (q) => q.isEnabledEqualTo(true),
      ).and().cijferKolom((q) => q.kolomSoortEqualTo(1));

  QueryBuilder<Grade, Grade, QAfterFilterCondition> get numericalGrades =>
      useable().and().group(
            (q) => q
                .cijferStrStartsWith("0")
                .or()
                .cijferStrStartsWith("1")
                .or()
                .cijferStrStartsWith("2")
                .or()
                .cijferStrStartsWith("3")
                .or()
                .cijferStrStartsWith("4")
                .or()
                .cijferStrStartsWith("5")
                .or()
                .cijferStrStartsWith("6")
                .or()
                .cijferStrStartsWith("7")
                .or()
                .cijferStrStartsWith("8")
                .or()
                .cijferStrStartsWith("9"),
          );
}

extension GradeQueryEntension
    on QueryBuilder<Grade, Grade, QAfterFilterCondition> {
  /// Calculates the average, keeping in mind that the grade has weight.
  Future<double> get average async {
    QueryBuilder<Grade, Grade, QAfterSortBy> sorted =
        sortById().thenByDatumIngevoerd();

    List<List> data = await Future.wait([
      sorted.cijferStrProperty().findAll(),
      sorted.weightProperty().findAll(),
      sorted.subjectUUIDProperty().findAll()
    ]);

    List<String?> gradeStrings = data[0] as List<String?>;
    List<double?> weights = data[1] as List<double?>;
    List<int?> subjectUUIDs = data[2] as List<int?>;

    // Subject_uuid: {grade: weight}
    Map<int, MapEntry<double, double>> subjects = {};

    for (final (index, subjectUUID) in subjectUUIDs.indexed) {
      if (subjects[subjectUUID] == null) {
        // Subject has not been parsed yet
        subjects.addAll({subjectUUID ?? index: const MapEntry(0, 0)});
      }
      MapEntry<double, double> subject = subjects[subjectUUID ?? index]!;

      double? grade = gradeStrings[index] != null
          ? double.tryParse(gradeStrings[index]!.replaceAll(",", "."))
          : null;
      double? weight = weights[index];
      if (grade != null) {
        subjects[subjectUUID ?? index] = MapEntry(
            grade * (weight ?? 1) + subject.key, subject.value + (weight ?? 1));
      }
    }

    Iterable<double> averages = [
      for (final value in subjects.values) value.key / value.value
    ].whereNot((e) => e.isNaN);

    return averages.isEmpty ? double.nan : averages.average;
  }

  /// Calculates the average, keeping in mind that the grade has weight.
  double get averageSync {
    QueryBuilder<Grade, Grade, QAfterSortBy> sorted =
        sortById().thenByDatumIngevoerd();

    List<String?> gradeStrings = sorted.cijferStrProperty().findAllSync();
    List<double?> weights = sorted.weightProperty().findAllSync();
    List<int?> subjectUUIDs = sorted.subjectUUIDProperty().findAllSync();

    // Subject_uuid: {grade: weight}
    Map<int, MapEntry<double, double>> subjects = {};

    for (final (index, subjectUUID) in subjectUUIDs.indexed) {
      if (subjects[subjectUUID] == null) {
        // Subject has not been parsed yet
        subjects.addAll({subjectUUID ?? index: const MapEntry(0, 0)});
      }
      MapEntry<double, double>? subject = subjects[subjectUUID ?? index]!;

      double? grade = gradeStrings[index] != null
          ? double.tryParse(gradeStrings[index]!.replaceAll(",", "."))
          : null;
      double? weight = weights[index];
      if (grade != null) {
        subjects[subjectUUID ?? index] = MapEntry(
            grade * (weight ?? 1) + subject.key, subject.value + (weight ?? 1));
      }
    }

    subjects.removeWhere((key, value) => key == 0);

    Iterable<double> averages = [
      for (final value in subjects.values) value.key / value.value
    ].whereNot((e) => e.isNaN);

    return averages.isEmpty ? double.nan : averages.average;
  }

  /// Gets the averages from Magister and tries to combine the averages that
  /// just differ in decimals.
  List<List<Grade>> getMagisterAverages() {
    // Get stored averages
    List<List<Grade>> combined = [];
    List<Grade> averages = cijferKolom((q) => q.kolomSoortEqualTo(2))
        .cijferStrIsNotNull()
        .findAllSync()
      ..sort(
        (a, b) => a.subject.value!.volgnr.compareTo(b.subject.value!.volgnr),
      );

    for (Grade average in averages) {
      List<List<Grade>> found = combined.reversed
          .where((g) =>
              g.firstOrNull?.subject.value!.naam == average.subject.value!.naam)
          .toList();
      if (found.isNotEmpty) {
        for (List<Grade> grades in found) {
          // Sort grades based on the colum index
          grades.sort((a, b) => a.cijferKolom.kolomVolgNummer
              .compareTo(b.cijferKolom.kolomVolgNummer));

          List<Grade> chainedGrades = [];

          for (Grade grade in grades) {
            if (chainedGrades.isEmpty) {
              chainedGrades.add(grade);
            } else {
              if (int.parse(chainedGrades.last.cijferKolom.kolomVolgNummer) +
                      1 !=
                  int.parse(grade.cijferKolom.kolomVolgNummer)) {
                // Grades are not chained
                chainedGrades.clear();
              }
              chainedGrades.add(grade);
            }
          }

          // Remove grades that are not the final average
          grades.removeWhere((g) => !chainedGrades.contains(g));
        }

        // Add the average to a group of already parsed averages
        found.first
          ..add(average)
          ..sort(
            (a, b) => b.cijferStr!.length.compareTo(
              a.cijferStr!.length,
            ),
          );
      } else {
        combined.add([average]);
      }
    }
    return combined;
  }

  /// Calculates a new average when a certain grade is added to the average
  /// Map<double, double> == {weight: grade}
  Future<double> newAverageFromGrade(
    List<DummyGrade> grades, {
    int? ignoredGradeUUID,
  }) async {
    // Set beginning values
    double total = grades.map((e) => e.grade * e.weight).sum;
    double totalgrades = grades.map((e) => e.weight).sum;

    // Loop through all the grades except the ignored ones
    for (Grade grade in await numericalGrades
        .optional(
          ignoredGradeUUID != null,
          (q) => q.not().uuidEqualTo(ignoredGradeUUID!),
        )
        .findAll()) {
      total += grade.grade * (grade.weight ?? 1);
      totalgrades += grade.weight ?? 1;
    }

    // Return the average
    return total / totalgrades;
  }

  /// Calculates a new grade if a certain average has to be hit
  Future<double> newGradeFromAverage(
    double average,
    double weight, {
    List<DummyGrade> grades = const [],
    int? ignoredGradeUUID,
  }) async {
    double total = grades.map((e) => e.grade * e.weight).sum;
    double totalgrades = grades.map((e) => e.weight).sum;

    for (var grade in await numericalGrades
        .optional(
          ignoredGradeUUID != null,
          (q) => q.not().uuidEqualTo(ignoredGradeUUID!),
        )
        .findAll()) {
      total += grade.grade * (grade.weight ?? 1);
      totalgrades += grade.weight ?? 1;
    }
    return ((totalgrades + weight) * average - total) / weight;
  }

  /// Calculates the impact that a certain grade has made on the average
  Future<GradeChange> changeInAverage(
      {bool includeFuture = false, required Grade grade}) async {
    List<Grade> grades = await cijferKolom((q) => q.kolomSoortEqualTo(1))
        .optional(
          !includeFuture && grade.datumIngevoerd != null,
          (q) => q.removeFuture(grade.datumIngevoerd!),
        )
        .and()
        .not()
        .uuidEqualTo(grade.uuid)
        .findAll();
    return GradeChange(
        avarageAfter: [...grades, grade].average,
        averageBefore: grades.average);
  }

  /// Gets the change in average that a daterange made
  Future<GradeChange> changeInAverageDate(DateTimeRange range) async {
    List<Grade> grades = await cijferKolom((q) => q.kolomSoortEqualTo(1))
        .not()
        .group((q) => q
            .datumIngevoerdBetween(range.start, range.end)
            .or()
            .datumIngevoerdEqualTo(range.end))
        .findAll();

    return GradeChange(
      avarageAfter:
          (await cijferKolom((q) => q.kolomSoortEqualTo(1)).findAll()).average,
      averageBefore: grades.average,
    );
  }

  /// Gets the change in average from the last month
  /// The last month is determined from the date of the last grade.
  Future<GradeChange> changeInAverageLastMonth() async {
    DateTime lastGradeTime = (await sortByDatumIngevoerdDesc()
            .datumIngevoerdProperty()
            .findFirst()) ??
        DateTime.now();
    return changeInAverageDate(DateTimeRange(
      start: DateTime(
          lastGradeTime.year, lastGradeTime.month - 1, lastGradeTime.day),
      end: lastGradeTime,
    ));
  }

  /// Removes grades that were added after a certain grade
  QueryBuilder<Grade, Grade, QAfterFilterCondition> removeFuture(
          DateTime endDate) =>
      datumIngevoerdLessThan(endDate).or().datumIngevoerdEqualTo(endDate);
}

/// A dummy grade that contains a value and a weight.
class DummyGrade {
  double grade;
  double weight;

  DummyGrade({required this.grade, this.weight = 1});
}

///
///   Subject Extensions
///
///
///

enum SubjectSortType {
  alphabetical,
  recentGrade,
  highestAverage,
  amountOfGrades,
  magister,
  none,
}

extension SubjectSortTypeExtension on SubjectSortType {
  String get toName {
    switch (this) {
      case SubjectSortType.alphabetical:
        return "Alphabetisch";
      case SubjectSortType.highestAverage:
        return "Hoogste gemiddelde";
      case SubjectSortType.recentGrade:
        return "Recente cijfers";
      case SubjectSortType.amountOfGrades:
        return "Aantal cijfers";
      case SubjectSortType.magister:
        return "Magister";
      default:
        return "Geen";
    }
  }
}

extension SubjectListExtension on List<Subject> {
  /// Sorts the subjects in a specific order. Uses the value from [ProfileSettings] by default
  Future<List<Subject>> sortSubjects(
      {SubjectSortType? customSortingType}) async {
    SubjectSortType sortingType =
        customSortingType ?? appSettings.subjectSortType;

    switch (sortingType) {
      case SubjectSortType.alphabetical:
        return this
          ..sort((a, b) =>
              a.afkorting.toLowerCase().compareTo(b.afkorting.toLowerCase()));
      case SubjectSortType.highestAverage:
        Map<int, double> subjects = {};

        List<double> averages = await Future.wait([
          for (Subject subject in this)
            subject.grades.filter().numericalGrades.applyGradeFilter().average
        ]);

        subjects.addAll(averages.asMap().map(
            (key, value) => MapEntry(this[key].uuid, value.isNaN ? 0 : value)));

        return this
          ..sort(
            (a, b) => subjects[b.uuid]!.compareTo(subjects[a.uuid]!),
          );
      case SubjectSortType.amountOfGrades:
        Map<int, int> subjects = {};

        List<int> amounts = await Future.wait([
          for (Subject subject in this)
            subject.grades.filter().numericalGrades.applyGradeFilter().count()
        ]);

        subjects.addAll(amounts
            .asMap()
            .map((key, value) => MapEntry(this[key].uuid, value)));

        return this
          ..sort(
            (a, b) => subjects[b.uuid]!.compareTo(subjects[a.uuid]!),
          );
      case SubjectSortType.magister:
        return this
          ..sort(
            (a, b) => a.volgnr.compareTo(b.volgnr),
          );
      case SubjectSortType.recentGrade:
        Map<int, DateTime?> subjects = {};

        for (Subject subject in this) {
          subjects.addEntries([
            MapEntry(
                subject.uuid,
                (await subject.grades
                    .filter()
                    .sortByDatumIngevoerdDesc()
                    .datumIngevoerdProperty()
                    .findFirst()))
          ]);
        }

        return this
          ..sort(
            (a, b) =>
                subjects[b.uuid]
                    ?.compareTo(subjects[a.uuid] ?? DateTime(1900)) ??
                0,
          );
      default:
        return this;
    }
  }
}
