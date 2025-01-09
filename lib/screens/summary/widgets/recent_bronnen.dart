import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class RecentBronnenTile extends StatefulWidget {
  const RecentBronnenTile({super.key});

  @override
  State<RecentBronnenTile> createState() => _RecentBronnenTileState();
}

class _RecentBronnenTileState extends State<RecentBronnenTile> {
  late final PageController controller;
  List<Bron> bronnen = [];

  Future<void> getbronnen() async {
    bronnen = (await isar.brons
            .filter()
            .bronSoortGreaterThan(0) // Is not a folder
            .lastUsedIsNotNull()
            .not()
            .profileIsNull()
            .and()
            .profile((q) => q.uuidEqualTo(activeProfile.uuid))
            .sortByLastUsedDesc()
            .findAll())
        .toList();
  }

  @override
  void initState() {
    controller = PageController();
    super.initState();
    getbronnen().then((value) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          columnWidths: const {0: FlexColumnWidth(), 1: FixedColumnWidth(42)},
          children: [
            TableRow(
              children: [
                SizedBox(
                  height: 100 - 16,
                  child: PageView.builder(
                    itemCount: bronnen.length,
                    controller: controller,
                    itemBuilder: (context, index) {
                      return BronTile(
                        bron: bronnen[index],
                        // hideThreeLine: true,
                      );
                    },
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: Material(
                    shape: const StadiumBorder(),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => controller.previousPage(
                            duration: Durations.short3,
                            curve: Easing.standardAccelerate,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.navigate_before),
                          ),
                        ),
                        InkWell(
                          onTap: () => controller.nextPage(
                            duration: Durations.short3,
                            curve: Easing.standardAccelerate,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.navigate_next),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
