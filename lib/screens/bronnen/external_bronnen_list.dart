import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class BronDirectory {
  String name;
  int id;

  BronDirectory({
    required this.name,
    required this.id,
  });
}

class ExternalBronnenList extends StatefulWidget {
  const ExternalBronnenList({super.key, required this.source});

  final ExternalBronSource source;

  @override
  State<ExternalBronnenList> createState() => _ExternalBronnenStateList();
}

class _ExternalBronnenStateList extends State<ExternalBronnenList> {
  // Contains the current directory. If empty, the root will be selected.
  late List<BronDirectory> folderDir = [
    BronDirectory(name: widget.source.naam, id: -1)
  ];
  List<Bron> bronnen = [];

  Future<void> setBronnen() async {
    bronnen = await widget.source.bronnen.filter().sortByRawNaam().findAll();
  }

  Future<void> getBronnen(bool isOffline, [Bron? bron]) async {
    await setBronnen();
    if (mounted) setState(() {});
    if (!isOffline) {
      if (folderDir.length == 1) {
        // Fetch root
        await widget.source.syncBronnen();
      } else {
        // Fetch subfolder
        await bron?.download();
      }
      await setBronnen();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: folderDir.length < 2,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            folderDir.removeLast();
          });
        }
      },
      child: ScaffoldSkeleton(
        fetch: getBronnen,
        appBar: (isRefreshing, trailingRefreshButton, leading) =>
            SliverAppBar.medium(
          forceElevated: true,
          expandedHeight: 80,
          leading: leading,
          actions: [if (trailingRefreshButton != null) trailingRefreshButton],
          title: Text(widget.source.naam),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(38),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FolderStructureNavigatorBar(
                directory: folderDir,
                onPressed: (directory) {
                  int index =
                      folderDir.map((e) => e.id).toList().indexOf(directory.id);
                  folderDir = folderDir.getRange(0, index + 1).toList();
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        children: [
          for (var folder in bronnen.where((e) =>
              e.bronSoort == 0 && (e.parentId == folderDir.lastOrNull?.id)))
            generateFolderTile(folder),
          for (var bron in bronnen.where((e) =>
              e.bronSoort != 0 && (e.parentId == folderDir.lastOrNull?.id)))
            BronTile(bron: bron)
        ],
      ),
    );
  }

  Widget generateFolderTile(Bron folder) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(folder.naam),
      subtitle: const Text("Unknown about of items"),
      onTap: () async {
        setState(() {
          if (folderDir.last.id != folder.id) {
            folderDir.add(BronDirectory(name: folder.naam, id: folder.id));
          }
        });
        await getBronnen(false, folder);
      },
    );
  }
}

class FolderStructureNavigatorBar extends StatefulWidget {
  const FolderStructureNavigatorBar({
    super.key,
    this.directory = const [],
    this.onPressed,
  });

  final List<BronDirectory> directory;
  final Function(BronDirectory directory)? onPressed;

  @override
  State<FolderStructureNavigatorBar> createState() =>
      _FolderStructureNavigatorBarState();
}

class _FolderStructureNavigatorBarState
    extends State<FolderStructureNavigatorBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            ...<Widget>[
              for (BronDirectory dir in widget.directory)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dir.name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: widget.directory.last == dir
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                    ),
                  ),
                  onTap: () => widget.onPressed?.call(dir),
                )
            ].intersperse(Icon(
              Icons.navigate_next,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ))
          ],
        ),
      ),
    );
  }
}
