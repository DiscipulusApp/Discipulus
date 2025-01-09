import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

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
