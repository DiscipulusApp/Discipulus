import 'dart:io';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class WeekHeatmap extends StatefulWidget {
  const WeekHeatmap({super.key, this.extraWeeks = 1});

  final int extraWeeks;

  @override
  State<WeekHeatmap> createState() => _WeekHeatmapState();
}

class _WeekHeatmapState extends State<WeekHeatmap> {
  bool showWeekend = !(Platform.isIOS || Platform.isAndroid);

  /// Gets the date from which we will start. This is always on a monday
  DateTime startDate = DateTime.now().dayOnly.subtract(
        Duration(days: (DateTime.now().weekday - 1) + 7),
      );

  late DateTime endDate =
      startDate.add(Duration(days: 7 * (1 + widget.extraWeeks)));

  // Check if there are event in eventData that are during the weekend with a
  // type that is not 0.
  bool eventsInWeekend(List<Map<String, dynamic>> eventData) {
    return [6, 7].contains(DateTime.now().weekday) ||
        eventData.any(
          (e) => ([6, 7].contains(
                  DateTime.fromMicrosecondsSinceEpoch(e["start"]! as int)
                      .weekday) &&
              e["type"] != 0),
        );
  }

  Future<List<Map<String, dynamic>>> _fetchEventData() async {
    final events = await activeProfile.calendarEvents
        .filter()
        .startBetween(startDate, endDate)
        .duurtHeleDagEqualTo(false)
        .and()
        .not()
        .infoTypeEqualTo(InfoType.none)
        .findAll();

    final eventData = events
        .map((event) => {
              'start': event.start.millisecondsSinceEpoch,
              'type': event.infoType.index,
              'isDone': event.afgerond,
            })
        .toList();

    if (eventsInWeekend(eventData)) {
      // Show weekend when there are events in the weekend
      setState(() => showWeekend = true);
    }

    return compute(_processEventData, {
      'eventData': eventData,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchEventData(),
      initialData: List.generate(
          endDate.difference(startDate).inDays,
          (_) => {
                'eventCount': 0,
                'testCount': 0,
                'homeworkCount': 0,
                'doneCount': 0
              }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Table(
          columnWidths: const {
            0: FixedColumnWidth(38),
            1: FlexColumnWidth(),
          },
          children: [
            TableRow(children: [
              const SizedBox.shrink(),
              ...List.generate(
                showWeekend ? 7 : 5,
                (index) => TableCell(
                  child: WeekHeatMapCellHeader(
                    date: startDate.add(Duration(days: index)),
                  ),
                ),
              ),
            ]),
            // Every row is a week
            ...List.generate(
              1 + widget.extraWeeks,
              (index) => TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: WeekHeatMapWeekIndicator(
                        weekNumber: startDate
                            .add(Duration(days: index * 7))
                            .weekNumber),
                  ),
                  ..._weekRow(index, snapshot.data!)
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _weekRow(
      int weekIndex, List<Map<String, dynamic>> processedData) {
    return List.generate(
      showWeekend ? 7 : 5,
      (index) {
        int dayIndex = 7 * weekIndex + index;

        return TableCell(
          child: WeekHeatMapCell(
            date: startDate.add(Duration(days: dayIndex)),
            homeworkCount: processedData[dayIndex]["homeworkCount"],
            testCount: processedData[dayIndex]["testCount"],
            doneCount: processedData[dayIndex]["doneCount"],
          ),
        );
      },
    );
  }
}

List<Map<String, dynamic>> _processEventData(Map<String, dynamic> params) {
  final eventData = params['eventData'] as List<dynamic>;
  final startDate =
      DateTime.fromMillisecondsSinceEpoch(params['startDate'] as int);
  final endDate = DateTime.fromMillisecondsSinceEpoch(params['endDate'] as int);

  final dayCount = endDate.difference(startDate).inDays + 1;
  final processedData = List.generate(
      dayCount,
      (_) => {
            'eventCount': 0,
            'testCount': 0,
            'homeworkCount': 0,
            'doneCount': 0,
          });

  for (final event in eventData) {
    final eventDate =
        DateTime.fromMillisecondsSinceEpoch(event['start'] as int);
    final dayIndex = eventDate.difference(startDate).inDays;
    if (dayIndex >= 0 && dayIndex < dayCount) {
      processedData[dayIndex]['eventCount'] =
          1 + (processedData[dayIndex]['eventCount'] as int);
      if ([
        InfoType.exam.index,
        InfoType.oralExam.index,
        InfoType.writtenExam.index,
        InfoType.test.index
      ].contains(event["type"])) {
        processedData[dayIndex]['testCount'] =
            1 + (processedData[dayIndex]['testCount'] as int);
      }
      if (InfoType.homework.index == event["type"]) {
        String key = event["isDone"] ? 'doneCount' : 'homeworkCount';
        processedData[dayIndex][key] =
            1 + (processedData[dayIndex][key] as int);
      }
    }
  }

  return processedData;
}

class WeekHeatMapCellHeader extends StatefulWidget {
  const WeekHeatMapCellHeader({super.key, required this.date});

  final DateTime date;

  @override
  State<WeekHeatMapCellHeader> createState() => _WeekHeatMapCellHeaderState();
}

class _WeekHeatMapCellHeaderState extends State<WeekHeatMapCellHeader> {
  bool get isElevated {
    return widget.date.weekday == DateTime.now().weekday ||
        widget.date.weekNumber == DateTime.now().weekNumber;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: isElevated
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.primaryContainer,
      child: Center(
          child: Text(
        widget.date.dayNameShort.capitalized,
        style: TextStyle(
          color: isElevated
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      )),
    );
  }
}

class WeekHeatMapWeekIndicator extends StatelessWidget {
  const WeekHeatMapWeekIndicator({super.key, required this.weekNumber});

  final int weekNumber;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: weekNumber == DateTime.now().weekNumber
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Text(
          weekNumber.toString(),
          style: TextStyle(
            color: weekNumber == DateTime.now().weekNumber
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class WeekHeatMapCell extends StatefulWidget {
  const WeekHeatMapCell({
    super.key,
    required this.date,
    this.testCount = 0,
    this.homeworkCount = 0,
    this.doneCount = 0,
  });

  final DateTime date;
  final int testCount;
  final int homeworkCount;
  final int doneCount;

  @override
  State<WeekHeatMapCell> createState() => _WeekHeatMapCellState();
}

class _WeekHeatMapCellState extends State<WeekHeatMapCell> {
  int get elevationFactor {
    return (widget.date.weekday == DateTime.now().weekday ? 1 : 0) +
        (widget.date.weekNumber == DateTime.now().weekNumber ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      elevation: 1 + elevationFactor * 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: widget.date.isToday
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: InkWell(
          onTap: () => CalendarDayView(displayedDay: widget.date).push(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 50),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: SquareGrid(children: [
                ...List.generate(
                    widget.testCount, (_) => _indicatorBuilder(true)),
                ...List.generate(
                    widget.homeworkCount, (_) => _indicatorBuilder()),
                ...List.generate(
                    widget.doneCount, (_) => _indicatorBuilder(false, true))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _indicatorBuilder([bool isTest = false, bool isDone = false]) {
    return CustomCard(
      margin: const EdgeInsets.all(2),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      color: isDone
          ? Theme.of(context).colorScheme.secondaryContainer
          : isTest
              ? Theme.of(context).colorScheme.tertiaryContainer
              : Theme.of(context).colorScheme.primaryContainer,
    );
  }
}

class SquareGrid extends StatelessWidget {
  const SquareGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double size = constraints.maxWidth < constraints.maxHeight
          ? constraints.maxWidth
          : constraints.maxHeight;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGridItem(0, size),
              _buildGridItem(1, size),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGridItem(2, size),
              _buildGridItem(3, size),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildGridItem(int index, double size) {
    if (index < children.length) {
      return SizedBox(
        width: size / 2,
        height: size / 2,
        child: children[index],
      );
    } else {
      return SizedBox(
        width: size / 2,
        height: size / 2,
      );
    }
  }
}
