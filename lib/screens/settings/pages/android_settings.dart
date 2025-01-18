import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/settings/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:dnd_manager/dnd_manager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidSettingsPage extends StatefulWidget {
  const AndroidSettingsPage({super.key});

  @override
  State<AndroidSettingsPage> createState() => _AndroidSettingsPageState();
}

class _AndroidSettingsPageState extends State<AndroidSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Android specifieke instellingen"),
      ),
      children: [
        ProfileChangeWidget(
          updateState: (p0) => setState(() {}),
        ),
        const DNDToggleCard()
      ],
    );
  }
}

class DNDToggleCard extends StatefulWidget {
  const DNDToggleCard({super.key});

  @override
  State<DNDToggleCard> createState() => _DNDToggleCardState();
}

class _DNDToggleCardState extends State<DNDToggleCard> {
  bool alarmPermission = false;
  bool dndPermission = false;

  Future<void> checkPermission() async {
    alarmPermission = await Permission.scheduleExactAlarm.isGranted;
    dndPermission = await DNDManager.hasDNDAccess;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          margin: (alarmPermission && dndPermission)
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          elevation: (alarmPermission && dndPermission) ? 0 : 1,
          child: Column(
            children: [
              if (!alarmPermission)
                ListTile(
                  leading: AllowedNotAllowedIcon(allowed: alarmPermission),
                  trailing: const Icon(Icons.navigate_next),
                  title: const Text("Permissie om alarmen in te stellen"),
                  subtitle: const Text(
                      "Dit is nodig om op het juiste moment DND te activeren."),
                  onTap: () async =>
                      await Permission.scheduleExactAlarm.request().then(
                            (_) async => await checkPermission(),
                          ),
                ),
              if (!dndPermission)
                ListTile(
                  leading: AllowedNotAllowedIcon(allowed: dndPermission),
                  trailing: const Icon(Icons.navigate_next),
                  title: const Text("Permissie om DND te gebruiken"),
                  subtitle: const Text(
                      "Dit is nodig om je telefoon op stil te zetten tijdens lessen."),
                  onTap: () async => await DNDManager.requestDNDAccess().then(
                    (_) async => await checkPermission(),
                  ),
                ),
              if (!(alarmPermission || dndPermission)) const Divider(),
              SwitchListTile(
                value: activeProfile.settings.useAutoDND,
                secondary: const Icon(Icons.do_not_disturb),
                title: const Text("Automatische stille modus"),
                subtitle: const Text("Zet DND aan tijdens lessen"),
                onChanged: (alarmPermission && dndPermission)
                    ? (value) async {
                        activeProfile
                          ..settings.useAutoDND = value
                          ..save();

                        if (value) {
                          await BackgroundScheduler.scheduler();
                        } else {
                          await AndroidAlarm.cancelAll();
                        }

                        await checkPermission();
                      }
                    : null,
              ),
              if (appSettings.alarms.isNotEmpty)
                CustomCard(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.alarm),
                    onTap: () => const AlarmListScreen().push(context),
                    title: Text("${appSettings.alarms.length}x DND ingesteld."),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}

class AlarmListScreen extends StatelessWidget {
  const AlarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          const SliverAppBar.large(
        title: Text("Ingestelde alarmen"),
      ),
      children: [
        for (var alarm in appSettings.alarms)
          ListTile(
            title: Text(alarm.time?.formattedDateAndTime ?? ""),
            subtitle: Text(alarm.params.values.join("\n")),
            leading: const Icon(Icons.alarm),
          )
      ],
    );
  }
}
