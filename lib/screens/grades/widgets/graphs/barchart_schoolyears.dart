import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class BarChartSchoolyears extends StatefulWidget {
  const BarChartSchoolyears({
    super.key,
    required this.subject,
    this.onSelected,
  });

  final Subject subject;
  final Function(Subject subject)? onSelected;

  @override
  State<BarChartSchoolyears> createState() => _BarChartSchoolyearsState();
}

class _BarChartSchoolyearsState extends State<BarChartSchoolyears> {
  Future<List<BarChartEntry>> getEntries() async {
    List<Subject> subjects = await widget.subject.relatedSchoolyears;
    return [
      for (Subject subject in subjects
          .where((s) => s.grades.filter().numericalGrades.countSync() > 0))
        BarChartEntry(
          name: subject.schoolyear.value!.groep.code,
          id: subject.schoolyear.value!.einde.millisecondsSinceEpoch,
          baseValue: await subject.grades
              .filter()
              .useable()
              .applyGradeFilter()
              .average,
          indicator: Settings.activeGradeFilters
                  .where(
                      (e) => e.schoolyearUuid == subject.schoolyear.value?.uuid)
                  .isNotEmpty
              ? Icons.filter_alt
              : null,
          color: (value) => value < appSettings.sufficientFrom
              ? BarChartColor(
                  barColor: subject.uuid == widget.subject.uuid
                      ? Theme.of(context)
                          .colorScheme
                          .error
                          .harmonizeWith(Theme.of(context).colorScheme.tertiary)
                      : Theme.of(context).colorScheme.error,
                  textColor: subject.uuid == widget.subject.uuid
                      ? Theme.of(context).colorScheme.onTertiary
                      : Theme.of(context).colorScheme.onError,
                )
              : BarChartColor(
                  barColor: subject.uuid == widget.subject.uuid
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.primary,
                  textColor: subject.uuid == widget.subject.uuid
                      ? Theme.of(context).colorScheme.onTertiary
                      : Theme.of(context).colorScheme.onPrimary,
                ),
          onTap: () => widget.onSelected?.call(subject),
        )
    ]..sort(
        (a, b) => b.id.compareTo(a.id),
      );
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalBarchart(
      data: getEntries,
      minValue: 1,
      maxValuePadding: 2,
      horizontalInterval: 1,
      horizontalLines: [
        HorizontalLine(
          y: appSettings.sufficientFrom,
          strokeWidth: 4,
          color: Theme.of(context).colorScheme.errorContainer,
        )
      ],
    );
  }
}
