import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/pages/teacher_detail_statistics.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';

enum TeacherMetric { hours, homework, canceled }

extension on TeacherMetric {
  String get toName {
    switch (this) {
      case TeacherMetric.hours:
        return "Lesuren";
      case TeacherMetric.homework:
        return "Huiswerk opgegeven";
      case TeacherMetric.canceled:
        return "Uitgevallen lessen";
    }
  }

  IconData get icon {
    switch (this) {
      case TeacherMetric.hours:
        return Icons.schedule;
      case TeacherMetric.homework:
        return Icons.assignment_outlined;
      case TeacherMetric.canceled:
        return Icons.event_busy;
    }
  }
}

class TeacherStatisticsCard extends StatefulWidget {
  const TeacherStatisticsCard({
    super.key,
    required this.events,
    this.allEvents,
    this.allSchoolyears,
  });

  final List<CalendarEvent> events;
  final List<CalendarEvent>? allEvents;
  final List<Schoolyear>? allSchoolyears;

  @override
  State<TeacherStatisticsCard> createState() => _TeacherStatisticsCardState();
}

class _TeacherStatisticsCardState extends State<TeacherStatisticsCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TeacherMetric _selectedMetric = TeacherMetric.hours;
  bool _includeAllTeachers = false;
  bool _metricPerHour = true;

  Future<List<BarChartEntry>> _getEntries() async {
    final Map<String, double> teacherHours = {};
    final Map<String, double> teacherTotalLessons = {};
    final Map<String, double> teacherHomeworkCount = {};
    final Map<String, double> teacherCanceledCount = {};
    final Map<String, String> teacherFullNames = {};
    final Map<String, String?> teacherCodes = {};

    for (final event in widget.events) {
      final docenten = event.docenten;
      if (docenten == null || docenten.isEmpty) continue;

      for (final docent in docenten) {
        final displayName = docent.docentcode ?? docent.naam?.trim() ?? "";
        if (displayName.isEmpty) continue;

        final fullName = docent.naam?.trim() ?? displayName;
        final code = docent.docentcode;

        teacherFullNames[displayName] = fullName;
        teacherCodes[displayName] = code;

        teacherTotalLessons[displayName] =
            (teacherTotalLessons[displayName] ?? 0.0) + 1.0;

        // Get hours for teacher
        if (!event.isCanceled && !event.duurtHeleDag) {
          final diff = event.einde.difference(event.start).inMinutes;
          if (diff > 0 && diff <= 600) {
            teacherHours[displayName] =
                (teacherHours[displayName] ?? 0.0) + (diff / 60.0);
          }
        }

        if (event.infoType == InfoType.homework ||
            (event.inhoud != null &&
                event.inhoud!.isNotEmpty &&
                !event.isTest)) {
          teacherHomeworkCount[displayName] =
              (teacherHomeworkCount[displayName] ?? 0.0) + 1.0;
        }

        if (event.isCanceled) {
          teacherCanceledCount[displayName] =
              (teacherCanceledCount[displayName] ?? 0.0) + 1.0;
        }
      }
    }

    final Map<String, double> teacherValues = {};

    final allTeacherNames = {
      ...teacherHours.keys,
      ...teacherHomeworkCount.keys,
      ...teacherCanceledCount.keys,
    };

    for (final name in allTeacherNames) {
      final hours = teacherHours[name] ?? 0.0;
      final homework = teacherHomeworkCount[name] ?? 0.0;
      final canceled = teacherCanceledCount[name] ?? 0.0;
      final totalLessons = teacherTotalLessons[name] ?? 0.0;

      switch (_selectedMetric) {
        case TeacherMetric.hours:
          teacherValues[name] = hours;
          break;
        case TeacherMetric.homework:
          if (_metricPerHour) {
            // Number of homework assignments given per taught hour
            teacherValues[name] = hours > 0 ? (homework / hours) : 0.0;
          } else {
            teacherValues[name] = homework;
          }
          break;
        case TeacherMetric.canceled:
          if (_metricPerHour) {
            // Cancellation rate percentage
            final total = totalLessons > 0 ? totalLessons : (hours + canceled);
            teacherValues[name] = total > 0 ? (canceled / total) * 100 : 0.0;
          } else {
            teacherValues[name] = canceled;
          }
          break;
      }
    }

    final sorted = teacherValues.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final theme = Theme.of(context);
    final top10 =
        sorted.take(_includeAllTeachers ? sorted.length : 10).toList();
    final List<BarChartEntry> entries = [];

    for (int i = 0; i < top10.length; i++) {
      final entry = top10[i];
      final teacherName = teacherFullNames[entry.key] ?? entry.key;
      final teacherCode = teacherCodes[entry.key];

      entries.add(
        BarChartEntry(
          id: i,
          name: entry.key,
          baseValue: entry.value,
          valueString: (val) {
            switch (_selectedMetric) {
              case TeacherMetric.hours:
                return "${val.toStringAsFixed(val >= 10 ? 0 : 1)} uur";
              case TeacherMetric.homework:
                return _metricPerHour
                    ? "${val.toStringAsFixed(2)}x / uur"
                    : "${val.round()}x opgegeven";
              case TeacherMetric.canceled:
                return _metricPerHour
                    ? "${val.toStringAsFixed(1)}%"
                    : "${val.round()} ${val.round() == 1 ? 'les' : 'lessen'}";
            }
          },
          onTap: () {
            TeacherDetailStatisticsScreen(
              teacherName: teacherName,
              teacherCode: teacherCode,
              allEvents: widget.allEvents ?? widget.events,
              allSchoolyears: widget.allSchoolyears ?? [],
            ).push(context);
          },
          color: (val) {
            Color barColor;
            switch (_selectedMetric) {
              case TeacherMetric.hours:
                barColor = theme.colorScheme.primary;
                break;
              case TeacherMetric.homework:
                barColor = theme.colorScheme.secondary;
                break;
              case TeacherMetric.canceled:
                barColor = theme.colorScheme.error;
                break;
            }
            return BarChartColor(
              barColor: barColor,
              textColor: theme.colorScheme.onPrimary,
            );
          },
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8),
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.info_outline),
            title: Text(
              _selectedMetric == TeacherMetric.hours
                  ? "Ranglijst van docenten op basis van aantal lesuren. Tik op een docent voor details."
                  : (_metricPerHour
                      ? "Ranglijst van docenten relatief per lesuur / percentage. Tik op een docent voor details."
                      : "Ranglijst van docenten op basis van totaal aantal. Tik op een docent voor details."),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(top: 0, bottom: 0),
          child: FilterChipList(
            chips: [
              DropDownChip<TeacherMetric>(
                defaultIcon: Icon(_selectedMetric.icon),
                currentValue: DropDownChipItem(
                  title: _selectedMetric.toName,
                  item: _selectedMetric,
                  icon: Icon(_selectedMetric.icon),
                ),
                defaultTitle: "Categorie",
                onSelected: (value) {
                  if (value != null) {
                    setState(() => _selectedMetric = value.item);
                  }
                },
                items: () async => [
                  for (final metric in TeacherMetric.values)
                    DropDownChipItem(
                      item: metric,
                      title: metric.toName,
                      icon: Icon(metric.icon),
                    ),
                ],
              ),
              FilterChip(
                label: Text(_selectedMetric == TeacherMetric.canceled
                    ? "Percentage uitval"
                    : "Per lesuur"),
                selected: _selectedMetric == TeacherMetric.hours
                    ? false
                    : _metricPerHour,
                onSelected: _selectedMetric == TeacherMetric.hours
                    ? null
                    : (value) {
                        setState(() => _metricPerHour = value);
                      },
              ),
              FilterChip(
                label: const Text("Alle docenten"),
                selected: _includeAllTeachers,
                onSelected: (value) {
                  setState(() => _includeAllTeachers = value);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 4),
          child: HorizontalBarchart(
            data: _getEntries,
            minValue: 0,
          ),
        ),
      ],
    );
  }
}
