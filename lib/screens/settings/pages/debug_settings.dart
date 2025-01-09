import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/core/notifications.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/introduction/vertical_intro.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:dnd_manager/dnd_manager.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DebugSettingsPage extends StatefulWidget {
  const DebugSettingsPage({super.key});

  @override
  State<DebugSettingsPage> createState() => _DebugSettingsPageState();
}

class _DebugSettingsPageState extends State<DebugSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Debug"),
      ),
      children: [
        ...isar.profiles.filter().not().accountIsNull().findAllSync().map((e) =>
            CustomCard(
                child: ListTile(
              leading:
                  ProfilePicture(base64ProfilePicture: e.base64ProfilePicture),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () async {
                        await isar.writeTxn(() async {
                          isar.studiewijzers
                              .filter()
                              .profile((q) => q.idEqualTo(e.uuid))
                              .deleteAll();
                          isar.discipulusAccounts.delete(e.account.value!.uuid);
                          isar.profiles.delete(e.uuid);
                        });
                        setState(() {});
                        await MainApp.of(context).updateTheme();
                      },
                      icon: const Icon(Icons.remove)),
                  IconButton(
                      onPressed: () => setState(() {
                            activeProfile = e;
                          }),
                      icon: e.isActive
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_outline)),
                ],
              ),
              title: Text(e.name),
            ))),
        ListTile(
          leading: const Icon(Icons.interests_rounded),
          title: const Text("Herstart introductie"),
          trailing: const Icon(Icons.navigate_next),
          onTap: () => Layout.of(context)?.goToPage(
            const VerticalIntroductionScreen(key: ValueKey("TRANSPARENT")),
            showDrawer: false,
            makeFirst: false, // You should be able to go back
          ),
        ),
        ListTile(
          leading: const Icon(Icons.do_not_disturb),
          title: const Text("Toggle DND"),
          onTap: () async {
            bool isOn = await DNDManager.isSilent;

            if (!(await DNDManager.hasDNDAccess)) {
              await DNDManager.requestDNDAccess();
            }
            await DNDManager.setDNDMode(!isOn);
          },
        ),
        ListTile(
          leading: const Icon(Icons.do_not_disturb),
          title: const Text("Add DND background event"),
          onTap: () async {
            print(await AndroidAlarmManager.oneShotAt(
              DateTime.now().add(const Duration(seconds: 15)),
              0,
              toggleDND,
              allowWhileIdle: true,
              exact: true,
              rescheduleOnReboot: true,
              params: DNDAlarm(turnOnDND: true, eventIds: [-1]).toJson(),
            ));
          },
        ),
        ListTile(
            leading: const Icon(Icons.storage),
            title: const Text("Clear Storage"),
            trailing: const Icon(Icons.clear_all),
            onTap: () async {
              Directory((await getTemporaryDirectory()).path)
                  .deleteSync(recursive: true);
            }),
        ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text("Update Widget"),
            trailing: const Icon(Icons.update),
            onTap: () async {
              await BackgroundRefresh.updateWidgets();
            }),
        ListTile(
            leading: const Icon(Icons.grade),
            title: const Text("Remove last grade"),
            trailing: const Icon(Icons.clear_all),
            onTap: () async {
              var schoolyear = await activeProfile.schoolyears
                  .filter()
                  .sortByEindeDesc()
                  .findFirst();
              isar.writeTxn(() async => await schoolyear!.grades
                  .filter()
                  .useable()
                  .sortByDatumIngevoerdDesc()
                  .deleteFirst());
            }),
        ListTile(
          title: const Text("Run background event"),
          onTap: () => BackgroundRefresh.quickRefresh(
            enableNotifcations: true,
            onlyRefreshNeeded: false,
          ),
        ),
        ListTile(
          title: const Text("Schedule reminder"),
          onTap: () => NotificationController.createNotification(
              NativeNotification(
                id: 0,
                title: "Test reminder",
                body: "This is a test reminder to see if it works ",
                channel: NotificationChannel.reminders,
              ),
              time: DateTime.now().add(const Duration(seconds: 30))),
        ),
        ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text("Export database"),
            trailing: const Icon(Icons.import_export),
            onTap: () async {
              await isar.copyToFile(
                  "${(await getTemporaryDirectory()).path}/isar.isar");
              print("${(await getTemporaryDirectory()).path}/isar.isar");
            }),
        ListTile(
            leading: const Icon(Icons.filter_alt),
            title: const Text("Clear grade filters"),
            subtitle: Text("${Settings.activeGradeFilters.length} active"),
            trailing: const Icon(Icons.clear_all),
            onTap: () async {
              setState(() {
                Settings.activeGradeFilters.clear();
              });
            }),
        ListTile(
            leading: const Icon(Icons.storage),
            title: const Text("Clear datebase"),
            trailing: const Icon(Icons.clear_all),
            onTap: () async {
              isar.writeTxnSync(() {
                isar.clearSync();
              });
              await MainApp.of(context).updateTheme();
            }),
        ListTile(
          leading: const Icon(Icons.error),
          title: const Text("Show error"),
          trailing: const Icon(Icons.navigate_next),
          onTap: () => const ErrorsListScreen().push(context),
        )
      ],
    );
  }
}

class ErrorsListScreen extends StatelessWidget {
  const ErrorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Errors"),
        ),
        body: ListView.builder(
          itemCount: errors.length,
          reverse: true,
          itemBuilder: (context, index) {
            FlutterErrorDetails error = errors[index];
            return ExpansionTile(
              title: Text(error.toStringShort()),
              children: [Text(error.stack.toString())],
            );
          },
        ));
  }
}
