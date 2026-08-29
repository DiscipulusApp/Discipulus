import 'dart:math';

import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekdayHoursBarchart extends StatelessWidget {
  const WeekdayHoursBarchart({
    super.key,
    required this.dayHours,
    this.events,
  });

  /// Map of weekday (1 = Monday ... 7 = Sunday) to hours
  final Map<int, double> dayHours;

  /// Optional list of events for tap navigation
  final List<CalendarEvent>? events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const dayLabels = {
      1: "Ma",
      2: "Di",
      3: "Wo",
      4: "Do",
      5: "Vr",
      6: "Za",
      7: "Zo",
    };

    const fullDayNames = {
      1: "Maandag",
      2: "Dinsdag",
      3: "Woensdag",
      4: "Donderdag",
      5: "Vrijdag",
      6: "Zaterdag",
      7: "Zondag",
    };

    // Filter to Monday-Friday unless weekend has hours
    final weekdays = [1, 2, 3, 4, 5];
    if ((dayHours[6] ?? 0) > 0 || (dayHours[7] ?? 0) > 0) {
      weekdays.addAll([6, 7]);
    }

    final maxVal = dayHours.values.isEmpty
        ? 1.0
        : dayHours.values.reduce((a, b) => max(a, b));
    final chartMaxY = maxVal <= 0 ? 10.0 : maxVal * 1.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 4),
          child: CustomCard(
            margin: const EdgeInsets.all(4),
            child: SizedBox(
              height: 190,
              child: BarChart(
                curve: CustomAnimatedSize.style().curve ?? Curves.easeInOut,
                duration: Durations.short3,
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval:
                        max(1, (chartMaxY / 4).roundToDouble()),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: CardTheme.of(context).color,
                      strokeWidth: 4,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          final dayIndex = value.toInt();
                          final label = dayLabels[dayIndex] ?? "";
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              label,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  maxY: chartMaxY,
                  minY: 0,
                  barTouchData: BarTouchData(
                    touchCallback: (event, response) {
                      if (event is FlTapUpEvent &&
                          response?.spot?.touchedBarGroup.x != null &&
                          events != null) {
                        final dayIndex = response!.spot!.touchedBarGroup.x;
                        final dayEvents = events!
                            .where((e) =>
                                e.start.weekday == dayIndex &&
                                !e.isCanceled &&
                                !e.duurtHeleDag)
                            .toList()
                          ..sort((a, b) => b.start.compareTo(a.start));
                        final recentEvent = dayEvents.firstOrNull;
                        if (recentEvent != null) {
                          CalendarDayView(displayedDay: recentEvent.start)
                              .push(context);
                        }
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      tooltipMargin: 8,
                      getTooltipColor: (group) =>
                          theme.colorScheme.inverseSurface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final dayIndex = group.x;
                        final dayName = fullDayNames[dayIndex] ?? "";
                        final hours = rod.toY.round();
                        return BarTooltipItem(
                          "$dayName\n$hours uur",
                          TextStyle(
                            color: theme.colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  barGroups: [
                    for (final day in weekdays)
                      BarChartGroupData(
                        x: day,
                        showingTooltipIndicators: [],
                        barRods: [
                          BarChartRodData(
                            toY: dayHours[day] ?? 0.0,
                            width: 28,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 8),
          child: ListTile(
            dense: true,
            leading: Icon(Icons.info_outline),
            title: Text(
                "Verdeling van het aantal gevolgde lesuren over de dagen van de week."),
          ),
        ),
      ],
    );
  }
}
