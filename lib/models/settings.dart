import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/widgets/global/filters/messages_filter.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';

part 'settings.g.dart';

Settings get appSettings {
  if (isar.settings.countSync() == 0) {
    isar.writeTxnSync(() => isar.settings.putSync(Settings()));
  }
  return isar.settings.where().findFirstSync()!;
}

@collection
class Settings {
  Id id = 0;
  bool? useMaterialYou;
  int activeMaterialYouColorInt = Colors.blue.value;
  @enumerated
  ThemeBrightness brightness = ThemeBrightness.system;
  int? activeProfileUuid;
  int? activeProfileUuidWidgets;
  bool drawerOnBack = true;
  bool drawerOpenOnRight = false;
  double sufficientFrom = 5.5;

  bool sendCrashInfo = true;
  bool useHandoff = true;

  @ignore

  /// This value will be `true` if holiday mode is detected, and when the user
  /// dismisses the holiday mode it will be `false`. When no holiday is detected
  /// and the user can still access the API without issue then this value will
  /// be `null`.
  static bool? holidayMode;

  // Bronnen
  bool showBronExtension = true;
  bool shortBronTitle = false;
  bool openAfterDownload = true;
  bool saveVirtualFiles = false;
  int autoRemoveDate =
      0; // When zero the bronnen will not be removed automatically
  @ignore
  // This is for selecting multiple bronnen
  static List<Bron> selectedBronnnen = [];

  // Calendar
  bool workWeek = true;
  bool coloredFinishedTests = false;
  bool showAutoCancelledEvents = false;
  bool combineDoublePeriods = true;
  bool showEmptySpaceBetweenLessons = true;

  // Grades
  @enumerated
  List<GradeBadgeTypes> enabledGradeBadgeTypes = [
    GradeBadgeTypes.pta,
    GradeBadgeTypes.weight
  ];
  bool curvedGraphs = true;
  bool coloredsufficientFromLine = true;
  bool showCalcCardsInGlobalAverageList = false;
  bool zoomLineGraph = true;
  @enumerated
  SubjectSortType subjectSortType = SubjectSortType.alphabetical;
  @ignore

  /// This contains the active grade filters, this value won't be saved.
  static List<GradeFilter> activeGradeFilters = [];

  @ignore

  /// This contains the active message filters, this value won't be saved.
  static List<MessageFilter> activeMessageFilters = [];

  String? geminiAPIKey;
  bool sharePersonalInformationWithGemini = false;

  DateTime? dndTurnedOnTime;

  List<AndroidAlarm> alarms = [];

  void save() => isar.writeTxnSync(() => isar.settings.putSync(this));
}

enum ThemeBrightness { system, dark, light }

extension ThemeBrightnessExtension on ThemeBrightness {
  String get name {
    switch (index) {
      case 1:
        return "Donker";
      case 2:
        return "licht";
      default:
        return "Systeem";
    }
  }

  Icon get icon {
    switch (index) {
      case 1:
        return const Icon(Icons.dark_mode);
      case 2:
        return const Icon(Icons.light_mode);
      default:
        return const Icon(Icons.auto_mode);
    }
  }
}

enum GradeBadgeTypes { weight, date, pta, change, globalChange }

@embedded
class ProfileSettings {
  DateTime? lastRefresh = DateTime.now();
  bool messagesNotifications = false;
  bool gradesNotfications = false;
  bool eventsNotifications = false;
  bool remindNotifications = true;

  // Spotlight item indexing
  bool spotlightIndexMessages = true;
  bool spotlightIndexStudiewijzers = true;
  bool spotlightIndexAssignments = true;

  /// Contains hashes of ignored uuid's
  List<int> ignoredSuggestedStudiewijzerGroups = [];

  /// The index of the page that the app will start on.
  int startingPageIndex = 0;

  bool autoInsertHeaderAndFooter = false;

  /// This will be inserted at the beginning of the mail "${ontvanger}" will be
  /// replaced with the name of the recipient.
  String? mailHeader = "Geachte, \${ontvanger},\n\n";

  /// This will be inserted at the end of the mail
  String? mailFooter;

  /// Contains the last active schoolyear that was viewed.
  @ignore
  int? activeSchoolyearUUID;

  /// Contains people who you know
  List<Contact> favoritePeople = [];

  /// If this profile should schedule auto Do Not Disturb events. (Android Only)
  bool useAutoDND = false;

  ProfileSettings({
    this.lastRefresh,
    this.mailFooter = "\nMet vriendelijke groeten,\n[naam]",
  });
}

String exportDataBase() {
  return isar.discipulusAccounts.buildQuery().exportJsonSync().toString();
}

@embedded
class AndroidAlarm {
  final DateTime? time; // Should be required, but Isar does not allow that.
  final int id;

  @ignore
  Function(int scheduleId, dynamic params)? callback;
  bool allowWhileIdle;
  bool exact;
  bool rescheduleOnReboot;

  @ignore
  Map<String, dynamic> params;

  AndroidAlarm({
    this.time,
    this.id = 0,
    this.callback,
    this.params = const {},
    this.allowWhileIdle = true,
    this.exact = true,
    this.rescheduleOnReboot = true,
  });

  static Future<void> cancelAll() async {
    await Future.wait([
      for (var alarm in appSettings.alarms) AndroidAlarmManager.cancel(alarm.id)
    ]);
    appSettings
      ..alarms = []
      ..save();
  }
}
