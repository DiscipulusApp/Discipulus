import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Albert Heijn All-in youth hourly wage scale (including vacation/ADV compensation)
double getAhHourlyWage(int age) {
  if (age <= 14) return 4.50;
  switch (age) {
    case 15:
      return 5.50;
    case 16:
      return 6.50;
    case 17:
      return 7.50;
    case 18:
      return 9.50;
    case 19:
      return 11.50;
    case 20:
      return 14.50;
    default:
      return 17.50;
  }
}

class SchoolyearPayroll {
  final Schoolyear schoolyear;
  final double totalHours;
  final double totalEarnings;
  final int eventCount;
  final Map<int, double> hoursPerAge;

  SchoolyearPayroll({
    required this.schoolyear,
    required this.totalHours,
    required this.totalEarnings,
    required this.eventCount,
    required this.hoursPerAge,
  });

  double get averageHourlyWage =>
      totalHours > 0 ? totalEarnings / totalHours : 0.0;
}

class AppiePayrollCalculator {
  static List<SchoolyearPayroll> calculatePerSchoolyear({
    required Profile profile,
    required List<Schoolyear> schoolyears,
    required List<CalendarEvent> events,
  }) {
    final List<SchoolyearPayroll> results = [];

    for (final sy in schoolyears) {
      final syEvents = events.where((e) =>
          !e.isCanceled &&
          !e.duurtHeleDag && 
          e.afwezigheid?.verantwoordingtype != AbsenceType.absent && 
          e.start.isAfter(sy.begin.subtract(const Duration(days: 1))) &&
          e.start.isBefore(sy.einde.add(const Duration(days: 1))));

      double syHours = 0.0;
      double syEarnings = 0.0;
      int syCount = 0;
      final Map<int, double> hoursPerAge = {};

      for (final event in syEvents) {
        final durationMinutes = event.einde.difference(event.start).inMinutes;
        if (durationMinutes <= 0 || durationMinutes > 600) continue;

        final hours = durationMinutes / 60.0;
        final age = profile.ageOn(event.start) ?? 16;
        final wage = getAhHourlyWage(age);

        syHours += hours;
        syEarnings += hours * wage;
        syCount++;
        hoursPerAge[age] = (hoursPerAge[age] ?? 0.0) + hours;
      }

      if (syCount > 0 || sy.isHoofdAanmelding == true) {
        results.add(SchoolyearPayroll(
          schoolyear: sy,
          totalHours: syHours,
          totalEarnings: syEarnings,
          eventCount: syCount,
          hoursPerAge: hoursPerAge,
        ));
      }
    }

    return results;
  }
}

/// "Wat als school een appie was?"
class AppiePayrollCard extends StatefulWidget {
  const AppiePayrollCard({
    super.key,
    required this.events,
    required this.schoolyears,
    this.selectedSchoolyear,
    this.title,
    this.subtitle,
    this.margin,
  });

  final List<CalendarEvent> events;
  final List<Schoolyear> schoolyears;
  final Schoolyear? selectedSchoolyear;
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry? margin;

  @override
  State<AppiePayrollCard> createState() => _AppiePayrollCardState();
}

class _AppiePayrollCardState extends State<AppiePayrollCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = activeProfile;
    final currencyFormatter =
        NumberFormat.currency(locale: 'nl_NL', symbol: '€', decimalDigits: 2);
    final numberFormatter = NumberFormat.decimalPattern('nl_NL');

    // Calculate all payroll data
    final payrolls = AppiePayrollCalculator.calculatePerSchoolyear(
      profile: profile,
      schoolyears: widget.schoolyears,
      events: widget.events,
    );

    // Selected schoolyear payroll vs Grand Total
    final selectedPayroll = payrolls.firstWhere(
      (p) => p.schoolyear.uuid == widget.selectedSchoolyear?.uuid,
      orElse: () => payrolls.isNotEmpty
          ? payrolls.first
          : SchoolyearPayroll(
              schoolyear: widget.schoolyears.firstOrNull ??
                  profile.activeSchoolyear,
              totalHours: 0,
              totalEarnings: 0,
              eventCount: 0,
              hoursPerAge: {},
            ),
    );

    final grandTotalHours =
        payrolls.fold<double>(0, (sum, p) => sum + p.totalHours);
    final grandTotalEarnings =
        payrolls.fold<double>(0, (sum, p) => sum + p.totalEarnings);

    // Assuming a frikandelbroodje costs €1.35, let's hope to dear God that inflation does not make things worse
    final totalFrikandelbroodjes = (grandTotalEarnings / 1.35).floor();

    return CustomCard(
      margin: widget.margin ?? const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "AH",
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title ?? "Wat als school een appie was?",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.subtitle ??
                            "Jouw theoretische Albert Heijn salarisstrook",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomCard(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Totaal all-time verdiend",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currencyFormatter.format(grandTotalEarnings),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Geroosterde uren",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${numberFormatter.format(grandTotalHours.round())} uur",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    // Fun fact
                    Row(
                      children: [
                        const Text("🥐", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Goed voor circa ${numberFormatter.format(totalFrikandelbroodjes)} frikandelbroodjes!",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Schoolyear Breakdown Section
            if (widget.selectedSchoolyear != null) ...[
              Text(
                "In dit schooljaar (${widget.selectedSchoolyear?.groep.omschrijving ?? 'Geselecteerd'}):",
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${numberFormatter.format(selectedPayroll.totalHours.round())} uur les",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        currencyFormatter.format(selectedPayroll.totalEarnings),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Expandable List of All Schoolyears
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _expanded
                          ? "Verberg uitsplitsing per schooljaar"
                          : "Bekijk uitsplitsing per schooljaar (${payrolls.length})",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_expanded) ...[
              const SizedBox(height: 6),
              for (final p in payrolls)
                CustomCard(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.schoolyear.groep.omschrijving ?? "Onbekend",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${numberFormatter.format(p.totalHours.round())} uur • gem. ${currencyFormatter.format(p.averageHourlyWage)}/u",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          currencyFormatter.format(p.totalEarnings),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
