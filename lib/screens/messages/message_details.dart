import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/routes/messages.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/summarizer.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/filters/messages_filter.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key, required this.message});

  final Bericht message;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with ExternalRefresh {
  late final PageController pageController;
  bool showAllBronnen = false;

  // AI
  Future<void> generateSummery({bool addAttachments = false}) async {
    setState(() {
      aiPromtisLoading = true;
    });
    try {
      widget.message
        ..aiSummary = await summarizeText(
          "Subject: ${widget.message.onderwerp}\n\nContent:\n${widget.message.inhoud}",
          bronnen: addAttachments ? widget.message.bronnen : [],
        )
        ..save();
    } catch (e) {
      if (mounted) {
        setState(() {
          aiPromtisLoading = false;
        });
      }
      rethrow;
    }
    aiPromtisLoading = false;
    if (mounted) setState(() {});
  }

  Future<void> refresh() async {
    await widget.message.fill();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    pageController = PageController(keepPage: false);
    super.initState();
    if (!widget.message.isGelezen) widget.message.markAsRead();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String get messageTitle =>
      widget.message.onderwerp != null && widget.message.onderwerp != ""
          ? widget.message.onderwerp!
          : "Bericht van ${widget.message.afzender?.naam}";

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      noWait: true,
      fetch: (isOffline) async {
        if (!isOffline) await refresh();
      },
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: messageTitle,
        profileUUID: widget.message.map.value?.profile.value?.uuid,
        screenType: MessageScreen,
        extraInfo: {
          "message_uuid": widget.message.uuid,
          "message_id": widget.message.id,
          "message_title": widget.message.onderwerp,
        },
      ),
      appBar: (isRefreshing, trailingButton, leading) => SliverAppBar(
        pinned: true,
        actions: [
          if (trailingButton != null) trailingButton,
          if (widget.message.map.value?.id == -1)
            // Message is a concept
            IconButton(
              onPressed: () =>
                  showComposeMessageSheet(context, message: widget.message),
              icon: const Icon(Icons.edit),
            ),
          // if (appSettings.geminiAPIKey != null)
          //   LoadingButton(
          //     future: () async {
          //       // Summarize the mail with gemini.
          //       widget.message
          //         ..aiSummary = await summarizeText(
          //           "Subject: ${widget.message.onderwerp}\n\nContent:\n${widget.message.inhoud}",
          //           bronnen: addAttachments ? widget.message.bronnen : [],
          //         )
          //         ..save();
          //       if (mounted) setState(() {});
          //     },
          //     child: (isLoading, onTap) => IconButton(
          //       onPressed: () async {
          //         if (widget.message.heeftBijlagen) {
          //           bool? attachments = await _showSummerizeBronDialog();
          //           if (attachments != null) {
          //             addAttachments = attachments;
          //             onTap();
          //           }
          //         } else {
          //           onTap();
          //         }
          //       },
          //       icon: isLoading
          //           ? const SizedBox(
          //               height: 24,
          //               width: 24,
          //               child: CircularProgressIndicator(),
          //             )
          //           : const Icon(Icons.auto_awesome),
          //     ),
          //   ),
          IconButton(
            onPressed: isRefreshing
                ? null
                : () async {
                    isLoadingExternally.value = true;
                    await widget.message
                        .markAsRead(read: !widget.message.isGelezen);
                    isLoadingExternally.value = false;
                    setState(() {});
                  },
            icon: Icon(widget.message.isGelezen
                ? Icons.mark_email_unread
                : Icons.mark_email_read),
          ),
          MenuAnchor(
            menuChildren: [
              if (widget.message.map.value?.id !=
                  -1) // You can't reply to concepts
                MenuItemButton(
                  leadingIcon: const Icon(Icons.reply),
                  onPressed: () => showComposeMessageSheet(
                    context,
                    message: widget.message,
                    verzendoptie: VerzendOptie.beantwoord,
                  ),
                  child: const Text("Beantwoorden"),
                ),
              if (widget.message.map.value?.id !=
                  -1) // You can't forward concepts
                MenuItemButton(
                  leadingIcon: const Icon(Icons.forward),
                  onPressed: () => showComposeMessageSheet(context,
                      message: widget.message,
                      verzendoptie: VerzendOptie.doorgestuurd),
                  child: const Text("Doorsturen"),
                ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.move_to_inbox),
                onPressed: () async {
                  MessagesFolder? folder = await showMessageFolderSelector(
                    context,
                    inboxes: await widget
                        .message.map.value?.profile.value?.berichtMappen
                        .filter()
                        .findAll(),
                    initialFolder: widget.message.map.value,
                  );
                  if (folder != null) {
                    await widget.message.moveToFolder(folder.id);
                    if (mounted) setState(() {});
                  }
                },
                child: const Text("Verplaatsen"),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.delete),
                onPressed: () async {
                  await widget.message.remove();
                  Navigator.of(context).pop();
                },
                child: const Text("Verwijderen"),
              )
            ],
            child: const Icon(Icons.more_vert),
            builder: (context, controller, child) => IconButton(
              icon: child!,
              onPressed: () => controller.open(),
            ),
          ),
        ],
      ),
      children: [
        Padding(
          key: const HeaderKey(),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Text(
            messageTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        CustomCard(
          key: const HeaderKey(),
          child: ListTile(
            title: Text(widget.message.afzender?.naam ??
                widget.message.map.value?.profile.value?.name ??
                "Onbekend"),
            subtitle: Text(widget.message.verzondenOp.formattedDate),
            leading: ContactAvatar(
              heroId: widget.message.id,
              firstLetter: widget.message.afzender?.naam ??
                  widget.message.map.value!.profile.value!.name[0],
            ),
            trailing: Wrap(
              children: [
                if (widget.message.map.value?.id ==
                    -1) // You can't reply to concepts
                  IconButton(
                    onPressed: () => showComposeMessageSheet(context,
                        message: widget.message,
                        verzendoptie: VerzendOptie.beantwoord),
                    icon: const Icon(Icons.reply),
                  ),
              ],
            ),
            onTap: () {
              // Add the sender to the filters
              if (widget.message.afzender != null &&
                  Settings.activeMessageFilters
                      .whereType<MessageSenderFilter>()
                      .where((e) => e.uuid == widget.message.afzender!.id)
                      .isEmpty) {
                Settings.activeMessageFilters.add(
                  MessageSenderFilter(
                    widget.message.afzender!.id,
                    senderId: widget.message.afzender!.id,
                    senderName: widget.message.afzender!.naam,
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
        Row(
          key: const HeaderKey(),
          children: [
            CustomCard(
              // I am aware that this widget is costly, but I do not see
              // any other way of doing this properly. Using a row and mimicking
              // a ListTile is a pain because of visualDensity and because this
              // widget is only used once in a view that does not really refresh
              // that often, I feel like this is the best choice.
              child: IntrinsicWidth(
                child: ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(
                    widget.message.verzondenOp.formattedTime,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            Expanded(
              child: CustomCard(
                child: ListTile(
                  leading: const Icon(Icons.group),
                  title: Text(
                    [
                      ...widget.message.ontvangers ?? [],
                      ...widget.message.kopieOntvangers ?? []
                    ].map<String>((e) => e.weergavenaam).take(10).formattedJoin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: _contactSearchAnchor(),
                ),
              ),
            )
          ],
        ),
        if (widget.message.heeftBijlagen)
          MoreBronnenTile(bronnen: widget.message.bronnen),
        CustomAnimatedSize(
          visible: appSettings.geminiAPIKey != null,
          child: _summerizedMailCard(),
        ),
        if ((widget.message.inhoud ?? "") != "")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: HTMLDisplay(
              html: widget.message.inhoud ?? "",
              marginOnParagraphTag: true,
            ),
          ),
      ],
    );
  }

  bool aiPromptisExpanded = false;
  bool aiPromtisLoading = false;

  Widget _summerizedMailCard() {
    return AppearAnimation(
      child: (animation) => FadeTransition(
        opacity: animation,
        child: CustomCard(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).colorScheme.tertiary,
                      onPrimary: Theme.of(context).colorScheme.onTertiary,
                    ),
              ),
              child: ExpansionTile(
                onExpansionChanged: (value) async {
                  setState(() {
                    aiPromptisExpanded = value;
                  });

                  if (true) {
                    // Is expanding
                    if (widget.message.aiSummary == null) {
                      // No summery yet, generating one
                      generateSummery();
                    }
                  }
                },
                expansionAnimationStyle: AnimationStyle(
                  curve: Easing.standardAccelerate,
                  duration: Durations.short3,
                ),
                iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
                leading: const Icon(Icons.auto_awesome),
                trailing: aiPromptisExpanded
                    ? Wrap(
                        children: [
                          if (widget.message.heeftBijlagen &&
                              aiPromptisExpanded)
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: aiPromtisLoading
                                  ? null
                                  : () => generateSummery(addAttachments: true),
                            ),
                          IconButton(
                            icon: const Icon(Icons.redo),
                            onPressed:
                                aiPromtisLoading ? null : generateSummery,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(12).copyWith(right: 0),
                            child: const Icon(Icons.expand_less),
                          ),
                        ],
                      )
                    : null,
                title: const Text(
                  "AI Samenvatting",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                children: [
                  if (widget.message.aiSummary == null || aiPromtisLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  if (widget.message.aiSummary != null && !aiPromtisLoading)
                    Padding(
                      padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                      child: HTMLDisplay(html: widget.message.aiSummary ?? ""),
                    ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _contactSearchAnchor() => SearchAnchor(
        isFullScreen: MediaQuery.of(context).size.width <= 600,
        builder: (BuildContext context, SearchController controller) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: controller.openView,
            child: IgnorePointer(
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ),
          );
        },
        suggestionsBuilder: (_, controller) async {
          List ontvangers = [
            ...widget.message.ontvangers ?? [],
            ...widget.message.kopieOntvangers ?? []
          ];
          List filteredOntvangers = (controller.text.isEmpty
              ? ontvangers
              : ontvangers
                  .where((p) => p.weergavenaam
                      .toLowerCase()
                      .contains(controller.text.toLowerCase()))
                  .toList());
          return [
            for (var e in filteredOntvangers)
              ListTile(
                leading: ContactAvatar(
                    heroId: e.id,
                    firstLetter: ContactBadge.fromOntvanger(e).initials),
                title: Text(e.weergavenaam),
                subtitle: Text(e.type.capitalized),
              ),
          ];
        },
      );
}
