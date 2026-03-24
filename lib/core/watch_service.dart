import 'dart:async';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:isar/isar.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class WatchService with WidgetsBindingObserver {
  static final WatchService _instance = WatchService._internal();
  factory WatchService() => _instance;

  final _watch = WatchConnectivity();
  bool _initialized = false;

  WatchService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncAll();
    }
  }

  void init() {
    if (_initialized) return;
    _initialized = true;

    _watch.messageStream.listen((message) {
      if (message['command'] == 'get_schedule') {
        _sendSchedule();
      } else if (message['command'] == 'get_grades') {
        _sendRecentGrades();
      }
    });

    // Initial sync
    _syncAll();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> syncAll() => _syncAll();

  Future<void> _syncAll() async {
    await Future.wait([
      _sendSchedule(),
      _sendRecentGrades(),
    ]);
  }

  Future<void> _sendSchedule() async {
    int profileUUID =
        appSettings.activeProfileUuidWidgets ?? activeProfile.uuid;

    List<CalendarEvent> events = await (await isar.profiles
            .filter()
            .uuidEqualTo(profileUUID)
            .findFirst())!
        .calendarEvents
        .filter()
        .startGreaterThan(DateTime.now().subtract(const Duration(days: 1)))
        .eindeLessThan(DateTime.now().add(const Duration(days: 28)))
        .sortByStart()
        .limit(200)
        .findAll();

    Map<DateTime, List<CalendarEvent>> rawGrouped =
        groupBy(events.where((e) => !e.isCanceled),
            (e) => e.start.dayOnly);

    // Apply combineEvents per day to prevent cross-day combining
    Map<String, List<Map<String, dynamic>>> data = {};
    for (var entry in rawGrouped.entries) {
      String dateKey = DateFormat('yyyy-MM-dd').format(entry.key);
      data[dateKey] = entry.value
          .combineEvents()
          .map((e) => {
                'id': e.first.id,
                'name': e.first.title,
                'shortName': e.first.subject.value?.afkorting,
                'location': e.first.lokatie ?? "",
                'lesuurVan': e.first.lesuurVan,
                'lesuurTotMet': e.last.lesuurTotMet,
                'infoType': e.first.infoType.index,
                'status': e.first.status.index,
                'startTime': e.first.start.millisecondsSinceEpoch,
                'endTime': e.last.einde.millisecondsSinceEpoch,
                'isCompleted': e.first.afgerond
              }..removeWhere((key, value) => value == null))
          .toList();
    }

    await _watch.sendMessage({
      'type': 'schedule',
      'data': data,
    });
    _updateSyncTime();
  }

  Future<void> _sendRecentGrades() async {
    final profile = activeProfile;

    // Fetch all school years
    final schoolyears =
        await profile.schoolyears.filter().sortByBeginDesc().findAll();

    final List<Map<String, dynamic>> schoolyearsData = await Future.wait(
      schoolyears.map((sy) async {
        final averages =
            activeProfile.schoolyears.firstWhere((e) => e.id == sy.id).subjects;
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
                    'average': a.grades.average.isNaN ? 0 : a.grades.average,
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

    await _watch.sendMessage({
      'type': 'grades',
      'data': schoolyearsData,
    });
    _updateSyncTime();
  }

  void _updateSyncTime() {
    appSettings.lastWatchSync = DateTime.now();
    appSettings.save();
  }
}
