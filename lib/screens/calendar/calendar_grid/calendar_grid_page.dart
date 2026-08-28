import 'dart:async';
import 'dart:math';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_grid/calendar_grid_event_card.dart';
import 'package:discipulus/screens/calendar/calendar_schedule.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

/// Swipable day columns page containing Material 3 rounded background blocks, event cards, and time indicator
class GridDayColumnsPage extends StatefulWidget {
  const GridDayColumnsPage({
    super.key,
    required this.days,
    required this.hourHeight,
    this.onLoadingChanged,
  });

  final List<DateTime> days;
  final double hourHeight;
  final ValueChanged<bool>? onLoadingChanged;

  @override
  State<GridDayColumnsPage> createState() => _GridDayColumnsPageState();
}

class _GridDayColumnsPageState extends State<GridDayColumnsPage> {
  List<CalendarEvent> _events = [];
  final Set<int> _cachedEventUuids = {};
  bool _initialCacheLoaded = false;
  Timer? _tickerTimer;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _tickerTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant GridDayColumnsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.days.first != oldWidget.days.first ||
        widget.days.length != oldWidget.days.length) {
      _loadEvents();
    }
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    if (widget.days.isEmpty) return;

    final rangeStart = DateTime(
      widget.days.first.year,
      widget.days.first.month,
      widget.days.first.day,
    );
    final rangeEnd = DateTime(
      widget.days.last.year,
      widget.days.last.month,
      widget.days.last.day + 1,
    );

    // 1. Fetch from local database (Isar)
    final localEvents = await activeProfile.calendarEvents
        .filter()
        .group((q) => q
            .eindeLessThan(rangeEnd)
            .or()
            .eindeEqualTo(rangeEnd))
        .and()
        .group((q) =>
            q.startGreaterThan(rangeStart).or().startEqualTo(rangeStart))
        .or()
        .group((q) => q
            .duurtHeleDagEqualTo(true)
            .startLessThan(rangeEnd)
            .eindeGreaterThan(rangeStart))
        .sortByStart()
        .findAll();

    if (mounted) {
      setState(() {
        _events = localEvents;
        if (!_initialCacheLoaded) {
          _cachedEventUuids.addAll(localEvents.map((e) => e.uuid));
          _initialCacheLoaded = true;
        }
      });
    }

    // 2. Fetch fresh data from Magister API in background
    widget.onLoadingChanged?.call(true);
    try {
      await activeProfile.getEvents(
        DateTimeRange(start: rangeStart, end: rangeEnd),
      );
      final refreshed = await activeProfile.calendarEvents
          .filter()
          .group((q) => q
              .eindeLessThan(rangeEnd)
              .or()
              .eindeEqualTo(rangeEnd))
          .and()
          .group((q) =>
              q.startGreaterThan(rangeStart).or().startEqualTo(rangeStart))
          .or()
          .group((q) => q
              .duurtHeleDagEqualTo(true)
              .startLessThan(rangeEnd)
              .eindeGreaterThan(rangeStart))
          .sortByStart()
          .findAll();

      if (mounted) {
        setState(() {
          _events = refreshed;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) {
        widget.onLoadingChanged?.call(false);
      }
    }
  }

  bool _isEventOnDay(CalendarEvent event, DateTime day) {
    final localStart = event.start.toLocal();
    final localEnd = event.einde.toLocal();

    if (event.duurtHeleDag) {
      final nextDay = DateTime(day.year, day.month, day.day + 1);
      return localStart.isBefore(nextDay) && localEnd.isAfter(day);
    }
    return localStart.year == day.year &&
        localStart.month == day.month &&
        localStart.day == day.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timedCombinedEventsPerDay = <DateTime, List<List<CalendarEvent>>>{};

    for (final day in widget.days) {
      final dayEvents = _events.where((e) => _isEventOnDay(e, day)).toList();

      // Reusing existing combineEvents() extension method
      timedCombinedEventsPerDay[day] = dayEvents
          .where((e) =>
              !e.duurtHeleDag &&
              (appSettings.showAutoCancelledEvents ||
                  (!appSettings.showAutoCancelledEvents &&
                      ![Status.automaticallyCanceled, Status.manuallyCanceled]
                          .contains(e.status))))
          .combineEvents();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final colWidth = constraints.maxWidth / widget.days.length;
        return Stack(
          children: [
            // Background Blocks for each hour slot
            for (int dayIndex = 0;
                dayIndex < widget.days.length;
                dayIndex++) ...[
              _buildDayBackgroundBlocks(
                dayIndex: dayIndex,
                colWidth: colWidth,
                day: widget.days[dayIndex],
                theme: theme,
              ),
            ],
            // Event Cards across all days
            for (int dayIndex = 0;
                dayIndex < widget.days.length;
                dayIndex++) ...[
              _buildDayEvents(
                dayIndex: dayIndex,
                day: widget.days[dayIndex],
                dayEvents:
                    timedCombinedEventsPerDay[widget.days[dayIndex]] ?? [],
                colWidth: colWidth,
              ),
            ],
            // Current time indicator for today
            for (int i = 0; i < widget.days.length; i++)
              if (widget.days[i].dayOnly == DateTime.now().dayOnly)
                CurrentTimeIndicator(
                  left: i * colWidth + 2.0,
                  width: colWidth - 4.0,
                  hourHeight: widget.hourHeight,
                ),
          ],
        );
      },
    );
  }

  /// Builds the recessed, background hour blocks for a day column
  Widget _buildDayBackgroundBlocks({
    required int dayIndex,
    required double colWidth,
    required DateTime day,
    required ThemeData theme,
  }) {
    return Positioned(
      left: dayIndex * colWidth,
      top: 0,
      bottom: 0,
      width: colWidth,
      child: Stack(
        children: [
          for (int hour = 0; hour < 24; hour++)
            Positioned(
              top: hour * widget.hourHeight + 1.5,
              height: widget.hourHeight - 3.0,
              left: 2.0,
              right: 2.0,
              child: Material(
                color: theme.colorScheme.surface,
                borderRadius: _getHourBlockBorderRadius(hour),
                child: InkWell(
                  borderRadius: _getHourBlockBorderRadius(hour),
                  onTap: () async {
                    final date = await showScheduleSheet(context);
                    if (date != null) {
                      _loadEvents();
                    }
                  },
                  child: const SizedBox.expand(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  BorderRadius _getHourBlockBorderRadius(int hour) {
    if (hour == 0) {
      // Rounded at start of day (midnight)
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(6),
        bottomRight: Radius.circular(6),
      );
    } else if (hour == 23) {
      // Rounded at end of day (midnight close)
      return const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      );
    }
    return BorderRadius.circular(6);
  }

  Widget _buildDayEvents({
    required int dayIndex,
    required DateTime day,
    required List<List<CalendarEvent>> dayEvents,
    required double colWidth,
  }) {
    if (dayEvents.isEmpty) return const SizedBox();

    final positionedEvents = _calculateOverlaps(dayEvents);

    return Positioned(
      left: dayIndex * colWidth,
      top: 0,
      bottom: 0,
      width: colWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (final pEvent in positionedEvents)
            _buildEventCard(pEvent, colWidth),
        ],
      ),
    );
  }

  Widget _buildEventCard(PositionedCombinedEvent pEvent, double colWidth) {
    final first = pEvent.events.first;
    final last = pEvent.events.last;
    final localStart = first.start.toLocal();
    final localEnd = last.einde.toLocal();

    final startMinutes = localStart.hour * 60 + localStart.minute;
    final endMinutes = localEnd.hour * 60 + localEnd.minute;
    final duration = max(15, endMinutes - startMinutes);

    final top = startMinutes * (widget.hourHeight / 60.0);
    final height = max(24.0, duration * (widget.hourHeight / 60.0) - 2.0);

    // Padding inset relative to column blocks
    final columnBlockWidth = colWidth - 4.0;
    final itemWidth = columnBlockWidth / pEvent.totalColumns;
    final left = 2.0 + pEvent.column * itemWidth;

    final isNew =
        !pEvent.events.every((e) => _cachedEventUuids.contains(e.uuid));

    final cardWidget = TimeGridEventCard(
      events: pEvent.events,
      height: height,
      onRefresh: _loadEvents,
    );

    return Positioned(
      key: ValueKey(pEvent.events.map((e) => e.uuid).join("_")),
      top: top,
      left: left + 1.0,
      width: max(0.0, itemWidth - 2.0),
      height: height,
      child: isNew
          ? AppearAnimation(
              duration: Durations.medium2,
              curve: Easing.standard,
              child: (animation) => FadeTransition(
                opacity: animation,
                child: cardWidget,
              ),
            )
          : cardWidget,
    );
  }

  /// Calculates column index and total overlapping columns for each combined event
  List<PositionedCombinedEvent> _calculateOverlaps(
      List<List<CalendarEvent>> rawEvents) {
    if (rawEvents.isEmpty) return [];

    final sorted = List<List<CalendarEvent>>.from(rawEvents)
      ..sort((a, b) {
        final cmp = a.first.start.compareTo(b.first.start);
        if (cmp != 0) return cmp;
        return b.last.einde.compareTo(a.last.einde);
      });

    final positionedList =
        sorted.map((e) => PositionedCombinedEvent(e)).toList();

    // Group into overlapping clusters
    final clusters = <List<PositionedCombinedEvent>>[];
    for (final pe in positionedList) {
      if (clusters.isEmpty) {
        clusters.add([pe]);
      } else {
        final lastCluster = clusters.last;
        final clusterEnd = lastCluster
            .map((e) => e.events.last.einde)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        if (pe.events.first.start.isBefore(clusterEnd)) {
          lastCluster.add(pe);
        } else {
          clusters.add([pe]);
        }
      }
    }

    // Assign column indices per cluster
    for (final cluster in clusters) {
      final columns = <List<PositionedCombinedEvent>>[];
      for (final pe in cluster) {
        int targetCol = 0;
        bool placed = false;
        while (!placed) {
          if (targetCol >= columns.length) {
            columns.add([pe]);
            pe.column = targetCol;
            placed = true;
          } else {
            final colEvents = columns[targetCol];
            final overlaps = colEvents.any((other) =>
                pe.events.first.start.isBefore(other.events.last.einde) &&
                pe.events.last.einde.isAfter(other.events.first.start));
            if (!overlaps) {
              colEvents.add(pe);
              pe.column = targetCol;
              placed = true;
            } else {
              targetCol++;
            }
          }
        }
      }
      for (final pe in cluster) {
        pe.totalColumns = max(1, columns.length);
      }
    }

    return positionedList;
  }
}

/// Helper model for calculating overlapping events layout
class PositionedCombinedEvent {
  PositionedCombinedEvent(this.events);
  final List<CalendarEvent> events;
  int column = 0;
  int totalColumns = 1;
}

/// Current time indicator line on today's column
class CurrentTimeIndicator extends StatelessWidget {
  const CurrentTimeIndicator({
    super.key,
    required this.left,
    required this.width,
    required this.hourHeight,
  });

  final double left;
  final double width;
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final top = (now.hour * 60 + now.minute) * (hourHeight / 60.0);
    final color = Theme.of(context).colorScheme.tertiary;

    return Positioned(
      left: left,
      top: top - 4,
      width: width,
      height: 8,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 4),
            height: 2.5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
