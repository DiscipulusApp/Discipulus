import 'package:discipulus/screens/settings/pages/debug_settings.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoSettingsPage extends StatefulWidget {
  const InfoSettingsPage({super.key});

  @override
  State<InfoSettingsPage> createState() => _InfoSettingsPageState();
}

class _InfoSettingsPageState extends State<InfoSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Informatie"),
      ),
      children: [
        ListTile(
          leading: const Icon(Icons.history_edu),
          title: const Text("Bekijk Licenties"),
          subtitle: const Text("Licenties van alle gebruikte externe code"),
          trailing: const Icon(Icons.navigate_next),
          onTap: () => showLicensePage(
            context: context,
            applicationIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.query_stats_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 64,
              ),
            ),
            applicationName: "Discipulus",
          ),
          onLongPress: () => const DebugSettingsPage().push(context),
        ),
        ListTile(
          leading: const Icon(Icons.device_hub_rounded),
          title: const Text("Github"),
          subtitle: const Text("Alle broncode voor Discipulus"),
          trailing: const Icon(Icons.open_in_browser),
          onTap: () => launchUrl(
            Uri.https('github.com', 'DiscipulusApp/Discipulus'),
            mode: LaunchMode.externalApplication,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.mail),
          title: const Text("Developer"),
          subtitle: const Text("Stuur een mailtje"),
          trailing: const Icon(Icons.open_in_browser),
          onTap: () => launchUrl(
            Uri(scheme: "mailto", path: "harry@harrydekat.dev"),
            mode: LaunchMode.externalApplication,
          ),
        )
      ],
    );
  }
}
