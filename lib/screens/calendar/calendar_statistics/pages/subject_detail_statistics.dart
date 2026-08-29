import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/pages/teacher_detail_statistics.dart';
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
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/grade_header.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class SubjectDetailStatisticsScreen extends StatefulWidget {
  const SubjectDetailStatisticsScreen({
    super.key,
    required this.subjectName,
    this.subjectShortName,
    required this.allEvents,
    required this.allSchoolyears,
  });

  final String subjectName;
  final String? subjectShortName;
  final List<CalendarEvent> allEvents;
  final List<Schoolyear> allSchoolyears;

  @override
  State<SubjectDetailStatisticsScreen> createState() =>
      _SubjectDetailStatisticsScreenState();
}

class _SubjectDetailStatisticsScreenState
    extends State<SubjectDetailStatisticsScreen> {
  bool _hideWithoutHours = true; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter events for this specific subject
    final subjectEvents = widget.allEvents.where((e) {
      final name = e.subject.value?.naam.capitalized ??
          (e.title.isNotEmpty ? e.title.capitalized : "");
      final short = e.subject.value?.afkorting.toUpperCase() ??
          (e.vakken?.firstOrNull?.naam?.toUpperCase() ?? "");

      if (name.isNotEmpty &&
          name.toLowerCase() == widget.subjectName.toLowerCase()) {
        return true;
      }
      if (widget.subjectShortName != null &&
          widget.subjectShortName!.isNotEmpty &&
          short.isNotEmpty &&
          short.toLowerCase() == widget.subjectShortName!.toLowerCase()) {
        return true;
      }
      return false;
    }).toList();

    // Filter out events without hours if enabled
    final usableEvents = subjectEvents
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

    // Teachers who gave this subject
    final Map<String, _SubjectTeacherStats> teachersMap = {};
    for (final e in usableEvents) {
      final docenten = e.docenten;
      if (docenten == null || docenten.isEmpty) continue;

      for (final d in docenten) {
        final tName = d.naam ?? d.docentcode ?? "";
        if (tName.isEmpty) continue;

        final isCancel = e.isCanceled;
        final diff = e.einde.difference(e.start).inMinutes;
        final hours =
            (!isCancel && diff > 0 && diff <= 600) ? diff / 60.0 : 0.0;

        if (!teachersMap.containsKey(tName)) {
          teachersMap[tName] = _SubjectTeacherStats(
            name: tName,
            code: d.docentcode,
          );
        }
        final t = teachersMap[tName]!;
        t.totalLessons++;
        t.totalHours += hours;
        if (isCancel) t.canceledLessons++;
      }
    }

    final sortedTeachers = teachersMap.values.toList()
      ..sort((a, b) => b.totalHours.compareTo(a.totalHours));

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

    // Check if there's a grade Subject in the local database
    Subject? matchedGradeSubject;
    try {
      matchedGradeSubject = isar.subjects
          .filter()
          .naamEqualTo(widget.subjectName, caseSensitive: false)
          .findFirstSync();
    } catch (_) {}

    // Sort lessons descending for cardless bottom list
    final sortedLessonsDescending = List<CalendarEvent>.from(usableEvents)
      ..sort((a, b) => b.start.compareTo(a.start));

    return ScaffoldSkeleton(
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: "Vak: ${widget.subjectName}",
        screenType: SubjectDetailStatisticsScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: Text(widget.subjectName),
        leading: leading,
      ),
      children: [
        // Statistical Header Tiles
        CalendarStatisticalTilesHeader.subject(
          totalHours: totalHours,
          totalLessons: totalLessons,
          canceledCount: canceledCount,
          canceledPercentage: canceledPercentage,
          teachersCount: sortedTeachers.length,
        ),

        // Filter chips (including Zonder lesuur verbergen)
        FilterChipList(
          chips: [
            ToggleChip(
              label: const Text("Zonder lesuur"),
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
              subtitle: "Albert Heijn salaris voor ${widget.subjectName}",
              sourceName: "Vak: ${widget.subjectName}",
              margin: EdgeInsets.zero,
            ),
          ),

          if (matchedGradeSubject != null)
            StatisticalTilesHeader(
                key: const HeaderKey(),
                grades: matchedGradeSubject.grades.useable),

          SchoolyearHoursCard(
            events: usableEvents,
            schoolyears: widget.allSchoolyears,
            infoText:
                "Aantal lesuren per schooljaar voor ${widget.subjectName}.",
          ),

          WeekdayHoursBarchart(
            dayHours: dayHours,
            events: usableEvents,
          ),

          LessonActivityInsightsCard(
            key: ValueKey("insights_${_hideWithoutHours ? 'hide' : 'show'}"),
            events: usableEvents,
            subtitle:
                "Statistieken over huiswerk, toetsen en tempo voor ${widget.subjectName}",
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
            title: "Lokalen voor ${widget.subjectName}",
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

        if (sortedTeachers.isNotEmpty) ...[
          ListTitle(
            child: Text("Docenten voor dit vak (${sortedTeachers.length})"),
          ),
          for (final teacher in sortedTeachers)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Text(
                  teacher.name.characters.firstOrNull?.toUpperCase() ?? "D",
                  style: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                teacher.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "${teacher.totalHours.toStringAsFixed(1)} uur • ${teacher.totalLessons} lessen${teacher.canceledLessons > 0 ? ' • ${teacher.canceledLessons} uitval' : ''}",
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                TeacherDetailStatisticsScreen(
                  teacherName: teacher.name,
                  teacherCode: teacher.code,
                  allEvents: widget.allEvents,
                  allSchoolyears: widget.allSchoolyears,
                ).push(context);
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

class _SubjectTeacherStats {
  final String name;
  final String? code;
  double totalHours = 0.0;
  int totalLessons = 0;
  int canceledLessons = 0;

  _SubjectTeacherStats({required this.name, this.code});
}
