import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/widgets/graphs/line_chart.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/csv_export.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:discipulus/widgets/global/tiles.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class GradesSettingsPage extends StatefulWidget {
  const GradesSettingsPage({super.key});

  @override
  State<GradesSettingsPage> createState() => _GradesSettingsPageState();
}

class _GradesSettingsPageState extends State<GradesSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Cijfer instellingen"),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomCard(
            child: GradeTileExample(
              grade: Grade(
                id: 0,
                cijferStr: "6.5",
                datumIngevoerd: DateTime.now(),
                weight: 2,
                cijferKolom: CijferKolom(kolomSoort: 1, isPtaKolom: true),
              )..subject,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text("Informative badges"),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SegmentedButton<GradeBadgeTypes>(
                showSelectedIcon: false,
                emptySelectionAllowed: true,
                multiSelectionEnabled: true,
                onSelectionChanged: (set) => setState(() {
                      appSettings
                        ..enabledGradeBadgeTypes = set.toList()
                        ..save();
                    }),
                segments: [
                  ...GradeBadgeTypes.values.map(
                    (e) => ButtonSegment(
                      value: e,
                      label: e.title,
                    ),
                  )
                ],
                selected: appSettings.enabledGradeBadgeTypes.toSet()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomCard(
            child: GradesLineChart(
              key: ValueKey(appSettings.hashCode),
              grades: null,
              showAverage: true,
            ),
          ),
        ),
        TextInputListTile(
          leading: const Icon(Icons.grading),
          title: const Text("Voldoende grens"),
          subtitle: const Text("Stel in welk cijfer nog net voldoende is"),
          hintText: appSettings.sufficientFrom.displayNumber(),
          onFocusChange: (value) {
            setState(() => activeProfile
              ..settings.sufficientFrom =
                  double.tryParse(value) ?? appSettings.sufficientFrom
              ..save());
          },
        ),
        SwitchListTile(
          value: appSettings.curvedGraphs,
          secondary: const Icon(Icons.line_axis_rounded),
          title: const Text("Geronde grafieklijnen"),
          subtitle: const Text(
              "Grafieken zien er hierdoor mooier uit, maar zijn minder accuraat"),
          onChanged: (value) {
            setState(() {
              appSettings
                ..curvedGraphs = value
                ..save();
            });
          },
        ),
        SwitchListTile(
          value: appSettings.coloredsufficientFromLine,
          secondary: const Icon(Icons.border_horizontal_rounded),
          title: const Text("Voldoende grens lijn"),
          subtitle: const Text(
              "Door dit aan te zetten wordt de lijn die de voldoende grens aangeeft duidelijker"),
          onChanged: (value) {
            setState(() {
              appSettings
                ..coloredsufficientFromLine = value
                ..save();
            });
          },
        ),
        SwitchListTile(
          value: appSettings.zoomLineGraph,
          secondary: const Icon(Icons.zoom_in_map_rounded),
          title: const Text("Zoom grafieken"),
          subtitle: const Text(
              "Het laagste/hoogste cijfer zichtbaar in de grafiek bepalen de minimun en maximum van de grafiek. De voldoende grens blijft altijd zichtbaar"),
          onChanged: (value) {
            setState(() {
              appSettings
                ..zoomLineGraph = value
                ..save();
            });
          },
        ),
        SwitchListTile(
          value: appSettings.pietjePrecies,
          secondary: const Icon(Icons.straighten_rounded),
          title: const Text("Pietje precies"),
          subtitle: const Text(
              "Toont duidelijke assen met schaalverdeling, dunnere strakke lijnen en hoeken voor maximale nauwkeurigheid"),
          onChanged: (value) {
            setState(() {
              appSettings
                ..pietjePrecies = value
                ..save();
            });
          },
        ),
        SwitchListTile(
          value: !appSettings.disableGradeReveal,
          secondary: const Icon(Icons.stars_rounded),
          title: const Text("Cijfer onthullingen"),
          subtitle: const Text(
              "Onthul nieuwe cijfers met een animatie en statistieken"),
          onChanged: (value) {
            setState(() {
              appSettings
                ..disableGradeReveal = !value
                ..save();
            });
          },
        ),
        SwitchListTile(
          value: appSettings.showCalcCardsInGlobalAverageList,
          secondary: const Icon(Icons.calculate_rounded),
          title: const Text("Rekenkaarten in globaal gemiddelde"),
          subtitle: const Text(
              "Door dit aan te zetten worden de rekenkaarten ook in het globale gemiddelde getoont"),
          onChanged: (value) {
            setState(() {
              appSettings
                ..showCalcCardsInGlobalAverageList = value
                ..save();
            });
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.inventory_2_outlined),
          title: const Text("Gearchiveerde cijfers"),
          subtitle: Text(
            "${isar.grades.filter().isArchivedEqualTo(true).countSync()} gearchiveerde cijfers bewaard",
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArchivedGradesSettingsPage(),
              ),
            );
            setState(() {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.download_rounded),
          title: const Text("Exporteer naar CSV"),
          subtitle: const Text("Exporteer al je cijfers naar een CSV bestand"),
          onTap: () async {
            try {
              await exportGradesToCSV();
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Exporteren mislukt"),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

class ArchivedGradesSettingsPage extends StatefulWidget {
  const ArchivedGradesSettingsPage({super.key});

  @override
  State<ArchivedGradesSettingsPage> createState() =>
      _ArchivedGradesSettingsPageState();
}

class _ArchivedGradesSettingsPageState
    extends State<ArchivedGradesSettingsPage> {
  List<Grade> _getArchivedGrades() {
    return isar.grades
        .filter()
        .isArchivedEqualTo(true)
        .sortByDatumIngevoerdDesc()
        .findAllSync();
  }

  void _toggleAll(bool enable, List<Grade> archivedGrades) {
    isar.writeTxnSync(() {
      for (var grade in archivedGrades) {
        grade.isEnabled = enable;
        isar.grades.putSync(grade);
      }
    });
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enable
              ? "Alle gearchiveerde cijfers ingeschakeld"
              : "Alle gearchiveerde cijfers uitgeschakeld",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteAll(List<Grade> archivedGrades) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alle gearchiveerde cijfers wissen?"),
        content: const Text(
          "Weet je zeker dat je alle bewaarde gearchiveerde cijfers definitief wilt verwijderen? Dit kan niet ongedaan worden gemaakt.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuleren"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Alles wissen"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      isar.writeTxnSync(() {
        for (var grade in archivedGrades) {
          isar.grades.deleteSync(grade.uuid);
        }
      });
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Alle gearchiveerde cijfers gewist"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteSingle(Grade grade) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cijfer wissen?"),
        content: Text(
          "Weet je zeker dat je dit cijfer (${grade.cijferStr} voor ${grade.subject.value?.naam ?? 'vak'}) definitief wilt verwijderen?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuleren"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Wissen"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      isar.writeTxnSync(() {
        isar.grades.deleteSync(grade.uuid);
      });
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cijfer gewist"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final archivedGrades = _getArchivedGrades();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Gearchiveerde cijfers"),
        actions: [
          if (archivedGrades.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'enable_all') {
                  _toggleAll(true, archivedGrades);
                } else if (value == 'disable_all') {
                  _toggleAll(false, archivedGrades);
                } else if (value == 'delete_all') {
                  _deleteAll(archivedGrades);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'enable_all',
                  child: Text("Alles inschakelen"),
                ),
                const PopupMenuItem(
                  value: 'disable_all',
                  child: Text("Alles uitschakelen"),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete_all',
                  child: Text(
                    "Alles definitief wissen",
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ],
            ),
        ],
      ),
      children: [
        if (archivedGrades.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: colorScheme.tertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Geen gearchiveerde cijfers",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Wanneer een school cijfers tijdelijk verwijdert (bijv. tijdens een toetsweek), worden ze hier automatisch bewaard.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Deze cijfers zijn niet meer aanwezig in Magister, maar bewaard om gemiddelden en berekeningen accuraat te houden.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: CustomCard(
              child: Column(
                children: [
                  for (int i = 0; i < archivedGrades.length; i++) ...[
                    ListTile(
                      leading: GradeAvatar(
                        heroTag: archivedGrades[i].id,
                        gradeString: archivedGrades[i].cijferStr,
                        badge: archivedGrades[i].weight != null
                            ? "${archivedGrades[i].weight!.displayNumber()}x"
                            : null,
                      ),
                      title: Text(
                        archivedGrades[i].subject.value?.naam.capitalized ??
                            "Vak",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        [
                          if (archivedGrades[i].description?.isNotEmpty == true)
                            archivedGrades[i].description!,
                          if (archivedGrades[i].datumIngevoerd != null)
                            archivedGrades[i].datumIngevoerd!.formattedDate,
                        ].join(" • "),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: archivedGrades[i].isEnabled,
                            onChanged: (val) {
                              isar.writeTxnSync(() {
                                archivedGrades[i].isEnabled = val;
                                isar.grades.putSync(archivedGrades[i]);
                              });
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: colorScheme.error,
                            ),
                            tooltip: "Wis cijfer",
                            onPressed: () => _deleteSingle(archivedGrades[i]),
                          ),
                        ],
                      ),
                    ),
                    if (i < archivedGrades.length - 1)
                      const Divider(height: 1),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ]
      ],
    );
  }
}

extension GradeBadgeTypesNames on GradeBadgeTypes {
  Widget get title {
    switch (this) {
      case GradeBadgeTypes.weight:
        return const Icon(Icons.balance_rounded);
      case GradeBadgeTypes.pta:
        return const Badge(
          label: Text("PTA"),
        );
      case GradeBadgeTypes.date:
        return const Icon(Icons.date_range_rounded);
      case GradeBadgeTypes.globalChange:
        return const Badge(
            label: Icon(Icons.trending_up_rounded), child: Icon(Icons.numbers));
      case GradeBadgeTypes.change:
        return const Badge(
            label: Icon(Icons.trending_up_rounded), child: Icon(Icons.book));
    }
  }
}
