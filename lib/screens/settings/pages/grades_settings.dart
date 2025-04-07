import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/widgets/graphs/line_chart.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:discipulus/widgets/global/tiles.dart';
import 'package:flutter/material.dart';

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
