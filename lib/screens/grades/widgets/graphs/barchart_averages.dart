import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/grades_subject.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class BarChartAverages extends StatefulWidget {
  const BarChartAverages({
    super.key,
    required this.subjects,
    this.rounded = false,
    this.showTrend = false,
  });

  final IsarLinks<Subject> subjects;
  final bool rounded;
  final bool showTrend;

  @override
  State<BarChartAverages> createState() => _BarChartAveragesState();
}

class _BarChartAveragesState extends State<BarChartAverages> {
  BarChartEntry _buildEntry({
    Subject? subject,
    double? average,
    int? index,
    bool amountChart = false,
    double? change,
  }) {
    return BarChartEntry(
      name: subject != null ? subject.afkorting.capitalized : "###",
      id: subject?.id ?? index!,
      onTap: subject != null
          ? () => SubjectGradesScreen(subject: subject).push(context)
          : null,
      color: (value) => !amountChart && value < appSettings.sufficientFrom
          ? BarChartColor(
              barColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.onError)
          : BarChartColor(
              barColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary),
      extraValueColor: (value) => value.isNegative
          ? Theme.of(context).colorScheme.inversePrimary
          : Theme.of(context).colorScheme.error,
      baseValue: average ?? appSettings.sufficientFrom,
      extraValue: change != null ? change * -1 : null,
    );
  }

  Future<List<BarChartEntry>> getEntries() async {
    List<Subject> subjects = await widget.subjects.toList().sortSubjects();
    List<double> averages = await Future.wait([
      for (Subject subject in subjects)
        appSettings.subjectSortType == SubjectSortType.amountOfGrades
            ? Future(() async => (await subject.grades
                    .filter()
                    .useable()
                    .applyGradeFilter()
                    .count())
                .toDouble())
            : subject.grades.filter().useable().applyGradeFilter().average
    ]);
    List<GradeChange>? changes;
    if (widget.showTrend) {
      changes = await Future.wait([
        for (Subject subject in subjects)
          subject.grades.filter().applyGradeFilter().changeInAverageLastMonth()
      ]);
    }

    return [
      for (MapEntry<int, Subject> subject in subjects.asMap().entries)
        _buildEntry(
            amountChart:
                appSettings.subjectSortType == SubjectSortType.amountOfGrades,
            subject: subject.value,
            change: changes?[subject.key].change,
            average: (() {
              double average = averages[subject.key];
              if (widget.rounded) {
                return average.roundToDouble();
              } else {
                return average;
              }
            })())
    ]..removeWhere((e) => e.value.isNaN || e.value == 0);
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalBarchart(
      initialData: [
        for (int id in widget.subjects
            .filter()
            .grades(
              (q) => q.numericalGrades,
            )
            .gradesIsNotEmpty()
            .idProperty()
            .findAllSync())
          _buildEntry(index: id)
      ],
      data: getEntries,
      minValue: 1,
      maxValuePadding: 2,
      horizontalInterval: 1,
      horizontalLines: [
        if (appSettings.subjectSortType != SubjectSortType.amountOfGrades)
          HorizontalLine(
            y: appSettings.sufficientFrom,
            strokeWidth: 4,
            color: Theme.of(context).colorScheme.errorContainer,
          )
      ],
    );
  }
}
