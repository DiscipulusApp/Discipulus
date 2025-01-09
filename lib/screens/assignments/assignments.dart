import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/assignments/widgets/assignment_tile.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chip_schoolyear.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:isar/isar.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  List<Assignment> assignments = [];
  AssignmentSortingType sortingType = AssignmentSortingType.deadline;

  // Filters
  DateTimeRange? range;
  AssignmentStatus? status;
  String? filterSubjectName;

  Future<void> localRefresh() async {
    if (range == null) {
      Schoolyear schoolyear = activeProfile.activeSchoolyear;
      range = DateTimeRange(start: schoolyear.begin, end: schoolyear.einde);
    }
    assignments = await activeProfile.assignments
        .filter()
        .inleverenVoorBetween(range!.start, range!.end)
        .sortByInleverenVoorDesc()
        .findAll();
  }

  Future<void> refresh(bool isOffline) async {
    await localRefresh();
    if (mounted) setState(() {});
    if (!isOffline) {
      await activeProfile.getAssignments();
      await localRefresh();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Opdrachten",
        screenType: AssignmentListScreen,
      ),
      fetch: refresh,
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Opdrachten"),
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
        leading: leading,
      ),
      children: [
        FilterChipList(
          key: const HeaderKey(),
          chips: [
            SchoolyearSelector(
              initValue: SchoolyearObject(
                activeProfile.activeSchoolyear.uuid,
                group: activeProfile.activeSchoolyear.groep,
              ),
              onSelected: (s) async {
                range = DateTimeRange(start: s!.begin, end: s.einde);
                await localRefresh();
                if (mounted) setState(() {});
              },
            ),
            _sortingChip(),
            DropDownChip<AssignmentStatus>(
              defaultTitle: "Status",
              emptySelectionAllowed: true,
              currentValue: status != null
                  ? DropDownChipItem(
                      title: status!.name.capitalized,
                      item: status!,
                    )
                  : null,
              onSelected: (value) => setState(() => status = value?.item),
              items: () async {
                return [
                  for (var status in AssignmentStatus.values)
                    DropDownChipItem(
                      title: status.name.capitalized,
                      item: status,
                    )
                ];
              },
            ),
            DropDownChip<String>(
              defaultTitle: "Vak",
              emptySelectionAllowed: true,
              currentValue: filterSubjectName != null
                  ? DropDownChipItem(
                      title: filterSubjectName!.isEmpty
                          ? "Overige"
                          : filterSubjectName!.capitalized,
                      item: filterSubjectName!,
                    )
                  : null,
              onSelected: (value) =>
                  setState(() => filterSubjectName = value?.item),
              items: () async {
                return [
                  for (String vak in {
                    for (Assignment ass in assignments) ass.vak
                  })
                    DropDownChipItem(
                      title: vak.isEmpty ? "Overige" : vak.capitalized,
                      item: vak,
                    )
                ];
              },
            )
          ],
        ),
        for (MapEntry<String, List<Assignment>> assignment in assignments
            .where(
              (e) =>
                  e.vak == (filterSubjectName ?? e.vak) &&
                  (e.status == (status ?? e.status) || status == null),
            )
            .assSort(sortingType)
            .sortByDate((e) => e.inleverenVoor, doNotSort: true)
            .entries)
          Column(
            children: [
              ListTitle(child: Text(assignment.key)),
              Column(
                children: [
                  for (Assignment assignment in assignment.value)
                    // ListTile(
                    //   title: Text(assignment.titel),
                    //   subtitle: Text([
                    //     assignment.inleverenVoor.formattedTime,
                    //     assignment.inleverenVoor.formattedDateWithoutYear
                    //   ].join(" * ")),
                    // )
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomCard(
                        child: AssignmentTile(assignment: assignment),
                      ),
                    )
                ],
              )
            ],
          ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8),
        //   child: CustomCard(child: AssignmentTile(assignment: assignment)),
        // )
      ],
    );
  }

  Widget _sortingChip() {
    return DropDownChip<AssignmentSortingType>(
      defaultTitle: "Sorteren",
      defaultIcon: const Icon(Icons.sort),
      currentValue: DropDownChipItem(
        title: sortingType.toName,
        item: sortingType,
      ),
      onSelected: (value) => setState(() {
        sortingType = value!.item;
      }),
      items: () async => [
        for (var type in AssignmentSortingType.values)
          DropDownChipItem(item: type, title: type.toName),
      ],
    );
  }
}
