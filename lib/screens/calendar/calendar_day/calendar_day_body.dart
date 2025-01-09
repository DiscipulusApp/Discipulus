import 'dart:async';

import 'package:collection/collection.dart';
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/isolates.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

class CalendarDayViewBody extends StatefulWidget {
  const CalendarDayViewBody({
    super.key,
    required this.day,
    this.selectedDay,
    this.exampleEvents,
  });

  final DateTime day;
  final ValueNotifier<DateTime>? selectedDay;

  /// When true example event will be used.
  final List<CalendarEvent>? exampleEvents;

  @override
  State<CalendarDayViewBody> createState() => _CalendarDayViewBodyState();
}

class _CalendarDayViewBodyState extends State<CalendarDayViewBody>
    with ChildCallback {
  List<CalendarEvent> events = [];
  List<Assignment> assignments = [];
  List<Activity> activities = [];
  CalendarEvent? nextEvent;
  DateTime? nextFullDate;

  Timer? _timer;

  @override
  Future<void> callback() async {
    await refresh();
  }

  Future<void> setEvents() async {
    events = widget.exampleEvents ??
        await activeProfile.calendarEvents
            .filter()
            .group((q) => q
                .eindeLessThan(widget.day.add(const Duration(days: 1)))
                .or()
                .eindeEqualTo(widget.day.add(const Duration(days: 1))))
            .and()
            .group((q) =>
                q.startGreaterThan(widget.day).or().startEqualTo(widget.day))
            .or()
            .group((q) => q
                .duurtHeleDagEqualTo(true)
                .startLessThan(widget.day)
                .eindeGreaterThan(widget.day.add(const Duration(days: 1))))
            .sortByStart()
            .findAll();
    assignments = await activeProfile.assignments
        .filter()
        .inleverenVoorBetween(
            widget.day, widget.day.add(const Duration(days: 1)))
        .sortByIngeleverdOpDesc()
        .findAll();
    activities = await activeProfile.activities
        .filter()
        .eindeInschrijfdatumBetween(
            widget.day, widget.day.add(const Duration(days: 1)))
        .sortByEindeInschrijfdatum()
        .findAll();
  }

  Future<void> getEvents() async {
    if (mounted) {
      ExternalRefresh.maybyOf(context)?.isLoadingExternally.value = true;
    }
    try {
      await activeProfile.getEvents(
        DateTimeRange(
          start: widget.day,
          end: widget.day.add(const Duration(days: 1)),
        ),
      );
    } catch (e) {
      // Continue
    }
    if (mounted) {
      ExternalRefresh.maybyOf(context)?.isLoadingExternally.value = false;
    }
  }

  Future<void> setNextEvent() async =>
      nextEvent = await activeProfile.calendarEvents
          .filter()
          .startGreaterThan(DateTime.now())
          .duurtHeleDagEqualTo(false)
          .optional(
            !appSettings.showAutoCancelledEvents,
            (q) => q
                .not()
                .statusEqualTo(Status.automaticallyCanceled)
                .or()
                .not()
                .statusEqualTo(Status.manuallyCanceled),
          )
          .sortByStart()
          .limit(5)
          .findFirst();

  Future<DateTime?> nextLessonDate(DateTime dateFrom) async {
    return CustomIsolates<DateTime?>().createisolate((data) async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(data.rootIsolateToken);
      await initIsar(true);
      data.sendPort.send((await activeProfile.calendarEvents
              .filter()
              .startGreaterThan(dateFrom)
              .duurtHeleDagEqualTo(false)
              .optional(
                !appSettings.showAutoCancelledEvents,
                (q) => q
                    .not()
                    .statusEqualTo(Status.automaticallyCanceled)
                    .and()
                    .not()
                    .statusEqualTo(Status.manuallyCanceled),
              )
              .sortByStart()
              .findFirst())
          ?.start);
      await isar.close();
    });
  }

  Future<void> refresh() async {
    await getEvents();
    await setEvents();
    if (mounted) setState(() {});
    if (events.isEmpty) {
      nextFullDate = await nextLessonDate(widget.day);
      if (mounted) setState(() {});
    }
  }

  void onTimer() async {
    if (_timer != null) _timer!.cancel();
    await setNextEvent();
    if (mounted) setState(() {});
    if (nextEvent != null && nextEvent!.start.isAfter(DateTime.now())) {
      _timer = Timer(nextEvent!.start.difference(DateTime.now()), onTimer);
    }
  }

  @override
  void initState() {
    // Start timers and update the events from storage and the API
    onTimer();
    setEvents().then((value) {
      if (mounted) setState(() {});
    });
    super.initState();

    // If the widget is still mounted after 250 miliseconds, we will check for
    // the next date that there are lessons. This is to prevent a metric ton of
    // isolates spawning for no reason.
    Future.delayed(
      const Duration(milliseconds: 250),
      () async {
        if (mounted &&
            widget.day.dayOnly == widget.selectedDay?.value.dayOnly) {
          await refresh();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HandoffFocus(
      onForegroundGained: refresh,
      activity: HandoffActivity.construct(
        title: "Kalender",
        screenType: CalendarDayView,
        extraInfo: {"date": widget.day.toIso8601String()},
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Content
          CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              // Peek at cancelled events button
              if (events.any((e) => e.isCanceled))
                SliverToBoxAdapter(
                  child: AppearAnimation(
                    child: (animation) => FadeTransition(
                      opacity: animation,
                      child: CustomCard(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.cancel_presentation),
                          title: const Text(
                            "Uitgevallen lessen gevonden",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: ElasticAnimation(
                            child: FilledButton(
                              key: ValueKey(
                                  "cancelled${appSettings.showAutoCancelledEvents}"),
                              onPressed: () async {
                                appSettings
                                  ..showAutoCancelledEvents =
                                      !appSettings.showAutoCancelledEvents
                                  ..save();
                                await setNextEvent();
                                setState(() {});
                              },
                              child: Text(
                                appSettings.showAutoCancelledEvents
                                    ? "Verbergen"
                                    : "Spieken",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              for (Assignment assignment in assignments)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AssignmentCalendarTile(assignment: assignment),
                  ),
                ),
              for (Activity activity in activities)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ActivityCalendarTile(activity: activity),
                  ),
                ),
              if (events.isNotEmpty) eventBuilder(),
              if (events.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CustomAnimatedSize(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Whoohoo, geen lessen! 🎉"),
                          ),
                          if (nextFullDate != null &&
                              widget.selectedDay != null)
                            AppearAnimation(
                              child: (animation) => FadeTransition(
                                opacity: animation,
                                child: TextButton.icon(
                                  onPressed: () =>
                                      widget.selectedDay!.value = nextFullDate!,
                                  icon: const Icon(Icons.navigate_next),
                                  label: const Text(
                                      "Ga naar eerstvolgende lesdag"),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(
                child: BottomSheetBottomContentPadding(),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Draws all the events in a special way
  ///
  ///   1. Spaces are inserted when there is a space between lessons.
  ///   2. Double hours that can be combined, will be combined.
  ///   3. Lessons that are smaller than the average lessons length are
  ///      displayed as smaller entries.
  Widget eventBuilder() {
    // Combine events
    List<List<CalendarEvent>> list = events
        .where(
          (e) =>
              appSettings.showAutoCancelledEvents ||
              (!appSettings.showAutoCancelledEvents &&
                  ![Status.automaticallyCanceled, Status.manuallyCanceled]
                      .contains(e.status)),
        )
        .combineEvents();

    // Calculate the average lenth of the events.
    List<int> eventLengths = [];

    for (CalendarEvent event in events) {
      if (!event.duurtHeleDag) {
        eventLengths.add(event.einde.difference(event.start).inMinutes);
      }
    }

    double? averageLength =
        eventLengths.isNotEmpty ? eventLengths.average : null;

    return SliverList.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) {
        if (index != list.length) {
          // Calculate the time between two events
          int height = list.length != index + 1
              ? list[index + 1]
                  .first
                  .start
                  .difference(list[index].last.einde)
                  .inMinutes
              : 0;
          if (height >= 5 && appSettings.showEmptySpaceBetweenLessons) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card.outlined(
                child: SizedBox(
                  width: double.infinity,
                  height: height.clamp(20, 50).toDouble(),
                  child: Center(
                    child: Text(
                      "$height min",
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return const SizedBox();
      },
      itemBuilder: (context, index) {
        int eventDuration = list[index]
            .last
            .einde
            .difference(list[index].first.start)
            .inMinutes;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SimpleDayViewEventTile(
            onTapOverride:
                list[index].every((e) => e.id.isNegative) ? () {} : null,
            callback: () async => await callback(),
            event: list[index],
            // We only want to display a countdown when the event is next
            displayCountdown:
                nextEvent != null && nextEvent!.id == list[index].first.id,
            size: list.length == 1 || list[index].last.duurtHeleDag
                ? null
                : averageLength == null || eventDuration < (averageLength - 5)
                    ? CalendarEventSize.small
                    : eventDuration > (averageLength + 5)
                        ? CalendarEventSize.large
                        : CalendarEventSize.normal,
          ),
        );
      },
    );
  }
}

enum CalendarEventSize { small, normal, large }
