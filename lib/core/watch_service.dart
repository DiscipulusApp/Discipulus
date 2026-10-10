import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/settings/pages/wear_os_setup.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WatchService with WidgetsBindingObserver {
  static final WatchService _instance = WatchService._internal();
  factory WatchService() => _instance;

  /// Notifier to notify active calendar screens whenever an event is updated by the watch
  static final ValueNotifier<int> calendarRefreshNotifier =
      ValueNotifier<int>(0);

  final _watch = WatchConnectivity();
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  bool _initialized = false;

  Map<String, dynamic>? _lastScheduleData;
  List<Map<String, dynamic>>? _lastGradesData;
  DateTime? _lastSyncAttempt;
  Future<void>? _syncInFlight;

  WatchService._internal();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncAll();
    }
  }

  void init() {
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addObserver(this);

    _messageSubscription = _watch.messageStream.listen((message) {
      final command = message['command'] ?? message['type'];
      if (command == 'open_watch_setup' ||
          command == 'request_tokenset_login') {
        final context = navKey.currentContext;
        if (context != null && context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const WearOSSetupScreen(),
            ),
          );
        }
        return;
      }

      if (command == 'toggle_event') {
        final id = (message['id'] as num?)?.toInt();
        final completed =
            (message['completed'] ?? message['isCompleted']) as bool?;
        if (id != null) {
          unawaited(_handleToggleEvent(id, completed));
        }
        return;
      }

      if (activeProfileNullable == null) return;
      if (command == 'get_schedule') {
        unawaited(_sendSchedule());
      } else if (command == 'get_grades') {
        unawaited(_sendRecentGrades());
      }
    });

    // Initial sync
    unawaited(_syncAll(force: true));
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageSubscription?.cancel();
    _messageSubscription = null;
    _initialized = false;
    _lastScheduleData = null;
    _lastGradesData = null;
    _lastSyncAttempt = null;
    _syncInFlight = null;
  }

  Future<void> syncAll({bool force = true}) => _syncAll(force: force);

  Future<void> _syncAll({bool force = false}) {
    return _syncInFlight ??= _doSync(force: force).whenComplete(() {
      _syncInFlight = null;
    });
  }

  Future<void> _doSync({bool force = false}) async {
    final profile = activeProfileNullable;
    if (profile == null) return;

    final now = DateTime.now();
    if (!force &&
        _lastSyncAttempt != null &&
        now.difference(_lastSyncAttempt!) < const Duration(minutes: 5)) {
      return;
    }

    try {
      final isSupported = await _watch.isSupported;
      if (!isSupported) return;
      final isPaired = await _watch.isPaired;
      if (!isPaired) return;
    } catch (e) {
      debugPrint("Watch platform check failed: $e");
    }

    _lastSyncAttempt = now;

    try {
      await Future.wait([
        _sendSchedule(targetProfile: profile, updateContext: false),
        _sendRecentGrades(targetProfile: profile, updateContext: false),
      ]);
      await _updateCombinedApplicationContext();
      _updateSyncTime();
    } catch (e) {
      debugPrint("Error in WatchService._syncAll: $e");
    }
  }

  Future<void> _updateCombinedApplicationContext() async {
    if (_lastScheduleData == null && _lastGradesData == null) return;
    final contextPayload = _sanitizeForPropertyList({
      'type': 'sync',
      if (_lastScheduleData != null) 'schedule': _lastScheduleData,
      if (_lastGradesData != null) 'grades': _lastGradesData,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }) as Map<String, dynamic>;

    try {
      await _watch.updateApplicationContext(contextPayload);
    } catch (e) {
      debugPrint("Error updating application context with combined data: $e");
    }
  }

  Future<Profile?> _getTargetProfile(Profile baseProfile) async {
    final profileUUID =
        appSettings.activeProfileUuidWidgets ?? baseProfile.uuid;
    if (profileUUID == baseProfile.uuid) return baseProfile;

    return await isar.profiles
            .filter()
            .uuidEqualTo(profileUUID)
            .findFirst() ??
        baseProfile;
  }

  Future<List<CalendarEvent>> _fetchEventsForProfile(
    Profile profile,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    return profile.calendarEvents
        .filter()
        .group((q) => q
            .startGreaterThan(rangeStart, include: true)
            .and()
            .startLessThan(rangeEnd, include: true))
        .or()
        .group((q) => q
            .duurtHeleDagEqualTo(true)
            .startLessThan(rangeEnd)
            .eindeGreaterThan(rangeStart))
        .sortByStart()
        .findAll();
  }

  Future<List<CalendarEvent>> _getScheduleEvents(
    Profile target,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) async {
    List<CalendarEvent> events =
        await _fetchEventsForProfile(target, rangeStart, rangeEnd);

    // If local cache is empty, fetch fresh events from Magister
    if (events.isEmpty) {
      try {
        await target
            .getEvents(DateTimeRange(start: rangeStart, end: rangeEnd));
        events = await _fetchEventsForProfile(target, rangeStart, rangeEnd);
      } catch (e) {
        debugPrint("Failed to fetch fresh events for watch: $e");
      }
    }

    return events;
  }

  Map<String, dynamic>? _customPropsToMap(CustomCalendarProperties? customProps) {
    if (customProps == null) return null;
    return {
      'Status': customProps.rawStatus,
      'originalStatus': customProps.rawStatusOriginal,
      'dateStatus': customProps.statusChanged?.toIso8601String(),
      'InfoType': customProps.rawInfotype,
      'originalInfoType': customProps.rawInfotypeOriginal,
      'dateInfoType': customProps.infotypeChanged?.toIso8601String(),
      'Lokatie': customProps.lokatie,
      'originalLokatie': customProps.lokatieOriginal,
      'dateLokatie': customProps.lokatieChanged?.toIso8601String(),
      'Inhoud': customProps.inhoud,
      'originalInhoud': customProps.inhoudOriginal,
      'dateInhoud': customProps.inhoudChanged?.toIso8601String(),
    };
  }

  Map<String, dynamic> _eventToMap(
    List<CalendarEvent> group, {
    required bool stripHtmlForWatchOS,
  }) {
    final first = group.first;
    final last = group.last;
    final customProps = group
            .map((ev) => ev.customCalendarProperties)
            .firstWhereOrNull((p) => p != null) ??
        first.customCalendarProperties;

    final teacherString = stripHtmlForWatchOS
        ? ""
        : (first.docenten
                ?.map((d) => d.naam ?? d.docentcode ?? "")
                .where((s) => s.isNotEmpty)
                .join(", ") ??
            "");

    final descriptionString = stripHtmlForWatchOS
        ? ""
        : (first.inhoud ?? first.omschrijving ?? "");

    return {
      'id': first.id,
      'name': first.title,
      'shortName': first.subject.value?.afkorting,
      'location': first.lokatie ?? "",
      'description': descriptionString,
      'teacher': teacherString,
      'startHourIndicator': first.lesuurVan,
      'endHourIndicator': last.lesuurTotMet,
      'lesuurVan': first.lesuurVan,
      'lesuurTotMet': last.lesuurTotMet,
      'infoType': first.infoType.index,
      'status': first.status.index,
      'startTime': first.start.millisecondsSinceEpoch,
      'endTime': last.einde.millisecondsSinceEpoch,
      'isCompleted': first.afgerond,
      'isCanceled': first.isCanceled,
      'customCalendarProperties': _customPropsToMap(customProps),
    };
  }

  Future<void> _sendSchedule({
    Profile? targetProfile,
    bool updateContext = true,
  }) async {
    final baseProfile = targetProfile ?? activeProfileNullable;
    if (baseProfile == null) return;

    try {
      final target = await _getTargetProfile(baseProfile) ?? baseProfile;

      final now = DateTime.now();
      final rangeStart = DateTime(now.year, now.month, now.day - 1);
      final rangeEnd = DateTime(now.year, now.month, now.day + 15);

      final events =
          await _getScheduleEvents(target, rangeStart, rangeEnd);

      final rawGrouped = groupBy(events, (e) => e.start.dayOnly);
      final stripHtml = Platform.isIOS;

      final Map<String, List<Map<String, dynamic>>> data = {};
      for (final entry in rawGrouped.entries) {
        final dateKey = DateFormat('yyyy-MM-dd').format(entry.key);
        data[dateKey] = entry.value
            .combineEvents()
            .map((group) => _eventToMap(group, stripHtmlForWatchOS: stripHtml))
            .toList();
      }

      _lastScheduleData = data;

      final payload = _sanitizeForPropertyList({
        'type': 'schedule',
        'data': data,
      }) as Map<String, dynamic>;

      try {
        await _watch.sendMessage(payload);
      } catch (e) {
        debugPrint("Error sending schedule via sendMessage: $e");
      }

      if (updateContext) {
        await _updateCombinedApplicationContext();
        _updateSyncTime();
      }
    } catch (e, stack) {
      debugPrint("Error in _sendSchedule: $e\n$stack");
    }
  }

  Future<void> _sendRecentGrades({
    Profile? targetProfile,
    bool updateContext = true,
  }) async {
    final baseProfile = targetProfile ?? activeProfileNullable;
    if (baseProfile == null) return;

    try {
      final profile = await _getTargetProfile(baseProfile) ?? baseProfile;

      final schoolyears = await profile.schoolyears
          .filter()
          .sortByBeginDesc()
          .findAll();

      final List<Map<String, dynamic>> schoolyearsData = await Future.wait(
        schoolyears.map((sy) async {
          final averages = sy.subjects;
          final grades = await sy.grades
              .filter()
              .useable()
              .sortByDatumIngevoerdDesc()
              .thenById()
              .findAll();

          return {
            'id': sy.id,
            'name': sy.groep.omschrijving,
            'averages': averages
                .map((a) => {
                      'subject': a.naam.capitalized,
                      'subjectShort': a.afkorting,
                      'average':
                          a.grades.average.isNaN ? 0 : a.grades.average,
                    })
                .toList(),
            'recentGrades': grades
                .map((g) => {
                      'subject': g.subject.value?.naam.capitalized ?? '',
                      'grade': g.cijferStr,
                      'isVoldoende': g.isVoldoende,
                      'weight': g.weight ?? 0,
                      'description': g.cijferKolom.kolomOmschrijving ?? '',
                      'isPTA': g.cijferKolom.isPtaKolom,
                      'date': g.datumIngevoerd?.millisecondsSinceEpoch,
                    })
                .toList(),
          };
        }),
      );

      _lastGradesData = schoolyearsData;

      final payload = _sanitizeForPropertyList({
        'type': 'grades',
        'data': schoolyearsData,
      }) as Map<String, dynamic>;

      try {
        await _watch.sendMessage(payload);
      } catch (e) {
        debugPrint("Error sending grades via sendMessage: $e");
      }

      if (updateContext) {
        await _updateCombinedApplicationContext();
        _updateSyncTime();
      }
    } catch (e, stack) {
      debugPrint("Error in _sendRecentGrades: $e\n$stack");
    }
  }

  Future<void> sendEventCompletion(int id, bool isCompleted) async {
    try {
      final payload = _sanitizeForPropertyList({
        'type': 'event_completed',
        'command': 'event_completed',
        'id': id,
        'completed': isCompleted,
      }) as Map<String, dynamic>;
      await _watch.sendMessage(payload);
    } catch (e) {
      debugPrint("Error sending event completion to watch: $e");
    }
  }

  /// Recursively removes null entries and converts unsupported types
  /// (DateTime -> ms, NaN/Infinity -> 0.0) so the payload strictly conforms
  /// to Apple Property List requirements (which reject NSNull, non-finite doubles, etc.).
  static dynamic _sanitizeForPropertyList(dynamic value) {
    if (value is Map) {
      final sanitized = <String, dynamic>{};
      value.forEach((k, v) {
        if (v != null) {
          sanitized[k.toString()] = _sanitizeForPropertyList(v);
        }
      });
      return sanitized;
    } else if (value is List) {
      return value
          .where((e) => e != null)
          .map(_sanitizeForPropertyList)
          .toList();
    } else if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    } else if (value is double) {
      if (value.isNaN || value.isInfinite) return 0.0;
      return value;
    } else if (value is num || value is String || value is bool) {
      return value;
    }
    return value.toString();
  }

  Future<void> _handleToggleEvent(int id, bool? completed) async {
    final profile = activeProfileNullable;
    if (profile == null) return;

    try {
      final event =
          await isar.calendarEvents.filter().idEqualTo(id).findFirst();
      if (event == null) return;

      event.afgerond = completed ?? !event.afgerond;
      event.save();
      calendarRefreshNotifier.value++;

      try {
        await event.sync();
      } catch (e) {
        debugPrint("Error syncing toggled event to Magister: $e");
      }

      // Re-send updated schedule to watch so both sides stay in sync
      unawaited(_sendSchedule(targetProfile: profile));
    } catch (e, st) {
      debugPrint("Error toggling event from watch: $e\n$st");
    }
  }

  void _updateSyncTime() {
    appSettings.lastWatchSync = DateTime.now();
    appSettings.save();
  }
}
