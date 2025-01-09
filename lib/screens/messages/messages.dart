// File: ./messages_lib/messages.dart
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/screens/messages/message_extensions.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/filters/messages_filter.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/selectable_mixin.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen>
    with ExternalRefresh, SelectableList {
  MessagesFolder? messagesFolder;
  List<Bericht> _messages = [];
  List<MessageFilter> _messageFilters = List.of(Settings.activeMessageFilters);
  @override
  late final ValueNotifier<bool> isLoadingExternally;
  late final ScrollController _scrollController;

  bool endWasReached = false;
  bool showScrollToTop = false;

  @override
  void initState() {
    messagesFolder = activeProfile.berichtMappen
        .where((e) => e.id == 1)
        .firstOrNull; // Select incoming mail
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Toggle scroll to top
    if (_scrollController.position.pixels > 400 && !showScrollToTop) {
      showScrollToTop = true;
      if (mounted) setState(() {});
    } else if (_scrollController.position.pixels <= 400 && showScrollToTop) {
      showScrollToTop = false;
      if (mounted) setState(() {});
    }

    // Load more messages when scrolling
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !isLoadingExternally.value) {
      loadMore();
    }
  }

  Future<void> changeMessagesFolder(MessagesFolder? folder) async {
    if (messagesFolder?.id == folder?.id) return;
    setState(() {
      messagesFolder = folder;
      _messages = [];
      endWasReached = false;
    });
    await refresh();
  }

  void _insertOrReplaceMessages(List<Bericht> newMessages) {
    if (_messageFilters.map((e) => e.uuid) ==
        Settings.activeMessageFilters.map((e) => e.uuid)) {
      // Filters are still the same
      for (final newMessage in newMessages) {
        final existingIndex =
            _messages.indexWhere((message) => message.id == newMessage.id);
        if (existingIndex != -1) {
          _messages[existingIndex] = newMessage;
        } else {
          _messages.add(newMessage);
        }
      }
    } else {
      // Filters are no longer the same, replacing
      _messageFilters = Settings.activeMessageFilters;
      endWasReached = false;
      _messages = newMessages;
    }
  }

  /// Fetches the latest messages from Magister
  Future<double> fetchMessages({bool loadMore = false}) async {
    isLoadingExternally.value = true;
    // Get the folders and set the inbox as the primary folder if none were
    // selected.
    await activeProfile.getBerichtMappen;
    messagesFolder ??=
        activeProfile.berichtMappen.where((e) => e.id == 1).firstOrNull;

    int amountFetched = _messages.isEmpty ? 25 : 100;

    // Get messages.
    List<Bericht> newMessages = await messagesFolder?.getMessages(
          skip: loadMore ? _messages.length : 0,
          amount: amountFetched,
          heeftBijlage: Settings.activeMessageFilters
              .whereType<MessageAttachmentFilter>()
              .firstOrNull
              ?.hasAttachment,
          heeftGelezen: Settings.activeMessageFilters
              .whereType<MessageReadFilter>()
              .firstOrNull
              ?.onlyRead,
          heeftPrioriteit: Settings.activeMessageFilters
              .whereType<MessageImportantFilter>()
              .firstOrNull
              ?.isImportant,
        ) ??
        [];
    _insertOrReplaceMessages(newMessages);
    isLoadingExternally.value = false;

    return newMessages.length / amountFetched;
  }

  /// Loads messages from storage
  Future<void> loadMessages({int? skip, int? amount}) async =>
      _insertOrReplaceMessages(
        await messagesFolder?.berichten
                .filter()
                .applyMessageFilter()
                .sortByVerzondenOpDesc()
                .offset(skip ?? 0)
                .limit(amount ?? (_messages.isEmpty ? 25 : _messages.length))
                .findAll() ??
            [],
      );

  Future<void> refresh([bool isOffline = true]) async {
    await loadMessages();
    if (mounted) setState(() {});
    if (!isOffline) {
      await fetchMessages();
      await loadMessages();
      if (mounted) setState(() {});
    }
  }

  Future<void> loadMore() async {
    if (!isLoadingExternally.value && !endWasReached) {
      isLoadingExternally.value = true;
      double ratio = 0;
      try {
        ratio = await fetchMessages(loadMore: true);
      } catch (e) {
        // Something went wrong, with the magister connection
      }

      await loadMessages();

      if (ratio != 1) {
        endWasReached = true;
      }

      isLoadingExternally.value = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      scrollController: _scrollController,
      fetch: refresh,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Berichten",
        screenType: MessagesListScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Berichten"),
        leading: leading,
        actions: [
          if (trailingRefreshButton != null) trailingRefreshButton,
          _searchAnchor()
        ],
      ),
      customBuilder: (body) {
        return Scaffold(
          primary: false,
          body: body,
          floatingActionButton: ElasticAnimation(
            child: showScrollToTop
                ? FloatingActionButton.extended(
                    key: ValueKey(showScrollToTop),
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () {
                      // Scroll to top
                      showScrollToTop = false;
                      _scrollController.animateTo(
                        0,
                        duration: Durations.medium3,
                        curve: Curves.easeInOut,
                      );
                    },
                    label: const Text("Terug naar boven"),
                  )
                : FloatingActionButton.extended(
                    key: ValueKey(showScrollToTop),
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        showComposeMessageSheet(context).then((value) async {
                      // await _refreshEntries(online: true, replace: true);
                    }),
                    label: const Text("Opstellen"),
                  ),
          ),
        );
      },
      children: [
        FilterChipList(chips: [
          InboxChip(
            inboxes: activeProfile.berichtMappen.toList(),
            initialSelected: messagesFolder,
            onSelected: changeMessagesFolder,
          ),
          ...messageFilterChips(onChanged: () async {
            await refresh();
          })
        ]),
        ..._messages
            .sortByDate((e) => e.verzondenOp, doNotSort: true)
            .entries
            .map(
              (entry) => Column(
                children: [
                  InkWell(
                    onTap: () {
                      bool wasEmpty = selectedItems.isEmpty;
                      if (entry.value.every(
                        (m) => selectedItems.contains(m.uuid),
                      )) {
                        // All of these messages have been selected, removing them
                        // all.
                        selectedItems.removeWhere(
                          (id) => entry.value.map((m) => m.uuid).contains(id),
                        );
                      } else {
                        // Not all of the messages have been selected, adding the
                        // non-selected ones.
                        selectedItems.addAll(entry.value.map((e) => e.uuid));
                      }

                      if (selectedItems.isNotEmpty && wasEmpty) {
                        showSelectionSheet(context);
                      } else if (selectedItems.isEmpty &&
                          sheetKey.currentContext != null) {
                        Navigator.of(sheetKey.currentContext!).pop();
                      }
                      setState(() {});
                    },
                    child: ListTitle(
                      selected: entry.value.every(
                        (m) => selectedItems.contains(m.uuid),
                      ),
                      child: Text(entry.key),
                    ),
                  ),
                  for (var bericht in entry.value)
                    MessageTile(bericht: bericht, update: refresh)
                ],
              ),
            )
      ],
    );
  }

  @override
  List<Widget>? headerOptionsBuilder(BuildContext context) {
    return [
      StatefulBuilder(builder: (context, modelSetState) {
        return FutureBuilder(
          future: messagesFolder?.berichten
              .filter()
              .anyOf(
                selectedItems,
                (q, uuid) => q.uuidEqualTo(uuid),
              )
              .findAll(),
          builder: (context, snapshot) {
            return Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                if (snapshot.data?.any((b) => !b.isGelezen) ?? false)
                  SelectionSheetBigOption(
                    title: const Text("Gelezen markeren"),
                    icon: const Icon(Icons.mark_email_read),
                    onTap: () async {
                      await snapshot.data?.markAsRead(read: false);
                      // await _refreshEntries(online: false, replace: true);
                      if (mounted) modelSetState(() {});
                    },
                  ),
                if (snapshot.data?.any((b) => b.isGelezen) ?? false)
                  SelectionSheetBigOption(
                    title: const Text("Ongelezen markeren"),
                    icon: const Icon(Icons.mark_as_unread),
                    onTap: () async {
                      await snapshot.data?.markAsRead(read: false);
                      // await _refreshEntries(online: false, replace: true);
                      if (mounted) modelSetState(() {});
                    },
                  ),
                if (snapshot.data
                        ?.where((b) => b.map.value?.id == -1)
                        .isEmpty ??
                    false)
                  SelectionSheetBigOption(
                    title: const Text("Verplaatsen"),
                    icon: const Icon(Icons.move_to_inbox),
                    onTap: () async {
                      MessagesFolder? folder = await showMessageFolderSelector(
                        context,
                        initialFolder: messagesFolder,
                      );
                      if (folder != null) {
                        await snapshot.data?.moveToFolder(folder.id);
                        // await _refreshEntries(online: false, replace: true);
                        if (mounted) Navigator.of(context).pop();
                      }
                    },
                  ),
                if (snapshot.data
                        ?.where(
                          (b) => b.map.value?.id == 3,
                        )
                        .isEmpty ??
                    false)
                  SelectionSheetBigOption(
                    title: const Text("Verwijderen"),
                    icon: const Icon(Icons.delete),
                    onTap: () async {
                      await snapshot.data!.removeMessages();
                      // await _refreshEntries(online: false, replace: true);
                      if (mounted) Navigator.of(context).pop();
                    },
                  ),
                const SizedBox(
                  width: 8,
                )
              ],
            );
          },
        );
      })
    ];
  }

  /// Button for searching through messages
  Widget _searchAnchor() => SearchAnchor(
        isFullScreen: MediaQuery.of(context).size.width <= 600,
        viewHintText: "Zoek in ${messagesFolder?.naam}",
        viewBuilder: (suggestions) {
          if (suggestions.isEmpty) {
            return const Center(
              child: Text("Niets gevonden"),
            );
          } else {
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) => suggestions.toList()[index],
            );
          }
        },
        viewTrailing: [
          ValueListenableBuilder(
            valueListenable: isLoadingExternally,
            builder: (context, value, child) {
              return value
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox();
            },
          )
        ],
        builder: (BuildContext context, SearchController controller) {
          return IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              controller.openView();
            },
          );
        },
        suggestionsBuilder: (_, controller) async {
          if (controller.text.isEmpty) {
            return [];
          }
          isLoadingExternally.value = true;
          // Do a local search
          List<Bericht> queryBerichten = await messagesFolder!.berichten
              .filter()
              .group((q) => q
                  .inhoudIsNotNull()
                  .and()
                  .inhoudIsNotEmpty()
                  .inhoudContains(controller.text, caseSensitive: false)
                  .or()
                  .onderwerpContains(controller.text, caseSensitive: false))
              .findAll();
          // Do a Magister search and remove duplicates
          try {
            queryBerichten.addAll(
              (controller.text.length >= 2)
                  ? ((await messagesFolder?.getMessages(
                      amount: 25,
                      skip: 0,
                      query: controller.text,
                      returnAll: false,
                    ))
                        ?..sort(
                          (a, b) => b.verzondenOp.millisecondsSinceEpoch
                              .compareTo(a.verzondenOp.millisecondsSinceEpoch),
                        ))!
                      .where((e) =>
                          !queryBerichten.map((e) => e.id).contains(e.id))
                      .toList()
                  : [],
            );
          } catch (e) {
            isLoadingExternally.value = false;
          }
          isLoadingExternally.value = false;
          // Return the found messages
          return queryBerichten.sortByDate((e) => e.verzondenOp).entries.map(
                (e) => Column(
                  children: [
                    ListTitle(child: Text(e.key)),
                    ...e.value.map((e) => MessageTile(
                          bericht: e,
                        )),
                  ],
                ),
              );
        },
      );
}
