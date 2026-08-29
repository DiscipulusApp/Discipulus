import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LessonActivityInsightsCard extends StatelessWidget {
  const LessonActivityInsightsCard({
    super.key,
    required this.events,
    this.title = "Lesactiviteit & Inzichten",
    this.subtitle = "Statistieken over huiswerk, toetsen en tempo",
  });

  final List<CalendarEvent> events;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    int totalHomework = 0;
    int totalTests = 0;
    int totalCanceled = 0;
    double totalAbsentHours = 0.0;
    int absentLessonsCount = 0;
    int unexcusedAbsentCount = 0;
    final Map<DateTime, double> dayTotalHours = {};

    for (final e in events) {
      if (e.isCanceled) {
        totalCanceled++;
      }
      if (e.infoType == InfoType.homework ||
          (e.inhoud != null && e.inhoud!.isNotEmpty && !e.isTest)) {
        totalHomework++;
      }
      if (e.isTest) {
        totalTests++;
      }
      if (e.afwezigheid != null && e.afwezigheid!.verantwoordingtype == AbsenceType.absent) {
        absentLessonsCount++;
        if (e.afwezigheid?.geoorloofd == false) {
          unexcusedAbsentCount++;
        }
        final dur = e.einde.difference(e.start).inMinutes;
        if (dur > 0 && dur <= 600) {
          totalAbsentHours += dur / 60.0;
        }
      }
      if (!e.isCanceled && !e.duurtHeleDag) {
        final dur = e.einde.difference(e.start).inMinutes;
        if (dur > 0 && dur <= 600) {
          final dayKey = e.start.dayOnly;
          dayTotalHours[dayKey] = (dayTotalHours[dayKey] ?? 0.0) + (dur / 60.0);
        }
      }
    }

    final double cancelChance =
        events.isNotEmpty ? (totalCanceled / events.length) * 100 : 0.0;

    double maxDayHours = 0.0;
    DateTime? maxDayDate;

    for (final entry in dayTotalHours.entries) {
      if (entry.value > maxDayHours) {
        maxDayHours = entry.value;
        maxDayDate = entry.key;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final tiles = [
          InsightCardItem(
            icon: Icons.assignment_outlined,
            iconColor: theme.colorScheme.primary,
            iconBackgroundColor: theme.colorScheme.primaryContainer,
            title: "Huiswerk opgegeven",
            value: "$totalHomework keer",
            subtitle: events.isNotEmpty
                ? "${(totalHomework / events.length * 100).toStringAsFixed(0)}% van de lessen"
                : null,
          ),
          InsightCardItem(
            icon: Icons.quiz_outlined,
            iconColor: theme.colorScheme.secondary,
            iconBackgroundColor: theme.colorScheme.primaryContainer,
            title: "Toetsen & Overhoringen",
            value: "$totalTests toetsen",
            subtitle: events.isNotEmpty
                ? "${(totalTests / events.length * 100).toStringAsFixed(0)}% van de lessen"
                : null,
          ),
          InsightCardItem(
            icon: Icons.event_busy_outlined,
            iconColor: totalCanceled > 0
                ? theme.colorScheme.error
                : theme.colorScheme.tertiary,
            iconBackgroundColor: totalCanceled > 0
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.tertiaryContainer,
            title: "Kans op uitval",
            value: "${cancelChance.toStringAsFixed(1)}%",
            subtitle: "$totalCanceled uitgevallen ${totalCanceled == 1 ? 'les' : 'lessen'}",
          ),
          InsightCardItem(
            icon: Icons.person_off_outlined,
            iconColor: totalAbsentHours > 0
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
            iconBackgroundColor: totalAbsentHours > 0
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.primaryContainer,
            title: "Afwezig geweest",
            value:
                "${totalAbsentHours.toStringAsFixed(totalAbsentHours == totalAbsentHours.roundToDouble() ? 0 : 1)} uur",
            subtitle: absentLessonsCount > 0
                ? "$absentLessonsCount ${absentLessonsCount == 1 ? 'les' : 'lessen'} verzuimd${unexcusedAbsentCount > 0 ? ' ($unexcusedAbsentCount ongeoorloofd)' : ''}"
                : "Geen verzuim geregistreerd",
          ),
          if (maxDayHours > 0 && maxDayDate != null)
            InsightCardItem(
              icon: Icons.hourglass_top_rounded,
              iconColor: theme.colorScheme.primary,
              iconBackgroundColor: theme.colorScheme.primaryContainer,
              title: "Meeste lesuren op 1 dag",
              value:
                  "${maxDayHours.toStringAsFixed(maxDayHours == maxDayHours.roundToDouble() ? 0 : 1)} uur",
              subtitle:
                  DateFormat('d MMMM yyyy', 'nl_NL').format(maxDayDate),
              onTap: () => CalendarDayView(
                displayedDay: maxDayDate,
              ).push(context),
            ),
        ];

        if (isWide) {
          return Wrap(
            children: tiles.map((tile) {
              return SizedBox(
                width: constraints.maxWidth / 2,
                child: tile,
              );
            }).toList(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: tiles,
          );
        }
      },
    );
  }
}

class InsightCardItem extends StatelessWidget {
  const InsightCardItem({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.value,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      margin: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
