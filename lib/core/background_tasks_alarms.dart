part of '../main.dart';

/// This extension is used to schedule and cancel alarms using the AndroidAlarmManager
/// It also keeps track of the active alarms in the app settings
extension AlarmExtension on AndroidAlarm {
  Future<bool> schedule() async {
    bool sucess = await AndroidAlarmManager.oneShotAt(
      time!,
      id,
      callback as Function,
      allowWhileIdle: allowWhileIdle,
      exact: exact,
      rescheduleOnReboot: rescheduleOnReboot,
      params: params,
    );

    if (sucess) {
      // Alarm was successfully scheduled, we need to put the add the id to the
      // list of active alarms.
      appSettings
        ..alarms = [...appSettings.alarms, this]
        ..save();
    }

    return sucess;
  }

  Future<bool> cancel() async {
    bool sucess = await AndroidAlarmManager.cancel(id);
    if (sucess) {
      appSettings
        ..alarms = appSettings.alarms.where((e) => e.id != id).toList()
        ..save();
    }
    return sucess;
  }
}

/// This is the basis of every alarm that actives or deactivates DND mode
class DNDAlarm {
  bool turnOnDND;
  List<int> eventIds;

  DNDAlarm({required this.turnOnDND, required this.eventIds});

  factory DNDAlarm.fromJson(Map<String, dynamic> json) => DNDAlarm(
        turnOnDND: json["turnOnDND"],
        eventIds: List<int>.from(json["eventIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "turnOnDND": turnOnDND,
        "eventIds": eventIds,
      };
}

// AndroidAlarmManager background task entrypoint
Future<void> initAutoDND() async => Future.wait([
      initializeDateFormatting("nl-NL"),
      initIsar(true),
      AndroidAlarmManager.initialize()
    ]);

@pragma('vm:entry-point')
Future<void> toggleDND(int scheduleId, dynamic params) async {
  if (params != null) {
    DNDAlarm alarm = DNDAlarm.fromJson(params);
    await initAutoDND();

    // Check if alarm is allowed to fire now
    if (await alarm.isAllowedNow()) {
      if (alarm.turnOnDND) {
        // Turn DND on
        await DNDManager.setDNDMode(true);
        // Update the last time an alarm was changed.
        appSettings
          ..dndTurnedOnTime = DateTime.now()
          ..save();
      } else {
        // Turn DND off
        await DNDManager.setDNDMode(false);
        // Update the last time an alarm was changed.
        appSettings
          ..dndTurnedOnTime = null
          ..save();
      }
    }
  }

  await BackgroundScheduler.scheduler();
}

class BackgroundScheduler {
  /// Schedules background tasks if needed
  static Future<void> scheduler() async {
    Future<void> schedule(Profile profile) async {
      List<List<CalendarEvent>> events = (await profile.calendarEvents
              .filter()
              .duurtHeleDagEqualTo(false)
              .eindeGreaterThan(DateTime.now())
              .excludeFromAutoDNDEqualTo(false)
              .sortByStart()
              .limit(25)
              .findAll())
          .where((e) => !e.isCanceled)
          .combineEvents();

      // Cancel all before set events to prevent ghost events
      await AndroidAlarm.cancelAll();

      await Future.wait([
        for (List<CalendarEvent> event in events) event.schedueleAutoDND(),
      ]);
    }

    List<Profile> profiles = await isar.profiles
        .filter()
        .settings((q) => q.useAutoDNDEqualTo(true).or().smartAlarmEnabledEqualTo(true))
        .findAll();

    for (Profile p in profiles) {
      if (p.settings.useAutoDND) await schedule(p);
      if (p.settings.smartAlarmEnabled) await p.scheduleSmartAlarm();
    }
  }
}

extension BackgroundSchedulerExt on Iterable<CalendarEvent> {
  /// Schedules a workmanager task for Android
  Future<void> schedueleAutoDND() async {
    if (!Platform.isAndroid) return;

    if (last.einde.difference(first.start).inSeconds > 30) {
      final int firstId = first.start.millisecondsSinceEpoch;

      AndroidAlarm alarm = AndroidAlarm(
        time: first.start,
        id: firstId,
        callback: toggleDND,
        allowWhileIdle: true,
        exact: true,
        rescheduleOnReboot: true,
        params: DNDAlarm(
          turnOnDND: true,
          eventIds: [...map((e) => e.uuid)],
        ).toJson(),
      );

      await alarm.cancel();

      // Schedule the start-alarm, which can then schedule the end-alarm
      if (!first.start.difference(DateTime.now()).isNegative) {
        await alarm.schedule();
      }
    }
  }
}

extension on DNDAlarm {
  /// Checks if an alarm is allowed to fire at the time of running this function
  Future<bool> isAllowedNow() async {
    // Check permissions
    if ((await Future.wait([
      DNDManager.hasDNDAccess,
      Permission.scheduleExactAlarm.isGranted,
    ]))
        .contains(false)) {
      return false;
    }

    bool turnOnWhenAlreadyOn = await DNDManager.isSilent && turnOnDND;
    bool turnOffWhenNotTurnedOn =
        !turnOnDND && appSettings.dndTurnedOnTime == null;

    // Check if DND was turned on though Discipulus before turning it off
    if (turnOnWhenAlreadyOn || turnOffWhenNotTurnedOn) {
      // The app is currently silent and we need to turn it on.
      // This will not be needed then, so we can just do nothing, but it will
      // also mean that we have to remove the coming alarm that will turn the DND
      // off, since that did not originate from Discipulus.
      print("AutoDND: Can't turn on DND when it is already set to silent");
      return false;

      // The next alarm will automatically do nothing, since we have not set the
      // dndTurnedOnTime, meaning that it will become null
    }

    // Check if the the alarm has fired in a time that is possible.
    List<CalendarEvent> events = await isar.calendarEvents
        .filter()
        .anyOf(eventIds, (q, uuid) => q.uuidEqualTo(uuid))
        .findAll();

    // We will try to fetch the latest updates
    try {
      await Future.wait([for (var e in events) e.fill()]);
    } catch (e) {
      // Something went wrong fetching the data
      print(
          "AutoDND: An error occurred when fetching the latest data from Magister");
    }

    // Get all durations to the event
    Iterable<Duration> possibleDurations = events
        .expand(
          (e) => [
            e.start.difference(DateTime.now()),
            e.einde.difference(DateTime.now())
          ],
        )
        .where((d) => d.inMinutes < 5 && d.inMinutes > -5);

    // If there are not durations, or alarms, within five minutes of the current
    // time, then we should not toggle DND.
    if (possibleDurations.isEmpty) {
      print("AutoDND: No possible durations found, so autoDND did not fire");
      return false;
    }

    // Find the closest starting event
    CalendarEvent closestEvent = (events
          ..sort(
            (a, b) => a.start.microsecondsSinceEpoch
                .compareTo(DateTime.now().millisecondsSinceEpoch),
          ))
        .where((e) => e.start.difference(DateTime.now()).inSeconds > -60 * 5)
        .first;

    if (turnOnDND &&
        (closestEvent.isCanceled || closestEvent.excludeFromAutoDND)) {
      // This event has been cancelled, so we should not enable DND and cancel
      // the cancel alarm

      print("AutoDND: Close event was either excused or cancelled");

      await AndroidAlarm(id: closestEvent.einde.millisecondsSinceEpoch)
          .cancel();

      return false;
    }

    if (turnOnDND) {
      final int lastId = events.last.einde.millisecondsSinceEpoch;

      // We need to schedule the turning off alarm. We will then also keep in
      // mind that there might be an alarm at the same time that will turn it
      // back on. We will therefor only add this turning off alarm when there
      // is no alarm at the same time that will turn it back on.

      bool hasAlarmAtSameTime = appSettings.alarms.any((e) {
        final timeDiff =
            e.time?.difference(events.last.einde).inSeconds.abs() ?? 60;
        return timeDiff <= 30;
      });

      if (hasAlarmAtSameTime) {
        print("AutoDND: There is already an alarm at the same time");
        return true;
      }

      await AndroidAlarm(
        time: events.last.einde,
        id: lastId,
        callback: toggleDND,
        allowWhileIdle: true,
        exact: true,
        rescheduleOnReboot: true,
        params: DNDAlarm(
          turnOnDND: false,
          eventIds: eventIds,
        ).toJson(),
      ).schedule();
    }

    return true;
  }
}

/// This alarm is used to wake the user up based on their first lesson
class SmartAlarm {
  final int offset;
  final DateTime? latestTime;

  SmartAlarm({required this.offset, this.latestTime});

  factory SmartAlarm.fromJson(Map<String, dynamic> json) => SmartAlarm(
        offset: json["offset"],
        latestTime: json["latestTime"] != null
            ? DateTime.parse(json["latestTime"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "latestTime": latestTime?.toIso8601String(),
      };
}

@pragma('vm:entry-point')
Future<void> toggleSmartAlarm(int scheduleId, dynamic params) async {
  // This function is called when the alarm fires.
  await NotificationController.init();
  await NotificationController.createNotification(
    NativeNotification(
      id: scheduleId,
      title: "Slimme wekker",
      body: "Het is tijd om op te staan voor je eerste les!",
      channel: NotificationChannel.calendar,
      payload: NotificationPayload(
        payload: {"type": "smart_alarm"},
      ),
    ),
  );
}

extension SmartAlarmScheduler on Profile {
  /// Calculates the next smart alarm time for this profile.
  /// Returns a record with the alarm time and the first lesson found (if any).
  Future<(DateTime?, CalendarEvent?)> calculateSmartAlarmTime() async {
    // Find the first lesson of the next day (or today if early morning)
    DateTime now = DateTime.now();
    DateTime end = now.add(const Duration(hours: 24));

    List<CalendarEvent> events = await calendarEvents
        .filter()
        .startGreaterThan(now)
        .startLessThan(end)
        .sortByStart()
        .findAll();

    // Filter for actual lessons (not cancelled, not free hours if possible to distinguish)
    CalendarEvent? firstLesson =
        events.where((e) => !e.isCanceled && !e.duurtHeleDag).firstOrNull;

    DateTime? alarmTime;

    if (firstLesson != null) {
      alarmTime = firstLesson.start
          .subtract(Duration(minutes: settings.smartAlarmOffset));
    }

    // Check boundaries
    if (settings.smartAlarmLatestTime != null) {
      DateTime targetDate =
          alarmTime?.dayOnly ?? now.add(const Duration(days: 1)).dayOnly;

      DateTime latest = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        settings.smartAlarmLatestTime!.hour,
        settings.smartAlarmLatestTime!.minute,
      );

      // If there's no lesson, or the lesson-based alarm is after the latest time,
      // use the latest time.
      if (alarmTime == null || alarmTime.isAfter(latest)) {
        alarmTime = latest;
      }
    }

    // Final check: if the calculated time is in the past, move it forward if it was latestTime?
    // Actually, if it's in the past, we shouldn't schedule it.
    if (alarmTime != null && alarmTime.isBefore(now)) {
      // If it's already past the latest time today, maybe we should look at tomorrow?
      // But this function is typically called periodically.
      return (null, firstLesson);
    }

    return (alarmTime, firstLesson);
  }

  Future<void> scheduleSmartAlarm() async {
    if (!settings.smartAlarmEnabled || !Platform.isAndroid) return;

    final (alarmTime, _) = await calculateSmartAlarmTime();

    if (alarmTime != null) {
      final int alarmId = uuid + 999999;
      // Schedule the alarm
      await AndroidAlarm(
        time: alarmTime,
        id: alarmId,
        callback: toggleSmartAlarm,
        allowWhileIdle: true,
        exact: true,
        rescheduleOnReboot: true,
        params: SmartAlarm(
          offset: settings.smartAlarmOffset,
          latestTime: settings.smartAlarmLatestTime,
        ).toJson(),
      ).schedule();
      print(
          "SmartAlarm: Scheduled alarm for $name at ${alarmTime.formattedDateAndTime}");
    } else {
      print("SmartAlarm: No suitable alarm time found for $name");
    }
  }
}
