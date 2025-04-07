import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/routes/messages.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/summarizer.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/filters/messages_filter.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
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
        SingleChildScrollView(
          key: const HeaderKey(noPadding: true),
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              spacing: 8,
              children: _messageChips(),
            ),
          ),
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

  List<Widget> _messageChips() {
    return [
      if (appSettings.geminiAPIKey != null && widget.message.inhoud != null)
        ActionChip(
          side: BorderSide(
              color: Theme.of(context).colorScheme.tertiaryContainer),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          avatar: Icon(
            Icons.auto_awesome,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          label: const Text("Samenvatting"),
          onPressed: () => showSummarizeSheet(
            context,
            text: """
            Afzender: ${widget.message.afzender?.naam ?? ""}
            Datum: ${widget.message.verzondenOp}
            Bijlagen: ${widget.message.bronnen.length}
            Onderwerp: ${widget.message.onderwerp ?? ""}
           
            ${widget.message.inhoud!}
            """,
            initialSummary: widget.message.aiSummary,
            onSummary: (summary) {
              widget.message.aiSummary = summary;
              widget.message.save();
            },
            bronnen: widget.message.bronnen,
          ),
        ),
      ElasticAnimation(
        child: LoadingButton(
          key: ValueKey(widget.message.isGelezen),
          future: () async {
            isLoadingExternally.value = true;
            await widget.message.markAsRead(read: !widget.message.isGelezen);
            isLoadingExternally.value = false;
            setState(() {});
          },
          child: (isLoading, onTap) => ActionChip(
            avatar: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                    ),
                  )
                : Icon(
                    widget.message.isGelezen
                        ? Icons.mark_email_unread
                        : Icons.mark_email_read,
                  ),
            label: Text(
              widget.message.isGelezen
                  ? "Markeer ongelezen"
                  : "Markeer gelezen",
            ),
            onPressed: isLoading ? null : onTap,
          ),
        ),
      ),
      ActionChip(
        avatar: const Icon(Icons.reply),
        label: const Text("Beantwoorden"),
        onPressed: () => showComposeMessageSheet(
          context,
          message: widget.message,
          verzendoptie: VerzendOptie.beantwoord,
        ),
      ),
      ActionChip(
        avatar: const Icon(Icons.move_to_inbox),
        label: const Text("Verplaatsen"),
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
      ),
      ActionChip(
        avatar: const Icon(Icons.forward),
        label: const Text("Doorsturen"),
        onPressed: () => showComposeMessageSheet(context,
            message: widget.message, verzendoptie: VerzendOptie.doorgestuurd),
      ),
      ActionChip(
        avatar: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
        label: const Text("Verwijderen"),
        onPressed: () async {
          bool? shouldDelete = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Weet je het zeker?"),
              content: const Text(
                  "Weet je zeker dat je dit bericht wilt verwijderen?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Annuleren"),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.error),
                    foregroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  onPressed: () async => Navigator.of(context).pop(true),
                  child: const Text("Verwijderen"),
                ),
              ],
            ),
          );
          if (shouldDelete == true && mounted) {
            await widget.message.remove();
            Navigator.of(context).pop();
          }
        },
      ),
    ];
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
          List<Ontvanger> ontvangers = [
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
            for (Ontvanger e in filteredOntvangers)
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
