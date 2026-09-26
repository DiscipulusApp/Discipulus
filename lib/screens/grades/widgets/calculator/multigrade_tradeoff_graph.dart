import 'dart:math';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'grade_calculator_models.dart';

class MultigradeTradeoffGraph extends StatefulWidget {
  final LinearTradeoffEquation equation;
  final double height;
  final ValueChanged<Offset?>? onSelectedPoint;

  const MultigradeTradeoffGraph({
    super.key,
    required this.equation,
    this.height = 220,
    this.onSelectedPoint,
  });

  @override
  State<MultigradeTradeoffGraph> createState() =>
      _MultigradeTradeoffGraphState();
}

class _MultigradeTradeoffGraphState extends State<MultigradeTradeoffGraph> {
  Offset? _inspectPoint;
  bool _isHovering = false;

  @override
  void didUpdateWidget(covariant MultigradeTradeoffGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.equation != oldWidget.equation && _inspectPoint != null) {
      final newG2 = widget.equation.solveG2(_inspectPoint!.dx);
      if (newG2 == null || newG2 < 1 || newG2 > 10) {
        _inspectPoint = null;
      } else {
        _inspectPoint = Offset(
          _inspectPoint!.dx,
          double.parse(newG2.toStringAsFixed(1)),
        );
      }
    }
  }

  /// Background color aligned with Discipulus card elevation overlay.
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

  List<FlSpot> _generateTradeoffSpots() {
    if (!widget.equation.isValid || widget.equation.isImpossible) {
      return [];
    }
    if (widget.equation.isTriviallySatisfied) {
      return [const FlSpot(0, 0), const FlSpot(10, 0)];
    }

    final double xMin = max(
      0.0,
      (widget.equation.requiredSum - (10.0 * widget.equation.w2)) /
          widget.equation.w1,
    );
    final double xMax = min(
      10.0,
      widget.equation.requiredSum / widget.equation.w1,
    );

    if (xMin > xMax) return [];

    final List<FlSpot> spots = [];
    const int steps = 50;
    for (int i = 0; i <= steps; i++) {
      final double x = xMin + (xMax - xMin) * (i / steps);
      final double? y = widget.equation.solveG2(x);
      if (y != null) {
        spots.add(FlSpot(
          double.parse(x.toStringAsFixed(2)),
          double.parse(y.clamp(0.0, 10.0).toStringAsFixed(2)),
        ));
      }
    }
    return spots;
  }

  List<FlSpot> _generateFeasibleAreaSpots(List<FlSpot> tradeoffSpots) {
    if (tradeoffSpots.isEmpty) return [];
    if (widget.equation.isTriviallySatisfied) {
      return [const FlSpot(0, 0), const FlSpot(10, 0)];
    }

    final List<FlSpot> areaSpots = List.from(tradeoffSpots);
    final lastSpot = tradeoffSpots.last;
    if (lastSpot.x < 10.0) {
      areaSpots.add(const FlSpot(10.0, 0.0));
    }
    return areaSpots;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Handle invalid or impossible target scenarios with standard empty/warning card
    if (!widget.equation.isValid || widget.equation.isImpossible) {
      return SizedBox(
        height: widget.height,
        child: Material(
          shape: theme.cardTheme.shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
          color: elevatedColor(addElevation: 0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 32,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.equation.isImpossible
                      ? 'Niet haalbaar met cijfers ≤ 10'
                      : 'Voer geldige wegingen in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final tradeoffSpots = _generateTradeoffSpots();
    final feasibleAreaSpots = _generateFeasibleAreaSpots(tradeoffSpots);

    return SizedBox(
      height: widget.height,
      child: RepaintBoundary(
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: theme.cardTheme.shape ??
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
          ),
          child: ClipRRect(
            child: LineChart(
              curve: CustomAnimatedSize.style().curve ?? Curves.easeInOut,
              duration: CustomAnimatedSize.style().duration ??
                  const Duration(milliseconds: 250),
              LineChartData(
                backgroundColor: elevatedColor(addElevation: 0),
                minX: 1,
                maxX: 10,
                minY: 1,
                maxY: 10,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: appSettings.pietjePrecies
                        ? theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.4)
                        : elevatedColor(addElevation: 1),
                    strokeWidth: appSettings.pietjePrecies ? 1 : 4,
                    dashArray: appSettings.pietjePrecies ? [4, 4] : null,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: appSettings.pietjePrecies
                        ? theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.4)
                        : elevatedColor(addElevation: 1),
                    strokeWidth: appSettings.pietjePrecies ? 1 : 4,
                    dashArray: appSettings.pietjePrecies ? [4, 4] : null,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitleAlignment: appSettings.pietjePrecies ? SideTitleAlignment.outside : SideTitleAlignment.inside,
                    axisNameWidget: Text(
                      'Cijfer 2',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    axisNameSize: 16,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      maxIncluded: appSettings.pietjePrecies,
                      minIncluded: appSettings.pietjePrecies,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 &&
                            value <= 10 &&
                            value == value.roundToDouble()) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitleAlignment: appSettings.pietjePrecies ? SideTitleAlignment.outside : SideTitleAlignment.inside,
                    axisNameWidget: Text(
                      'Cijfer 1',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    axisNameSize: 16,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      maxIncluded: appSettings.pietjePrecies,
                      minIncluded: appSettings.pietjePrecies,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 &&
                            value <= 10 &&
                            value == value.roundToDouble()) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  extraLinesOnTop: false,
                  horizontalLines: [
                    HorizontalLine(
                      y: appSettings.sufficientFrom,
                      color: appSettings.coloredsufficientFromLine
                          ? theme.colorScheme.error.withValues(alpha: 0.7)
                          : theme.colorScheme.outlineVariant,
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                    ),
                  ],
                  verticalLines: [
                    VerticalLine(
                      x: appSettings.sufficientFrom,
                      color: appSettings.coloredsufficientFromLine
                          ? theme.colorScheme.error.withValues(alpha: 0.7)
                          : theme.colorScheme.outlineVariant,
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                    ),
                  ],
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchSpotThreshold: 60,
                  touchCallback: (event, touchResponse) {
                    final isEndEvent = [
                      FlPointerExitEvent,
                      FlTapCancelEvent,
                      FlTapUpEvent,
                      FlLongPressEnd,
                      FlPanEndEvent,
                    ].contains(event.runtimeType);
    
                    final hasSpots = touchResponse?.lineBarSpots != null &&
                        touchResponse!.lineBarSpots!.isNotEmpty;
    
                    if (isEndEvent || !hasSpots) {
                      if (_isHovering) {
                        setState(() => _isHovering = false);
                      }
                      return;
                    }
    
                    final spot = touchResponse.lineBarSpots!.firstWhere(
                      (s) => s.bar.barWidth > 0,
                      orElse: () => touchResponse.lineBarSpots!.first,
                    );
                    final newPoint = Offset(
                      double.parse(spot.x.toStringAsFixed(1)),
                      double.parse(spot.y.toStringAsFixed(1)),
                    );
    
                    final shouldUpdateInspectPoint =
                        _inspectPoint != newPoint;
                    final shouldUpdateHover = !_isHovering;
    
                    if (shouldUpdateHover || shouldUpdateInspectPoint) {
                      if (shouldUpdateInspectPoint) {
                        HapticFeedback.selectionClick();
                        widget.onSelectedPoint?.call(newPoint);
                      }
                      setState(() {
                        _isHovering = true;
                        if (shouldUpdateInspectPoint) {
                          _inspectPoint = newPoint;
                        }
                      });
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => theme
                        .colorScheme.secondaryContainer
                        .withValues(alpha: 0.95),
                    tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        if (spot.bar.barWidth == 0) {
                          return null;
                        }
                        final g1 = spot.x;
                        final g2 = spot.y;
                        final avg =
                            widget.equation.calculateAverage(g1, g2);
                        return LineTooltipItem(
                          'Cijfer 1: ${g1.toStringAsFixed(1)}\nCijfer 2: ${g2.toStringAsFixed(1)}\n'
                          'Gemiddelde: ${avg.toStringAsFixed(2)}',
                          TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    // Only draw the touch indicator on the trade-off line itself (barWidth > 0)
                    if (barData.barWidth == 0) {
                      return spotIndexes.map((_) => null).toList();
                    }
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: colorScheme.primary.withValues(alpha: 0.4),
                          strokeWidth: 2,
                          dashArray: [4, 4],
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 6,
                            color: colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: feasibleAreaSpots,
                    barWidth: 0,
                    color: Colors.transparent,
                    dotData: const FlDotData(show: false),
                    aboveBarData: BarAreaData(
                      show: true,
                      applyCutOffY: true,
                      cutOffY: 10,
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  LineChartBarData(
                    spots: tradeoffSpots,
                    isCurved: false,
                    color: colorScheme.primary,
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  if (_inspectPoint != null && !_isHovering)
                    LineChartBarData(
                      spots: [FlSpot(_inspectPoint!.dx, _inspectPoint!.dy)],
                      barWidth: 0,
                      color: Colors.transparent,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 6,
                          color: colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
