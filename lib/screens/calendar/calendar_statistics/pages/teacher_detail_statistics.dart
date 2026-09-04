import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/pages/subject_detail_statistics.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/appie_payroll_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/calendar_lesson_list_tile.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/calendar_statistical_tiles_header.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/classrooms_statistics_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_activity_insights_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/lesson_timeline_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/period_heatmap_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/schoolyear_hours_card.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/weekday_hours_barchart.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

class TeacherDetailStatisticsScreen extends StatefulWidget {
  const TeacherDetailStatisticsScreen({
    super.key,
    required this.teacherName,
    this.teacherCode,
    required this.allEvents,
    required this.allSchoolyears,
  });

  final String teacherName;
  final String? teacherCode;
  final List<CalendarEvent> allEvents;
  final List<Schoolyear> allSchoolyears;

  @override
  State<TeacherDetailStatisticsScreen> createState() =>
      _TeacherDetailStatisticsScreenState();
}

class _TeacherDetailStatisticsScreenState
    extends State<TeacherDetailStatisticsScreen> {
  bool _hideWithoutHours = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter events for this specific teacher
    final teacherEvents = widget.allEvents.where((e) {
      final docenten = e.docenten;
      if (docenten == null || docenten.isEmpty) return false;
      return docenten.any((d) =>
          (d.naam != null && d.naam!.trim() == widget.teacherName.trim()) ||
          (widget.teacherCode != null &&
              d.docentcode != null &&
              d.docentcode!.trim() == widget.teacherCode!.trim()) ||
          (d.naam == null &&
              d.docentcode != null &&
              d.docentcode!.trim() == widget.teacherName.trim()));
    }).toList();

    // Filter out events without hours if enabled
    final usableEvents = teacherEvents
        .where((e) => !_hideWithoutHours || e.lesuurVan != null)
        .toList();

    final nonCanceledEvents =
        usableEvents.where((e) => !e.isCanceled && !e.duurtHeleDag).toList();
    final canceledEvents = usableEvents.where((e) => e.isCanceled).toList();
    final totalLessons = usableEvents.length;

    // Total hours
    double totalHours = 0.0;
    for (final e in nonCanceledEvents) {
      final diff = e.einde.difference(e.start).inMinutes;
      if (diff > 0 && diff <= 600) {
        totalHours += diff / 60.0;
      }
    }

    final canceledCount = canceledEvents.length;
    final canceledPercentage =
        totalLessons > 0 ? (canceledCount / totalLessons) * 100 : 0.0;

    // Active schoolyears with this teacher
    final activeSchoolyears = widget.allSchoolyears.where((sy) {
      return usableEvents.any((e) =>
          e.start.isAfter(sy.begin.subtract(const Duration(days: 1))) &&
          e.start.isBefore(sy.einde.add(const Duration(days: 1))));
    }).toList();

    // Subjects taught by this teacher
    final Map<String, _TeacherSubjectStats> subjectsMap = {};
    for (final e in usableEvents) {
      final subjectName = e.subject.value?.naam.capitalized ??
          (e.title.isNotEmpty ? e.title.capitalized : "Onbekend vak");
      final isCancel = e.isCanceled;
      final diff = e.einde.difference(e.start).inMinutes;
      final hours = (!isCancel && diff > 0 && diff <= 600) ? diff / 60.0 : 0.0;
      final isHomework = e.infoType == InfoType.homework ||
          (e.inhoud != null && e.inhoud!.isNotEmpty && !e.isTest);
      final isTest = e.isTest;

      if (!subjectsMap.containsKey(subjectName)) {
        subjectsMap[subjectName] = _TeacherSubjectStats(
          name: subjectName,
          shortName: e.subject.value?.afkorting ?? e.vakken?.firstOrNull?.naam,
        );
      }
      final s = subjectsMap[subjectName]!;
      s.totalLessons++;
      s.totalHours += hours;
      if (isCancel) s.canceledLessons++;
      if (isHomework) s.homeworkCount++;
      if (isTest) s.testCount++;
      s.events.add(e);
    }

    // Weekday hours distribution
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

    // Sort all lessons descending by date for the cardless bottom list
    final sortedLessonsDescending = List<CalendarEvent>.from(usableEvents)
      ..sort((a, b) => b.start.compareTo(a.start));

    return ScaffoldSkeleton(
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: "Docent: ${widget.teacherName}",
        screenType: TeacherDetailStatisticsScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: Text(widget.teacherName),
        leading: leading,
        actions: [
          if (widget.teacherCode != null && widget.teacherCode!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Chip(
                  avatar: const Icon(Icons.badge_outlined, size: 18),
                  label: Text(widget.teacherCode!),
                ),
              ),
            ),
        ],
      ),
      children: [
        // Statistical Header Tiles
        CalendarStatisticalTilesHeader.teacher(
          totalHours: totalHours,
          totalLessons: totalLessons,
          canceledCount: canceledCount,
          canceledPercentage: canceledPercentage,
          schoolyearsCount: activeSchoolyears.length,
        ),

        // Filter chips (including Alleen lesuren verbergen)
        FilterChipList(
          chips: [
            ToggleChip(
              label: const Text("Alleen lesuren"),
              icon: const Icon(Icons.timer_off_outlined),
              initalValue: _hideWithoutHours,
              onChanged: (val) => setState(() => _hideWithoutHours = val),
            ),
          ],
        ),

        // Content Cards
        ...[
          // "Wat als school een appie was?"
          CustomCard(
            margin: EdgeInsets.zero,
            child: AppiePayrollCard(
              events: usableEvents,
              schoolyears: widget.allSchoolyears,
              selectedSchoolyear: null,
              title: "Wat als school een appie was?",
              subtitle: "Albert Heijn salaris bij ${widget.teacherName}",
              sourceName: "Docent: ${widget.teacherName}",
              margin: EdgeInsets.zero,
            ),
          ),

          SchoolyearHoursCard(
            events: usableEvents,
            schoolyears: widget.allSchoolyears,
            infoText: "Aantal lesuren per schooljaar voor ${widget.teacherName}.",
          ),

          WeekdayHoursBarchart(
            dayHours: dayHours,
            events: usableEvents,
          ),

          LessonActivityInsightsCard(
            key: ValueKey("insights_${_hideWithoutHours ? 'hide' : 'show'}"),
            events: usableEvents,
            subtitle:
                "Statistieken over huiswerk, toetsen en tempo bij ${widget.teacherName}",
          ),

          LessonTimelineCard(
            key: ValueKey("timeline_${_hideWithoutHours ? 'hide' : 'show'}"),
            events: usableEvents,
          ),

          PeriodHeatmapCard(
            key: ValueKey("heatmap_${_hideWithoutHours ? 'hide' : 'show'}"),
            events: usableEvents,
          ),

          ClassroomsStatisticsCard(
            events: usableEvents,
            title: "Lokalen bij ${widget.teacherName}",
          ),
        ].map(
          (e) => e.key.runtimeType != HeaderKey
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: (e.key.toString().contains("insights") ||
                          e.key.toString().contains("timeline") ||
                          e.key.toString().contains("heatmap"))
                      ? e
                      : CustomCard(
                          margin: const EdgeInsets.all(4),
                          child: e,
                        ),
                )
              : e,
        ),

        if (subjectsMap.isNotEmpty) ...[
          ListTitle(
            child: Text("Gegeven vakken (${subjectsMap.length})"),
          ),
          for (final sub in subjectsMap.values)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  sub.name.characters.firstOrNull?.toUpperCase() ?? "V",
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                sub.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "${sub.totalHours.toStringAsFixed(1)} uur • ${sub.totalLessons} lessen${sub.canceledLessons > 0 ? ' • ${sub.canceledLessons} uitval' : ''}",
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SubjectDetailStatisticsScreen(
                      subjectName: sub.name,
                      subjectShortName: sub.shortName,
                      allEvents: widget.allEvents,
                      allSchoolyears: widget.allSchoolyears,
                    ),
                  ),
                );
              },
            ),
        ],

        if (sortedLessonsDescending.isNotEmpty) ...[
          ListTitle(
            child: Text("Lessen (${sortedLessonsDescending.length})"),
          ),
          for (final lesson in sortedLessonsDescending.take(100))
            CalendarLessonListTile(lesson: lesson),
        ],
      ],
    );
  }
}

class _TeacherSubjectStats {
  final String name;
  final String? shortName;
  double totalHours = 0.0;
  int totalLessons = 0;
  int canceledLessons = 0;
  int homeworkCount = 0;
  int testCount = 0;
  final List<CalendarEvent> events = [];

  _TeacherSubjectStats({required this.name, this.shortName});
}
