import 'dart:math';

import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

class HighlightGrade {
  /// If this is null a new grade will be added.
  final int? id;
  final double? customGrade;

  /// This value should not be zero for obvious reasons
  final double? customWeight;
  HighlightGrade({
    required this.id,
    this.customGrade,
    this.customWeight,
  });
}

class GradesLineChart extends StatefulWidget {
  const GradesLineChart({
    super.key,
    required this.grades,
    this.height = 200,
    this.highlightGrade,
    this.showAverage = false,
  });

  /// The grades that the graph will be made of.
  /// When null an example will be displayed.
  final QueryBuilder<Grade, Grade, QAfterFilterCondition>? grades;

  /// Can be used to indicate where a certain grade is located in the graph
  final HighlightGrade? highlightGrade;
  final double height;
  final bool showAverage;

  @override
  State<GradesLineChart> createState() => _GradesLineChartState();
}

class _GradesLineChartState extends State<GradesLineChart> {
  List<Grade> grades = [];
  List<FlSpot> gradeSpots = [];
  List<FlSpot> averageSpots = [];
  bool showSubjectNames = false;

  late final ValueNotifier<Grade?> hoveredGrade;
  DateTime? hoveredGradeSetTime;
  Grade? lastHoveredGrade;
  late final ValueNotifier<List<TouchLineBarSpot>> _lastLineBarSpot;

  /// Keeps track of the current tooltip
  int? currentTooltipId;

  Grade? spotToGrade(int index) =>
      grades.isNotEmpty && grades.length - 1 >= index ? grades[index] : null;

  Color elevatedColor({double addElevation = 0}) =>
      ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        CardTheme.of(context).elevation == 0 && addElevation == 0
            ? 1
            : CardTheme.of(context).elevation == 0 && addElevation == 1
                ? 0
                : addElevation,
      );

  Future<bool> getData() async {
    grades = (await widget.grades?.numericalGrades
            .sortByDatumIngevoerd()
            .thenById()
            .findAll() ??
        List.generate(
          5,
          (index) {
            return Grade(
              id: index,
              cijferKolom: CijferKolom(kolomSoort: 1),
              cijferStr: (sin(index * 2) * 3 + 7).toString(),
            );
          },
        ));
    showSubjectNames = widget.grades != null &&
        !grades.every(
            (e) => e.subject.value!.id == grades.first.subject.value!.id);

    // Create points for graph
    List<Grade> exGrades = [
      ...grades,
      if (widget.highlightGrade != null &&
          widget.highlightGrade!.id == null &&
          widget.highlightGrade!.customGrade != null)
        Grade(
            id: 0,
            cijferKolom: CijferKolom(),
            cijferStr: widget.highlightGrade!.customGrade.toString(),
            weight: widget.highlightGrade?.customWeight)
    ];
    gradeSpots = exGrades
        .asMap()
        .map((index, q) => MapEntry(
            index,
            FlSpot(
                index.toDouble(),
                widget.highlightGrade?.id != null &&
                        widget.highlightGrade!.id == q.id
                    ? widget.highlightGrade!.customGrade ?? q.grade
                    : q.grade)))
        .values
        .toList();
    if (widget.showAverage) {
      averageSpots = exGrades
          .asMap()
          .map((index, q) => MapEntry(
              index,
              FlSpot(
                  index.toDouble(),
                  widget.highlightGrade?.customGrade == null
                      ? exGrades.take(index + 1).average
                      : exGrades.take(index + 1).map<double>((e) {
                            if (widget.highlightGrade?.customGrade != null &&
                                widget.highlightGrade?.id == e.id) {
                              //Custom grade
                              return widget.highlightGrade!.customGrade! *
                                  (widget.highlightGrade!.customWeight ??
                                      e.weight ??
                                      1);
                            }
                            return e.grade * (e.weight ?? 1);
                          }).sum /
                          exGrades.take(index + 1).map((e) {
                            if (widget.highlightGrade?.customWeight != null &&
                                widget.highlightGrade?.id == e.id) {
                              //Custom grade weight
                              return widget.highlightGrade!.customWeight!;
                            } else {
                              return (e.weight ?? 1);
                            }
                          }).sum)))
          .values
          .toList();
    }
    return Future.value(true);
  }

  @override
  void initState() {
    hoveredGrade = ValueNotifier(null);
    _lastLineBarSpot = ValueNotifier([]);
    super.initState();
  }

  @override
  void dispose() {
    hoveredGrade.dispose();
    _lastLineBarSpot.dispose();
    super.dispose();
  }

  LineChartBarData lineChartBarData(
          {List<FlSpot> spots = const [],
          Color? color,
          Color? onColor,
          bool drawBackground = true}) =>
      LineChartBarData(
        barWidth: 5,
        isStrokeCapRound: true,
        isStrokeJoinRound: true,
        isCurved: appSettings.curvedGraphs,
        showingIndicators: [3],
        aboveBarData: BarAreaData(
            show: drawBackground,
            applyCutOffY: true,
            cutOffY: appSettings.sufficientFrom - 0.15,
            color: elevatedColor(addElevation: 0)),
        belowBarData: BarAreaData(
            show: drawBackground,
            applyCutOffY: true,
            cutOffY: appSettings.sufficientFrom + 0.15,
            color: elevatedColor(addElevation: 0)),
        color: color ?? Theme.of(context).colorScheme.primary,
        dotData: FlDotData(
          getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
              color: color ?? Theme.of(context).colorScheme.primary,
              strokeColor: onColor ?? Theme.of(context).colorScheme.onPrimary,
              strokeWidth: 2,
              radius: 7.5),
          checkToShowDot: (spot, barData) {
            Grade? grade = spotToGrade(spot.x.toInt());
            if (widget.highlightGrade != null) {
              if (widget.highlightGrade!.id == null && grade == null) {
                //New calculated grade
                return true;
              } else if (grade != null &&
                  grade.id == widget.highlightGrade?.id) {
                //Existing grade
                return true;
              }
            }
            return false;
          },
        ),
        spots: spots,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Popup on grade hover
        CustomAnimatedSize(
          child: ValueListenableBuilder(
            valueListenable: hoveredGrade,
            builder: (context, grade, child) {
              return SizedBox(
                height: grade != null ? null : 12,
                child: Column(
                  children: grade != null
                      ? [
                          ElasticAnimation(
                            child: CustomCard(
                              key: ValueKey(grade.id),
                              margin: const EdgeInsets.all(12),
                              child: GradeTile(grade: grade),
                            ),
                          ),
                        ]
                      : [],
                ),
              );
            },
          ),
        ),

        // Graph
        SizedBox(
          height: widget.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.stackTrace);
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  if (gradeSpots.length <= 1) {
                    // No usseful information can be display in this graph,
                    // because there are too few spots.
                    return Material(
                      shape: Theme.of(context).cardTheme.shape ??
                          const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                      color: elevatedColor(addElevation: 0),
                      child: Center(
                        child: Icon(
                          Icons.auto_graph_rounded,
                          size: 32,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                      ),
                    );
                  }
                  return RepaintBoundary(
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: Theme.of(context).cardTheme.shape ??
                            const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                      ),
                      child: ClipRRect(
                        child: LineChart(
                          curve: CustomAnimatedSize.style().curve!,
                          duration: CustomAnimatedSize.style().duration!,
                          LineChartData(
                            backgroundColor: elevatedColor(addElevation: 0),
                            maxY: appSettings.zoomLineGraph
                                ? (([
                                      ...gradeSpots.map((e) => e.y),
                                      ...averageSpots.map((e) => e.y),
                                      (appSettings.sufficientFrom + .5)
                                    ].max) +
                                    1)
                                : 11,
                            minY: appSettings.zoomLineGraph
                                ? (([
                                      ...gradeSpots.map((e) => e.y),
                                      ...averageSpots.map((e) => e.y),
                                      (appSettings.sufficientFrom - .5)
                                    ].min) -
                                    1)
                                : 0,
                            gridData: FlGridData(
                              horizontalInterval: 1,
                              drawVerticalLine: false,
                              drawHorizontalLine: true,
                              checkToShowHorizontalLine: (value) =>
                                  (value - appSettings.sufficientFrom) > 1 ||
                                  (value - appSettings.sufficientFrom) < -1,
                              getDrawingHorizontalLine: (value) => FlLine(
                                  color: elevatedColor(addElevation: 1),
                                  strokeWidth: 4),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: const AxisTitles(),
                              rightTitles: const AxisTitles(),
                              topTitles: const AxisTitles(),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 30,
                                  showTitles: false,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) =>
                                      Text(meta.formattedValue),
                                ),
                              ),
                            ),
                            lineTouchData: LineTouchData(
                              touchCallback: (p0, p1) async {
                                // Haptic feedback
                                if (currentTooltipId !=
                                    p1?.lineBarSpots?.first.spotIndex) {
                                  HapticFeedback.selectionClick();
                                  currentTooltipId =
                                      p1?.lineBarSpots?.first.spotIndex;
                                  _lastLineBarSpot.value =
                                      p1?.lineBarSpots ?? [];
                                }

                                // If the user is no longer hovering over the
                                // graph we need to cancel the indicator process.
                                if ([
                                  FlPointerExitEvent,
                                  FlTapCancelEvent,
                                  FlLongPressEnd
                                ].contains(p0.runtimeType)) {
                                  lastHoveredGrade = null;
                                }

                                // When A pan starts or updates we need to set
                                // the indicator grade.
                                if ([
                                  FlPointerEnterEvent,
                                  FlPointerHoverEvent,
                                  FlLongPressMoveUpdate,
                                  FlLongPressStart,
                                  FlTapDownEvent
                                ].contains(p0.runtimeType)) {
                                  Grade? grade =
                                      p1?.lineBarSpots?.firstOrNull != null
                                          ? spotToGrade(
                                              p1!.lineBarSpots!.first.spotIndex)
                                          : null;
                                  lastHoveredGrade = grade;

                                  if (grade != null &&
                                      grade.subject.value != null) {
                                    await Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () async {
                                        // Only display the grade indicator
                                        // when the same grade is hovered for
                                        // awhile.
                                        if (lastHoveredGrade?.uuid ==
                                            grade.uuid) {
                                          hoveredGrade.value = grade;
                                          hoveredGradeSetTime = DateTime.now();

                                          // We will remove the grade after 2 seconds
                                          await Future.delayed(
                                            const Duration(seconds: 2),
                                            () {
                                              if (mounted &&
                                                  DateTime.now()
                                                          .difference(
                                                              hoveredGradeSetTime!)
                                                          .inSeconds >=
                                                      2) {
                                                hoveredGrade.value = null;
                                                _lastLineBarSpot.value = [];
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                }
                              },
                              touchSpotThreshold: 50,
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (line) => Colors.transparent,
                                tooltipHorizontalOffset: 16,
                                maxContentWidth: 0,
                                tooltipHorizontalAlignment:
                                    FLHorizontalAlignment.right,
                                tooltipPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ).copyWith(bottom: 0),
                                fitInsideHorizontally: true,
                                fitInsideVertically: true,
                                getTooltipItems: (touchedSpots) {
                                  return [
                                    for (var spot in touchedSpots)
                                      const LineTooltipItem(
                                        "",
                                        TextStyle(),
                                      )
                                  ];
                                },
                              ),
                            ),
                            lineBarsData: [
                              lineChartBarData(
                                spots: gradeSpots,
                                drawBackground: !widget.showAverage,
                              ),
                              if (widget.showAverage)
                                lineChartBarData(
                                  spots: averageSpots,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  onColor:
                                      Theme.of(context).colorScheme.onTertiary,
                                  drawBackground: false,
                                ),
                            ],
                            extraLinesData: ExtraLinesData(
                              extraLinesOnTop: false,
                              verticalLines: [
                                // if (widget.highlightGradeId != null)
                                //   VerticalLine(
                                //       color: elevatedColor(addElevation: 1),
                                //       strokeWidth: 4,
                                //       dashArray: [10, 0],
                                //       strokeCap: StrokeCap.round,
                                //       x: grades
                                //           .indexOf(grades.firstWhere(
                                //               (e) => e.id == widget.highlightGradeId))
                                //           .toDouble())
                              ],
                              horizontalLines: [
                                HorizontalLine(
                                  y: appSettings.sufficientFrom,
                                  color: appSettings.coloredsufficientFromLine
                                      ? Theme.of(context)
                                          .colorScheme
                                          .errorContainer
                                      : elevatedColor(addElevation: 1),
                                  strokeWidth: 5,
                                  dashArray: [10, 0],
                                  strokeCap: StrokeCap.round,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),

        CustomAnimatedSize(
          child: ValueListenableBuilder(
            valueListenable: hoveredGrade,
            builder: (context, grade, child) {
              return SizedBox(
                height: grade != null ? null : 12,
                child: Column(
                  children: grade != null
                      ? [
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: ElasticAnimation(
                                  child: CustomCard(
                                    key: ValueKey(grade
                                        .datumIngevoerd?.formattedDateAndTime),
                                    margin: const EdgeInsets.all(12)
                                        .copyWith(right: 0),
                                    child: ListTile(
                                      dense: true,
                                      leading: const Icon(Icons.date_range),
                                      title: Text(grade.datumIngevoerd
                                              ?.formattedDateAndTime ??
                                          ""),
                                    ),
                                  ),
                                ),
                              ),
                              CustomAnimatedSize(
                                child: IntrinsicWidth(
                                  child: ElasticAnimation(
                                    child: CustomCard(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                      key: ValueKey(_lastLineBarSpot
                                          .value.lastOrNull?.y
                                          .displayNumber()),
                                      margin: const EdgeInsets.all(12)
                                          .copyWith(left: 0),
                                      child: ListTile(
                                        dense: true,
                                        leading: Icon(
                                          Icons.trending_neutral,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiaryContainer,
                                        ),
                                        title: Text(
                                          _lastLineBarSpot.value.lastOrNull?.y
                                                  .displayNumber() ??
                                              "-",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                      : [],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// This widget should only be used with a small amount of grades.
class TransparentLineGradesChart extends StatefulWidget {
  const TransparentLineGradesChart(
      {super.key, required this.grades, this.minY = -10});

  final List<Grade> grades;
  final double minY;

  @override
  State<TransparentLineGradesChart> createState() =>
      _TransparentLineGradesChartState();
}

class _TransparentLineGradesChartState
    extends State<TransparentLineGradesChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          minY: widget.minY,
          maxY: 10,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(),
            topTitles: AxisTitles(),
            leftTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              barWidth: 5,
              isCurved: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              spots: (widget.grades.numericalGrades
                    ..sort(
                      (a, b) => a.datumIngevoerd!.microsecondsSinceEpoch
                          .compareTo(b.datumIngevoerd!.microsecondsSinceEpoch),
                    ))
                  .asMap()
                  .map(
                    (index, g) => MapEntry(
                      index,
                      FlSpot(index.toDouble(), g.grade),
                    ),
                  )
                  .values
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
