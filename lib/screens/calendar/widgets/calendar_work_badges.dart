import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:flutter/material.dart';

/// The same homework/test classification is used in the day and week views.
/// Cancelled appointments are excluded, including when periods are combined.
class CalendarWorkSummary {
  const CalendarWorkSummary({
    this.hasTest = false,
    this.hasHomework = false,
  });

  final bool hasTest;
  final bool hasHomework;

  bool get isEmpty => !hasTest && !hasHomework;

  factory CalendarWorkSummary.fromEvents(Iterable<CalendarEvent> events) {
    bool hasTest = false;
    bool hasHomework = false;
    for (final event in events) {
      if (event.isCanceled) continue;
      hasTest = hasTest || event.isTest;
      hasHomework = hasHomework || event.hasHomework;
      if (hasTest && hasHomework) break;
    }
    return CalendarWorkSummary(
      hasTest: hasTest,
      hasHomework: hasHomework,
    );
  }
}

/// Small, accessible icons in tight calendar cells; text labels on lesson tiles.
class CalendarWorkBadges extends StatelessWidget {
  const CalendarWorkBadges({
    super.key,
    required this.summary,
    this.showLabels = false,
    this.iconSize = 14,
    this.testLabel,
    this.testTooltip,
  });

  final CalendarWorkSummary summary;
  final bool showLabels;
  final double iconSize;

  /// Optional specific test type on lesson cards; dates show generic 'Toets'.
  final String? testLabel;
  final String? testTooltip;

  @override
  Widget build(BuildContext context) {
    if (summary.isEmpty) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;

    Widget badge({
      required String label,
      required IconData icon,
      required Color foreground,
      required Color background,
      String? tooltip,
    }) {
      final symbol = Icon(icon, size: iconSize, color: foreground);
      if (!showLabels) {
        return Tooltip(
          message: tooltip ?? label,
          child: Semantics(
            label: tooltip ?? label,
            child: ExcludeSemantics(
              child: Container(
                width: iconSize + 6,
                height: iconSize + 6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: symbol,
              ),
            ),
          ),
        );
      }
      return Tooltip(
        message: tooltip ?? label,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              symbol,
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final indicators = <Widget>[
      if (summary.hasTest)
        badge(
          label: testLabel ?? 'Toets',
          tooltip: testTooltip ?? 'Toets',
          icon: Icons.assignment_outlined,
          foreground: colors.onTertiaryContainer,
          background: colors.tertiaryContainer,
        ),
      if (summary.hasHomework)
        badge(
          label: 'Huiswerk',
          icon: Icons.menu_book_outlined,
          foreground: colors.onSecondaryContainer,
          background: colors.secondaryContainer,
        ),
    ];

    // Text labels wrap on smaller phones instead of overflowing a lesson tile.
    if (showLabels) {
      return Wrap(spacing: 4, runSpacing: 3, children: indicators);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < indicators.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          indicators[i],
        ],
      ],
    );
  }
}
