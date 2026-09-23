import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_body.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_header.dart';
import 'package:discipulus/screens/calendar/calendar_grid/calendar_grid_header.dart';
import 'package:discipulus/screens/calendar/calendar_grid/calendar_grid_hour_axis.dart';
import 'package:discipulus/screens/calendar/calendar_grid/calendar_grid_page.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

import 'package:discipulus/utils/account_manager.dart';
import 'package:isar/isar.dart';

class CalendarSettingsPage extends StatefulWidget {
  const CalendarSettingsPage({super.key});

  @override
  State<CalendarSettingsPage> createState() => _CalendarSettingsPageState();
}

class _CalendarSettingsPageState extends State<CalendarSettingsPage> {
  ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  bool _isSyncing = false;
  String _syncStatus = "";

  late final ValueNotifier<int> _previewWeekNotifier =
      ValueNotifier(DateTime.now().weekNumber);
  late final ValueNotifier<bool> _previewFetchingNotifier =
      ValueNotifier(false);
  late final PageController _previewHeaderController = PageController();

  @override
  void dispose() {
    date.dispose();
    _previewWeekNotifier.dispose();
    _previewFetchingNotifier.dispose();
    _previewHeaderController.dispose();
    super.dispose();
  }

  List<DateTime> _getPreviewDays() {
    if (appSettings.timeGridDefaultDayView) {
      return [date.value];
    }
    final monday =
        date.value.dayOnly.subtract(Duration(days: date.value.weekday - 1));
    final count = appSettings.workWeek ? 5 : 7;
    return [for (int i = 0; i < count; i++) monday.add(Duration(days: i))];
  }

  List<CalendarEvent> _getAllExampleEvents() {
    final monday =
        date.value.dayOnly.subtract(Duration(days: date.value.weekday - 1));
    return [
      ...exampleEvents,
      for (int i = 0; i < (appSettings.workWeek ? 5 : 7); i++)
        if (monday.add(Duration(days: i)).dayOnly != date.value.dayOnly) ...[
          CalendarEvent(
            lesuurVan: 1,
            omschrijving: i % 2 == 0 ? "Geschiedenis" : "Biologie",
            start: monday.add(Duration(days: i, hours: 8, minutes: 30)),
            einde: monday.add(Duration(days: i, hours: 9, minutes: 30)),
            id: -100 - i,
            afgerond: false,
            rawInfoType: InfoType.homework,
            rawLokatie: "10${i + 1}",
            type: CalendarType.general,
          ),
          CalendarEvent(
            lesuurVan: 3,
            omschrijving: i % 2 == 0 ? "Aardrijkskunde" : "Natuurkunde",
            start: monday.add(Duration(days: i, hours: 10, minutes: 30)),
            einde: monday.add(Duration(days: i, hours: 11, minutes: 30)),
            id: -200 - i,
            afgerond: false,
            rawInfoType: i == 1 ? InfoType.test : InfoType.none,
            rawLokatie: "20${i + 1}",
            type: CalendarType.general,
          ),
        ],
    ];
  }

  void changeSetting(Settings Function(Settings settings) settings) =>
      setState(() {
        settings.call(appSettings).save();
      });

  Future<void> _performFullCareerFetch() async {
    if (activeProfile.isOffline || _isSyncing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hele schoolcarrière synchroniseren?"),
        content: const Text(
          "Dit haalt alle kalendergebeurtenissen op van al je geregistreerde schooljaren. Dit kan even duren.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuleren"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Synchroniseren"),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isSyncing = true;
      _syncStatus = "Schooljaren voorbereiden...";
    });

    try {
      final schoolyears =
          await activeProfile.schoolyears.filter().sortByBeginDesc().findAll();

      final total = schoolyears.length;
      for (int i = 0; i < total; i++) {
        if (!mounted) break;
        final sy = schoolyears[i];
        setState(() {
          _syncStatus =
              "Schooljaar ${sy.groep.omschrijving ?? sy.groep.code} ophalen (${i + 1}/$total)...";
        });
        await activeProfile.getEvents(DateTimeRange(
          start: sy.begin,
          end: sy.einde,
        ));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Alle kalendergebeurtenissen succesvol gesynchroniseerd!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Fout bij synchroniseren: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _syncStatus = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Kalender instellingen"),
      ),
      children: [
        AnimatedSwitcher(
          duration: Durations.short3,
          child: !appSettings.useTimeGridCalendar
              ? BottomDaySelectHeader(
                  key: ValueKey("bottom_day_header_${appSettings.workWeek}"),
                  selectedDay: date,
                )
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Material(
                  color: Theme.of(context)
                        .colorScheme
                        .surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: CalendarGridHeader(
                        key: ValueKey(
                            "grid_header_${appSettings.timeGridDefaultDayView}_${appSettings.workWeek}"),
                        unifiedBackground:
                            Theme.of(context).colorScheme.surfaceContainer,
                        timeColWidth: 48.0,
                        weekNumberNotifier: _previewWeekNotifier,
                        isFetchingNotifier: _previewFetchingNotifier,
                        headerPageController: _previewHeaderController,
                        getDaysForPage: (_) => _getPreviewDays(),
                        onDayTap: (_) {},
                      ),
                  ),
                ),
              ),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month_outlined),
          title: const Text("Kalenderweergave"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                !appSettings.useTimeGridCalendar
                    ? "Klassieke lijstweergave"
                    : (appSettings.timeGridDefaultDayView
                        ? "Tijdrooster (dagoverzicht)"
                        : (appSettings.workWeek
                            ? "Tijdrooster (werkweek, 5 dagen)"
                            : "Tijdrooster (volledige week, 7 dagen)")),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      label: Text("Lijst"),
                      icon: Icon(Icons.view_agenda_outlined),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text("Dag"),
                      icon: Icon(Icons.calendar_view_day),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text("Week"),
                      icon: Icon(Icons.calendar_view_week),
                    ),
                  ],
                  selected: {
                    if (!appSettings.useTimeGridCalendar)
                      0
                    else if (appSettings.timeGridDefaultDayView)
                      1
                    else
                      2,
                  },
                  onSelectionChanged: (selected) => setState(() {
                    switch (selected.first) {
                      case 0:
                        appSettings
                          ..useTimeGridCalendar = false
                          ..save();
                      case 1:
                        appSettings
                          ..useTimeGridCalendar = true
                          ..timeGridDefaultDayView = true
                          ..save();
                      case 2:
                        appSettings
                          ..useTimeGridCalendar = true
                          ..timeGridDefaultDayView = false
                          ..save();
                    }
                  }),
                ),
              ),
            ],
          ),
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
            child: AnimatedSwitcher(
              duration: Durations.short3,
              child: !appSettings.useTimeGridCalendar
                  ? NestedScrollView(
                      key: ValueKey(
                          "example_list_${appSettings.combineDoublePeriods}_${appSettings.showEmptySpaceBetweenLessons}_${appSettings.hideEventswithoutHours}_${appSettings.coloredFinishedTests}_${appSettings.showAutoCancelledEvents}"),
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                            sliver: const SliverToBoxAdapter(),
                          )
                        ];
                      },
                      body: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CalendarDayViewBody(
                          day: date.value,
                          exampleEvents: exampleEvents,
                        ),
                      ),
                    )
                  : Builder(
                      key: ValueKey(
                          "example_grid_${appSettings.timeGridDefaultDayView}_${appSettings.workWeek}_${appSettings.combineDoublePeriods}_${appSettings.hideEventswithoutHours}_${appSettings.coloredFinishedTests}"),
                      builder: (context) {
                        const double hourHeight = 48.0;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SingleChildScrollView(
                            controller: ScrollController(
                              initialScrollOffset: 7.5 * hourHeight,
                            ),
                            child: SizedBox(
                              height: 24 * hourHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const HourAxis(
                                    hourHeight: hourHeight,
                                    width: 36.0,
                                  ),
                                  Expanded(
                                    child: GridDayColumnsPage(
                                      days: _getPreviewDays(),
                                      hourHeight: hourHeight,
                                      exampleEvents: _getAllExampleEvents(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
        SwitchListTile(
          value: appSettings.hideEventswithoutHours,
          secondary: const Icon(Icons.event_busy),
          title: const Text("Evenementen zonder uren weglaten"),
          subtitle: const Text(
              "Laat evenementen zonder lesuren niet zien in de kalender"),
          onChanged: (value) => setState(() {
            appSettings
              ..hideEventswithoutHours = value
              ..save();
          }),
        ),
        ListTile(
          leading: const Icon(Icons.sync_rounded),
          title: const Text("Volledige schoolcarrière synchroniseren"),
          subtitle: Text(_isSyncing
              ? _syncStatus
              : "Haal alle kalendergebeurtenissen van alle schooljaren op"),
          trailing: _isSyncing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : null,
          onTap: _isSyncing ? null : _performFullCareerFetch,
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
    lesuurVan: null,
    lesuurTotMet: null,
    omschrijving: "Mentorles",
    rawInhoud:
        "Dit is een afspraak of activiteit zonder lesuur die verborgen kan worden.",
    start: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 14 + 15)),
    einde: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 15)),
    id: -6,
    afgerond: false,
    rawInfoType: InfoType.information,
    rawStatus: Status.unknown,
    rawLokatie: "Aula A",
    type: CalendarType.general,
  ),
  CalendarEvent(
    lesuurVan: 5,
    lesuurTotMet: 5,
    omschrijving: "Engelse taal",
    start: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 15)),
    einde: DateTime.now().dayOnly.add(const Duration(minutes: 60 * 16)),
    id: -5,
    afgerond: false,
    rawInfoType: InfoType.none,
    rawLokatie: "004",
    type: CalendarType.general,
  ),
];
