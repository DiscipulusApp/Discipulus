import 'dart:io';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:discipulus/screens/calendar/widgets/oncoming_special_event.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_tiles.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/selectable_mixin.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

class StudieWijzerScreen extends StatefulWidget {
  const StudieWijzerScreen({super.key, required this.studiewijzer});

  final Studiewijzer studiewijzer;

  @override
  State<StudieWijzerScreen> createState() => _StudieWijzerScreenState();
}

class _StudieWijzerScreenState extends State<StudieWijzerScreen>
    with SelectableList {
  List<StudiewijzerOnderdeel> onderdelen = [];
  List<CalendarEvent> events = [];
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  Future<void> setOnderdelen() async {
    onderdelen = await widget.studiewijzer.onderdelen
        .filter()
        .bronnen((q) => q.search(_controller.text.nullOnEmpty))
        .sortByVolgnummer()
        .findAll();
  }

  Future<void> setEvents() async {
    Schoolyear? schoolyear = await widget
        .studiewijzer.profile.value?.schoolyears
        .filter()
        .sortByEindeDesc()
        .findFirst();

    if (schoolyear != null) {
      // Studiewijzers are not linked to a subject, or well they are, but
      // Magister does not use that field anymore, so they are not anymore.
      // We therefor have to sort of guess the name of the subject based on the
      // name of the studiewijzer and then match the subject to the studiewijzer.
      //
      // We will do that by splitting the name of the studiewijzer and then
      // taking the biggest part based on num numeric characters.
      String subjectName = widget.studiewijzer.titel
          .split(" ")
          // Filter out words with numbers
          .where((word) => !word.contains(RegExp(r'\d')))
          .reduce((a, b) => a.length > b.length ? a : b);

      Subject? subject = await schoolyear.subjects
          .filter()
          .naamContains(subjectName, caseSensitive: false)
          .findFirst();

      if (subject != null) {
        events = (await subject.events
            .filter()
            .eindeGreaterThan(DateTime.now())
            .anyOf(
          [InfoType.homework, ...InfoType.tests],
          (q, infoType) => q.infoTypeEqualTo(infoType),
        ).findAll());
      }
    }
  }

  Future<void> refresh(bool isOffline) async {
    await Future.wait([setOnderdelen(), setEvents()]);
    if (mounted) setState(() {});
    if (!isOffline) {
      await widget.studiewijzer.fill();
      await setOnderdelen();
      if (onderdelen.length == 1) await onderdelen.first.fill();
      if (mounted) setState(() {});
    }
  }

  // We will check for key presses, so that the search field appears when the
  // user will start typing. The enter, backspace and tab are ignored, because for
  // some reason they create valid characters.
  bool keyHandler(KeyEvent event) {
    if (![
          LogicalKeyboardKey.escape,
          LogicalKeyboardKey.backspace,
          LogicalKeyboardKey.enter,
          LogicalKeyboardKey.tab,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.alt,
        ].contains(event.logicalKey) &&
        event.character != null) {
      _controller.text += event.character!;
      _focusNode.requestFocus();
      refresh(true);
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    ServicesBinding.instance.keyboard.addHandler(keyHandler);
    super.initState();
    widget.studiewijzer
      ..lastUsed = DateTime.now()
      ..save();
  }

  @override
  void dispose() {
    _controller.dispose();
    ServicesBinding.instance.keyboard.removeHandler(keyHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      noWait: true,
      fetch: (isOffline) async {
        bool firstTime = onderdelen.isEmpty;
        await refresh(isOffline);
        if (firstTime &&
            widget.studiewijzer.onderdelen.length == 1 &&
            !isOffline) {
          widget.studiewijzer.onderdelen.first.fill();
          if (mounted) setState(() {});
        }
      },
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.subPage,
        title: widget.studiewijzer.titel,
        profileUUID: widget.studiewijzer.profile.value?.uuid,
        screenType: StudieWijzerScreen,
        extraInfo: {
          "studiewijzer_uuid": widget.studiewijzer.uuid,
          "studiewijzer_id": widget.studiewijzer.id,
          "studiewijzer_title": widget.studiewijzer.rawTitel,
        },
      ),
      emptyBuilder: _controller.text.isEmpty
          ? null
          : () => Center(
                child: Text("Niets gevonden voor \"${_controller.text}\" 🤷"),
              ),
      appBar: (isRefreshing, trailingButtom, leading) => SliverAppBar.large(
        actions: [if (trailingButtom != null) trailingButtom],
        title: Text(widget.studiewijzer.titel.capitalized),
      ),
      children: [
        Padding(
          key: const HeaderKey(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: CustomAnimatedSize(
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StudieWijzerTile(
                    widget.studiewijzer,
                    navigationTile: false,
                    callback: () => setState(() {}),
                  ),
                  if (events.isNotEmpty)
                    CustomCard(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
                              .copyWith(top: 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: OncomingSpecialEventTile(events: events),
                        ),
                      ),
                    ),
                  if (Platform.isAndroid ||
                      Platform.isIOS ||
                      _controller.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12).copyWith(top: 0),
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _controller,
                        maxLines: 1,
                        onChanged: (value) async => await refresh(true),
                        decoration: const InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Zoek naar bronnen",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        for (StudiewijzerOnderdeel onderdeel in onderdelen)
          StudieWijzerOnderdeelTile(
            key: ValueKey("${onderdeel.id}${onderdelen.hashCode}"),
            searchQuery: _controller.text.nullOnEmpty,
            onderdeel: onderdeel,
            isExpanded: onderdelen.length == 1,
            callback: () async => await refresh(true),
          ),
        if (selectedItems.isNotEmpty) buildExtraSheetPadding(context)!
      ],
    );
  }

  @override
  selectionSheetContentBuilder(BuildContext context) {
    return [
      const ListTitle(child: Text("Geselecteerde bronnen")),
      FutureBuilder(
        future: Future(
          () => isar.brons
              .filter()
              .anyOf(
                SelectableList.maybyOf(context)?.selectedItems ?? [],
                (q, uuid) => q.uuidEqualTo(uuid),
              )
              .findAll(),
        ),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomCard(
              elevation: 0,
              child: Column(
                children: [
                  for (Bron bron in snapshot.data ?? [])
                    BronTile(
                      bron: bron,
                      // selectedCallback: widget.selectedCallback,
                    )
                ],
              ),
            ),
          );
        },
      ),
    ];
  }

  @override
  headerOptionsBuilder(BuildContext context) {
    return [
      FutureBuilder(
          future: Future(
            () => isar.brons
                .filter()
                .anyOf(
                  SelectableList.maybyOf(context)?.selectedItems ?? [],
                  (q, uuid) => q.uuidEqualTo(uuid),
                )
                .findAll(),
          ),
          builder: (context, snapshot) {
            return Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                if (snapshot.data?.any((bron) => bron.savedPath == null) ??
                    false)
                  SelectionSheetBigOption(
                    icon: const Icon(Icons.cloud_download),
                    title: const Text("Downloaden"),
                    onTap: () async {
                      await Future.wait(
                          [for (Bron bron in snapshot.data!) bron.download()]);

                      setState(() {});
                      // widget.selectedCallback?.call();
                      if (mounted) {
                        SelectableList.maybyOf(context)
                            ?.sheetKey
                            .currentState
                            ?.setState(() {});
                      }
                    },
                  ),
                if (snapshot.data?.any((bron) => bron.isFavorite == false) ??
                    false)
                  SelectionSheetBigOption(
                    icon: const Icon(Icons.favorite_outline),
                    title: const Text("Favoriet maken"),
                    onTap: () {
                      for (Bron bron in snapshot.data!
                          .where((b) => b.isFavorite == false)) {
                        bron.toggleFavorite();
                      }

                      setState(() {});
                      // widget.selectedCallback?.call();
                      SelectableList.maybyOf(context)
                          ?.sheetKey
                          .currentState
                          ?.setState(() {});
                    },
                  ),
                if ((snapshot.data?.isNotEmpty ?? false) &&
                    snapshot.data!.every((bron) => bron.isFavorite == true))
                  SelectionSheetBigOption(
                    icon: const Icon(Icons.favorite),
                    title: const Text("Onfavoriet maken"),
                    onTap: () {
                      for (Bron bron in snapshot.data!
                          .where((b) => b.isFavorite == true)) {
                        bron.toggleFavorite();
                      }

                      setState(() {});
                      // widget.selectedCallback?.call();
                      SelectableList.maybyOf(context)
                          ?.sheetKey
                          .currentState
                          ?.setState(() {});
                    },
                  ),
                if (snapshot.data?.any((bron) => bron.rawSavedPath != null) ??
                    false)
                  SelectionSheetBigOption(
                    icon: const Icon(Icons.delete_outline),
                    title: const Text("Verwijderen"),
                    onTap: () {
                      for (Bron bron in snapshot.data!) {
                        bron.remove();
                      }
                      setState(() {});
                      SelectableList.maybyOf(context)
                          ?.setState(() {}); // widget.selectedCallback?.call();
                      Navigator.of(context).pop();
                    },
                  ),
                SelectionSheetBigOption(
                  icon: const Icon(Icons.share),
                  title: const Text("Delen"),
                  onTap: () async => await snapshot.data?.share(context),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            );
          })
    ];
  }
}

extension SearchBronnen on QueryBuilder<Bron, Bron, QFilterCondition> {
  /// Searches the bronnen based on the custom and original name.
  QueryBuilder<Bron, Bron, QAfterFilterCondition> search(String? query) {
    return optional(
      query != null,
      (q) => q
          .group(
            (q) => q
                .customNameIsNotNull()
                .and()
                .customNameContains(query!, caseSensitive: false),
          )
          .or()
          .group(
            (q) => q
                .customNameIsNull()
                .and()
                .rawNaamContains(query!, caseSensitive: false),
          ),
    );
  }
}
