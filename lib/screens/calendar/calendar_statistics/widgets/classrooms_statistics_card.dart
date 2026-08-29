import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';

enum ClassroomMetric { hours, lessons, canceled }

extension on ClassroomMetric {
  String get toName {
    switch (this) {
      case ClassroomMetric.hours:
        return "Lesuren";
      case ClassroomMetric.lessons:
        return "Aantal lessen";
      case ClassroomMetric.canceled:
        return "Uitgevallen lessen";
    }
  }

  IconData get icon {
    switch (this) {
      case ClassroomMetric.hours:
        return Icons.schedule;
      case ClassroomMetric.lessons:
        return Icons.meeting_room_outlined;
      case ClassroomMetric.canceled:
        return Icons.event_busy;
    }
  }
}

class ClassroomsStatisticsCard extends StatefulWidget {
  const ClassroomsStatisticsCard({
    super.key,
    required this.events,
    this.title = "Lokalen statistieken",
  });

  final List<CalendarEvent> events;
  final String title;

  @override
  State<ClassroomsStatisticsCard> createState() =>
      _ClassroomsStatisticsCardState();
}

class _ClassroomsStatisticsCardState extends State<ClassroomsStatisticsCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ClassroomMetric _selectedMetric = ClassroomMetric.hours;
  bool _includeAll = false;

  Future<List<BarChartEntry>> _getEntries() async {
    final Map<String, double> classroomHours = {};
    final Map<String, double> classroomLessons = {};
    final Map<String, double> classroomCanceled = {};

    for (final event in widget.events) {
      String? location = event.lokatie?.trim();
      if (location == null || location.isEmpty) {
        final lokalen = event.lokalen;
        if (lokalen != null && lokalen.isNotEmpty) {
          location = lokalen
              .map((l) => l.naam?.trim())
              .where((s) => s != null && s.isNotEmpty)
              .join(", ");
        }
      }

      if (location == null || location.isEmpty) continue;

      // Clean multiple location strings if comma separated
      final individualLocations =
          location.split(",").map((s) => s.trim()).where((s) => s.isNotEmpty);

      for (final loc in individualLocations) {
        if (!event.isCanceled && !event.duurtHeleDag) {
          final diff = event.einde.difference(event.start).inMinutes;
          if (diff > 0 && diff <= 600) {
            classroomHours[loc] =
                (classroomHours[loc] ?? 0.0) + (diff / 60.0);
          }
          classroomLessons[loc] = (classroomLessons[loc] ?? 0.0) + 1.0;
        }

        if (event.isCanceled) {
          classroomCanceled[loc] = (classroomCanceled[loc] ?? 0.0) + 1.0;
        }
      }
    }

    Map<String, double> metricMap;
    switch (_selectedMetric) {
      case ClassroomMetric.hours:
        metricMap = classroomHours;
        break;
      case ClassroomMetric.lessons:
        metricMap = classroomLessons;
        break;
      case ClassroomMetric.canceled:
        metricMap = classroomCanceled;
        break;
    }

    final sorted = metricMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final theme = Theme.of(context);
    final topList = sorted.take(_includeAll ? sorted.length : 10).toList();
    final List<BarChartEntry> entries = [];

    for (int i = 0; i < topList.length; i++) {
      final entry = topList[i];
      final val = entry.value;
      if (val <= 0) continue;

      String displayVal;
      switch (_selectedMetric) {
        case ClassroomMetric.hours:
          displayVal = "${val.toStringAsFixed(val >= 10 ? 0 : 1)} uur";
          break;
        case ClassroomMetric.lessons:
          displayVal = "${val.toInt()} ${val.toInt() == 1 ? 'les' : 'lessen'}";
          break;
        case ClassroomMetric.canceled:
          displayVal = "${val.toInt()} ${val.toInt() == 1 ? 'les' : 'lessen'}";
          break;
      }

      final roomEvents = widget.events.where((e) {
        final loc = e.lokatie ?? e.lokalen?.map((l) => l.naam).join(", ") ?? "";
        return loc.toLowerCase().contains(entry.key.toLowerCase());
      }).toList()
        ..sort((a, b) => b.start.compareTo(a.start));
      final mostRecentLesson = roomEvents.firstOrNull;

      entries.add(
        BarChartEntry(
          id: entry.key.hashCode,
          name: entry.key,
          baseValue: val,
          valueString: (v) => displayVal,
          onTap: mostRecentLesson != null
              ? () => CalendarDayView(
                    displayedDay: mostRecentLesson.start,
                  ).push(context)
              : null,
          color: (v) => BarChartColor(
            barColor: theme.colorScheme.tertiary,
            textColor: theme.colorScheme.onTertiary,
          ),
        ),
      );
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8),
          child: ListTile(
            dense: true,
            leading: Icon(Icons.info_outline),
            title: Text(
                "Meest bezochte lokalen en ruimtes."),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                DropDownChip<ClassroomMetric>(
                  defaultIcon: Icon(_selectedMetric.icon),
                  defaultTitle: _selectedMetric.toName,
                  currentValue: DropDownChipItem(
                    title: _selectedMetric.toName,
                    item: _selectedMetric,
                  ),
                  items: () async => [
                    for (final metric in ClassroomMetric.values)
                      DropDownChipItem(
                        title: metric.toName,
                        item: metric,
                      ),
                  ],
                  onSelected: (item) {
                    if (item?.item != null) {
                      setState(() {
                        _selectedMetric = item!.item;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ToggleChip(
                  label: const Text("Alles tonen"),
                  initalValue: _includeAll,
                  onChanged: (val) => setState(() {
                    _includeAll = val;
                  }),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(top: 0, bottom: 4),
          child: HorizontalBarchart(
            data: _getEntries,
            minValue: 0,
          ),
        ),
      ],
    );
  }
}
