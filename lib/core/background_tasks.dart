part of '../main.dart';

/// This class is used to schedule background tasks using the Workmanager package.
/// It also contains the logic for refreshing data and sending notifications.
class BackgroundRefresh {
  static Future<void> init() async {
    Workmanager().initialize(backgroundSync, isInDebugMode: !kReleaseMode);

    if (Platform.isAndroid) {
      Workmanager().registerPeriodicTask(
        "discipulusQuickrefresh",
        "discipulusQuickrefresh",
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(minutes: 30),
      );
    } else if (Platform.isIOS &&
        (await Workmanager().checkBackgroundRefreshPermission()) ==
            BackgroundRefreshPermissionState.available) {
      Workmanager().registerProcessingTask(
        "dev.harrydekat.discipulus.discipulusQuickrefresh",
        "dev.harrydekat.discipulus.discipulusQuickrefresh",
        constraints: Constraints(networkType: NetworkType.connected),
      );
    }
  }

  /// Will perform some quick refresh operations for all logged in accounts unless specified otherwise
  static Future<void> quickRefresh({
    List<Profile>? profiles,
    bool onlyRefreshNeeded = true,
    bool enableNotifcations = true,
  }) async {
    // Profiles that will be refreshed
    List<Profile> refreshingProfiles = [...?profiles].isNotEmpty
        ? profiles!
        : (await isar.profiles.filter().not().accountIsNull().findAll());

    // When all the saved schoolyears and dates are in the past, we will check
    // for new ones
    await Future.wait([
      for (Profile profile in refreshingProfiles)
        Future(() async {
          if (await profile.schoolyears
                  .filter()
                  .eindeGreaterThan(DateTime.now())
                  .count() ==
              0) {
            await profile.getSchoolyears();
          }
        })
    ]);
    for (Profile profile in refreshingProfiles) {
      if (await profile.schoolyears
              .filter()
              .eindeGreaterThan(DateTime.now())
              .count() ==
          0) {
        await profile.getSchoolyears();
      }
    }

    // Remove accounts that do not need a refresh
    if (onlyRefreshNeeded) {
      refreshingProfiles
          .removeWhere((profile) => !shouldRefresh(profiles: [profile]));
    }

    // Run garbagecollector
    _runGarbageCollector();

    // For each profile
    await Future.forEach(refreshingProfiles, (profile) async {
      // Perform refresh
      await Future.wait([
        // Refresh the main inbox (fetches last 15 messages)
        if (profile.settings.messagesNotifications)
          _quickRefreshMessages(profile, enableNotifcations),

        // Refresh grades for last schoolyear
        if (profile.settings.gradesNotfications)
          _quickRefreshGrades(profile, enableNotifcations),

        // Refresh calendar events (oncoming two weeks)
        if (profile.settings.eventsNotifications)
          _quickRefreshCalendar(profile, enableNotifcations),

        if (profile.settings.remindNotifications) scheduleReminders(profile)
      ]);

      //Updated last refresh time
      profile
        ..settings.lastRefresh = DateTime.now()
        ..save();
    });

    // Update the widgets
    await updateWidgets();
  }

  /// Checks if a refresh should take place
  static bool shouldRefresh({List<Profile>? profiles}) {
    // List of the latest refresh times
    List<DateTime> lastRefreshTimes =
        [...?profiles?.map((e) => e.settings.lastRefresh)].nonNulls.toList();

    // If any of these time is more than 30 minutes ago a refresh should take place
    return lastRefreshTimes
        .any((time) => DateTime.now().difference(time).inMinutes >= 30);
  }

  /// Updates the native widgets for the activeProfile.
  static Future<void> updateWidgets() async {
    //TODO: Android
    int profileUUID =
        appSettings.activeProfileUuidWidgets ?? activeProfile.uuid;
    if ((Platform.isIOS || Platform.isMacOS)) {
      List<CalendarEvent> events = await (await isar.profiles
              .filter()
              .uuidEqualTo(profileUUID)
              .findFirst())!
          .calendarEvents
          .filter()
          .startGreaterThan(DateTime.now().subtract(const Duration(days: 1)))
          .eindeLessThan(DateTime.now().add(const Duration(days: 28)))
          .sortByStart()
          .limit(40)
          .findAll();
      await HomeWidget.saveWidgetData<List<Map<String, dynamic>>>(
        'events',
        events
            .where((e) => !e.isCanceled) // filter cancelled lessons
            .combineEvents()
            .map((e) => {
                  'id': e.first.id,
                  'name': e.first.title,
                  'shortName': e.first.subject.value?.afkorting,
                  'location': e.first.lokatie?.nullOnEmpty,
                  'startHourIndicator': e.first.lesuurVan,
                  'endHourIndicator': e.last.lesuurTotMet,
                  'infoType': e.first.infoType.index,
                  'startTime': e.first.start.millisecondsSinceEpoch,
                  'endTime': e.last.einde.millisecondsSinceEpoch,
                  'isCompleted': e.first.afgerond
                }..removeWhere((key, value) => value == null))
            .toList(),
      );
      await HomeWidget.updateWidget(
        name: "EventWidgetProvider",
        iOSName: "NavigatorWidget",
        androidName: "NavigatorWidgetProvider",
        qualifiedAndroidName:
            "dev.harrydekat.discipulus.NavigatorWidgetProvider",
      );
    }
  }
}

/// Refreshes the colorScheme that is used for the widgets for macOS, iOS and
/// Android
Future<void> refreshWidgetColorscheme(
    {required ColorScheme lightColorScheme,
    required ColorScheme darkColorScheme}) async {
  if (Platform.isIOS || Platform.isMacOS) {
    // TODO: Android
    await HomeWidget.saveWidgetData<Map<String, int>>("colors", {
      "background": lightColorScheme.surface.value,
      "primary": lightColorScheme.primary.value,
      "done": Colors.green.harmonizeWith(lightColorScheme.primary).value,
      "test": lightColorScheme.tertiary.value,
      "secondary": lightColorScheme.secondary.value,
      "darkBackground": darkColorScheme.surface.value,
      "darkPrimary": darkColorScheme.primary.value,
      "darkDone": Colors.green.harmonizeWith(darkColorScheme.primary).value,
      "darkTest": darkColorScheme.tertiary.value,
      "darkSecondary": darkColorScheme.secondary.value
    });
  }
}

/// Refresh messages
Future<void> _quickRefreshMessages(
    Profile profile, bool enableNotifcations) async {
  await (await profile.berichtMappen.filter().idEqualTo(1).findFirst())
      ?.getMessages();
}

/// Refresh grades for last schoolyear
Future<void> _quickRefreshGrades(
    Profile profile, bool enableNotifcations) async {
  // Last schoolyear
  Schoolyear? schoolyear =
      await profile.schoolyears.filter().sortByEindeDesc().findFirst();

  // Save the current grade id's, so we can compare it with the data from Magister
  List<int>? gradesBefore =
      await schoolyear?.grades.filter().useable().idProperty().findAll();

  // Refresh grades
  await schoolyear?.fillGrades();

  // Check if new grades were added
  List<int>? gradesAfter =
      await schoolyear?.grades.filter().useable().idProperty().findAll();

  // Remove all exiting grades, so that we are left with only the new ones
  gradesAfter?.removeWhere((gId) => gradesBefore?.contains(gId) ?? false);

  // Send notifications
  if ((gradesAfter?.isNotEmpty ?? false) && enableNotifcations) {
    Set<String> subjectNames = gradesAfter!
        .map((e) => schoolyear!.grades
            .filter()
            .idEqualTo(e)
            .findFirstSync()!
            .subject
            .value!
            .naam)
        .toSet();

    NotificationController.createNotification(
      NativeNotification(
        id: profile.uuid,
        channel: NotificationChannel.grades,
        title: [
          'Nieuwe cijfers gevonden',
          if (await isar.profiles.count() >= 2) 'voor ${profile.name}'
        ].join(" "),
        body: gradesAfter.length == 1
            ? "Er is een nieuw cijfer van ${subjectNames.first} beschikbaar"
            : "Er zijn ${gradesAfter.length} nieuwe cijfers beschikbaar van ${subjectNames.toList().formattedJoin}",
        payload: NotificationPayload(
          profile: profile,
          payload: {"Grades": gradesAfter},
        ),
      ),
    );
  }
}

/// Callback entrypoint for the home_widget package.
@pragma('vm:entry-point')
Future<void> homeWidgetCallback(Uri? uri) async {
  print(uri);
}

Future<void> _runGarbageCollector() async {
  if (appSettings.autoRemoveDate != 0) {
    List<Bron> toBeRemoved = await isar.brons
        .filter()
        .rawSavedPathIsNotNull()
        .lastUsedLessThan(
            DateTime.now().subtract(Duration(days: appSettings.autoRemoveDate)))
        .findAll();
    for (Bron bron in toBeRemoved) {
      bron.remove();
    }
  }
}

/// Background task entrypoint
@pragma('vm:entry-point')
void backgroundSync() {
  try {
    Workmanager().executeTask((task, inputData) async {
      try {
        switch (task) {
          case Workmanager.iOSBackgroundTask:
            stderr.writeln("The iOS background fetch was triggered");
            break;
        }
        initializeTimeZones();
        await Future.wait([
          initializeDateFormatting("nl-NL"),
          initIsar(true),
          NotificationController.init(),
        ]);
        await BackgroundRefresh.quickRefresh(onlyRefreshNeeded: !kDebugMode);
        await isar.close();
        return Future.value(true);
      } catch (e) {
        stderr.writeln(e);
      }

      await isar.close();
      return Future.value(false);
    });
  } catch (e) {
    stderr.writeln(e);
  }
}
