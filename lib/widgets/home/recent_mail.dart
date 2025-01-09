import 'package:discipulus/screens/messages/tiles.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';

class RecentMail extends StatefulWidget {
  const RecentMail({super.key});

  @override
  State<RecentMail> createState() => _RecentMailState();
}

class _RecentMailState extends State<RecentMail> {
  List<Bericht> messages = [];

  Future<void> update() async {
    messages = (await activeProfile.berichtMappen
            .filter()
            .bovenliggendeIdEqualTo(0)
            .limit(3)
            .findAll())
        .first
        .berichten
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
        ...messages
            .sortByDate((e) => e.verzondenOp,
                take: 3, removeNull: true, doNotSort: true)
            .entries
            .toList()
            .map((e) => Column(
                  children: [
                    ListTitle(child: Text(e.key)),
                    ...e.value.map((e) => MessageTile(
                          bericht: e,
                          update: update,
                        )),
                  ],
                ))
            
      ],
    );
  }
}
