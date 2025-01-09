import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';

class RecentBronnen extends StatefulWidget {
  const RecentBronnen({super.key});

  @override
  State<RecentBronnen> createState() => _RecentBronnenState();
}

class _RecentBronnenState extends State<RecentBronnen> {
  List<Bron> bronnen = [];
  update() async {
    bronnen = (await isar.brons.where().findAll())
        .where((b) =>
            b.profile.value != null &&
            b.bronSoort != 0 &&
            b.profile.value!.uuid == activeProfile.uuid)
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...bronnen
            .sortByDate((e) => e.lastUsed, take: 3, removeNull: true)
            .entries
            .toList()
            .map((e) => Column(
                  children: [
                    ListTitle(child: Text(e.key)),
                    ...e.value.map((e) => BronTile(
                          bron: e,
                          // onTapCallback: () => update(),
                        )),
                  ],
                ))
            
      ],
    );
  }
}
