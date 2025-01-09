import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_body.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_header.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

class CalendarSettingsPage extends StatefulWidget {
  const CalendarSettingsPage({super.key});

  @override
  State<CalendarSettingsPage> createState() => _CalendarSettingsPageState();
}

class _CalendarSettingsPageState extends State<CalendarSettingsPage> {
  ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());

  @override
  void dispose() {
    date.dispose();
    super.dispose();
  }

  void changeSetting(Settings Function(Settings settings) settings) =>
      setState(() {
        settings.call(appSettings).save();
      });

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Kalender instellingen"),
      ),
      children: [
        BottomDaySelectHeader(
          selectedDay: date,
        ),
        SwitchListTile(
          value: !appSettings.workWeek,
          secondary: const Icon(Icons.date_range),
          title: const Text("Weekend"),
          subtitle: const Text("Laat het weekend zien in de kalender"),
          onChanged: (value) => setState(() {
            appSettings
              ..workWeek = !value
              ..save();
          }),
        ),
        SwitchListTile(
          value: appSettings.coloredFinishedTests,
          secondary: const Icon(Icons.colorize),
          title: const Text("Afgeronde indicatorkleur"),
          subtitle: const Text(
              "Afgeronde toetsen hebben nog steeds een indicator kleur"),
          onChanged: (value) => setState(() {
            appSettings
              ..coloredFinishedTests = value
              ..save();
          }),
        ),
        SizedBox(
          height: 300,
          child: CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: const SliverToBoxAdapter(),
                  )
                ];
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CalendarDayViewBody(
                  day: DateTime.now(),
                  exampleEvents: exampleEvents,
                ),
              ),
            ),
          ),
        ),
        SwitchListTile(
          value: appSettings.combineDoublePeriods,
          secondary: const Icon(Icons.double_arrow_rounded),
          title: const Text("Combineer blokuren"),
          subtitle: const Text("Combineer dezelfde achtereenvolgende uren"),
          onChanged: (value) => setState(() {
            appSettings
              ..combineDoublePeriods = value
              ..save();
          }),
        ),
        SwitchListTile(
          value: appSettings.showEmptySpaceBetweenLessons,
          secondary: const Icon(Icons.free_breakfast_outlined),
          title: const Text("Pauze/Tussenuur indicator"),
          subtitle: const Text(
              "Laat lege ruimte tussen lessen zien door een indicator"),
          onChanged: (value) => setState(() {
            appSettings
              ..showEmptySpaceBetweenLessons = value
              ..save();
          }),
        ),
      ],
    );
  }
}

List<CalendarEvent> exampleEvents = [
  CalendarEvent(
    lesuurVan: 1,
    omschrijving: "Nederlands",
    start: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 8)),
    einde: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 9)),
    id: -1,
    afgerond: false,
    rawInfoType: InfoType.homework,
    rawStatus: Status.automaticallyCanceled,
    rawLokatie: "001",
    type: CalendarType.general,
  ),
  CalendarEvent(
    lesuurVan: 2,
    rawInhoud:
        "Dit zijn twee lesuren waarvan aleen de bovenste huiswerk heeft, waardoor ze gecombineerd kunnen worden!",
    omschrijving: "Wiskunde",
    start: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 10)),
    einde: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 11)),
    id: -2,
    afgerond: false,
    rawInfoType: InfoType.homework,
    rawLokatie: "002",
    type: CalendarType.general,
  ),
  CalendarEvent(
    lesuurVan: 3,
    lesuurTotMet: 3,
    omschrijving: "Wiskunde",
    start: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 11)),
    einde: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 12)),
    id: -3,
    afgerond: false,
    rawInfoType: InfoType.none,
    rawLokatie: "002",
    type: CalendarType.general,
  ),
  CalendarEvent(
    lesuurVan: 4,
    lesuurTotMet: 4,
    omschrijving: "Engelse taal",
    rawInhoud:
        "Deze twee lesuren zijn het hetzelfde, behalve dat een van de twee een toets heeft. Hierdoor worden ze niet samengevoegd.",
    start: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 13)),
    einde: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 14)),
    id: -4,
    afgerond: true,
    rawInfoType: InfoType.test,
    rawLokatie: "004",
    type: CalendarType.general,
  ),
  CalendarEvent(
    lesuurVan: 5,
    lesuurTotMet: 5,
    omschrijving: "Engelse taal",
    start: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 14)),
    einde: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 15)),
    id: -5,
    afgerond: false,
    rawInfoType: InfoType.none,
    rawLokatie: "004",
    type: CalendarType.general,
  ),
];
