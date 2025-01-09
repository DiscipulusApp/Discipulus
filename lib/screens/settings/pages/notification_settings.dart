import 'package:discipulus/core/notifications.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/settings/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Notificaties & Achtergrond"),
      ),
      children: [
        ProfileChangeWidget(
          updateState: (_) => setState(() {}),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomCard(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: FutureBuilder(
              future: NotificationController.isAllowed,
              builder: (context, snapshot) {
                return SwitchListTile(
                  value: snapshot.hasData ? snapshot.data ?? false : false,
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text("Notificaties"),
                  subtitle: const Text(
                      "Sta toe dat Discipulus je notificaties stuurt"),
                  onChanged: snapshot.hasData
                      ? (value) async {
                          if (value && snapshot.data == true) {
                            // Notifications have been allowed, nothing to do
                          } else if (snapshot.data == false) {
                            // Notifications have been not been allowed yet
                            await NotificationController.requestPermissions();
                          }
                          setState(() {});
                        }
                      : null,
                );
              },
            ),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.event),
          title: const Text("Kalender notificaties"),
          subtitle: const Text(
              "Krijg berichten wanneer lessen uitvallen of van locatie veranderen"),
          value: activeProfile.settings.eventsNotifications,
          onChanged: (value) {
            setState(() {
              activeProfile
                ..settings.eventsNotifications = value
                ..save();
            });
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.numbers),
          title: const Text("Cijfer notificaties"),
          subtitle: const Text(
              "Krijg een melding wanneer er een nieuw cijfer op staat"),
          value: activeProfile.settings.gradesNotfications,
          onChanged: (value) {
            setState(() {
              activeProfile
                ..settings.gradesNotfications = value
                ..save();
            });
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.replay),
          title: const Text("Herinnerings notificaties"),
          subtitle: const Text(
              "Je zal herinnert worden voor belangrijke deadlines van opdrachten en activiteiten"),
          value: activeProfile.settings.remindNotifications,
          onChanged: (value) {
            setState(() {
              activeProfile
                ..settings.remindNotifications = value
                ..save();
            });
          },
        ),
        FutureBuilder(
            future:
                flutterLocalNotificationsPlugin.pendingNotificationRequests(),
            builder: (context, snapshot) {
              return CustomCard(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.alarm),
                  title: Text(
                      "${snapshot.data?.length ?? 0} verwachte notificaties."),
                ),
              );
            })
      ],
    );
  }
}
