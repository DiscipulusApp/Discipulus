import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/messages/message_details.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/context_menu.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/selectable_mixin.dart';
import 'package:flutter/material.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({super.key, required this.bericht, this.update});

  final Bericht bericht;
  final Future<void> Function()? update;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> with SelectableListItem {
  @override
  get selectableId => widget.bericht.uuid;

  String get _senderName {
    if (widget.bericht.afzender?.naam != null) {
      return widget.bericht.afzender!.naam;
    } else if (widget.bericht.ontvangers != null) {
      return "Naar ${widget.bericht.ontvangers!.map((e) => e.weergavenaam).formattedJoin}";
    } else if (widget.bericht.map.value?.profile.value?.name != null) {
      return widget.bericht.map.value!.profile.value!.name;
    } else {
      return "Onbekende afzender";
    }
  }

  String get _firstLetter {
    return widget.bericht.afzender?.naam.substring(0, 1) ??
        widget.bericht.map.value?.profile.value?.name.substring(0, 1) ??
        "??";
  }

  void _handleTileTap() async {
    if (SelectableList.maybyOf(context)?.selectedItems.isEmpty ?? true) {
      await MessageScreen(message: widget.bericht).push(context);
      if (widget.update != null) await widget.update!();
    } else {
      selection(context);
    }
  }

  Future<void> _markAsRead(bool read) async {
    await widget.bericht.markAsRead(read: read);
    if (mounted) setState(() {});
    await widget.update?.call();
  }

  Future<void> _moveMessage() async {
    MessagesFolder? folder = await showMessageFolderSelector(context);
    if (folder != null) {
      await widget.bericht.moveToFolder(folder.id);
      if (mounted) setState(() {});
      await widget.update?.call();
    }
  }

  Future<void> _removeMessage() async {
    await widget.bericht.remove();
    if (mounted) setState(() {});
    await widget.update?.call();
  }

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      canAddItemToExistingSession: true,
      allowedOperations: () => [DropOperation.move],
      dragItemProvider: (req) => DragItem(
        localData: {"message_uuid": widget.bericht.uuid},
      ),
      dragBuilder: (context, child) => Card(child: child),
      liftBuilder: (context, child) => Card(child: child),
      child: DraggableWidget(
        child: CustomContextMenuWidget(
          liftBuilder: (context, child) => Card(
            margin: EdgeInsets.zero,
            child: _buildTile(),
          ),
          menuProvider: (_) => contextMenu,
          child: _buildTile(),
        ),
      ),
    );
  }

  Widget _buildTile() {
    return ListTile(
      title: Text(
        _senderName,
        maxLines: 1,
        style: TextStyle(
          fontWeight:
              widget.bericht.isGelezen ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      leading: GestureDetector(
        onTap: () => selection(context),
        child: CoinflipTransition(
          turned: isSelected,
          back: CircleAvatar(
            key: ValueKey(isSelected),
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.done),
          ),
          front: ContactAvatar(
            key: ValueKey(isSelected),
            heroId: widget.bericht.id,
            firstLetter: _firstLetter,
          ),
        ),
      ),
      trailing: Wrap(
        spacing: 8,
        children: [
          if (widget.bericht.heeftPrioriteit)
            const Icon(Icons.error_outline_rounded),
          if (widget.bericht.heeftBijlagen) const Icon(Icons.attachment),
        ],
      ),
      subtitle: Text(
        widget.bericht.onderwerp ?? "Concept",
      ),
      onTap: _handleTileTap,
    );
  }

  Menu get contextMenu => Menu(
        children: [
          if (widget.bericht.isGelezen)
            MenuAction(
              image: MenuImage.icon(Icons.mark_as_unread),
              title: "Ongelezen markeren",
              callback: () => _markAsRead(false),
            ),
          if (!widget.bericht.isGelezen)
            MenuAction(
              image: MenuImage.icon(Icons.mark_email_read),
              title: "Gelezen markeren",
              callback: () => _markAsRead(true),
            ),
          MenuSeparator(),
          MenuAction(
            image: MenuImage.icon(Icons.move_to_inbox),
            title: "Veplaatsen",
            callback: () => _moveMessage(),
          ),
          MenuAction(
            attributes: const MenuActionAttributes(destructive: true),
            image: MenuImage.icon(Icons.delete),
            title: "Remove",
            callback: () => _removeMessage(),
          ),
        ],
      );
}

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({super.key, required this.firstLetter, this.heroId});

  final String firstLetter;

  /// When set a hero animation will be used.
  final int? heroId;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroId ?? hashCode,
      child: firstLetter == "HarryDeKat"
          ? const CircleAvatar(
              radius: 25,
              child: Icon(Icons.query_stats_rounded),
            )
          : CircleAvatar(
              radius: 25,
              child:
                  Text(firstLetter.characters.firstOrNull?.capitalized ?? ""),
            ),
    );
  }
}

class ContactBadge extends StatelessWidget {
  const ContactBadge(
      {super.key, required this.name, required this.initials, this.icon});

  final String name;
  final String initials;
  final Widget? icon;

  factory ContactBadge.fromDocent(Docenten docent) => ContactBadge(
        name: docent.naam ?? docent.docentcode ?? "",
        initials: (docent.naam ?? docent.docentcode ?? "")
            .split(" ")
            .first
            .characters
            .first,
      );

  factory ContactBadge.fromOntvanger(Ontvanger ontvanger) => ContactBadge(
        name: ontvanger.weergavenaam,
        initials: ontvanger.weergavenaam.split(" ").first.characters.first,
      );

  factory ContactBadge.fromVerzender(Afzender afzender) => ContactBadge(
        name: afzender.naam,
        initials: afzender.naam.split(" ").first.characters.first,
      );

  factory ContactBadge.fromContact(Contact contact) => ContactBadge(
        name:
            contact.roepnaam ?? "${contact.voorletters} ${contact.achternaam}",
        initials:
            (contact.roepnaam ?? "${contact.voorletters} ${contact.achternaam}")
                    .trim()
                    .split(" ")
                    .firstOrNull
                    ?.characters
                    .firstOrNull ??
                contact.type.characters.firstOrNull ??
                "",
      );

  @override
  Widget build(BuildContext context) {
    return Chip(
        label: Text(name),
        avatar: icon ??
            CircleAvatar(
                child: Text(
              initials,
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
            )));
  }
}

class InboxChip extends StatefulWidget {
  const InboxChip({
    super.key,
    this.title = const Text("Map"),
    required this.inboxes,
    this.onSelected,
    this.initialSelected,
  });

  final Widget title;
  final List<MessagesFolder> inboxes;
  final MessagesFolder? initialSelected;
  final void Function(MessagesFolder folder)? onSelected;

  @override
  State<InboxChip> createState() => _InboxChipState();
}

class _InboxChipState extends State<InboxChip> {
  /// THe current selected message folder, or inbox
  late final ValueNotifier<MessagesFolder?> _selected;

  @override
  void initState() {
    // Select the inbox when the widget is initted,
    // or if that is not available the first in the list
    _selected = ValueNotifier(widget.initialSelected ??
        widget.inboxes.where((e) => e.id == 1).firstOrNull ??
        widget.inboxes.firstOrNull);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: const [],
      onDropOver: (DropOverEvent event) async {
        if ((event.session.items.first.localData as Map?)?["message_uuid"] !=
            null) {
          showMessageFolderSelector(
            context,
            initiallyOpen: true,
            onSelected: (folder) {
              _selected.value = folder;
              widget.onSelected?.call(folder);
            },
          );
        }
        return DropOperation.move;
      },
      onPerformDrop: (_) async {},
      child: ValueListenableBuilder(
        valueListenable: _selected,
        builder: (context, value, child) => CustomDropDownChip(
          label: Text(value?.naam ?? "Geen mailboxen"),
          icon: value != null
              ? folderIcon(value.id)
              : const Icon(Icons.inbox_outlined),
          onPressed: () => showMessageFolderSelector(
            context,
            initialFolder: value,
            inboxes: widget.inboxes,
            onSelected: (folder) {
              _selected.value = folder;
              widget.onSelected?.call(folder);
            },
          ),
        ),
      ),
    );
  }
}

/// Gets the correct icon for each id
Widget folderIcon(int id) {
  switch (id) {
    case -1:
      return const Icon(Icons.edit_document);
    case 1:
      return const Icon(Icons.inbox);
    case 2:
      return const Icon(Icons.send);
    case 3:
      return const Icon(Icons.delete);
    default:
      return const Icon(Icons.folder);
  }
}

Future<MessagesFolder?> showMessageFolderSelector(
  BuildContext context, {
  void Function(MessagesFolder folder)? onSelected,
  List<MessagesFolder>? inboxes,
  MessagesFolder? initialFolder,
  bool initiallyOpen = false,
}) async {
  MessagesFolder? selectedFolder = initialFolder;

  Widget folderTile(
    MessagesFolder folder, {
    void Function(void Function())? setState,
    void Function(MessagesFolder selected)? callback,
  }) {
    return FolderTile(
      reloadCallback: setState != null ? () => setState(() {}) : null,
      folderId: folder.id,
      onPressed: callback != null ? () => callback(folder) : null,
      selected: selectedFolder?.id == folder.id,
      leading: Badge(
        alignment: Alignment.bottomRight,
        isLabelVisible: folder.aantalOngelezen != 0,
        label: Text(folder.aantalOngelezen.toString()),
        child: CustomCard(
          color: selectedFolder?.id == folder.id
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: folderIcon(folder.id),
          ),
        ),
      ),
      title: Text(folder.naam),
      subtitle: Text("${folder.berichten.length} bericht(en)"),
      children: [
        for (var folder in (inboxes ?? activeProfile.berichtMappen)
            .where((e) => e.bovenliggendeId == folder.id))
          folderTile(folder, setState: setState, callback: callback),
      ],
    );
  }

  await showScrollableModalBottomSheet(
    initiallyOpen: initiallyOpen,
    context: context,
    builder: (context, setState, scrollcontroller) {
      return ListView(
        controller: scrollcontroller,
        children: [
          // Select the upper inboxes
          for (var folder in (inboxes ?? activeProfile.berichtMappen)
              .where((e) => e.bovenliggendeId == 0))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: folderTile(
                folder,
                setState: setState,
                callback: (folder) {
                  selectedFolder = folder;
                  if (onSelected == null) {
                    Navigator.pop(context);
                  } else {
                    setState(() {});
                    onSelected.call(folder);
                  }
                },
              ),
            )
        ],
      );
    },
  );
  return selectedFolder;
}

class FolderTile extends StatefulWidget {
  const FolderTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    required this.children,
    this.selected = false,
    this.onPressed,
    required this.folderId,
    this.reloadCallback,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;
  final void Function()? onPressed;
  final void Function()? reloadCallback;
  final bool selected;
  final int folderId;

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  late final ExpansionTileController controller;
  DateTime? startHover;
  bool isExpanded = false;

  @override
  void initState() {
    controller = ExpansionTileController();
    super.initState();
  }

  void toggleExpansion() =>
      controller.isExpanded ? controller.collapse() : controller.expand();

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: const [],
      onPerformDrop: (event) async {
        // Move message
        await Future.wait([
          for (DropItem item in event.session.items)
            Future(() async {
              {
                Bericht? bericht = await isar.berichts
                    .get((item.localData as Map?)?["message_uuid"]);
                await bericht?.moveToFolder(widget.folderId);
              }
            })
        ]);
        if (widget.reloadCallback != null) widget.reloadCallback!();
      },
      onDropEnter: (p0) {
        if (widget.folderId != -1) {
          // You can't move messages to the concepts folder
          setState(() {
            startHover ??= DateTime.now();
          });
        }
      },
      onDropLeave: (p0) => setState(() {
        startHover = null;
      }),
      onDropOver: (DropOverEvent event) {
        // If the tile has children it should open when you are hovering for
        // awhile.
        if (widget.children.isNotEmpty) {
          if (startHover != null &&
              DateTime.now().difference(startHover!).inMilliseconds > 1500) {
            // Hovered for more than 1.5 seconds.
            setState(() {
              startHover = DateTime.now();
            });
            toggleExpansion();
          } else if (startHover != null &&
              DateTime.now().difference(startHover!).inMilliseconds > 750) {
            // Blink
            setState(() {});
          }
        }
        return widget.folderId != -1
            ? DropOperation.move
            : DropOperation.forbidden;
      },
      child: CustomCard(
        elevation: startHover != null
            ? (DateTime.now().difference(startHover!).inMilliseconds ~/ 150)
                    .isEven
                ? 4
                : 2
            : 0,
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                controller: controller,
                leading: widget.leading,
                title: widget.title,
                childrenPadding: const EdgeInsets.only(left: 16),
                subtitle: widget.subtitle,
                trailing: SizedBox(
                  width: widget.children.isNotEmpty ? 48 : 0,
                ),
                onExpansionChanged: (value) {
                  setState(() {
                    isExpanded = value;
                  });
                  // _selected.value = folder;
                  // widget.onSelected?.call(folder);
                },
                children: widget.children,
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                leading: widget.leading != null
                    ? IconTheme(
                        data: IconThemeData(
                          color: widget.selected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null,
                        ),
                        child: widget.leading!,
                      )
                    : null,
                title: widget.title,
                onExpansionChanged: widget.onPressed != null
                    ? (value) => widget.onPressed!()
                    : null,
                subtitle: widget.subtitle,
                trailing: Wrap(
                  children: [
                    if (widget.children.isNotEmpty)
                      IconButton(
                        onPressed: () => toggleExpansion(),
                        icon: RotatedBox(
                          quarterTurns: isExpanded ? 2 : 0,
                          child: const Icon(
                            Icons.expand_more,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
