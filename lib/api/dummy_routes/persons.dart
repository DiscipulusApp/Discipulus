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
  Future<List<Activity>> get activiteiten async => Future.value([
        Activity(
          id: 1,
          titel: "Schoolreis Berlijn 5 VWO",
          details:
              "<h1>Culturele Excursie Berlijn</h1><br><p>Inschrijving voor de culturele excursie naar Berlijn in mei. Inclusief museumbezoek, fietstour door Mitte en een bezoek aan de Rijksdag. Kies je gewenste bus en kamerindeling.</p>",
          zichtbaarVanaf: DateTime(2026, 9, 1),
          zichtbaarTotEnMet: DateTime(2026, 11, 30),
          maximumAantalInschrijvingenPerActiviteit: 1,
          minimumAantalInschrijvingenPerActiviteit: 1,
          status: 0,
          startInschrijfdatum: DateTime(2026, 9, 15, 9, 0),
          eindeInschrijfdatum: DateTime(2026, 10, 29, 23, 59),
          toegangstype: 1,
          aantalInschrijvingen: 1,
          elementsLink: "personen/0/activiteiten/1",
        ),
        Activity(
          id: 2,
          titel: "Inschrijving Herkansingen Periode 1",
          details:
              "<h1>Inschrijving herkansingen</h1><br><p>Schrijf je in voor maximaal één herkansing van de schoolexamens uit Periode 1. Let op: controleer vooraf je rooster op eventuele overlap.</p>",
          zichtbaarVanaf: DateTime(2026, 9, 1),
          zichtbaarTotEnMet: DateTime(2026, 10, 31),
          maximumAantalInschrijvingenPerActiviteit: 2,
          minimumAantalInschrijvingenPerActiviteit: 0,
          status: 0,
          startInschrijfdatum: DateTime(2026, 9, 20, 9, 0),
          eindeInschrijfdatum: DateTime(2026, 10, 19, 23, 59),
          toegangstype: 1,
          aantalInschrijvingen: 0,
          elementsLink: "personen/0/activiteiten/2",
        ),
        Activity(
          id: 3,
          titel: "Profielwerkstuk Presentatieavond",
          details:
              "<h1>PWS Presentatieavond</h1><br><p>Meld je aan voor een presentatie-tijdslot in het auditorium om je profielwerkstuk te presenteren aan docenten, medeleerlingen en familie.</p>",
          zichtbaarVanaf: DateTime(2026, 9, 1),
          zichtbaarTotEnMet: DateTime(2026, 11, 15),
          maximumAantalInschrijvingenPerActiviteit: 1,
          minimumAantalInschrijvingenPerActiviteit: 1,
          status: 0,
          startInschrijfdatum: DateTime(2026, 9, 10, 9, 0),
          eindeInschrijfdatum: DateTime(2026, 10, 17, 23, 59),
          toegangstype: 1,
          aantalInschrijvingen: 1,
          elementsLink: "personen/0/activiteiten/3",
        ),
        Activity(
          id: 4,
          titel: "Sportdag: Zaalvoetbal & Volleybaltoernooi",
          details:
              "<h1>Jaarlijkse Bovenbouw Sportdag</h1><br><p>Schrijf je team in voor het toernooi in de sportzaal. Teams bestaan uit 6 personen uit je eigen mentorklas.</p>",
          zichtbaarVanaf: DateTime(2026, 9, 1),
          zichtbaarTotEnMet: DateTime(2026, 10, 31),
          maximumAantalInschrijvingenPerActiviteit: 1,
          minimumAantalInschrijvingenPerActiviteit: 0,
          status: 0,
          startInschrijfdatum: DateTime(2026, 9, 18, 9, 0),
          eindeInschrijfdatum: DateTime(2026, 10, 15, 23, 59),
          toegangstype: 1,
          aantalInschrijvingen: 1,
          elementsLink: "personen/0/activiteiten/4",
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
        docenten: [Docenten(naam: "M. van Rossem", docentcode: "ros")],
        ingeleverdOp: range.start,
      ),
    );
    return assingments;
  }

  @override
  Future<List<CalendarEvent>> calendarEvents(DateTimeRange range, {bool includeAbsences = false}) async {
    List<CalendarEvent> allEvents = [];
    int totalDays = range.end.difference(range.start).inDays;

    for (int dayIndex = 0; dayIndex < totalDays; dayIndex++) {
      DateTime day = range.start.dayOnly.add(Duration(days: dayIndex));
      if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        continue;
      }

      List<({
        String subject,
        String teacher,
        String code,
        String room,
        InfoType infoType,
        String content,
        int startHour,
        int startMinute,
        int endHour,
        int endMinute,
        int lesuurVan,
        int lesuurTotMet,
        bool afgerond,
      })> dayLessons;

      if (day.weekday == DateTime.tuesday) {
        dayLessons = [
          (
            subject: "Lichamelijke opvoeding",
            teacher: "H. de Vries",
            code: "vrs",
            room: "Gymzaal",
            infoType: InfoType.none,
            content: "",
            startHour: 8,
            startMinute: 30,
            endHour: 9,
            endMinute: 10,
            lesuurVan: 1,
            lesuurTotMet: 1,
            afgerond: true,
          ),
          (
            subject: "Lichamelijke opvoeding",
            teacher: "H. de Vries",
            code: "vrs",
            room: "Gymzaal",
            infoType: InfoType.none,
            content: "",
            startHour: 9,
            startMinute: 10,
            endHour: 9,
            endMinute: 50,
            lesuurVan: 2,
            lesuurTotMet: 2,
            afgerond: true,
          ),
          (
            subject: "Wiskunde B",
            teacher: "R. Descartes",
            code: "des",
            room: "A104",
            infoType: InfoType.none,
            content: "",
            startHour: 9,
            startMinute: 50,
            endHour: 10,
            endMinute: 40,
            lesuurVan: 3,
            lesuurTotMet: 3,
            afgerond: true,
          ),
          (
            subject: "Natuurkunde",
            teacher: "M. Eijkelkamp",
            code: "Ekl",
            room: "N003",
            infoType: InfoType.test,
            content: "PW H3 Elektriciteit & Magnetisme",
            startHour: 11,
            startMinute: 0,
            endHour: 11,
            endMinute: 50,
            lesuurVan: 4,
            lesuurTotMet: 4,
            afgerond: false,
          ),
          (
            subject: "Geschiedenis",
            teacher: "M. van Rossem",
            code: "ros",
            room: "B102",
            infoType: InfoType.none,
            content: "",
            startHour: 11,
            startMinute: 50,
            endHour: 12,
            endMinute: 40,
            lesuurVan: 5,
            lesuurTotMet: 5,
            afgerond: false,
          ),
          (
            subject: "Engels",
            teacher: "L. van Gaal",
            code: "lvg",
            room: "A205",
            infoType: InfoType.homework,
            content: "Self study chapter 4. We are running behind the facts!",
            startHour: 13,
            startMinute: 10,
            endHour: 14,
            endMinute: 0,
            lesuurVan: 6,
            lesuurTotMet: 6,
            afgerond: false,
          ),
          (
            subject: "Maatschappijleer",
            teacher: "M. Rutte",
            code: "rut",
            room: "C105",
            infoType: InfoType.none,
            content: "",
            startHour: 14,
            startMinute: 0,
            endHour: 14,
            endMinute: 50,
            lesuurVan: 7,
            lesuurTotMet: 7,
            afgerond: false,
          ),
        ];
      } else if (day.weekday == DateTime.thursday) {
        dayLessons = [
          (
            subject: "Nederlands",
            teacher: "P.C. Hooft",
            code: "pch",
            room: "B201",
            infoType: InfoType.none,
            content: "",
            startHour: 8,
            startMinute: 30,
            endHour: 9,
            endMinute: 20,
            lesuurVan: 1,
            lesuurTotMet: 1,
            afgerond: true,
          ),
          (
            subject: "Scheikunde",
            teacher: "W.H. White",
            code: "sam",
            room: "C105",
            infoType: InfoType.test,
            content: "SO H2 Koolstofchemie & Redoxreacties",
            startHour: 9,
            startMinute: 20,
            endHour: 10,
            endMinute: 10,
            lesuurVan: 2,
            lesuurTotMet: 2,
            afgerond: false,
          ),
          (
            subject: "Wiskunde B",
            teacher: "R. Descartes",
            code: "des",
            room: "A104",
            infoType: InfoType.homework,
            content: "Opgaven 12 t/m 18 maken.",
            startHour: 10,
            startMinute: 30,
            endHour: 11,
            endMinute: 20,
            lesuurVan: 3,
            lesuurTotMet: 3,
            afgerond: false,
          ),
          (
            subject: "Frans",
            teacher: "A. Poulain",
            code: "aml",
            room: "A102",
            infoType: InfoType.none,
            content: "",
            startHour: 11,
            startMinute: 20,
            endHour: 12,
            endMinute: 10,
            lesuurVan: 4,
            lesuurTotMet: 4,
            afgerond: false,
          ),
          (
            subject: "Informatica",
            teacher: "A. Turing",
            code: "tur",
            room: "301",
            infoType: InfoType.none,
            content: "",
            startHour: 12,
            startMinute: 40,
            endHour: 13,
            endMinute: 30,
            lesuurVan: 5,
            lesuurTotMet: 5,
            afgerond: false,
          ),
        ];
      } else if (day.weekday == DateTime.monday) {
        dayLessons = [
          (
            subject: "Nederlands",
            teacher: "P.C. Hooft",
            code: "pch",
            room: "B201",
            infoType: InfoType.homework,
            content: "Vertaal 'Wanneer de Vorst des lichts slaet aen de gulden tóómen' naar modern Nederlands",
            startHour: 8,
            startMinute: 30,
            endHour: 9,
            endMinute: 20,
            lesuurVan: 1,
            lesuurTotMet: 1,
            afgerond: true,
          ),
          (
            subject: "Wiskunde B",
            teacher: "R. Descartes",
            code: "des",
            room: "A104",
            infoType: InfoType.homework,
            content: "Huiswerk: H4 opgaven 14 t/m 28 afmaken.",
            startHour: 9,
            startMinute: 20,
            endHour: 10,
            endMinute: 10,
            lesuurVan: 2,
            lesuurTotMet: 2,
            afgerond: true,
          ),
          (
            subject: "Geschiedenis",
            teacher: "M. van Rossem",
            code: "ros",
            room: "B102",
            infoType: InfoType.none,
            content: "",
            startHour: 10,
            startMinute: 30,
            endHour: 11,
            endMinute: 20,
            lesuurVan: 3,
            lesuurTotMet: 3,
            afgerond: false,
          ),
          (
            subject: "Scheikunde",
            teacher: "W.H. White",
            code: "sam",
            room: "C105",
            infoType: InfoType.none,
            content: "",
            startHour: 11,
            startMinute: 20,
            endHour: 12,
            endMinute: 10,
            lesuurVan: 4,
            lesuurTotMet: 4,
            afgerond: false,
          ),
          (
            subject: "Natuurkunde",
            teacher: "M. Eijkelkamp",
            code: "Ekl",
            room: "N003",
            infoType: InfoType.homework,
            content: "Opgaven 5 t/m 12 voorbereiden.",
            startHour: 12,
            startMinute: 40,
            endHour: 13,
            endMinute: 30,
            lesuurVan: 5,
            lesuurTotMet: 5,
            afgerond: false,
          ),
        ];
      } else if (day.weekday == DateTime.wednesday) {
        dayLessons = [
          (
            subject: "Engels",
            teacher: "L. van Gaal",
            code: "lvg",
            room: "A205",
            infoType: InfoType.none,
            content: "",
            startHour: 8,
            startMinute: 30,
            endHour: 9,
            endMinute: 20,
            lesuurVan: 1,
            lesuurTotMet: 1,
            afgerond: true,
          ),
          (
            subject: "Biologie",
            teacher: "F. Vonk",
            code: "vnk",
            room: "B012",
            infoType: InfoType.homework,
            content: "Practicum voorbereiden: preparaten maken.",
            startHour: 9,
            startMinute: 20,
            endHour: 10,
            endMinute: 10,
            lesuurVan: 2,
            lesuurTotMet: 2,
            afgerond: false,
          ),
          (
            subject: "Wiskunde B",
            teacher: "R. Descartes",
            code: "des",
            room: "A104",
            infoType: InfoType.none,
            content: "",
            startHour: 10,
            startMinute: 30,
            endHour: 11,
            endMinute: 20,
            lesuurVan: 3,
            lesuurTotMet: 3,
            afgerond: false,
          ),
          (
            subject: "Duits",
            teacher: "J. Goethe",
            code: "gth",
            room: "A105",
            infoType: InfoType.none,
            content: "",
            startHour: 11,
            startMinute: 20,
            endHour: 12,
            endMinute: 10,
            lesuurVan: 4,
            lesuurTotMet: 4,
            afgerond: false,
          ),
        ];
      } else {
        // Friday
        dayLessons = [
          (
            subject: "Maatschappijleer",
            teacher: "M. Rutte",
            code: "rut",
            room: "B104",
            infoType: InfoType.none,
            content: "",
            startHour: 8,
            startMinute: 30,
            endHour: 9,
            endMinute: 20,
            lesuurVan: 1,
            lesuurTotMet: 1,
            afgerond: true,
          ),
          (
            subject: "Frans",
            teacher: "A. Poulain",
            code: "aml",
            room: "A102",
            infoType: InfoType.homework,
            content: "Vocabulaire chapitre 3 apprendre.",
            startHour: 9,
            startMinute: 20,
            endHour: 10,
            endMinute: 10,
            lesuurVan: 2,
            lesuurTotMet: 2,
            afgerond: false,
          ),
          (
            subject: "Natuurkunde",
            teacher: "M. Eijkelkamp",
            code: "Ekl",
            room: "N003",
            infoType: InfoType.none,
            content: "",
            startHour: 10,
            startMinute: 30,
            endHour: 11,
            endMinute: 20,
            lesuurVan: 3,
            lesuurTotMet: 3,
            afgerond: false,
          ),
          (
            subject: "Lichamelijke opvoeding",
            teacher: "H. de Vries",
            code: "vrs",
            room: "Gymzaal",
            infoType: InfoType.none,
            content: "",
            startHour: 11,
            startMinute: 20,
            endHour: 12,
            endMinute: 0,
            lesuurVan: 4,
            lesuurTotMet: 4,
            afgerond: false,
          ),
          (
            subject: "Lichamelijke opvoeding",
            teacher: "H. de Vries",
            code: "vrs",
            room: "Gymzaal",
            infoType: InfoType.none,
            content: "",
            startHour: 12,
            startMinute: 0,
            endHour: 12,
            endMinute: 40,
            lesuurVan: 5,
            lesuurTotMet: 5,
            afgerond: false,
          ),
        ];
      }

      for (final lesson in dayLessons) {
        DateTime start = day.add(Duration(
          hours: lesson.startHour,
          minutes: lesson.startMinute,
        ));
        DateTime end = day.add(Duration(
          hours: lesson.endHour,
          minutes: lesson.endMinute,
        ));

        allEvents.add(
          CalendarEvent(
            start: start,
            einde: end,
            aangemaakt: DateTime.now(),
            aantekening: "",
            afgerond: lesson.afgerond,
            afwezigheid: null,
            docenten: [
              Docenten(naam: lesson.teacher, docentcode: lesson.code)
            ],
            duurtHeleDag: false,
            gewijzigd: null,
            heeftBijlagen: false,
            herhaalStatus: 0,
            id: start.microsecondsSinceEpoch,
            isOnlineDeelname: false,
            lesuurTotMet: lesson.lesuurTotMet,
            lesuurVan: lesson.lesuurVan,
            lokalen: [Lokalen(naam: lesson.room)],
            omschrijving: lesson.subject,
            opdrachtId: 0,
            rawInfoType: lesson.infoType,
            rawInhoud: lesson.content,
            rawLokatie: lesson.room,
            rawStatus: Status.automaticallyScheduled,
            subtype: 1,
            type: CalendarType.schedule,
            vakken: [Vakken(naam: lesson.subject)],
            weergaveType: 1,
          ),
        );
      }
    }
    return Future.value(allEvents);
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
      subjects.length,
      (index) => Studiewijzer(
        id: index,
        van: DateTime.now().subtract(const Duration(days: 30)),
        totEnMet: DateTime.now().add(const Duration(days: 180)),
        rawTitel: subjects[index],
        isZichtbaar: true,
        inLeerlingArchief: false,
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
