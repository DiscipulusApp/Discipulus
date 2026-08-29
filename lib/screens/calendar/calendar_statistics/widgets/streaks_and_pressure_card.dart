import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_activity_insights_card.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreaksAndPressureCard extends StatelessWidget {
  const StreaksAndPressureCard({
    super.key,
    required this.events,
  });

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Calculate Attendance Streaks (Afwezigheids-vrije streak)
    final Map<DateTime, bool> schoolDaysAbsenceMap = {};
    for (final e in events) {
      if (e.duurtHeleDag) continue;
      final dayKey = e.start.dayOnly;
      final isAbsent = e.afwezigheid != null &&
          e.afwezigheid!.verantwoordingtype == AbsenceType.absent;

      if (!schoolDaysAbsenceMap.containsKey(dayKey)) {
        schoolDaysAbsenceMap[dayKey] = isAbsent;
      } else if (isAbsent) {
        schoolDaysAbsenceMap[dayKey] = true;
      }
    }

    final sortedSchoolDays = schoolDaysAbsenceMap.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    int longestStreakDays = 0;
    int currentRunningStreak = 0;
    DateTime? longestStreakStartDate;

    DateTime? tempStreakStart;

    for (final day in sortedSchoolDays) {
      final wasAbsent = schoolDaysAbsenceMap[day] ?? false;
      if (!wasAbsent) {
        if (currentRunningStreak == 0) {
          tempStreakStart = day;
        }
        currentRunningStreak++;
        if (currentRunningStreak > longestStreakDays) {
          longestStreakDays = currentRunningStreak;
          longestStreakStartDate = tempStreakStart;
        }
      } else {
        currentRunningStreak = 0;
        tempStreakStart = null;
      }
    }

    final int streakWeeks = (longestStreakDays / 5).round();

    // 2. Max Tests in a Week
    final Map<String, List<CalendarEvent>> testsPerWeek = {};
    for (final e in events) {
      if (e.isTest || e.infoType == InfoType.test || e.infoType == InfoType.exam) {
        final weekKey = "${e.start.year}-W${e.start.weekNumber.toString().padLeft(2, '0')}";
        testsPerWeek.putIfAbsent(weekKey, () => []).add(e);
      }
    }

    List<CalendarEvent> peakWeekTests = [];
    int maxTestsInWeek = 0;

    for (final entry in testsPerWeek.entries) {
      if (entry.value.length > maxTestsInWeek) {
        maxTestsInWeek = entry.value.length;
        peakWeekTests = entry.value..sort((a, b) => a.start.compareTo(b.start));
      }
    }

    final firstPeakTest = peakWeekTests.firstOrNull;

    final tiles = <Widget>[
      InsightCardItem(
        icon: Icons.local_fire_department_outlined,
        iconColor: theme.colorScheme.primary,
        iconBackgroundColor: theme.colorScheme.primaryContainer,
        title: "Afwezigheids-vrije Streak",
        value: longestStreakDays > 0
            ? "$longestStreakDays schooldagen"
            : "Geen data",
        subtitle: longestStreakDays > 0
            ? "~$streakWeeks schoolweken op rij 100% aanwezig"
            : "Nog geen streak geregistreerd",
        onTap: longestStreakStartDate != null
            ? () => CalendarDayView(
                  displayedDay: longestStreakStartDate,
                ).push(context)
            : null,
      ),
      if (maxTestsInWeek > 0 && firstPeakTest != null)
        InsightCardItem(
          icon: Icons.thunderstorm_outlined,
          iconColor: theme.colorScheme.error,
          iconBackgroundColor: theme.colorScheme.errorContainer,
          title: "Meeste toetsen in 1 week",
          value: "$maxTestsInWeek toetsen",
          subtitle:
              "Week ${firstPeakTest.start.weekNumber} (${firstPeakTest.start.year}) • ${DateFormat('d MMM', 'nl_NL').format(firstPeakTest.start)} - ${DateFormat('d MMM yyyy', 'nl_NL').format(peakWeekTests.last.start)}",
          onTap: () => CalendarDayView(
            displayedDay: firstPeakTest.start,
          ).push(context),
        ),
    ];

    return LayoutBuilder(
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
    );
  }
}
