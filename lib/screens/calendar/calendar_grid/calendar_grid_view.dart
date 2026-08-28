import 'dart:async';
import 'dart:math';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_grid/calendar_grid_header.dart';
import 'package:discipulus/screens/calendar/calendar_grid/calendar_grid_hour_axis.dart';
import 'package:discipulus/screens/calendar/calendar_grid/calendar_grid_page.dart';
import 'package:discipulus/screens/calendar/calendar_schedule.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

/// Available display modes for the grid calendar
enum CalendarGridDisplayMode {
  day(1, "Dag", Icons.calendar_view_day),
  workWeek(5, "Werkweek", Icons.calendar_view_week),
  week(7, "Week", Icons.calendar_view_month);

  const CalendarGridDisplayMode(this.dayCount, this.label, this.icon);
  final int dayCount;
  final String label;
  final IconData icon;
}

/// Multi-column time grid calendar view.
class CalendarGridView extends StatefulWidget {
  const CalendarGridView({
    super.key,
    this.initialDate,
    this.initialMode,
  });

  final DateTime? initialDate;
  final CalendarGridDisplayMode? initialMode;

  @override
  State<CalendarGridView> createState() => _CalendarGridViewState();
}

class _CalendarGridViewState extends State<CalendarGridView> {
  static final DateTime _anchor = DateTime(2020, 1, 6); // Known Monday
  static const double _hourHeight = 60.0; // 1dp per minute
  static const double _timeColWidth = 48.0;

  late CalendarGridDisplayMode _mode;
  late DateTime _selectedDate;
  late PageController _pageController;
  late PageController _headerPageController;
  final ScrollController _verticalScrollController = ScrollController();

  late final ValueNotifier<String> _titleNotifier;
  late final ValueNotifier<bool> _isTodayRangeNotifier;
  late final ValueNotifier<int> _weekNumberNotifier;
  late final ValueNotifier<bool> _isFetchingNotifier;
  late int _lastReportedPage;

  int _dateToPageIndex(DateTime date, CalendarGridDisplayMode mode) {
    final d = DateTime.utc(date.year, date.month, date.day);
    final a = DateTime.utc(_anchor.year, _anchor.month, _anchor.day);
    final days = d.difference(a).inDays;
    switch (mode) {
      case CalendarGridDisplayMode.day:
        return days;
      case CalendarGridDisplayMode.workWeek:
      case CalendarGridDisplayMode.week:
        final mondayOffset = date.weekday - 1;
        final mondayDays = days - mondayOffset;
        return mondayDays ~/ 7;
    }
  }

  List<DateTime> _getDaysForPage(int pageIndex, CalendarGridDisplayMode mode) {
    switch (mode) {
      case CalendarGridDisplayMode.day:
        return [DateTime(_anchor.year, _anchor.month, _anchor.day + pageIndex)];
      case CalendarGridDisplayMode.workWeek:
        final monday =
            DateTime(_anchor.year, _anchor.month, _anchor.day + pageIndex * 7);
        return List.generate(
            5, (i) => DateTime(monday.year, monday.month, monday.day + i));
      case CalendarGridDisplayMode.week:
        final monday =
            DateTime(_anchor.year, _anchor.month, _anchor.day + pageIndex * 7);
        return List.generate(
            7, (i) => DateTime(monday.year, monday.month, monday.day + i));
    }
  }

  CalendarGridDisplayMode get _defaultWeekMode =>
      appSettings.workWeek ? CalendarGridDisplayMode.workWeek : CalendarGridDisplayMode.week;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode ?? _defaultWeekMode;
    _selectedDate = widget.initialDate?.dayOnly ?? DateTime.now().dayOnly;
    final initialPage = _dateToPageIndex(_selectedDate, _mode);
    _lastReportedPage = initialPage;

    _pageController = PageController(initialPage: initialPage);
    _headerPageController = PageController(initialPage: initialPage);

    final initialDays = _getDaysForPage(initialPage, _mode);
    _titleNotifier = ValueNotifier(_formatHeaderTitle(initialDays));
    _isTodayRangeNotifier = ValueNotifier(_isCurrentRangeToday(initialDays));
    _weekNumberNotifier = ValueNotifier(initialDays.first.weekNumber);
    _isFetchingNotifier = ValueNotifier(false);

    // Smart auto-scroll to optimal view showing events overview and now indicator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToOptimalPosition();
    });
  }

  Future<void> _scrollToOptimalPosition() async {
    if (!mounted || !_verticalScrollController.hasClients) return;

    final now = DateTime.now();
    final initialPage = _dateToPageIndex(_selectedDate, _mode);
    final days = _getDaysForPage(initialPage, _mode);
    final isTodayVisible = _isCurrentRangeToday(days);

    final rangeStart =
        DateTime(days.first.year, days.first.month, days.first.day);
    final rangeEnd =
        DateTime(days.last.year, days.last.month, days.last.day + 1);

    // Fetch visible events from Isar
    final events = await activeProfile.calendarEvents
        .filter()
        .group((q) => q.eindeLessThan(rangeEnd).or().eindeEqualTo(rangeEnd))
        .and()
        .group((q) =>
            q.startGreaterThan(rangeStart).or().startEqualTo(rangeStart))
        .findAll();

    if (!mounted || !_verticalScrollController.hasClients) return;

    final timedEvents = events.where((e) => !e.duurtHeleDag).toList();

    double targetOffset;

    if (timedEvents.isNotEmpty) {
      // Find earliest start minute and latest end minute among visible events
      int earliestMinute = 24 * 60;
      int latestMinute = 0;

      for (final e in timedEvents) {
        final startLocal = e.start.toLocal();
        final endLocal = e.einde.toLocal();
        final startMin = startLocal.hour * 60 + startLocal.minute;
        final endMin = endLocal.hour * 60 + endLocal.minute;
        if (startMin < earliestMinute) earliestMinute = startMin;
        if (endMin > latestMinute) latestMinute = endMin;
      }

      final earliestOffset = earliestMinute * (_hourHeight / 60.0);
      final latestOffset = latestMinute * (_hourHeight / 60.0);
      final viewportHeight =
          _verticalScrollController.position.viewportDimension;

      if (isTodayVisible) {
        final nowMinute = now.hour * 60 + now.minute;
        final nowOffset = nowMinute * (_hourHeight / 60.0);

        // Bounding box encompassing both the events and current time with comfortable margins
        final minY = min(earliestOffset - 24.0, nowOffset - 40.0);
        final maxY = max(latestOffset + 24.0, nowOffset + 40.0);
        final totalSpan = maxY - minY;

        if (totalSpan <= viewportHeight) {
          // Everything fits in the viewport: align from top margin so all events and now are visible
          targetOffset = minY;
        } else {
          // Span is larger than screen: keep now visible without centering
          if (nowOffset < earliestOffset) {
            targetOffset = minY;
          } else if (nowOffset > latestOffset) {
            targetOffset = maxY - viewportHeight;
          } else {
            // During middle of day: ensure now is in upper 35% of view
            targetOffset = (nowOffset - viewportHeight * 0.35).clamp(
              minY,
              maxY - viewportHeight,
            );
          }
        }
      } else {
        // Today not in this page: display from top with breathing room
        targetOffset = earliestOffset - 24.0;
      }
    } else {
      // No events: default to current time or morning
      final targetHour = (isTodayVisible && now.hour >= 7 && now.hour <= 19)
          ? now.hour - 1
          : 7;
      targetOffset = targetHour * _hourHeight + 30;
    }

    final clampedOffset = targetOffset.clamp(
      0.0,
      _verticalScrollController.position.maxScrollExtent,
    );

    _verticalScrollController.jumpTo(clampedOffset);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _headerPageController.dispose();
    _verticalScrollController.dispose();
    _titleNotifier.dispose();
    _isTodayRangeNotifier.dispose();
    _weekNumberNotifier.dispose();
    _isFetchingNotifier.dispose();
    super.dispose();
  }

  void _toggleDayWeekMode(DateTime day) {
    setState(() {
      _selectedDate = day.dayOnly;
      if (_mode == CalendarGridDisplayMode.day) {
        _mode = _defaultWeekMode;
      } else {
        _mode = CalendarGridDisplayMode.day;
      }
      final targetPage = _dateToPageIndex(_selectedDate, _mode);
      _lastReportedPage = targetPage;
      final days = _getDaysForPage(targetPage, _mode);
      _titleNotifier.value = _formatHeaderTitle(days);
      _isTodayRangeNotifier.value = _isCurrentRangeToday(days);
      _weekNumberNotifier.value = days.first.weekNumber;
      _pageController.jumpToPage(targetPage);
      if (_headerPageController.hasClients) {
        _headerPageController.jumpToPage(targetPage);
      }
      _scrollToOptimalPosition();
    });
    HapticFeedback.selectionClick();
  }

  void _goToDate(DateTime date) {
    _selectedDate = date.dayOnly;
    final targetPage = _dateToPageIndex(_selectedDate, _mode);
    _lastReportedPage = targetPage;
    final days = _getDaysForPage(targetPage, _mode);
    _titleNotifier.value = _formatHeaderTitle(days);
    _isTodayRangeNotifier.value = _isCurrentRangeToday(days);
    _weekNumberNotifier.value = days.first.weekNumber;
    _pageController.animateToPage(
      targetPage,
      duration: Durations.medium2,
      curve: Easing.emphasizedDecelerate,
    );
    _scrollToOptimalPosition();
  }

  String _formatHeaderTitle(List<DateTime> days) {
    if (days.isEmpty) return "";
    final first = days.first;
    final last = days.last;
    final currentYear = DateTime.now().year;

    if (first.month == last.month) {
      final monthName = DateFormat.MMMM('nl-NL').format(first).capitalized;
      return first.year != currentYear ? "$monthName ${first.year}" : monthName;
    }

    final firstMonth = DateFormat.MMM('nl-NL').format(first).capitalized;
    final lastMonth = DateFormat.MMM('nl-NL').format(last).capitalized;
    if (first.year != last.year) {
      return "$firstMonth ${first.year} - $lastMonth ${last.year}";
    }
    return first.year != currentYear
        ? "$firstMonth - $lastMonth ${first.year}"
        : "$firstMonth - $lastMonth";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unifiedBackground = ElevationOverlay.applySurfaceTint(
      theme.colorScheme.surface,
      theme.colorScheme.surfaceTint,
      1,
    );

    return Scaffold(
      backgroundColor: unifiedBackground,
      appBar: AppBar(
        backgroundColor: unifiedBackground,
        surfaceTintColor: Colors.transparent,
        leading: leadingAppBarButton(context),
        title: ValueListenableBuilder<String>(
          valueListenable: _titleNotifier,
          builder: (context, title, _) => Text(title),
        ),
        actions: [
          // Jump to Today
          ValueListenableBuilder<bool>(
            valueListenable: _isTodayRangeNotifier,
            builder: (context, isToday, _) => isToday
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: "Vandaag",
                    icon: const Icon(Icons.today),
                    onPressed: () => _goToDate(DateTime.now()),
                  ),
          ),
          // Date picker
          IconButton(
            tooltip: "Kies datum",
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (picked != null) _goToDate(picked);
            },
          ),
          // Add Event
          IconButton(
            tooltip: "Toevoegen",
            icon: const Icon(Icons.add),
            onPressed: () async {
              final date = await showScheduleSheet(context);
              if (date != null) {
                _goToDate(date);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Sticky Top Day Header Component
          CalendarGridHeader(
            unifiedBackground: unifiedBackground,
            timeColWidth: _timeColWidth,
            weekNumberNotifier: _weekNumberNotifier,
            isFetchingNotifier: _isFetchingNotifier,
            headerPageController: _headerPageController,
            getDaysForPage: (pageIndex) => _getDaysForPage(pageIndex, _mode),
            onDayTap: _toggleDayWeekMode,
          ),
          // 2. Main Scrollable 24-Hour Time Grid
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // Keep the header PageView perfectly in sync with user swipe interactions in real-time
                if (notification.metrics.axis == Axis.horizontal) {
                  if (notification is ScrollUpdateNotification) {
                    if (_pageController.hasClients &&
                        _headerPageController.hasClients) {
                      _headerPageController.position
                          .correctPixels(_pageController.position.pixels);
                      _headerPageController.position.notifyListeners();
                    }
                  } else if (notification is ScrollEndNotification) {
                    final currentPage = (_pageController.page ?? 0).round();
                    if (_lastReportedPage != currentPage) {
                      _lastReportedPage = currentPage;
                      HapticFeedback.selectionClick();
                    }
                    _selectedDate =
                        _getDaysForPage(currentPage, _mode).first.dayOnly;
                    final days = _getDaysForPage(currentPage, _mode);
                    _titleNotifier.value = _formatHeaderTitle(days);
                    _isTodayRangeNotifier.value = _isCurrentRangeToday(days);
                    _weekNumberNotifier.value = days.first.weekNumber;
                  }
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                child: SizedBox(
                  height: 24 * _hourHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sticky Left Hour Labels Axis
                      HourAxis(
                        hourHeight: _hourHeight,
                        width: _timeColWidth,
                      ),
                      const SizedBox(width: 2),
                      // Horizontal PageView of Day Columns
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (pageIndex) {
                            if (_lastReportedPage != pageIndex) {
                              _lastReportedPage = pageIndex;
                              HapticFeedback.selectionClick();
                            }
                          },
                          itemBuilder: (context, pageIndex) {
                            final days = _getDaysForPage(pageIndex, _mode);
                            return GridDayColumnsPage(
                              key: ValueKey("page_${_mode.name}_$pageIndex"),
                              days: days,
                              hourHeight: _hourHeight,
                              onLoadingChanged: (loading) {
                                _isFetchingNotifier.value = loading;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentRangeToday(List<DateTime> days) {
    final today = DateTime.now().dayOnly;
    return days.any((d) => d.dayOnly == today);
  }
}
