import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart_averages.dart';
import 'package:discipulus/screens/grades/widgets/no_weights_warning.dart';
import 'package:discipulus/screens/grades/widgets/subject_averages_card.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chip_schoolyear.dart';
import 'package:discipulus/widgets/global/chips/chip_filter.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  late Schoolyear schoolyear;
  List<Subject>? subjects;

  // Filters
  bool rounded = false;
  bool showTrend = false;

  List<Widget> filterChips = [];

  @override
  void initState() {
    schoolyear = activeProfile.activeSchoolyear;
    _setSubjects();
    _setChips();
    super.initState();
  }

  Future<void> _setChips() async {
    var chips = await schoolyear.periods.periodChips(
      onChanged: () async {
        await _setSubjects();
      },
    );
    if (mounted) {
      setState(() {
        filterChips = chips;
      });
    }
  }

  Future<void> _setSubjects() async {
    var newSubjects = await (await schoolyear.subjects
            .filter()
            .grades((q) => q.useable())
            .gradesIsNotEmpty()
            .findAll())
        .sortSubjects();
    if (mounted) {
      setState(() {
        subjects = newSubjects;
      });
    }
  }

  Future<void> _refresh(bool isOffline) async {
    if (!isOffline) await schoolyear.fillGrades();
    await _setSubjects();
    await _setChips();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      fetch: _refresh,
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Vak Gemiddelden"),
        leading: leading,
        actions: [
          if (trailingRefreshButton != null) trailingRefreshButton,
        ],
      ),
      children: [
        CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 12)
            ..copyWith(bottom: 4),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: BarChartAverages(
              subjects: schoolyear.subjects,
              rounded: rounded,
              showTrend: showTrend &&
                  appSettings.subjectSortType != SubjectSortType.amountOfGrades,
            ),
          ),
        ),
        NoWeightsWarning(
          schoolyear: schoolyear,
          onDone: () => _refresh(true),
        ),
        FilterChipList(
          key: const HeaderKey(),
          chips: [
            SchoolyearSelector(
              initValue:
                  SchoolyearObject(schoolyear.uuid, group: schoolyear.groep),
              onSelected: (s) async {
                setState(() {
                  schoolyear = s!;
                  subjects = null;
                  filterChips = [];
                });
                await _setSubjects();
                await _setChips();
              },
            ),
            _sortingChip(),
            // ToggleChip(
            //   label: const Text("Afgerond"),
            //   onChanged: (value) => setState(() => rounded = value),
            //   initalValue: rounded,
            // ),
            // ToggleChip(
            //   label: const Text("Maandelijkse trend"),
            //   icon: const Icon(Icons.trending_up),
            //   onChanged:
            //       appSettings.subjectSortType != SubjectSortType.amountOfGrades
            //           ? (value) => setState(() => showTrend = value)
            //           : null,
            //   initalValue: showTrend &&
            //       appSettings.subjectSortType != SubjectSortType.amountOfGrades,
            // ),
            ...filterChips
          ],
        ),
        if (subjects == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else
          for (var i = 0; i < subjects!.length; i++)
            Container(
              color: i % 2 != 0
                  ? Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.4)
                  : null,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SubjectAverageTile(
                      subject: subjects![i],
                      big: true,
                      rounded: rounded,
                      showTrend: showTrend,
                    ),
                  ),
                  // if (i != subjects!.length - 1)
                  //   Divider(
                  //     height: 2,
                  //     thickness: 0,
                  //     color: Theme.of(context).colorScheme.surface,
                  //   )
                ],
              ),
            ),
      ],
    );
  }

  Widget _sortingChip() {
    return DropDownChip<SubjectSortType>(
      defaultIcon: const Icon(Icons.sort),
      currentValue: DropDownChipItem(
        title: appSettings.subjectSortType.toName,
        item: appSettings.subjectSortType,
      ),
      defaultTitle: "Sorteren",
      onSelected: (value) async {
        setState(() {
          appSettings
            ..subjectSortType = value!.item
            ..save();
        });
        await _setSubjects();
      },
      items: () async {
        return [
          for (var sortType in SubjectSortType.values)
            DropDownChipItem(item: sortType, title: sortType.toName)
        ];
      },
    );
  }
}
