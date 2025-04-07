import 'dart:async';
import 'dart:io';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/input_dialog.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/tiles/fleather_toolbar.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';

class CalendarSaveIntent extends Intent {
  const CalendarSaveIntent();
}

class CalendarEventDetails extends StatefulWidget {
  const CalendarEventDetails({
    super.key,
    required this.combinedEvent,
    this.showSeeInContext = false,
    this.callback,
  });

  final List<CalendarEvent> combinedEvent;
  final FutureOr<void> Function()? callback;
  final bool showSeeInContext;

  @override
  State<CalendarEventDetails> createState() => _CalendarEventDetailsState();
}

class _CalendarEventDetailsState extends State<CalendarEventDetails> {
  late FleatherController controller;
  late CalendarEvent event = widget.combinedEvent.first;
  List<Contact> contacts = [];

  Future<void> refresh() async {
    await widget.combinedEvent.first.fill();
    contacts = await widget.combinedEvent.first.contacts;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    controller = FleatherController(
        document: ParchmentDocument.fromDelta(
            parchmentHtml.decode(event.inhoud ?? "").toDelta()));
    controller.addListener(onControllerUpdate);
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(onControllerUpdate);
    controller.dispose();
    super.dispose();
  }

  void onControllerUpdate() async {
    if (event.rawInfoType == InfoType.none &&
        [InfoType.none, InfoType.homework].contains(event.infoType) &&
        event.inhoud == null) {
      // This event did not have any information before, so the user will
      // most likely want a different infotype, because it is adding details
      // to the event.
      if (controller.document.toPlainText().trim().isEmpty) {
        event
          ..infoType = InfoType.none
          ..save();
      } else {
        event
          ..infoType = InfoType.homework
          ..save();
      }
    }
    setState(() {});
    await event.sync();
    await refresh();
    await widget.callback?.call();
  }

  void Function()? showLocationChanger() {
    if (event.isEditable) {
      return () => showTextInputDialog(context,
                  title: "Lokatie",
                  hint: event.rawLokatie ?? "",
                  prefill: event.lokatie)
              .then((value) async {
            if (value != null) {
              await (event
                    ..lokatie = value
                    ..save())
                  .sync();
              await widget.callback?.call();
              await refresh();
            }
          });
    }
    return null;
  }

  Widget _buildTimeTile() {
    Set<DateTime> times = {
      for (CalendarEvent event in widget.combinedEvent) ...{
        event.start,
        event.einde
      }
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TimelineWidget(
        dateTimes: times,
      ),
    );
  }

  Widget _buildPersonalChangesTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.combinedEvent.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: [
                  for (var e in widget.combinedEvent)
                    ButtonSegment(
                      label: Text(e.lesuurVan.toString()),
                      value: e.uuid,
                    ),
                ],
                selected: {event.uuid},
                onSelectionChanged: (uuids) {
                  setState(() {
                    event = widget.combinedEvent
                        .where((e) => e.uuid == uuids.first)
                        .first;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalChangesInformationChips() {
    ThemeData themdata = Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              secondaryContainer:
                  Theme.of(context).colorScheme.tertiaryContainer,
            ));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            IgnorePointer(
              ignoring: !event.isEditable || event.isPersonal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Theme(
                      data: event.infoType != event.rawInfoType
                          ? themdata
                          : Theme.of(context),
                      child: DropDownChip(
                        currentValue: DropDownChipItem(
                          title: event.infoType.toName,
                          item: event.infoType,
                        ),
                        defaultIcon: const Icon(Icons.event_note),
                        items: () => Future.value([
                          for (var e in infoTypeOptions.entries)
                            DropDownChipItem(title: e.value, item: e.key)
                        ]),
                        onSelected: (item) async {
                          event
                            ..infoType = item?.item
                            ..save();
                          setState(() {});

                          await event.sync();
                          await refresh();

                          await widget.callback?.call();
                        },
                        defaultTitle: "Informatie",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Theme(
                      data: event.status != event.rawStatus
                          ? themdata
                          : Theme.of(context),
                      child: DropDownChip(
                        currentValue: DropDownChipItem(
                          title: statusOptions[event.status] ??
                              event.status.toName,
                          item: event.status,
                        ),
                        defaultIcon: const Icon(Icons.event_available),
                        items: () => Future.value([
                          for (var e in statusOptions.entries)
                            DropDownChipItem(title: e.value, item: e.key)
                        ]),
                        onSelected: (item) async {
                          event
                            ..status = item?.item
                            ..save();
                          await event.sync();
                          await refresh();

                          await widget.callback?.call();
                        },
                        defaultTitle: "Status",
                      ),
                    ),
                  ),
                  if (!widget.combinedEvent.last.einde
                          .difference(DateTime.now())
                          .isNegative &&
                      (widget.combinedEvent.first.profile.value?.settings
                              .useAutoDND ??
                          false))
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: ToggleChip(
                        initalValue:
                            !widget.combinedEvent.first.excludeFromAutoDND,
                        label: const Text("Automatisch niet storen"),
                        onChanged: (value) async {
                          widget.combinedEvent.first
                            ..excludeFromAutoDND = value
                            ..save();
                          setState(() {});

                          if (!value) {
                            await widget.combinedEvent.schedueleAutoDND();
                          } else {
                            await Future.wait([
                              AndroidAlarm(
                                      id: widget.combinedEvent.first.start
                                          .millisecondsSinceEpoch)
                                  .cancel(),
                              AndroidAlarm(
                                      id: widget.combinedEvent.last.einde
                                          .millisecondsSinceEpoch)
                                  .cancel()
                            ]);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            if (event.isPersonal)
              Padding(
                padding: const EdgeInsets.all(4),
                child: ActionChip(
                  avatar: const Icon(Icons.delete),
                  label: const Text("Verwijderen"),
                  onPressed: () async {
                    // Show a pop that warns the user of they are sure. If so,
                    // it will remove the event
                    bool? isDeleted = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Weet je het zeker?"),
                        content: const Text(
                            "Weet je zeker dat je dit evenement wilt verwijderen?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Annuleren"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await event.remove();
                              Navigator.pop(context, true);
                              await widget.callback?.call();
                            },
                            child: const Text("Verwijderen"),
                          ),
                        ],
                      ),
                    );
                    if (isDeleted == true) {
                      Navigator.pop(context);
                    }
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildInformationTiles() {
    String teachers = event.docenten
            ?.map((e) => e.naam ?? e.docentcode)
            .nonNulls
            .formattedJoin ??
        "";
    String location = event.lokatie ??
        event.lokalen?.map((e) => e.naam).nonNulls.formattedJoin ??
        "";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          CustomCard(
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(
                maxLines: 1,
                overflow: TextOverflow.fade,
                event.start.formattedDateWithoutYear.capitalized,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.supervisor_account),
                    title: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      teachers,
                    ),
                  ),
                ),
              ),
              if (location != "")
                IntrinsicWidth(
                  child: CustomCard(
                    elevation: 0,
                    color: event.lokatie == event.rawLokatie
                        ? null
                        : Theme.of(context).colorScheme.tertiaryContainer,
                    child: ListTile(
                      leading: const Icon(Icons.pin_drop),
                      title: Text(
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        location,
                      ),
                      onTap: showLocationChanger(),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildImportantTiles() {
    return [
      for (var imp in event.importantDetails) ...[
        if (imp.type == ImportantCalenderEventTypes.status)
          ListTile(
            leading: const Icon(Icons.warning_amber_rounded),
            title: Text(imp.changeDesc!),
          ),
        if (imp.type == ImportantCalenderEventTypes.infotype && imp.important)
          ListTile(
            leading: const Icon(Icons.type_specimen_rounded),
            title: Text(imp.changeDesc!),
          ),
        if (imp.type == ImportantCalenderEventTypes.absent)
          ListTile(
            leading: const Icon(Icons.person_remove),
            title: Text(
                "Je was deze les ${(event.afwezigheid?.geoorloofd ?? true) ? "geoorloofd" : "ongeoorloofd"} absent"),
            subtitle: Text(
                "${event.afwezigheid!.code}: ${event.afwezigheid!.omschrijving.capitalized}"),
          ),
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        // Save on Ctrl + S
        SingleActivator(
            meta: Platform.isIOS || Platform.isMacOS,
            control: !(Platform.isIOS || Platform.isMacOS),
            LogicalKeyboardKey.keyS): const CalendarSaveIntent()
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          CalendarSaveIntent: CallbackAction<CalendarSaveIntent>(
            onInvoke: (CalendarSaveIntent intent) async => saveEvent(),
          ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InverseCardElevation(
                child: Column(
                  children: [
                    for (var e in widget.combinedEvent.combineEvents())
                      SimpleDayViewEventTile(
                        event: e,
                        callback: () async => await widget.callback?.call(),
                        onTapOverride: () => CalendarDayView(
                          displayedDay: event.start.dayOnly,
                        ).push(context),
                        navigationTile: widget.showSeeInContext,
                      ),
                  ],
                ),
              ),
            ),
            for (var e in _buildImportantTiles())
              CustomCard(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: e,
              ),
            _buildTimeTile(),
            _buildInformationTiles(),
            if (event.omschrijving != null)
              CustomCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.short_text),
                  title: const Text("Omschrijving"),
                  subtitle: Text(event.omschrijving!.capitalized),
                ),
              ),
            CustomAnimatedSize(
              visible: contacts.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomCard(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: ContactsList(contacts: contacts),
                ),
              ),
            ),
            if (event.vakken != null)
              CustomCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text("Vak(ken)"),
                  subtitle: Text(event.vakken!
                      .map((e) => e.naam?.capitalized)
                      .formattedJoin),
                ),
              ),
            if (event.gewijzigd != null)
              CustomCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.edit_calendar),
                  title: const Text("Laaste aanpassing"),
                  subtitle: Text(event.gewijzigd!.formattedDateAndTime),
                ),
              ),
            if (widget.combinedEvent.expand((e) => e.bronnen).isNotEmpty)
              const ListTile(
                leading: Icon(Icons.attach_file),
                title: Text("Bronnen"),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InverseCardElevation(
                  child: MoreBronnenTile(
                      bronnen: widget.combinedEvent.expand((e) => e.bronnen))),
            ),
            const ListTile(
              leading: Icon(Icons.edit_rounded),
              title: Text("Persoonlijke aanpassingen"),
            ),
            _buildPersonalChangesInformationChips(),
            _buildPersonalChangesTile(),
            if (event.isEditable) _buildEditor(),
            const BottomSheetBottomContentPadding()
          ],
        ),
      ),
    );
  }

  Future<void> saveEvent() async {
    (event
      ..inhoud = parchmentHtml.encode(controller.document)
      ..save());
    setState(() {});
    await widget.callback?.call();
    await event.sync();
  }

  Widget _buildEditor() {
    bool canSave =
        parchmentHtml.encode(controller.document).nullOnEmpty?.withoutHTML ==
            event.inhoud?.withoutHTML;
    return CustomCard(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          if (event.isEditable)
            CustomCard(
              margin: const EdgeInsets.all(8).copyWith(bottom: 0),
              child: CustomToolBar(
                controller: controller,
                leading: [
                  ElasticAnimation(
                    child: CustomCard(
                      key: ValueKey(canSave),
                      color: canSave
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      child: InkWell(
                        onTap: () async => saveEvent(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.save,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ElasticAnimation(
                  //   child: CustomCard(
                  //     key: ValueKey("ori$_viewOriginal"),
                  //     elevation: _viewOriginal ? 0 : 1,
                  //     child: InkWell(
                  //       onTap: () async {
                  //         setState(() {
                  //           _viewOriginal = !_viewOriginal;
                  //         });
                  //         if (_viewOriginal) {

                  //         } else {

                  //         }
                  //       },
                  //       child: const Padding(
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 8, horizontal: 16),
                  //           child: Text("Zie origineel")),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 200),
            child: FleatherTheme(
              data: customFleatherTheme(context),
              child: FleatherEditor(
                controller: controller,
                minHeight: 200,
                padding: const EdgeInsets.all(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactsList extends StatefulWidget {
  const ContactsList({
    super.key,
    required this.contacts,
    this.title,
    this.customSuggestionsBuilder,
  });

  final List<Contact> contacts;
  final String? title;
  final FutureOr<Iterable<Widget>> Function(BuildContext, SearchController)?
      customSuggestionsBuilder;

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(widget.title ??
              "Gevonden klasgenoten (${widget.contacts.length})"),
          trailing: SearchAnchor(
            builder: (context, controller) => IconButton(
              onPressed: () => controller.openView(),
              icon: const Icon(Icons.search),
            ),
            suggestionsBuilder: widget.customSuggestionsBuilder ??
                (context, controller) => [
                      for (Contact contact in widget.contacts.where(
                        (c) => c.fullName
                            .toLowerCase()
                            .contains(controller.text.toLowerCase()),
                      ))
                        ListTile(
                          onTap: () => setState(() {
                            contact.toggleFavorite();
                          }),
                          leading: ContactAvatar(firstLetter: contact.fullName),
                          title: Text(contact.fullName),
                          subtitle: Text(
                            [
                              contact.klas,
                              contact.type.capitalized,
                            ].nonNulls.join(" - "),
                          ),
                        ),
                    ],
          ),
        ),
        (widget.contacts.isEmpty)
            ? CustomCard(
                margin: const EdgeInsets.all(8).copyWith(top: 0),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Center(
                      child: Text("Geen contacten gevonden"),
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4)
                      .copyWith(top: 0),
                  child: Row(
                    children: [
                      for (Contact contact in widget.contacts.selectiveSort())
                        InkWell(
                          onTap: () => setState(() {
                            contact.toggleFavorite();
                          }),
                          child: Card.outlined(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Badge(
                                    isLabelVisible: contact.isFavorite,
                                    alignment: Alignment.bottomRight,
                                    offset: const Offset(0, -15),
                                    label: const Icon(
                                      Icons.favorite,
                                      size: 12,
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: Text(contact.fullName.characters
                                              .firstOrNull?.capitalized ??
                                          ""),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(contact.fullName),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key, required this.dateTimes});

  final Iterable<DateTime> dateTimes;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double dotSize = 12.0;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: dotSize / 2 - 1,
              ),
              child: Container(
                height: 2.0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: dateTimes.map((dateTime) {
                  return Column(
                    children: [
                      Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            dateTime.formattedTime,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:discipulus/api/models/calendar.dart';
// import 'package:discipulus/api/models/messages.dart';
// import 'package:discipulus/api/models/studiewijzers.dart';
// import 'package:discipulus/main.dart';
// import 'package:discipulus/screens/messages/message_compose.dart';
// import 'package:discipulus/screens/studiewijzers/studiewijzer_details.dart';
// import 'package:discipulus/utils/ext_calendar.dart';
// import 'package:discipulus/utils/extensions.dart';
// import 'package:discipulus/widgets/global/bottom_sheet.dart';
// import 'package:discipulus/widgets/global/card.dart';
// import 'package:discipulus/widgets/global/html.dart';
// import 'package:discipulus/widgets/global/input_dialog.dart';
// import 'package:discipulus/widgets/global/list_decoration.dart';
// import 'package:discipulus/screens/bronnen/bron_tiles.dart';
// import 'package:discipulus/widgets/global/tiles/fleather_toolbar.dart';
// import 'package:fleather/fleather.dart';
// import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
// import 'package:parchment/codecs.dart';

// class CalendarEventDetails extends StatefulWidget {
//   const CalendarEventDetails({
//     super.key,
//     required this.event,
//     this.callback,
//   });

//   final CalendarEvent event;
//   final void Function()? callback;

//   @override
//   State<CalendarEventDetails> createState() => _CalendarEventDetailsState();
// }

// class _CalendarEventDetailsState extends State<CalendarEventDetails> {
//   late CalendarEvent event;
//   late FleatherController controller;
//   List<Studiewijzer> studiewijzers = [];

//   Future<void> refresh() async => await event.fill().then((value) async {
//         await loadEvent();
//         setState(() {});
//       });

//   Future<void> loadEvent() async => event =
//       await isar.calendarEvents.filter().uuidEqualTo(event.uuid).findFirst() ??
//           event;

//   @override
//   void initState() {
//     event = widget.event;
//     controller = FleatherController(
//         document: ParchmentDocument.fromDelta(
//             parchmentHtml.decode(widget.event.inhoud ?? "").toDelta()));
//     super.initState();
//     Future.wait([
//       Future(() async =>
//           studiewijzers = await event.subject.value!.relatedStudiewijzers),
//       refresh()
//     ]).then((value) {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         ListTile(
//           title: Text(event.title),
//           leading: CircleAvatar(
//             radius: 25,
//             child: Text(event.lesuurVan.toString()),
//           ),
//         ),
//         ...[
//           Row(
//             children: [
//               ListTile(
//                 title: const Text("Datum"),
//                 subtitle: Text(
//                   event.start.formattedDate,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 leading: const Icon(Icons.calendar_today_outlined),
//               ),
//               ListTile(
//                 title: const Text("Tijd"),
//                 subtitle: Text(
//                   "${event.start.formattedTime} - ${event.einde.formattedTime}",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 leading: const Icon(Icons.access_time),
//               ),
//             ]
//                 .map((e) => Expanded(child: CustomCard(elevation: 0, child: e)))
//                 .toList(),
//           ),
//           CustomCard(
//             elevation: 0,
//             child: Column(
//               children: [
//                 if (event.omschrijving != null)
//                   ListTile(
//                     leading: const Icon(Icons.short_text),
//                     title: const Text("Omschrijving"),
//                     subtitle: Text(event.omschrijving!.capitalized),
//                     onTap: () async {
//                       List<Contact> contacts = await event.contacts;
//                       print(contacts.map(
//                         (e) => "${e.roepnaam ?? e.voorletters} ${e.achternaam}",
//                       ));
//                     },
//                   ),
//                 ListTile(
//                   title: const Text("Lokatie"),
//                   subtitle: event.lokatie != null ? Text(event.lokatie!) : null,
//                   leading: const Icon(Icons.location_pin),
//                   onTap: event.isEditable
//                       ? () => showTextInputDialog(context,
//                                   title: "Lokatie",
//                                   hint: event.rawLokatie ?? "",
//                                   prefill: event.lokatie)
//                               .then((value) async {
//                             if (value != null) {
//                               await (event
//                                     ..lokatie = value
//                                     ..save())
//                                   .sync();
//                               widget.callback?.call();
//                               await refresh();
//                             }
//                           })
//                       : null,
//                 ),
//                 ListTile(
//                   title: const Text("Vakken"),
//                   subtitle: Text(event.vakken!
//                       .map((e) => e.naam.toString().capitalized)
//                       .formattedJoin),
//                   leading: const Icon(Icons.book),
//                 ),
//                 if (event.docenten != null && event.docenten!.isNotEmpty)
//                   ListTile(
//                     leading: const Icon(Icons.supervisor_account),
//                     title: const Text("Docent(en)"),
//                     subtitle:
//                         Text(event.docenten!.map((e) => e.naam).formattedJoin),
//                   ),
//                 if (event.gewijzigd != null)
//                   ListTile(
//                     leading: const Icon(Icons.edit_calendar),
//                     title: const Text("Laaste aanpassing"),
//                     subtitle: Text(event.gewijzigd!.formattedDateAndTime),
//                   ),
//               ],
//             ),
//           ),
//           if (studiewijzers.isNotEmpty)
//             CustomCard(
//               elevation: 0,
//               color: Theme.of(context).colorScheme.secondaryContainer,
//               child: ListTile(
//                 title: const Text("Gerelateerde studiewijzers"),
//                 leading: const Icon(Icons.collections_bookmark),
//                 subtitle: Column(
//                   children: [
//                     ...studiewijzers.map(
//                       (e) => CustomCard(
//                         elevation: 0,
//                         child: ListTile(
//                           onTap: () =>
//                               StudieWijzerScreen(studiewijzer: e).push(context),
//                           title: Text(e.titel.capitalized),
//                           trailing: const Icon(Icons.navigate_next),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           const ListTile(
//             title: Text("Details"),
//             leading: Icon(Icons.mode_edit),
//           ),
//           Row(
//             children: [
//               ListTile(
//                 title: const Text("Status"),
//                 subtitle: Text(
//                   statusOptions[event.status] ?? event.status.toName,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 leading: const Icon(Icons.event_available),
//                 onTap: event.isEditable
//                     ? () => dropdownSheet(
//                           context,
//                           title: "Status",
//                           radioListTiles: (modelSetState) =>
//                               statusOptions.entries
//                                   .map((e) => RadioListTile<Status?>(
//                                         value: e.key,
//                                         title: Text(e.value),
//                                         groupValue: event.status,
//                                         onChanged: (Status? value) async {
//                                           modelSetState(() {});
//                                           setState(() {});
//                                           event
//                                             ..status = value
//                                             ..save();
//                                           await loadEvent();
//                                           setState(() {});
//                                           widget.callback?.call();
//                                         },
//                                       ))
//                                   .toList(),
//                         ).then((value) async {
//                           // Only save to Magister when the sheet is closed
//                           await event.sync();
//                           await refresh();
//                         })
//                     : null,
//               ),
//               ListTile(
//                 title: const Text("Informatie"),
//                 subtitle: Text(
//                   event.infoType.toName,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 leading: const Icon(Icons.event_note),
//                 onTap: event.isEditable
//                     ? () => dropdownSheet(
//                           context,
//                           title: "Informatie",
//                           radioListTiles: (modelSetState) =>
//                               infoTypeOptions.entries
//                                   .map((e) => RadioListTile<InfoType?>(
//                                         value: e.key,
//                                         title: Text(e.value),
//                                         groupValue: event.infoType,
//                                         onChanged: (InfoType? value) async {
//                                           modelSetState(() {});
//                                           setState(() {});
//                                           event
//                                             ..infoType = value
//                                             ..save();
//                                           await loadEvent();
//                                           setState(() {});
//                                           widget.callback?.call();
//                                         },
//                                       ))
//                                   .toList(),
//                         ).then((value) async {
//                           // Only save to Magister when the sheet is closed
//                           await event.sync();
//                           await refresh();
//                         })
//                     : null,
//               ),
//             ]
//                 .map((e) => Expanded(child: CustomCard(elevation: 0, child: e)))
//                 .toList(),
//           ),
//           DefaultTabController(
//             length: (event.customCalendarProperties?.inhoud != null &&
//                     event.rawInhoud != null)
//                 ? 2
//                 : 1,
//             child: CustomCard(
//                 elevation: 0,
//                 child: Column(
//                   children: [
//                     SwitchListTile(
//                       secondary: const Icon(Icons.subject),
//                       title: const Text("Beschrijving"),
//                       value: event.afgerond,
//                       onChanged: widget.event.isEditable
//                           ? (value) {
//                               event
//                                 ..afgerond = value
//                                 ..save();
//                               setState(() {});
//                               event.sync();
//                             }
//                           : null,
//                     ),
//                     if (event.customCalendarProperties?.inhoud != null &&
//                         event.rawInhoud != null)
//                       const TabBar(tabs: [
//                         Tab(
//                           text: "Persoonlijk",
//                         ),
//                         Tab(
//                           text: "Origineel",
//                         )
//                       ]),
//                     SizedBox(
//                       height: 350,
//                       child: TabBarView(children: [
//                         Column(
//                           children: [
//                             if (event.isEditable)
//                               CustomCard(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 child: CustomToolBar(
//                                   controller: controller,
//                                   leading: [
//                                     IconButton(
//                                       onPressed: () async {
//                                         event
//                                           ..inhoud = parchmentHtml
//                                               .encode(controller.document)
//                                           ..save();
//                                         widget.callback?.call();
//                                         await event.sync();
//                                       },
//                                       icon: const Icon(Icons.save),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             FleatherTheme(
//                                 data: customFleatherTheme(context),
//                                 child: FleatherEditor(
//                                     controller: controller,
//                                     minHeight: 200,
//                                     padding: const EdgeInsets.all(16.0))),
//                           ],
//                         ),
//                         if (event.customCalendarProperties?.inhoud != null &&
//                             event.rawInhoud != null)
//                           Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: HTMLDisplay(html: event.rawInhoud!),
//                           ),
//                       ]),
//                     ),
//                   ],
//                 )),
//           ),
//           CustomCard(
//               elevation: 0,
//               child: Column(
//                   children:
//                       event.bronnen.map((e) => BronTile(bron: e)).toList()))
//         ].map((e) => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16), child: e)),
//         const BottomSheetBottomContentPadding()
//       ],

//       // [
//       //   ListTile(
//       //     leading: const Icon(Icons.access_time),
//       //     title: const Text("Tijd"),
//       //     subtitle: Text(
//       //         "${event.lesuurVan}e ${event.start.formattedTime} - ${event.einde.formattedTime}"),
//       //   ),
//       //   ListTile(
//       //     leading: const Icon(Icons.event),
//       //     title: const Text("Datum"),
//       //     subtitle: Text(event.start.formattedDate),
//       //   ),
//       //   if (event.omschrijving != null)
//       //     ListTile(
//       //       leading: const Icon(Icons.short_text),
//       //       title: const Text("Omschrijving"),
//       //       subtitle: Text(event.omschrijving!.capitalized),
//       //     ),
//       //   if ((event.lokalen ?? event.lokatie) != null && event.lokatie != "")
//       //     ListTile(
//       //       leading: const Icon(Icons.place),
//       //       title: const Text("Lokatie(s)"),
//       //       subtitle: Text(event.lokatie ??
//       //           event.lokalen!.map((e) => e.naam).formattedJoin),
//       //       trailing: IconButton(
//       //           onPressed: () {
//       //             showTextInputDialog(context,
//       //                     title: "Lokatie",
//       //                     hint: event.rawLokatie ?? "",
//       //                     prefill: event.lokatie)
//       //                 .then((value) async {
//       //               if (value != null) {
//       //                 await (event
//       //                       ..lokatie = value
//       //                       ..save())
//       //                     .sync();
//       //                 await refresh();
//       //               }
//       //             });
//       //           },
//       //           icon: const Icon(Icons.edit)),
//       //     ),
//       //   if (event.vakken != null && event.vakken!.isNotEmpty)
//       //     ListTile(
//       //       leading: const Icon(Icons.book),
//       //       title: const Text("Vak(ken)"),
//       //       subtitle: Text(event.vakken!
//       //           .map((e) => e.naam.toString().capitalized)
//       //           .formattedJoin),
//       //     ),
//       //   if (event.docenten != null && event.docenten!.isNotEmpty)
//       //     ListTile(
//       //       leading: const Icon(Icons.supervisor_account),
//       //       title: const Text("Docent(en)"),
//       //       subtitle: Text(event.docenten!.map((e) => e.naam).formattedJoin),
//       //     ),
//       //   if (event.gewijzigd != null)
//       //     ListTile(
//       //       leading: const Icon(Icons.edit_calendar),
//       //       title: const Text("Laaste aanpassing"),
//       //       subtitle: Text(event.gewijzigd!.formattedDateAndTime),
//       //     ),
//       // ],
//       // [
//       //   if (event.infoType.index != 0)
//       //     SwitchListTile(
//       //         secondary: const Icon(Icons.subject),
//       //         title: Text("Beschrijving"),
//       //         value: event.afgerond,
//       //         onChanged: (value) {
//       //           event
//       //             ..afgerond = value
//       //             ..save();
//       //           setState(() {});
//       //           event.sync();
//       //         }),
//       //   // DefaultTabController(
//       //   //   length: 2,
//       //   //   child: TabBarView(children: [
//       //   //     if (event.inhoud != null)
//       //   //       ListTile(
//       //   //         title: HTMLDisplay(html: event.inhoud!),
//       //   //       ),
//       //   //     if (event.inhoud != null)
//       //   //       ListTile(
//       //   //         title: HTMLDisplay(html: event.inhoud!),
//       //   //       ),
//       //   //   ]),
//       //   // )
//       //   if (event.inhoud != null)
//       //     ListTile(
//       //       subtitle: HTMLDisplay(html: event.inhoud!),
//       //     ),
//       //   if (event.heeftBijlagen)
//       //     Padding(
//       //       padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//       //       child: CustomCard(
//       //           elevation: 0,
//       //           child: Column(
//       //               children: event.bronnen
//       //                   .map((e) => BronTile(bijlage: e))
//       //                   .toList())),
//       //     )
//       // ]
//       // ]
//       //     .map<Widget>((e) => Padding(
//       //           padding:
//       //               const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       //           child: CustomCard(
//       //             child: Column(children: e),
//       //           ),
//       //         ))
//       //     .toList(),
//     );
//   }
// }

Map<Status?, String> statusOptions = {
  null: "Origineel",
  Status.manuallyScheduled: "Ingeroostered",
  Status.changed: "Veranderd",
  Status.manuallyCanceled: "Uitgevallen",
  Status.moved: "Verplaast",
  Status.changedAndMoved: "Verplaast en veranderd"
};
