import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/appie_payroll_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/calendar_statistical_tiles_header.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/classrooms_statistics_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_activity_insights_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_timeline_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/period_heatmap_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/schedule_extremes_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/schoolday_efficiency_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/streaks_and_pressure_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/subject_hours_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/teacher_statistics_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/teacher_subject_search_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/weekday_hours_barchart.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chip_filter.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class CalendarStatisticsScreen extends StatefulWidget {
  const CalendarStatisticsScreen({super.key});

  @override
  State<CalendarStatisticsScreen> createState() =>
      _CalendarStatisticsScreenState();
}

class _CalendarStatisticsScreenState extends State<CalendarStatisticsScreen> {
  Schoolyear? _selectedSchoolyear; // null = "Alles"
  List<Schoolyear> _allSchoolyears = [];
  List<CalendarEvent>? _allEvents;
  bool _isLoading = true;
  bool _isFullSyncing = false;
  String _syncProgressText = "";
  bool _hasUnsyncedSchoolyears = false;
  bool _hideWithoutHours = true; 

  @override
  void initState() {
    super.initState();
    _selectedSchoolyear = null;
    _loadData();
  }

  Future<void> _loadData() async {
    _allSchoolyears =
        await activeProfile.schoolyears.filter().sortByBeginDesc().findAll();

    final events =
        await activeProfile.calendarEvents.filter().sortByStart().findAll();

    // Check if any schoolyears have 0 events in the local database
    bool missingYears = false;
    for (final sy in _allSchoolyears) {
      final count = events
          .where((e) =>
              e.start.isAfter(sy.begin.subtract(const Duration(days: 1))) &&
              e.start.isBefore(sy.einde.add(const Duration(days: 1))))
          .length;
      if (count == 0) {
        missingYears = true;
        break;
      }
    }

    if (mounted) {
      setState(() {
        _allEvents = events;
        _hasUnsyncedSchoolyears = missingYears;
        _isLoading = false;
      });
    }
  }

  Future<void> _performFullCareerFetch({bool force = false}) async {
    if (activeProfile.isOffline || _isFullSyncing) return;

    // Determine which schoolyears are actually missing events in local database
    final missingSchoolyears = force
        ? _allSchoolyears
        : _allSchoolyears.where((sy) {
            final count = (_allEvents ?? [])
                .where((e) =>
                    e.start
                        .isAfter(sy.begin.subtract(const Duration(days: 1))) &&
                    e.start.isBefore(sy.einde.add(const Duration(days: 1))))
                .length;
            return count == 0;
          }).toList();

    // If all schoolyears already have events in local DB and not forced, skip network sync!
    if (missingSchoolyears.isEmpty && !force) {
      await _loadData();
      return;
    }

    setState(() {
      _isFullSyncing = true;
      _syncProgressText = "Schooljaren voorbereiden...";
    });

    try {
      final totalYears = missingSchoolyears.length;
      for (int i = 0; i < totalYears; i++) {
        if (!mounted) break;
        final sy = missingSchoolyears[i];
        setState(() {
          _syncProgressText =
              "Schooljaar ${sy.groep.omschrijving ?? sy.groep.code} ophalen (${i + 1}/$totalYears)...";
        });
        await activeProfile.getEvents(DateTimeRange(
          start: sy.begin,
          end: sy.einde,
        ));
      }
    } catch (_) {
    } finally {
      if (mounted) {
        await _loadData();
        setState(() {
          _isFullSyncing = false;
        });
      }
    }
  }

  Future<void> _refresh(bool isOffline) async {
    await _loadData();
    if (!isOffline && _hasUnsyncedSchoolyears) {
      await _performFullCareerFetch(force: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Full screen loader while downloading all career schoolyears
    if (_isFullSyncing) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  "Kalendergegevens ophalen",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _syncProgressText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Dit kan even duren omdat alle schooljaren worden geladen.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isLoading || _allEvents == null) {
      return ScaffoldSkeleton(
        fetch: _refresh,
        appBar: (isRefreshing, trailingRefreshButton, leading) =>
            SliverAppBar.large(
          title: const Text("Kalender statistieken"),
          leading: leading,
        ),
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    // Filter events by selected schoolyear (or all events if null)
    final yearFilteredEvents = _selectedSchoolyear == null
        ? _allEvents!
        : _allEvents!
            .where((e) =>
                e.start.isAfter(_selectedSchoolyear!.begin
                    .subtract(const Duration(days: 1))) &&
                e.start.isBefore(
                    _selectedSchoolyear!.einde.add(const Duration(days: 1))))
            .toList();

    // Apply Isar/List calendar filters (e.g. teacher filters) and hide without hours
    final filteredEvents = yearFilteredEvents
        .applyCalendarFilter(
          schoolyearUuid: _selectedSchoolyear?.uuid,
        )
        .where((e) => !_hideWithoutHours || e.lesuurVan != null)
        .toList();

    final nonCanceledEvents =
        filteredEvents.where((e) => !e.isCanceled && !e.duurtHeleDag).toList();
    final canceledCount = filteredEvents.where((e) => e.isCanceled).length;

    double totalHours = 0.0;
    final Set<String> distinctSubjects = {};
    final Set<String> distinctTeachers = {};

    for (final e in nonCanceledEvents) {
      final diff = e.einde.difference(e.start).inMinutes;
      if (diff > 0 && diff <= 600) {
        totalHours += diff / 60.0;
      }
      final title = e.subject.value?.naam.capitalized ??
          (e.title.isNotEmpty ? e.title.capitalized : null);
      if (title != null) distinctSubjects.add(title);

      final docenten = e.docenten;
      if (docenten != null && docenten.isNotEmpty) {
        for (final d in docenten) {
          if (d.naam != null && d.naam!.isNotEmpty) {
            distinctTeachers.add(d.naam!);
          }
        }
      }
    }

    // Day of week breakdown (Monday = 1, Sunday = 7)
    final Map<int, double> dayHours = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final e in nonCanceledEvents) {
      if (dayHours.containsKey(e.start.weekday)) {
        final diff = e.einde.difference(e.start).inMinutes;
        if (diff > 0 && diff <= 600) {
          dayHours[e.start.weekday] =
              (dayHours[e.start.weekday] ?? 0.0) + (diff / 60.0);
        }
      }
    }

    return ScaffoldSkeleton(
      fetch: _refresh,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: "Kalender statistieken",
        screenType: CalendarStatisticsScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Kalender statistieken"),
        leading: leading,
        actions: [
          if (trailingRefreshButton != null) trailingRefreshButton,
        ],
      ),
      children: [
        // Statistical Tiles Header
        CalendarStatisticalTilesHeader.general(
          key: const HeaderKey(),
          totalHours: totalHours,
          canceledCount: canceledCount,
          subjectCount: distinctSubjects.length,
          teacherCount: distinctTeachers.length,
        ),

        // Search Bar for Teachers and Subjects
        TeacherSubjectSearchCard(
          allEvents: _allEvents!,
          allSchoolyears: _allSchoolyears,
        ),

        FilterChipList(
          key: const HeaderKey(),
          chips: [
            DropDownChip<int?>(
              defaultTitle: "Alle schooljaren",
              defaultIcon: const Icon(Icons.school),
              currentValue: _selectedSchoolyear != null
                  ? DropDownChipItem(
                      title: _selectedSchoolyear!.groep.omschrijving ??
                          _selectedSchoolyear!.groep.code,
                      shortTitle: _selectedSchoolyear!.groep.code,
                      item: _selectedSchoolyear!.uuid,
                    )
                  : DropDownChipItem(
                      title: "Alle schooljaren",
                      shortTitle: "Alles",
                      item: null,
                    ),
              items: () async {
                return [
                  DropDownChipItem(
                    title: "Alle schooljaren",
                    shortTitle: "Alles",
                    item: null,
                  ),
                  for (final sy in _allSchoolyears)
                    DropDownChipItem(
                      title: sy.groep.omschrijving ?? sy.groep.code,
                      shortTitle: sy.groep.code,
                      item: sy.uuid,
                    ),
                ];
              },
              onSelected: (item) {
                setState(() {
                  _selectedSchoolyear = item?.item != null
                      ? _allSchoolyears.firstWhere((s) => s.uuid == item!.item)
                      : null;
                });
              },
            ),
            CalendarFilterMenuChip(
              key: ValueKey(
                  "CalendarFilterButton_${_selectedSchoolyear?.uuid ?? 'all'}_${Settings.activeCalendarFilters.length}"),
              schoolyear: _selectedSchoolyear,
              allSchoolyears: _allSchoolyears,
              allEvents: _allEvents!,
              onChanged: () => setState(() {}),
            ),
            ToggleChip(
              label: const Text("Zonder lesuur"),
              icon: const Icon(Icons.timer_off_outlined),
              initalValue: _hideWithoutHours,
              onChanged: (val) => setState(() => _hideWithoutHours = val),
            ),
          ],
        ),

        if (_hasUnsyncedSchoolyears)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: CustomCard(
              margin: const EdgeInsets.all(4),
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_download_outlined,
                      color: theme.colorScheme.error,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Schooljaren niet compleet",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Haal alle schooljaren eenmalig op voor een compleet overzicht van je hele schoolcarrière.",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: () => _performFullCareerFetch(force: true),
                      child: const Text("Ophalen"),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ...[
          // "Wat als school een appie was?" 
          if (_selectedSchoolyear == null)
            AppiePayrollCard(
              events: filteredEvents,
              schoolyears: _allSchoolyears,
              selectedSchoolyear: _selectedSchoolyear,
            ),

          // Hours per Subject Section
          SubjectHoursTile(
            key: ValueKey("subjects_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
            allEvents: _allEvents,
            allSchoolyears: _allSchoolyears,
          ),

          // Weekday Hours Distribution Section
          WeekdayHoursBarchart(
            dayHours: dayHours,
            events: filteredEvents,
          ),

          // Teacher Statistics Section
          TeacherStatisticsCard(
            key: ValueKey("teacher_card_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
            allEvents: _allEvents,
            allSchoolyears: _allSchoolyears,
          ),

          // Lesson Activity & Insights Section
          LessonActivityInsightsCard(
            key: ValueKey("insights_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
          ),

          // School Day Efficiency & Gaps (Tussenuren, Efficiëntie & Grootste Gat)
          SchoolDayEfficiencyCard(
            key: ValueKey("efficiency_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
          ),

          // Streaks & Pressure (Afwezigheids-vrije streak & Toets Weken)
          StreaksAndPressureCard(
            key: ValueKey("streaks_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
          ),

          // Schedule Extremes (Uitslaap-loterij, Gemiddelde tijden, Vroegste/Laatste & Grootste Uitvaldag)
          ScheduleExtremesCard(
            key: ValueKey("extremes_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
          ),

          // Period Heatmap (1e uur overleving vs 8e uur marteling / Heatmap)
          PeriodHeatmapCard(
            key: ValueKey("heatmap_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
          ),

          // First & Last lesson timeline (Loose cards just like insights)
          LessonTimelineCard(
            key: ValueKey("timeline_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
          ),

          // Classrooms Statistics Section
          ClassroomsStatisticsCard(
            key: ValueKey("classrooms_${_selectedSchoolyear?.uuid ?? 'all'}"),
            events: filteredEvents,
          ),
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: (e.key.toString().contains("insights") ||
                    e.key.toString().contains("timeline") ||
                    e.key.toString().contains("efficiency") ||
                    e.key.toString().contains("streaks") ||
                    e.key.toString().contains("extremes") ||
                    e.key.toString().contains("heatmap"))
                ? e
                : CustomCard(
                    margin: const EdgeInsets.all(4),
                    child: e,
                  ),
          ),
        ),
      ],
    );
  }
}
