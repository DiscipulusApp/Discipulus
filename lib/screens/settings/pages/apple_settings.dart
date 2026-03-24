import 'package:discipulus/core/watch_service.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/settings/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:home_widget/home_widget.dart';
import 'package:isar/isar.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class AppleSettingsPage extends StatefulWidget {
  const AppleSettingsPage({super.key});

  @override
  State<AppleSettingsPage> createState() => _AppleSettingsPageState();
}

class _AppleSettingsPageState extends State<AppleSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Apple specifieke instellingen"),
      ),
      children: [
        ProfileChangeWidget(
          updateState: (p0) => setState(() {}),
        ),
        const ListTitle(child: Text("Spotlight")),
        SwitchListTile(
          value: activeProfile.settings.spotlightIndexMessages,
          secondary: const Icon(Icons.message_outlined),
          title: const Text("Indexeer berichten"),
          subtitle: const Text("Voeg berichten toe aan spotlight"),
          onChanged: (value) async {
            setState(() {
              activeProfile
                ..settings.spotlightIndexMessages = value
                ..save();
            });
            if (!value) {
              // Setting has been turned off, removing all indexed messages
              await CoreSpotlight.instance.deleteAll(
                identifier: [
                  "dev.harrydekat.discipulus.message.${activeProfile.uuid}"
                ],
                identifierIsDomain: true,
              );
            }
          },
        ),
        SwitchListTile(
          value: activeProfile.settings.spotlightIndexStudiewijzers,
          secondary: const Icon(Icons.book_outlined),
          title: const Text("Indexeer Studiewijzers"),
          subtitle: const Text("Voeg studiewijzers toe aan spotlight"),
          onChanged: (value) async {
            setState(() {
              activeProfile
                ..settings.spotlightIndexStudiewijzers = value
                ..save();
            });
            if (!value) {
              // Setting has been turned off, removing all indexed messages
              await CoreSpotlight.instance.deleteAll(
                identifier: [
                  "dev.harrydekat.discipulus.studiewijzer.${activeProfile.uuid}"
                ],
                identifierIsDomain: true,
              );
            }
          },
        ),
        const ListTitle(child: Text("Handoff")),
        SwitchListTile(
          value: appSettings.useHandoff,
          secondary: const Icon(Icons.handshake_outlined),
          title: const Text("Gebruik handoff"),
          subtitle: const Text("Maak gebruik van Apple's handoff"),
          onChanged: (value) async {
            if (!value) {
              // The handoff was turned off, so we will remove all the indexes
              await CoreSpotlight.instance.deleteAll();
            }
            setState(() {
              appSettings
                ..useHandoff = value
                ..save();
            });
          },
        ),
        const ListTitle(child: Text("Widget")),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Widget profiel"),
          subtitle:
              const Text("Dit profiel zal worden gebruikt voor de widgets"),
          trailing: DropdownButton<int>(
              value: appSettings.activeProfileUuidWidgets ?? activeProfile.uuid,
              onChanged: (value) async {
                setState(() {
                  appSettings
                    ..activeProfileUuidWidgets = value!
                    ..save();
                });
                BackgroundRefresh.updateWidgets();
              },
              items: [
                for (Profile profile in isar.profiles.where().findAllSync())
                  DropdownMenuItem(
                    value: profile.uuid,
                    child: Text(profile.name),
                  )
              ]),
        ),
        ListTile(
          leading: const Icon(Icons.widgets_outlined),
          title: const Text("Gebruikte widgets"),
          subtitle: FutureBuilder(
            future: HomeWidget.getInstalledWidgets(),
            builder: (context, snapshot) {
              return Text("${snapshot.data?.length ?? 0} widget(s) actief.");
            },
          ),
          trailing: LoadingButton(
            future: BackgroundRefresh.updateWidgets,
            child: (isLoading, onTap) => IconButton(
              onPressed: onTap,
              icon: isLoading
                  ? const SizedBox(
                      height: 24,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const Icon(Icons.refresh),
            ),
          ),
        ),
        const ListTitle(child: Text("Apple Watch")),
        FutureBuilder(
          future: WatchConnectivity().isPaired,
          builder: (context, snapshot) {
            final isPaired = snapshot.data ?? false;

            return ListTile(
              leading: const Icon(Icons.watch),
              title: const Text("Status"),
              subtitle: Text(
                !isPaired ? "Geen horloge gekoppeld" : "Gekoppeld",
              ),
              trailing: StreamBuilder(
                stream: WatchConnectivity().messageStream,
                builder: (context, snapshot) => Icon(
                  Icons.circle,
                  size: 12,
                  color: isPaired ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text("Laatste synchronisatie"),
          subtitle: Text(appSettings.lastWatchSync == null
              ? "Nog nooit gesynchroniseerd"
              : "Laatst gesynchroniseerd op ${appSettings.lastWatchSync!.day}-${appSettings.lastWatchSync!.month}-${appSettings.lastWatchSync!.year} om ${appSettings.lastWatchSync!.hour}:${appSettings.lastWatchSync!.minute.toString().padLeft(2, '0')}"),
          trailing: LoadingButton(
            future: WatchService().syncAll,
            child: (isLoading, onTap) => IconButton(
              onPressed: onTap,
              icon: isLoading
                  ? const SizedBox(
                      height: 24,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const Icon(Icons.refresh),
            ),
          ),
        )
      ],
    );
  }
}
