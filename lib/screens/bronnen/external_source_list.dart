import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/screens/bronnen/external_bronnen_list.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class ExternalBronnenSourcesList extends StatefulWidget {
  const ExternalBronnenSourcesList({super.key});

  @override
  State<ExternalBronnenSourcesList> createState() =>
      _ExternalBronnenStateList();
}

class _ExternalBronnenStateList extends State<ExternalBronnenSourcesList> {
  // Contains the current directory. If empty, the root will be selected.
  List<String> folderDir = [];
  List<ExternalBronSource> externalBronnen = [];

  Future<void> setBronSources() async {
    externalBronnen =
        await activeProfile.externalBronnen.filter().sortByVolgnr().findAll();
  }

  Future<void> getBronSources(bool isOffline) async {
    await setBronSources();
    if (mounted) setState(() {});
    if (!isOffline) {
      await activeProfile.fetchExternalBronnen();
      await setBronSources();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      fetch: getBronSources,
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
        title: const Text("Externe Bronnen"),
      ),
      children: [
        for (var source in externalBronnen)
          ListTile(
            title: Text(source.naam),
            leading: const Icon(Icons.folder),
            onTap: () => ExternalBronnenList(source: source).push(context),
          )
      ],
    );
  }
}
