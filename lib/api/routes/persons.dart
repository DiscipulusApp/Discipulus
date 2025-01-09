import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/api/models/personal.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/leermiddelen.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/routes/schoolyear.dart';

class PersonRoute extends MagisterBase {
  PersonRoute(super.magister, {required this.personId}) : super();

  final int personId;

  SchoolyearsRoute schoolyear({int? schoolyearId}) =>
      SchoolyearsRoute(magister, id: schoolyearId, personId: personId);

  Future<List<CalendarEvent>> calendarEvents(DateTimeRange range) async {
    //Download data
    var data = await Future.wait([
      magister.dio.get(
          "personen/$personId/afspraken?tot=${DateFormat("yyyy-MM-dd").format(range.end)}&van=${DateFormat("yyyy-MM-dd").format(range.start)}"),
      magister.dio.get(
          "personen/$personId/absenties?tot=${DateFormat("yyyy-MM-dd").format(range.end)}&van=${DateFormat("yyyy-MM-dd").format(range.start)}")
    ]);
    //Cast data
    List<CalendarEvent> calendarEvents = List<CalendarEvent>.from(
        data.first.data["Items"].map((x) => CalendarEvent.fromMap(x)));
    List<Absence> absence = List<Absence>.from(
        data.last.data["Items"].map((x) => Absence.fromMap(x)));
    //Merge data
    for (var absence in absence) {
      calendarEvents
          .firstWhere((e) => e.id == absence.rawAfspraak?.id)
          .afwezigheid = absence;
    }
    //Return Data
    return calendarEvents;
  }

  Future<CalendarEvent> calendarEvent(int id) async {
    //Download data
    List<Response> data = await Future.wait([
      magister.dio.get("personen/$personId/afspraken/$id"),
      // magister.dio.get("personen/$personId/absenties/$id")
    ]);
    //Cast data
    CalendarEvent calendarEvent = CalendarEvent.fromMap(data.first.data,
        selfUrl: "personen/$personId/afspraken/$id");
    // Absence absence = Absence.fromMap(data.last.data);
    //Merge data
    // calendarEvent.afwezigheid = absence;
    //Return Data
    return calendarEvent;
  }

  ///Create a new calendar event
  ///**Only [CalendarType.personal] and [CalendarType.schedule] are allowed** for the event type.
  Future<void> createCalendarEvent({
    required DateTime start,
    required DateTime einde,
    required bool duurtHeleDag,
    required String omschrijving,
    String? lokatie,
    String? inhoud = "",
    CalendarType type = CalendarType.personal,
  }) async {
    assert(!(type != CalendarType.schedule && type != CalendarType.personal),
        "You can't create this type of event!");
    assert(start.isBefore(einde), "Start date needs to be before the end date");
    await magister.dio.post(
      "personen/$personId/afspraken",
      data: CalendarEvent(
        start: start.toUtc(),
        einde: einde.toUtc(),
        duurtHeleDag: duurtHeleDag,
        omschrijving: omschrijving,
        rawInhoud: inhoud?.nullOnEmpty,
        rawLokatie: lokatie,
        rawInfoType: InfoType.none,
        type: type,
      ).toJson(),
    );
  }

  Future<List<Assignment>> assignments(DateTimeRange range) async {
    return List<Assignment>.from((await magister.dio.get(
            "personen/$personId/opdrachten?einddatum=${DateFormat("yyyy-MM-dd").format(range.end)}&startdatum=${DateFormat("yyyy-MM-dd").format(range.start)}"))
        .data["Items"]
        .map((x) => Assignment.fromMap(x, magister)));
  }

  Future<List<Leermiddel>> get leermiddelen async {
    return List<Leermiddel>.from(
        (await magister.dio.get("personen/$personId/lesmateriaal"))
            .data["Items"]
            .map((x) => Leermiddel.fromMap(x, magister)))
      ..sort((a, b) => a.titel.length.compareTo(b.titel.length));
  }

  ///Get the children of a parent account
  Future<List<ApiChild>> get children async => List<ApiChild>.from(
      (await magister.dio.get("personen/$personId/kinderen?openData=%27%27"))
          .data["Items"]
          .map((x) => ApiChild.fromMap(x)));

  ///Haalt studiewijzers en projecten op
  Future<List<Studiewijzer>> studiewijzers(
      {bool includeProjects = true, includeStudiewijzers = true}) async {
    return List<Studiewijzer>.from((await Future.wait([
      if (includeStudiewijzers)
        magister.dio.get(
            "leerlingen/$personId/studiewijzers?peildatum=${DateFormat("yyyy-MM-dd").format(DateTime.now())}"),
      if (includeProjects)
        magister.dio.get(
            "leerlingen/$personId/projecten?peildatum=${DateFormat("yyyy-MM-dd").format(DateTime.now())}")
    ]))
        .expand((e) => e.data["Items"])
        .map((x) => Studiewijzer.fromMap(x)));
  }

  ///Returns the users profile picture (if present) in a Base64 String.
  Future<String?> get profilepicture async {
    var img = (await magister.dio.get(
      "leerlingen/$personId/foto",
      options: Options(
        responseType: ResponseType.bytes,
        validateStatus: (status) => [200, 404].contains(status),
      ),
    ));
    return (img.statusCode == 200) ? base64Encode(img.data) : null;
  }

  Future<List<Activity>> get activiteiten async {
    return List<Activity>.from(
        (await magister.dio.get("personen/$personId/activiteiten"))
            .data["Items"]
            .map((x) => Activity.fromMap(x)));
  }

  /// Get information about mail and mobile phone numbers
  Future<ProfileInfo> get getProfileInfo async => ProfileInfo.fromMap(
      (await magister.dio.get("personen/$personId/profiel")).data);

  /// Get addresses connected to the account
  Future<List<ProfileAddress>> get getProfileAddress async =>
      List<ProfileAddress>.from(
          (await magister.dio.get("personen/$personId/adressen"))
              .data["items"]
              .map((x) => ProfileAddress.fromMap(x)));

  Future<ProfileCareer> get getCareer async => ProfileCareer.fromMap(
      (await magister.dio.get("personen/$personId/opleidinggegevensprofiel"))
          .data);

  Future<ProfileAuthorization> get getAuthorization async =>
      ProfileAuthorization.fromMap(
          (await magister.dio.get("leerlingen/$personId/autorisatie")).data);

  // This is unsupported, since the scope that grants access to this does not
  // work with a universal link as redirect URL as far as I know. Making a GET
  // request will therefor always lead to a "401: Not allowed", even if you do
  // provide a valid access_token.
  //
  // Future<ProfileiCalendar> get getICalendar async {
  //   await magister.dio.get("https://calendar.magister.net/api/icalendar");
  //   return ProfileiCalendar.fromMap((await Dio().get(
  //           "https://calendar.magister.net/api/icalendar/feed",
  //           options: Options(headers: {"credentials": "omit"})))
  //       .data);
  // }

  /// Get answers
  Future<List<ProfileAnswer>> get getAnswers async =>
      List<ProfileAnswer>.from(List<ProfileAnswer>.from((await magister.dio
              .get("toestemmingen/personen/$personId/antwoorden"))
          .data["items"]
          .map((x) => ProfileAnswer.fromMap(x))));

  /// Get bron sources
  Future<List<ExternalBronSource>> get getBronSources async =>
      List<ExternalBronSource>.from(
          (await magister.dio.get("personen/$personId/bronnen?soort=0"))
              .data["Items"]
              .map((x) => ExternalBronSource.fromMap(x)));
}
