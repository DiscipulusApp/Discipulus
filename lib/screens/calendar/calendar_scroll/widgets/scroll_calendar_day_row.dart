import 'package:collection/collection.dart';
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_body.dart';
import 'package:discipulus/screens/calendar/calendar_scroll/widgets/scroll_calendar_week_card.dart';
import 'package:discipulus/screens/calendar/calendar_scroll/widgets/sticky_day_indicator.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class ScrollCalendarDayRow extends StatefulWidget {
  const ScrollCalendarDayRow({
    super.key,
    required this.day,
    this.showWeekCard = false,
    this.topOffset = 0.0,
    this.activeFilters,
    this.onEventChanged,
    this.onNavigateToDate,
    this.onDaySelected,
  });

  final DateTime day;
  final bool showWeekCard;
  final double topOffset;
  final List<CalendarFilter>? activeFilters;
  final VoidCallback? onEventChanged;
  final ValueChanged<DateTime>? onNavigateToDate;
  final ValueChanged<DateTime>? onDaySelected;

  @override
  State<ScrollCalendarDayRow> createState() => _ScrollCalendarDayRowState();
}

class _ScrollCalendarDayRowState extends State<ScrollCalendarDayRow> {
  late List<CalendarEvent> _events;
  late List<Assignment> _assignments;
  late List<Activity> _activities;
  DateTime? _nextLessonDate;

  @override
  void initState() {
    super.initState();
    _loadDayDataSync();
  }

  @override
  void didUpdateWidget(ScrollCalendarDayRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day.dayOnly != widget.day.dayOnly ||
        !const ListEquality()
            .equals(oldWidget.activeFilters, widget.activeFilters)) {
      _loadDayDataSync();
    }
  }

  void _loadDayDataSync() {
    final day = widget.day.dayOnly;
    final nextDay = DateTime(day.year, day.month, day.day + 1);

    try {
      final rawEvents = activeProfile.calendarEvents
          .filter()
          .startLessThan(nextDay)
          .and()
          .eindeGreaterThan(day)
          .sortByStart()
          .findAllSync();

      _events =
          (widget.activeFilters != null && widget.activeFilters!.isNotEmpty)
              ? rawEvents.applyCalendarFilter(filters: widget.activeFilters)
              : rawEvents;

      final bool hasActiveFilters =
          widget.activeFilters != null && widget.activeFilters!.isNotEmpty;

      if (hasActiveFilters) {
        final infoFilters =
            widget.activeFilters!.whereType<CalendarInfoTypeFilter>().toList();
        final hasHomeworkFilter =
            infoFilters.any((f) => f.infoType == InfoType.homework);
        final hasTeacherOrClassroom = widget.activeFilters!.any(
            (f) => f is CalendarTeacherFilter || f is CalendarClassroomFilter);

        if (hasTeacherOrClassroom ||
            (infoFilters.isNotEmpty && !hasHomeworkFilter)) {
          _assignments = [];
          _activities = [];
        } else {
          _assignments = activeProfile.assignments
              .filter()
              .inleverenVoorBetween(day, nextDay)
              .sortByIngeleverdOpDesc()
              .findAllSync();
          _activities = [];
        }
      } else {
        _assignments = activeProfile.assignments
            .filter()
            .inleverenVoorBetween(day, nextDay)
            .sortByIngeleverdOpDesc()
            .findAllSync();

        _activities = activeProfile.activities
            .filter()
            .eindeInschrijfdatumBetween(day, nextDay)
            .sortByEindeInschrijfdatum()
            .findAllSync();
      }

      if (_events.isEmpty && widget.day.isToday && !hasActiveFilters) {
        final nextEvent = activeProfile.calendarEvents
            .filter()
            .startGreaterThan(nextDay)
            .validLessons()
            .sortByStart()
            .findFirstSync();
        _nextLessonDate = nextEvent?.start;
      }
    } catch (_) {
      _events = [];
      _assignments = [];
      _activities = [];
    }
  }

  void _onDataChanged() {
    setState(() {
      _loadDayDataSync();
    });
    widget.onEventChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFilterActive =
        widget.activeFilters != null && widget.activeFilters!.isNotEmpty;
    final bool hasNoItems =
        _events.isEmpty && _assignments.isEmpty && _activities.isEmpty;

    final int filterHash = Object.hashAll(widget.activeFilters ?? const []);

    // In filtered mode, empty days disappear completely
    if (isFilterActive && hasNoItems) {
      if (widget.showWeekCard) {
        return ScrollCalendarWeekCard(
          key:
              ValueKey("week_card_${widget.day.toIso8601String()}_$filterHash"),
          weekDate: widget.day,
          activeFilters: widget.activeFilters,
        );
      }
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showWeekCard)
          ScrollCalendarWeekCard(
            key: ValueKey(
                "week_card_${widget.day.toIso8601String()}_$filterHash"),
            weekDate: widget.day,
            activeFilters: widget.activeFilters,
          ),
        Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 68,
              child: StickyHeaderBox(
                topPadding: widget.topOffset,
                child: DayIndicatorBadge(
                  date: widget.day,
                  onTap: widget.onDaySelected != null
                      ? () => widget.onDaySelected!(widget.day)
                      : null,
                ),
              ),
            ),

            CustomCard(
              margin: const EdgeInsets.only(left: 68, right: 8, bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: context.cs.surfaceContainer.withValues(alpha: 0.75),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 64),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final assignment in _assignments)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: AssignmentCalendarTile(assignment: assignment),
                        ),
                      for (final activity in _activities)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: ActivityCalendarTile(activity: activity),
                        ),
                      if (_events.isNotEmpty)
                        _buildEventsList()
                      else if (_assignments.isEmpty && _activities.isEmpty)
                        _buildEmptyState(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventsList() {
    final List<List<CalendarEvent>> combinedList = _events
        .where(
          (e) =>
              (appSettings.showAutoCancelledEvents ||
                  (!appSettings.showAutoCancelledEvents &&
                      ![Status.automaticallyCanceled, Status.manuallyCanceled]
                          .contains(e.status))) &&
              (!appSettings.hideEventswithoutHours || e.lesuurVan != null),
        )
        .combineEvents();

    if (combinedList.isEmpty) {
      return _buildEmptyState();
    }

    final List<int> eventLengths = [];
    for (final event in _events) {
      if (!event.duurtHeleDag &&
          (!appSettings.hideEventswithoutHours || event.lesuurVan != null)) {
        eventLengths.add(event.einde.difference(event.start).inMinutes);
      }
    }
    final double? averageLength =
        eventLengths.isNotEmpty ? eventLengths.average : null;

    final List<Widget> children = [];

    for (int i = 0; i < combinedList.length; i++) {
      final combinedEvent = combinedList[i];
      final int eventDuration = combinedEvent.last.einde
          .difference(combinedEvent.first.start)
          .inMinutes;

      int getGapMinutes({bool after = false}) {
        if (after && combinedList.length != i + 1) {
          final gapMinutes = combinedList[i + 1]
              .first
              .start
              .difference(combinedEvent.last.einde)
              .inMinutes;
          return gapMinutes;
        }
        if (i == 0) return 0;
        final gapMinutes = combinedEvent.first.start
            .difference(combinedList[i - 1].last.einde)
            .inMinutes;
        return gapMinutes;
      }

      bool gapHasBeenAddedBefore = getGapMinutes() >= 5;
      bool gapHasBeenAddedAfter = getGapMinutes(after: true) >= 5;

      if (gapHasBeenAddedBefore && appSettings.showEmptySpaceBetweenLessons) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Hero(
              tag: "emptySpace${combinedEvent.last.id}",
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: double.infinity,
                  height: getGapMinutes().clamp(28, 44).toDouble(),
                  child: Center(
                    child: Text(
                      "${getGapMinutes()} min",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      ScrollCalendarTileTypePosition tileType() {
        if (gapHasBeenAddedBefore && gapHasBeenAddedAfter ||
            (i == 0 && gapHasBeenAddedAfter)) {
          return ScrollCalendarTileTypePosition.single;
        } else if (gapHasBeenAddedBefore) {
          return ScrollCalendarTileTypePosition.top;
        } else if (gapHasBeenAddedAfter) {
          return ScrollCalendarTileTypePosition.end;
        } else if (i == 0) {
          return ScrollCalendarTileTypePosition.top;
        } else if (i == combinedList.length - 1) {
          return ScrollCalendarTileTypePosition.end;
        } else {
          return ScrollCalendarTileTypePosition.middle;
        }
      }

      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: SimpleDayViewEventTile(
            scrollTile: true,
            callback: _onDataChanged,
            event: combinedEvent,
            size: combinedList.length == 1 || combinedEvent.last.duurtHeleDag
                ? null
                : averageLength == null || eventDuration < (averageLength - 5)
                    ? CalendarEventSize.small
                    : eventDuration > (averageLength + 5)
                        ? CalendarEventSize.large
                        : CalendarEventSize.normal,
            tileType: tileType(),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final bool isWeekend = widget.day.weekday >= 6;

    return CustomCard(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.day.isToday
                        ? "Whoohoo, geen lessen! 🎉"
                        : (isWeekend ? "Weekend" : "Geen lessen"),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (_nextLessonDate != null) ...[
              SizedBox(height: 4),
              FilledButton.tonalIcon(
                onPressed: () =>
                    widget.onNavigateToDate?.call(_nextLessonDate!),
                icon: const Icon(Icons.navigate_next, size: 18),
                label: const Text("Volgende les"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
