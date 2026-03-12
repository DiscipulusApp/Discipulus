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
        const DNDToggleCard(),
        // const SmartAlarmCard(),
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

class SmartAlarmCard extends StatefulWidget {
  const SmartAlarmCard({super.key});

  @override
  State<SmartAlarmCard> createState() => _SmartAlarmCardState();
}

class _SmartAlarmCardState extends State<SmartAlarmCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          SwitchListTile(
            value: activeProfile.settings.smartAlarmEnabled,
            secondary: const Icon(Icons.alarm_add),
            title: const Text("Slimme wekker"),
            subtitle: const Text(
                "Zet automatisch een wekker op basis van je eerste les\n(Zeer ongetest en op eigen risico!)"),
            onChanged: (value) async {
              if (value && !await Permission.scheduleExactAlarm.isGranted) {
                await Permission.scheduleExactAlarm.request();
              }
              setState(() {
                activeProfile
                  ..settings.smartAlarmEnabled = value
                  ..save();
              });
              // Trigger background scheduler to update alarms
              await BackgroundScheduler.scheduler();
            },
          ),
          if (activeProfile.settings.smartAlarmEnabled) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text("Tijd voor eerste les"),
              subtitle:
                  Text("${activeProfile.settings.smartAlarmOffset} minuten"),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: activeProfile.settings.smartAlarmOffset.toDouble(),
                  min: 0,
                  max: 120,
                  divisions: 24,
                  label: "${activeProfile.settings.smartAlarmOffset} min",
                  onChanged: (value) {
                    setState(() {
                      activeProfile
                        ..settings.smartAlarmOffset = value.toInt()
                        ..save();
                    });
                  },
                  onChangeEnd: (_) => BackgroundScheduler.scheduler(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Uiterste wektijd"),
              subtitle: Text(
                  activeProfile.settings.smartAlarmLatestTime?.formattedTime ??
                      "Geen"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                        activeProfile.settings.smartAlarmLatestTime ??
                            DateTime(2000, 1, 1, 8, 0)),
                  );
                  if (time != null) {
                    final now = DateTime.now();
                    setState(() {
                      activeProfile
                        ..settings.smartAlarmLatestTime = DateTime(now.year,
                            now.month, now.day, time.hour, time.minute)
                        ..save();
                    });
                    await BackgroundScheduler.scheduler();
                  }
                },
              ),
              onTap: () async {
                // Clear setting on long press or add a clear button?
                // For now, just let them edit it.
                // Maybe add a clear button if it's set.
              },
            ),
            if (activeProfile.settings.smartAlarmLatestTime != null)
              ListTile(
                dense: true,
                leading: const Icon(Icons.clear),
                title: const Text("Verwijder uiterste wektijd"),
                onTap: () {
                  setState(() {
                    activeProfile
                      ..settings.smartAlarmLatestTime = null
                      ..save();
                  });
                  BackgroundScheduler.scheduler();
                },
              )
          ],
        ],
      ),
    );
  }
}
