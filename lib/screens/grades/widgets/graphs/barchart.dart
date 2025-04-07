import 'dart:math';

import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BarChartColor {
  Color barColor;
  Color textColor;

  BarChartColor({
    required this.barColor,
    required this.textColor,
  });
}

class BarChartEntry {
  /// These should be unique
  int id;

  /// The value that the bar should have
  double get value => extraValue != null && !extraValue!.isNegative
      ? baseValue + extraValue!
      : baseValue;

  /// The name that will be displayed on the side of the bar
  String name;

  /// This indicator is shown after the name.
  IconData? indicator;

  /// When set, this will be called when the bar is tapped.
  void Function()? onTap;

  /// The color of the entry. When null the primary color will be used.
  BarChartColor Function(double value)? color;

  /// The label that will be displayed at the end of the bar. When null the
  /// value will be displayed as as string.
  String Function(double value)? valueString;

  /// This will be added or removed from the current value if not null. This
  /// value will be in a different color if set
  double? extraValue;

  /// The color of the entry. When null the primary color will be used.
  Color Function(double value)? extraValueColor;

  /// The value that the bar should have
  double baseValue;

  BarChartEntry({
    required this.name,
    this.indicator,
    this.onTap,
    required this.id,
    required this.baseValue,
    this.color,
    this.valueString,
    this.extraValue,
    this.extraValueColor,
  });
}

class HorizontalBarchart extends StatefulWidget {
  const HorizontalBarchart({
    super.key,
    this.minValue,
    this.maxValue,
    required this.data,
    this.initialData,
    this.maxValuePadding,
    this.horizontalInterval = 1,
    this.horizontalLines = const [],
  });

  /// The minimum value of the graph. When this is null the minimum value will
  /// be used instead.
  final double? minValue;

  /// The maximum value of the graph. When this is null the maximum value will
  /// be used instead.
  final double? maxValue;

  /// This will add extra padding to the graph. Also, when this is set the graph
  /// will still be dynamic in size, but it will use the min max as a clamp.
  final double? maxValuePadding;

  /// The interval between two lines
  final double horizontalInterval;

  // Extra horizontal lines can be added. These will be drawn behind the bars.
  final List<HorizontalLine> horizontalLines;

  final Future<List<BarChartEntry>> Function() data;
  final List<BarChartEntry>? initialData;

  @override
  State<HorizontalBarchart> createState() => _HorizontalBarchartState();
}

class _HorizontalBarchartState extends State<HorizontalBarchart> {
  late final ValueNotifier<double> calculatedHeight;
  void setCalculatedHeight() {
    if (entries.isEmpty) {
      calculatedHeight.value = 200;
    } else {
      calculatedHeight.value = entries.length * 24 // each bar is 24dp
          + // we want al least 16dp in between the bars plus the sides
          16 * (entries.length + 1);
    }
  }

  @override
  initState() {
    calculatedHeight = ValueNotifier(200);
    if (widget.initialData != null) {
      entries = widget.initialData!;
      setCalculatedHeight();
    }
    super.initState();
  }

  @override
  dispose() {
    calculatedHeight.dispose();
    super.dispose();
  }

  List<BarChartEntry> entries = [];

  BarChartEntry indexToEntry(int id) => entries.firstWhere(
        (e) => e.id == id,
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() async {
        entries = await widget.data();
        setCalculatedHeight();
        return Future.value(true);
      }),
      builder: (context, snapshot) {
        return CustomAnimatedSize(
          child: ValueListenableBuilder(
            valueListenable: calculatedHeight,
            builder: (context, height, child) {
              // Graphs do not have a height, so we need to enforce one ourselves
              Widget parent(Widget child) => SizedBox(
                    height: height,
                    child: child,
                  );

              if (snapshot.hasData ||
                  (snapshot.connectionState == ConnectionState.waiting &&
                      widget.initialData != null)) {
                // Data loaded successfully, or initial data has been provided.
                return parent(
                  CustomCard(
                    child: _graphBuilder(),
                  ),
                );
              } else if (snapshot.hasError) {
                // An error occurred loading the data
                if (kDebugMode) print(snapshot.stackTrace);
                return parent(Text(snapshot.error.toString()));
              }
              return parent(const Center(child: CircularProgressIndicator()));
            },
          ),
        );
      },
    );
  }

  Widget _graphBuilder() {
    if (entries.isEmpty) {
      // When there is nothing to display, we will display a placeholder.
      return Center(
        child: Icon(
          Icons.bar_chart_rounded,
          size: 32,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      );
    } else {
      return RepaintBoundary(
        child: RotatedBox(
          quarterTurns: 1,
          child: BarChart(
            curve: CustomAnimatedSize.style().curve!,
            duration: Durations.short3,
            BarChartData(
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                horizontalInterval: widget.horizontalInterval,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: CardTheme.of(context).color,
                  strokeWidth: 4,
                ),
              ),
              extraLinesData: ExtraLinesData(
                extraLinesOnTop: false,
                horizontalLines: widget.horizontalLines,
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 72,
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (id, meta) => CustomSideTile(
                      // key: ValueKey(id),
                      indexToEntry(id.toInt()),
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                leftTitles: const AxisTitles(),
              ),
              maxY: widget.maxValuePadding != null || widget.maxValue == null
                  ? (entries
                              .map((e) => e.extraValue != null &&
                                      e.extraValue!.abs() > 0.05
                                  ? e.value + 1
                                  : e.value)
                              .reduce((value, element) => max(value, element))
                              .toDouble() +
                          (widget.maxValuePadding ?? 0))
                      .clamp(
                      widget.minValue ?? double.infinity,
                      widget.maxValue ?? double.infinity,
                    )
                  : widget.maxValue,
              minY: widget.minValue ??
                  entries
                      .map((e) => e.value)
                      .reduce((value, element) => min(value, element))
                      .toDouble(),
              barTouchData: BarTouchData(
                touchCallback: (p0, p1) async {
                  if (p0 is FlTapUpEvent &&
                      p1?.spot?.touchedBarGroup.x != null) {
                    indexToEntry(p1!.spot!.touchedBarGroup.x).onTap?.call();
                  }
                },
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: false,
                  fitInsideVertically: true,
                  tooltipMargin: 10,
                  tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                  tooltipPadding: EdgeInsets.zero,
                  rotateAngle: -90,
                  getTooltipColor: (line) => Colors.transparent,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    BarChartEntry entry = indexToEntry(group.x);

                    return BarTooltipItem(
                      [
                        entry.valueString?.call(entry.baseValue) ??
                            (entry.baseValue).displayNumber(),

                        // If there is a change that is bigger than 0.1 rounded
                        // add it to the tooltip.
                        if (entry.extraValue != null &&
                            entry.extraValue!.abs() > 0.05)
                          " (${entry.extraValue!.isNegative ? "+" : ""}${(entry.extraValue! * -1).displayNumber(decimalDigits: 1)})"
                      ].join(""),
                      TextStyle(
                        color: rod.color,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              barGroups: [
                for (var entry in entries)
                  BarChartGroupData(
                    x: entry.id,
                    showingTooltipIndicators: [0],
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        width: 24,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        color: entry.color?.call(entry.baseValue).barColor ??
                            Theme.of(context).colorScheme.primary,
                        rodStackItems: [
                          if (entry.extraValue != null)
                            BarChartRodStackItem(
                              entry.extraValue!.isNegative
                                  ? entry.baseValue + entry.extraValue!
                                  : entry.baseValue,
                              entry.extraValue!.isNegative
                                  ? entry.baseValue
                                  : entry.baseValue + entry.extraValue!,
                              entry.extraValueColor?.call(entry.extraValue!) ??
                                  entry.color?.call(entry.baseValue).barColor ??
                                  Theme.of(context).colorScheme.primary,
                            )
                        ],
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    }
  }
}

class CustomSideTile extends StatelessWidget {
  const CustomSideTile(this.entry, {super.key});

  final BarChartEntry entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: entry.onTap,
      child: SideTitleWidget(
        meta: TitleMeta(
          min: 5,
          max: 50,
          parentAxisSize: 10,
          axisPosition: 0,
          appliedInterval: 0,
          sideTitles: SideTitles(),
          formattedValue: "",
          axisSide: AxisSide.bottom,
          rotationQuarterTurns: 1,
        ),
        // axisSide: AxisSide.bottom,
        space: 0,
        fitInside: SideTitleFitInsideData.disable(),
        child: AnimatedContainer(
          curve: CustomAnimatedSize.style().curve!,
          duration: Durations.short3,
          height: 24,
          alignment: Alignment.centerLeft,
          color: entry.color?.call(entry.baseValue).barColor ??
              Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: EdgeInsets.only(left: entry.indicator != null ? 4 : 8),
            child: CustomAnimatedSize(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (entry.indicator != null)
                  Icon(
                    entry.indicator,
                    color: entry.color?.call(entry.baseValue).textColor ??
                        Theme.of(context).colorScheme.onPrimary,
                    size: 18,
                  ),
                ElasticAnimation(
                  child: Text(
                    key: ValueKey(entry.name),
                    entry.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: entry.color?.call(entry.baseValue).textColor ??
                          Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
