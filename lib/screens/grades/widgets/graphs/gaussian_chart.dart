// lib/screens/grades/widgets/graphs/gaussian_curve_chart.dart
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

// Helper class to hold data for a single curve
class CurveData {
  final GaussianFunction function;
  final List<FlSpot> spots;
  final double mean;
  final double stdDev;
  final double maxY; // Max Y value *for this specific curve*
  final bool hasEnoughData;

  CurveData({
    required this.function,
    required this.spots,
    required this.mean,
    required this.stdDev,
    required this.maxY,
    required this.hasEnoughData,
  });
}

class GaussianCurveChart extends StatefulWidget {
  const GaussianCurveChart({
    super.key,
    required this.primaryGradesQuery,
    this.backgroundGradesQueries = const [], // New list for background queries
    this.height = 200,
  });

  // Renamed for clarity
  final QueryBuilder<Grade, Grade, QAfterFilterCondition> primaryGradesQuery;
  // List of queries for background curves
  final List<QueryBuilder<Grade, Grade, QAfterFilterCondition>>
      backgroundGradesQueries;
  final double height;

  @override
  State<GaussianCurveChart> createState() => _GaussianCurveChartState();
}

class _GaussianCurveChartState extends State<GaussianCurveChart> {
  CurveData? _primaryCurveData;
  List<CurveData> _backgroundCurveData = [];
  double _overallMaxY = 0.1; // Max Y across *all* curves for chart scaling

  @override
  void initState() {
    super.initState();
    _generateAllCurveData();
  }

  @override
  void didUpdateWidget(covariant GaussianCurveChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Basic check: Regenerate if the primary query object instance changes.
    // A more robust check might compare query details if possible.
    if (widget.primaryGradesQuery != oldWidget.primaryGradesQuery ||
        !listEquals(widget.backgroundGradesQueries,
            oldWidget.backgroundGradesQueries)) {
      _generateAllCurveData();
    }
  }

  // Helper function to generate data for a single query
  Future<CurveData> _generateSingleCurveData(
      QueryBuilder<Grade, Grade, QAfterFilterCondition> query) async {
    final gradesData = await query.findAll();
    final numericalGrades =
        gradesData.numericalGrades.map((g) => g.grade).toList();

    if (numericalGrades.length < 2) {
      return CurveData(
        function: (x) => 0.0,
        spots: [],
        mean: double.nan,
        stdDev: double.nan,
        maxY: 0.0,
        hasEnoughData: false,
      );
    }

    final double mean = numericalGrades.average;
    final double variance = numericalGrades.map((g) => pow(g - mean, 2)).sum /
        numericalGrades.length;
    final double standardDeviation = sqrt(variance);
    final GaussianFunction curveFunction = gradesData.generateGaussianCurve();

    List<FlSpot> curveSpots = [];
    double currentMaxY = 0.0;
    const double epsilon = 1e-9;

    // Handle zero standard deviation case within the function itself
    if (standardDeviation < epsilon) {
      // Create a spike representation
      curveSpots = [
        FlSpot(mean - epsilon * 10, 0), // Point before mean
        FlSpot(mean, 1.0), // Peak at mean (arbitrary height 1)
        FlSpot(mean + epsilon * 10, 0), // Point after mean
      ];
      currentMaxY = 1.0; // Set max Y for the spike
    } else {
      // Generate spots for the curve
      for (double x = 0.0; x <= 11.0; x += 0.1) {
        final y = curveFunction(x);
        if (x >= 0.5 && x <= 10.5) {
          curveSpots.add(FlSpot(x, y));
          if (y > currentMaxY) {
            currentMaxY = y;
          }
        }
      }
    }

    return CurveData(
      function: curveFunction,
      spots: curveSpots,
      mean: mean,
      stdDev: standardDeviation,
      maxY: currentMaxY,
      hasEnoughData: true,
    );
  }

  // Generates data for all curves (primary and background)
  Future<void> _generateAllCurveData() async {
    if (!mounted) return;

    final primaryDataFuture =
        _generateSingleCurveData(widget.primaryGradesQuery);
    final backgroundDataFutures = widget.backgroundGradesQueries
        .map((query) => _generateSingleCurveData(query))
        .toList();

    final List<CurveData> allData =
        await Future.wait([primaryDataFuture, ...backgroundDataFutures]);

    final primaryData = allData[0];
    final backgroundData = allData.sublist(1);

    // Calculate overall max Y for chart scaling, considering only valid curves
    final overallMaxYValue = allData
        .where((d) => d.hasEnoughData)
        .map((d) => d.maxY)
        .fold(0.0, (prev, element) => max(prev, element));

    if (mounted) {
      setState(() {
        _primaryCurveData = primaryData;
        _backgroundCurveData = backgroundData;
        // Add padding to the highest peak for better visualization
        _overallMaxY = overallMaxYValue > 0 ? overallMaxYValue * 1.15 : 0.1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onSurfaceVariant =
        Theme.of(context).colorScheme.onSurfaceVariant;
    final Color surfaceContainerHighest =
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final Color errorColor = Theme.of(context).colorScheme.error;

    Widget chartContent;

    if (_primaryCurveData == null || !_primaryCurveData!.hasEnoughData) {
      chartContent =
          const Center(child: Text("Not enough data for primary curve"));
    } else {
      chartContent = LineChart(
        LineChartData(
          minX: 0.5,
          maxX: 10.5,
          minY: 0,
          maxY: _overallMaxY, // Use overall max Y
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _overallMaxY / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: surfaceContainerHighest.withOpacity(0.5),
              strokeWidth: 4, // Thinner grid lines
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value >= 1 && value <= 10 && value == value.toInt()) {
                    return SideTitleWidget(
                      meta: meta,
                      space: 8.0,
                      child: Text(
                        value.toInt().toString(),
                        style: TextStyle(color: onSurfaceVariant, fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            // Tooltip only for primary curve
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.9), // Slightly opaque background
              tooltipHorizontalOffset: 10, // Adjust spacing from the spot
              maxContentWidth: 200, // Allow more width if needed
              tooltipPadding: const EdgeInsets.all(8), // Add padding
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                // This callback MUST return a list of the same length as touchedSpots.
                // Return null for spots where no tooltip should be shown.
                return touchedSpots.map((spot) {
                  // Check if this specific spot belongs to the primary curve (barIndex 0)
                  if (spot.barIndex == 0) {
                    final gradeX = spot.x;
                    final densityY = spot.y;
                    // Optionally calculate percentile or other info here
                    // String percentileText = _calculatePercentileText(gradeX);

                    return LineTooltipItem(
                      'Cijfer: ${gradeX.toStringAsFixed(1)}\n'
                      'Dichtheid: ${densityY.toStringAsFixed(3)}'
                      // '\n$percentileText', // Add percentile info if calculated
                      ,
                      TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start, // Align text left
                    );
                  } else {
                    // This spot is not on the primary curve, return null for its tooltip
                    return null;
                  }
                }).toList(); // Ensure it returns a List<LineTooltipItem?>
              },
            ),
            getTouchedSpotIndicator: (barData, spotIndexes) {
              // This function MUST return a list with the same length as spotIndexes.
              // Each element corresponds to the spot at the same index.
              // Return null if no indicator is desired for a specific spot.

              // Check if the current barData belongs to the primary curve ONCE
              final bool isPrimaryCurve = barData.color == primaryColor;

              // Map over the spotIndexes, returning either indicator data or null
              return spotIndexes.map((index) {
                if (isPrimaryCurve) {
                  // It's the primary curve, return the indicator data for this spot
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: primaryColor.withOpacity(0.5),
                      strokeWidth: 5, // Make indicator line slightly thicker
                    ),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 8, // Make dot slightly larger
                        color: primaryColor,
                        strokeWidth: 2,
                        // Use surface color for better contrast against the primary dot fill
                        strokeColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  );
                } else {
                  // It's a background curve, return null for this spot index
                  // This ensures the output list has the correct length.
                  return null;
                }
              }).toList(); // Ensure it returns a List<TouchedSpotIndicatorData?>
            },
          ),
          lineBarsData: [
            // Primary Curve
            LineChartBarData(
              spots: _primaryCurveData!.spots,
              isCurved: true,
              color: primaryColor,
              barWidth: 4, // Slightly thicker
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.3),
                    primaryColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Background Curves
            ..._backgroundCurveData.where((d) => d.hasEnoughData).map(
                  (curveData) => LineChartBarData(
                    spots: curveData.spots,
                    isCurved: true,
                    color: onSurfaceVariant.withOpacity(0.4), // Grayed out
                    barWidth: 1.5, // Thinner
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false), // No fill
                  ),
                ),
            // Line representing the mean of the primary curve
            if (_primaryCurveData!.hasEnoughData &&
                !_primaryCurveData!.stdDev.isNaN)
              LineChartBarData(
                spots: [
                  FlSpot(_primaryCurveData!.mean, 0),
                  FlSpot(_primaryCurveData!.mean, _overallMaxY)
                ],
                color: tertiaryColor.withOpacity(0.7),
                barWidth: 1,
                dashArray: [4, 4],
                dotData: const FlDotData(show: false),
              ),
            // Line representing the passing grade
            LineChartBarData(
              spots: [
                FlSpot(appSettings.sufficientFrom, 0),
                FlSpot(appSettings.sufficientFrom, _overallMaxY)
              ],
              color: errorColor.withOpacity(0.7),
              barWidth: 1,
              dashArray: [4, 4],
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
        curve: CustomAnimatedSize.style().curve!,
        duration: CustomAnimatedSize.style().duration!,
      );
    }

    return SizedBox(
      height: widget.height,
      child: chartContent,
    );
  }
}
