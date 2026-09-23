import 'dart:io';

import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/screens/settings/pages/ai_settings.dart';
import 'package:discipulus/screens/settings/pages/android_settings.dart';
import 'package:discipulus/screens/settings/pages/apple_settings.dart';
import 'package:discipulus/screens/settings/pages/bronnen_settings.dart';
import 'package:discipulus/screens/settings/pages/calendar_settings.dart';
import 'package:discipulus/screens/settings/pages/debug_settings.dart';
import 'package:discipulus/screens/settings/pages/discipulus_info.dart';
import 'package:discipulus/screens/settings/pages/discipulus_settings.dart';
import 'package:discipulus/screens/settings/pages/grades_settings.dart';
import 'package:discipulus/screens/settings/pages/login_with_discipulus.dart';
import 'package:discipulus/screens/settings/pages/magister_settings.dart';
import 'package:discipulus/screens/settings/pages/mail_settings.dart';
import 'package:discipulus/screens/settings/pages/notification_settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
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

class SettingsPageSection {
  String name;
  List<SettingsPage> pages;

  SettingsPageSection({
    required this.name,
    required this.pages,
  });
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<SettingsPageSection> settingsPages = [
    SettingsPageSection(name: "Algemeen", pages: [
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
      SettingsPage(
        name: "Kunstmatige intelligentie",
        desc: "OpenAI-compatibel & lokaal systeemmodel",
        icon: const Icon(Icons.auto_awesome),
        page: const AiSettingsPage(),
      ),
    ]),
    SettingsPageSection(name: "Apparaat gerelateerde instellingen", pages: [
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
    ]),
    SettingsPageSection(name: "Pagina instellingen", pages: [
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
    ]),
    SettingsPageSection(name: "Overig", pages: [
      if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)
        SettingsPage(
          name: "Login met Discipulus",
          desc: "Log in op alternatieve applicaties",
          icon: const Icon(Icons.login_rounded),
          page: const LoginWithDiscipulusPage(),
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
    ]),
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
        for (SettingsPageSection section in settingsPages)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: [
                // ListTitle(child: Text(section.name)), I do not think this looks that good tbh
                ...<CustomCard>[
                  for (SettingsPage page in section.pages)
                    CustomCard(
                      margin: EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        leading: page.icon,
                        title: Text(page.name),
                        subtitle: page.desc != null ? Text(page.desc!) : null,
                        onTap: () => page.page
                            .pushSideView(
                              context,
                              onUpdateNormalWindow: ([fn]) =>
                                  setState(fn ?? () {}),
                            )
                            .then((_) => setState(() {})),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                    )
                ].toMaterial3List(
                    inbetweenBorderRadius: const Radius.circular(4),
                    endsBorderRadius: const Radius.circular(12)),
              ],
            ),
          ),
      ],
    );
  }
}

class ProfileChangeWidget extends StatelessWidget {
  const ProfileChangeWidget({
    super.key,
    required this.updateState,
    this.showAddProfileButton = true,
    this.showName = true,
    this.vertical = false,
  });

  final void Function(VoidCallback fn) updateState;
  final bool showAddProfileButton;
  final bool showName;
  final bool vertical;

  Widget _buildHorizontalProfileTile(BuildContext context,
      {required Profile profile}) {
    ColorScheme cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        // Change the profile to this one
        activeProfile = profile;
        updateState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
          color: profile.isActive ? cs.tertiaryContainer : cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(16)),
            side: BorderSide(
              color: profile.isActive ? cs.tertiary : cs.surfaceBright,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: [0.8, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                    child: Material(
                      color: cs.surfaceContainer,
                      child: ProfilePicture(
                        radius: 22.5 + 4,
                        forceSquare: true,
                        key: ValueKey(profile.base64ProfilePicture),
                        base64ProfilePicture: profile.base64ProfilePicture,
                      ),
                    ),
                  ),
                ),
                if (showName)
                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 12),
                    child: Text(
                      profile.name,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: profile.isActive
                            ? cs.onTertiaryContainer
                            : null,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        children: [
          for (Profile profile
              in isar.profiles.filter().not().accountIsNull().findAllSync())
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                // Change the profile to this one
                activeProfile = profile;
                updateState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: profile.isActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ProfilePicture(
                      key: ValueKey(profile.base64ProfilePicture),
                      base64ProfilePicture: profile.base64ProfilePicture,
                    ),
                  ),
                ),
              ),
            ),
          if (showAddProfileButton)
            IconButton.filledTonal(
              onPressed: () => const CreateAccountScreen().push(context),
              icon: const Icon(Icons.person_add),
            )
        ],
      );
    }

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
                    _buildHorizontalProfileTile(context, profile: profile),
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
