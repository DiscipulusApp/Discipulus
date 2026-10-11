import 'dart:async';
import 'dart:io';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/live_activity.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:live_activities/live_activities.dart';

/// The live activities work on both iOS and Android and adhere to the following rules
/// and design standards: 
/// 
/// The pill/dynamic island (collapsed view)
/// 
/// We are limited to an icon and some text, with on iOS one more place to put text as the 
/// dynamic island has two sides :)
/// These are used to show the most important information for glancing, which is the location
/// for most people. The subject is deliberatly not shown as this takes up space that is in the 
/// moment less important. Pressing the activity shows the full lesson though. 
/// 
/// --- This is overengineerd to death. ---
///
/// Slots:
/// - iOS:     [Icon] [Location] | ISLAND | [Countdown]
/// - Android: [Icon] [Single Slot: Location OR Countdown]
///
/// Thresholds:
/// - "Directly after" = Next event starts <= 5 min after current event ends.
/// - End Transition Window = max(current.duration * 0.10, min(5 min, current.duration * 0.25)).
/// - Start "Late" Window   = current.duration * 0.10.
///
/// States:
/// 1. PRE-EVENT (30m to 5m before start)
///    - iOS:     [Nav Icon] [Next Room] | ISLAND | [Time to start]
///    - Android: Hidden
///
/// 2. IMMINENT (5m to 0m before start)
///    - iOS:     [Nav Icon] [Next Room] | ISLAND | [Time to start]
///    - Android: [Nav Icon] [Next Room]
///
/// 3. LESSON START / LATE WINDOW (Start to +10%)
///    - iOS:     [Disci Icon] [Current Room] | ISLAND | [Time left in lesson]
///    - Android: [Disci Icon] [Current Room]
///
/// 4. LESSON MID-PERIOD (+10% to End Window)
///    - iOS:     [Disci Icon] [Current Room] | ISLAND | [Time left in lesson]
///    - Android: [Disci Icon] [Time left in lesson]
///
/// 5. LESSON END WINDOW (Final 10% / ~5m)
///    - If NEXT lesson is directly after:
///      - iOS:     [Nav Icon] [Next Room] | ISLAND | [Time until next lesson starts]
///      - Android: [Nav Icon] [Next Room]
///    - If NO next lesson (or long break):
///      - iOS:     [Disci Icon] [Current Room] | ISLAND | [Time left in lesson]
///      - Android: [Disci Icon] [Time left in lesson]
///
/// 6. DISMISSAL
///    - Dismiss immediately at end of day
///    - If entering a long break (>15m), dismiss on Android; keep on iOS if <= 30m until next.

class LiveActivityService {
  static final LiveActivityService _instance = LiveActivityService._internal();
  factory LiveActivityService() => _instance;
  LiveActivityService._internal();

  final LiveActivities _liveActivities = LiveActivities();
  String? _currentActivityId;
  bool _initialized = false;
  bool _isUpdating = false;
  Timer? _scheduleTimer;

  static const String appGroupId = 'group.DUGUWCFH8P.dev.harrydekat.discipulus';
  static const String urlScheme = 'discipulus';

  static Duration computeEndTransitionWindow(Duration duration) {
    final tenPercent = Duration(milliseconds: (duration.inMilliseconds * 0.10).round());
    final twentyFivePercent = Duration(milliseconds: (duration.inMilliseconds * 0.25).round());
    const fiveMin = Duration(minutes: 5);
    final minFiveOr25 = fiveMin < twentyFivePercent ? fiveMin : twentyFivePercent;
    return tenPercent > minFiveOr25 ? tenPercent : minFiveOr25;
  }

  static Duration computeStartLateWindow(Duration duration) {
    return Duration(milliseconds: (duration.inMilliseconds * 0.10).round());
  }

  Future<void> init() async {
    if (!Platform.isIOS && !Platform.isAndroid) return;
    if (_initialized) return;

    try {
      await _liveActivities.init(
        appGroupId: appGroupId,
        urlScheme: urlScheme,
        requestAndroidNotificationPermission: false,
      );
      _initialized = true;
      if (Platform.isIOS) {
        final supported = await _liveActivities.areActivitiesSupported();
        debugPrint("Live activities supported on this device: $supported");
      }
    } catch (e) {
      debugPrint("Failed to initialize LiveActivityService: $e");
    }
  }

  String? get currentActivityId => _currentActivityId;

  Future<bool> areActivitiesSupported() async {
    if (!Platform.isIOS && !Platform.isAndroid) return false;
    await init();
    if (Platform.isIOS) {
      try {
        return await _liveActivities.areActivitiesSupported();
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  Future<List<String>> getActiveActivityIds() async {
    if (!Platform.isIOS && !Platform.isAndroid) return [];
    await init();
    try {
      return await _liveActivities.getAllActivitiesIds();
    } catch (_) {
      return [];
    }
  }

  Future<String?> _syncActivity(
    LiveActivityData activityData, {
    Duration? staleIn,
  }) async {
    const activityId = 'current_lesson';

    try {
      if (_currentActivityId == null) {
        final existingIds = await _liveActivities.getAllActivitiesIds();
        if (existingIds.isNotEmpty) {
          _currentActivityId = existingIds.first;
        }
      }

      if (_currentActivityId != null) {
        await _liveActivities.updateActivity(
          _currentActivityId!,
          activityData.toJson(),
        );
      } else {
        _currentActivityId = await _liveActivities.createActivity(
          activityId,
          activityData.toJson(),
          removeWhenAppIsKilled: false,
          iOSEnableRemoteUpdates: false,
          staleIn: staleIn,
        );
      }
      return _currentActivityId;
    } catch (e) {
      debugPrint("LiveActivity sync failed, attempting re-creation: $e");
      try {
        _currentActivityId = await _liveActivities.createActivity(
          activityId,
          activityData.toJson(),
          removeWhenAppIsKilled: false,
          iOSEnableRemoteUpdates: false,
          staleIn: staleIn,
        );
        return _currentActivityId;
      } catch (inner) {
        debugPrint("Error creating live activity: $inner");
        return null;
      }
    }
  }

  Future<String?> pushActivityData(
    LiveActivityData activityData, {
    Duration? staleIn,
  }) async {
    if (!Platform.isIOS && !Platform.isAndroid) return null;
    await init();
    _scheduleTimer?.cancel();
    _scheduleTimer = null;

    // Android specification: Pre-Event is HIDDEN (> 5m before start).
    if (Platform.isAndroid && !activityData.isOngoing && activityData.nextStartTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diffMs = activityData.nextStartTime! - now;
      if (diffMs > const Duration(minutes: 5).inMilliseconds) {
        await endAllActivities();
        return null;
      }
    }

    return await _syncActivity(activityData, staleIn: staleIn);
  }

  Future<void> endAllActivities() async {
    if (!Platform.isIOS && !Platform.isAndroid) return;
    try {
      _scheduleTimer?.cancel();
      _scheduleTimer = null;
      _currentActivityId = null;
      await _liveActivities.endAllActivities();
    } catch (e) {
      debugPrint("Failed to end live activities: $e");
    }
  }

  Future<void> update({Profile? targetProfile}) async {
    if (!Platform.isIOS && !Platform.isAndroid) return;
    if (_isUpdating) return;
    _isUpdating = true;

    try {
      await init();

      final profile = targetProfile ?? activeProfileNullable;
      if (profile == null || !appSettings.useLiveActivities) {
        await endAllActivities();
        return;
      }

      if (!await _liveActivities.areActivitiesEnabled()) {
        if (_currentActivityId != null) {
          await endAllActivities();
        }
        return;
      }

      final now = DateTime.now();
      final startOfDay = now.dayOnly;
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final events = await profile.calendarEvents
          .filter()
          .duurtHeleDagEqualTo(false)
          .eindeGreaterThan(now.subtract(const Duration(minutes: 30)))
          .startLessThan(endOfDay)
          .sortByStart()
          .findAll();

      final validEvents = events.where((e) => !e.isCanceled).toList();
      final combined = validEvents.combineEvents();

      List<CalendarEvent>? currentBlock;
      int currentIndex = -1;

      for (int i = 0; i < combined.length; i++) {
        final block = combined[i];
        if (!now.isBefore(block.first.start) && now.isBefore(block.last.einde)) {
          currentBlock = block;
          currentIndex = i;
          break;
        }
      }

      LiveActivityData? activityData;
      DateTime? nextWakeUpTime;

      if (currentBlock != null) {
        // CURRENTLY INSIDE A LESSON
        final lessonStart = currentBlock.first.start;
        final lessonEnd = currentBlock.last.einde;
        final duration = lessonEnd.difference(lessonStart);

        final tenPercent = computeStartLateWindow(duration);
        final endTransitionWindow = computeEndTransitionWindow(duration);

        final startLateThreshold = lessonStart.add(tenPercent);
        final endTransitionThreshold = lessonEnd.subtract(endTransitionWindow);

        final isLastLesson = currentIndex + 1 >= combined.length;
        final nextBlock = !isLastLesson ? combined[currentIndex + 1] : null;

        String nextTitle = '';
        String nextRoom = '';
        int? nextStartTime;
        bool nextDirectlyAfter = false;
        String afterText = '';

        if (isLastLesson || nextBlock == null) {
          afterText = 'Hierna: Vrij! 🎉';
        } else {
          final nextEvent = nextBlock.first;
          final gap = nextEvent.start.difference(lessonEnd);
          nextDirectlyAfter = gap <= const Duration(minutes: 5);
          nextTitle = nextEvent.subject.value?.naam.capitalized ?? nextEvent.title;
          nextRoom = nextEvent.lokatie ?? '';
          nextStartTime = nextEvent.start.millisecondsSinceEpoch;
          final nextRoomStr = nextRoom.isNotEmpty ? ' ($nextRoom)' : '';

          if (gap > const Duration(minutes: 5)) {
            afterText = 'Hierna: Pauze (${gap.inMinutes}m) ➔ $nextTitle$nextRoomStr';
          } else {
            afterText = 'Hierna: $nextTitle$nextRoomStr';
          }
        }

        final currentEvent = currentBlock.first;
        final title = currentEvent.subject.value?.naam.capitalized ?? currentEvent.title;
        final room = currentEvent.lokatie ?? '';

        String hourIndicator = '';
        if (currentEvent.lesuurVan != null) {
          final startHour = currentEvent.lesuurVan!;
          final endHour = currentBlock.last.lesuurTotMet ?? currentBlock.last.lesuurVan;
          if (endHour != null && endHour != startHour) {
            hourIndicator = '${startHour}e - ${endHour}e uur';
          } else {
            hourIndicator = '${startHour}e uur';
          }
        }

        activityData = LiveActivityData(
          title: title,
          room: room,
          hourIndicator: hourIndicator,
          startTime: lessonStart.millisecondsSinceEpoch,
          endTime: lessonEnd.millisecondsSinceEpoch,
          nextTitle: nextTitle,
          nextRoom: nextRoom,
          nextStartTime: nextStartTime,
          afterText: afterText,
          isOngoing: true,
          isLastLesson: isLastLesson,
          nextDirectlyAfter: nextDirectlyAfter,
          startLateThreshold: startLateThreshold.millisecondsSinceEpoch,
          endTransitionThreshold: endTransitionThreshold.millisecondsSinceEpoch,
        );

        if (now.isBefore(startLateThreshold)) {
          nextWakeUpTime = startLateThreshold;
        } else if (now.isBefore(endTransitionThreshold)) {
          nextWakeUpTime = endTransitionThreshold;
        } else {
          nextWakeUpTime = lessonEnd;
        }
      } else {
        // NOT CURRENTLY INSIDE A LESSON: CHECK FOR UPCOMING LESSON
        List<CalendarEvent>? upcomingBlock;
        int upcomingIndex = -1;

        for (int i = 0; i < combined.length; i++) {
          if (combined[i].first.start.isAfter(now)) {
            upcomingBlock = combined[i];
            upcomingIndex = i;
            break;
          }
        }

        if (upcomingBlock == null) {
          await endAllActivities();
          return;
        }

        final upcomingStart = upcomingBlock.first.start;
        final diff = upcomingStart.difference(now);

        // Check long break dismissal rule:
        // If entering a long break (>15m), dismiss on Android; keep on iOS if <= 30m until next.
        bool isBreakAfterPrevious = false;
        if (upcomingIndex > 0 && now.isAfter(combined[upcomingIndex - 1].last.einde)) {
          isBreakAfterPrevious = true;
        }

        // Platform visibility evaluation:
        // State 1: PRE-EVENT (30m to 5m before start): iOS active, Android hidden.
        // If long break (>15m): Android hidden until 5m before start.
        if (diff > const Duration(minutes: 30)) {
          // Outside the 30m window: hide on both platforms
          await endAllActivities();
          _scheduleTimer?.cancel();
          final targetWakeUp = Platform.isAndroid
              ? upcomingStart.subtract(const Duration(minutes: 5))
              : upcomingStart.subtract(const Duration(minutes: 30));
          final wakeDiff = targetWakeUp.difference(now);
          if (!wakeDiff.isNegative && wakeDiff.inSeconds > 0) {
            _scheduleTimer = Timer(wakeDiff + const Duration(seconds: 1), () => update(targetProfile: profile));
          }
          return;
        } else if (Platform.isAndroid && diff > const Duration(minutes: 5)) {
          // Android is hidden during Pre-Event (> 5m before start) or during long breaks
          await endAllActivities();
          _scheduleTimer?.cancel();
          final targetWakeUp = upcomingStart.subtract(const Duration(minutes: 5));
          final wakeDiff = targetWakeUp.difference(now);
          if (!wakeDiff.isNegative && wakeDiff.inSeconds > 0) {
            _scheduleTimer = Timer(wakeDiff + const Duration(seconds: 1), () => update(targetProfile: profile));
          }
          return;
        }

        // We are either on iOS (within 30m) or on Android (within 5m):
        final upcomingEvent = upcomingBlock.first;
        final upcomingSubject = upcomingEvent.subject.value?.naam.capitalized ?? upcomingEvent.title;
        final upcomingRoom = upcomingEvent.lokatie ?? '';
        final upcomingRoomStr = upcomingRoom.isNotEmpty ? ' ($upcomingRoom)' : '';

        String upcomingHourIndicator = '';
        if (upcomingEvent.lesuurVan != null) {
          final startHour = upcomingEvent.lesuurVan!;
          final endHour = upcomingBlock.last.lesuurTotMet ?? upcomingBlock.last.lesuurVan;
          if (endHour != null && endHour != startHour) {
            upcomingHourIndicator = '${startHour}e - ${endHour}e uur';
          } else {
            upcomingHourIndicator = '${startHour}e uur';
          }
        }

        String title;
        String afterText;
        int startEpoch;

        // Only show "Pauze" if in an actual break window (>5m before next lesson).
        // If within 5m of next lesson (Imminent state), the upcoming lesson is the subject.
        if (isBreakAfterPrevious && diff > const Duration(minutes: 5)) {
          final prevLesson = combined[upcomingIndex - 1];
          title = 'Pauze';
          startEpoch = prevLesson.last.einde.millisecondsSinceEpoch;
          afterText = 'Hierna: $upcomingSubject$upcomingRoomStr';
        } else {
          title = upcomingSubject;
          startEpoch = now.millisecondsSinceEpoch;
          afterText = 'Begint om ${DateFormat('HH:mm').format(upcomingStart)}';
        }

        activityData = LiveActivityData(
          title: title,
          room: upcomingRoom,
          hourIndicator: upcomingHourIndicator,
          startTime: startEpoch,
          endTime: upcomingStart.millisecondsSinceEpoch,
          nextTitle: upcomingSubject,
          nextRoom: upcomingRoom,
          nextStartTime: upcomingStart.millisecondsSinceEpoch,
          afterText: afterText,
          isOngoing: false,
          isLastLesson: false,
          nextDirectlyAfter: true,
          startLateThreshold: upcomingStart.millisecondsSinceEpoch,
          endTransitionThreshold: upcomingStart.millisecondsSinceEpoch,
        );

        if (Platform.isIOS && diff > const Duration(minutes: 5)) {
          // iOS pre-event transition to imminent state at 5m
          nextWakeUpTime = upcomingStart.subtract(const Duration(minutes: 5));
        } else {
          nextWakeUpTime = upcomingStart;
        }
      }

      // On iOS, the TimelineView autonomously handles state transitions.
      // Setting staleIn to an intermediate milestone tick prematurely marks the activity as stale
      // when the app is suspended. Instead, allow staleIn to cover the entire lesson/block plus a buffer.
      Duration? staleIn;
      if (activityData.isOngoing) {
        final lessonEndDiff = DateTime.fromMillisecondsSinceEpoch(activityData.endTime).difference(now);
        staleIn = lessonEndDiff.isNegative ? null : lessonEndDiff + const Duration(minutes: 15);
      } else if (activityData.nextStartTime != null) {
        final startDiff = DateTime.fromMillisecondsSinceEpoch(activityData.nextStartTime!).difference(now);
        staleIn = startDiff.isNegative ? null : startDiff + const Duration(minutes: 10);
      }

      await _syncActivity(activityData, staleIn: staleIn);

      // Schedule next update at milestone transition
      _scheduleTimer?.cancel();
      final timeUntilNext = nextWakeUpTime.difference(now);
      if (timeUntilNext.inSeconds > 0) {
        _scheduleTimer = Timer(timeUntilNext + const Duration(seconds: 1), () {
          update(targetProfile: profile);
        });
      }
    } finally {
      _isUpdating = false;
    }
  }
}
