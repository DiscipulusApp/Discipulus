import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

/// Upcoming tests from the locally cached Magister agenda.
class UpcomingTestsTile extends StatelessWidget {
  const UpcomingTestsTile({super.key});

  Future<List<CalendarEvent>> _load() async {
    final now = DateTime.now();
    final events = await activeProfile.calendarEvents
        .filter()
        .startBetween(now, now.add(const Duration(days: 21)))
        .sortByStart()
        .findAll();
    return events
        .where((event) => InfoType.tests.contains(event.infoType) && !event.isCanceled)
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CalendarEvent>>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Toetsen konden niet worden geladen.'),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          );
        }
        final tests = snapshot.data!;
        if (tests.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Geen toetsen in de komende drie weken.'),
          );
        }
        return Column(
          children: [
            for (final event in tests)
              ListTile(
                leading: const Icon(Icons.event_note_outlined),
                title: Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${event.infoType.toName} · '
                    '${MaterialLocalizations.of(context).formatShortDate(event.start)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Layout.of(context)?.goToPage(
                  CalendarDayView(displayedDay: event.start),
                  makeFirst: false,
                ),
              ),
          ],
        );
      },
    );
  }
}
