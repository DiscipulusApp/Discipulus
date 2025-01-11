import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/calendar/widgets/oncoming_special_event.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart_schoolyears.dart';
import 'package:discipulus/screens/grades/widgets/no_weights_warning.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chip_filter.dart';
import 'package:discipulus/widgets/global/chips/chip_schoolyear.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart_rounded_grades.dart';
import 'package:discipulus/screens/grades/widgets/graphs/line_chart.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:discipulus/screens/grades/widgets/grade_calc_card.dart';
import 'package:discipulus/screens/grades/widgets/grade_header.dart';

class SubjectGradesScreen extends StatefulWidget {
  const SubjectGradesScreen({super.key, required this.subject});

  /// The subject that will be loaded.
  final Subject subject;

  @override
  State<SubjectGradesScreen> createState() => _SubjectGradesScreenState();
}

class _SubjectGradesScreenState extends State<SubjectGradesScreen> {
  /// This value contains the useable grades, in other words, the grades without averages and with the filter applied.
  /// This value is late, because the filter is quite intensive.
  late QueryBuilder<Grade, Grade, QAfterFilterCondition> grades;

  /// This value contains the "extra" calculated grade that can be created using the [GradeCalculationCard].
  final ValueNotifier<HighlightGrade?> highlightGrade = ValueNotifier(null);

  /// Contains all the tests that are related to the current subject and schoolyear.
  /// This only contains tests after the date that the value was loaded.
  List<CalendarEvent> tests = [];

  /// This list contains all the other schoolyears that the subject was found.
  ///
  /// Since magister does not support this (who knew...), it's pure guesswork.
  /// The subjects are match based on the name, since Magister does not provide any other way
  /// for a student account to match them. Sometimes the names won't
  /// be the same for every schoolyear resulting in them not matching.
  /// e.g. "Wiskunde" and "Wiskunde A/B/C/D" will not match. Thanks Magister!
  List<Subject> otherSchoolyears = [];

  /// This value contains the available filters. Since the getting all the possible filters can be quite an intensive task, it's also asynchronously constructed
  List filterChips = [];

  /// This value contains the active subject
  late Subject subject;

  bool containsNumericalGrades = true;

  /// Applies the new filterChips, but does not setState
  Future<void> setFilterChips() async =>
      filterChips = await subject.periods.periodChips(
        onChanged: () => setFilterChips().then(
          (value) => setState(() {
            grades = subject.grades.filter().applyGradeFilter();
          }),
        ),
      );

  Future<void> refresh(bool isOffline) async {
    if (!isOffline) await widget.subject.schoolyear.value!.fillGrades();
    grades = subject.grades.filter();
    containsNumericalGrades =
        await subject.grades.filter().numericalGrades.isNotEmpty();
    if (mounted) setState(() {});

    // When a subject does not have all the weights yet, we should fetch them.
    // To prevent hitting the rate limiter this will only happen when the amount
    // of weightless-grades are 15 or less.
    if (await subject.grades.filter().useable().weightIsNull().count() <= 15) {
      await Future.wait([
        for (Grade grade
            in await subject.grades.filter().useable().weightIsNull().findAll())
          grade.fill()
      ]);
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    subject = widget.subject;
    containsNumericalGrades =
        subject.grades.filter().numericalGrades.isNotEmptySync();
    super.initState();
    grades = subject.grades.filter();

    //Get the related schoolyears and tests from storage, then setState.
    Future.wait([
      setFilterChips(),
      Future(() async =>
          otherSchoolyears = await widget.subject.relatedSchoolyears),
      Future(() async => tests = await widget.subject.events
          .filter()
          .startGreaterThan(DateTime.now())
          .and()
          .infoTypeBetween(InfoType.test, InfoType.oralExam)
          .sortByStart()
          .findAll())
    ]).then((value) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      fetch: refresh,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: widget.subject.naam,
        profileUUID: widget.subject.schoolyear.value?.profile.value?.uuid,
        screenType: SubjectGradesScreen,
        extraInfo: {
          "subject_uuid": widget.subject.uuid,
          "subject_id": widget.subject.id,
          "subject_title": widget.subject.naam,
        },
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: Text(
          // Magister does not capitalize the subjects, so we will do that instead.
          widget.subject.naam.capitalized,
        ),
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
      ),
      children: [
        if (containsNumericalGrades)
          StatisticalTilesHeader(
            key: const HeaderKey(),
            grades: grades.applyGradeFilter(),
          ),
        FilterChipList(
          key: const HeaderKey(),
          chips: [
            SchoolyearSelector(
              initValue: SchoolyearObject(
                subject.schoolyear.value!.uuid,
                group: subject.schoolyear.value!.groep,
              ),
              gradesInformation: (q) => q.anyOf(
                  otherSchoolyears,
                  (q, subject) =>
                      q.subject((q) => q.uuidEqualTo(subject.uuid))),
              allowedUUIDS: otherSchoolyears
                  .map((e) => e.schoolyear.value!.uuid)
                  .toList(),
              onSelected: (s) async {
                subject = otherSchoolyears
                    .firstWhere((e) => e.schoolyear.value!.id == s?.id);
                containsNumericalGrades =
                    await subject.grades.filter().numericalGrades.isNotEmpty();
                grades = subject.grades.filter();
                setFilterChips().then((value) => setState(() {}));
              },
            ),
            ...filterChips
          ],
        ),
        // If the user had not fetched all the weights, display a warning
        NoWeightsWarning(
          schoolyear: subject.schoolyear.value!,
          subject: subject,
          onDone: () => refresh(false),
        ),
        if (tests.isNotEmpty)
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: UpcomingSpecialEventTile(
                events: tests,
              ),
            ),
          ),
        if (containsNumericalGrades)
          ...[
            ValueListenableBuilder(
                valueListenable: highlightGrade,
                builder: (context, value, child) {
                  return GradesLineChart(
                      grades: grades.applyGradeFilter(),
                      showAverage: true,
                      highlightGrade: value);
                }),
            GradeCalculationCard(
                toNewAverage: true,
                grades: grades.applyGradeFilter(),
                onResult: (grade, average, weight) => WidgetsBinding.instance
                    .addPostFrameCallback((_) => highlightGrade.value =
                        weight != null
                            ? HighlightGrade(
                                id: null,
                                customGrade: grade,
                                customWeight: weight)
                            : null)),
            GradeCalculationCard(
                grades: grades.applyGradeFilter(),
                onResult: (grade, average, weight) => WidgetsBinding.instance
                    .addPostFrameCallback((_) => highlightGrade.value =
                        weight != null
                            ? HighlightGrade(
                                id: null,
                                customGrade: grade,
                                customWeight: weight)
                            : null)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChartSchoolyears(
                subject: subject,
                onSelected: (newSubject) async {
                  subject = newSubject;
                  containsNumericalGrades = await subject.grades
                      .filter()
                      .numericalGrades
                      .isNotEmpty();
                  grades = subject.grades.filter();
                  setFilterChips().then((value) => setState(() {}));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChartRoundedGrades(
                grades: grades,
                onFilterApplied: () {
                  grades = subject.grades.filter();
                  setFilterChips().then((value) => setState(() {}));
                },
              ),
            ),
          ].map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomCard(child: e),
              )),
        ...grades
            .applyGradeFilter()
            .useable(showDisabled: true)
            .findAllSync()
            .insertDateSeparatorWidget(
              (e) => e.datumIngevoerd,
              separator: ({required title, required values}) =>
                  ListTitle(child: Text(title), children: [
                if (values.length > 1)
                  ExpandedStats(
                    grades: values,
                  )
              ]),
              tile: (e) => GradeTile(
                grade: e,
                setStateTop: (p0) => setState(() {}),
              ),
            )
      ],
    );
  }
}
