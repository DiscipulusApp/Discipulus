import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_activity_insights_card.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleExtremesCard extends StatelessWidget {
  const ScheduleExtremesCard({
    super.key,
    required this.events,
  });

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final nonCanceledEvents =
        events.where((e) => !e.isCanceled && !e.duurtHeleDag).toList();

    // 1. Maandagochtend Uitslaap-Loterij
    final Map<DateTime, List<CalendarEvent>> mondayEvents = {};
    for (final e in events.where((e) => e.start.weekday == DateTime.monday && !e.duurtHeleDag)) {
      mondayEvents.putIfAbsent(e.start.dayOnly, () => []).add(e);
    }

    int totalMondays = mondayEvents.length;
    int uitslaapMondays = 0;
    for (final dayEvents in mondayEvents.values) {
      final firstLesson = dayEvents.sortedBy((e) => e.start).firstOrNull;
      if (firstLesson == null) continue;
      // If the very first lesson on Monday was canceled OR started after 09:00
      if (firstLesson.isCanceled ||
          firstLesson.start.hour > 9 ||
          (firstLesson.start.hour == 9 && firstLesson.start.minute >= 0)) {
        uitslaapMondays++;
      }
    }
    final double uitslaapKans =
        totalMondays > 0 ? (uitslaapMondays / totalMondays) * 100 : 0.0;

    // 2. Gemiddelde start- en eindtijd per weekdag
    final Map<int, List<int>> weekdayStartMinutes = {for (int i = 1; i <= 5; i++) i: []};
    final Map<int, List<int>> weekdayEndMinutes = {for (int i = 1; i <= 5; i++) i: []};

    final Map<DateTime, List<CalendarEvent>> dayEventsMap = {};
    for (final e in nonCanceledEvents) {
      dayEventsMap.putIfAbsent(e.start.dayOnly, () => []).add(e);
    }

    for (final dayLessons in dayEventsMap.values) {
      if (dayLessons.isEmpty) continue;
      final w = dayLessons.first.start.weekday;
      if (w < 1 || w > 5) continue;

      final sorted = dayLessons..sort((a, b) => a.start.compareTo(b.start));
      weekdayStartMinutes[w]!.add(sorted.first.start.hour * 60 + sorted.first.start.minute);
      weekdayEndMinutes[w]!.add(sorted.last.einde.hour * 60 + sorted.last.einde.minute);
    }

    // 3. Extremen: Vroegste les & Laatste les
    CalendarEvent? earliestLesson;
    CalendarEvent? latestLesson;

    int earliestTimeMinute = 24 * 60;
    int latestTimeMinute = 0;

    for (final e in nonCanceledEvents) {
      final startMin = e.start.hour * 60 + e.start.minute;
      final endMin = e.einde.hour * 60 + e.einde.minute;

      if (startMin < earliestTimeMinute && startMin >= 6 * 60) {
        earliestTimeMinute = startMin;
        earliestLesson = e;
      }
      if (endMin > latestTimeMinute && endMin <= 22 * 60) {
        latestTimeMinute = endMin;
        latestLesson = e;
      }
    }

    // 4. Grootste Uitvaldag Ooit
    final Map<DateTime, double> canceledHoursPerDay = {};
    final Map<DateTime, int> canceledCountPerDay = {};
    for (final e in events.where((e) => e.isCanceled && !e.duurtHeleDag)) {
      final dayKey = e.start.dayOnly;
      final diff = e.einde.difference(e.start).inMinutes;
      if (diff > 0 && diff <= 600) {
        canceledHoursPerDay[dayKey] = (canceledHoursPerDay[dayKey] ?? 0.0) + (diff / 60.0);
        canceledCountPerDay[dayKey] = (canceledCountPerDay[dayKey] ?? 0) + 1;
      }
    }

    DateTime? maxCanceledDay;
    double maxCanceledHours = 0.0;
    for (final entry in canceledHoursPerDay.entries) {
      if (entry.value > maxCanceledHours) {
        maxCanceledHours = entry.value;
        maxCanceledDay = entry.key;
      }
    }

    String formatTimeFromMinutes(int mins) {
      final h = mins ~/ 60;
      final m = mins % 60;
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
    }

    const dayShortNames = {1: "Ma", 2: "Di", 3: "Wo", 4: "Do", 5: "Vr"};

    final tiles = <Widget>[
      InsightCardItem(
        icon: Icons.bedtime_outlined,
        iconColor: theme.colorScheme.tertiary,
        iconBackgroundColor: theme.colorScheme.tertiaryContainer,
        title: "Maandag Uitslaap-Loterij",
        value: "${uitslaapKans.toStringAsFixed(1)}% kans",
        subtitle: "$uitslaapMondays van $totalMondays maandagen vrij 1e uur",
      ),
      if (maxCanceledDay != null && maxCanceledHours > 0)
        InsightCardItem(
          icon: Icons.celebration_outlined,
          iconColor: theme.colorScheme.error,
          iconBackgroundColor: theme.colorScheme.errorContainer,
          title: "Grootste Uitvaldag Ooit",
          value:
              "${maxCanceledHours.toStringAsFixed(maxCanceledHours == maxCanceledHours.roundToDouble() ? 0 : 1)} uur uitval",
          subtitle:
              "${DateFormat('d MMMM yyyy', 'nl_NL').format(maxCanceledDay)} (${canceledCountPerDay[maxCanceledDay]} lessen)",
          onTap: () => CalendarDayView(
            displayedDay: maxCanceledDay,
          ).push(context),
        ),
      if (earliestLesson != null)
        InsightCardItem(
          icon: Icons.wb_sunny_outlined,
          iconColor: theme.colorScheme.primary,
          iconBackgroundColor: theme.colorScheme.primaryContainer,
          title: "Vroegste les ooit",
          value: DateFormat('HH:mm').format(earliestLesson.start),
          subtitle:
              "${DateFormat('d MMMM yyyy', 'nl_NL').format(earliestLesson.start)} • ${earliestLesson.title.isNotEmpty ? earliestLesson.title : 'Les'}",
          onTap: () => CalendarDayView(
            displayedDay: earliestLesson!.start,
          ).push(context),
        ),
      if (latestLesson != null)
        InsightCardItem(
          icon: Icons.nightlight_outlined,
          iconColor: theme.colorScheme.secondary,
          iconBackgroundColor: theme.colorScheme.secondaryContainer,
          title: "Laatste les ooit",
          value: DateFormat('HH:mm').format(latestLesson.einde),
          subtitle:
              "${DateFormat('d MMMM yyyy', 'nl_NL').format(latestLesson.einde)} • ${latestLesson.title.isNotEmpty ? latestLesson.title : 'Les'}",
          onTap: () => CalendarDayView(
            displayedDay: latestLesson!.einde,
          ).push(context),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Average start and end times per weekday card
        CustomCard(
          margin: const EdgeInsets.all(4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (int w = 1; w <= 5; w++) ...[
                      Expanded(
                        child: CustomCard(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                            child: Column(
                              children: [
                                Text(
                                  dayShortNames[w] ?? "",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (weekdayStartMinutes[w]!.isNotEmpty) ...[
                                  Text(
                                    formatTimeFromMinutes(
                                      weekdayStartMinutes[w]!.average.round(),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Icon(
                                      Icons.arrow_downward,
                                      size: 12,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    formatTimeFromMinutes(
                                      weekdayEndMinutes[w]!.average.round(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ] else
                                  const Text("—", style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (w < 5) const SizedBox(width: 6),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        // Loose extreme cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
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
        ),
      ],
    );
  }
}
