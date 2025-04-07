part of '../main.dart';

// Models for tracking changes
class _ChangedEvent {
  Status? statusBefore;
  Status? statusAfter;
  InfoType? infoTypeBefore;
  InfoType? infoTypeAfter;
  String? locationBefore;
  String? locationAfter;

  bool get hasStatusChange => statusBefore != null && statusAfter != null;
  bool get hasInfoTypeChange => infoTypeBefore != null && infoTypeAfter != null;
  bool get hasLocationChange => locationBefore != null && locationAfter != null;

  bool get hasInterestingChanges {
    List<bool> checks = [];

    if (hasStatusChange) {
      // Event was cancelled
      checks.add(_isStatusChangeToCancelled);
      // Event was rescheduled after being cancelled
      checks.add(_isStatusChangeFromCancelled);
      // Event was changed
      checks.add(_isStatusChangeToChanged);
      // Event was moved
      checks.add(_isStatusChangeToMoved);
      // Event was moved and changed
      checks.add(_isStatusChangeToMovedAndChanged);
    }

    if (hasInfoTypeChange) {
      checks.add(_isLestypeChangeInteresting);
    }

    if (hasLocationChange) {
      checks.add(locationBefore != locationAfter);
    }

    return checks.any((e) => e == true);
  }

  bool get _isStatusChangeToCancelled =>
      (statusBefore!.index >= 0 && statusBefore!.index <= 3 ||
          statusBefore!.index >= 6) &&
      statusAfter!.index >= 4 &&
      statusAfter!.index <= 5;

  bool get _isStatusChangeFromCancelled =>
      (statusAfter!.index >= 0 && statusAfter!.index <= 3 ||
          statusAfter!.index >= 6) &&
      statusBefore!.index >= 4 &&
      statusBefore!.index <= 5;

  bool get _isStatusChangeToChanged =>
      statusBefore!.index != 3 && statusAfter!.index == 3;

  bool get _isStatusChangeToMoved =>
      statusBefore!.index != 9 && statusAfter!.index == 9;

  bool get _isStatusChangeToMovedAndChanged =>
      statusBefore!.index != 10 && statusAfter!.index == 10;

  bool get _isLestypeChangeInteresting =>
      (infoTypeAfter != InfoType.homework && infoTypeBefore != InfoType.none) &&
      infoTypeAfter!.index != infoTypeBefore!.index;
}

class _NotificationContent {
  final List<String> titleParts = [];
  final List<String> bodyParts = [];
  final List<int> uuids;

  void addPart({required String title, required String body}) {
    titleParts.add(title);
    bodyParts.add(body);
  }

  _NotificationContent([this.uuids = const []]);

  bool get isEmpty => titleParts.isEmpty || bodyParts.isEmpty;
  String get title => titleParts.join(" ");
  String get body => bodyParts.join(" ");
}

Future<void> _quickRefreshCalendar(
    Profile profile, bool enableNotifications) async {
  if (!enableNotifications) return;

  final changes = await _detectScheduleChanges(profile);
  if (changes.isEmpty) return;

  if (changes.length > 3) {
    await _sendSummaryNotification(profile, changes.length);
  } else {
    await _sendDetailedNotifications(profile, changes);
  }
}

Future<Map<int, _ChangedEvent>> _detectScheduleChanges(Profile profile) async {
  // Get events before and after refresh
  final calendarEventsBefore = await _getCalendarEvents();
  await profile.getEvents(
    DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(
        const Duration(days: 7 * 4), // We will fetch the next four weeks
      ),
    ),
  );
  final calendarEventsAfter = await _getCalendarEvents();

  // Detect all types of changes
  final changes = <int, _ChangedEvent>{};
  _detectStatusChanges(changes, calendarEventsBefore, calendarEventsAfter);
  _detectInfoTypeChanges(changes, calendarEventsBefore, calendarEventsAfter);
  _detectLocationChanges(changes, calendarEventsBefore, calendarEventsAfter);

  // Only keep interesting changes
  changes.removeWhere((_, change) => !change.hasInterestingChanges);

  return changes;
}

Future<List<CalendarEvent>> _getCalendarEvents() async {
  return await isar.calendarEvents
      .filter()
      .startBetween(
          DateTime.now(), DateTime.now().add(const Duration(days: 14)))
      .findAll();
}

void _detectStatusChanges(Map<int, _ChangedEvent> changes,
    List<CalendarEvent> before, List<CalendarEvent> after) {
  final statusBefore =
      Map.fromEntries(before.map((e) => MapEntry(e.id, e.status)));
  final statusAfter =
      Map.fromEntries(after.map((e) => MapEntry(e.id, e.status)));

  for (final entry in statusAfter.entries) {
    if (statusBefore[entry.key] != entry.value) {
      changes[entry.key] = _ChangedEvent()
        ..statusBefore = statusBefore[entry.key]
        ..statusAfter = entry.value;
    }
  }
}

void _detectInfoTypeChanges(Map<int, _ChangedEvent> changes,
    List<CalendarEvent> before, List<CalendarEvent> after) {
  final infoTypeBefore =
      Map.fromEntries(before.map((e) => MapEntry(e.id, e.infoType)));
  final infoTypeAfter =
      Map.fromEntries(after.map((e) => MapEntry(e.id, e.infoType)));

  for (final entry in infoTypeAfter.entries) {
    if (infoTypeBefore[entry.key] != entry.value) {
      if (changes.containsKey(entry.key)) {
        changes[entry.key]!
          ..infoTypeBefore = infoTypeBefore[entry.key]
          ..infoTypeAfter = entry.value;
      } else {
        changes[entry.key] = _ChangedEvent()
          ..infoTypeBefore = infoTypeBefore[entry.key]
          ..infoTypeAfter = entry.value;
      }
    }
  }
}

void _detectLocationChanges(Map<int, _ChangedEvent> changes,
    List<CalendarEvent> before, List<CalendarEvent> after) {
  final locationBefore =
      Map.fromEntries(before.map((e) => MapEntry(e.id, e.lokatie)));
  final locationAfter =
      Map.fromEntries(after.map((e) => MapEntry(e.id, e.lokatie)));

  for (final entry in locationAfter.entries) {
    if (locationBefore[entry.key] != entry.value) {
      if (changes.containsKey(entry.key)) {
        changes[entry.key]!
          ..locationBefore = locationBefore[entry.key]
          ..locationAfter = entry.value;
      } else {
        changes[entry.key] = _ChangedEvent()
          ..locationBefore = locationBefore[entry.key]
          ..locationAfter = entry.value;
      }
    }
  }
}

Future<void> _sendSummaryNotification(Profile profile, int changeCount) async {
  final notification = _NotificationContent();

  notification.addPart(
      title: 'Meerdere roosterwijzigingen gevonden',
      body: "Er zijn $changeCount roosterwijzigingen gevonden");

  if (await isar.profiles.count() >= 2) {
    notification.addPart(
        title: 'voor ${profile.name}', body: 'voor ${profile.name}');
  }

  await _createNotification(profile, notification);
}

Future<void> _sendDetailedNotifications(
    Profile profile, Map<int, _ChangedEvent> changes) async {
  for (var change in changes.entries) {
    final event =
        (await isar.calendarEvents.filter().idEqualTo(change.key).findFirst())!;

    final notification = await _buildEventNotification(event, change.value);
    if (!notification.isEmpty) {
      if (await isar.profiles.count() >= 2) {
        notification.addPart(
            title: 'voor ${profile.name}', body: 'voor ${profile.name}');
      }
      await _createNotification(profile, notification);
    }
  }
}

Future<_NotificationContent> _buildEventNotification(
    CalendarEvent event, _ChangedEvent change) async {
  final notification = _NotificationContent([event.uuid]);

  // Status changes
  if (change.hasStatusChange) {
    if ((event.status.index == 4 || event.status.index == 5) &&
        change.statusBefore != event.status) {
      notification.addPart(
          title: "${event.subject.value!.naam.capitalized} komt te vervallen",
          body:
              "${event.subject.value!.naam.capitalized} op ${event.start.formattedDateWithoutYear} (${event.lesuurVan}e uur) komt te vervallen");
    } else if ((change.statusBefore!.index == 4 ||
            change.statusBefore!.index == 5) &&
        change.statusBefore != event.status) {
      notification.addPart(
          title:
              "${event.subject.value!.naam.capitalized} is weer ingeroosterd",
          body:
              "${event.subject.value!.naam.capitalized} op ${event.start.formattedDateWithoutYear} (${event.lesuurVan}e uur) is weer ingeroosterd");
    }
  }

  // InfoType changes
  if (change.hasInfoTypeChange && change.infoTypeBefore != event.infoType) {
    notification.addPart(
        title:
            "Lestype van ${event.subject.value!.naam.capitalized} op ${event.start.formattedDateWithoutYear} (${event.lesuurVan}e uur) is veranderd",
        body:
            "Lestype is veranderd van ${change.infoTypeBefore!.toName} naar ${event.infoType.toName}");
  }

  // Location changes
  if (change.hasLocationChange && change.locationBefore != event.lokatie) {
    notification.addPart(
        title:
            "Locatie van ${event.subject.value!.naam.capitalized} is gewijzigd",
        body:
            "Locatie is veranderd van ${change.locationBefore} naar ${event.lokatie}");
  }

  return notification;
}

Future<void> _createNotification(
    Profile profile, _NotificationContent content) async {
  if (content.isEmpty) return;

  await NotificationController.createNotification(NativeNotification(
      id: profile.uuid + 1,
      title: content.title,
      body: content.body,
      channel: NotificationChannel.calendar,
      payload: NotificationPayload(
        profile: profile,
        payload: {"event_uuids": content.uuids},
      )));
}

Future<void> scheduleReminders(Profile profile) async {
  // First we cancel all the previous schedules notifications
  List<PendingNotificationRequest> pending =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  await Future.wait([
    for (var e in pending.where(
      (e) =>
          e.payload != null &&
          e.payload!.isNotEmpty &&
          NotificationPayload.fromJson(e.payload!).channel ==
              NotificationChannel.reminders,
    ))
      flutterLocalNotificationsPlugin.cancel(e.id)
  ]);

  late List<Assignment> assignments;
  late List<Activity> activities;
  late List<CalendarEvent> events;

  List data = await Future.wait([
    // Get assignments
    profile.assignments
        .filter()
        .inleverenVoorGreaterThan(DateTime.now())
        .findAll(),
    // Get activities
    profile.activities
        .filter()
        .eindeInschrijfdatumGreaterThan(DateTime.now())
        .findAll(),
    // Get tests
    profile.calendarEvents
        .filter()
        .startGreaterThan(DateTime.now())
        .anyOf(
          InfoType.tests,
          (q, type) => q.infoTypeEqualTo(type),
        )
        .not()
        .group(
          (q) => q
              .statusEqualTo(Status.automaticallyCanceled)
              .or()
              .statusEqualTo(Status.manuallyCanceled),
        )
        .findAll()
  ]);

  assignments = data[0] as List<Assignment>;
  activities = data[1] as List<Activity>;
  events = data[2] as List<CalendarEvent>;

  Future<void> scheduleReminder(
    DateTime time, {
    required NativeNotification content,
  }) async {
    NotificationController.createNotification(content, time: time);
  }

  // Create assignments notifications
  await Future.wait([
    for (Assignment assignment in assignments)
      // For each assignment, create a reminder a day before the test at half
      // past four
      scheduleReminder(
        assignment.inleverenVoor.dayOnly
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 16, minutes: 30)),
        content: NativeNotification(
          id: 0,
          channel: NotificationChannel.reminders,
          title: "Morgen moet er een opdracht worden ingeleverd!",
          body:
              "Op ${assignment.inleverenVoor.formattedDateWithoutYear} moet de opdracht \"${assignment.titel}\" worden ingeleverd.",
        ),
      )
  ]);

  // Create activities notifications
  await Future.wait([
    for (Activity activity in activities) ...[
      // For each activity, create a reminder that runs a two days before, one
      // day before and an hour before.
      scheduleReminder(
        activity.eindeInschrijfdatum.dayOnly
            .subtract(const Duration(days: 2))
            .add(const Duration(hours: 16, minutes: 30)),
        content: NativeNotification(
          id: activity.uuid,
          channel: NotificationChannel.reminders,
          title: "Vergeet je niet in te schrijven!",
          body:
              "Op ${activity.eindeInschrijfdatum.formattedDateAndTimWithoutYear} sluit de inschrijving voor ${activity.titel}",
        ),
      ),
      scheduleReminder(
        activity.eindeInschrijfdatum.dayOnly
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 16, minutes: 30)),
        content: NativeNotification(
          id: activity.uuid,
          channel: NotificationChannel.reminders,
          title: "Vergeet je niet in te schrijven!",
          body:
              "Op ${activity.eindeInschrijfdatum.formattedDateAndTimWithoutYear} sluit de inschrijving voor ${activity.titel}",
        ),
      ),
      scheduleReminder(
        activity.eindeInschrijfdatum.subtract(const Duration(hours: 1)),
        content: NativeNotification(
          id: activity.uuid,
          channel: NotificationChannel.reminders,
          title: "Vergeet je niet in te schrijven!",
          body:
              "Op ${activity.eindeInschrijfdatum.formattedDateAndTimWithoutYear} sluit de inschrijving voor ${activity.titel}",
        ),
      ),
      // If the ending time is at midnight, also create a reminder at eight o'clock.
      if (activity.eindeInschrijfdatum.hour == 0 ||
          activity.eindeInschrijfdatum.hour == 23)
        scheduleReminder(
          activity.eindeInschrijfdatum.dayOnly.add(const Duration(hours: 20)),
          content: NativeNotification(
            id: activity.uuid,
            channel: NotificationChannel.reminders,
            title: "Vergeet je niet in te schrijven!",
            body:
                "Op ${activity.eindeInschrijfdatum.formattedDateAndTimWithoutYear} sluit de inschrijving voor ${activity.titel}",
          ),
        )
    ]
  ]);

  // Create assignments notifications
  await Future.wait([
    for (List<CalendarEvent> events in events.splitPerWeek)
      // The reminders are scheduled for the saturday morning before the week
      // that the test is in.
      scheduleReminder(
        events.first.start.dayOnly
            .subtract(Duration(days: (events.first.start.weekday + 1) % 7))
            .add(const Duration(hours: 9)),
        content: NativeNotification(
          id: events.first.start.weekNumber + events.first.start.year,
          channel: NotificationChannel.reminders,
          title: events.length == 1
              ? "Je hebt volgende week één toets"
              : "Je hebt volgende week ${events.length} toets(en)",
          body: events.length == 1
              ? "Je hebt een toets op ${events.first.start.dayName} van ${events.first.subject.value?.naam.capitalized ?? events.first.title}"
              : "Je hebt toetsen van ${events.map((e) => e.subject.value?.naam).nonNulls.toSet().formattedJoin} op ${events.map((e) => e.start.dayName).nonNulls.toSet().formattedJoin}",
        ),
      ),
    for (CalendarEvent event in events)
      // For each event, create a reminder of the start date.
      // Another reminder is for 16:30 the night before the
      // test.

      scheduleReminder(
        event.start.dayOnly
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 16, minutes: 30)),
        content: NativeNotification(
          id: event.uuid,
          channel: NotificationChannel.reminders,
          title: "Vergeet je toets morgen niet!",
          body:
              "Morgen heb je een toets ${event.subject.value?.naam.capitalized ?? event.title} ${event.lesuurVan != null ? "het ${event.lesuurVan}e uur" : "om ${event.start.formattedTime}"}.",
        ),
      )
  ]);
}
