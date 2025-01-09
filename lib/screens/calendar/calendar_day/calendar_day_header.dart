import 'dart:io';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class BottomDaySelectHeader extends StatefulWidget
    implements PreferredSizeWidget {
  const BottomDaySelectHeader({
    super.key,
    required this.selectedDay,
  });

  final ValueNotifier<DateTime> selectedDay;

  @override
  State<BottomDaySelectHeader> createState() => _BottomDaySelectHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _BottomDaySelectHeaderState extends State<BottomDaySelectHeader> {
  late final PageController pageviewController;

  void dateListener() {
    // When the date changes, change the selected day too
    pageviewController.animateToPage(
      getWeekNumber(widget.selectedDay.value),
      duration: Durations.medium1,
      curve: Easing.standard,
    );
  }

  int getWeekNumber(DateTime date) {
    return appSettings.workWeek
        ? (dateToIndex(date.add(const Duration(days: 1))) ~/ 5)
        : (dateToIndex(date) ~/ 7);
  }

  @override
  void initState() {
    pageviewController = PageController(
      initialPage: getWeekNumber(widget.selectedDay.value),
    );
    super.initState();
    widget.selectedDay.addListener(dateListener);
  }

  @override
  void didUpdateWidget(BottomDaySelectHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay) {
      oldWidget.selectedDay.removeListener(dateListener);
      widget.selectedDay.addListener(dateListener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.selectedDay.removeListener(dateListener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Table(
        columnWidths: [
          if (!(Platform.isAndroid || Platform.isIOS))
            const FixedColumnWidth(52),
          const FlexColumnWidth(),
          if (!(Platform.isAndroid || Platform.isIOS))
            const FixedColumnWidth(52)
        ].asMap(),
        children: [
          TableRow(
            children: [
              if (!(Platform.isAndroid || Platform.isIOS))
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton.filledTonal(
                      onPressed: () => pageviewController.previousPage(
                        duration: Durations.short3,
                        curve: Easing.standard,
                      ),
                      icon: const Icon(Icons.navigate_before),
                    ),
                  ),
                ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 80),
                child: pageviewBuilder(context),
              ),
              if (!(Platform.isAndroid || Platform.isIOS))
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton.filledTonal(
                      onPressed: () => pageviewController.nextPage(
                        duration: Durations.short3,
                        curve: Easing.standard,
                      ),
                      icon: const Icon(Icons.navigate_next),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageviewBuilder(BuildContext context) {
    return PageView.builder(
      controller: pageviewController,
      itemBuilder: (context, pageIndex) {
        return ValueListenableBuilder(
          valueListenable: widget.selectedDay,
          builder: (context, date, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                appSettings.workWeek ? 5 : 7,
                (index) {
                  // Get date that should be drawn
                  DateTime day = indexToDate(
                      index + (appSettings.workWeek ? 5 : 7) * pageIndex);

                  bool isVisible = appSettings.workWeek ||
                      (!appSettings.workWeek &&
                          (day.weekday <= 5 || date.weekday >= 6));

                  // Draw widget
                  return Expanded(
                    flex: isVisible ? 1 : 0,
                    child: CustomAnimatedSize(
                      child: SizedBox(
                        width: isVisible ? null : 0,
                        child: InkWell(
                          onTap: () => widget.selectedDay.value = day,
                          child: FutureBuilder(
                            future: Future(() async {
                              // Check if a day contains a test
                              List<CalendarEvent> events = await activeProfile
                                  .calendarEvents
                                  .filter()
                                  .startBetween(
                                      day, day.add(const Duration(days: 1)))
                                  .findAll();
                              return {
                                "count": events.length,
                                "isSpecial": events
                                    // If this setting has been turned on, we
                                    // will only show the special indicator if
                                    // the  event is not yet marked as done
                                    .where(
                                      (e) =>
                                          appSettings.coloredFinishedTests ||
                                          (!appSettings.coloredFinishedTests &&
                                              !e.afgerond),
                                    )
                                    .map((e) => e.infoType.index)
                                    .any(
                                      (index) => [2, 3, 4, 5].contains(index),
                                    ),
                              };
                            }),
                            builder: (context, snapshot) {
                              return DayIndexTile(
                                key: ValueKey(day.toIso8601String()),
                                day: day,
                                selected: day.dayOnly == date.dayOnly,
                                isEmpty: snapshot.hasData &&
                                    snapshot.data!["count"] == 0,
                                isSpecial: snapshot.hasData &&
                                    snapshot.data!["isSpecial"] == true,
                                unFinished:
                                    snapshot.data?["unfinished"] as int?,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class DayIndexTile extends StatelessWidget {
  const DayIndexTile({
    super.key,
    required this.day,
    this.selected = false,
    this.isSpecial = false,
    this.isEmpty = false,
    this.unFinished,
  });

  final DateTime day;
  final bool selected;
  final bool isSpecial;
  final bool isEmpty;
  final int? unFinished;

  Color? cardColor(context) {
    return selected
        ? isSpecial
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.secondaryContainer
        : null;
  }

  Color? onCardColor(context) {
    return selected
        ? isSpecial
            ? Theme.of(context).colorScheme.onTertiaryContainer
            : Theme.of(context).colorScheme.onSecondaryContainer
        : null;
  }

  Color? containerOnCardColor(context) {
    return (selected || day.dayOnly == DateTime.now().dayOnly)
        ? isSpecial
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.primary
        : isSpecial
            ? Theme.of(context).colorScheme.tertiaryContainer
            : isEmpty
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Theme.of(context).colorScheme.primaryContainer;
  }

  Color? onContainerOnCardColor(context) {
    return (selected || day.dayOnly == DateTime.now().dayOnly)
        ? isSpecial
            ? Theme.of(context).colorScheme.onTertiary
            : Theme.of(context).colorScheme.onPrimary
        : isSpecial
            ? Theme.of(context).colorScheme.onTertiaryContainer
            : isEmpty
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onPrimaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: cardColor(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 4,
          spacing: 2,
          children: [
            Badge(
              backgroundColor: containerOnCardColor(context),
              textColor: onContainerOnCardColor(context),
              isLabelVisible: unFinished != null && unFinished != 0,
              label: unFinished != null ? Text(unFinished.toString()) : null,
              alignment: const Alignment(1, 1.5),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: containerOnCardColor(context),
                foregroundColor: onContainerOnCardColor(context),
                child: Text(
                  day.day.toString(),
                  maxLines: 1,
                ),
              ),
            ),
            SizedBox(
              width: 35,
              child: Center(
                child: Text(
                  day.dayNameShort.capitalized,
                  maxLines: 1,
                  style: TextStyle(
                    color: onCardColor(context),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
