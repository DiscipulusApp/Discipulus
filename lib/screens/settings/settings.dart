import 'dart:io';

import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/screens/settings/pages/android_settings.dart';
import 'package:discipulus/screens/settings/pages/apple_settings.dart';
import 'package:discipulus/screens/settings/pages/bronnen_settings.dart';
import 'package:discipulus/screens/settings/pages/calendar_settings.dart';
import 'package:discipulus/screens/settings/pages/debug_settings.dart';
import 'package:discipulus/screens/settings/pages/discipulus_info.dart';
import 'package:discipulus/screens/settings/pages/discipulus_settings.dart';
import 'package:discipulus/screens/settings/pages/grades_settings.dart';
import 'package:discipulus/screens/settings/pages/magister_settings.dart';
import 'package:discipulus/screens/settings/pages/mail_settings.dart';
import 'package:discipulus/screens/settings/pages/notification_settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class SettingsPage {
  String name;
  String? desc;
  Icon icon;

  Widget page;

  SettingsPage({
    required this.name,
    this.desc,
    required this.icon,
    required this.page,
  });
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<SettingsPage> settingsPages = [
    SettingsPage(
      name: "Discipulus",
      desc: "Discipulus specifieke instellingen",
      icon: const Icon(Icons.query_stats_rounded),
      page: const DiscipulusSettingsPage(),
    ),
    SettingsPage(
      name: "Magister",
      desc: "Magister instellingen en informatie",
      icon: const Icon(Icons.work_outline),
      page: const MagisterSettingsPage(),
    ),
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)
      SettingsPage(
        name: "Notificaties & Achtergrond",
        desc: "Berichten over nieuwe cijfers/evenementen",
        icon: const Icon(Icons.notifications_none_rounded),
        page: const NotificationSettingsPage(),
      ),
    if (Platform.isIOS || Platform.isMacOS)
      SettingsPage(
        name: "Apple specifiek",
        desc: "Widgets, Handoff & Spotlight",
        icon: const Icon(Icons.apple_rounded),
        page: const AppleSettingsPage(),
      ),
    if (Platform.isAndroid)
      SettingsPage(
        name: "Android specifiek",
        desc: "Automatische stille modus",
        icon: const Icon(Icons.android_rounded),
        page: const AndroidSettingsPage(),
      ),
    SettingsPage(
      name: "Kalender",
      desc: "Kalender gerelateerde instellingen",
      icon: const Icon(Icons.calendar_month_rounded),
      page: const CalendarSettingsPage(),
    ),
    SettingsPage(
      name: "Cijfers",
      desc: "Voldoende grens, grafieken, badges, etc.",
      icon: const Icon(Icons.numbers_rounded),
      page: const GradesSettingsPage(),
    ),
    SettingsPage(
      name: "Berichten",
      desc: "Headers & Footers",
      icon: const Icon(Icons.message_rounded),
      page: const MailSettingsPage(),
    ),
    SettingsPage(
      name: "Bronnen / Bijlagen",
      desc: "Beheer hoe bronnen worden behandeled",
      icon: const Icon(Icons.file_copy_outlined),
      page: const BronnenSettingsPage(),
    ),
    SettingsPage(
      name: "Over Discipulus",
      desc: "Informatie & Licenties",
      icon: const Icon(Icons.info_outline_rounded),
      page: const InfoSettingsPage(),
    ),
    if (!kReleaseMode)
      SettingsPage(
        name: "Debug",
        desc: "Instellingen voor het testen van de app",
        icon: const Icon(Icons.bug_report),
        page: const DebugSettingsPage(),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Instellingen",
        screenType: SettingsScreen,
      ),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Instellingen"),
      ),
      children: [
        ProfileChangeWidget(
          updateState: (p0) => setState(() {}),
        ),
        for (SettingsPage page in settingsPages)
          ListTile(
            leading: page.icon,
            title: Text(page.name),
            subtitle: page.desc != null ? Text(page.desc!) : null,
            onTap: () => page.page.push(context).then((_) => setState(() {})),
            trailing: const Icon(Icons.navigate_next),
          )
      ],
    );
  }
}

class ProfileChangeWidget extends StatelessWidget {
  const ProfileChangeWidget(
      {super.key, required this.updateState, this.showAddProfileButton = true});

  final void Function(VoidCallback fn) updateState;
  final bool showAddProfileButton;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "profileSelector",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          child: CustomCard(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (Profile profile in isar.profiles
                      .filter()
                      .not()
                      .accountIsNull()
                      .findAllSync())
                    InkWell(
                      onTap: () {
                        // Change the profile to this one
                        activeProfile = profile;
                        updateState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Card.outlined(
                          color: profile.isActive
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Theme(
                                  data: profile.isActive
                                      ? Theme.of(context).copyWith(
                                          colorScheme: Theme.of(context)
                                              .colorScheme
                                              .copyWith(
                                                primaryContainer:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                onPrimaryContainer:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                              ),
                                        )
                                      : Theme.of(context),
                                  child: ProfilePicture(
                                    key: ValueKey(profile.base64ProfilePicture),
                                    base64ProfilePicture:
                                        profile.base64ProfilePicture,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(profile.name),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (showAddProfileButton)
                    IconButton.filledTonal(
                      onPressed: () =>
                          const CreateAccountScreen().push(context),
                      icon: const Icon(Icons.person_add),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
