import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/routes/messages.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/gemini/email_generation.dart';
import 'package:discipulus/screens/gemini/gemini.dart';
import 'package:discipulus/screens/grades/widgets/text_input.dart';
import 'package:discipulus/screens/messages/message_extensions.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/screens/settings/pages/mail_settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';
import 'package:isar/isar.dart';
import 'package:parchment/codecs.dart';
import 'package:share_handler/share_handler.dart';
import 'package:mime/mime.dart' show lookupMimeType;
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

Future<void> showComposeMessageSheet(
  BuildContext context, {
  Bericht? message,
  VerzendOptie verzendoptie = VerzendOptie.standaard,
  SharedMedia? sharedMedia,
}) =>
    showScrollableModalBottomSheet(
      isDismissible: false,
      initiallyOpen: true,
      context: context,
      builder: (context, setState, scrollcontroller) => _ComposeMessageScreen(
        message: message,
        verzendoptie: verzendoptie,
        sharedMedia: sharedMedia,
        controller: scrollcontroller,
      ),
    );

class _ComposeMessageScreen extends StatefulWidget {
  const _ComposeMessageScreen({
    this.message,
    this.verzendoptie = VerzendOptie.standaard,
    this.sharedMedia,
    required this.controller,
  });

  final Bericht? message;
  final VerzendOptie verzendoptie;
  final SharedMedia? sharedMedia;
  final ScrollController controller;

  @override
  State<_ComposeMessageScreen> createState() => _ComposeMessageScreenState();
}

class UploadedAttachmentProgress extends UploadedAttachment {
  @override
  final String path;
  final ValueNotifier<int> part = ValueNotifier(0);
  int total;

  /// If the upload failed, this value will be true
  bool failed;

  UploadedAttachmentProgress(
      {required this.path, this.total = 0, this.failed = false});
}

class _ComposeMessageScreenState extends State<_ComposeMessageScreen> {
  /// Controlers for the text inputs, these are initialized in [initState]
  late FleatherController controller;
  late final TextEditingController subjectController;

  /// This is the profile that will be used to send messages
  late Profile profile;

  /// This list contains the selected reciepients
  late final ValueNotifier<List<Contact>> reciepients;

  bool showExtraReciepientsField = false;
  late final ValueNotifier<List<Contact>> ccReciepients;
  late final ValueNotifier<List<Contact>> bccReciepients;

  /// This list contains the uploaded attachments
  Map<int, List<UploadedAttachment>> uploadedAttachmentsPerProfile = {};
  List<UploadedAttachment> get uploadedAttachments =>
      uploadedAttachmentsPerProfile[profile.uuid] ?? [];

  set uploadedAttachments(List<UploadedAttachment> value) {
    uploadedAttachmentsPerProfile[profile.uuid] = value;
  }

  /// This list contains the progress of an attachment that is still being uploaded.
  List<UploadedAttachmentProgress> attachmentsProgress = [];

  bool hasPriority = false;
  bool saveAsConcept = false;

  // Will be set if the user is editing a concept
  Bericht? concept;

  MessagesFolder? concepts;

  Timer? _debounceTimer; // Timer for debouncing FleatherController changes

  @override
  void initState() {
    super.initState();
    // Set profile to the active one
    profile = activeProfile;

    // Set concept if message is concept
    if (widget.message?.map.value?.id == -1) {
      concept = widget.message;
    }

    // Set contents if needed
    controller = FleatherController(
      document:
          widget.message?.inhoud != null || widget.sharedMedia?.content != null
              ? parchmentHtml.decode(widget.message?.inhoud != null
                  ? widget.verzendoptie == VerzendOptie.beantwoord
                      ? "<br><br><hr><br>${widget.message!.inhoud!}"
                      : widget.message!.inhoud!
                  : widget.sharedMedia!.content!)
              : null,
    )..addListener(_onFleatherChange); // Use debounced listener

    // Set subject if needed
    subjectController = TextEditingController(
      text: widget.verzendoptie == VerzendOptie.doorgestuurd
          ? "FW: ${widget.message?.onderwerp}"
          : widget.verzendoptie == VerzendOptie.beantwoord
              ? "RE: ${widget.message?.onderwerp?.replaceAll("RE: ", "")}"
              : concept != null
                  ? widget.message?.onderwerp
                  : null,
    )..addListener(onChange); // Subject changes need immediate update

    // Set reciepients if needed
    ccReciepients = ValueNotifier([]);
    bccReciepients = ValueNotifier([]);
    reciepients = ValueNotifier([
      if (widget.message?.afzender != null &&
          widget.verzendoptie == VerzendOptie.beantwoord)
        Contact(
          id: widget.message!.afzender!.id,
          achternaam: widget.message!.afzender!.naam,
        )
    ]);

    // Add attachments if needed
    if (widget.verzendoptie != VerzendOptie.beantwoord &&
        widget.message?.bronnen != null) {
      uploadedAttachments = widget.message!.bronnen
          .map((e) => UploadedAttachment(
              id: e.id, naam: e.naam, type: "bijlage", bron: e))
          .toList();
    }

    // Check if there were shared attachments
    if (widget.sharedMedia != null) {
      uploadAttachment(
              widget.sharedMedia?.attachments
                      ?.map((e) => File(e!.path))
                      .toList() ??
                  [],
              setState)
          .then((value) => setState(() {}));
    }

    // Listeners for immediate UI updates (e.g., send button state)
    reciepients.addListener(onChange);
    ccReciepients.addListener(onChange);
    bccReciepients.addListener(onChange);

    // Initial state update
    onChange();

    Future(() async => concepts =
            await profile.berichtMappen.filter().idEqualTo(-1).findFirst())
        .then((_) => checkRecentConcepts());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Cancel timer on dispose

    controller
      ..removeListener(_onFleatherChange) // Remove the specific listener
      ..dispose();
    subjectController
      ..removeListener(onChange)
      ..dispose();

    reciepients.removeListener(onChange);
    ccReciepients.removeListener(onChange);
    bccReciepients.removeListener(onChange);

    reciepients.dispose();
    ccReciepients.dispose();
    bccReciepients.dispose();
    super.dispose();
  }

  /// Debounced listener specifically for FleatherController changes
  void _onFleatherChange() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Only call onChange (which calls setState) after a delay
      if (mounted) {
        onChange();
      }
    });
  }

  /// Gets triggered after the content of a field changes (or debounced Fleather change)
  void onChange() {
    // Update handoff (can still happen frequently, but setState is the main cost)
    if (Platform.isMacOS || Platform.isIOS) updateActivity();
    // This setState rebuilds the widget, ensure widget is still mounted
    if (mounted) {
      setState(() {});
    }
  }

  /// Updates the activity
  Future<void> updateActivity() async {
    // No changes needed here, just ensure it's called reasonably
    await FlutterAppleHandoff.updateActivity(
      HandoffActivity.construct(
          profileUUID: profile.uuid,
          title: "Bericht opstellen",
          screenType: _ComposeMessageScreen,
          type: NSUserActivityTypes.bottomSheet,
          extraInfo: {
            "recievers": [for (var c in reciepients.value) c.toMap()],
            "ccRecievers": [for (var c in ccReciepients.value) c.toMap()],
            "bccRecievers": [for (var c in bccReciepients.value) c.toMap()],
            "hasPriority": hasPriority,
            "subjectContent": subjectController.text,
            "contentJSON": controller.document.toJson().toString()
          }),
    );
  }

  /// Checks for recent concepts
  Future<void> checkRecentConcepts() async {
    await concepts?.getMessages(returnAll: false);
  }

  /// This will upload a file to Magister and add the progress to [attachmentsProgress]
  Future<void> uploadAttachment(
      List<File> files, void Function(void Function()) setState,
      {bool retryFailed = false}) async {
    // Add files to files-that-are-in-progress list and call setState
    if (!retryFailed) {
      attachmentsProgress
          .addAll(files.map((e) => UploadedAttachmentProgress(path: e.path)));
    }
    // Ensure UI updates happen within the mounted state
    if (mounted) {
      setState(() {});
    }

    // Upload all the files
    await Future.wait(files.map((e) =>
        profile.account.value!.api.messages.uploadFile(e, (part, total) {
          // Update the upload progress of the file
          UploadedAttachmentProgress? progress =
              attachmentsProgress.where((p) => p.path == e.path).firstOrNull;
          progress?.part.value = part;
          progress?.total = total;
        }).then((value) {
          // The Upload was finished, so we can remove it from the files-that-are-in-progress list
          // and add it to the list of attachments
          attachmentsProgress.removeWhere((a) => a.path == e.path);
          uploadedAttachments = [...uploadedAttachments, value];
          // Ensure UI updates happen within the mounted state
          if (mounted) {
            setState(() {});
          }
        }))).onError((error, stackTrace) {
      // When the upload fails, the files should be removed from the files-that-are-in-progress list
      attachmentsProgress
          .where((a) => files.map((e) => e.path).contains(a.path))
          .firstOrNull
          ?.failed = true;
      // Ensure UI updates happen within the mounted state
      if (mounted) {
        setState(() {}); // Update UI to show failed state
      }
      return []; // Return empty list on error
    });
  }

  /// Sends the message
  Future<void> sendMessage({bool asConcept = false}) async {
    bool isConcept = asConcept || saveAsConcept;

    String subject = subjectController.text;
    if (concept != null && isConcept) {
      // This message has already been saved, so we need to sync it instead
      concept!.heeftPrioriteit = hasPriority;
      concept!.onderwerp = subject.nullOnEmpty ??
          "Concept van ${DateTime.now().formattedDateAndTimWithoutYear}";

      // Reciepients
      concept!.ontvangers = [for (var c in reciepients.value) c.toOntvanger];
      concept!.kopieOntvangers = [
        for (var c in ccReciepients.value) c.toOntvanger
      ];
      concept!.blindeKopieOntvangers = [
        for (var c in bccReciepients.value) c.toOntvanger
      ];

      // concept!.bronnen.addAll(uploadedAttachments); // Handled by syncConcept
      concept!.inhoud = parchmentHtml.encode(controller.document);
      concept!.save();
      await concept!.syncConcept(
          newAttachmentIds: [for (var u in uploadedAttachments) u.id]);
    } else {
      // This is not a concept, send the messsage
      await profile.account.value!.api.messages.sendMessage(
        gerelateerdBerichtId: widget.verzendoptie != VerzendOptie.standaard
            ? widget.message!.id
            : null,
        recepients: reciepients.value,
        copyRecepients: ccReciepients.value,
        blindCopyRecepients: bccReciepients.value,
        subject: subject,
        verzendOptie: widget.verzendoptie,
        attachments: uploadedAttachments,
        heeftPrioriteit: hasPriority,
        isConcept: isConcept,
        htmlContent: parchmentHtml.encode(controller.document),
      );
      if (isConcept) {
        // If the mail was not a concept, but was sent as a concept,
        // the new concept message should be fetched from the API.

        // Magister does not return an ID, so we have to guess the correct
        // message...
        await concepts?.getMessages(returnAll: false);

        // Sadly there is a chance that it will not fetch the correct message,
        // but I don't see how it can be done in another way.
        concept = await concepts?.berichten
            .filter()
            .onderwerpContains(subject)
            .sortByVerzondenOpDesc()
            .findFirst();
      }
    }

    // Close the sheet if still mounted
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> applyConcept(Bericht appliedConcept) async {
    await appliedConcept.fill();

    // Applying concept
    concept = appliedConcept;
    // Replace content - Create new controller to ensure update
    // Dispose old one first
    controller.removeListener(_onFleatherChange);
    controller.dispose();
    controller = FleatherController(
        document: parchmentHtml.decode(appliedConcept.inhoud ?? ""))
      ..addListener(_onFleatherChange); // Add listener to new controller

    // Replace subject
    subjectController.text = appliedConcept.onderwerp ?? "";

    // Replace recievers - Use .value setter to notify listeners
    reciepients.value = [
      ...appliedConcept.ontvangers?.map((e) => Contact(
              id: e.id,
              achternaam: e.weergavenaam,
              voorletters: e.weergavenaam.characters.first)) ??
          []
    ];
    // Clear CC/BCC when applying concept unless they were part of it (add if needed)
    ccReciepients.value = [
      ...appliedConcept.kopieOntvangers?.map((e) => Contact(
              id: e.id,
              achternaam: e.weergavenaam,
              voorletters: e.weergavenaam.characters.first)) ??
          []
    ];
    bccReciepients.value = [
      ...appliedConcept.blindeKopieOntvangers?.map((e) => Contact(
              id: e.id,
              achternaam: e.weergavenaam,
              voorletters: e.weergavenaam.characters.first)) ??
          []
    ];

    // Add attachments if needed
    uploadedAttachments = [
      ...uploadedAttachments.where((e) =>
          e.path != null), // Keep attachments that were just uploaded by user
      ...appliedConcept.bronnen.map((e) =>
          UploadedAttachment(id: e.id, naam: e.naam, type: "bijlage", bron: e))
    ];

    // Is important
    hasPriority = appliedConcept.heeftPrioriteit;

    // Trigger UI update
    onChange();
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // REMOVED ValueListenableBuilder
            FilledButton.icon(
              // Condition is evaluated on each build triggered by setState
              onPressed: saveAsConcept ||
                      (reciepients.value.isNotEmpty &&
                          subjectController.text.isNotEmpty) // Use isNotEmpty
                  ? () => sendMessage()
                  : null,
              icon: saveAsConcept
                  ? const Icon(Icons.save)
                  : const Icon(Icons.send),
              label: saveAsConcept
                  ? const Text("Opslaan")
                  : const Text("Versturen"),
            ),
          ],
        )
      ],
    );
  }

  /// Switch to the next profiles
  Future<void> nextProfile() async {
    if (widget.verzendoptie == VerzendOptie.standaard) {
      await nextActiveProfile();
      if (mounted) setState(() {});
    }
  }

  Widget _buildReceipientsTile() {
    Widget buildContactTile(ValueNotifier<List<Contact>> contacts,
        {String title = "Ontvanger(s)", Widget? leading}) {
      return CustomCard(
        elevation: 0,
        child: SearchContactsButton(
          callback: setState, // Pass setState directly
          selectedContacts: contacts,
          builder: (p0, controller) => ValueListenableBuilder<List<Contact>>(
              valueListenable: contacts,
              builder: (context, value, childWidget) {
                // Renamed 'widget'
                return ListTile(
                  leading: leading ?? const Icon(Icons.mail_outline_rounded),
                  trailing: const Icon(Icons.person_add),
                  subtitle: value.isNotEmpty
                      ? Wrap(
                          spacing: 4,
                          runSpacing: 4, // Added runSpacing for better wrap
                          children: [
                            for (var e in value) ContactBadge.fromContact(e)
                          ],
                        )
                      : Text(
                          "Klik hier om ${title.toLowerCase()} toe te voegen"),
                  title: Text(title),
                  onTap: () => controller.openView(),
                );
              }),
        ),
      );
    }

    return CustomAnimatedSize(
      child: Table(
        columnWidths: const {
          // Made const
          0: FlexColumnWidth(),
          1: FixedColumnWidth(72),
        },
        // Removed .asMap() as it's redundant with explicit keys
        children: [
          TableRow(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min, // Added for tighter layout
                children: [
                  buildContactTile(reciepients),
                  if (showExtraReciepientsField)
                    buildContactTile(
                      ccReciepients,
                      title: "Kopie ontvanger(s)",
                      leading: const Icon(Icons.forward_to_inbox),
                    ),
                  if (showExtraReciepientsField)
                    buildContactTile(
                      bccReciepients,
                      title: "Blindekopie ontvanger(s)",
                      leading: const Icon(Icons.remove_red_eye),
                    )
                ],
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.fill,
                child: Card(
                  margin: const EdgeInsets.only(
                      left: 8), // Added margin for spacing
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(12), // Match card radius
                    onTap: () => setState(() {
                      showExtraReciepientsField = !showExtraReciepientsField;
                    }),
                    child: Icon(
                      showExtraReciepientsField
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea() {
    // No changes needed here, RichTextInput handles its own state.
    return RichTextInput(
      minHeight: 200,
      extraLeadingButton: [
        // _selectConcepts(
        //   builder: (_, controller) => IconButton(
        //     onPressed: () => controller.openView(),
        //     icon: const Icon(Icons.edit_document),
        //   ),
        // )
      ],
      controller: controller,
      topWidget: CustomCard(
        margin: const EdgeInsets.all(8).copyWith(bottom: 0),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _buildAttachmentTiles(),
        ),
      ),
      placeholderText: "Of begin hier met schrijven...",
      onEmpty: [
        FilledButton.icon(
          onPressed: (!profile.settings.autoInsertHeaderAndFooter ||
                  profile.settings.autoInsertHeaderAndFooter &&
                      (profile.settings.mailHeader?.contains("\${ontvanger}") ??
                          false) &&
                      (reciepients.value.isNotEmpty ||
                          !(profile.settings.mailHeader
                                  ?.contains("\${ontvanger}") ??
                              false)))
              ? () async {
                  if (profile.settings.autoInsertHeaderAndFooter) {
                    // Insert header and footer
                    String content = profile.settings.mailHeader?.replaceAll(
                            "\${ontvanger}",
                            reciepients.value
                                .map((e) => e.fullName)
                                .formattedJoin) ??
                        "";

                    content = "$content\n${profile.settings.mailFooter}";

                    // Use replace to avoid issues if text already exists
                    final currentLength = controller.document.length;
                    controller.replaceText(0, currentLength, content,
                        selection:
                            TextSelection.collapsed(offset: content.length));

                    // No need for setState here, controller listener will handle it (debounced)
                  } else {
                    // Redirect to settings page
                    if (mounted) {
                      const MailSettingsPage().push(context);
                    }
                  }
                }
              : null,
          label: const Text("Voeg pre-fill in"),
          icon: const Icon(Icons.short_text),
        ),
        _selectConcepts(
          builder: (_, conceptController) => FilledButton.tonalIcon(
            // Renamed controller
            onPressed: () => conceptController.openView(),
            label: const Text("Gebruik concept"),
            icon: const Icon(Icons.edit_document),
          ),
        ),
        if (GeminiSettings.apiKey != null) // Check added for Gemini button
          FilledButton.tonalIcon(
            onPressed: () async {
              String? email = await showGenerationDialog(context, "");
              if (email?.nullOnEmpty != null) {
                final decoded = parchmentHtml.decode(
                  email!
                      .replaceAll(
                          "```hmtl\n", "") // Consider more robust HTML cleaning
                      .replaceAll("\n```", ""),
                );
                // Insert at current cursor position or beginning
                final index = controller.selection.baseOffset;
                final length = controller.selection.extentOffset - index;
                controller.replaceText(index, length, decoded.toPlainText(),
                    selection: TextSelection.collapsed(
                        offset: index + decoded.toPlainText().length));
                // No need for setState here, controller listener will handle it (debounced)
              }
            },
            label: const Text("Genereer email"),
            icon: const Icon(Icons.auto_awesome),
          ),
      ],
    );
  }

  Widget _buildSubjectEditor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16)
          .copyWith(left: 72, top: 10),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Voeg titel toe",
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 24.0, // Consider using Theme.of(context).textTheme
          ),
        ),
        style: const TextStyle(
          // Consider using Theme.of(context).textTheme
          fontSize: 24.0,
        ),
        controller: subjectController,
        maxLines: null,
      ),
    );
  }

  Widget _buildSelectionChips() {
    // Wrap with SingleChildScrollView for horizontal overflow
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(left: 20, bottom: 0),
      child: Row(
        // No 'spacing' property on Row, use Padding or SizedBox between chips
        // mainAxisAlignment: MainAxisAlignment.start, // Default for Row
        children: [
          DropDownChip<Profile>(
            defaultTitle: "Profiel",
            currentValue: DropDownChipItem(
              title: profile.name,
              item: profile,
              icon: ProfilePicture(
                  base64ProfilePicture: profile.base64ProfilePicture),
            ),
            items: () async {
              List<Profile> profiles = await isar.profiles.where().findAll();
              return [
                for (Profile p in profiles)
                  DropDownChipItem(title: p.name, item: p)
              ];
            },
            onSelected: (item) {
              if (widget.verzendoptie == VerzendOptie.standaard &&
                  item != null) {
                setState(() {
                  profile = item.item;
                  // Clear attachments specific to the previous profile if necessary
                  // uploadedAttachments.clear(); // Decide if this is desired behavior
                });
              }
            },
          ),
          const SizedBox(width: 8), // Spacing
          ToggleChip(
            initalValue: hasPriority,
            icon: const Icon(Icons.label_important),
            label: const Text("Belangrijk"),
            onChanged: (value) {
              setState(() {
                hasPriority = value;
              });
            },
          ),
          const SizedBox(width: 8), // Spacing
          ToggleChip(
            initalValue: saveAsConcept,
            icon: const Icon(Icons.edit_document),
            label: const Text("Concept"),
            onChanged: (value) {
              setState(() {
                saveAsConcept = value;
              });
            },
          ),
          if (GeminiSettings.apiKey != null) ...[
            const SizedBox(width: 8), // Spacing
            _buildSubjectGenerationButton()
          ]
        ],
      ),
    );
  }

  Widget _buildSubjectGenerationButton() {
    return LoadingButton(
      future: () async {
        final subject = await generateEmailSubject(
          parchmentHtml.encode(controller.document),
        );
        if (mounted) {
          subjectController.text = subject;
          // No need for setState, controller listener handles it
        }
      },
      child: (isLoading, onTap) {
        // Check plain text for emptiness
        bool isEmpty = controller.document.toPlainText().trim().isEmpty;
        return ActionChip(
          side: isLoading || isEmpty
              ? BorderSide.none // Use none instead of null
              : BorderSide(
                  color: Theme.of(context).colorScheme.tertiaryContainer),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          avatar: isLoading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, // Thinner indicator
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                )
              : Icon(
                  Icons.auto_awesome,
                  size: 18, // Smaller icon
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
          label: Text(
            "Genereer titel",
            style: TextStyle(
              // Ensure text color matches icon
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          onPressed: isLoading || isEmpty ? null : onTap,
        );
      },
    );
  }

  Widget _buildAttachmentTiles() {
    // No changes needed here, AttachmentTileList handles its own state updates via ValueNotifiers.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AttachmentTileList(
        attachmentsProgress: attachmentsProgress,
        uploadedAttachments: uploadedAttachments,
        onAttachmentUploaded: (attachment) {
          // This callback might trigger a setState in the parent if needed,
          // but currently it seems handled internally or by other triggers.
          uploadedAttachments = [...uploadedAttachments, attachment];
          if (mounted)
            setState(
                () {}); // Explicitly update if list change needs UI rebuild
        },
        onAttachmentRemoved: (attachment) {
          if (attachment.path == null) {
            widget.message
              ?..bronnen.removeWhere((u) => u.id == attachment.id)
              ..save();
          }
          uploadedAttachments.removeWhere((u) => u.id == attachment.id);
          setState(() {});
        },
        onRetry: (attachment) {
          attachment.failed = false;
          // Ensure UI updates to remove failed state immediately
          if (mounted) setState(() {});
          uploadAttachment([File(attachment.path)], setState,
              retryFailed: true);
        },
        uploadAttachment: (files) {
          uploadAttachment(files, setState); // No .then needed here
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Using ListView directly is fine here
    return DropRegion(
      formats: Formats.standardFormats,
      onPerformDrop: (PerformDropEvent event) async {
        for (var e in event.session.items) {
          e.dataReader?.getValue(
            Formats.fileUri,
            (value) {
              uploadAttachment([File(value?.toFilePath() ?? "")], setState)
                  .then((value) {
                if (mounted) setState(() {});
              });
            },
          );
        }
      },
      onDropOver: (DropOverEvent event) {
        // Check if any item contains a file URI
        final hasFile =
            event.session.items.any((item) => item.canProvide(Formats.fileUri));
        return hasFile ? DropOperation.copy : DropOperation.none;
      },
      child: ListView(
        controller: widget.controller,
        padding: EdgeInsets.zero, // Remove default padding if not needed
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: _buildHeader(),
          ),
          _buildSubjectEditor(),
          _buildSelectionChips(), // Already wrapped in SingleChildScrollView
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildReceipientsTile(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // Wrap RichTextInput in a Card for consistent styling
            child: CustomCard(
                elevation: 0,
                margin: EdgeInsets.zero, // Remove margin if padding handles it
                child: _buildTextArea()),
          ),
          const BottomSheetBottomContentPadding() // Ensure consistent bottom padding
        ],
      ),
    );
  }

  Widget _selectConcepts(
      {required Widget Function(BuildContext, SearchController) builder}) {
    return SearchAnchor(
      builder: builder,
      suggestionsBuilder: (context, anchorController) async {
        final query = anchorController.text;
        if (concepts == null || query.isEmpty)
          return []; // Handle null concepts or empty query

        final results = await concepts!.berichten
            .filter()
            .group(
              (q) => q
                  .inhoudContains(query, caseSensitive: false)
                  .or()
                  .onderwerpContains(query, caseSensitive: false),
            )
            .sortByVerzondenOpDesc()
            .findAll();

        return results
            .map<Widget>(
              (e) => GestureDetector(
                onTap: () async {
                  // Close view immediately for better UX
                  anchorController
                      .closeView(e.onderwerp); // Pass something back?
                  // Apply concept after closing
                  await applyConcept(e);
                  // State update is handled within applyConcept or its listeners
                },
                // Use AbsorbPointer to prevent inner tile taps
                child: AbsorbPointer(
                  child: MessageTile(bericht: e),
                ),
              ),
            )
            .toList(); // Removed unnecessary intermediate list/[]
      },
    );
  }
}

class AttachmentTileList extends StatefulWidget {
  const AttachmentTileList({
    super.key,
    required this.attachmentsProgress,
    required this.uploadedAttachments,
    required this.onAttachmentUploaded,
    required this.onAttachmentRemoved,
    required this.onRetry,
    required this.uploadAttachment,
  });

  final List<UploadedAttachmentProgress> attachmentsProgress;
  final List<UploadedAttachment> uploadedAttachments;
  final void Function(UploadedAttachment) onAttachmentUploaded;
  final void Function(UploadedAttachment) onAttachmentRemoved;
  final void Function(UploadedAttachmentProgress) onRetry;
  final void Function(List<File>) uploadAttachment;

  @override
  State<AttachmentTileList> createState() => _AttachmentTileListState();
}

class _AttachmentTileListState extends State<AttachmentTileList> {
  @override
  Widget build(BuildContext context) {
    List<UploadedAttachment> attachments = [
      ...widget.attachmentsProgress,
      ...widget.uploadedAttachments
    ]..sort(
        (a, b) => (a.path ?? "").compareTo(b.path ?? ""),
      );
    return Row(
      children: [
        ...attachments.map((e) => e.path != null
            ? AttachmentTile.fromFile(
                File(e.path!),
                onTap: (e is UploadedAttachmentProgress && e.failed)
                    ? () => widget.onRetry(e)
                    : () => widget.onAttachmentRemoved(e),
                total: e is UploadedAttachmentProgress && !e.failed
                    ? e.total
                    : null,
                progress: e is UploadedAttachmentProgress ? e.part : null,
              )
            : AttachmentTile(
                name: e.naam,
                key: ValueKey(e.id),
                onTap: () => widget.onAttachmentRemoved(e),
                size: e.bron?.grootte,
                mimeType: e.bron?.contentType,
                total: e is UploadedAttachmentProgress ? e.total : null,
                progress: e is UploadedAttachmentProgress ? e.part : null,
              )),
        SizedBox(
          height: 150,
          child: AspectRatio(
            aspectRatio: 1,
            child: InkWell(
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);

                if (result != null) {
                  widget.uploadAttachment(
                      result.paths.map((path) => File(path!)).toList());
                }
              },
              child: const Card.outlined(
                elevation: 1,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload_file),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        child: Text(
                          "Upload",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AttachmentTile extends StatefulWidget {
  const AttachmentTile(
      {super.key,
      this.path,
      this.progress,
      this.onTap,
      this.total,
      required this.name,
      this.mimeType,
      this.size});

  final String? path;
  final String name;
  final String? mimeType;
  final int? size;

  final void Function()? onTap;
  final ValueNotifier<int>? progress;
  final int? total;

  @override
  State<AttachmentTile> createState() => _AttachmentTileState();

  factory AttachmentTile.fromFile(File file,
          {ValueNotifier<int>? progress, void Function()? onTap, int? total}) =>
      AttachmentTile(
        key: ValueKey(file.path),
        name: file.path.split("/").last,
        size: file.lengthSync(),
        mimeType: lookupMimeType(file.path),
        path: file.path,
        progress: progress,
        onTap: onTap,
        total: total,
      );
}

class _AttachmentTileState extends State<AttachmentTile> {
  ColorScheme? colorScheme;
  late final File? file;

  bool get failedUpload =>
      (widget.total == null && widget.progress != null && file != null);

  @override
  void initState() {
    file = widget.path != null ? File(widget.path!) : null;
    super.initState();
    if (file != null && file!.canPreview) {
      Future(() async {
        colorScheme = await ColorScheme.fromImageProvider(
            provider: ResizeImage(FileImage(file!), height: 10, width: 10),
            brightness: Theme.of(context).brightness);
      }).then((value) => (mounted) ? setState(() {}) : () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(colorScheme: colorScheme ?? Theme.of(context).colorScheme),
      child: SizedBox(
        key: ValueKey(widget.path ?? widget.name),
        width: 150,
        height: 150,
        child: InkWell(
          onTap: widget.onTap,
          child: CustomCard(
            elevation: 0,
            child: Tooltip(
              message: widget.name,
              child: Stack(
                children: [
                  // Image Background
                  if (file != null && file!.canPreview || failedUpload)
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: failedUpload
                            ? Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                child: (file != null && file!.canPreview)
                                    ? Center(
                                        child: Icon(
                                        Icons.refresh,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                      ))
                                    : const SizedBox())
                            : Image.file(
                                // Background image
                                file!,
                                gaplessPlayback: true,
                                fit: BoxFit.cover,
                                cacheWidth: 250,
                                width: 250,
                              ),
                      ),
                    ),
                  // Center loader when no image is present
                  if (widget.progress != null &&
                      widget.total != null &&
                      !(file != null && file!.canPreview))
                    ValueListenableBuilder<int>(
                      valueListenable: widget.progress!,
                      builder: (context, value, child) {
                        double progress = (value / widget.total!);
                        return Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(16),
                                minHeight: 4,
                                value: progress.isNaN ||
                                        progress.isInfinite ||
                                        progress == 1
                                    ? null
                                    : progress,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // File size marker
                  if (widget.size != null)
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomCard(
                        elevation: colorScheme != null ? 16 : 0,
                        color: failedUpload
                            ? Theme.of(context).colorScheme.errorContainer
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            widget.size!.getFileSizeString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: failedUpload
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                  // File name when noimage is present
                  if (file == null || !file!.canPreview)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              failedUpload
                                  ? Icons.refresh
                                  : widget.mimeType?.iconForMime,
                              color: failedUpload
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer
                                  : null),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            child: Text(
                              widget.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  // File name box when image is present
                  if (file != null && file!.canPreview)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomAnimatedSize(
                        child: CustomCard(
                          elevation: 16,
                          color: failedUpload
                              ? Theme.of(context).colorScheme.errorContainer
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      file!.iconForFile ?? Icons.file_present,
                                      color: failedUpload
                                          ? Theme.of(context).colorScheme.error
                                          : colorScheme?.primary,
                                      size: 18,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        child: Text(file!.path.split("/").last,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: failedUpload
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onErrorContainer
                                                    : null)),
                                      ),
                                    )
                                  ],
                                ),
                                if (widget.progress != null &&
                                    widget.total != null)
                                  ValueListenableBuilder<int>(
                                    valueListenable: widget.progress!,
                                    builder: (context, value, child) {
                                      double progress = (value / widget.total!);
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: LinearProgressIndicator(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          minHeight: 4,
                                          value: progress.isNaN ||
                                                  progress.isInfinite ||
                                                  progress == 1
                                              ? null
                                              : progress,
                                        ),
                                      );
                                    },
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchContactsButton extends StatefulWidget {
  const SearchContactsButton({
    super.key,
    required this.builder,
    this.selectedContacts,
    required this.callback,
  });

  final Widget Function(BuildContext, SearchController) builder;
  final ValueNotifier<List<Contact>>? selectedContacts;
  final void Function(VoidCallback)? callback;

  @override
  State<SearchContactsButton> createState() => _SearchContactsButtonState();
}

class _SearchContactsButtonState extends State<SearchContactsButton> {
  late final SearchController searchController;
  late void Function(void Function() fn) innerSetState;
  List<Contact> searchedContacts = [];

  @override
  void initState() {
    searchController = SearchController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Shows a warning if two contacts are similair
  Future<Contact?> showSimilairContactWarning(Contact selection) async {
    bool? addAnyway = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Weet je zeker dat dit contact juist is?"),
              content: Text(
                  "Er zijn meerdere gevonden contacten met de achternaam \"${selection.achternaam.capitalized}\", weet je zeker dat dit het juiste contact is?"),
              actions: [
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.clear),
                  label: const Text("Nee"),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.check),
                  label: const Text("Ja"),
                ),
              ],
            ));
    if (addAnyway ?? false) {
      return selection;
    } else {
      return null;
    }
  }

  /// Invert The selection
  void _invertSelection() {
    // Get selected contacts from searched contacts
    Iterable<Contact>? currentSelectedContacts = widget.selectedContacts?.value
        .where((e) => [for (var e in searchedContacts) e.id].contains(e.id));

    // Add all the searched contacts that are not yet selected to the selected list
    widget.selectedContacts?.value.addAll(searchedContacts.where((e) =>
        !(widget.selectedContacts?.value.map((e) => e.id).contains(e.id) ??
            false)));

    // Remove contacts that were already selected
    widget.selectedContacts?.value.removeWhere((e) =>
        currentSelectedContacts?.map((e) => e.id).contains(e.id) ?? false);

    // Update the list
    if (widget.callback != null) widget.callback!(() {});
    updateInnerState();
  }

  void updateInnerState() {
    // innerSetState(() {});

    // For now there is no proper way to do this, so the menu will just be closed
    String previous = searchController.text;
    searchController.clear();
    searchController.value = TextEditingValue(text: previous);
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        searchController: searchController,
        builder: widget.builder,
        isFullScreen: false,
        viewElevation: 0,
        dividerColor: Theme.of(context).colorScheme.outlineVariant,
        viewTrailing: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: _invertSelection,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              if (widget.callback != null) widget.callback!(() {});
              updateInnerState();
            },
          )
        ],
        suggestionsBuilder: (context, controller) async {
          innerSetState = context.findAncestorStateOfType()!.setState;
          // We can only search for contacts using two or more characters
          searchedContacts = [
            if (controller.text.characters.length >= 2)
              ...(await activeProfile.account.value!.api.messages
                  .searchContacts(controller.text))
          ];

          return [
            <Iterable<Contact>>[
              searchedContacts.where((e) => !(widget.selectedContacts?.value
                      .map((e) => e.id)
                      .contains(e.id) ??
                  false)),
              if (widget.selectedContacts != null)
                widget.selectedContacts!.value
            ]
                .map<Iterable<Widget>?>(
                  (e) => e.map(
                    (e) => Tooltip(
                      message: [e.voorletters, e.tussenvoegsel, e.achternaam]
                          .nonNulls
                          .join(" "),
                      child: _buildContactTile(e),
                    ),
                  ),
                )
                .intersperse([
                  if ((widget.selectedContacts?.value ?? []).isNotEmpty)
                    const Divider()
                ])
                .nonNulls
                .expand((e) => e),
            [
              for (Contact contact in activeProfile.settings.favoritePeople)
                _buildContactTile(contact),
            ]
          ]
              .where((e) => e.isNotEmpty)
              .intersperse([const Divider()]).expand((e) => e);
        });
  }

  Widget _buildContactTile(Contact contact) {
    bool isSelected = widget.selectedContacts?.value
            .where((s) => s.id == contact.id)
            .firstOrNull !=
        null;

    return ListTile(
      subtitle: Text(contact.klas ?? contact.type.capitalized),
      leading: ContactAvatar(
        heroId: contact.id,
        firstLetter: contact.voorletters != ""
            ? contact.voorletters
            : contact.achternaam,
      ),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () async {
        // Add or remove the contact to the selected contact list
        if (isSelected) {
          // Remove
          widget.selectedContacts?.value.removeWhere((s) => s.id == contact.id);
        } else {
          // Add
          if (searchedContacts
                  .where((s) => s.achternaam == contact.achternaam)
                  .length >
              1) {
            // Some surnames are similiar, prompting the user
            Contact? simContact = await showSimilairContactWarning(contact);
            widget.selectedContacts?.value
                .addAll([if (simContact != null) simContact]);
          } else {
            widget.selectedContacts?.value.add(contact);
          }
        }
        if (widget.callback != null) widget.callback!(() {});
        updateInnerState();
      },
      title: Text([
        contact.roepnaam ??
            (contact.voorletters != "" ? contact.voorletters : null),
        contact.tussenvoegsel,
        contact.achternaam
      ].nonNulls.join(" ")),
    );
  }
}
