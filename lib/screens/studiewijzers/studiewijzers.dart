import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_extensions.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_tiles.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/input_dialog.dart';
import 'package:discipulus/widgets/global/selectable_mixin.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:isar/isar.dart';

class StudiewijzerListScreen extends StatefulWidget {
  const StudiewijzerListScreen({super.key});

  @override
  State<StudiewijzerListScreen> createState() => _StudiewijzerListScreenState();
}

class _StudiewijzerListScreenState extends State<StudiewijzerListScreen>
    with SelectableList {
  List<Studiewijzer> studiewijzers = [];
  Map<String, List<Studiewijzer>> suggestedGroupes = {};
  bool showSuggestions = false;

  // Sorting & Filtering
  StudieWijzerSortingType sortingType = StudieWijzerSortingType.alphabetical;
  bool onlyFavorite = false;

  Future<void> setStudiewijzers() async {
    studiewijzers =
        await activeProfile.studiewijzers.filter().sortByRawTitel().findAll();

    suggestedGroupes =
        studiewijzers.where((e) => e.groupedUUIDS.isEmpty).getGroupSuggestions;

    bool isGroupIgnored(List<int> groupUUIDs) {
      return activeProfile.settings.ignoredSuggestedStudiewijzerGroups
          .contains(Object.hashAllUnordered(groupUUIDs));
    }

    suggestedGroupes.removeWhere(
        (key, value) => isGroupIgnored(value.map((e) => e.uuid).toList()));

    if (suggestedGroupes.isEmpty) showSuggestions = false;
  }

  Future<void> getStudiewijzers(bool isOffline) async {
    await setStudiewijzers();
    if (mounted) setState(() {});
    if (!isOffline) {
      await activeProfile.fetchStudiewijzers();
      await setStudiewijzers();
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return selectableListPopScope(
      child: ScaffoldSkeleton(
        activity: HandoffActivity.construct(
          type: NSUserActivityTypes.rootPage,
          title: "Studiewijzers",
          screenType: StudiewijzerListScreen,
        ),
        fetch: getStudiewijzers,
        appBar: (isRefreshing, trailingRefreshButton, leading) =>
            SliverAppBar.large(
          title: const Text("Studiewijzers"),
          actions: [if (trailingRefreshButton != null) trailingRefreshButton],
          leading: leadingAppBarButton(context),
        ),
        emptyBuilder: onlyFavorite
            ? () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Je hebt nog geen favorieten ingesteld!"),
                  ),
                )
            : null,
        customBuilder: (body) {
          return Scaffold(
            primary: false,
            body: body,
            floatingActionButton: selectedItems.isNotEmpty
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      // Get new name
                      String? name = await showTextInputDialog(context,
                          title: "Groepnaam");

                      // Get selected studiewijzers
                      List<Studiewijzer> studiewijzers =
                          await isar.studiewijzers
                              .filter()
                              .anyOf(
                                selectedItems,
                                (q, uuid) => q.uuidEqualTo(uuid),
                              )
                              .findAll();

                      if (name != null && name.isNotEmpty) {
                        for (Studiewijzer studiewijzer in studiewijzers) {
                          studiewijzer
                            ..groupedUUIDS = selectedItems.cast<int>()
                            ..groupName = name
                            ..save();
                        }
                        selectedItems.clear();
                        await setStudiewijzers();
                        if (mounted) setState(() {});
                      }
                    },
                    label: const Text("Groeperen"),
                    icon: const Icon(Icons.group_add),
                  )
                : null,
          );
        },
        children: [
          FilterChipList(
            key: const HeaderKey(),
            chips: [
              _sortingChip(),
              ToggleChip(
                label: const Text("Favorieten"),
                icon: const Icon(Icons.favorite),
                onChanged: (value) => setState(() {
                  onlyFavorite = value;
                }),
              ),
            ],
          ),
          CustomAnimatedSize(
            visible: suggestedGroupes.isNotEmpty,
            child: CustomCard(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: false,
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.auto_awesome),
                    ),
                    title: const Text("Groep suggesties gevonden"),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            "Er zijn studiewijzers gevonden die mogelijk bij elkaar horen."),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton.icon(
                                style: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.onTertiary,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                onPressed: () => setState(() {
                                  showSuggestions = !showSuggestions;
                                }),
                                label: ElasticAnimation(
                                  child: Text(
                                    key: ValueKey(showSuggestions),
                                    "${showSuggestions ? "Verberg" : "Zie"} groepen",
                                  ),
                                ),
                              )
                            ]),
                      ],
                    ),
                  ),
                  CustomAnimatedSize(
                    child: Column(
                      children: [
                        if (suggestedGroupes.isNotEmpty && showSuggestions)
                          for (MapEntry<String,
                                  List<Studiewijzer>> studiewijzers
                              in suggestedGroupes.entries)
                            AppearAnimation(
                              duration: Durations.medium3,
                              child: (animation) => FadeTransition(
                                opacity: animation,
                                child: CustomCard(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: GroupedStudiewijzerSuggestion(
                                    suggestion: studiewijzers,
                                    callback: () async =>
                                        await getStudiewijzers(true),
                                  ),
                                ),
                              ),
                            ),
                        if (showSuggestions)
                          const SizedBox(height: 4) // Padding
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          for (List<Studiewijzer> studiewijzers in studiewijzers
              .where((s) =>
                  (s.isFavorite == true && onlyFavorite) || !onlyFavorite)
              .where(
                (s) =>
                    (!suggestedGroupes.values
                            .expand((e) => e)
                            .map((e) => e.uuid)
                            .contains(s.uuid) &&
                        showSuggestions) ||
                    !showSuggestions,
              )
              .toList()
              .group
              .stuSort(sortingType))
            studiewijzers.length > 1
                ? Opacity(
                    opacity: selectedItems.isNotEmpty ? 0.5 : 1,
                    child: GroupedStudieWijzerTile(
                      studiewijzers: studiewijzers,
                      callback: () => setState(() {}),
                    ),
                  )
                : StudieWijzerTile(
                    studiewijzers.first,
                    callback: () => setState(() {}),
                  ),
          if (selectedItems.isNotEmpty) buildExtraSheetPadding(context)!
        ],
      ),
    );
  }

  Widget _sortingChip() {
    return DropDownChip<StudieWijzerSortingType>(
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
        for (var type in StudieWijzerSortingType.values)
          DropDownChipItem(item: type, title: type.toName),
      ],
    );
  }
}

class GroupedStudiewijzerSuggestion extends StatelessWidget {
  const GroupedStudiewijzerSuggestion(
      {super.key, required this.suggestion, this.callback});

  final MapEntry<String, List<Studiewijzer>> suggestion;
  final Function()? callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(suggestion.key.capitalized),
          trailing: Wrap(
            spacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  // This group will be ignored in the future
                  activeProfile
                    ..settings
                        .ignoredSuggestedStudiewijzerGroups
                        .add(Object.hashAllUnordered(
                          suggestion.value.map((e) => e.uuid),
                        ))
                    ..save();
                  callback?.call();
                },
                label: const Text("Negeren"),
              ),
              FilledButton.icon(
                onPressed: () {
                  for (Studiewijzer studiewijzer in suggestion.value) {
                    studiewijzer
                      ..groupedUUIDS =
                          suggestion.value.map((e) => e.uuid).toList()
                      ..groupName = suggestion.key.capitalized
                      ..save();
                    callback?.call();
                  }
                },
                label: const Text("Groeperen"),
              ),
            ],
          ),
        ),
        CustomCard(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Column(
            children: [
              for (Studiewijzer studiewijzer in suggestion.value)
                StudieWijzerTile(studiewijzer)
            ],
          ),
        ),
      ],
    );
  }
}
