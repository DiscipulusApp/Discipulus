import 'dart:io';

import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/activities/activity_detail.dart';
import 'package:discipulus/screens/bronnen/external_source_list.dart';
// import 'package:discipulus/screens/calendar/calendar_week/calendar_week.dart';
import 'package:discipulus/screens/calendar/experimental/calendar_stats.dart';
import 'package:discipulus/screens/grades/grades_subject.dart';
import 'package:discipulus/screens/introduction/post_login.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/screens/messages/message_details.dart';
import 'package:discipulus/screens/introduction/vertical_intro.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_details.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Routes
import 'package:discipulus/screens/activities/activities.dart';
import 'package:discipulus/screens/assignments/assignments.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/leermiddelen.dart';
import 'package:discipulus/screens/messages/messages.dart';
import 'package:discipulus/screens/bronnen/bronnen_list.dart';
import 'package:discipulus/screens/settings/settings.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzers.dart';
import 'package:discipulus/screens/summary/home.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

/// The main navigationKey. all navigation should be handaled though here.
final GlobalKey<NavigatorState> navKey = GlobalKey();

/// Collection of [Destination] with a specific name
class DestinationSegement {
  final String? name;
  final List<Destination> destinations;

  DestinationSegement({this.name, this.destinations = const []});
}

/// A root destination with a name and icon
class Destination {
  final Widget icon;
  final Widget filledIcon;
  final String label;
  final Widget view;

  /// Contains a list of types that can be considered sub-views
  final List<Type> subviews;

  final MenuSerializableShortcut? shortcut;

  const Destination({
    required this.icon,
    required this.label,
    required this.view,
    this.subviews = const [],
    required this.filledIcon,
    this.shortcut,
  });
}

/// Build the destinations for a profile.
/// The permissions of a profile are required because these can differ per
/// school and account type.
List<DestinationSegement> destinations(List<Permission> permissions,
        {bool forceDebug = false}) =>
    [
      if (kDebugMode || forceDebug)
        DestinationSegement(destinations: const [
          Destination(
            label: "Samenvatting",
            icon: Icon(Icons.auto_awesome_outlined),
            filledIcon: Icon(Icons.auto_awesome),
            shortcut: SingleActivator(LogicalKeyboardKey.keyH, alt: true),
            view: HomeScreen(),
          ),
        ]),
      DestinationSegement(name: "Actueel", destinations: [
        if (permissions.hasPermissions(PermissionType.afspraken))
          const Destination(
            label: "Kalender",
            icon: Icon(Icons.calendar_today_outlined),
            filledIcon: Icon(Icons.calendar_today),
            shortcut: SingleActivator(LogicalKeyboardKey.keyK, alt: true),
            view: CalendarDayView(),
          ),
        if (permissions.hasPermissions(PermissionType.cijfers))
          const Destination(
            label: "Cijfers",
            icon: Icon(Icons.numbers_outlined),
            filledIcon: Icon(Icons.numbers),
            shortcut: SingleActivator(LogicalKeyboardKey.keyC, alt: true),
            view: GradesListScreen(),
            subviews: [SubjectGradesScreen],
          ),
        if (permissions.hasPermissions(PermissionType.berichten))
          const Destination(
            label: "Berichten",
            icon: Icon(Icons.message_outlined),
            filledIcon: Icon(Icons.message),
            shortcut: SingleActivator(LogicalKeyboardKey.keyB, alt: true),
            view: MessagesListScreen(),
            subviews: [MessageScreen],
          ),
      ]),
      DestinationSegement(name: "Elektronische leeromgeving", destinations: [
        if (permissions.hasPermissions(PermissionType.studiewijzers) ||
            permissions.hasPermissions(PermissionType.projecten))
          const Destination(
            label: "Studiewijzers",
            icon: Icon(Icons.collections_bookmark_outlined),
            filledIcon: Icon(Icons.collections_bookmark),
            shortcut: SingleActivator(LogicalKeyboardKey.keyS, alt: true),
            view: StudiewijzerListScreen(),
            subviews: [StudieWijzerScreen],
          ),
        if (permissions.hasPermissions(PermissionType.eloOpdracht))
          const Destination(
            label: "Opdrachten",
            icon: Icon(Icons.history_edu_outlined),
            filledIcon: Icon(Icons.history_edu),
            shortcut: SingleActivator(LogicalKeyboardKey.keyO, alt: true),
            view: AssignmentListScreen(),
          ),
        if (permissions.hasPermissions(PermissionType.bronnen))
          const Destination(
            label: "Externe bronnen",
            icon: Icon(Icons.cloud_outlined),
            filledIcon: Icon(Icons.cloud_rounded),
            shortcut: SingleActivator(LogicalKeyboardKey.keyD, alt: true),
            view: ExternalBronnenSourcesList(),
          ),
        if (permissions.hasPermissions(PermissionType.digitaalLesmateriaal))
          const Destination(
            label: "Leermiddelen",
            icon: Icon(Icons.menu_book_outlined),
            filledIcon: Icon(Icons.menu_book),
            shortcut: SingleActivator(LogicalKeyboardKey.keyL, alt: true),
            view: LeermiddelenScreen(),
          ),
      ]),
      DestinationSegement(name: "Overige", destinations: [
        if (permissions.hasPermissions(PermissionType.activiteiten))
          const Destination(
            label: "Activiteiten",
            icon: Icon(Icons.local_activity_outlined),
            filledIcon: Icon(Icons.local_activity),
            shortcut: SingleActivator(LogicalKeyboardKey.keyA, alt: true),
            view: ActivitiesScreen(),
            subviews: [ActivityDetailScreen],
          ),
        const Destination(
          label: "Bronnen",
          icon: Icon(Icons.attach_file_outlined),
          filledIcon: Icon(Icons.attach_file),
          shortcut: SingleActivator(LogicalKeyboardKey.keyB, alt: true),
          view: BronnenListScreen(),
        ),
        const Destination(
          label: "Instellingen",
          icon: Icon(Icons.settings_outlined),
          filledIcon: Icon(Icons.settings),
          shortcut: SingleActivator(LogicalKeyboardKey.comma, meta: true),
          view: SettingsScreen(),
        ),
      ]),
      if (kDebugMode || forceDebug)
        DestinationSegement(name: "Debug", destinations: [
          const Destination(
            icon: Icon(Icons.interests),
            filledIcon: Icon(Icons.interests_outlined),
            label: "Post Login",
            view: PostLoginScreen(),
          ),
          // const Destination(
          //   icon: Icon(Icons.calendar_view_week_outlined),
          //   filledIcon: Icon(Icons.calendar_view_week),
          //   label: "Calendar Week",
          //   view: CalendarWeekScreen(),
          // ),
          const Destination(
            icon: Icon(Icons.screen_lock_landscape_outlined),
            filledIcon: Icon(Icons.screen_lock_landscape),
            label: "Scroll intro",
            view: VerticalIntroductionScreen(
              key: ValueKey("TRANSPARENT"),
            ),
          ),
          const Destination(
            icon: Icon(Icons.start_outlined),
            filledIcon: Icon(Icons.start),
            label: "Calendar Statictics",
            view: CalendarStatistics(),
          ),
        ])
    ].where((s) => s.destinations.isNotEmpty).toList();

List<PlatformMenuItem> platformMenu = [];

/// Updates the menubar for macOS
void updateMenuBar({required List<DestinationSegement> destinations}) async {
  platformMenu = [
    const PlatformMenu(label: "Discipulus", menus: [
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.about,
        )
      ]),
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.servicesSubmenu,
        ),
      ]),
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.hide,
        ),
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.hideOtherApplications,
        ),
      ]),
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.quit,
        ),
      ])
    ]),
    const PlatformMenu(label: "Window", menus: [
      PlatformMenuItemGroup(members: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.minimizeWindow,
        ),
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.zoomWindow,
        ),
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.toggleFullScreen,
        ),
      ]),
    ]),
    PlatformMenu(
      label: "Go",
      menus: [
        PlatformMenu(label: "Profielen", menus: [
          PlatformMenuItem(
            label: "Volgende profiel",
            shortcut: const SingleActivator(LogicalKeyboardKey.keyZ, alt: true),
            onSelected: isar.profiles.countSync() > 1
                ? () async {
                    await nextActiveProfile();
                    Layout.of(navKey.currentContext!)
                      ?..update()
                      ..goToPageFromIndex(null);
                  }
                : null,
          ),
          PlatformMenuItemGroup(members: [
            for (var profile in isar.profiles.where().findAllSync())
              PlatformMenuItem(
                label: profile.name,
                onSelected: profile.uuid != activeProfile.uuid
                    ? () {
                        activeProfile = profile;
                        Layout.of(navKey.currentContext!)
                          ?..update()
                          ..goToPageFromIndex(null);
                      }
                    : null,
              )
          ])
        ]),
        for (DestinationSegement segment in destinations)
          PlatformMenuItemGroup(
            members: [
              for (var destination in segment.destinations)
                PlatformMenuItem(
                  label: destination.label,
                  shortcut: destination.shortcut,
                  onSelected: () => Layout.of(navKey.currentContext!)
                      ?.goToPage(destination.view),
                ),
            ],
          ),
        PlatformMenuItemGroup(members: [
          PlatformMenuItem(
            label: "Compose",
            shortcut: const SingleActivator(LogicalKeyboardKey.keyN, alt: true),
            onSelected: () => showComposeMessageSheet(navKey.currentContext!),
          ),
        ])
      ],
    ),
  ];

  // This is only supported on macOS
  if (Platform.isMacOS) {
    WidgetsBinding.instance.platformMenuDelegate.setMenus(platformMenu);
  }
}

/// Returns a [IconButton] that opens the drawer if the drawer has to be opened (in small views)
Widget? leadingAppBarButton(BuildContext context) {
  if (!Layout.of(context)!.persistantDrawer &&
      !Navigator.of(context).canPop()) {
    return Center(
      child: IconButton(
        onPressed: () => Layout.of(context)!.drawerController.toggleDrawer(),
        icon: const Icon(Icons.menu),
      ),
    );
  } else {
    return null;
  }
}

Widget onPopToggleDrawer({required Widget child}) => PopScope(
      canPop: navKey.currentContext != null && navKey.currentContext!.mounted
          ? Layout.of(navKey.currentContext!)!.persistantDrawer &&
              !appSettings.drawerOnBack
          : true,
      onPopInvokedWithResult: (didPop, result) {
        Layout.of(navKey.currentContext!)!.drawerController.toggleDrawer();
      },
      child: child,
    );
