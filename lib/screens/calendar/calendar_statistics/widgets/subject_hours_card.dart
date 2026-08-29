import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/pages/subject_detail_statistics.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';

enum SubjectSortType { mostHours, leastHours, alphabetical }

extension on SubjectSortType {
  String get toName {
    switch (this) {
      case SubjectSortType.mostHours:
        return "Meeste uren";
      case SubjectSortType.leastHours:
        return "Minste uren";
      case SubjectSortType.alphabetical:
        return "Alfabetisch";
    }
  }
}

class SubjectHoursTile extends StatefulWidget {
  const SubjectHoursTile({
    super.key,
    required this.events,
    this.allEvents,
    this.allSchoolyears,
  });

  final List<CalendarEvent> events;
  final List<CalendarEvent>? allEvents;
  final List<Schoolyear>? allSchoolyears;

  @override
  State<SubjectHoursTile> createState() => _SubjectHoursTileState();
}

class _SubjectHoursTileState extends State<SubjectHoursTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  SubjectSortType _sortType = SubjectSortType.mostHours;
  bool _includeCanceled = false;

  Future<List<BarChartEntry>> _getEntries() async {
    final Map<String, double> subjectHours = {};
    final Map<String, String> subjectFullNames = {};
    final Map<String, String?> subjectShortNames = {};

    for (final e in widget.events) {
      if ((!e.isCanceled || _includeCanceled) && !e.duurtHeleDag) {
        final displayName = e.subject.value?.afkorting.capitalized ??
            e.subject.value?.naam.capitalized ??
            (e.title.isNotEmpty ? e.title.capitalized : "Overig");
        final fullName = e.subject.value?.naam.capitalized ??
            (e.title.isNotEmpty ? e.title.capitalized : "Overig");
        final shortName = e.subject.value?.afkorting ?? e.vakken?.firstOrNull?.naam;

        subjectFullNames[displayName] = fullName;
        subjectShortNames[displayName] = shortName;

        final diff = e.einde.difference(e.start).inMinutes;
        if (diff > 0 && diff <= 600) {
          subjectHours[displayName] =
              (subjectHours[displayName] ?? 0.0) + (diff / 60.0);
        }
      }
    }

    final entriesList = subjectHours.entries.toList();

    switch (_sortType) {
      case SubjectSortType.mostHours:
        entriesList.sort((a, b) => b.value.compareTo(a.value));
        break;
      case SubjectSortType.leastHours:
        entriesList.sort((a, b) => a.value.compareTo(b.value));
        break;
      case SubjectSortType.alphabetical:
        entriesList.sort((a, b) => a.key.compareTo(b.key));
        break;
    }

    final top15 = entriesList.take(15).toList();
    final theme = Theme.of(context);

    final List<BarChartEntry> entries = [];
    for (int i = 0; i < top15.length; i++) {
      final entry = top15[i];
      final subjectName = subjectFullNames[entry.key] ?? entry.key;
      final shortName = subjectShortNames[entry.key];

      entries.add(
        BarChartEntry(
          id: i,
          name: entry.key,
          baseValue: entry.value,
          valueString: (val) => "${val.round()} uur",
          onTap: () {
            SubjectDetailStatisticsScreen(
              subjectName: subjectName,
              subjectShortName: shortName,
              allEvents: widget.allEvents ?? widget.events,
              allSchoolyears: widget.allSchoolyears ?? [],
            ).push(context);
          },
          color: (val) => BarChartColor(
            barColor: theme.colorScheme.primary,
            textColor: theme.colorScheme.onPrimary,
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
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 4),
          child: HorizontalBarchart(
            data: _getEntries,
            minValue: 0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(top: 0, bottom: 0),
          child: FilterChipList(
            chips: [
              DropDownChip<SubjectSortType>(
                defaultIcon: const Icon(Icons.sort),
                currentValue: DropDownChipItem(
                  title: _sortType.toName,
                  item: _sortType,
                ),
                defaultTitle: "Sorteren",
                onSelected: (value) {
                  if (value != null) {
                    setState(() => _sortType = value.item);
                  }
                },
                items: () async => [
                  for (final st in SubjectSortType.values)
                    DropDownChipItem(item: st, title: st.toName),
                ],
              ),
              ToggleChip(
                label: const Text("Inclusief uitval"),
                icon: const Icon(Icons.event_busy),
                initalValue: _includeCanceled,
                onChanged: (value) => setState(() => _includeCanceled = value),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 8),
          child: ListTile(
            dense: true,
            leading: Icon(Icons.info_outline),
            title: Text("Overzicht van alle gevolgde lesuren per vak."),
          ),
        ),
      ],
    );
  }
}
