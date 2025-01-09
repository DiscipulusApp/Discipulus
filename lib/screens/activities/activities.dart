import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/activities/widget/activity_card.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:isar/isar.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<Activity> activities = [];
  ActivitySortingType sortingType = ActivitySortingType.dates;
  bool onlyShowObligated = false;

  Future<void> refresh(bool isOffline) async {
    await setActivities();
    if (mounted) setState(() {});
    if (!isOffline) {
      await activeProfile.getActivities();
      await setActivities();
      if (mounted) setState(() {});
    }
  }

  Future<void> setActivities() async {
    activities = await activeProfile.activities.filter().findAll();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Activiteiten",
        screenType: ActivitiesScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Activiteiten"),
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
        leading: leading,
      ),
      fetch: refresh,
      children: [
        FilterChipList(
          key: const HeaderKey(),
          chips: [
            _sortingChip(),
            ToggleChip(
              label: const Text("Verplicht"),
              icon: const Icon(Icons.warning_rounded),
              initalValue: onlyShowObligated,
              onChanged: (isEnabled) => setState(() {
                onlyShowObligated = isEnabled;
              }),
            )
          ],
        ),
        ...activities
            .actSort(sortingType)
            .where((e) =>
                e.minimumAantalInschrijvingenPerActiviteit > 0 ||
                !onlyShowObligated)
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: CustomCard(child: ActivityCard(activity: e)),
              ),
            )
      ],
    );
  }

  Widget _sortingChip() {
    return DropDownChip<ActivitySortingType>(
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
        for (var type in ActivitySortingType.values)
          DropDownChipItem(item: type, title: type.toName),
      ],
    );
  }
}

extension ActivitySortingTypeExtension on ActivitySortingType {
  String get toName {
    switch (this) {
      case ActivitySortingType.alphabetical:
        return "Alphabetisch";
      case ActivitySortingType.dates:
        return "Inleverdatum";
      default:
        return "Geen";
    }
  }
}

enum ActivitySortingType { alphabetical, dates, none }

extension ActivitListExtension on List<Activity> {
  List<Activity> actSort(ActivitySortingType sortingType) {
    switch (sortingType) {
      case ActivitySortingType.alphabetical:
        return this
          ..sort(
              (a, b) => a.titel.toLowerCase().compareTo(b.titel.toLowerCase()));
      case ActivitySortingType.dates:
        return this
          ..sort((a, b) => b.eindeInschrijfdatum.millisecondsSinceEpoch
              .compareTo(a.eindeInschrijfdatum.millisecondsSinceEpoch));
      default:
        return this;
    }
  }
}
