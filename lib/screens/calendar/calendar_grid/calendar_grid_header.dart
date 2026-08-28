import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';

/// Header component combining the week number badge, synchronized PageView of day headers, and the line loader.
class CalendarGridHeader extends StatelessWidget {
  const CalendarGridHeader({
    super.key,
    required this.unifiedBackground,
    required this.timeColWidth,
    required this.weekNumberNotifier,
    required this.isFetchingNotifier,
    required this.headerPageController,
    required this.getDaysForPage,
    required this.onDayTap,
  });

  final Color unifiedBackground;
  final double timeColWidth;
  final ValueNotifier<int> weekNumberNotifier;
  final ValueNotifier<bool> isFetchingNotifier;
  final PageController headerPageController;
  final List<DateTime> Function(int pageIndex) getDaysForPage;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Top Day Header Row
        Container(
          color: unifiedBackground,
          padding: const EdgeInsets.only(top: 2, bottom: 4),
          child: Row(
            children: [
              // Fixed top-left corner showing the week number
              SizedBox(
                width: timeColWidth,
                child: CustomCard(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Center(
                      child: ValueListenableBuilder<int>(
                        valueListenable: weekNumberNotifier,
                        builder: (context, weekNum, _) => Text(
                          "W$weekNum",
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              // Synchronized Day Headers PageView
              Expanded(
                child: SizedBox(
                  height: 58,
                  child: PageView.builder(
                    controller: headerPageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, pageIndex) {
                      final days = getDaysForPage(pageIndex);
                      return DayHeaderRow(
                        days: days,
                        onDayTap: onDayTap,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        // Material 3 line loader overlay at bottom edge of header
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CalendarGridLineLoader(
            isFetchingNotifier: isFetchingNotifier,
          ),
        ),
      ],
    );
  }
}

/// Row of day chips for a single page of days (day names & date circles)
class DayHeaderRow extends StatelessWidget {
  const DayHeaderRow({
    super.key,
    required this.days,
    this.onDayTap,
  });

  final List<DateTime> days;
  final ValueChanged<DateTime>? onDayTap;

  bool _isToday(DateTime d) => d.dayOnly == DateTime.now().dayOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        for (final day in days)
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onDayTap?.call(day),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        day.dayNameShort.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isToday(day)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isToday(day)
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${day.day}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _isToday(day)
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Smoothly retracting LinearProgressIndicator line loader
class CalendarGridLineLoader extends StatelessWidget {
  const CalendarGridLineLoader({
    super.key,
    required this.isFetchingNotifier,
  });

  final ValueNotifier<bool> isFetchingNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: isFetchingNotifier,
      builder: (context, isFetching, _) => ClipRect(
        child: AnimatedAlign(
          alignment: Alignment.topCenter,
          heightFactor: isFetching ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 350),
          curve: isFetching
              ? Easing.emphasizedDecelerate
              : Easing.emphasizedAccelerate,
          child: SizedBox(
            height: 3.0,
            child: LinearProgressIndicator(
              minHeight: 3.0,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
