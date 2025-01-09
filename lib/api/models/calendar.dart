import 'dart:convert';

import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/utils/extensions.dart';

part 'calendar.g.dart';

@Collection()
@Name("CalendarEvent")
class CalendarEvent {
  final profile = IsarLink<Profile>();
  final subject = IsarLink<Subject>();
  Id get uuid => "${profile.value!.uuid}$id".hashCode;

  @ignore
  String get title => (vakken ?? []).isEmpty
      ? omschrijving?.split(" - ").first ?? "??"
      : vakken!.map((e) => e.naam!).formattedJoin.capitalized;

  final int id;
  final DateTime start;
  final DateTime einde;
  final int? lesuurVan;
  final int? lesuurTotMet;
  final bool duurtHeleDag;
  final String? omschrijving;
  @enumerated
  final CalendarType type;
  final int subtype;
  final bool isOnlineDeelname;
  final int weergaveType;
  String? aantekening;
  bool afgerond;
  final int herhaalStatus;
  final List<Vakken>?
      vakken; //Waarom kan dit niet met IsarLinks? Zie "Subjects.dart".
  final List<Docenten>? docenten;
  final List<Lokalen>? lokalen;
  final int opdrachtId;
  final bool heeftBijlagen;
  final String? selfUrl;
  Absence? afwezigheid;
  DateTime? aangemaakt;
  DateTime? gewijzigd;
  final bronnen = IsarLinks<Bron>();
  final studiewijzers = IsarLinks<
      Studiewijzer>(); //Ooit waren VakCodes in studiewijzers een ding, maar nu zijn ze blijvend leeg, god weet waarom.
  CustomCalendarProperties? customCalendarProperties;

  bool excludeFromAutoDND = false;

  //Custom properties
  final String? rawLokatie;
  @enumerated
  final Status rawStatus;
  final String? rawInhoud;
  @enumerated
  final InfoType rawInfoType;

  String? get lokatie => magiCal(
        custom: customCalendarProperties?.lokatie,
        offical: rawLokatie?.split(",").formattedJoin,
        original:
            customCalendarProperties?.lokatieOriginal?.split(",").formattedJoin,
      );

  set lokatie(String? newLokatie) {
    customCalendarProperties ??= CustomCalendarProperties();
    customCalendarProperties?.lokatieOriginal = rawLokatie;
    customCalendarProperties?.lokatieChanged = DateTime.now();
    customCalendarProperties?.lokatie = newLokatie;
  }

  @enumerated
  Status get status => magiCal(
      custom: customCalendarProperties?.status,
      offical: rawStatus,
      original: customCalendarProperties?.statusOriginal);

  set status(Status? newStatus) {
    customCalendarProperties ??= CustomCalendarProperties();
    customCalendarProperties?.statusOriginal = rawStatus;
    customCalendarProperties?.statusChanged = DateTime.now();
    customCalendarProperties?.status = newStatus;
  }

  String? get inhoud => magiCal(
      custom: customCalendarProperties?.inhoud,
      offical: rawInhoud,
      original: customCalendarProperties?.inhoudOriginal);

  set inhoud(String? newInhoud) {
    customCalendarProperties ??= CustomCalendarProperties();
    customCalendarProperties?.inhoudOriginal = rawInhoud;
    customCalendarProperties?.inhoudChanged = DateTime.now();
    customCalendarProperties?.inhoud = newInhoud;
  }

  @enumerated
  InfoType get infoType => magiCal(
      custom: customCalendarProperties?.infotype,
      offical: rawInfoType,
      original: customCalendarProperties?.infotypeOriginal);

  set infoType(InfoType? newInfoType) {
    customCalendarProperties ??= CustomCalendarProperties();
    customCalendarProperties?.infotypeOriginal = rawInfoType;
    customCalendarProperties?.infotypeChanged = DateTime.now();
    customCalendarProperties?.infotype = newInfoType;
  }

  dynamic magiCal({custom, original, offical}) {
    if (original == offical) {
      return custom ?? offical;
    }
    return offical;
  }

  CalendarEvent({
    this.id = 0,
    required this.start,
    required this.einde,
    this.lesuurVan,
    this.lesuurTotMet,
    this.duurtHeleDag = false,
    this.omschrijving,
    this.rawLokatie,
    this.rawStatus = Status.manuallyScheduled,
    this.type = CalendarType.personal,
    this.subtype = 1,
    this.isOnlineDeelname = false,
    this.weergaveType = 1,
    this.rawInhoud = "",
    this.rawInfoType = InfoType.information,
    this.aantekening,
    this.afgerond = false,
    this.herhaalStatus = 0,
    this.vakken,
    this.docenten,
    this.lokalen,
    this.opdrachtId = 0,
    this.heeftBijlagen = false,
    this.selfUrl,
    this.afwezigheid,
    this.aangemaakt,
    this.gewijzigd,
  });

  factory CalendarEvent.fromJson(String str) =>
      CalendarEvent.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CalendarEvent.fromMap(Map<String, dynamic> json, {String? selfUrl}) =>
      CalendarEvent(
          id: json["Id"],
          start: DateTime.parse(json["Start"]).toUtc(),
          einde: DateTime.parse(json["Einde"]).toUtc(),
          lesuurVan: json["LesuurVan"],
          lesuurTotMet: json["LesuurTotMet"],
          duurtHeleDag: json["DuurtHeleDag"],
          omschrijving: json["Omschrijving"],
          rawLokatie: json["Lokatie"],
          rawStatus:
              statusValues.map[json["Status"].toString()] ?? Status.unknown,
          type: typeValues.map[json["Type"].toString()] ?? CalendarType.none,
          subtype: json["Subtype"],
          isOnlineDeelname: json["IsOnlineDeelname"],
          weergaveType: json["WeergaveType"],
          rawInhoud: json["Inhoud"],
          rawInfoType:
              infoTypeValues.map[json["InfoType"].toString()] ?? InfoType.none,
          aantekening: json["Aantekening"],
          afgerond: json["Afgerond"],
          herhaalStatus: json["HerhaalStatus"],
          vakken:
              List<Vakken>.from(json["Vakken"].map((x) => Vakken.fromMap(x))),
          docenten: json["Docenten"] == null
              ? []
              : List<Docenten>.from(
                  json["Docenten"].map((x) => Docenten.fromMap(x))),
          lokalen:
              json["Lokalen"] == null
                  ? []
                  : List<Lokalen>.from(
                      json["Lokalen"].map((x) => Lokalen.fromMap(x))),
          opdrachtId: json["OpdrachtId"],
          heeftBijlagen: json["HeeftBijlagen"],
          aangemaakt: json["TaakAangemaaktOp"] == null
              ? null
              : DateTime.parse(json["TaakAangemaaktOp"]).toUtc(),
          gewijzigd: json["TaakGewijzigdOp"] == null
              ? null
              : DateTime.parse(json["TaakGewijzigdOp"]).toUtc(),
          selfUrl: selfUrl ??
              (json["Links"] == null
                  ? null
                  : List<Link>.from(json["Links"].map((x) => Link.fromMap(x)))
                      .where((l) => l.rel == "Self")
                      .firstOrNull
                      ?.href
                      .replaceAll("/api/", "")))
        ..customCalendarProperties = (() {
          // Adding customCalendarProperties if existent
          if (json["Aantekening"] != null && json["Aantekening"] != "") {
            try {
              return CustomCalendarProperties.fromAantekening(
                  json["Aantekening"]!);
            } on FormatException {
              // No base64 String
            }
          }
          return null;
        }).call();

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Start": start.toIso8601String(),
        "Einde": einde.toIso8601String(),
        "LesuurVan": lesuurVan,
        "LesuurTotMet": lesuurTotMet,
        "DuurtHeleDag": duurtHeleDag,
        "Omschrijving": omschrijving,
        "Lokatie": lokatie,
        "Status": int.parse(statusValues.reverse[status]!),
        "Type": int.parse(typeValues.reverse[type]!),
        "Subtype": subtype,
        "IsOnlineDeelname": isOnlineDeelname,
        "WeergaveType": weergaveType,
        "Inhoud": inhoud,
        "InfoType": int.parse(infoTypeValues.reverse[infoType]!),
        "Aantekening": customCalendarProperties?.toAantekening() ??
            ([
              customCalendarProperties?.infotypeChanged,
              customCalendarProperties?.statusChanged,
              customCalendarProperties?.lokatieChanged,
              customCalendarProperties?.inhoudChanged
            ].nonNulls.isEmpty
                ? aantekening
                : null),
        "Afgerond": afgerond,
        "HerhaalStatus": herhaalStatus,
        "Vakken": vakken != null
            ? List<dynamic>.from(vakken!.map((x) => x.toMap()))
            : null,
        "Docenten": docenten != null
            ? List<dynamic>.from(docenten!.map((x) => x.toMap()))
            : null,
        "Lokalen": lokalen != null
            ? List<dynamic>.from(lokalen!.map((x) => x.toMap()))
            : null,
        "OpdrachtId": opdrachtId,
        "HeeftBijlagen": heeftBijlagen,
      };

  void save() => isar.writeTxnSync(() => isar.calendarEvents.putSync(this));

  Future<void> fill() async {
    // Check permissions
    if (!(profile.value?.account.value?.permissions
            .hasPermissions(PermissionType.afspraken) ??
        false)) {
      return;
    }

    assert(selfUrl != null);
    var res = (await profile.value!.account.value!.api.dio.get(selfUrl!)).data;
    var bijlagen = List<Bron>.from(res["Bijlagen"].map((x) =>
        Bron.fromMap(x..["BronSoort"] = 1)..profile.value = profile.value));
    var event = CalendarEvent.fromMap(res, selfUrl: selfUrl)
      ..profile.value = profile.value;
    bronnen.addAll(bijlagen);
    isar.writeTxnSync(() {
      isar.brons.putAllSync(bronnen.toList());
      isar.calendarEvents.putSync(event);
      bronnen.saveSync();
    });
  }

  /// Push changes to Magister
  Future<void> sync() async {
    assert(selfUrl != null);

    // Check permissions
    if (!(profile.value?.account.value?.permissions.hasPermissions(
            PermissionType.afspraken,
            statuses: [PermissionStatus.update]) ??
        false)) {
      return;
    }

    await profile.value!.account.value!.api.dio.put(selfUrl!, data: toJson());
  }

  Future<void> remove() async {
    assert(selfUrl != null);
    assert(!(type != CalendarType.personal && type != CalendarType.schedule),
        "Event not created by user!");

    // Check permissions
    if (!(profile.value?.account.value?.permissions.hasPermissions(
            PermissionType.afspraken,
            statuses: [PermissionStatus.update]) ??
        false)) {
      return;
    }

    await profile.value!.account.value!.api.dio.delete(selfUrl!);
  }
}

class Link {
  final String rel;
  final String href;

  Link({
    this.rel = "",
    this.href = "",
  });

  factory Link.fromMap(Map<String, dynamic> json) => Link(
        rel: json["Rel"],
        href: json["Href"],
      );
}

@embedded
class Docenten {
  final int id;
  final String? naam;
  final String? docentcode;

  Docenten({
    this.id = 0,
    this.naam,
    this.docentcode,
  });

  factory Docenten.fromJson(String str) => Docenten.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Docenten.fromMap(Map<String, dynamic> json) => Docenten(
        id: json["Id"],
        naam: json["Naam"],
        docentcode: json["Docentcode"],
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Naam": naam,
        "Docentcode": docentcode,
      };
}

@embedded
class Vakken {
  final int id;
  final String? naam;

  Vakken({
    this.id = 0,
    this.naam,
  });

  factory Vakken.fromJson(String str) => Vakken.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Vakken.fromMap(Map<String, dynamic> json) => Vakken(
        id: json["Id"],
        naam: json["Naam"],
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Naam": naam,
      };
}

enum Status {
  unknown,
  automaticallyScheduled,
  manuallyScheduled,
  changed,
  manuallyCanceled,
  automaticallyCanceled,
  inUse,
  finished,
  used,
  moved,
  changedAndMoved
}

extension StatusName on Status {
  String get toName {
    switch (this) {
      case Status.automaticallyScheduled:
        return "Automatisch ingeroosterd";
      case Status.manuallyScheduled:
        return "Handmatig ingeroosterd";
      case Status.changed:
        return "Veranderd";
      case Status.manuallyCanceled:
        return "Handmatig uitgevallen";
      case Status.automaticallyCanceled:
        return "Automatisch uitgevallen";
      case Status.inUse:
        return "In gebruik";
      case Status.finished:
        return "Afgerond";
      case Status.used:
        return "Gebruikt";
      case Status.moved:
        return "Verplaast";
      case Status.changedAndMoved:
        return "Veranderd en verplaast";
      default:
        return "Geen";
    }
  }
}

final statusValues = EnumValues({
  "0": Status.unknown,
  "1": Status.automaticallyScheduled,
  "2": Status.manuallyScheduled,
  "3": Status.changed,
  "4": Status.manuallyCanceled,
  "5": Status.automaticallyCanceled,
  "6": Status.inUse,
  "7": Status.inUse,
  "8": Status.used,
  "9": Status.moved,
  "10": Status.changedAndMoved,
});

enum InfoType {
  none,
  homework,
  test,
  exam,
  writtenExam,
  oralExam,
  information,
  note;

  static List<InfoType> tests = [
    InfoType.test,
    InfoType.writtenExam,
    InfoType.oralExam,
    InfoType.exam,
  ];
}

Map<InfoType?, String> infoTypeOptions = {
  null: "Origineel",
  InfoType.none: "Geen",
  InfoType.homework: "Huiswerk",
  InfoType.test: "Proefwerk",
  InfoType.exam: "Tentamen",
  InfoType.writtenExam: "Schriftelijke overhoring",
  InfoType.oralExam: "Mondelinge overhoring",
  InfoType.information: "Informatie",
  InfoType.note: "Notitie",
};

Map<InfoType?, String> infoTypeShortOptions = {
  null: "N",
  InfoType.none: "N",
  InfoType.homework: "HW",
  InfoType.test: "PW",
  InfoType.exam: "TT",
  InfoType.writtenExam: "SO",
  InfoType.oralExam: "MO",
  InfoType.information: "Inf",
  InfoType.note: "Not",
};

extension InfoTypeName on InfoType? {
  /// Get the name of a certain infotype.
  /// ```text
  /// 0 - null:                    "Origineel",
  /// 1 - InfoType.none:           "Geen",
  /// 2 - InfoType.homework:       "Huiswerk",
  /// 3 - InfoType.test:           "Proefwerk",
  /// 4 - InfoType.exam:           "Tentamen",
  /// 5 - InfoType.writtenExam:    "Schriftelijke overhoring",
  /// 6 - InfoType.oralExam:       "Mondelinge overhoring",
  /// 7 - InfoType.information:    "Informatie",
  /// 8 - InfoType.note:           "Notitie",
  /// ```
  String get toName => infoTypeOptions[this] ?? "Geen";
  String get toShort => infoTypeShortOptions[this] ?? "N";
}

final infoTypeValues = EnumValues({
  "0": InfoType.none,
  "1": InfoType.homework,
  "2": InfoType.test,
  "3": InfoType.exam,
  "4": InfoType.writtenExam,
  "5": InfoType.oralExam,
  "6": InfoType.information,
  "7": InfoType.note,
});

enum CalendarType {
  none,
  personal,
  general,
  schoolWide,
  internship,
  intake,
  free,
  kwt,
  standby,
  blocked,
  other,
  blockedClassroom,
  blockedClass,
  classs,
  studyHouse,
  freeStudy,
  schedule,
  measures,
  presentations,
  examSchedule
}

final typeValues = EnumValues({
  "0": CalendarType.none,
  "1": CalendarType.personal,
  "2": CalendarType.general,
  "3": CalendarType.schoolWide,
  "4": CalendarType.internship,
  "5": CalendarType.intake,
  "6": CalendarType.free,
  "7": CalendarType.kwt,
  "8": CalendarType.standby,
  "9": CalendarType.blocked,
  "10": CalendarType.other,
  "11": CalendarType.blockedClassroom,
  "12": CalendarType.blockedClass,
  "13": CalendarType.classs,
  "14": CalendarType.studyHouse,
  "15": CalendarType.freeStudy,
  "16": CalendarType.schedule,
  "101": CalendarType.measures,
  "102": CalendarType.presentations,
  "103": CalendarType.examSchedule
});

@embedded
class Lokalen {
  final String? naam;

  Lokalen({
    this.naam,
  });

  factory Lokalen.fromJson(String str) => Lokalen.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Lokalen.fromMap(Map<String, dynamic> json) => Lokalen(
        naam: json["Naam"],
      );

  Map<String, dynamic> toMap() => {
        "Naam": naam,
      };
}

@embedded
class Absence {
  final int id;
  final DateTime? start;
  final DateTime? eind;
  final int lesuur;
  final bool geoorloofd;
  final int afspraakId;
  final String omschrijving;
  @enumerated
  final AbsenceType verantwoordingtype;
  final String code;
  @ignore
  final CalendarEvent? rawAfspraak;

  Absence({
    this.id = 0,
    this.start,
    this.eind,
    this.lesuur = 0,
    this.geoorloofd = true,
    this.afspraakId = 0,
    this.omschrijving = "No data",
    this.verantwoordingtype = AbsenceType.unknown,
    this.code = "??",
    this.rawAfspraak,
  });

  factory Absence.fromJson(String str) => Absence.fromMap(json.decode(str));

  factory Absence.fromMap(Map<String, dynamic> json) => Absence(
        id: json["Id"],
        start: DateTime.parse(json["Start"]).toUtc(),
        eind: DateTime.parse(json["Eind"]).toUtc(),
        lesuur: json["Lesuur"],
        geoorloofd: json["Geoorloofd"],
        afspraakId: json["AfspraakId"],
        omschrijving: json["Omschrijving"],
        verantwoordingtype:
            absenceValues.map[json["Verantwoordingtype"].toString()] ??
                AbsenceType.unknown,
        code: json["Code"],
        rawAfspraak: CalendarEvent.fromMap(json["Afspraak"]),
      );
}

enum AbsenceType {
  absent,
  late,
  sick,
  discharged,
  exemption,
  books,
  homework,
  unknown
}

final absenceValues = EnumValues({
  "0": AbsenceType.unknown,
  "1": AbsenceType.absent,
  "2": AbsenceType.late,
  "3": AbsenceType.sick,
  "4": AbsenceType.discharged,
  // No 5?
  "6": AbsenceType.exemption,
  "7": AbsenceType.books,
  "8": AbsenceType.homework,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

//MagIcal intergration
@embedded
class CustomCalendarProperties {
  ///When this value is is null, the value from Magister will be used instead.
  @ignore
  String? get inhoud => rawInhoud;

  set inhoud(String? newInhoud) {
    rawInhoud =
        newInhoud != "" && newInhoud != inhoudOriginal ? newInhoud : null;
  }

  String? rawInhoud;
  String? inhoudOriginal;
  DateTime? inhoudChanged;

  ///When this value is is null, the value from Magister will be used instead.
  @ignore
  String? get lokatie => rawLokatie;

  set lokatie(String? newLokatie) {
    rawLokatie =
        newLokatie != "" && newLokatie != lokatieOriginal ? newLokatie : null;
  }

  String? rawLokatie;
  String? lokatieOriginal;
  DateTime? lokatieChanged;

  @ignore
  InfoType? get infotype => infoTypeValues.map[rawInfotype.toString()];

  set infotype(InfoType? newInfotype) {
    rawInfotype = newInfotype != null && newInfotype != infotypeOriginal
        ? int.tryParse(infoTypeValues.reverse[newInfotype].toString())
        : null;
  }

  int? rawInfotype;
  @ignore
  InfoType? get infotypeOriginal =>
      infoTypeValues.map[rawInfotypeOriginal.toString()];
  set infotypeOriginal(InfoType? newInfotype) => rawInfotypeOriginal =
      int.tryParse(infoTypeValues.reverse[newInfotype] ?? "");
  int? rawInfotypeOriginal;
  DateTime? infotypeChanged;

  @ignore
  Status? get status => statusValues.map[rawStatus.toString()];

  set status(Status? newStatus) {
    rawStatus = newStatus != null && newStatus != statusOriginal
        ? int.tryParse(statusValues.reverse[newStatus].toString())
        : null;
  }

  int? rawStatus;
  @ignore
  Status? get statusOriginal => statusValues.map[rawStatusOriginal.toString()];
  set statusOriginal(Status? newStatus) =>
      rawStatusOriginal = int.tryParse(statusValues.reverse[newStatus] ?? "");
  int? rawStatusOriginal;
  DateTime? statusChanged;

  CustomCalendarProperties(
      {this.rawInhoud,
      this.inhoudOriginal,
      this.inhoudChanged,
      this.rawInfotype,
      this.rawInfotypeOriginal,
      this.infotypeChanged,
      this.rawStatus,
      this.rawStatusOriginal,
      this.statusChanged,
      this.rawLokatie,
      this.lokatieOriginal,
      this.lokatieChanged});

  factory CustomCalendarProperties.fromAantekening(String aantekening) {
    //Decode base64 to map
    Map<String, dynamic> decodedMap =
        jsonDecode(utf8.decode(base64Decode(aantekening)));

    //Create element
    return CustomCalendarProperties(
      rawStatus: decodedMap["Status"] != null
          ? int.tryParse(decodedMap["Status"].toString())
          : null,
      rawStatusOriginal: decodedMap["originalStatus"],
      statusChanged: DateTime.tryParse(decodedMap["dateStatus"].toString()) ??
          DateTime.now(),
      rawInfotype: decodedMap["InfoType"] != null
          ? int.tryParse(decodedMap["InfoType"].toString())
          : null,
      rawInfotypeOriginal: decodedMap["originalInfoType"],
      infotypeChanged:
          DateTime.tryParse(decodedMap["dateInfotype"].toString()) ??
              DateTime.now(),
      rawInhoud: decodedMap["Inhoud"],
      inhoudOriginal: decodedMap["originalInhoud"],
      inhoudChanged: DateTime.tryParse(decodedMap["dateInhoud"].toString()) ??
          DateTime.now(),
      rawLokatie: decodedMap["Lokatie"],
      lokatieOriginal: decodedMap["originalLokatie"],
      lokatieChanged: DateTime.tryParse(decodedMap["dateLokatie"].toString()) ??
          DateTime.now(),
    );
  }

  //Create a base64 string for saving in Magister
  String? toAantekening() => [rawInfotype, rawStatus, rawLokatie, rawInhoud]
          .nonNulls
          .isEmpty
      ? null
      : base64Encode(utf8.encode(
          jsonEncode({
            "Status": rawStatus,
            "InfoType": rawInfotype,
            "Lokatie": lokatie,
            "Inhoud": inhoud,
            "originalInfoType": rawInfotypeOriginal,
            "originalStatus": rawStatusOriginal,
            "originalLokatie": lokatieOriginal,
            "originalInhoud": inhoudOriginal,
            "dateInfoType":
                (infotypeChanged ?? DateTime.now()).toIso8601String(),
            "dateStatus": (statusChanged ?? DateTime.now()).toIso8601String(),
            "dateLokatie": (lokatieChanged ?? DateTime.now()).toIso8601String(),
            "dateInhoud": (inhoudChanged ?? DateTime.now()).toIso8601String(),
          }),
        ));
}
