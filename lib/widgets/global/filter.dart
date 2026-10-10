import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

abstract class CalendarFilter {
  final int uuid;

  /// If this value is set, the filter will only work when a certain schoolyear is active.
  final int? schoolyearUuid;
  CalendarFilter(this.uuid, {this.schoolyearUuid});
}

class CalendarTeacherFilter extends CalendarFilter {
  CalendarTeacherFilter(
    super.uuid, {
    required this.name,
    this.code,
    super.schoolyearUuid,
  });

  final String name;
  final String? code;
}

class CalendarSubjectFilter extends CalendarFilter {
  CalendarSubjectFilter(super.uuid, {super.schoolyearUuid});
}

class CalendarClassroomFilter extends CalendarFilter {
  CalendarClassroomFilter(
    super.uuid, {
    required this.classroom,
    super.schoolyearUuid,
  });

  final String classroom;
}

class CalendarInfoTypeFilter extends CalendarFilter {
  CalendarInfoTypeFilter(
    super.uuid, {
    required this.infoType,
    this.name,
    super.schoolyearUuid,
  });

  final InfoType infoType;
  final String? name;
}

extension CalendarFilterExtension
    on QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition> {
  QueryBuilder<CalendarEvent, CalendarEvent, QAfterFilterCondition>
      applyCalendarFilter({
    List<CalendarFilter>? filters,
    int? schoolyearUuid,
  }) {
    List<CalendarFilter> activeFilters = [
      ...(filters ?? Settings.activeCalendarFilters),
    ];

    if (schoolyearUuid != null) {
      activeFilters.removeWhere(
        (f) => f.schoolyearUuid != null && f.schoolyearUuid != schoolyearUuid,
      );
    }

    return optional(
      activeFilters.any((e) => e is CalendarTeacherFilter),
      (q) => q.anyOf(
        activeFilters.whereType<CalendarTeacherFilter>(),
        (q, element) => q.docentenElement(
          (q) => q.naamEqualTo(element.name).optional(element.code != null,
              (q) => q.or().docentcodeEqualTo(element.code)),
        ),
      ),
    );
  }
}

extension CalendarEventListFilterExtension on Iterable<CalendarEvent> {
  List<CalendarEvent> applyCalendarFilter({
    List<CalendarFilter>? filters,
    int? schoolyearUuid,
  }) {
    List<CalendarFilter> activeFilters = [
      ...(filters ?? Settings.activeCalendarFilters),
    ];

    if (schoolyearUuid != null) {
      activeFilters.removeWhere(
        (f) => f.schoolyearUuid != null && f.schoolyearUuid != schoolyearUuid,
      );
    }

    if (activeFilters.isEmpty) return toList();

    final teacherFilters =
        activeFilters.whereType<CalendarTeacherFilter>().toList();
    final classroomFilters =
        activeFilters.whereType<CalendarClassroomFilter>().toList();
    final infoTypeFilters =
        activeFilters.whereType<CalendarInfoTypeFilter>().toList();

    return where((event) {
      // 1. Teacher match (OR within category)
      if (teacherFilters.isNotEmpty) {
        final docenten = event.docenten ?? [];
        final matches = teacherFilters.any((tf) {
          final tfName = tf.name.trim().toLowerCase();
          final tfCode = tf.code?.trim().toLowerCase();

          // Check in docenten list
          final inDocenten = docenten.any((d) {
            final dNaam = d.naam?.trim().toLowerCase();
            final dCode = d.docentcode?.trim().toLowerCase();
            if (dNaam != null &&
                (dNaam == tfName ||
                    dNaam.contains(tfName) ||
                    tfName.contains(dNaam))) {
              return true;
            }
            if (tfCode != null && dCode != null && dCode == tfCode) {
              return true;
            }
            if (dCode != null &&
                (dCode == tfName ||
                    tfCode == dNaam ||
                    dCode.contains(tfName))) {
              return true;
            }
            return false;
          });
          if (inDocenten) return true;

          // Check in event.omschrijving (e.g. "WI - LOO - 101")
          if (event.omschrijving != null) {
            final parts =
                event.omschrijving!.toLowerCase().split(RegExp(r'[\s\-/,()]+'));
            if (parts.contains(tfName) ||
                (tfCode != null && parts.contains(tfCode))) {
              return true;
            }
          }
          return false;
        });
        if (!matches) return false;
      }

      // 2. Classroom match (OR within category)
      if (classroomFilters.isNotEmpty) {
        final matches = classroomFilters.any((cf) {
          final target = cf.classroom.trim().toLowerCase();
          if (event.lokatie != null) {
            final parts = event.lokatie!.toLowerCase().split(RegExp(r'[,/ ]+'));
            if (parts.contains(target) ||
                event.lokatie!.trim().toLowerCase() == target) {
              return true;
            }
          }
          if (event.rawLokatie != null) {
            final parts =
                event.rawLokatie!.toLowerCase().split(RegExp(r'[,/ ]+'));
            if (parts.contains(target) ||
                event.rawLokatie!.trim().toLowerCase() == target) {
              return true;
            }
          }
          if (event.lokalen != null) {
            if (event.lokalen!
                .any((l) => l.naam?.trim().toLowerCase() == target)) {
              return true;
            }
          }
          if (event.omschrijving != null) {
            final parts =
                event.omschrijving!.toLowerCase().split(RegExp(r'[\s\-/,()]+'));
            if (parts.contains(target)) return true;
          }
          return false;
        });
        if (!matches) return false;
      }

      // 3. Infotype match (OR within category)
      if (infoTypeFilters.isNotEmpty) {
        final matches =
            infoTypeFilters.any((itf) => itf.infoType == event.infoType);
        if (!matches) return false;
      }

      return true;
    }).toList();
  }
}

abstract class GradeFilter {
  final int uuid;

  ///If this value is set, the filter will only work when a certain schoolyear is active.
  final int? schoolyearUuid;
  GradeFilter(this.uuid, {this.schoolyearUuid});
}

class PeriodFilter extends GradeFilter {
  PeriodFilter(super.uuid, {super.schoolyearUuid});
}

class SubjectFilter extends GradeFilter {
  SubjectFilter(super.uuid, {super.schoolyearUuid});
}

class TeacherFilter extends GradeFilter {
  TeacherFilter(super.uuid, {required this.shortName, super.schoolyearUuid});

  String shortName;
}

class RoundedGradeRangeFilter extends GradeFilter {
  RoundedGradeRangeFilter(
    super.uuid, {
    required this.range,
    super.schoolyearUuid,
  });

  /// The range of a grade when it is rounded
  int range;
}

class GradeDateRangeFilter extends GradeFilter {
  GradeDateRangeFilter(super.uuid, {required this.range, super.schoolyearUuid});

  DateTimeRange range;
}

extension GradeFilterExtension
    on QueryBuilder<Grade, Grade, QAfterFilterCondition> {
  /// Applies the active filter. If no list of filters is provided it will
  /// use the filters from the [Settings] object.
  ///
  /// The Order of the filter is as follows:
  /// 1. Periods
  /// 2. Subjects
  /// 3. Teachers
  /// 4. Dates
  ///
  QueryBuilder<Grade, Grade, QAfterFilterCondition> applyGradeFilter(
      {List<GradeFilter>? filters,
      List<GradeFilter>? forceAddFilters,
      bool singleSchoolyear = true}) {
    // If no grades are present, do nothing.
    if (countSync() == 0) return this;

    // Get the correct filters and, because sometimes a filter needs to be forced,
    // add those aswell.
    List<GradeFilter> activeFilters = [
      ...(filters ?? Settings.activeGradeFilters),

      // Forced filters are only added if there are other active filters.
      if (forceAddFilters != null &&
          (filters ??
                  Settings.activeGradeFilters.where((e) =>
                      !singleSchoolyear ||
                      singleSchoolyear &&
                          e.schoolyearUuid ==
                              findFirstSync()?.schoolyear.value!.uuid))
              .isNotEmpty)
        ...forceAddFilters
    ];

    if (singleSchoolyear) {
      // Filters that should only be active on other schoolyears are ignored
      activeFilters.removeWhere((f) =>
          f.schoolyearUuid != null &&
          f.schoolyearUuid != findFirstSync()?.schoolyear.value?.uuid);
    }

    return
        // Filter for periods
        optional(
                activeFilters.any((e) => e is PeriodFilter),
                (q) => q.period(
                      (q) => q.anyOf(activeFilters.whereType<PeriodFilter>(),
                          (q, element) => q.uuidEqualTo(element.uuid)),
                    ))
            // Filter for subjects
            .optional(
                activeFilters.any((e) => e is SubjectFilter),
                (q) => q.subject(
                      (q) => q.anyOf(activeFilters.whereType<SubjectFilter>(),
                          (q, element) => q.uuidEqualTo(element.uuid)),
                    ))
            // Filter for teachers
            .optional(
              activeFilters.any((e) => e is TeacherFilter),
              (q) => q.anyOf(activeFilters.whereType<TeacherFilter>(),
                  (q, element) => q.docentEqualTo(element.shortName)),
            )
            // Filter for rounded grades
            .optional(
              activeFilters.any((e) => e is RoundedGradeRangeFilter),
              (q) => q.anyOf(activeFilters.whereType<RoundedGradeRangeFilter>(),
                  (q, element) => q.roundedGrades(element.range)),
            )
            // Filter for dateRanges
            .optional(
              activeFilters.any((e) => e is GradeDateRangeFilter),
              (q) => q.anyOf(
                  activeFilters.whereType<GradeDateRangeFilter>(),
                  (q, element) => q.datumIngevoerdBetween(
                      element.range.start, element.range.end)),
            );
  }
}
