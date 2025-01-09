import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/selectable_mixin.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';

class BronnenListScreen extends StatefulWidget {
  const BronnenListScreen({super.key, this.forceShowedBron});

  final Bron? forceShowedBron;

  @override
  State<BronnenListScreen> createState() => _BronnenListScreenState();
}

class _BronnenListScreenState extends State<BronnenListScreen> {
  /// Contains the current displayed "bronnen"
  List<Bron> bronnen = [];

  bool onlySaved = true;
  bool onlyFavorite = false;
  DateTimeRange? dateRange;

  Future update() async {
    bronnen = (await isar.brons
            .filter()
            .bronSoortGreaterThan(0) // Is not a folder
            .lastUsedIsNotNull()
            .not()
            .profileIsNull()
            .and()
            .profile((q) => q.uuidEqualTo(activeProfile.uuid))
            .group(
              (q) => q
                  .optional(onlySaved, (q) => q.rawSavedPathIsNotNull())
                  .or()
                  .optional(onlyFavorite, (q) => q.isFavoriteEqualTo(true)),
            )
            .and()
            .optional(
              dateRange != null,
              (q) => q.lastUsedBetween(dateRange!.start.dayOnly,
                  dateRange!.end.dayOnly.add(const Duration(days: 1))),
            )
            .sortByLastUsedDesc()
            .findAll())
        .toList();

    if (onlySaved) {
      bronnen.removeWhere((e) => e.savedPath == null);
    }
    if (widget.forceShowedBron != null &&
        bronnen.where((e) => e.uuid == widget.forceShowedBron?.uuid).isEmpty) {
      bronnen.add(widget.forceShowedBron!);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      noWait: true,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Gebruikte bronnen",
        screenType: BronnenListScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Gebruikte bronnen"),
        leading: leadingAppBarButton(context),
        actions: [
          if (trailingRefreshButton != null) trailingRefreshButton,
          _bronSearchAnchor()
        ],
      ),
      fetch: (_) => update(),
      children: [
        FilterChipList(
          chips: [
            ToggleChip(
              label: const Text("Opgeslagen"),
              icon: const Icon(Icons.save_alt),
              onChanged: (isEnabled) async {
                onlySaved = isEnabled;
                await update();
              },
              initalValue: onlySaved,
            ),
            ToggleChip(
              label: const Text("Favorieten"),
              icon: const Icon(Icons.favorite),
              onChanged: (isEnabled) async {
                onlyFavorite = isEnabled;
                await update();
              },
              initalValue: onlyFavorite,
            ),
            DateRangeChip(
              title: const Text("Data"),
              selectedRange: dateRange,
              callback: (range) async {
                dateRange = range;
                await update();
              },
            )
          ],
        ),
        ..._buildBronList(bronnen),
        if (SelectableList.maybyOf(context)?.selectedItems.isNotEmpty ?? false)
          SelectableList.maybyOf(context)!.buildExtraSheetPadding(context)!
      ],
    );
  }

  List<Widget> _buildBronList(List<Bron> bronnen) => [
        for (var bron in bronnen.sortByDate((e) => e.lastUsed).entries)
          Column(
            key: ValueKey(bron.key),
            children: [
              ListTitle(child: Text(bron.key)),
              for (var bron in bron.value)
                BronTile(
                  bron: bron,
                  // onTapCallback: () => update(),
                  selectedCallback: () => setState(() {}),
                ),
            ],
          )
      ];

  Widget _bronSearchAnchor() => SearchAnchor(
        isFullScreen: MediaQuery.of(context).size.width <= 600,
        builder: (BuildContext context, SearchController controller) {
          return IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              controller.openView();
            },
          );
        },
        suggestionsBuilder: (context, controller) async {
          return Future.value(
            _buildBronList(
              controller.text.isEmpty
                  ? []
                  : await isar.brons
                      .filter()
                      .bronSoortGreaterThan(0) // Is not a folder
                      .profile((q) => q.uuidEqualTo(activeProfile.uuid))
                      .rawNaamContains(controller.text.toLowerCase(),
                          caseSensitive: false)
                      .sortByLastUsedDesc()
                      .findAll(),
            ),
          );
        },
      );
}
