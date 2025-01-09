import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';

class EventHeatmap extends StatelessWidget {
  final Isar isar;
  final DateTime startDate;
  final DateTime endDate;

  const EventHeatmap({
    super.key,
    required this.isar,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchEventData(),
      initialData: List.generate(
          endDate.difference(startDate).inDays,
          (_) => {
                'eventCount': 0,
                'isSpecial': false,
              }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return _buildHeatmap(context, snapshot.data!);
      },
    );
  }

  Widget _buildHeatmap(
      BuildContext context, List<Map<String, dynamic>> processedData) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final weekCount = ((endDate.difference(startDate).inDays + 1) / 7).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        const double cellSize = 20;
        //constraints.maxWidth / 4 / 8; // 7 days + 1 column for labels
        return Stack(
          children: [
            SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: cellSize), // Space for fixed column
                  ...List.generate(weekCount, (weekIndex) {
                    return Column(
                      children: [
                        _buildWeekHeader(context, weekIndex, cellSize),
                        _buildWeekColumn(context, processedData, weekIndex,
                            colorScheme, today, cellSize),
                      ],
                    );
                  }),
                ],
              ),
            ),
            _buildFixedLabels(context, cellSize),
          ],
        );
      },
    );
  }

  Widget _buildFixedLabels(BuildContext context, double cellSize) {
    final textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 12,
    );
    return Column(
      children: [
        Cell(cellSize: cellSize), // Space for week number
        ...['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) => Cell(
              cellSize: cellSize,
              child: Center(
                child: Text(day, style: textStyle),
              ),
            )),
      ],
    );
  }

  Widget _buildWeekHeader(
      BuildContext context, int weekIndex, double cellSize) {
    final weekStart = startDate.add(Duration(days: weekIndex * 7));
    final weekNumber = weekStart.weekNumber;
    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: Center(
        child: Text(
          '$weekNumber',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildWeekColumn(
      BuildContext context,
      List<Map<String, dynamic>> processedData,
      int weekIndex,
      ColorScheme colorScheme,
      DateTime today,
      double cellSize) {
    final weekStart = startDate.add(Duration(days: weekIndex * 7));
    final firstDayOffset = weekStart.weekday - 1; // 0 for Monday, 6 for Sunday

    return Column(
      children: List.generate(7, (dayIndex) {
        final date = weekStart
            .subtract(Duration(days: firstDayOffset))
            .add(Duration(days: dayIndex));
        final dataIndex = date.difference(startDate).inDays;

        if (dataIndex < 0 || dataIndex >= processedData.length) {
          return Container(
            height: cellSize,
            width: cellSize,
            margin: const EdgeInsets.all(1),
          );
        }

        final dayData = processedData[dataIndex];

        Color cellColor = colorScheme.surfaceContainerHighest;
        if (dayData['eventCount'] > 0) {
          cellColor =
              dayData['isSpecial'] ? colorScheme.tertiary : colorScheme.primary;
          final opacity = (0.3 + (dayData['eventCount'] * 0.1)).clamp(0.0, 1.0);
          cellColor = cellColor.withValues(alpha: opacity);
        }

        return Cell(
          cellSize: cellSize,
          color: cellColor,
          date: date,
        );
      }),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchEventData() async {
    final events = await isar.calendarEvents
        .filter()
        .startBetween(startDate, endDate)
        .duurtHeleDagEqualTo(false)
        .and()
        .not()
        .statusBetween(Status.automaticallyCanceled, Status.manuallyCanceled)
        .not()
        .infoTypeEqualTo(InfoType.none)
        .findAll();

    final eventData = events
        .map((event) => {
              'start': event.start.millisecondsSinceEpoch,
              'type': event.infoType.index,
            })
        .toList();

    return compute(_processEventData, {
      'eventData': eventData,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    });
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
            'isSpecial': false,
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
        processedData[dayIndex]['isSpecial'] = true;
      }
    }
  }

  return processedData;
}

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.cellSize,
    this.color,
    this.date,
    this.child,
  });

  final double cellSize;
  final Color? color;
  final DateTime? date;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.short3,
      curve: Easing.standard,
      width: cellSize,
      height: cellSize,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        border: date?.isToday ?? false
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        child: child,
        onTap: () => CalendarDayView(
          displayedDay: date,
        ).push(context),
      ),
    );
  }
}

// // Add this extension method for getting the week of year
// extension DateTimeExtension on DateTime {
//   int get weekOfYear {
//     final firstDayOfYear = DateTime(year, 1, 1);
//     final daysOffset = firstDayOfYear.weekday - 1;
//     final firstMondayOfYear = firstDayOfYear.subtract(Duration(days: daysOffset));
//     final diffInDays = difference(firstMondayOfYear).inDays;
//     return (diffInDays / 7).floor() + 1;
//   }
// }
