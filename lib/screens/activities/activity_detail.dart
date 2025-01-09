import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/activities/widget/activity_card.dart';
import 'package:discipulus/screens/activities/widget/activity_element_card.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreen();
}

class _ActivityDetailScreen extends State<ActivityDetailScreen> {
  /// This is the activity that is displayed, it is saved because it changes
  /// when the user signs up for an element.
  late Activity activity;

  /// These are the activity elements. These as saved, so they can be searched and filterd
  List<ActivityElement> activityElements = [];

  /// Constains the current input of the search box
  String searchString = "";
  // Contans the current sorting method
  ActivityElementSortingType sortingType = ActivityElementSortingType.magister;

  // Filters
  bool showFull = true;
  bool onlyShowSignedUp = false;

  /// Will refresh everything, from activity to the elements
  Future<void> refresh(bool isOffline) async {
    if (!isOffline) await activity.profile.value!.getActivities();
    activity = (await activity.profile.value!.activities
        .filter()
        .uuidEqualTo(activity.uuid)
        .findFirst())!;
    if (!isOffline) await activity.getElements();
    activityElements = activity.elements.toList();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    activity = widget.activity;
    activityElements = activity.elements.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      noWait: true,
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: Text(activity.titel),
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
      ),
      fetch: refresh,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: widget.activity.titel,
        profileUUID: widget.activity.profile.value?.uuid,
        screenType: ActivityDetailScreen,
        extraInfo: {
          "activity_uuid": widget.activity.uuid,
          "activity_id": widget.activity.id,
          "activity_title": widget.activity.titel,
        },
      ),
      children: [
        // Header
        Padding(
          key: const HeaderKey(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomCard(
            child: ActivityCard(
              activity: activity,
              navigationCard: false,
            ),
          ),
        ),

        // Search box
        Padding(
          key: const HeaderKey(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomCard(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: TextField(
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) =>
                    setState(() => searchString = value.toLowerCase()),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: "Zoek naar titels en beschrijvingen...",
                ),
              ),
            ),
          ),
        ),

        // Filters
        FilterChipList(
          key: const HeaderKey(),
          chips: [
            _sortingChip(),
            ToggleChip(
              label: const Text("Volle activiteiten"),
              initalValue: showFull,
              onChanged: (isEnabled) => setState(() {
                showFull = isEnabled;
              }),
            ),
            ToggleChip(
              label: const Text("Ingeschreven"),
              initalValue: onlyShowSignedUp,
              onChanged: (isEnabled) => setState(() {
                onlyShowSignedUp = isEnabled;
              }),
            )
          ],
        ),

        // Activities

        ...activityElements
            .actSort(sortingType)
            .where((e) => (showFull || e.isOpInTeSchrijven))
            .where((e) =>
                (e.isIngeschreven && onlyShowSignedUp) || !onlyShowSignedUp)
            .where((e) =>
                e.titel.toLowerCase().contains(searchString) ||
                (e.details != null &&
                    e.details!.toLowerCase().contains(searchString)))
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomCard(
                  child: ActivityElementCard(
                    activityElement: e,
                    onSignupChanged: (signedUp) => refresh(true),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  /// Builds the sorting chip
  Widget _sortingChip() {
    return DropDownChip<ActivityElementSortingType>(
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
        for (var type in ActivityElementSortingType.values)
          DropDownChipItem(item: type, title: type.toName),
      ],
    );
  }
}

enum ActivityElementSortingType { alphabetical, popularity, dates, magister }

extension ActivityElementSortingTypeExtension on ActivityElementSortingType {
  String get toName {
    switch (this) {
      case ActivityElementSortingType.alphabetical:
        return "Alphabetisch";
      case ActivityElementSortingType.dates:
        return "Inleverdatum";
      case ActivityElementSortingType.popularity:
        return "Populariteit";
      default:
        return "Magister";
    }
  }
}

extension ActivitListExtension on List<ActivityElement> {
  List<ActivityElement> actSort(ActivityElementSortingType sortingType) {
    switch (sortingType) {
      case ActivityElementSortingType.alphabetical:
        return this
          ..sort(
              (a, b) => a.titel.toLowerCase().compareTo(b.titel.toLowerCase()));
      case ActivityElementSortingType.dates:
        return this
          ..sort((a, b) => a.eindeInschrijfdatum.millisecondsSinceEpoch
              .compareTo(b.eindeInschrijfdatum.millisecondsSinceEpoch));
      case ActivityElementSortingType.popularity:
        return this
          ..sort(
            (a, b) => ((b.maxAantalDeelnemers - b.aantalPlaatsenBeschikbaar) /
                    b.maxAantalDeelnemers)
                .compareTo(
                    ((a.maxAantalDeelnemers - a.aantalPlaatsenBeschikbaar) /
                        a.maxAantalDeelnemers)),
          );
      default:
        return this
          ..sort(
            (a, b) => a.volgnummer.compareTo(b.volgnummer),
          );
    }
  }
}
