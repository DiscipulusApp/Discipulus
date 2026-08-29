import 'dart:math';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';

class PeriodHeatmapCard extends StatelessWidget {
  const PeriodHeatmapCard({
    super.key,
    required this.events,
  });

  final List<CalendarEvent> events;

  /// Helper to infer period (1..9) from timestamp if school does not provide lesuurVan
  int _inferPeriodFromTime(DateTime start) {
    final startMin = start.hour * 60 + start.minute;
    if (startMin < 9 * 60) return 1; // < 09:00
    if (startMin < 9 * 60 + 55) return 2; // 09:00 - 09:55
    if (startMin < 10 * 60 + 55) return 3; // 10:00 - 10:55
    if (startMin < 11 * 60 + 55) return 4; // 11:00 - 11:55
    if (startMin < 12 * 60 + 55) return 5; // 12:00 - 12:55
    if (startMin < 13 * 60 + 55) return 6; // 13:00 - 13:55
    if (startMin < 14 * 60 + 55) return 7; // 14:00 - 14:55
    if (startMin < 15 * 60 + 55) return 8; // 15:00 - 15:55
    return 9; // 16:00+
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final usableEvents = events.where((e) => !e.duurtHeleDag).toList();

    // Check if school provides explicit lesuurVan
    final bool hasExplicitPeriods =
        usableEvents.any((e) => e.lesuurVan != null && e.lesuurVan! > 0);

    // Map of (weekday: 1..5, period: 1..10) -> count of non-canceled lessons
    final Map<int, Map<int, int>> periodCounts = {
      for (int w = 1; w <= 5; w++) w: {for (int p = 1; p <= 10; p++) p: 0},
    };

    final Map<String, CalendarEvent> recentPeriodEvents = {};

    int firstPeriodTotal = 0;
    int firstPeriodCanceled = 0;
    int latePeriodCount = 0;

    int maxObservedPeriod = 7;

    for (final e in usableEvents) {
      final w = e.start.weekday;
      if (w < 1 || w > 5) continue;

      final startPeriod =
          hasExplicitPeriods ? e.lesuurVan : _inferPeriodFromTime(e.start);
      final endPeriod =
          hasExplicitPeriods ? (e.lesuurTotMet ?? startPeriod) : startPeriod;

      if (startPeriod != null && startPeriod >= 1 && startPeriod <= 10) {
        if (startPeriod > maxObservedPeriod) {
          maxObservedPeriod = startPeriod;
        }

        if (startPeriod == 1) {
          firstPeriodTotal++;
          if (e.isCanceled) firstPeriodCanceled++;
        }

        if (!e.isCanceled) {
          final maxP = min(endPeriod ?? startPeriod, 10);
          for (int p = startPeriod; p <= maxP; p++) {
            periodCounts[w]![p] = (periodCounts[w]![p] ?? 0) + 1;
            final key = "$w-$p";
            if (!recentPeriodEvents.containsKey(key) ||
                e.start.isAfter(recentPeriodEvents[key]!.start)) {
              recentPeriodEvents[key] = e;
            }
          }
        }
      }

      // Late period detection (8th period or lessons after 15:00)
      if (!e.isCanceled) {
        if ((startPeriod != null && startPeriod >= 8) ||
            e.start.hour >= 15 ||
            (e.start.hour == 14 && e.start.minute >= 45)) {
          latePeriodCount++;
        }
      }
    }

    // Clamp max period between 6 and 9 for clean display
    maxObservedPeriod = maxObservedPeriod.clamp(6, 9);

    int maxCellCount = 1;
    for (int w = 1; w <= 5; w++) {
      for (int p = 1; p <= maxObservedPeriod; p++) {
        final count = periodCounts[w]?[p] ?? 0;
        if (count > maxCellCount) maxCellCount = count;
      }
    }

    const dayLabels = ["Ma", "Di", "Wo", "Do", "Vr"];

    return CustomCard(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCard(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // Header row: Weekdays
                    TableRow(
                      children: [
                        const SizedBox(width: 24), // period label column
                        for (final label in dayLabels)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                label,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Period rows
                    for (int p = 1; p <= maxObservedPeriod; p++)
                      TableRow(
                        children: [
                          // Period number on the left
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              "${p}e",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),

                          // Day columns for this period
                          for (int w = 1; w <= 5; w++)
                            Builder(
                              builder: (context) {
                                final count = periodCounts[w]?[p] ?? 0;
                                final fraction = maxCellCount > 0
                                    ? (count / maxCellCount)
                                    : 0.0;
                                final recent = recentPeriodEvents["$w-$p"];

                                final cellColor = count > 0
                                    ? theme.colorScheme.primary.withValues(
                                        alpha: (fraction * 0.85 + 0.15)
                                            .clamp(0.0, 1.0),
                                      )
                                    : theme.colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.35);

                                final textColor = count > 0
                                    ? (fraction > 0.45
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface)
                                    : theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.4);

                                return Padding(
                                  padding: const EdgeInsets.all(2.5),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    onTap: recent != null
                                        ? () => CalendarDayView(
                                              displayedDay: recent.start,
                                            ).push(context)
                                        : null,
                                    child: Container(
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: cellColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        count > 0 ? "$count" : "—",
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            CustomCard(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1e Uur uitslapen",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            firstPeriodTotal > 0
                                ? "${(((firstPeriodTotal - firstPeriodCanceled) / firstPeriodTotal) * 100).toStringAsFixed(0)}% kans"
                                : "N.v.t.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 26,
                      color: theme.colorScheme.outlineVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Late Uren (na 15:00)",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "$latePeriodCount ${latePeriodCount == 1 ? 'uur' : 'uren'}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8),
              child: ListTile(
                dense: true,
                leading: Icon(Icons.info_outline),
                title: Text(
                  hasExplicitPeriods
                      ? "Aantal lessen per lesuur en dag."
                      : "Aantal lessen per tijdsblok (geschat op basis van starttijd). ",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
