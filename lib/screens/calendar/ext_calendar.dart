import 'package:collection/collection.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension CalenderEventListExt on Iterable<CalendarEvent> {
  /// Splits a list of events into a map with the day as key and the events of that day as value
  Map<DateTime, List<CalendarEvent>> get splitPerDay {
    Map<DateTime, List<CalendarEvent>> map = <DateTime, List<CalendarEvent>>{};

    // Loop though events
    for (CalendarEvent event in this) {
      DateTime dayOnly = event.start.dayOnly;
      if (map[dayOnly] != null &&
          !map[dayOnly]!.map((e) => e.id).contains(event.id)) {
        // Day exits, but event has not been added
        map[dayOnly]!.add(event);
      } else {
        // Day does not exist yet
        map.addEntries([
          MapEntry(dayOnly, [event])
        ]);
      }
    }

    return map;
  }

  /// Combines events that are similar
  List<List<CalendarEvent>> combineEvents() {
    if (!appSettings.combineDoublePeriods) return map((e) => [e]).toList();
    List<List<CalendarEvent>> combinedEvents = [];
    for (CalendarEvent event in this) {
      if (combinedEvents.isEmpty) {
        combinedEvents.add([event]);
      } else

      // Only when specific elements are the same will we combine an event
      //    1. The ending date and the starting date can differ from each other
      //       with a maximum of five minutes
      //    2. Both event should have the same infotype and status, the only
      //       exception is when the status of both events is the same, but only
      //       the top one contains an semi-important infotype such as
      //       homework, info or note
      //    3. The location, teacher, subject and title properties have to be
      //       the same.
      //    4. The content of the following event has to be empty
      //    5. Event should not last all day
      if (event.start.difference(combinedEvents.last.last.einde).inMinutes <=
              5 &&
          event.status == combinedEvents.last.last.status &&
          (event.infoType == combinedEvents.last.last.infoType ||
              ([1, 6, 7].contains(combinedEvents.last.first.infoType.index) &&
                  event.infoType.index == 0)) &&
          (event.docenten?.map((e) => e.id).every((id) =>
                  combinedEvents.last.last.docenten
                      ?.map((e) => e.id)
                      .contains(id) ??
                  true) ??
              true) &&
          event.lokatie == combinedEvents.last.last.lokatie &&
          event.subject.value?.uuid ==
              combinedEvents.last.last.subject.value?.uuid &&
          event.title == combinedEvents.last.last.title &&
          (event.inhoud?.isEmptyHTML ?? true) &&
          event.duurtHeleDag == false) {
        // Event is similair to last added event
        combinedEvents.last.add(event);
      } else {
        // Event is not similair to last added event
        combinedEvents.add([event]);
      }
    }
    return combinedEvents;
  }

  /// Get the duration for a combined event.
  Duration get duration {
    return Duration(
        milliseconds: [
      for (CalendarEvent event in this)
        event.einde.difference(event.start).inMilliseconds
    ].sum);
  }
}

enum ImportantCalenderEventTypes { absent, status, infotype }

class ImportantCalenderEventDetails {
  String change;
  bool important;
  ImportantCalenderEventTypes type;
  String? changeDesc;

  ImportantCalenderEventDetails({
    required this.change,
    this.important = false,
    required this.type,
    this.changeDesc,
  });
}

extension CalenderEventExt on CalendarEvent {
  /// Gets important details about a calendarEvent.
  /// When nothing is important this function will result in an empty list.
  List<ImportantCalenderEventDetails> get importantDetails {
    return [
      if (status == Status.automaticallyCanceled ||
          status == Status.changed ||
          status == Status.changedAndMoved ||
          status == Status.manuallyCanceled ||
          status == Status.moved)
        ImportantCalenderEventDetails(
          change: status.toName,
          type: ImportantCalenderEventTypes.status,
          changeDesc: "Evenement is ${status.toName.toLowerCase()}",
          important: true,
        ),
      if (infoType != InfoType.none)
        ImportantCalenderEventDetails(
          change: infoType.toName,
          type: ImportantCalenderEventTypes.infotype,
          important: isTest,
          changeDesc: isTest
              ? "Evenement heeft een ${infoType.toName.toLowerCase()}"
              : "Evenement is ${infoType.toName.toLowerCase()}",
        ),
      if (afwezigheid != null)
        ImportantCalenderEventDetails(
          change: afwezigheid!.omschrijving,
          type: ImportantCalenderEventTypes.absent,
        ),
    ];
  }

  bool get isCanceled => [4, 5].contains(status.index);
  bool get isTest => [2, 3, 4, 5].contains(infoType.index);

  bool get isEditable =>
      id.isNegative ||
      (profile.value?.account.value?.permissions.hasPermissions(
            PermissionType.afspraken,
            statuses: [PermissionStatus.update],
          ) ??
          false);

  /// If an event is person and has been created by the user
  bool get isPersonal =>
      type == CalendarType.personal || type == CalendarType.schedule;

  Future<List<Contact>> get contacts async => (await Future.wait([
        for (String className in omschrijving!.split(" - ").last.split(","))
          (profile.value ?? activeProfile)
              .account
              .value!
              .api
              .messages
              .searchContacts(className)
      ]))
          .expand((e) => e)
          .toList();
}

extension DateTimeHelper on List<DateTime> {
  int get weeks {
    return map((e) => e.dayOnly).toSet().where((e) => e.day == 1).length;
  }
}

extension DateTimeHelp on DateTime {
  int get weekNumber {
    final startOfYear = DateTime(year, 1, 1);
    final dayOfYear = difference(startOfYear).inDays + 1;

    // Get the first Monday of the year
    final firstMonday =
        startOfYear.add(Duration(days: (1 - startOfYear.weekday + 7) % 7));

    // Calculate the number of weeks that have passed since the first Monday
    if (firstMonday.isAfter(this)) {
      // If the first Monday is after the given date, it's part of the last week's range
      return 1;
    }

    final weeksPassed =
        ((dayOfYear - (firstMonday.difference(startOfYear).inDays)) / 7).ceil();

    return weeksPassed + 1; // Adding 1 as week number starts from 1
  }

  //TODO: For god sake, make this more practical

  String get formattedDate {
    if (year == DateTime.now().year) {
      // The year is not relevant when it is the current year.
      return DateFormat.MMMMd('nl-NL').format(this);
    }
    return DateFormat.yMMMMd('nl-NL').format(this);
  }

  String get formattedDateWithoutYear =>
      DateFormat.MMMMEEEEd('nl-NL').format(this);
  String get formattedDateAndTime =>
      DateFormat.yMMMMd('nl-NL').add_jm().format(this);
  String get formattedDateAndTimWithoutYear =>
      DateFormat.MMMMd('nl-NL').add_jm().format(this);
  String get formattedTime => DateFormat.Hm('nl-NL').format(this);
  String get formattedYear => DateFormat.y('nl-NL').format(this);

  DateTime get dayOnly => DateTime(year, month, day);
  String get dayName => DateFormat('EEEE', 'nl-NL').format(this);
  String get dayNameShort => DateFormat('E', 'nl-NL').format(this);

  bool get isToday =>
      DateTime.now().year == year &&
      DateTime.now().month == month &&
      DateTime.now().day == day;

  DateTimeRange get weekRange {
    DateTime day = dayOnly;
    return DateTimeRange(
      start: day.subtract(Duration(days: weekday - 1)),
      end: day.add(Duration(days: 7 - weekday)),
    );
  }

  DateTime get startOfWeek {
    final dayOfWeek = weekday;
    return subtract(Duration(days: dayOfWeek - 1)).dayOnly;
  }
}

class FormattedDuration {
  final int time;
  final String unit;

  FormattedDuration({required this.time, required this.unit});
}

extension DurationExtension on Duration {
  String get toName {
    if (inSeconds < 60) {
      // Seconds
      return "seconden";
    } else if (inMinutes < 60) {
      // Minutes
      return "$inMinutes minuten";
    } else if (inHours < 24) {
      // Hours
      return "$inHours uren";
    } else if (inDays < 7) {
      // Days
      return inDays == 1 ? "1 dag" : "$inDays dagen";
    } else if (inDays > 365) {
      // Days
      String string = "${inDays ~/ 365} jaar";
      if (inDays % 365 == 1) {
        string += " en ${inDays % 365} dag";
      } else if (inDays % 365 != 0) {
        string += " en ${inDays % 365} dagen";
      }
      return string;
    } else {
      return "$inDays dagen";
      // More than a week
    }
  }

  FormattedDuration get toNameFormat {
    if (inSeconds < 60) {
      // Seconds
      return FormattedDuration(time: inSeconds, unit: "seconden");
    } else if (inMinutes < 60) {
      // Minutes
      return FormattedDuration(time: inMinutes, unit: "minuten");
    } else if (inHours < 24) {
      // Hours
      return FormattedDuration(time: inHours, unit: "uren");
    } else if (inDays < 7) {
      // Days
      return FormattedDuration(time: inDays, unit: "dagen");
    } else {
      return FormattedDuration(time: inDays, unit: "dagen");
      // More than a week
    }
  }
}
