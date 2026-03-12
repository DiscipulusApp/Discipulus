import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart_rounded_grades.dart';
import 'package:discipulus/screens/grades/widgets/graphs/gaussian_chart.dart';
import 'package:discipulus/screens/grades/widgets/graphs/line_chart.dart';
import 'package:discipulus/screens/grades/widgets/grade_header.dart';
import 'package:discipulus/screens/grades/widgets/no_weights_warning.dart';
import 'package:discipulus/screens/grades/widgets/subject_averages_card.dart';
import 'package:discipulus/screens/grades/widgets/sufficient_grades_card.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chip_filter.dart';
import 'package:discipulus/widgets/global/chips/chip_schoolyear.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class GradesStatisticsScreen extends StatefulWidget {
  const GradesStatisticsScreen({super.key});

  @override
  State<GradesStatisticsScreen> createState() => _GradesStatisticsScreenState();
}

class _GradesStatisticsScreenState extends State<GradesStatisticsScreen> {
  late Schoolyear schoolyear;
  late QueryBuilder<Grade, Grade, QAfterFilterCondition> gradesQuery;
  List<Grade>? gradesList;
  List filterChips = [];
  late Schoolyear comparisonSchoolyear;

  @override
  void initState() {
    schoolyear = activeProfile.activeSchoolyear;
    comparisonSchoolyear = activeProfile.schoolyears
            .filter()
            .not()
            .uuidEqualTo(schoolyear.uuid)
            .sortByEindeDesc()
            .findFirstSync() ??
        schoolyear;

    gradesQuery = schoolyear.grades.filter();
    setGrades();
    super.initState();
  }

  Future<void> setGrades() async {
    gradesQuery =
        schoolyear.grades.filter().cijferKolom((q) => q.kolomSoortEqualTo(1));
    var newGrades = await gradesQuery
        .applyGradeFilter()
        .sortByDatumIngevoerd()
        .thenById()
        .findAll();
    if (mounted) {
      setState(() {
        gradesList = newGrades;
      });
    }
  }

  Future<void> setChips() async =>
      filterChips = await schoolyear.periods.periodChips(
          onChanged: () => Future.wait([setGrades(), setChips()]).then((value) {
                if (mounted) setState(() {});
              }));

  Future<void> refresh(bool isOffline) async {
    await setChips();
    await setGrades();
    if (!isOffline) await schoolyear.fillGrades();
    await setGrades();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      fetch: refresh,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: "Statistieken",
        screenType: GradesStatisticsScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Statistieken"),
        leading: leading,
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
      ),
      extraSlivers: [
        if (gradesList == null)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                List<Widget> children = gradesList!
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
                        setStateTop: (p0) =>
                            Future.wait([setChips(), setGrades()])
                                .then((value) => setState(() {})),
                      ),
                    )
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: e,
                        ))
                    .toList();
                return children[index];
              },
              childCount: gradesList!
                  .insertDateSeparatorWidget(
                    (e) => e.datumIngevoerd,
                    separator: ({required title, required values}) =>
                        ListTitle(child: Text(title), children: []),
                    tile: (e) => const SizedBox(),
                  )
                  .length,
            ),
          )
      ],
      children: [
        StatisticalTilesHeader(
            key: const HeaderKey(), grades: gradesList ?? []),
        FilterChipList(
          key: const HeaderKey(),
          chips: [
            SchoolyearSelector(
              initValue:
                  SchoolyearObject(schoolyear.uuid, group: schoolyear.groep),
              gradesInformation: (q) => q,
              onSelected: (s) async {
                schoolyear = s!;
                await refresh(true);
              },
            ),
            ...filterChips
          ],
        ),
        NoWeightsWarning(
          schoolyear: schoolyear,
          onDone: () => refresh(true),
        ),
        Padding(
          key: const HeaderKey(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomCard(
            margin: const EdgeInsets.all(4),
            child: GradesLineChart(
              grades: gradesQuery.applyGradeFilter(),
              showAverage: true,
            ),
          ),
        ),
        ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SufficientGradesCard(
              grades: gradesQuery.applyGradeFilter(),
            ),
          ),
          AveragesTile(
            subjects: schoolyear.subjects,
          ),
          Column(
            key: const ValueKey("NO_PADDING"),
            children: [
              CustomCard(
                margin: const EdgeInsets.all(12).copyWith(bottom: 8),
                child: GaussianCurveChart(
                  primaryGradesQuery: gradesQuery.applyGradeFilter(),
                  backgroundGradesQueries: [
                    comparisonSchoolyear.grades
                        .filter()
                        .useable()
                        .applyGradeFilter()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8)
                    .copyWith(bottom: 0),
                child: ListTile(
                  dense: true,
                  trailing: SchoolyearSelector(
                    initValue: SchoolyearObject(
                      schoolyear.uuid,
                      group: comparisonSchoolyear.groep,
                    ),
                    onSelected: (schoolyear) => setState(() {
                      comparisonSchoolyear = schoolyear!;
                    }),
                  ),
                  title: const Text("Vergelijkings jaar: "),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8)
                    .copyWith(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.info_outline),
                  title: const Text(
                      "Deze curve laat de normaalverdeling zien van hoe vaak je bepaalde cijfers haalt."),
                ),
              ),
            ],
          ),
          Padding(
            key: const ValueKey("NO_PADDING"),
            padding: const EdgeInsets.all(8.0),
            child: BarChartRoundedGrades(
              grades: gradesQuery,
              schoolyearUUID: schoolyear.uuid,
              onFilterApplied: () async {
                await setGrades();
                if (mounted) setState(() {});
              },
            ),
          ),
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomCard(
              margin: const EdgeInsets.all(4).copyWith(
                  bottom: e.key == const ValueKey("NO_PADDING") ? 0 : 4),
              child: e,
            ),
          ),
        ),
      ],
    );
  }
}
