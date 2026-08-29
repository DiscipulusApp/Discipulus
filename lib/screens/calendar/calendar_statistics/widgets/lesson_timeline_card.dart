import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_activity_insights_card.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LessonTimelineCard extends StatelessWidget {
  const LessonTimelineCard({
    super.key,
    required this.events,
    this.title = "Eerste & Laatste les",
    this.subtitle = "Tijdlijn van de eerste en meest recente les",
  });

  final List<CalendarEvent> events;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sorted = List<CalendarEvent>.from(events)
      ..sort((a, b) => a.start.compareTo(b.start));

    final firstLesson = sorted.firstOrNull;
    final lastLesson = sorted.lastOrNull;

    if (firstLesson == null || lastLesson == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final tiles = [
          InsightCardItem(
            icon: Icons.play_circle_outline,
            iconColor: theme.colorScheme.primary,
            iconBackgroundColor: theme.colorScheme.primaryContainer,
            title: "Eerste les",
            value: DateFormat('d MMMM yyyy', 'nl_NL').format(firstLesson.start),
            subtitle: firstLesson.title.isNotEmpty ? firstLesson.title : "Les",
            onTap: () => CalendarDayView(
              displayedDay: firstLesson.start,
            ).push(context),
          ),
          InsightCardItem(
            icon: Icons.flag_outlined,
            iconColor: theme.colorScheme.primary,
            iconBackgroundColor: theme.colorScheme.primaryContainer,
            title: "Meest recente les",
            value: DateFormat('d MMMM yyyy', 'nl_NL').format(lastLesson.start),
            subtitle: lastLesson.title.isNotEmpty ? lastLesson.title : "Les",
            onTap: () => CalendarDayView(
              displayedDay: lastLesson.start,
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
