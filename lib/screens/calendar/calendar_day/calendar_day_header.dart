import 'dart:io';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_work_badges.dart';
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

  int getWeekNumber(DateTime date) => getHeaderWeekNumber(date);

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
          if (!AppPlatform.isMobile) const FixedColumnWidth(52),
          const FlexColumnWidth(),
          if (!AppPlatform.isMobile) const FixedColumnWidth(52)
        ].asMap(),
        children: [
          TableRow(
            children: [
              if (!AppPlatform.isMobile)
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
              if (!AppPlatform.isMobile)
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
        return ValueListenableBuilder<DateTime>(
          valueListenable: widget.selectedDay,
          builder: (context, date, child) => StreamBuilder<void>(
            stream: isar.calendarEvents.watchLazy(),
            builder: (context, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                appSettings.workWeek ? 5 : 7,
                (index) {
                  final day = indexToDate(
                    index + (appSettings.workWeek ? 5 : 7) * pageIndex,
                  );
                  final isVisible = appSettings.workWeek ||
                      (day.weekday <= 5 || date.weekday >= 6);
                  List<CalendarEvent> events;
                  try {
                    events = activeProfile.calendarEvents
                        .filter()
                        .startBetween(day, day.add(const Duration(days: 1)))
                        .findAllSync();
                  } catch (_) {
                    events = [];
                  }

                  final work = CalendarWorkSummary.fromEvents(events);
                  final isSpecial = events.any((event) =>
                      !event.isCanceled &&
                      event.isTest &&
                      (appSettings.coloredFinishedTests || !event.afgerond));

                  return Expanded(
                    flex: isVisible ? 1 : 0,
                    child: CustomAnimatedSize(
                      child: SizedBox(
                        width: isVisible ? null : 0,
                        child: InkWell(
                          onTap: () => widget.selectedDay.value = day,
                          child: DayIndexTile(
                            key: ValueKey(day.toIso8601String()),
                            day: day,
                            selected: day.dayOnly == date.dayOnly,
                            isEmpty: events.isEmpty,
                            isSpecial: isSpecial,
                            work: work,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
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
    this.work = const CalendarWorkSummary(),
  });

  final DateTime day;
  final bool selected;
  final bool isSpecial;
  final bool isEmpty;
  final int? unFinished;
  final CalendarWorkSummary work;

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
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              backgroundColor: containerOnCardColor(context),
              textColor: onContainerOnCardColor(context),
              isLabelVisible: unFinished != null && unFinished != 0,
              label: unFinished != null ? Text(unFinished.toString()) : null,
              alignment: const Alignment(1, 1.5),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: containerOnCardColor(context),
                foregroundColor: onContainerOnCardColor(context),
                child: Text(
                  day.day.toString(),
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              day.dayNameShort.capitalized,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: onCardColor(context),
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 1),
            // Reserve space on all days so the weekday never jumps when
            // homework/test information arrives after a sync.
            SizedBox(
              height: 18,
              child: Center(
                child: CalendarWorkBadges(summary: work, iconSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
