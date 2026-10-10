import 'dart:async';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/calendar_schedule.dart';
import 'package:discipulus/screens/calendar/calendar_scroll/widgets/scroll_calendar_day_row.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/screens/calendar/calendar_scroll/widgets/expandable_filter_fab.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

/// Controller to programmatically auto-scroll the [ScrollCalendar].
class ScrollCalendarController {
  _ScrollCalendarState? _state;

  void _attach(_ScrollCalendarState state) => _state = state;
  void _detach() => _state = null;

  /// Auto-scrolls smoothly to [targetDate].
  void scrollToDate(DateTime targetDate, {bool animate = true}) {
    _state?.scrollToDate(targetDate, animate: animate);
  }

  /// Auto-scrolls smoothly to today.
  void scrollToToday({bool animate = true}) {
    _state?.scrollToDate(DateTime.now(), animate: animate);
  }
}

/// A continuous vertical infinite scrolling calendar in both directions.
class ScrollCalendar extends StatefulWidget {
  const ScrollCalendar({
    super.key,
    this.initdate,
    this.selectedDay,
    this.controller,
    this.onDaySelected,
  });

  /// The initial date to center the calendar on.
  /// Defaults to [DateTime.now()] if null.
  final DateTime? initdate;

  /// Optional notifier for the currently focused or visible date.
  final ValueNotifier<DateTime>? selectedDay;

  /// Optional controller to trigger auto-scroll actions.
  final ScrollCalendarController? controller;

  /// Optional callback invoked when a day indicator badge is tapped.
  final ValueChanged<DateTime>? onDaySelected;

  @override
  State<ScrollCalendar> createState() => _ScrollCalendarState();
}

DateTime scrollCalendarIndexToDate(
    DateTime centerDate, int offset, bool workWeek) {
  if (!workWeek) {
    return DateTime(centerDate.year, centerDate.month, centerDate.day + offset);
  }
  DateTime current =
      DateTime(centerDate.year, centerDate.month, centerDate.day);
  if (offset > 0) {
    int remaining = offset;
    while (remaining > 0) {
      current = DateTime(current.year, current.month, current.day + 1);
      if (current.weekday <= 5) {
        remaining--;
      }
    }
  } else if (offset < 0) {
    int remaining = -offset;
    while (remaining > 0) {
      current = DateTime(current.year, current.month, current.day - 1);
      if (current.weekday <= 5) {
        remaining--;
      }
    }
  }
  return current;
}

int scrollCalendarDateToOffset(
    DateTime centerDate, DateTime targetDate, bool workWeek) {
  if (!workWeek) {
    return DateTime.utc(targetDate.year, targetDate.month, targetDate.day)
        .difference(
            DateTime.utc(centerDate.year, centerDate.month, centerDate.day))
        .inDays;
  }
  DateTime cleanCenter =
      DateTime(centerDate.year, centerDate.month, centerDate.day);
  DateTime cleanTarget =
      DateTime(targetDate.year, targetDate.month, targetDate.day);
  if (cleanTarget.isAfter(cleanCenter)) {
    int count = 0;
    DateTime cur = cleanCenter;
    while (cur.isBefore(cleanTarget)) {
      cur = DateTime(cur.year, cur.month, cur.day + 1);
      if (cur.weekday <= 5) count++;
    }
    return count;
  } else if (cleanTarget.isBefore(cleanCenter)) {
    int count = 0;
    DateTime cur = cleanCenter;
    while (cur.isAfter(cleanTarget)) {
      cur = DateTime(cur.year, cur.month, cur.day - 1);
      if (cur.weekday <= 5) count--;
    }
    return count;
  }
  return 0;
}

class _ScrollCalendarState extends State<ScrollCalendar> {
  final Key _centerKey = const ValueKey('calendar_scroll_center_key');
  late ScrollController _scrollController;
  late ValueNotifier<DateTime> _visibleDay;
  late DateTime _centerDate;

  final Map<DateTime, BuildContext> _dayContexts = {};
  final Set<int> _fetchedWeeks = {};
  final List<CalendarFilter> _activeFilters = [];
  int _filterVersion = 0;

  List<DateTime>? _futureMatchingDays;
  List<DateTime>? _pastMatchingDays;
  List<DateTime> _allMatchingDays = [];

  @override
  void initState() {
    super.initState();
    _centerDate = getInitialCalendarDate(
      explicitDate: widget.initdate,
      adjustWeekend: true,
    );
    _visibleDay = widget.selectedDay ?? ValueNotifier(_centerDate);
    _scrollController = ScrollController()..addListener(_onScroll);

    widget.controller?._attach(this);
    _updateFilteredDays();
    _fetchWeekForDate(_centerDate);
  }

  void _updateFilteredDays() {
    if (_activeFilters.isEmpty) {
      _futureMatchingDays = null;
      _pastMatchingDays = null;
      _allMatchingDays = [];
      return;
    }

    try {
      final events =
          activeProfile.calendarEvents.filter().sortByStart().findAllSync();
      final filteredEvents =
          events.applyCalendarFilter(filters: _activeFilters);

      final infoFilters =
          _activeFilters.whereType<CalendarInfoTypeFilter>().toList();
      final hasHomeworkFilter =
          infoFilters.any((f) => f.infoType == InfoType.homework);
      final hasTeacherOrClassroom = _activeFilters.any(
          (f) => f is CalendarTeacherFilter || f is CalendarClassroomFilter);

      List<Assignment> matchingAssignments = [];
      if (!hasTeacherOrClassroom &&
          (infoFilters.isEmpty || hasHomeworkFilter)) {
        matchingAssignments = activeProfile.assignments
            .filter()
            .sortByInleverenVoorDesc()
            .findAllSync();
      }

      final Set<DateTime> matchingDaySet = {};
      for (final e in filteredEvents) {
        if (!appSettings.showAutoCancelledEvents &&
            [Status.automaticallyCanceled, Status.manuallyCanceled]
                .contains(e.status)) {
          continue;
        }
        if (appSettings.hideEventswithoutHours &&
            e.lesuurVan == null &&
            !e.duurtHeleDag) {
          continue;
        }
        matchingDaySet.add(e.start.dayOnly);
      }

      for (final a in matchingAssignments) {
        matchingDaySet.add(a.inleverenVoor.dayOnly);
      }

      final sortedDays = matchingDaySet.toList()..sort();
      _allMatchingDays = sortedDays;

      if (sortedDays.isEmpty) {
        _futureMatchingDays = [];
        _pastMatchingDays = [];
        return;
      }

      // Always anchor to _centerDate so the split point between
      // past and future slivers NEVER shifts while scrolling!
      DateTime anchor = _centerDate.dayOnly;
      if (!sortedDays.any((d) => !d.isBefore(anchor))) {
        anchor = sortedDays.last;
        _centerDate = anchor;
      }

      _futureMatchingDays =
          sortedDays.where((d) => !d.isBefore(anchor)).toList();
      _pastMatchingDays = sortedDays
          .where((d) => d.isBefore(anchor))
          .toList()
          .reversed
          .toList();
    } catch (_) {
      _futureMatchingDays = [];
      _pastMatchingDays = [];
      _allMatchingDays = [];
    }
  }

  bool _isFirstMatchingDayInWeek(DateTime day) {
    final int index = _allMatchingDays.indexOf(day.dayOnly);
    if (index <= 0) return true;
    final DateTime prevDay = _allMatchingDays[index - 1];
    return day.startOfWeek.dayOnly != prevDay.startOfWeek.dayOnly;
  }

  @override
  void didUpdateWidget(ScrollCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (widget.selectedDay == null) {
      _visibleDay.dispose();
    }
    super.dispose();
  }

  DateTime? _findTopVisibleDay() {
    DateTime? bestDay;
    double minDistance = double.infinity;
    DateTime? closestDay;
    double closestDistance = double.infinity;

    _dayContexts.removeWhere((_, ctx) => !ctx.mounted);

    for (final entry in _dayContexts.entries) {
      final ctx = entry.value;
      if (!ctx.mounted) continue;
      final renderBox = ctx.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize && renderBox.attached) {
        final viewport = RenderAbstractViewport.of(renderBox);
        final revealed = viewport.getOffsetToReveal(renderBox, 0.0);
        final double dy = revealed.offset - _scrollController.offset;
        final double distance = dy.abs();

        if (distance < closestDistance) {
          closestDistance = distance;
          closestDay = entry.key;
        }

        if (dy <= 80 && (dy + renderBox.size.height) > 0) {
          if (distance < minDistance) {
            minDistance = distance;
            bestDay = entry.key;
          }
        }
      }
    }

    return bestDay ?? closestDay;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final DateTime? visible = _findTopVisibleDay();
    final DateTime targetDay;
    if (visible != null) {
      targetDay = visible;
    } else if (_activeFilters.isEmpty) {
      const double estimatedDayHeight = 140.0;
      final double offset = _scrollController.offset;
      final int dayOffset = (offset / estimatedDayHeight).round();
      targetDay = scrollCalendarIndexToDate(
          _centerDate, dayOffset, appSettings.workWeek);
    } else {
      targetDay = _visibleDay.value;
    }

    if (targetDay.dayOnly != _visibleDay.value.dayOnly) {
      _visibleDay.value = targetDay.dayOnly;
      _fetchWeekForDate(targetDay);
    }
  }

  Future<void> _fetchWeekForDate(DateTime date) async {
    final int weekKey = date.year * 100 + date.weekNumber;
    if (_fetchedWeeks.contains(weekKey)) return;

    try {
      await activeProfile.getEvents(getHeaderWeekRange(date));
      _fetchedWeeks.add(weekKey);
    } catch (_) {
      // Continue silently if offline so we can retry on reconnection
    }
  }

  /// Auto-scrolls to the requested [targetDate].
  Future<void> scrollToDate(DateTime targetDate, {bool animate = true}) async {
    DateTime cleanTarget = targetDate.dayOnly;
    if (appSettings.workWeek && cleanTarget.weekday > 5) {
      cleanTarget = cleanTarget.add(Duration(days: 8 - cleanTarget.weekday));
    }
    final targetContext = _dayContexts[cleanTarget];

    // Case 1: Target day is already in the viewport tree
    if (targetContext != null && targetContext.mounted) {
      HapticFeedback.selectionClick();
      await Scrollable.ensureVisible(
        targetContext,
        duration: animate ? Durations.medium4 : Duration.zero,
        curve: Easing.emphasizedDecelerate,
        alignment: 0.0,
      );
      _visibleDay.value = cleanTarget;
      return;
    }

    if (_activeFilters.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() {
        _centerDate = cleanTarget;
        _updateFilteredDays();
        _dayContexts.clear();
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
        if (_futureMatchingDays != null && _futureMatchingDays!.isNotEmpty) {
          _visibleDay.value = _futureMatchingDays!.first;
        } else {
          _visibleDay.value = cleanTarget;
        }
      });
      return;
    }

    // Case 2: Nearby day within ±14 schooldays
    final int diff = scrollCalendarDateToOffset(
        _centerDate, cleanTarget, appSettings.workWeek);

    if (diff.abs() <= 14 && _scrollController.hasClients) {
      const double estimatedDayHeight = 140.0;
      final double targetOffset = diff * estimatedDayHeight;
      HapticFeedback.selectionClick();
      if (animate) {
        await _scrollController.animateTo(
          targetOffset,
          duration: Durations.medium4,
          curve: Easing.emphasizedDecelerate,
        );
      } else {
        _scrollController.jumpTo(targetOffset);
      }
      _visibleDay.value = cleanTarget;
      return;
    }

    // Case 3: Far away date (e.g. jumped from DatePicker months ahead)
    // Seamlessly re-anchor the center around the target date
    HapticFeedback.selectionClick();
    setState(() {
      _centerDate = cleanTarget;
      _dayContexts.clear();
      _scrollController.jumpTo(0.0);
      _visibleDay.value = cleanTarget;
    });
    _fetchWeekForDate(cleanTarget);
  }

  void _handleDayTap(DateTime day) {
    HapticFeedback.selectionClick();
    if (widget.onDaySelected != null) {
      widget.onDaySelected!(day);
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(day);
    } else {
      CalendarDayView(displayedDay: day).push(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double topOffset = 8.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.cs.surface,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const BackButtonIcon(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.of(context).pop(_visibleDay.value),
              )
            : leadingAppBarButton(context),
        title: ValueListenableBuilder<DateTime>(
          valueListenable: _visibleDay,
          builder: (context, currentDay, _) {
            final String monthName =
                DateFormat.MMMM('nl-NL').format(currentDay).capitalized;
            final String monthTitle = currentDay.year == DateTime.now().year
                ? monthName
                : "$monthName ${currentDay.year}";

            return Text(monthTitle);
          },
        ),
        actions: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _visibleDay,
            builder: (context, currentDay, _) {
              if (currentDay.isToday) return const SizedBox();
              return IconButton(
                tooltip: "Vandaag",
                onPressed: () => scrollToDate(DateTime.now()),
                icon: const Icon(Icons.today),
              );
            },
          ),
          IconButton(
            tooltip: "Kies datum",
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _visibleDay.value,
                firstDate:
                    DateTime.now().subtract(const Duration(days: 365 * 2)),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                currentDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
              );
              if (picked != null) {
                scrollToDate(picked);
              }
            },
            icon: const Icon(Icons.date_range),
          ),
          IconButton(
            tooltip: "Afspraak toevoegen",
            onPressed: () async {
              final DateTime? addedDate = await showScheduleSheet(context);
              if (addedDate != null) {
                scrollToDate(addedDate);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        center: _centerKey,
        slivers: [
          if (_activeFilters.isNotEmpty && _allMatchingDays.isEmpty)
            SliverFillRemaining(
              key: _centerKey,
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_alt_off_outlined,
                        size: 64,
                        color: context.cs.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Geen afspraken gevonden",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Er zijn geen afspraken die voldoen aan de actieve filters.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.cs.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Reverse Direction: Past Schooldays (-1, -2, -3...)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final DateTime day = _activeFilters.isNotEmpty
                      ? _pastMatchingDays![index]
                      : scrollCalendarIndexToDate(
                          _centerDate, -(index + 1), appSettings.workWeek);
                  final bool isStartOfWeek = _activeFilters.isNotEmpty
                      ? _isFirstMatchingDayInWeek(day)
                      : day.weekday == DateTime.monday;

                  return Builder(
                    builder: (ctx) {
                      _dayContexts[day.dayOnly] = ctx;
                      return ScrollCalendarDayRow(
                        key: ValueKey(
                            "past_${day.toIso8601String()}_$_filterVersion"),
                        day: day,
                        topOffset: topOffset,
                        showWeekCard: isStartOfWeek,
                        activeFilters: List.unmodifiable(_activeFilters),
                        onEventChanged: () => setState(() {
                          _updateFilteredDays();
                        }),
                        onNavigateToDate: (target) => scrollToDate(target),
                        onDaySelected: _handleDayTap,
                      );
                    },
                  );
                },
                childCount: _activeFilters.isNotEmpty
                    ? _pastMatchingDays!.length
                    : null,
              ),
            ),

            // Forward Direction: Today & Future Schooldays (0, 1, 2, 3...)
            SliverList(
              key: _centerKey,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final DateTime day = _activeFilters.isNotEmpty
                      ? _futureMatchingDays![index]
                      : scrollCalendarIndexToDate(
                          _centerDate, index, appSettings.workWeek);
                  final bool isStartOfWeek = _activeFilters.isNotEmpty
                      ? _isFirstMatchingDayInWeek(day)
                      : day.weekday == DateTime.monday;

                  return Builder(
                    builder: (ctx) {
                      _dayContexts[day.dayOnly] = ctx;
                      return ScrollCalendarDayRow(
                        key: ValueKey(
                            "future_${day.toIso8601String()}_$_filterVersion"),
                        day: day,
                        topOffset: topOffset,
                        showWeekCard: isStartOfWeek,
                        activeFilters: List.unmodifiable(_activeFilters),
                        onEventChanged: () => setState(() {
                          _updateFilteredDays();
                        }),
                        onNavigateToDate: (target) => scrollToDate(target),
                        onDaySelected: _handleDayTap,
                      );
                    },
                  );
                },
                childCount: _futureMatchingDays?.length,
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: ExpandableCalendarFilterFab(
        activeFilters: _activeFilters,
        onFiltersChanged: () => setState(() {
          _centerDate = _visibleDay.value.dayOnly;
          _updateFilteredDays();
          _filterVersion++;
          _dayContexts.clear();
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0.0);
          }
          if (_futureMatchingDays != null && _futureMatchingDays!.isNotEmpty) {
            _visibleDay.value = _futureMatchingDays!.first;
          }
        }),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
