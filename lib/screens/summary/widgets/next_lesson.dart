import 'dart:async';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class NextLessonTile extends StatefulWidget {
  const NextLessonTile({super.key});

  @override
  State<NextLessonTile> createState() => _NextLessonTileState();
}

class _NextLessonTileState extends State<NextLessonTile> {
  List<CalendarEvent>? nextEvent;
  Timer? _timer;

  Future<void> refresh() async {
    if (_timer != null) _timer!.cancel();
    nextEvent = (await activeProfile.calendarEvents
            .filter()
            .duurtHeleDagEqualTo(false)
            .startGreaterThan(
                DateTime.now().subtract(const Duration(minutes: 5)))
            .group(
              (q) => q
                  .not()
                  .statusBetween(
                      Status.manuallyCanceled, Status.automaticallyCanceled)
                  .and()
                  .not()
                  .rawStatusBetween(
                      Status.manuallyCanceled, Status.automaticallyCanceled),
            )
            .sortByStart()
            .limit(8)
            .findAll())
        .combineEvents()
        .firstOrNull;
    if (mounted) setState(() {});
    if (nextEvent != null) {
      _timer =
          Timer(nextEvent!.first.start.difference(DateTime.now()), refresh);
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return nextEvent != null
        ? SimpleDayViewEventTile(
            key: ValueKey(activeProfile.settings.lastRefresh),
            event: nextEvent!,
            displayCountdown: true,
            onTapOverride: () => Layout.of(context)?.goToPage(
              CalendarDayView(
                displayedDay: nextEvent?.first.start,
              ),
              makeFirst: false,
            ),
          )
        : const SizedBox();
  }
}
