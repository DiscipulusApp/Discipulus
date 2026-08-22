import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/core/notifications.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/introduction/expressive_intro.dart';
import 'package:discipulus/screens/introduction/post_login.dart';
import 'package:discipulus/screens/introduction/vertical_intro.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/utils/login_logger.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
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
  void _showLoginDiagnosticSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final logText = LoginLogger.instance.getLogText();
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Login Diagnostiek"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: "Kopieer logboek",
                    onPressed: () =>
                        LoginLogger.instance.copyToClipboard(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    tooltip: "Deel logboek",
                    onPressed: () => LoginLogger.instance.shareLog(context),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: SelectableText(
                    logText,
                    style: const TextStyle(
                      fontFamily: "monospace",
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final profiles =
        isar.profiles.filter().not().accountIsNull().findAllSync();

    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Debug Menu"),
      ),
      children: [
        //
        // 1. Accounts & Profiles
        //
        if (profiles.isNotEmpty) ...[
          const ListTitle(child: Text("Accounts & Profielen")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: CustomCard(
              child: Column(
                children: [
                  for (int i = 0; i < profiles.length; i++) ...[
                    ListTile(
                      leading: ProfilePicture(
                        base64ProfilePicture: profiles[i].base64ProfilePicture,
                      ),
                      title: Text(profiles[i].name),
                      subtitle: Text("ID: ${profiles[i].id} | UUID: ${profiles[i].uuid}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: profiles[i].isActive
                                ? "Actief profiel"
                                : "Maak actief",
                            icon: Icon(
                              profiles[i].isActive
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: profiles[i].isActive
                                  ? colorScheme.primary
                                  : null,
                            ),
                            onPressed: () => setState(() {
                              activeProfile = profiles[i];
                            }),
                          ),
                          IconButton(
                            tooltip: "Verwijder profiel",
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: colorScheme.error,
                            ),
                            onPressed: () async {
                              final profile = profiles[i];
                              await isar.writeTxn(() async {
                                isar.studiewijzers
                                    .filter()
                                    .profile((q) => q.idEqualTo(profile.uuid))
                                    .deleteAll();
                                if (profile.account.value?.uuid != null) {
                                  isar.discipulusAccounts
                                      .delete(profile.account.value!.uuid);
                                }
                                isar.profiles.delete(profile.uuid);
                              });
                              if (!context.mounted) return;
                              setState(() {});
                              await MainApp.of(context).updateTheme();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (i < profiles.length - 1) const Divider(height: 1),
                  ]
                ],
              ),
            ),
          ),
        ],

        //
        // 2. UI & Onboarding Previews
        //
        const ListTitle(child: Text("UI & Onboarding Previews")),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: CustomCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.auto_awesome_rounded),
                  title: const Text("Material 3 Expressive Intro"),
                  subtitle: const Text("Bekijk de nieuwe onboarding flow"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      const ExpressiveIntroductionScreen().push(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.celebration_rounded),
                  title: const Text("Material 3 Expressive Post-Login"),
                  subtitle:
                      const Text("Bekijk de post-login features carousel"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => const PostLoginScreen().push(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.interests_rounded),
                  title: const Text("Klassieke introductie"),
                  subtitle: const Text("Herstart de verticale introductie"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Layout.of(context)?.goToPage(
                    const VerticalIntroductionScreen(
                        key: ValueKey("TRANSPARENT")),
                    showDrawer: false,
                    makeFirst: false,
                  ),
                ),
              ],
            ),
          ),
        ),

        //
        // 3. Diagnostics & Logs
        //
        const ListTitle(child: Text("Diagnostiek & Logboeken")),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: CustomCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.assignment_outlined),
                  title: const Text("Login diagnostisch logboek"),
                  subtitle:
                      const Text("Bekijk en exporteer recente login logs"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showLoginDiagnosticSheet(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.error_outline_rounded),
                  title: const Text("Geregistreerde app-fouten"),
                  subtitle: Text("${errors.length} fouten gelogd"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => const ErrorsListScreen().push(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.import_export_rounded),
                  title: const Text("Exporteer lokale database"),
                  subtitle: const Text("Kopieer isar.isar naar tijdelijke map"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    final targetPath =
                        "${(await getTemporaryDirectory()).path}/isar.isar";
                    await isar.copyToFile(targetPath);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Database geëxporteerd naar: $targetPath"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        //
        // 4. Background Tasks & System
        //
        const ListTitle(child: Text("Achtergrondtaken & Systeem")),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: CustomCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.alarm_add_rounded),
                  title: const Text("Slimme wekker test"),
                  subtitle: const Text("Bereken en test de volgende wektijd"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    final (alarmTime, lesson) =
                        await activeProfile.calculateSmartAlarmTime();
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Slimme wekker resultaat"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Berekende tijd: ${alarmTime?.formattedDateAndTime ?? 'Geen'}",
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Gebaseerd op les: ${lesson?.title ?? (lesson?.omschrijving ?? 'Geen')}",
                            ),
                            if (lesson != null)
                              Text(
                                "Les begint om: ${lesson.start.formattedTime}",
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Sluiten"),
                          ),
                          FilledButton(
                            onPressed: () async {
                              await activeProfile.scheduleSmartAlarm();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Alarm ingepland"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Text("Nu inplannen"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.widgets_outlined),
                  title: const Text("Update widgets"),
                  subtitle: const Text("Werk home-screen widgets bij"),
                  onTap: () async {
                    await BackgroundRefresh.updateWidgets();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Widgets bijgewerkt"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.sync_rounded),
                  title: const Text("Achtergrondverversing uitvoeren"),
                  subtitle: const Text("Voer een geforceerde sync uit"),
                  onTap: () async {
                    await BackgroundRefresh.quickRefresh(
                      enableNotifcations: true,
                      onlyRefreshNeeded: false,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Achtergrondverversing voltooid"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: const Text("Test notificatie plannen"),
                  subtitle: const Text("Ontvang testmelding na 30 seconden"),
                  onTap: () async {
                    await NotificationController.createNotification(
                      NativeNotification(
                        id: 0,
                        title: "Discipulus Test",
                        body: "Dit is een testnotificatie vanuit het debug menu.",
                        channel: NotificationChannel.reminders,
                      ),
                      time: DateTime.now().add(const Duration(seconds: 30)),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Testmelding gepland over 30 seconden"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.do_not_disturb_on_outlined),
                  title: const Text("Niet Storen (DND) schakelen"),
                  subtitle: const Text("Toggle actieve DND modus"),
                  onTap: () async {
                    bool isOn = await DNDManager.isSilent;
                    if (!(await DNDManager.hasDNDAccess)) {
                      await DNDManager.requestDNDAccess();
                    }
                    await DNDManager.setDNDMode(!isOn);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("DND ${!isOn ? 'ingeschakeld' : 'uitgeschakeld'}"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.schedule_rounded),
                  title: const Text("DND achtergrondevent plannen"),
                  subtitle: const Text("Plan DND alarm na 15 seconden"),
                  onTap: () async {
                    await AndroidAlarmManager.oneShotAt(
                      DateTime.now().add(const Duration(seconds: 15)),
                      0,
                      toggleDND,
                      allowWhileIdle: true,
                      exact: true,
                      rescheduleOnReboot: true,
                      params: DNDAlarm(turnOnDND: true, eventIds: [-1]).toJson(),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("DND event gepland over 15 seconden"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        //
        // 5. Data & Cache Maintenance
        //
        const ListTitle(child: Text("Gegevens & Cache Beheer")),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: CustomCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.grade_outlined),
                  title: const Text("Verwijder meest recente cijfer"),
                  subtitle: const Text("Handig voor het testen van notificaties"),
                  onTap: () async {
                    var schoolyears = await activeProfile.schoolyears
                        .filter()
                        .sortByEindeDesc()
                        .findAll();
                    Schoolyear? targetSchoolyear;
                    for (var sy in schoolyears) {
                      if (await sy.grades.filter().useable().count() > 0) {
                        targetSchoolyear = sy;
                        break;
                      }
                    }
                    targetSchoolyear ??= schoolyears.firstOrNull;

                    if (targetSchoolyear != null) {
                      await isar.writeTxn(() async => await targetSchoolyear!.grades
                          .filter()
                          .useable()
                          .sortByDatumIngevoerdDesc()
                          .deleteFirst());
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Laatste cijfer verwijderd"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text("Simuleer toetsweek (archiveer cijfers)"),
                  subtitle: const Text(
                    "Markeert de 3 meest recente cijfers als gearchiveerd",
                  ),
                  onTap: () async {
                    var schoolyears = await activeProfile.schoolyears
                        .filter()
                        .sortByEindeDesc()
                        .findAll();
                    Schoolyear? targetSchoolyear;
                    for (var sy in schoolyears) {
                      if (await sy.grades
                              .filter()
                              .isArchivedEqualTo(false)
                              .count() >
                          0) {
                        targetSchoolyear = sy;
                        break;
                      }
                    }
                    targetSchoolyear ??= schoolyears.firstOrNull;

                    if (targetSchoolyear != null) {
                      var recentGrades = await targetSchoolyear.grades
                          .filter()
                          .isArchivedEqualTo(false)
                          .sortByDatumIngevoerdDesc()
                          .limit(3)
                          .findAll();
                      if (recentGrades.isNotEmpty) {
                        isar.writeTxnSync(() {
                          for (var g in recentGrades) {
                            g.isArchived = true;
                            isar.grades.putSync(g);
                          }
                        });
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${recentGrades.length} cijfers gemarkeerd als gearchiveerd (${targetSchoolyear.groep.code})",
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Geen actieve cijfers gevonden om te archiveren",
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.unarchive_outlined),
                  title: const Text("Herstel alle gearchiveerde cijfers"),
                  subtitle: const Text(
                    "Zet de status van alle gearchiveerde cijfers terug naar actief",
                  ),
                  onTap: () async {
                    var archived = await isar.grades
                        .filter()
                        .isArchivedEqualTo(true)
                        .findAll();
                    if (archived.isNotEmpty) {
                      isar.writeTxnSync(() {
                        for (var g in archived) {
                          g.isArchived = false;
                          isar.grades.putSync(g);
                        }
                      });
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${archived.length} gearchiveerde cijfers hersteld naar actief",
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Geen gearchiveerde cijfers gevonden"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.filter_alt_outlined),
                  title: const Text("Wis cijferfilters"),
                  subtitle: Text("${Settings.activeGradeFilters.length} filters actief"),
                  onTap: () {
                    setState(() {
                      Settings.activeGradeFilters.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cijferfilters gewist"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined),
                  title: const Text("Wis tijdelijke bestanden (Cache)"),
                  subtitle: const Text("Verwijder tijdelijke downloads en cache"),
                  onTap: () async {
                    Directory((await getTemporaryDirectory()).path)
                        .deleteSync(recursive: true);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tijdelijke opslag gewist"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever_rounded,
                    color: colorScheme.error,
                  ),
                  title: Text(
                    "Wis gehele database",
                    style: TextStyle(color: colorScheme.error),
                  ),
                  subtitle: const Text(
                    "Verwijdert alle lokale profielen, cijfers en instellingen",
                  ),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Database wissen?"),
                        content: const Text(
                          "Weet je zeker dat je alle lokale gegevens wilt wissen? Dit kan niet ongedaan worden gemaakt.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Annuleren"),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Wis alles"),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      isar.writeTxnSync(() {
                        isar.clearSync();
                      });
                      if (!context.mounted) return;
                      await MainApp.of(context).updateTheme();
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

class ErrorsListScreen extends StatelessWidget {
  const ErrorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Geregistreerde fouten"),
      ),
      body: errors.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Geen fouten geregistreerd",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Er zijn momenteel geen fouten opgeslagen.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: errors.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                FlutterErrorDetails error = errors[errors.length - 1 - index];
                return ExpansionTile(
                  leading: Icon(
                    Icons.error_outline_rounded,
                    color: colorScheme.error,
                  ),
                  title: Text(
                    error.toStringShort(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          error.stack.toString(),
                          style: const TextStyle(
                            fontFamily: "monospace",
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
