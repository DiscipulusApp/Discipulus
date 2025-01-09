import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:flutter/material.dart';

class OncomingSpecialEventTile extends StatelessWidget {
  const OncomingSpecialEventTile({
    super.key,
    required this.events,
    this.showHomework = true,
    this.showTests = true,
  });

  final List<CalendarEvent> events;
  final bool showHomework;
  final bool showTests;

  @override
  Widget build(BuildContext context) {
    Iterable<CalendarEvent> specialEvents = events.where((e) =>
        (showHomework && e.infoType == InfoType.homework) ||
        (showTests && e.isTest));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (CalendarEvent event in specialEvents)
            OncomingSpecialEventSubtile(event: event)
        ],
      ),
    );
  }
}

class OncomingSpecialEventSubtile extends StatefulWidget {
  const OncomingSpecialEventSubtile({super.key, required this.event});

  final CalendarEvent event;

  @override
  State<OncomingSpecialEventSubtile> createState() =>
      _OncomingSpecialEventSubtileState();
}

class _OncomingSpecialEventSubtileState
    extends State<OncomingSpecialEventSubtile> {
  /// Whether or not the name of the subject should be shown. This is not really
  /// needed when only one subject is displayed, but sometimes, when multiple
  /// subjects are mixed, this does make sense.
  final showSubjectName = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showCalendarEventDetailsSheet(
        context,
        events: [widget.event],
        callback: () => setState(() {}),
      ),
      child: Card.outlined(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: CircleAvatar(
                backgroundColor: widget.event.isTest
                    ? Theme.of(context).colorScheme.tertiaryContainer
                    : null,
                foregroundColor: widget.event.isTest
                    ? Theme.of(context).colorScheme.onTertiaryContainer
                    : null,
                child: Text(
                  widget.event.infoType.toShort,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showSubjectName
                        ? widget.event.title
                        : widget.event.infoType.toName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  CountDownWidget(
                    countDownTime: widget.event.start,
                    builder: (duration) => Text(
                      "${duration.time} ${duration.unit}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
