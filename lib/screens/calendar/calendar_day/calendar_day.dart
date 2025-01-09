import 'package:discipulus/core/routes.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_body.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_header.dart';
import 'package:discipulus/screens/calendar/calendar_schedule.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

DateTime indexToDate(int index) {
  if (appSettings.workWeek) {
    // Calculate the actual date, accounting for skipped weekends
    int daysToAdd = (index ~/ 5) * 7 + (index % 5) + 1;
    return DateTime(1970, 01, 04).add(Duration(days: daysToAdd));
  } else {
    return DateTime(1970, 01, 04).add(Duration(days: index));
  }
}

int dateToIndex(DateTime date) {
  DateTime day = date.dayOnly;
  if (appSettings.workWeek) {
    // Calculate the index, accounting for skipped weekends
    int daysSince = day.difference(DateTime(1970, 01, 04)).inDays;
    int weekNumber = daysSince ~/ 7;
    int dayOfWeek = day.weekday - 1; // 0 = Monday, 4 = Friday
    return weekNumber * 5 + (dayOfWeek > 4 ? 4 : dayOfWeek);
  } else {
    return day.difference(DateTime(1970, 01, 04)).inDays;
  }
}

/// Shows a dayview of the calendar
class CalendarDayView extends StatefulWidget {
  const CalendarDayView({super.key, this.displayedDay});

  /// If this value is null, then the current date will be used.
  final DateTime? displayedDay;

  @override
  State<CalendarDayView> createState() => _CalendarDayViewState();
}

class _CalendarDayViewState extends State<CalendarDayView>
    with ExternalRefresh {
  late final PageController pageViewContoller;
  late final ValueNotifier<DateTime> selectedDay;

  /// Is used to check if the pageview is animating to a new page or not.
  /// When this is not used onPageChanged will fire multiple times, making it
  /// impossible to scroll to pages that are further away.
  bool isAnimating = false;

  /// Is used to check if the pageChange was caused by a drag from the pageview.
  /// If this is that case then the animation should not fire.
  bool isFromDrag = false;

  /// When the selected day changes the pageview should respond
  void dateListener() async {
    isAnimating = true;
    if (!isFromDrag) {
      await pageViewContoller.animateToPage(
        dateToIndex(selectedDay.value),
        duration: Durations.medium4,
        curve: Easing.emphasizedDecelerate,
      );
    }
    isAnimating = false;
  }

  @override
  void initState() {
    selectedDay = ValueNotifier(widget.displayedDay ?? DateTime.now());
    pageViewContoller =
        PageController(initialPage: dateToIndex(selectedDay.value));
    selectedDay.addListener(dateListener);
    super.initState();
  }

  @override
  void dispose() {
    selectedDay.removeListener(dateListener);
    selectedDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: ValueListenableBuilder<bool>(
              valueListenable: isLoadingExternally,
              builder: (context, loading, child) {
                return ValueListenableBuilder(
                  valueListenable: selectedDay,
                  builder: (context, date, child) => SliverAppBar(
                    leading: leadingAppBarButton(context),
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    title:
                        Text("${date.formattedDate}, Week ${date.weekNumber}"),
                    actions: [
                      if (loading)
                        AnimatedSwitcher(
                          duration: Durations.short3,
                          switchInCurve: Easing.standard,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                          child: IconButton(
                            key: ValueKey(loading),
                            onPressed: () {},
                            icon: loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      if (date.dayOnly != DateTime.now().dayOnly)
                        IconButton(
                          onPressed: () async =>
                              selectedDay.value = DateTime.now(),
                          icon: const Icon(Icons.today),
                        ),
                      IconButton(
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            currentDate: DateTime.now(),
                            initialDate: appSettings.workWeek &&
                                    selectedDay.value.weekday > 5
                                ? null
                                : selectedDay.value,
                            firstDate: DateTime(1970, 01, 05),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 2),
                            ),
                            selectableDayPredicate: (DateTime day) {
                              if (appSettings.workWeek) {
                                return day.weekday <= 5;
                              }
                              return true;
                            },
                          );
                          // If the selected date is a day, go to that day
                          if (date != null) selectedDay.value = date;
                        },
                        icon: const Icon(Icons.date_range),
                      ),
                      IconButton(
                        onPressed: () async {
                          DateTime? date = await showScheduleSheet(context);
                          if (date != null) {
                            selectedDay.value = date;
                          }
                        },
                        icon: const Icon(Icons.add),
                      )
                    ],
                    bottom: child! as PreferredSizeWidget,
                  ),
                  child: BottomDaySelectHeader(
                    selectedDay: selectedDay,
                  ),
                );
              },
            ),
          ),
        ],
        body: PageView.builder(
          controller: pageViewContoller,
          onPageChanged: (index) {
            isFromDrag = true;
            if (!isAnimating) {
              selectedDay.value = indexToDate(index);
            }
            HapticFeedback.selectionClick();
            isFromDrag = false;
          },
          itemBuilder: (context, index) {
            DateTime day = indexToDate(index);

            return CalendarDayViewBody(
              day: day,
              selectedDay: selectedDay,
            );
          },
        ),
      ),
    );
  }
}
