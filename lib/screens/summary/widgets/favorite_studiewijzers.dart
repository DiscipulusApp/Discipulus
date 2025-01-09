import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_tiles.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzers.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class FavoriteStudiewijzersTile extends StatefulWidget {
  const FavoriteStudiewijzersTile({super.key});

  @override
  State<FavoriteStudiewijzersTile> createState() =>
      _FavoriteStudiewijzersTileState();
}

class _FavoriteStudiewijzersTileState extends State<FavoriteStudiewijzersTile> {
  bool isExpanded = false;

  Future<List<Studiewijzer>> setStudiewijzers() async {
    return await activeProfile.studiewijzers
        .filter()
        .isFavoriteEqualTo(true)
        .sortByLastUsedDesc()
        .findAll();
  }

  Widget _buildNavigationButton() {
    return IconButton.filledTonal(
      onPressed: () => Layout.of(context)
          ?.goToPage(
            const StudiewijzerListScreen(),
            makeFirst: false,
          )
          .then(
            (value) => setStudiewijzers().then((value) {
              if (mounted) setState(() {});
            }),
          ),
      icon: const Icon(Icons.navigate_next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Studiewijzer>>(
      initialData: const [],
      future: setStudiewijzers(),
      builder: (context, snapshot) => CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FixedColumnWidth(40 + 4 * 2)
                },
                children: [
                  TableRow(
                    key: ValueKey(activeProfile.settings.lastRefresh),
                    children: [
                      CustomCard(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 80),
                          child: CustomAnimatedSize(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (snapshot.data!.isEmpty)
                                  const Center(
                                    child: Text(
                                        "Er zijn geen favoriete studiewijzers 💔"),
                                  ),
                                for (Studiewijzer studiewijzer in (isExpanded
                                    ? snapshot.data!
                                    : snapshot.data!.take(2)))
                                  StudieWijzerTile(
                                    studiewijzer,
                                    callback: () =>
                                        setStudiewijzers().then((value) {
                                      if (mounted) setState(() {});
                                    }),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (snapshot.data!.length <= 2)
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: _buildNavigationButton()),
                        )
                    ],
                  )
                ],
              ),
              if (snapshot.data!.length > 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4)
                      .copyWith(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: FilledButton.icon(
                            onPressed: () => setState(() {
                              isExpanded = !isExpanded;
                            }),
                            label: isExpanded
                                ? const Text("Zie minder")
                                : const Text("Zie meer"),
                            icon: isExpanded
                                ? const Icon(Icons.expand_less)
                                : const Icon(Icons.expand_more),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8, // Padding
                      ),
                      Expanded(child: _buildNavigationButton())
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
