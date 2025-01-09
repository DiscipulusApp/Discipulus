import 'dart:math';

import 'package:discipulus/api/dummy_magister_api_dart.dart';
import 'package:discipulus/api/dummy_routes/schoolyear.dart';
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/api/models/personal.dart';
import 'package:discipulus/api/routes/persons.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/leermiddelen.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/routes/schoolyear.dart';

class DummyPersonRoute extends DummyMagisterBase implements PersonRoute {
  DummyPersonRoute(super.magister);

  @override
  // TODO: implement activiteiten
  Future<List<Activity>> get activiteiten async => Future.value([
        Activity(
          id: 0,
          titel: "Inschrijving herkansingen",
          details:
              "<h1>Inschijving herkansingen</h1><br><p>Vergeet je niet voor de herkansingen in te schrijven</p>",
          zichtbaarVanaf: DateTime.now(),
          zichtbaarTotEnMet: DateTime.now().add(const Duration(days: 365)),
          maximumAantalInschrijvingenPerActiviteit: 2,
          minimumAantalInschrijvingenPerActiviteit: 0,
          status: 0,
          startInschrijfdatum: DateTime.now(),
          eindeInschrijfdatum: DateTime.now().add(const Duration(days: 365)),
          toegangstype: 1,
          aantalInschrijvingen: 1,
          elementsLink: "personen/0/activiteiten/0",
        ),
      ]);

  @override
  Future<List<Assignment>> assignments(DateTimeRange range) async {
    int totalWeeks = range.end.difference(range.start).inDays ~/ 7;
    List<Assignment> assingments = List.generate(
      totalWeeks ~/ 4,
      (index) => Assignment(
        id: index,
        links: [],
        titel: "Opdracht nummer $index",
        vak: "GS",
        inleverenVoor: range.start.add(Duration(days: 5 + index * 7 * 4)),
        statusLaatsteOpdrachtVersie: VersieStatus.values[index % 5],
        laatsteOpdrachtVersienummer: index.isEven ? 1 : 2,
        omschrijving:
            "In deze opdracht ga je onderzoeken waarom geschiedenisstudie vaak wordt verwaarloosd, hoewel het de sleutel biedt tot begrip van de hedendaagse wereld. Is het omdat mensen liever dom blijven? Of misschien omdat ze denken dat hun Netflix-abonnement hen meer leert? Graaf eens wat dieper en ontdek waarom het verleden toch meer invloed heeft op jouw dagelijks leven dan je denkt. Maar verwacht geen heldere antwoorden, want die zijn er niet altijd.",
        beoordeling:
            "Ach, laten we eerlijk zijn, deze leerling heeft zo goed als niets gedaan. Misschien denkt hij dat hij tijd aan het besparen is voor belangrijkere zaken, zoals het leren van de nieuwste dansjes op TikTok. Maar goed, zelfs een mislukte poging tot luiheid is op zichzelf ook een soort prestatie. Je hebt in ieder geval bewezen dat je erin slaagt om helemaal niets te doen, en dat is op zijn minst consistent. Het cijfer? Tja, ik geef je het voordeel van de twijfel en houd het bij een magere 2. Volgende keer misschien toch maar iets meer moeite doen, of anders kun je net zo goed een carrière als beroepslui overwegen.",
        opnieuwInleveren: index.isOdd,
        afgesloten: false,
        magInleveren: true,
        beoordeeldOp: range.start.add(Duration(days: index * 7 * 4)),
        docenten: [Docenten(naam: "van Rossem", docentcode: "ros")],
        ingeleverdOp: range.start,
      ),
    );
    return assingments;
  }

  @override
  Future<List<CalendarEvent>> calendarEvents(DateTimeRange range) async {
    return Future.value(List.generate(
      range.end.difference(range.start).inDays,
      (dayIndex) {
        return List.generate(
          (Random(range.start.dayOnly
                      .add(Duration(days: dayIndex))
                      .microsecondsSinceEpoch)
                  .nextInt(7) +
              1),
          (hourIndex) {
            DateTime start = range.start.dayOnly
                .add(Duration(days: dayIndex, hours: 8 + hourIndex));
            return CalendarEvent(
              start: start,
              einde: start.add(const Duration(hours: 1)),
              aangemaakt: DateTime.now(),
              aantekening: "",
              afgerond: Random(start.microsecondsSinceEpoch).nextBool(),
              afwezigheid: Random(start.microsecondsSinceEpoch).nextInt(20) == 0
                  ? null
                  : Absence(),
              docenten: [Docenten(naam: "van Rossem", docentcode: "ros")],
              duurtHeleDag: false,
              gewijzigd: null,
              heeftBijlagen: false,
              herhaalStatus: 0,
              id: start.microsecondsSinceEpoch,
              isOnlineDeelname: false,
              lesuurTotMet: hourIndex + 1,
              lesuurVan: hourIndex + 1,
              lokalen: [Lokalen(naam: "001")],
              omschrijving: "Geschiedenis",
              opdrachtId: 0,
              rawInfoType: InfoType.values[Random(start.microsecondsSinceEpoch)
                  .nextInt(InfoType.values.length - 1)],
              rawInhoud: "",
              rawLokatie: "001",
              rawStatus: Status.values[Random(start.microsecondsSinceEpoch)
                  .nextInt(Status.values.length - 1)],
              subtype: 1,
              type: CalendarType.schedule,
              vakken: [Vakken(naam: "Geschiedenis")],
              weergaveType: 1,
            );
          },
        );
      },
    ).expand((e) => e).toList());
  }

  @override
  Future<List<ApiChild>> get children async => Future.value([]);

  @override
  Future<void> createCalendarEvent({
    required DateTime start,
    required DateTime einde,
    required bool duurtHeleDag,
    required String omschrijving,
    String? lokatie,
    String? inhoud = "",
    CalendarType type = CalendarType.personal,
  }) async {
// Does not work in dummy mode
  }

  @override
  Future<List<Leermiddel>> get leermiddelen async => Future.value([
        Leermiddel(
          magister,
          id: 0,
          materiaalType: 0,
          links: [],
          titel: "Online leren",
          uitgeverij: "Harry's Drukkerij",
          status: 0,
          start: DateTime.now(),
          eind: DateTime(DateTime.now().year + 1),
          ean: "EAN",
          vak: Vak(
            id: 0,
            omschrijving: "Nederlands",
            volgnr: 0,
            licentieUrl: "",
          ),
        )
      ]);

  @override
  int get personId => 0;

  @override
  Future<String?> get profilepicture async => Future.value(null);

  @override
  SchoolyearsRoute schoolyear({int? schoolyearId}) {
    return DummySchoolyearsRoute(magister);
  }

  @override
  Future<List<Studiewijzer>> studiewijzers(
      {bool includeProjects = true, includeStudiewijzers = true}) async {
    List<String> subjects = [
      "Nederlands",
      "Engels",
      "Wiskunde",
      "Geschiedenis",
      "Biologie Kwartiel I",
      "Biologie Kwartiel II",
      "Biologie Kwartiel III",
      "Scheikunde",
      "Natuurkunde",
      "Aardrijkskunde",
      "Economie",
      "Maatschappijleer"
    ];

    return Future.value(List.generate(
      10,
      (index) => Studiewijzer(
        id: index,
        van: DateTime.now(),
        totEnMet: DateTime.now(),
        rawTitel: subjects[index % subjects.length], // Varied titles
        isZichtbaar: index.isEven, // Varied visibility
        inLeerlingArchief: index > 5, // Varied archive status
        selfUrl: "/api/leerlingen/0/studiewijzers/$index/",
      ),
    ));
  }

  @override
  // TODO: implement getAnswers
  Future<List<ProfileAnswer>> get getAnswers => throw UnimplementedError();

  @override
  // TODO: implement getAuthorization
  Future<ProfileAuthorization> get getAuthorization =>
      throw UnimplementedError();

  @override
  // TODO: implement getCareer
  Future<ProfileCareer> get getCareer => throw UnimplementedError();

  // TODO: implement getICalendar
  Future<ProfileiCalendar> get getICalendar => throw UnimplementedError();

  @override
  // TODO: implement getProfileAddress
  Future<List<ProfileAddress>> get getProfileAddress =>
      throw UnimplementedError();

  @override
  // TODO: implement getProfileInfo
  Future<ProfileInfo> get getProfileInfo => throw UnimplementedError();

  @override
  Future<CalendarEvent> calendarEvent(int id) {
    // TODO: implement calendarEvent
    throw UnimplementedError();
  }

  @override
  Future<List<ExternalBronSource>> get getBronSources => Future.value([]);
}
