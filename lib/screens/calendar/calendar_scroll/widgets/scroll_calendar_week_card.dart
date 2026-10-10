import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

class ScrollCalendarWeekCard extends StatefulWidget {
  const ScrollCalendarWeekCard({
    super.key,
    required this.weekDate,
    this.activeFilters,
  });

  final DateTime weekDate;
  final List<CalendarFilter>? activeFilters;

  @override
  State<ScrollCalendarWeekCard> createState() => _ScrollCalendarWeekCardState();
}

class _ScrollCalendarWeekCardState extends State<ScrollCalendarWeekCard> {
  int totalTests = 0;
  int completedTests = 0;
  int totalHomework = 0;
  int completedHomework = 0;
  int totalLessons = 0;
  bool hasEvents = false;

  DateTime get monday => widget.weekDate.startOfWeek;
  DateTime get endOfWeek =>
      monday.add(Duration(days: appSettings.workWeek ? 4 : 6));

  @override
  void initState() {
    super.initState();
    _loadWeekStatsSync();
  }

  @override
  void didUpdateWidget(ScrollCalendarWeekCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weekDate.dayOnly != widget.weekDate.dayOnly ||
        !const ListEquality().equals(oldWidget.activeFilters, widget.activeFilters)) {
      _loadWeekStatsSync();
    }
  }

  void _loadWeekStatsSync() {
    try {
      final rangeEnd = DateTime(monday.year, monday.month, monday.day + 7);
      final rawEvents = activeProfile.calendarEvents
          .filter()
          .startBetween(monday, rangeEnd)
          .findAllSync();

      final events = (widget.activeFilters != null &&
              widget.activeFilters!.isNotEmpty)
          ? rawEvents.applyCalendarFilter(filters: widget.activeFilters)
          : rawEvents;

      hasEvents = events.isNotEmpty;

      final tests = events.where((e) => e.isTest).toList();
      final finishedTests = tests
          .where((e) => e.afgerond || e.einde.isBefore(DateTime.now()))
          .length;

      final homework = events.where((e) => e.hasHomework).toList();
      final finishedHomework = homework.where((e) => e.afgerond).length;

      final lessons = events
          .where((e) => !e.duurtHeleDag && e.lesuurVan != null)
          .toList();

      totalTests = tests.length;
      completedTests = finishedTests;
      totalHomework = homework.length;
      completedHomework = finishedHomework;
      totalLessons = lessons.length;
    } catch (_) {
      hasEvents = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFilterActive =
        widget.activeFilters != null && widget.activeFilters!.isNotEmpty;
    if (isFilterActive && !hasEvents) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final bool isCurrentWeek =
        DateTime.now().startOfWeek.dayOnly == monday.dayOnly;

    final String dateRangeStr =
        "${monday.day} ${DateFormat.MMM('nl-NL').format(monday)} - ${endOfWeek.day} ${DateFormat.MMM('nl-NL').format(endOfWeek)}";

    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
      color: isCurrentWeek
          ? theme.colorScheme.surfaceContainer.harmonizeWith(theme.colorScheme.primary)
          : theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Title & Date Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Week ${widget.weekDate.weekNumber}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateRangeStr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 20,
                          color: theme.colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Toetsen",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color:
                                      theme.colorScheme.onTertiaryContainer,
                                ),
                              ),
                              Text(
                                totalTests > 0
                                    ? "$completedTests / $totalTests"
                                    : "0",
                                style:
                                    theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      theme.colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 20,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Huiswerk",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color:
                                      theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              Text(
                                totalHomework > 0
                                    ? "$completedHomework / $totalHomework"
                                    : "0",
                                style:
                                    theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (totalLessons > 0) ...[
                  const SizedBox(width: 8),
                  // Lesuren Stat
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lessen",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          "$totalLessons u",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
