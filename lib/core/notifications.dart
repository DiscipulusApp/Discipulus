import 'dart:convert';
import 'dart:io';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
import 'package:discipulus/screens/grades/grade_detail.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:share_handler/share_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationPayload {
  Profile? profile;
  late NotificationChannel channel;
  Map<String, dynamic> payload;

  NotificationPayload({
    this.profile,
    this.payload = const {},
  });

  String toJson() => jsonEncode({
        "profile": profile?.uuid,
        "channel": channel.name,
        "payload": payload,
      });

  factory NotificationPayload.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return NotificationPayload(
      profile:
          map["profile"] != null ? isar.profiles.getSync(map["profile"]) : null,
      payload: map["payload"],
    )..channel = NotificationChannel.values.byName(map["channel"]);
  }
}

enum NotificationChannel { calendar, grades, messages, reminders }

class NotificationChannelDetails {
  final String channelKey;
  final String channelName;
  final String channelDescription;

  NotificationChannelDetails({
    required this.channelKey,
    required this.channelName,
    required this.channelDescription,
  });
}

extension on NotificationChannel {
  NotificationChannelDetails get channelDetails {
    Map<NotificationChannel, NotificationChannelDetails> channels = {
      NotificationChannel.calendar: NotificationChannelDetails(
        channelKey: "discipulus-events",
        channelName: "Kalender",
        channelDescription: "Krijg berichten met betrekking to je kalender",
      ),
      NotificationChannel.grades: NotificationChannelDetails(
        channelKey: "discipulus-grades",
        channelName: "Cijfers",
        channelDescription: "Krijg berichten met betrekking to je cijfers",
      ),
      NotificationChannel.messages: NotificationChannelDetails(
        channelKey: "discipulus-messages",
        channelName: "Berichten",
        channelDescription: "Krijg berichten met betrekking to je berichten",
      ),
      NotificationChannel.reminders: NotificationChannelDetails(
        channelKey: "discipulus-reminders",
        channelName: "Reminders",
        channelDescription: "Reminders van toetsen, activiteiten en opdrachten",
      )
    };
    return channels[this]!;
  }
}

class NativeNotification {
  int id;
  String title;
  String body;
  NotificationChannel channel;
  NotificationPayload? payload;

  NativeNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.channel,
    this.payload,
  });
}

class NotificationController {
  static Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('discipulus_notification_icon'),
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          NotificationController.onActionReceivedMethod,
      onDidReceiveBackgroundNotificationResponse:
          NotificationController.onActionReceivedMethod,
    );
  }

  static Future<bool> get isAllowed async {
    if (Platform.isAndroid) {
      // Check android
      return (await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .areNotificationsEnabled()) ??
          false;
    } else if (Platform.isIOS) {
      // Check iOS
      return (await flutterLocalNotificationsPlugin
                  .resolvePlatformSpecificImplementation<
                      IOSFlutterLocalNotificationsPlugin>()!
                  .checkPermissions())
              ?.isEnabled ??
          false;
    } else if (Platform.isMacOS) {
      // Check macOS
      return (await flutterLocalNotificationsPlugin
                  .resolvePlatformSpecificImplementation<
                      MacOSFlutterLocalNotificationsPlugin>()!
                  .checkPermissions())
              ?.isEnabled ??
          false;
    } else {
      // Other is not supported
      return false;
    }
  }

  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Request android
      return (await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .requestNotificationsPermission()) ??
          false;
    } else if (Platform.isIOS) {
      // Request iOS
      return (await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()!
              .requestPermissions()) ??
          false;
    } else {
      // Other is not supported
      return false;
    }
  }

  static Future<void> createNotification(
    NativeNotification content, {
    DateTime? time,
  }) async {
    if (time != null && DateTime.now().isAfter(time)) {
      return;
    }

    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        content.channel.channelDetails.channelKey,
        content.channel.channelDetails.channelName,
        channelDescription: content.channel.channelDetails.channelDescription,
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: content.channel.name,
      ),
    );

    NotificationPayload? payload = content.payload?..channel = content.channel;

    if (time == null) {
      await flutterLocalNotificationsPlugin.show(
        content.id,
        content.title,
        content.body,
        payload: payload?.toJson(),
        details,
      );
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        content.id,
        content.title,
        content.body,
        tz.TZDateTime.fromMillisecondsSinceEpoch(
          tz.UTC,
          time.toUtc().millisecondsSinceEpoch,
        ),
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload?.toJson(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    NotificationResponse receivedAction,
  ) async {
    NotificationPayload payload =
        NotificationPayload.fromJson(receivedAction.payload!);

    switch (payload.channel) {
      case NotificationChannel.grades:
        // Grade notification was pressed.

        // Switch to the correct account
        activeProfile = payload.profile ?? activeProfile;

        // Navigate to correct screen
        Layout.of(navKey.currentContext!)?.goToPage(const GradesListScreen(
          key: ValueKey("ALLOWED_ROOT"),
        ));

        if (payload.payload.values.length == 1) {
          Grade grade = (await isar.grades
              .filter()
              .idEqualTo(int.parse(payload.payload.values.first!.first))
              .findFirst())!;

          // One grade was received, so we can display the bottom sheet.
          Layout.of(navKey.currentContext!)?.goToPage(
            const GradesListScreen(),
            makeFirst: false,
          );
          showGradeDetailSheet(
            navKey.currentContext!,
            GradeInformation(grade: grade),
          );
        }

        break;
      case NotificationChannel.calendar:
        // Calendar notification was pressed.

        // Switch to the correct account
        activeProfile = payload.profile ?? activeProfile;

        if (payload.payload["event_uuids"].length == 1) {
          CalendarEvent event = (await isar.calendarEvents
              .filter()
              .uuidEqualTo(payload.payload["event_uuids"].first)
              .findFirst())!;

          Layout.of(navKey.currentContext!)?.goToPage(CalendarDayView(
            key: const ValueKey("ALLOWED_ROOT"),
            displayedDay: event.start.dayOnly,
          ));
        } else {
          Layout.of(navKey.currentContext!)?.goToPage(const CalendarDayView(
            key: ValueKey("ALLOWED_ROOT"),
          ));
        }

        break;
      default:
    }
  }
}

class Intents {
  static uniLinkListener(Uri uri) async {
    if (uri.hasScheme && uri.scheme == "discipulus") {
      if (uri.host == "calendar") {
        // Handle calendar related deeplinks
        int? personId = int.tryParse(uri.queryParameters["profileId"] ?? "");
        int? calendarId = int.tryParse(uri.queryParameters["eventId"] ?? "");
        Profile? profile =
            await isar.profiles.filter().idEqualTo(personId ?? -1).findFirst();

        if (profile != null && calendarId != null) {
          // Try to find the correct event
          CalendarEvent? event = await profile.calendarEvents
              .filter()
              .idEqualTo(calendarId)
              .findFirst();

          // If the event does not exist we will try to fetch it using the
          // id
          if (event == null) {
            CalendarEvent? newEvent = await profile.account.value?.api
                .person(personId!)
                .calendarEvent(calendarId);
            if (newEvent != null) {
              profile.processCalendarEvent(
                  DateTimeRange(start: newEvent.start, end: newEvent.einde),
                  newEvent);
              isar.writeTxnSync(() async {
                newEvent.subject.saveSync();
                isar.calendarEvents.putSync(newEvent);
              });
              event = newEvent;
            }
          }

          if (event != null) {
            activeProfile = profile;
            CalendarDayView(displayedDay: event.start).push(null);
            showCalendarEventDetailsSheet(
              navKey.currentContext!,
              events: [event],
            );
          }
        }
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      final handler = ShareHandlerPlatform.instance;
      SharedMedia? media = await handler.getInitialSharedMedia();

      handler.sharedMediaStream.listen((SharedMedia media) {
        if (!navKey.currentContext!.mounted) {
          return;
        }
        media.launchMessageSheet();
      });

      // Initial app start
      if (!navKey.currentContext!.mounted) return;

      await media.launchMessageSheet();
    }
  }
}

extension on SharedMedia? {
  Future<void> launchMessageSheet() async {
    Uri? uri = Uri.tryParse(this?.content ?? "");

    bool hasAttachments = this?.attachments?.isNotEmpty ?? false;
    bool hasText = this?.content?.isNotEmpty ?? false;

    if (await isar.profiles.where().count() == 0) return;

    if (this != null &&
        (hasAttachments || hasText) &&
        (uri == null || !["discipulus", "m6loapp"].contains(uri.scheme))) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) =>
            showComposeMessageSheet(navKey.currentContext!, sharedMedia: this),
      );
    }
  }
}
