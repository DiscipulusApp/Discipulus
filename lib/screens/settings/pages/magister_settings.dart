import 'dart:convert';
import 'dart:ui' as ui;

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/personal.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/routes/persons.dart';
import 'package:discipulus/screens/calendar/calendar_details.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/screens/settings/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';

class MagisterSettingsPage extends StatefulWidget {
  const MagisterSettingsPage({super.key});

  @override
  State<MagisterSettingsPage> createState() => _MagisterSettingsPageState();
}

class _MagisterSettingsPageState extends State<MagisterSettingsPage> {
  List<ProfileAnswer> answers = [];
  ProfileAuthorization? auth;
  ProfileCareer? career;
  List<ProfileAddress> addresses = [];
  ProfileInfo? profileInfo;
  PersonInfoCardStatistics? statistics;

  Future<void> refresh(bool isOffline) async {
    // Offline does not work yet for this data.
    if (!isOffline) {
      PersonRoute route =
          activeProfile.account.value!.api.person(activeProfile.id);
      List future = await Future.wait([
        route.getAnswers,
        route.getAuthorization,
        route.getCareer,
        route.getProfileAddress,
        route.getProfileInfo,
        Future(() async {
          DateTime? start = await activeProfile.schoolyears
              .filter()
              .sortByBegin()
              .beginProperty()
              .findFirst();

          DateTime? end = await activeProfile.schoolyears
              .filter()
              .sortByEindeDesc()
              .eindeProperty()
              .findFirst();

          if (end != null && !end.difference(DateTime.now()).isNegative) {
            end = DateTime.now();
          }

          List<Schoolyear?> schoolyearID = await activeProfile.schoolyears
              .filter()
              .isHoofdAanmeldingEqualTo(true)
              .findAll();

          List<int> grades = await Future.wait([
            for (Schoolyear schoolyear in schoolyearID.nonNulls)
              schoolyear.grades.filter().useable().count()
          ]);

          int abstances = await activeProfile.calendarEvents
              .filter()
              .afwezigheidIsNotNull()
              .count();

          return PersonInfoCardStatistics(
            startDate: DateTimeRange(
                start: start ?? DateTime.now(), end: end ?? DateTime.now()),
            amountOfGrades: grades.fold(0, (p, e) => p + e),
            amountAbsences: abstances,
          );
        })
      ]);
      answers = future[0];
      auth = future[1];
      career = future[2];
      addresses = future[3];
      profileInfo = future[4];
      statistics = future[5];
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      noWait: true,
      fetch: refresh,
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Magister Instellingen"),
      ),
      children: [
        ProfileChangeWidget(
          key: const HeaderKey(),
          updateState: (fn) async {
            await refresh(false);
            setState(fn);
          },
        ),
        if (profileInfo != null || addresses.isNotEmpty || career != null)
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: PersonInfoCard(
              addresses: addresses,
              profileInfo: profileInfo,
              career: career,
              statistics: statistics,
            ),
          ),
        if (profileInfo != null || addresses.isNotEmpty || career != null)
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ContactsList(
              title: "Favorite personen",
              contacts: activeProfile.settings.favoritePeople,
              customSuggestionsBuilder: (context, controller) async {
                List<Contact>? contacts = [];
                if (controller.text.length > 2) {
                  contacts = await activeProfile.account.value?.api.messages
                      .searchContacts(controller.text);
                }
                return [
                  for (Contact contact in {
                    ...(contacts ?? []),
                  })
                    _buildContactTile(controller, contact),
                  if (activeProfile.settings.favoritePeople.isNotEmpty &&
                      (contacts?.isNotEmpty ?? true))
                    const Divider(),
                  for (Contact contact in {
                    ...activeProfile.settings.favoritePeople
                  })
                    _buildContactTile(controller, contact)
                ];
              },
            ),
          ),
        if (answers.isNotEmpty || auth != null)
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: MagisterSettingsAnswerCard(
              answers: answers,
              auth: auth,
            ),
          ),
      ],
    );
  }

  Widget _buildContactTile(SearchController controller, Contact contact) {
    return ListTile(
      leading: ContactAvatar(firstLetter: contact.fullName),
      subtitle: Text([contact.klas, contact.type].nonNulls.join(" - ")),
      title: Text(contact.fullName),
      onTap: () {
        contact.toggleFavorite();
        controller.text = ' ';
        controller.text = '';
        setState(() {});
      },
    );
  }
}

class MagisterSettingsAnswerCard extends StatelessWidget {
  const MagisterSettingsAnswerCard(
      {super.key, required this.answers, this.auth});

  final List<ProfileAnswer> answers;
  final ProfileAuthorization? auth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          const ListTile(title: Text("Toestemmingen")),
          for (var e in answers)
            CustomCard(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(e.omschrijving),
                  subtitle: Text(
                      "Veranderd op: ${e.datumAangepast.formattedDateAndTime}"),
                  leading: AllowedNotAllowedIcon(allowed: e.toestemming),
                  childrenPadding: const EdgeInsets.all(8),
                  children: [Text(e.uitleg)],
                ),
              ),
            ),
          if (auth != null) ...[
            const Divider(),
            CustomCard(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ListTile(
                  title: const Text("Ouders mogen gegevens zien"),
                  subtitle: !auth!.magInzageOudersInstellen
                      ? const Text("Je mag dit nog niet aanpassen")
                      : const Text(
                          "Je hebt toestemmingen om de ouderinzage aan te passen"),
                  leading: AllowedNotAllowedIcon(
                    allowed: auth!.oudersMogenGegevensZien ||
                        !auth!.magInzageOudersInstellen,
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}

class PersonInfoCardStatistics {
  DateTimeRange startDate;
  int amountOfGrades;
  int amountAbsences;

  PersonInfoCardStatistics({
    required this.startDate,
    required this.amountOfGrades,
    required this.amountAbsences,
  });
}

class PersonInfoCard extends StatefulWidget {
  const PersonInfoCard({
    super.key,
    this.profileInfo,
    this.addresses = const [],
    this.career,
    this.statistics,
  });

  final List<ProfileAddress> addresses;
  final ProfileInfo? profileInfo;
  final ProfileCareer? career;
  final PersonInfoCardStatistics? statistics;

  @override
  State<PersonInfoCard> createState() => _PersonInfoCardState();
}

class _PersonInfoCardState extends State<PersonInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          margin: const EdgeInsets.all(8).copyWith(bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // width: 128,
                height: 192,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: CustomCard(
                    margin: const EdgeInsets.all(8).copyWith(right: 0),
                    child: InkWell(
                      onTap: () => showProfilePictureDialog(context).then(
                        (value) => setState(() {}),
                      ),
                      child: activeProfile.base64ProfilePicture != null
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Image.memory(
                                fit: BoxFit.cover,
                                const Base64Decoder().convert(
                                    activeProfile.base64ProfilePicture!),
                                gaplessPlayback: true,
                                cacheHeight: 128 * 2,
                                cacheWidth: 128 * 2,
                                width: 128 * 2,
                                height: 128 * 2,
                              ),
                            )
                          : const Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Naam"),
                      subtitle: Text(activeProfile.name),
                    ),
                    if (widget.career?.stamNr != null)
                      ListTile(
                        title: const Text("Stam nummer"),
                        subtitle: Text(widget.career!.stamNr),
                      ),
                    if (widget.career?.klas != null)
                      ListTile(
                        title: const Text("Klas"),
                        subtitle: Text(widget.career!.klas!),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.career?.studie != null)
          ListTile(
            title: const Text("Studie"),
            subtitle: Text(widget.career!.studie),
          ),
        if (widget.career?.examenNr != null)
          ListTile(
            title: const Text("Examennummer"),
            subtitle: Text(widget.career!.examenNr!),
          ),
        if (widget.career?.profielen != null)
          ListTile(
            title: const Text("Profielen"),
            subtitle: Text(widget.career!.profielen!),
          ),
        if (widget.statistics != null)
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.start),
                  title: const Text("Startdatum"),
                  subtitle: Text(
                      "Je starte dit avontuur op ${widget.statistics!.startDate.start.formattedDate}. \nJe zit dus al ${widget.statistics!.startDate.duration.toName} op school."),
                ),
                ListTile(
                  leading: const Icon(Icons.numbers),
                  title: const Text("Aantal cijfers"),
                  subtitle: Text(
                      "Je hebt ${widget.statistics!.amountOfGrades} cijfers gehaald."),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Aantal absenties"),
                  subtitle: Text(
                      "Je bent ${widget.statistics!.amountAbsences} keer absent geweest."),
                )
              ],
            ),
          ),
        if (widget.profileInfo?.mobiel != null)
          ListTile(
            title: const Text("Mobiel"),
            subtitle: Text(widget.profileInfo!.mobiel!),
          ),
        if (widget.profileInfo?.emailAdres != null)
          ListTile(
            title: const Text("E-mailadres (school)"),
            subtitle: Text(widget.profileInfo!.emailAdres!),
          ),
        if (widget.profileInfo?.emailAdresPrive != null)
          ListTile(
            title: const Text("E-mailadres (privé)"),
            subtitle: Text(widget.profileInfo!.emailAdresPrive!),
          ),
        for (var address in widget.addresses)
          ListTile(
            title: Text("${address.type}adres"),
            subtitle: Text(
              [
                address.straat,
                address.huisnummer,
                address.toevoeging?.nullOnEmpty,
                address.postcode,
                address.plaats,
                address.land,
              ].nonNulls.join(" "),
            ),
          ),
      ],
    );
  }
}

Future<void> showProfilePictureDialog(BuildContext context) async {
  await showDialog(
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return const Dialog.fullscreen(
        child: _ProfilePictureDialog(),
      );
    },
  );
}

class _ProfilePictureDialog extends StatefulWidget {
  const _ProfilePictureDialog();

  @override
  State<_ProfilePictureDialog> createState() => __ProfilePictureDialogState();
}

class __ProfilePictureDialogState extends State<_ProfilePictureDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profielfoto'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              if (activeProfile.base64ProfilePicture != null) {
                final box = context.findRenderObject() as RenderBox?;
                Rect? rect = box != null
                    ? (box.localToGlobal(Offset.zero) & box.size)
                    : null;

                final imageBytes = const Base64Decoder()
                    .convert(activeProfile.base64ProfilePicture!);

                await Share.shareXFiles(
                  [
                    XFile.fromData(
                      imageBytes,
                      mimeType: "image/png",
                      name:
                          "${DateTime.now().toIso8601String()}-${activeProfile.name}",
                    )
                  ],
                  sharePositionOrigin: rect,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final XFile? image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                maxHeight: 512,
                maxWidth: 512,
              );

              Future<String> convertToSquareBase64() async {
                final imageBytes = await image!.readAsBytes();
                final ui.Image originalImage =
                    await decodeImageFromList(imageBytes);

                final double originalWidth = originalImage.width.toDouble();
                final double originalHeight = originalImage.height.toDouble();

                // Determine the smaller dimension for the square crop
                final squareSize = originalWidth < originalHeight
                    ? originalWidth
                    : originalHeight;

                // Calculate the offsets to center the crop
                final offsetX = (originalWidth - squareSize) / 2;
                final offsetY = (originalHeight - squareSize) / 2;

                // Define the rectangle to crop from the original image
                final srcRect = Rect.fromLTWH(
                  offsetX,
                  offsetY,
                  squareSize,
                  squareSize,
                );

                // Define the rectangle to paint onto the canvas (the full square)
                final dstRect = Rect.fromLTWH(0, 0, squareSize, squareSize);

                // Create a PictureRecorder and Canvas
                final recorder = ui.PictureRecorder();
                final canvas = Canvas(
                  recorder,
                  Rect.fromLTWH(0, 0, squareSize, squareSize),
                );

                // Paint the cropped portion of the original image onto the canvas
                canvas.drawImageRect(originalImage, srcRect, dstRect, Paint());

                // Finish recording and get the Picture
                final ui.Picture picture = recorder.endRecording();

                // Convert the Picture to an Image
                final img = await picture.toImage(
                  squareSize.toInt(),
                  squareSize.toInt(),
                );

                // Get the raw image bytes (PNG format is usually good for lossless)
                final byteData =
                    await img.toByteData(format: ui.ImageByteFormat.png);
                final squareImageBytes = byteData!.buffer.asUint8List();

                // Encode to Base64
                final base64 = base64Encode(squareImageBytes);

                return base64;
              }

              if (image != null) {
                activeProfile
                  ..customBase64ProfilePicture = await convertToSquareBase64()
                  ..save();
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              if (activeProfile.customBase64ProfilePicture != null) {
                // A custom profile picture was set, returning to the
                // original one
                activeProfile
                  ..customBase64ProfilePicture = null
                  ..save();
                setState(() {});
              } else {
                // No custom profile picture was set, getting the new one
                // from Magister.
                String? profilePicture = await activeProfile.account.value?.api
                    .person(activeProfile.id)
                    .profilepicture;
                if (profilePicture != null) {
                  activeProfile
                    ..magisterBase64ProfilePicture = profilePicture
                    ..save();
                  setState(() {});
                }
              }
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 5,
          child: activeProfile.base64ProfilePicture != null
              ? Image.memory(
                  const Base64Decoder()
                      .convert(activeProfile.base64ProfilePicture!),
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                )
              : const Icon(Icons.person),
        ),
      ),
    );
  }
}
