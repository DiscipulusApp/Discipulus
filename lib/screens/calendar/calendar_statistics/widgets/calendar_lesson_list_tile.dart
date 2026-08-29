import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarLessonListTile extends StatelessWidget {
  const CalendarLessonListTile({
    super.key,
    required this.lesson,
  });

  final CalendarEvent lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: lesson.isCanceled
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          lesson.isCanceled
              ? Icons.event_busy
              : (lesson.isTest ? Icons.quiz_outlined : Icons.schedule),
          color: lesson.isCanceled
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Text(
        lesson.title.isNotEmpty ? lesson.title : "Les",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: lesson.isCanceled ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        "${DateFormat('EEE d MMM yyyy', 'nl_NL').format(lesson.start)} • ${DateFormat('HH:mm').format(lesson.start)} - ${DateFormat('HH:mm').format(lesson.einde)}${lesson.lokatie != null && lesson.lokatie!.isNotEmpty ? ' • ${lesson.lokatie}' : ''}",
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => CalendarDayView(
        displayedDay: lesson.start,
      ).push(context),
    );
  }
}
