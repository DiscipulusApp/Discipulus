import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chip_schoolyear.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  Schoolyear? _selectedSchoolyear;
  final Set<AbsenceType> _filteredTypes = {};

  @override
  void initState() {
    super.initState();
    _selectedSchoolyear = activeProfile.schoolyears
        .filter()
        .isHoofdAanmeldingEqualTo(true)
        .sortByBeginDesc()
        .findFirstSync();
  }

  Future<void> _fetch(bool isOffline) async {
    if (!isOffline) {
      await activeProfile.getEvents(DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 365 * 2)),
        end: DateTime.now().add(const Duration(days: 7)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = activeProfile.calendarEvents
        .filter()
        .afwezigheidIsNotNull()
        .optional(
            _selectedSchoolyear != null,
            (q) => q.startBetween(
                _selectedSchoolyear!.begin, _selectedSchoolyear!.einde))
        .optional(
            _filteredTypes.isNotEmpty,
            (q) => q.anyOf(
                _filteredTypes,
                (q, type) =>
                    q.afwezigheid((q) => q.verantwoordingtypeEqualTo(type))))
        .sortByStartDesc();
    final stream = query.watch(fireImmediately: true).asBroadcastStream();

    return ScaffoldSkeleton(
      fetch: _fetch,
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Absenties"),
        leading: leading,
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
      ),
      extraSlivers: [
        StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final absences = snapshot.data!;

            if (absences.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text("Geen absenties gevonden")),
              );
            }

            final widgets = absences.insertDateSeparatorWidget(
              (e) => e.start,
              separator: ({required title, required values}) => ListTitle(
                child: Text(title),
              ),
              tile: (event) {
                final absence = event.afwezigheid!;
                return CustomCard(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(absence.verantwoordingtype.icon),
                    ),
                    title: Text(absence.omschrijving.capitalized),
                    subtitle: Text(
                        "${absence.verantwoordingtype.name} • ${event.start.formattedTime}${event.lesuurVan != null ? " • Lesuur ${event.lesuurVan}" : ""}"),
                    trailing: !absence.geoorloofd
                        ? const Icon(Icons.warning_amber_rounded,
                            color: Colors.orange)
                        : null,
                    onTap: () => showCalendarEventDetailsSheet(
                      context,
                      events: [event],
                    ),
                  ),
                );
              },
            );

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => widgets[index],
                childCount: widgets.length,
              ),
            );
          },
        ),
      ],
      children: [
        StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              return AbsenceStatisticalTilesHeader(
                  key: const HeaderKey(), events: snapshot.data ?? []);
            }),
        FilterChipList(
          key: const HeaderKey(),
          chips: [
            SchoolyearSelector(
              initValue: _selectedSchoolyear != null
                  ? SchoolyearObject(_selectedSchoolyear!.uuid,
                      group: _selectedSchoolyear!.groep)
                  : null,
              onSelected: (s) {
                setState(() {
                  _selectedSchoolyear = s;
                });
              },
            ),
            ...[
              AbsenceType.late,
              AbsenceType.sick,
              AbsenceType.absent,
              AbsenceType.homework,
              AbsenceType.books,
            ].map((type) => ToggleChip(
                  label: Text(type.name),
                  icon: Icon(type.icon),
                  initalValue: _filteredTypes.contains(type),
                  onChanged: (v) {
                    setState(() {
                      if (v) {
                        _filteredTypes.add(type);
                      } else {
                        _filteredTypes.remove(type);
                      }
                    });
                  },
                )),
          ],
        ),
      ],
    );
  }
}

class AbsenceStatisticalTilesHeader extends StatelessWidget {
  const AbsenceStatisticalTilesHeader({super.key, required this.events});

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    int total = events.length;
    int unexcused =
        events.where((e) => e.afwezigheid?.geoorloofd == false).length;
    int lateCount = events
        .where((e) => e.afwezigheid?.verantwoordingtype == AbsenceType.late)
        .length;
    int sickCount = events
        .where((e) => e.afwezigheid?.verantwoordingtype == AbsenceType.sick)
        .length;

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Wrap(
          children: [
            _AbsenceHeaderTile(
              label: "Totaal",
              value: "$total",
              icon: const Icon(Icons.list_alt),
            ),
            _AbsenceHeaderTile(
              label: "Ongeoorloofd",
              value: "$unexcused",
              icon: const Icon(Icons.warning_amber_rounded),
              negative: unexcused > 0,
            ),
            _AbsenceHeaderTile(
              label: "Te laat",
              value: "$lateCount",
              icon: const Icon(Icons.access_time),
            ),
            _AbsenceHeaderTile(
              label: "Ziek",
              value: "$sickCount",
              icon: const Icon(Icons.sick_outlined),
            ),
          ]
              .splitByChunks(constraints.maxWidth > 600 ? 4 : 2)
              .map((row) => Row(
                    children: row
                        .map((tile) => Expanded(
                              child: CustomCard(
                                child: ListTile(
                                  leading: tile.icon,
                                  iconColor: tile.negative
                                      ? Theme.of(context).colorScheme.error
                                      : null,
                                  textColor: tile.negative
                                      ? Theme.of(context).colorScheme.error
                                      : null,
                                  title: ElasticAnimation(
                                    child: Text(
                                      tile.value,
                                      key: ValueKey(tile.value),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                  ),
                                  subtitle: Text(tile.label),
                                ),
                              ),
                            ))
                        .toList(),
                  ))
              .toList(),
        ),
      );
    });
  }
}

class _AbsenceHeaderTile {
  final String label;
  final String value;
  final Icon icon;
  final bool negative;

  _AbsenceHeaderTile({
    required this.label,
    required this.value,
    required this.icon,
    this.negative = false,
  });
}
