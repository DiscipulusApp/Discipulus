import 'dart:convert';

import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/api/models/personal.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';

part 'schoolyears.g.dart';

@Collection()
@Name("Schoolyear")
class Schoolyear {
  @Backlink(to: 'schoolyears')
  final profile = IsarLink<Profile>();
  Id get uuid => "${profile.value!.uuid}$id".hashCode;

  final grades = IsarLinks<Grade>();
  final periods = IsarLinks<GradePeriod>();
  final subjects = IsarLinks<Subject>();

  final Groep studie;
  final Groep groep;
  final Lesperiode lesperiode;
  final List<Groep> profielen;
  final PersoonlijkeMentor? persoonlijkeMentor;
  final DateTime begin;
  final DateTime einde;
  final bool? isZittenBlijver;
  final String? indicatie;
  final OpleidingCode? opleidingCode;
  final int? id;
  final bool? isHoofdAanmelding;

  Schoolyear({
    required this.studie,
    required this.groep,
    required this.lesperiode,
    required this.profielen,
    this.persoonlijkeMentor,
    required this.begin,
    required this.einde,
    this.isZittenBlijver,
    this.indicatie,
    this.opleidingCode,
    this.id,
    this.isHoofdAanmelding,
  });

  factory Schoolyear.fromJson(String str) =>
      Schoolyear.fromMap(json.decode(str));

  factory Schoolyear.fromMap(Map<String, dynamic> json) => Schoolyear(
        studie: json["studie"] != null
            ? Groep.fromMap(json["studie"])
            : Groep(),
        groep: json["groep"] != null
            ? Groep.fromMap(json["groep"])
            : Groep(),
        lesperiode: json["lesperiode"] != null
            ? Lesperiode.fromMap(json["lesperiode"])
            : Lesperiode(),
        profielen: json["profielen"] != null
            ? List<Groep>.from(json["profielen"].map((x) => Groep.fromMap(x)))
            : [],
        persoonlijkeMentor: json["persoonlijkeMentor"] == null
            ? null
            : PersoonlijkeMentor.fromMap(json["persoonlijkeMentor"]),
        begin: json["begin"] != null
            ? DateTime.parse(json["begin"]).toUtc()
            : DateTime(2000),
        einde: json["einde"] != null
            ? DateTime.parse(json["einde"]).toUtc()
            : DateTime(2000),
        isZittenBlijver: json["isZittenBlijver"],
        indicatie: json["indicatie"],
        opleidingCode: json["opleidingCode"] == null
            ? null
            : OpleidingCode.fromMap(json["opleidingCode"]),
        id: json["id"],
        isHoofdAanmelding: json["isHoofdAanmelding"],
      );

  /// Fills the grades from a schoolyear.
  ///
  /// This does not include the weights, unless there are 15 or less grades without a weight.
  Future<void> fillGrades() async {
    // Get data from Magister

    if (!(profile.value!.account.value?.permissions
            .hasPermissions(PermissionType.aanmeldingen) ??
        false)) {
      return;
    }

    var res = (await profile.value!.account.value!.api.dio.get(
            "personen/${profile.value!.id}/aanmeldingen/$id/cijfers/cijferoverzichtvooraanmelding?actievePerioden=false&alleenBerekendeKolommen=false&alleenPTAKolommen=false&peildatum=${einde.toIso8601String()}"))
        .data;

    List<Grade> newGrades = List<Grade>.from(
        res["Items"].map((x) => Grade.fromMap(x)..schoolyear.value = this));

    // Get current locally saved grades for this schoolyear
    List<Grade> existingGrades = await grades.filter().findAll();
    Map<int, Grade> existingGradesMap = {
      for (Grade g in existingGrades) g.uuid: g
    };
    Set<int> newUUIDs = newGrades.map((e) => e.uuid).toSet();

    // Prepare list of missing grades to be archived
    List<Grade> missingGrades =
        existingGrades.where((g) => !newUUIDs.contains(g.uuid)).map((g) {
      return g..isArchived = true;
    }).toList();

    // Prepare updated/new grades (unarchived)
    List<Grade> processedNewGrades = newGrades.map((e) {
      Grade? currentGrade = existingGradesMap[e.uuid];
      bool wasRevealed = true;
      if (existingGrades.isNotEmpty) {
        wasRevealed = currentGrade?.wasRevealed ?? false;
      }
      return e
        ..isArchived = false
        ..isEnabled = currentGrade?.isEnabled ?? true
        ..period.value?.schoolyear.value = this
        ..subject.value?.schoolyear.value = this
        ..period.value?.grades.add(e)
        ..subject.value?.grades.add(e)
        ..subject
            .value
            ?.periods
            .addAll([if (e.period.value != null) e.period.value!])
        ..weight = currentGrade?.weight
        ..description = currentGrade?.description
        ..testDate = currentGrade?.testDate
        ..wasRevealed = wasRevealed;
    }).toList();

    List<Grade> allGrades = [...processedNewGrades, ...missingGrades];

    // Save the internal database
    isar.writeTxnSync(() {
      isar.grades.putAllSync(allGrades);
      isar.gradePeriods.putAllSync(allGrades
          .where((g) => g.period.value != null)
          .map((e) => e.period.value!)
          .toList());
      isar.subjects.putAllSync(allGrades
          .where((g) => g.subject.value != null)
          .map((e) => e.subject.value!)
          .toList());
      grades.clear();
      grades.addAll(allGrades);
      grades.saveSync();
      periods.saveSync();
      subjects.saveSync();
    });

    // If there are new grades without a weight, the weight might be fetched
    // depending on how many new grades without weights there are.
    //
    // Currently, if there are 15 grades or less without a weight, the weights are automatically fetched.
    if (await grades
            .filter()
            .useable()
            .isArchivedEqualTo(false)
            .weightIsNull()
            .count() <=
        15) {
      List<Grade> gradesWithoutWeight = await grades
          .filter()
          .useable()
          .isArchivedEqualTo(false)
          .weightIsNull()
          .findAll();
      await Future.wait(
          [for (Grade grade in gradesWithoutWeight) grade.fill()]);
    }
  }

  /// Get Mentors
  @ignore
  Future<List<ProfileMentor>> get getMentor async =>
      List<ProfileMentor>.from((await profile.value!.account.value!.api.dio
              .get("aanmeldingen/$id/mentoren"))
          .data["items"]
          .map((x) => ProfileMentor.fromMap(x)));
}

@embedded
class Groep {
  final int? id;
  final String code;
  final String? omschrijving;

  Groep({
    this.id,
    this.code = "",
    this.omschrijving,
  });

  factory Groep.fromJson(String str) => Groep.fromMap(json.decode(str));

  factory Groep.fromMap(Map<String, dynamic> json) => Groep(
        id: json["id"] ?? json["Id"],
        code: json["code"] ??
            json["Code"] ??
            json["omschrijving"] ??
            json["Omschrijving"] ??
            "",
        omschrijving: json["omschrijving"] ?? json["Omschrijving"],
      );
}

@embedded
class Lesperiode {
  final String code;

  Lesperiode({
    this.code = "",
  });

  factory Lesperiode.fromJson(String str) =>
      Lesperiode.fromMap(json.decode(str));

  factory Lesperiode.fromMap(Map<String, dynamic> json) => Lesperiode(
        code: json["code"] ?? json["Code"] ?? "",
      );
}

@embedded
class OpleidingCode {
  final int code;
  final String omschrijving;

  OpleidingCode({
    this.code = 0,
    this.omschrijving = "",
  });

  factory OpleidingCode.fromJson(String str) =>
      OpleidingCode.fromMap(json.decode(str));

  factory OpleidingCode.fromMap(Map<String, dynamic> json) => OpleidingCode(
        code: json["code"] ?? json["Code"] ?? 0,
        omschrijving: json["omschrijving"] ?? json["Omschrijving"] ?? "",
      );
}

@embedded
class PersoonlijkeMentor {
  final String voorletters;
  final String? tussenvoegsel;
  final String achternaam;

  PersoonlijkeMentor({
    this.voorletters = "",
    this.tussenvoegsel,
    this.achternaam = "",
  });

  factory PersoonlijkeMentor.fromJson(String str) =>
      PersoonlijkeMentor.fromMap(json.decode(str));

  factory PersoonlijkeMentor.fromMap(Map<String, dynamic> json) =>
      PersoonlijkeMentor(
        voorletters: json["voorletters"] ?? json["Voorletters"] ?? "",
        tussenvoegsel: json["tussenvoegsel"] ?? json["Tussenvoegsel"],
        achternaam: json["achternaam"] ?? json["Achternaam"] ?? "",
      );
}
