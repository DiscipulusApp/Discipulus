import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';

class SchoolyearHoursCard extends StatelessWidget {
  const SchoolyearHoursCard({
    super.key,
    required this.events,
    required this.schoolyears,
    this.title = "Uren per schooljaar",
    this.subtitle = "Aantal lesuren doorgebracht per schooljaar",
    this.infoText,
  });

  final List<CalendarEvent> events;
  final List<Schoolyear> schoolyears;
  final String title;
  final String subtitle;
  final String? infoText;

  Future<List<BarChartEntry>> _getEntries(BuildContext context) async {
    final theme = Theme.of(context);
    final nonCanceledEvents =
        events.where((e) => !e.isCanceled && !e.duurtHeleDag).toList();

    final List<BarChartEntry> schoolyearEntries = [];
    for (final sy in schoolyears) {
      final syEvents = nonCanceledEvents.where((e) =>
          e.start.isAfter(sy.begin.subtract(const Duration(days: 1))) &&
          e.start.isBefore(sy.einde.add(const Duration(days: 1)))).toList()
        ..sort((a, b) => a.start.compareTo(b.start));

      double syHours = 0.0;
      for (final e in syEvents) {
        final diff = e.einde.difference(e.start).inMinutes;
        if (diff > 0 && diff <= 600) {
          syHours += diff / 60.0;
        }
      }

      if (syHours > 0) {
        final title = sy.groep.omschrijving ?? sy.groep.code;
        final firstLesson = syEvents.firstOrNull;

        schoolyearEntries.add(
          BarChartEntry(
            id: sy.uuid,
            name: title,
            baseValue: syHours,
            valueString: (v) =>
                "${syHours.toStringAsFixed(syHours >= 10 ? 0 : 1)} uur",
            onTap: firstLesson != null
                ? () => CalendarDayView(
                      displayedDay: firstLesson.start,
                    ).push(context)
                : null,
            color: (v) => BarChartColor(
              barColor: theme.colorScheme.primary,
              textColor: theme.colorScheme.onPrimary,
            ),
          ),
        );
      }
    }

    return schoolyearEntries;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HorizontalBarchart(
            data: () => _getEntries(context),
            minValue: 0,
          ),
        ),
        if (infoText != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 8),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.info_outline),
              title: Text(infoText!),
            ),
          ),
      ],
    );
  }
}
