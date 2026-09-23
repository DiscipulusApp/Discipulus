import 'dart:math';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_activity_insights_card.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchoolDayEfficiencyCard extends StatelessWidget {
  const SchoolDayEfficiencyCard({
    super.key,
    required this.events,
  });

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final nonCanceledEvents =
        events.where((e) => !e.isCanceled && !e.duurtHeleDag).toList();

    // Group events by day
    final Map<DateTime, List<CalendarEvent>> eventsPerDay = {};
    for (final e in nonCanceledEvents) {
      final dayKey = e.start.dayOnly;
      eventsPerDay.putIfAbsent(dayKey, () => []).add(e);
    }

    int totalTussenuurMinutes = 0;
    int tussenuurCount = 0;
    int totalLessonMinutes = 0;
    int totalPresenceMinutes = 0;

    int maxGapMinutes = 0;
    DateTime? maxGapDay;
    CalendarEvent? gapAfterLesson;
    CalendarEvent? gapBeforeLesson;

    for (final entry in eventsPerDay.entries) {
      final dayLessons = entry.value..sort((a, b) => a.start.compareTo(b.start));
      if (dayLessons.isEmpty) continue;

      int dayLessonMinutes = 0;
      for (final l in dayLessons) {
        final dur = l.einde.difference(l.start).inMinutes;
        if (dur > 0 && dur <= 600) {
          dayLessonMinutes += dur;
        }
      }
      totalLessonMinutes += dayLessonMinutes;

      if (dayLessons.length >= 2) {
        final dayPresence =
            dayLessons.last.einde.difference(dayLessons.first.start).inMinutes;
        if (dayPresence > 0 && dayPresence <= 720) {
          totalPresenceMinutes += dayPresence;
        }

        // Calculate gaps between lessons
        for (int i = 0; i < dayLessons.length - 1; i++) {
          final current = dayLessons[i];
          final next = dayLessons[i + 1];

          if (next.start.isAfter(current.einde)) {
            final gapMinutes = next.start.difference(current.einde).inMinutes;

            // Check if there is a skipped period (lesuurVan) or if the gap is >= 40 minutes.
            // Standard small breaks (15-20 min) and lunch breaks (30 min) are ignored.
            bool isTussenuur = false;
            int missedPeriodCount = 0;

            final currentEndPeriod = current.lesuurTotMet ?? current.lesuurVan;
            final nextStartPeriod = next.lesuurVan;

            if (currentEndPeriod != null && nextStartPeriod != null) {
              if (nextStartPeriod > currentEndPeriod + 1) {
                isTussenuur = true;
                missedPeriodCount = nextStartPeriod - currentEndPeriod - 1;
              }
            } else {
              // If school doesn't use lesuurVan: gaps >= 40 min represent an unscheduled free period / tussenuur
              if (gapMinutes >= 40 && gapMinutes <= 360) {
                isTussenuur = true;
                missedPeriodCount = 1;
              }
            }

            if (isTussenuur && gapMinutes >= 35 && gapMinutes <= 360) {
              // Wasted time is the gap duration minus normal passing break (10 min)
              final effectiveWastedMinutes = max(0, gapMinutes - 10);
              totalTussenuurMinutes += effectiveWastedMinutes;
              tussenuurCount += max(1, missedPeriodCount);

              if (gapMinutes > maxGapMinutes) {
                maxGapMinutes = gapMinutes;
                maxGapDay = entry.key;
                gapAfterLesson = current;
                gapBeforeLesson = next;
              }
            }
          }
        }
      } else {
        totalPresenceMinutes += dayLessonMinutes;
      }
    }

    if (eventsPerDay.isEmpty) {
      return const SizedBox.shrink();
    }

    final double efficiency = totalPresenceMinutes > 0
        ? (totalLessonMinutes / totalPresenceMinutes) * 100
        : 100.0;
    final double totalTussenuurHours = totalTussenuurMinutes / 60.0;

    String formatGapDuration(int minutes) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (hours == 0) return "$mins min";
      if (mins == 0) return "$hours uur";
      return "$hours u $mins m";
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final tiles = [
          InsightCardItem(
            icon: Icons.hourglass_empty_rounded,
            iconColor: theme.colorScheme.primary,
            iconBackgroundColor: theme.colorScheme.primaryContainer,
            title: "Tussenuren & Wachttijd",
            value:
                "${totalTussenuurHours.toStringAsFixed(totalTussenuurHours >= 10 ? 0 : 1)} uur",
            subtitle: tussenuurCount > 0
                ? "$tussenuurCount ${tussenuurCount == 1 ? 'tussenuur' : 'tussenuren'} (excl. pauzes)"
                : "Geen tussenuren geregistreerd",
          ),
          InsightCardItem(
            icon: Icons.speed_rounded,
            iconColor: efficiency >= 80
                ? theme.colorScheme.primary
                : theme.colorScheme.tertiary,
            iconBackgroundColor: efficiency >= 80
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.tertiaryContainer,
            title: "Schooldag Efficiëntie",
            value: "${efficiency.clamp(0.0, 100.0).toStringAsFixed(1)}%",
            subtitle: "Tijd op school effectief in de les (dus ${(100 -efficiency).clamp(0.0, 100.0).toStringAsFixed(1)}% tussenuren)",
          ),
          if (maxGapMinutes > 0 && maxGapDay != null)
            InsightCardItem(
              icon: Icons.space_bar_rounded,
              iconColor: theme.colorScheme.secondary,
              iconBackgroundColor: theme.colorScheme.secondaryContainer,
              title: "Grootste Gat Ooit",
              value: formatGapDuration(maxGapMinutes),
              subtitle:
                  "${DateFormat('d MMMM yyyy', 'nl_NL').format(maxGapDay)} • tussen ${gapAfterLesson?.title.isNotEmpty == true ? gapAfterLesson!.title : 'Les'} & ${gapBeforeLesson?.title.isNotEmpty == true ? gapBeforeLesson!.title : 'Les'}",
              onTap: () => CalendarDayView(
                displayedDay: maxGapDay,
              ).push(context),
            ),
        ];

        if (isWide) {
          return Wrap(
            children: tiles.map((tile) {
              return SizedBox(
                width: constraints.maxWidth / 2,
                child: tile,
              );
            }).toList(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: tiles,
          );
        }
      },
    );
  }
}
