import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/screens/messages/messages.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class RecentMessagesTile extends StatefulWidget {
  const RecentMessagesTile({super.key});

  @override
  State<RecentMessagesTile> createState() => _RecentMessagesTileState();
}

class _RecentMessagesTileState extends State<RecentMessagesTile> {
  Future<List<Bericht>?> refresh() async {
    return await (await activeProfile.berichtMappen
            .filter()
            .idEqualTo(1)
            .findFirst())
        ?.berichten
        .filter()
        .isGelezenEqualTo(false)
        .sortByVerzondenOpDesc()
        .limit(3)
        .findAll();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: FutureBuilder<List<Bericht>?>(
          future: refresh(),
          builder: (context, snapshot) {
            return Table(
              columnWidths: {
                0: const FlexColumnWidth(),
                1: FixedColumnWidth(
                  (snapshot.data ?? []).length > 1 ? 40 + 16 : 40 * 2 + 20,
                )
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4).copyWith(right: 0),
                      child: Column(
                        children: [
                          for (Bericht message in snapshot.data ?? [])
                            CustomCard(
                              elevation: 0,
                              child: MessageTile(bericht: message),
                            ),
                          if ((snapshot.data ?? []).isEmpty)
                            const CustomCard(
                              elevation: 0,
                              child: SizedBox(
                                height: 80,
                                child: Center(
                                  child: Text("Geen ongelezen berichten"),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(4).copyWith(left: 0),
                        child: Builder(
                          builder: (context) {
                            List<Widget> children = [
                              IconButton.filledTonal(
                                onPressed: () =>
                                    showComposeMessageSheet(context),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton.filledTonal(
                                onPressed: () => Layout.of(context)?.goToPage(
                                  const MessagesListScreen(),
                                  makeFirst: false,
                                ),
                                icon: const Icon(Icons.navigate_next),
                              )
                            ];

                            if ((snapshot.data ?? []).length > 1) {
                              return Column(
                                children: children
                                    .map(
                                      (e) => Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: children
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: SizedBox(
                                          width: 40,
                                          child: e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
    );
  }
}
