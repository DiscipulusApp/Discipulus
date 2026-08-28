import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:flutter/material.dart';

/// Card representing a single combined event on the time grid
class TimeGridEventCard extends StatelessWidget {
  const TimeGridEventCard({
    super.key,
    required this.events,
    required this.height,
    required this.onRefresh,
  });

  final List<CalendarEvent> events;
  final double height;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCanceled = events.every((e) => e.isCanceled);
    final isDone = events.every((e) => e.afgerond);
    final isTest = events.any((e) => e.isTest);
    final hasHomework = events.any((e) =>
        e.infoType == InfoType.homework ||
        (e.inhoud != null && e.inhoud!.trim().isNotEmpty && !e.isTest));

    final showTestColor =
        isTest && (!isDone || appSettings.coloredFinishedTests);
    final showHomeworkColor = hasHomework && !isDone && !showTestColor;

    final Color bgColor;
    final Color textColor;
    final Color subTextColor;

    if (isCanceled) {
      bgColor = theme.colorScheme.errorContainer;
      textColor = theme.colorScheme.onErrorContainer;
      subTextColor = textColor.withValues(alpha: 0.85);
    } else if (showTestColor) {
      bgColor = theme.colorScheme.tertiaryContainer;
      textColor = theme.colorScheme.onTertiaryContainer;
      subTextColor = textColor.withValues(alpha: 0.85);
    } else if (showHomeworkColor) {
      bgColor = theme.colorScheme.primaryContainer;
      textColor = theme.colorScheme.onPrimaryContainer;
      subTextColor = textColor.withValues(alpha: 0.85);
    } else {
      bgColor = theme.colorScheme.surfaceContainerHighest;
      textColor = theme.colorScheme.onSurface;
      subTextColor = theme.colorScheme.onSurfaceVariant;
    }

    final first = events.first;
    final last = events.last;
    final localStart = first.start.toLocal();
    final localEnd = last.einde.toLocal();

    String lesuurText = "";
    if (first.lesuurVan != null) {
      final endUur = last.lesuurTotMet ?? last.lesuurVan;
      if (endUur != null && endUur != first.lesuurVan) {
        lesuurText = "${first.lesuurVan}e - ${endUur}e";
      } else {
        lesuurText = "${first.lesuurVan}e";
      }
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showCalendarEventDetailsSheet(
          context,
          events: events,
          callback: onRefresh,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardHeight = constraints.maxHeight;
            final cardWidth = constraints.maxWidth;
            final isNarrow = cardWidth < 55;

            final showDetails = cardHeight >= 46 && !isNarrow;
            final titleMaxLines = cardHeight < 36 ? 1 : (cardHeight >= 64 ? 2 : 1);
            final titleStyle = (cardHeight < 36
                    ? theme.textTheme.labelSmall
                    : theme.textTheme.labelMedium)
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              decoration: isCanceled ? TextDecoration.lineThrough : null,
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: ClipRect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title & Lesuur
                    Row(
                      children: [
                        if (isDone && (hasHomework || isTest) && !isNarrow)
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              size: 13,
                              color: subTextColor,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            first.title,
                            maxLines: titleMaxLines,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),
                        ),
                        if (lesuurText.isNotEmpty && cardHeight >= 32 && !isNarrow)
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              lesuurText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: subTextColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Time & Location / Teacher
                    if (showDetails) ...[
                      const SizedBox(height: 1),
                      Text(
                        [
                          "${localStart.formattedTime} - ${localEnd.formattedTime}",
                          if (first.lokatie != null && first.lokatie!.isNotEmpty)
                            first.lokatie!,
                          if (first.docenten?.isNotEmpty == true)
                            first.docenten!.first.naam ?? "",
                        ].join(" • "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
