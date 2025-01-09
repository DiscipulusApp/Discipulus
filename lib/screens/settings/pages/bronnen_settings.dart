import 'package:discipulus/models/settings.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

class BronnenSettingsPage extends StatefulWidget {
  const BronnenSettingsPage({super.key});

  @override
  State<BronnenSettingsPage> createState() => _BronnenSettingsPageState();
}

class _BronnenSettingsPageState extends State<BronnenSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Bronnen instellingen"),
      ),
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: DummyBronTiles(
            shortend: appSettings.shortBronTitle,
            removeExt: !appSettings.showBronExtension,
          ),
        ),
        SwitchListTile(
            value: appSettings.showBronExtension,
            secondary: const Icon(Icons.extension),
            title: const Text("Bronnen extensions"),
            subtitle: const Text(
                "Wanneer dit uit staat zal \"Toets.pdf\", \"Toets\" worden"),
            onChanged: (value) {
              setState(() {
                appSettings
                  ..showBronExtension = value
                  ..save();
              });
            }),
        SwitchListTile(
            value: appSettings.shortBronTitle,
            secondary: const Icon(Icons.compress),
            title: const Text("Namen korter maken"),
            subtitle: const Text(
                "Wanneer dit aan staat zal er geprobeert worden om patronen te herkennen en herhalingen te verwijderen"),
            onChanged: (value) {
              setState(() {
                appSettings
                  ..shortBronTitle = value
                  ..save();
              });
            }),
        SwitchListTile(
            value: appSettings.openAfterDownload,
            secondary: const Icon(Icons.downloading),
            title: const Text("Openen na download"),
            subtitle: const Text("Open een bestand na het downloaden"),
            onChanged: (value) {
              setState(() {
                appSettings
                  ..openAfterDownload = value
                  ..save();
              });
            }),
        SwitchListTile(
            value: appSettings.saveVirtualFiles,
            secondary: const Icon(Icons.cloud_sync),
            title: const Text("Sla virtuele bestanden op"),
            subtitle: const Text(
                "Of een onopgeslagen bron die uit het programma wordt gesleept ook nog in het programma wordt opgeslagen"),
            onChanged: (value) {
              setState(() {
                appSettings
                  ..saveVirtualFiles = value
                  ..save();
              });
            }),
      ],
    );
  }
}

class DummyBronTiles extends StatelessWidget {
  const DummyBronTiles(
      {super.key, this.shortend = false, this.removeExt = false});

  final bool shortend;
  final bool removeExt;

  final List<String> items = const [
    "VG6N H13 Uitwerkingen Gravitatie.pdf",
    "VG6N H14 Uitwerkingen Astrofysica.pdf",
    "VG6N H15 Uitwerkingen Golven en deeltjes.pdf",
    "VG6N H16 Uitwerkingen Quantummechanische modellen.pdf",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (String? item in shortend
            ? removeExt
                ? items.simplifyPatterns().map((e) => e?.withoutExt)
                : items.simplifyPatterns()
            : removeExt
                ? items.map((e) => e.withoutExt)
                : items)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(
                item ?? "No name",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text("46.3KB"),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
      ],
    );
  }
}

extension on String {
  get withoutExt => replaceAll(".pdf", "");
}
