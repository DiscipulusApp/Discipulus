import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/widgets/global/chips/chip_filter.dart';
import 'package:discipulus/widgets/global/chips/chip_schoolyear.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/screens/grades/widgets/grade_calc_card.dart';
import 'package:discipulus/screens/grades/widgets/graphs/line_chart.dart';
import 'package:discipulus/screens/grades/widgets/no_weights_warning.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';

class GradesListScreen extends StatefulWidget {
  const GradesListScreen({super.key});

  @override
  State<GradesListScreen> createState() => _GradesListScreenState();
}

class _GradesListScreenState extends State<GradesListScreen> {
  /// The active schoolyear. This value default value will be the activeProfile's most recent schoolyear.
  late Schoolyear schoolyear;

  /// This value contains the useable grades, in other words, the grades without averages and with the filter applied.
  /// This value is late, because the filter is quite intensive.
  late QueryBuilder<Grade, Grade, QAfterFilterCondition> gradesQuery;
  List<Grade>? gradesList;

  /// This value contains the "extra" calculated grade that can be created using the [GradeCalculationCard].
  late final ValueNotifier<HighlightGrade?> highlightGrade;

  /// If a refresh is taking place;
  late final ValueNotifier<bool> isRefreshing;

  /// This value contains the available filters. Since the getting all the possible filters can be quite an intensive task, it's also asynchronously constructed
  List filterChips = [];

  /// The schoolyear that will be compared to the current schoolyear.
  /// This value defaults to the previous schoolyear.
  late Schoolyear comparisonSchoolyear;

  @override
  void initState() {
    highlightGrade = ValueNotifier(null);
    isRefreshing = ValueNotifier<bool>(true);

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

  @override
  void dispose() {
    highlightGrade.dispose();
    isRefreshing.dispose();
    super.dispose();
  }

  ///This will get the current grades, but does not setState.
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

  Future<void> setChips() async => //Set available filterChips
      filterChips = await schoolyear.periods.periodChips(
          onChanged: () => Future.wait([setGrades(), setChips()]).then((value) {
                if (mounted) setState(() {});
              }));

  ///Refreshes the whole view and sets the state.
  Future<void> refresh(bool isOffline) async {
    //Set available filterChips
    await setChips();
    //Get the current locally saved grades and then setState. For obvious reasons this is faster compared to waiting on the API
    await setGrades();

    //Get the most recent grades for this schoolyear from the API, get them from the local storage and setState.
    //Calling setState while the widget is still building, is not that great, so we will wait until that is done.
    if (!isOffline) await schoolyear.fillGrades();

    await setGrades();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      fetch: refresh,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Cijfers",
        screenType: GradesListScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Cijfers"),
        leading: leading,
        actions: [
          if (trailingRefreshButton != null) trailingRefreshButton,
          searchAnchor()
        ],
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
        // StatisticalTilesHeader(
        //     key: const HeaderKey(), grades: gradesList ?? []),
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
        // If the user had not fetched all the weights, display a warning
        NoWeightsWarning(
          schoolyear: schoolyear,
          onDone: () => refresh(true),
        ),

        // Padding(
        //   key: const HeaderKey(),
        //   padding: const EdgeInsets.symmetric(horizontal: 8),
        //   child: CustomCard(
        //     margin: const EdgeInsets.all(4),
        //     child: ValueListenableBuilder(
        //       key: const HeaderKey(),
        //       valueListenable: highlightGrade,
        //       builder: (context, value, child) => GradesLineChart(
        //         grades: gradesQuery.applyGradeFilter(),
        //         showAverage: true,
        //         highlightGrade: value,
        //       ),
        //     ),
        //   ),
        // ),

        // Padding(
        //   key: const HeaderKey(),
        //   padding: const EdgeInsets.symmetric(horizontal: 8),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.all(4),
        //           child: FilledButton.tonalIcon(
        //             icon: const Icon(Icons.grid_4x4),
        //             onPressed: () => GradesMagisterView(
        //               schoolyear: schoolyear,
        //             ).push(context),
        //             label: const Text(
        //               "Magister Gemiddeldes",
        //               overflow: TextOverflow.ellipsis,
        //               maxLines: 1,
        //             ),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ],
    );
  }

  /// Used for searching for grades
  Widget searchAnchor() {
    return SearchAnchor(
      isFullScreen: MediaQuery.of(context).size.width < 600,
      builder: (BuildContext context, SearchController controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (context, controller) async {
        List<Schoolyear> schoolyears = await activeProfile.schoolyears
            .filter()
            .grades((q) =>
                q.descriptionContains(controller.text, caseSensitive: false))
            .findAll();
        List<Grade> grades = schoolyears
            .expand((e) => e.grades
                .filter()
                .useable(showDisabled: true)
                .descriptionContains(controller.text, caseSensitive: false)
                .findAllSync())
            .toList();
        return grades
            .sortByDate(
              (e) => e.datumIngevoerd,
            )
            .entries
            .map((e) => Column(
                  children: [
                    ListTitle(child: Text(e.key)),
                    ...e.value.map((e) => GradeTile(
                          grade: e,
                          setStateTop: setState,
                        )),
                  ],
                ));
      },
    );
  }
}

///This is the widget that is visible when the user expands the Date separators in this list of grades
class ExpandedStats extends StatelessWidget {
  const ExpandedStats({super.key, this.grades = const []});

  final List<Grade> grades;

  @override
  Widget build(BuildContext context) {
    Color containerColor = Theme.of(context).colorScheme.primaryContainer;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        TransparentLineGradesChart(grades: grades),
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...<IconData, String>{
                Icons.numbers: grades.length.toString(),
                Icons.grading_rounded:
                    "${(grades.where((e) => e.isVoldoende).length / grades.length * 100).displayNumber(decimalDigits: 0)}%"
              }
                  .map((key, value) => MapEntry(
                      key,
                      ListTile(
                          trailing: Icon(
                            key,
                            color: containerColor,
                          ),
                          title: Text(
                            value,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: containerColor),
                          ))))
                  .values,
            ]),
      ],
    );
  }
}
