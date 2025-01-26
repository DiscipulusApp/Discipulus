import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class BarChartRoundedGrades extends StatefulWidget {
  const BarChartRoundedGrades({
    super.key,
    required this.grades,
    this.onFilterApplied,
    this.schoolyearUUID,
  });

  final QueryBuilder<Grade, Grade, QAfterFilterCondition> grades;
  final void Function()? onFilterApplied;
  final int? schoolyearUUID;

  @override
  State<BarChartRoundedGrades> createState() => _BarChartRoundedGradesState();
}

class _BarChartRoundedGradesState extends State<BarChartRoundedGrades> {
  Future<List<BarChartEntry>> getEntries() async {
    int? schoolyearUUID = widget.schoolyearUUID ??
        (await widget.grades.findFirst())?.schoolyear.value?.uuid;

    bool containsFilters(int grade) => Settings.activeGradeFilters
        .where(
          (e) =>
              e.runtimeType == RoundedGradeRangeFilter &&
              e.uuid == "$grade$schoolyearUUID".hashCode &&
              e.schoolyearUuid == schoolyearUUID,
        )
        .isNotEmpty;

    return [
      for (int grade in List.generate(10, (i) => i + 1).reversed)
        BarChartEntry(
          name: "#$grade",
          id: grade,
          valueString: (value) => "${value.toInt()}x",
          baseValue: (await widget.grades
                  .applyGradeFilter(filters: [
                    ...Settings.activeGradeFilters
                        .where((e) => e.runtimeType != RoundedGradeRangeFilter)
                  ])
                  .numericalGrades
                  .roundedGrades(grade)
                  .count())
              .toDouble(),
          color: (value) => BarChartColor(
            barColor: (grade < appSettings.sufficientFrom
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary)
                .withAlpha(!containsFilters(grade) &&
                        Settings.activeGradeFilters
                            .whereType<RoundedGradeRangeFilter>()
                            .where((e) => e.schoolyearUuid == schoolyearUUID)
                            .isNotEmpty
                    ? 255 ~/ 2
                    : 255),
            textColor: grade < appSettings.sufficientFrom
                ? Theme.of(context).colorScheme.onError
                : Theme.of(context).colorScheme.onPrimary,
          ),
          indicator: containsFilters(grade) ? Icons.filter_alt : null,
          onTap: () async {
            // When tapped a filter should be either added or removed.
            if (widget.onFilterApplied != null) {
              if (!containsFilters(grade)) {
                // This filter does not yet exist, so we are adding it
                Settings.activeGradeFilters.add(
                  RoundedGradeRangeFilter(
                    "$grade$schoolyearUUID".hashCode,
                    range: grade,
                    schoolyearUuid: schoolyearUUID,
                  ),
                );
              } else {
                // The filter does exist, so we need to remove it.
                Settings.activeGradeFilters.removeWhere(
                  (e) =>
                      e.runtimeType == RoundedGradeRangeFilter &&
                      e.uuid == "$grade$schoolyearUUID".hashCode,
                );
              }
              widget.onFilterApplied?.call();
            }
          },
        )
    ]..removeWhere((e) => e.value.isNaN || e.value == 0);
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalBarchart(
      data: getEntries,
      minValue: 0,
      maxValuePadding: 4,
      horizontalInterval: 2,
    );
  }
}
