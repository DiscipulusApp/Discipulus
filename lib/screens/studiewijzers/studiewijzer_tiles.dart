import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_details.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_extensions.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/context_menu.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/input_dialog.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/selectable_mixin.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:super_context_menu/super_context_menu.dart';

class StudieWijzerTile extends StatefulWidget {
  const StudieWijzerTile(
    this.studiewijzer, {
    super.key,
    this.callback,
    this.navigationTile = true,
  });

  final Studiewijzer studiewijzer;
  final void Function()? callback;
  final bool navigationTile;

  @override
  State<StudieWijzerTile> createState() => _StudieWijzerTileState();
}

class _StudieWijzerTileState extends State<StudieWijzerTile>
    with SelectableListItem {
  @override
  get selectableId => widget.studiewijzer.uuid;

  @override
  Widget build(BuildContext context) {
    return CustomContextMenuWidget(
      liftBuilder: (context, child) => CustomCard(
        margin: EdgeInsets.zero,
        child: child,
      ),
      menuProvider: (MenuRequest request) {
        return Menu(children: menu);
      },
      child: ListTile(
        title: Text(
          widget.studiewijzer.titel.capitalized,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.studiewijzer.onderdelen.isNotEmpty
              ? "${widget.studiewijzer.onderdelen.length} Onderdelen"
              : widget.studiewijzer.lastUsed != null
                  ? "Geen onderdelen"
                  : "Niet gebruikt",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing:
            SelectableList.maybyOf(context)?.selectedItems.isNotEmpty ?? false
                ? null
                : widget.navigationTile
                    ? const Icon(Icons.navigate_next)
                    : const Icon(Icons.edit),
        leading: GestureDetector(
          onTap:
              widget.studiewijzer.groupedUUIDS.isEmpty && widget.navigationTile
                  ? () => selection(context)
                  : null,
          child: CoinflipTransition(
            turned: isSelected,
            back: CustomCard(
              margin: EdgeInsets.zero,
              color: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                height: 50,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.done,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
            front: Hero(
              tag: "${widget.studiewijzer.uuid}",
              child: Badge(
                offset: const Offset(2, -12),
                alignment: Alignment.bottomRight,
                isLabelVisible: widget.studiewijzer.isFavorite,
                label: widget.studiewijzer.isFavorite
                    ? const Icon(
                        Icons.favorite,
                        size: 12,
                      )
                    : null,
                child: CustomCard(
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: SizedBox(
                    height: 50,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          child: widget.studiewijzer.icon,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onLongPress:
            widget.studiewijzer.groupedUUIDS.isEmpty && widget.navigationTile
                ? () => selection(context)
                : null,
        onTap: SelectableList.maybyOf(context)?.selectedItems.isNotEmpty ??
                false
            ? widget.studiewijzer.groupedUUIDS.isEmpty
                ? () => selection(context)
                : null
            : widget.navigationTile
                ? () => StudieWijzerScreen(studiewijzer: widget.studiewijzer)
                        .push(context)
                        .then(
                      (value) {
                        if (widget.callback != null) widget.callback!();
                      },
                    )
                : () => editMenu(),
      ),
    );
  }

  List<MenuElement> get menu => [
        if (widget.navigationTile &&
            widget.studiewijzer.groupedUUIDS.isEmpty &&
            SelectableList.maybyOf(context) != null) ...[
          MenuAction(
            title: (SelectableList.maybyOf(context)?.selectedItems.isNotEmpty ??
                    false)
                ? isSelected
                    ? "Verwijderen uit selectie"
                    : "Toevoegen aan selectie"
                : "Map maken",
            image: MenuImage.icon(Icons.create_new_folder),
            activator: const SingleActivator(LogicalKeyboardKey.keyN),
            callback: () => selection(context),
          ),
          MenuSeparator(),
        ],
        MenuAction(
          title: "Favoriet",
          image: MenuImage.icon(
            widget.studiewijzer.isFavorite
                ? Icons.favorite
                : Icons.favorite_outline,
          ),
          activator: const SingleActivator(LogicalKeyboardKey.keyF),
          callback: () {
            widget.studiewijzer
              ..isFavorite = !widget.studiewijzer.isFavorite
              ..save();
            widget.callback!();
          },
        ),
        MenuAction(
          title: "Hernoemen",
          image: MenuImage.icon(Icons.edit),
          activator: const SingleActivator(LogicalKeyboardKey.f2),
          callback: () async {
            String currentName = widget.studiewijzer.titel;
            String? newName = await showTextInputDialog(context,
                title: "Hernoemen",
                prefill: currentName,
                hint: widget.studiewijzer.rawTitel);
            widget.studiewijzer
              ..titel = newName != ""
                  ? newName ?? widget.studiewijzer.titel
                  : widget.studiewijzer.rawTitel
              ..save();
            widget.callback!();
          },
        ),
        MenuAction(
          title: "Icoon instellen",
          image: MenuImage.icon(Icons.emoji_emotions),
          activator: const SingleActivator(LogicalKeyboardKey.keyI),
          callback: () async {
            String? currentName = widget.studiewijzer.customEmojiIcon;
            String? newName = await showTextInputDialog(
              context,
              maxLength: 1,
              title: "Icoon instellen",
              prefill: currentName,
              hint: widget.studiewijzer.customEmojiIcon ?? "",
            );
            widget.studiewijzer
              ..customEmojiIcon = newName != "" ? newName : null
              ..save();
            widget.callback!();
          },
        )
      ];

  void editMenu() {
    final box = context.findRenderObject() as RenderBox?;
    showMenu(
      context: context,
      position: RelativeRect.fromSize(
          box!.localToGlobal(Offset.zero) & box.size, box.size),
      items: menu
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
}

class GroupedStudieWijzerTile extends StatefulWidget {
  const GroupedStudieWijzerTile({
    super.key,
    required this.studiewijzers,
    this.callback,
  });

  final List<Studiewijzer> studiewijzers;
  final void Function()? callback;

  @override
  State<GroupedStudieWijzerTile> createState() =>
      _GroupedStudieWijzerTileState();
}

class _GroupedStudieWijzerTileState extends State<GroupedStudieWijzerTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) => setState(() => _isExpanded = value),
      initiallyExpanded: _isExpanded,
      leading: CustomCard(
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SizedBox(
          height: 50,
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                child: Stack(
                  children: [
                    for (var indexWijzer in widget.studiewijzers
                        .take(4)
                        .map((e) => e.icon)
                        .toList()
                        .indexed)
                      Transform.scale(
                        scale: 0.5,
                        alignment: indexWijzer.$1 == 0
                            ? Alignment.topLeft
                            : indexWijzer.$1 == 1
                                ? Alignment.topRight
                                : indexWijzer.$1 == 2
                                    ? Alignment.bottomLeft
                                    : Alignment.bottomRight,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: indexWijzer.$2,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        widget.studiewijzers.first.groupName ?? "Geen naam",
        maxLines: 2,
      ),
      subtitle: Text(
        "Groep van ${widget.studiewijzers.length} studiewijzers",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: AnimatedSwitcher(
        duration: CustomAnimatedSize.style().duration!,
        switchInCurve: CustomAnimatedSize.style().curve!,
        child: !_isExpanded
            ? SizedBox(
                key: ValueKey(_isExpanded),
              )
            : Wrap(
                key: ValueKey(_isExpanded),
                children: [
                  IconButton(
                    onPressed: () {
                      for (Studiewijzer studiewijzer in widget.studiewijzers) {
                        studiewijzer
                          ..groupedUUIDS = []
                          ..groupName = null
                          ..save();
                      }
                      widget.callback?.call();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () async {
                      String? newName = await showTextInputDialog(
                        context,
                        title: "Groepnaam",
                        prefill: widget.studiewijzers.firstOrNull?.groupName,
                      );
                      if (newName != null && newName.isNotEmpty) {
                        for (Studiewijzer studiewijzer
                            in widget.studiewijzers) {
                          studiewijzer
                            ..groupName = newName
                            ..save();
                        }
                      }
                      widget.callback?.call();
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
      ),
      children: [
        for (Studiewijzer studiewijzer in widget.studiewijzers)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: StudieWijzerTile(
              studiewijzer,
              callback: widget.callback,
            ),
          )
      ],
    );
  }
}

extension StudieWijzerSortingTypeExtension on StudieWijzerSortingType {
  String get toName {
    switch (this) {
      case StudieWijzerSortingType.alphabetical:
        return "Alphabetisch";
      case StudieWijzerSortingType.lastUsed:
        return "Laast gebruikt";
      default:
        return "Geen";
    }
  }
}

enum StudieWijzerSortingType { alphabetical, lastUsed, none }

extension GroupedStudieWijzerListExtension on List<List<Studiewijzer>> {
  List<List<Studiewijzer>> stuSort(StudieWijzerSortingType sortingType) {
    switch (sortingType) {
      case StudieWijzerSortingType.alphabetical:
        return this
          ..sort(
            (a, b) => (a.length > 1
                    ? a.group.first.first.groupName ?? ""
                    : a.first.titel)
                .toLowerCase()
                .compareTo((b.length > 1
                        ? b.group.first.first.groupName ?? ""
                        : b.first.titel)
                    .toLowerCase()),
          );
      case StudieWijzerSortingType.lastUsed:
        return map((e) => e
          ..sort((a, b) => (b.lastUsed?.millisecondsSinceEpoch ?? 0)
              .compareTo(a.lastUsed?.millisecondsSinceEpoch ?? 0))).toList()
          ..sort(
            (a, b) => (b.first.lastUsed?.millisecondsSinceEpoch ?? 0)
                .compareTo(a.first.lastUsed?.millisecondsSinceEpoch ?? 0),
          );
      default:
        return this;
    }
  }
}

class StudieWijzerOnderdeelTile extends StatefulWidget {
  const StudieWijzerOnderdeelTile({
    super.key,
    required this.onderdeel,
    this.isExpanded = false,
    this.callback,
    this.searchQuery,
  });

  final StudiewijzerOnderdeel onderdeel;
  final bool isExpanded;
  final String? searchQuery;
  final void Function()? callback;

  @override
  State<StudieWijzerOnderdeelTile> createState() =>
      _StudieWijzerOnderdeelTileState();
}

class _StudieWijzerOnderdeelTileState extends State<StudieWijzerOnderdeelTile> {
  late bool isExpanded = widget.isExpanded;

  String? get desc =>
      (widget.onderdeel.omschrijving ?? widget.onderdeel.omschrijvingShort)
          .nullOnEmpty;

  late List<Bron> bronnen;
  late List<Bron> folders;

  List<String?> patternTitles = [];

  void setBronnen() {
    List<Bron> mixedBronnen = widget.onderdeel.bronnen
        .filter()
        .search(widget.searchQuery)
        .sortByRawNaam()
        .findAllSync();

    bronnen = mixedBronnen.where((b) => b.type != BronType.folder).toList();

    Set folderIDs = {for (Bron bron in bronnen) bron.parentId};

    // Add all the folders that contain some found bron
    folders = widget.onderdeel.bronnen
        .where((e) => folderIDs.contains(e.id) && e.type == BronType.folder)
        .toList();

    if (appSettings.shortBronTitle) {
      patternTitles = bronnen.map((e) => e.naam).toList().simplifyPatterns();
    }
  }

  @override
  void initState() {
    setBronnen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: CustomAnimatedSize.style().duration!,
      curve: CustomAnimatedSize.style().curve!,
      padding: isExpanded
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
          : EdgeInsets.zero,
      child: CustomCard(
        elevation: isExpanded ? 1 : 0,
        margin: EdgeInsets.zero,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            expansionAnimationStyle: CustomAnimatedSize.style(),
            initiallyExpanded: widget.isExpanded,
            leading: Icon(
              Icons.bookmark,
              color: widget.onderdeel.color.harmonizeWith(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
            title: Text(widget.onderdeel.titel.capitalized),
            subtitle: (() {
              String? value;
              if (isExpanded) {
                value = bronnen.isNotEmpty
                    ? "${bronnen.length} bron(nen)"
                    : "Geen bronnen";
              } else if (!((desc ?? "").isEmptyHTML)) {
                value = desc?.withoutHTML ?? "";
              }
              return value != null
                  ? ElasticAnimation(
                      child: Text(
                        key: ValueKey("${widget.onderdeel.id}$value"),
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : null;
            })(),
            onExpansionChanged: (expanding) async {
              setState(() {
                isExpanded = expanding;
              });
              if (expanding) {
                widget.onderdeel.fill().then((value) {
                  setBronnen();
                  if (mounted) setState(() {});
                });
              }
            },
            children: [
              CustomCard(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    if (!(desc?.isEmptyHTML ?? true))
                      ExcludeFocus(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: ExpandableEventBody(
                            key: ValueKey(widget.searchQuery),
                            constraints: widget.searchQuery != null
                                ? const BoxConstraints(maxHeight: 150)
                                : const BoxConstraints(),
                            child: HTMLDisplay(
                              html: desc ?? "",
                              margin: 0,
                            ),
                          ),
                        ),
                      ),
                    if (bronnen.isNotEmpty)
                      Divider(
                        height: 2,
                        thickness: 4,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    CustomAnimatedSize(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            for (var folder in folders)
                              (() {
                                Iterable<Bron> folderBronnen = bronnen
                                    .where((b) => b.parentId == folder.id);

                                return ExpansionTile(
                                  // When a studiewijzer just contains one folder
                                  // and nothing else, expand the folder.
                                  initiallyExpanded: folders.length == 1 ||
                                      folderBronnen.length == 1,
                                  leading: const Icon(Icons.folder),
                                  title: Text(folder.naam),
                                  subtitle:
                                      Text("${folderBronnen.length} item(s)"),
                                  children: [
                                    for (Bron bron in folderBronnen)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: BronTile(
                                          bron: bron,
                                          selectedCallback: widget.callback !=
                                                  null
                                              ? () => widget.callback?.call()
                                              : null,
                                        ),
                                      )
                                  ],
                                );
                              })(),
                            for ((int, Bron) bron in bronnen
                                .where((b) => b.parentId == 0)
                                .indexed)
                              BronTile(
                                customTitle: patternTitles.isNotEmpty
                                    ? patternTitles[bron.$1]
                                    : null,
                                bron: bron.$2,
                                // selectedCallback: widget.callback != null
                                //     ? () => widget.callback?.call()
                                //     : null,
                              )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
