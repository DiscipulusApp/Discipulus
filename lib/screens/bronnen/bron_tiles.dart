import 'dart:async';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/context_menu.dart';
import 'package:discipulus/widgets/global/input_dialog.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/selectable_mixin.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class BronTile extends StatefulWidget {
  const BronTile({
    super.key,
    required this.bron,
    this.allowTextOverflow = false,
    this.selectedCallback,
    this.customTitle,
  });

  final Bron bron;
  final bool allowTextOverflow;
  final void Function()? selectedCallback;

  /// This will be used as a replacement for the original title. This is useful
  /// when some parts of a bron title are not needed and can be shorted.
  final String? customTitle;

  @override
  State<BronTile> createState() => _BronTileState();
}

class _BronTileState extends State<BronTile> with SelectableListItem {
  late final StreamSubscription sub;
  final ValueNotifier<DownloadingBronInformation?> downloadInformation =
      ValueNotifier(null);

  @override
  get selectableId => widget.bron.uuid;

  @override
  void initState() {
    sub = isar.brons
        .watchObjectLazy(widget.bron.uuid, fireImmediately: true)
        .listen(
      (bron) {
        downloadInformation.value = downloadingBronnen[widget.bron.uuid];
      },
    );
    super.initState();
  }

  @override
  dispose() {
    downloadInformation.dispose();
    sub.cancel();
    super.dispose();
  }

  void onTap({bool cancelable = true}) async {
    widget.bron.updateLastUsed();
    if (downloadInformation.value?.recievedBytes != null && cancelable) {
      // A download is going on, we will cancel it.
      downloadInformation.value?.cancelToken.cancel();
      widget.bron.cleanupDownload();
      if (mounted) setState(() {});
    } else {
      if (widget.bron.savedPath != null) {
        // Bron has been downloaded, opening it.
        await widget.bron.openFile();
      } else if (cancelable) {
        // Bron has not been downloaded, downloading it.
        await widget.bron.download();
        if (mounted) setState(() {});
        if (appSettings.openAfterDownload &&
            widget.bron.type == BronType.file) {
          // Open the file after the download is done.
          onTap(cancelable: false);
        }
      }
    }
  }

  Widget buildLeading() {
    return Badge(
      offset: const Offset(4, 4),
      alignment: Alignment.bottomRight,
      isLabelVisible: widget.bron.isFavorite,
      label: widget.bron.isFavorite
          ? const Icon(
              Icons.favorite,
              size: 12,
            )
          : null,
      child: Icon(widget.bron.icon),
    );
  }

  Widget buildBronTile({bool dragged = false}) {
    return ListTile(
      onTap: SelectableList.maybyOf(context)?.selectedItems.isNotEmpty ?? false
          ? () => selection(context)
          : dragged
              ? null
              : onTap,
      leading: buildLeading(),
      title: widget.allowTextOverflow || dragged
          ? Text(dragged
              ? widget.bron.naam
              : widget.customTitle ?? widget.bron.naam)
          : EllipsisInMiddleText(
              widget.customTitle ?? widget.bron.naam,
              maxLines: 2,
            ),
      subtitle: Text(
        [
          if (widget.bron.savedPath != null) "Opgeslagen",
          if (widget.bron.grootte != 0) widget.bron.grootte.getFileSizeString(),
          if (widget.bron.datum != null &&
              widget.bron.datum!.millisecondsSinceEpoch != 0)
            widget.bron.datum?.formattedDate,
          if (widget.bron.bronSoort == 3)
            widget.bron.links.firstWhere((l) => l.rel == "Contents").href
        ].join(" • "),
        maxLines: 1,
      ),
      trailing: dragged
          ? null
          : ValueListenableBuilder(
              valueListenable: downloadInformation,
              builder: (context, downloadInformation, child) {
                // A download is going on, so we need to show a loader
                return buildContextMenu(downloadInformation);
              },
            ),
      onLongPress: () => selection(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      canAddItemToExistingSession: true,
      allowedOperations: () => [DropOperation.copy],
      dragItemProvider: (request) => widget.bron.dragItemProvider(
        request,
        onDownloadDone: () => setState(() {}),
      ),
      dragBuilder: (context, child) =>
          Card(child: buildBronTile(dragged: true)),
      liftBuilder: (context, child) =>
          Card(child: buildBronTile(dragged: true)),
      child: CustomContextMenuWidget(
        liftBuilder: (context, child) => Card(
          margin: EdgeInsets.zero,
          child: buildBronTile(dragged: true),
        ),
        menuProvider: (MenuRequest request) {
          return Menu(children: menu(downloadInformation.value));
        },
        child: DraggableWidget(child: buildBronTile()),
      ),
    );
  }

  Widget buildContextMenu(DownloadingBronInformation? downloadInformation) {
    return PopupMenuButton(
      child: downloadInformation?.recievedBytes != null
          ? IconButton(
              onPressed: null,
              icon: SizedBox(
                height: 24,
                width: 24,
                child: ValueListenableBuilder<int?>(
                    valueListenable: downloadInformation!.recievedBytes!,
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        value: value != 0 && value != null
                            ? (value / downloadInformation.totalBytes!)
                            : null,
                      );
                    }),
              ),
            )
          : SelectableList.maybyOf(context)?.selectedItems.isNotEmpty ?? false
              ? Checkbox(
                  value: isSelected,
                  onChanged: (value) => selection(context),
                )
              : null,
      itemBuilder: (BuildContext context) => menu(downloadInformation)
          .map<PopupMenuEntry>((item) => (item is MenuAction)
              ? PopupMenuItem(
                  onTap: item.callback,
                  child: ListTile(
                    title: Text(item.title!),
                    leading: item.image?.asWidget(
                      IconThemeData(
                        color: item.attributes.destructive
                            ? Theme.of(context).colorScheme.error
                            : null,
                      ),
                    ),
                  ),
                )
              : const PopupMenuDivider() as PopupMenuEntry)
          .toList(),
    );
  }

  List<MenuElement> menu(DownloadingBronInformation? downloadInformation) => [
        MenuAction(
          title: (() {
            if (widget.bron.savedPath != null ||
                widget.bron.type == BronType.link) {
              return "Open";
            }
            if (downloadInformation?.recievedBytes != null) {
              // Download is going on
              return "Stop download";
            } else if (appSettings.openAfterDownload) {
              return "Download & open";
            } else {
              return "Download";
            }
          })(),
          callback: onTap,
          image: MenuImage.icon((() {
            if (widget.bron.savedPath == null) {
              if (widget.bron.type == BronType.folder) {
                return Icons.expand_more;
              } else if (widget.bron.type == BronType.link) {
                return Icons.open_in_browser;
              } else if (downloadInformation?.recievedBytes == null) {
                return Icons.file_download;
              } else {
                return Icons.cancel;
              }
            }
            return Icons.open_in_new;
          })()),
        ),
        MenuSeparator(),
        if (widget.bron.savedPath == null &&
            appSettings.openAfterDownload &&
            widget.bron.type == BronType.file)
          MenuAction(
            callback: () async {
              await widget.bron.download();
              if (mounted) setState(() {});
            },
            image: MenuImage.icon(Icons.cloud_download_outlined),
            title: "Download",
          ),
        if (SelectableList.maybyOf(context) != null)
          MenuAction(
            callback: () => selection(context),
            title: isSelected ? "Deselecteren" : "Selecteren",
            image: MenuImage.icon(
                isSelected ? Icons.select_all : Icons.select_all_outlined),
          ),
        MenuAction(
          title: widget.bron.isFavorite ? "Onfavoriet" : "Favoriet",
          image: MenuImage.icon(
              widget.bron.isFavorite ? Icons.favorite : Icons.favorite_outline),
          callback: () {
            widget.bron.toggleFavorite();
            setState(() {});
          },
        ),
        MenuAction(
          title: "Hernoemen",
          image: MenuImage.icon(Icons.edit),
          callback: () async {
            String currentName =
                (widget.bron.naam.split(".")..removeLast()).join();
            String? newName = await showTextInputDialog(
              context,
              title: "Hernoemen",
              suffix: ".${widget.bron.rawNaam.split(".").last}",
              prefill: currentName,
              hint: (widget.bron.rawNaam.split(".")..removeLast()).join(),
            );
            if (mounted) {
              setState(() {
                widget.bron.customName =
                    "${(newName != "" && newName != null) ? newName : widget.bron.rawNaam.removePossibleExtension}.${widget.bron.rawNaam.split(".").last}";
              });
            }
          },
        ),
        MenuAction(
          callback: () async => await [widget.bron].share(context),
          image: MenuImage.icon(Icons.share),
          title: "Deel",
        ),
        if (widget.bron.savedPath != null)
          MenuAction(
            title: "Verwijderen",
            attributes: const MenuActionAttributes(destructive: true),
            image: MenuImage.icon(Icons.delete),
            callback: () {
              widget.bron.remove();
              setState(() {});
            },
          ),
      ];
}

class MoreBronnenTile extends StatefulWidget {
  const MoreBronnenTile({super.key, required this.bronnen});

  final Iterable<Bron> bronnen;

  @override
  State<MoreBronnenTile> createState() => _MoreBronnenTileState();
}

class _MoreBronnenTileState extends State<MoreBronnenTile> {
  bool _showMore = false;
  List<Bron> get bronnen =>
      widget.bronnen.toList()..sort((a, b) => a.naam.compareTo(b.naam));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          key: const HeaderKey(),
          child: CustomAnimatedSize(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  for (Bron bron in _showMore ? bronnen : bronnen.take(2))
                    BronTile(bron: bron)
                ],
              ),
            ),
          ),
        ),
        if (widget.bronnen.length > 2)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElasticAnimation(
                    child: FilledButton.tonalIcon(
                      key: ValueKey(_showMore),
                      onPressed: () => setState(() {
                        _showMore = !_showMore;
                      }),
                      icon: Icon(
                          _showMore ? Icons.expand_less : Icons.expand_more),
                      label: SizedBox(
                        width: double.infinity,
                        child: Text(
                          _showMore
                              ? "Minder bronnen weergeven"
                              : "Nog ${widget.bronnen.length - 2} meer",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _bronSearchAnchor(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _bronSearchAnchor() => SearchAnchor(
        isFullScreen: MediaQuery.of(context).size.width <= 600,
        builder: (BuildContext context, SearchController controller) {
          return FilledButton.tonalIcon(
            onPressed: controller.openView,
            icon: const Icon(Icons.search),
            label: const Text("Zoeken"),
          );
        },
        suggestionsBuilder: (_, controller) async {
          return Future.value(
            (controller.text.isEmpty
                    ? bronnen
                    : bronnen
                        .where((p) => p.naam
                            .toLowerCase()
                            .contains(controller.text.toLowerCase()))
                        .toList())
                .map(
              (e) => BronTile(bron: e),
            ),
          );
        },
      );
}
