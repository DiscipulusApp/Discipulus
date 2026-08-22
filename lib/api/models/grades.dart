import 'dart:convert';

import 'package:discipulus/api/models/permissions.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart';

part 'grades.g.dart';

@Collection()
@Name("Grade")
class Grade {
  @Backlink(to: 'grades')
  final schoolyear = IsarLink<Schoolyear>();
  final period = IsarLink<GradePeriod>();
  final subject = IsarLink<Subject>();
  int? get subjectUUID => subject.value?.uuid;
  Id get uuid => "${schoolyear.value!.uuid}$id".hashCode;

  final int id;
  final String? cijferStr;
  double? _preParsedgrade;
  @ignore
  double get grade =>
      _preParsedgrade ??
      double.tryParse(cijferStr?.replaceAll(',', '.') ?? "-1") ??
      -1;
  final bool isVoldoende;
  final String? ingevoerdDoor;
  final DateTime? datumIngevoerd;
  // final Vak vak;
  final bool inhalen;
  final bool vrijstelling;
  final bool teltMee;
  final CijferKolom cijferKolom;
  final int cijferKolomIdEloOpdracht;
  final String? docent;
  final bool vakOntheffing;
  final bool vakVrijstelling;
  String? description;
  double? weight;
  DateTime? testDate;
  bool isEnabled = true;
  bool wasRevealed = true;
  bool isArchived = false;

  Grade({
    required this.id,
    this.cijferStr,
    this.weight,
    this.isVoldoende = true,
    this.ingevoerdDoor,
    this.datumIngevoerd,
    // required this.vak,
    this.inhalen = false,
    this.vrijstelling = false,
    this.teltMee = true,
    required this.cijferKolom,
    this.cijferKolomIdEloOpdracht = -1,
    this.docent,
    this.vakOntheffing = false,
    this.vakVrijstelling = false,
    this.isArchived = false,
  });

  factory Grade.fromJson(String str) => Grade.fromMap(json.decode(str));

  factory Grade.fromMap(Map<String, dynamic> json) => Grade(
      id: json["CijferId"] ?? json["Id"] ?? 0,
      cijferStr: json["CijferStr"],
      isVoldoende: json["IsVoldoende"] ?? true,
      ingevoerdDoor: json["IngevoerdDoor"],
      datumIngevoerd: json["DatumIngevoerd"] == null
          ? null
          : DateTime.parse(json["DatumIngevoerd"]).toUtc(),
      weight: json["Weging"] != null ? (json["Weging"] as num).toDouble() : null,
      inhalen: json["Inhalen"] ?? false,
      vrijstelling: json["Vrijstelling"] ?? false,
      teltMee: json["TeltMee"] ?? true,
      cijferKolom: json["CijferKolom"] != null
          ? CijferKolom.fromMap(json["CijferKolom"])
          : CijferKolom(),
      cijferKolomIdEloOpdracht: json["CijferKolomIdEloOpdracht"] ?? -1,
      docent: json["Docent"] ?? json["Docentcode"],
      vakOntheffing: json["VakOntheffing"] ?? false,
      vakVrijstelling: json["VakVrijstelling"] ?? false,
      isArchived: json["isArchived"] ?? json["IsArchived"] ?? false)
    ..period.value = json["CijferPeriode"] == null
        ? null
        : GradePeriod.fromMap(json["CijferPeriode"])
    ..subject.value = json["Vak"] == null ? null : Subject.fromMap(json["Vak"])
    .._preParsedgrade =
        double.tryParse(json["CijferStr"]?.replaceAll(',', '.') ?? "-1") ?? -1;

  ///This will fill the current grade with extra information such as, the weight, description and test date.
  Future<void> fill() async {
    // Check permissions
    if (!(schoolyear.value!.profile.value!.account.value?.permissions
            .hasPermissions(PermissionType.cijfers) ??
        false)) {
      return;
    }

    var res = (await schoolyear.value!.profile.value!.account.value!.api.dio.get(
            "personen/${schoolyear.value!.profile.value!.id}/aanmeldingen/${schoolyear.value!.id}/cijfers/extracijferkolominfo/$cijferKolomId"))
        .data;

    description =  res["WerkInformatieOmschrijving"] != null &&
            res["WerkInformatieOmschrijving"] != ""
        ? res["WerkInformatieOmschrijving"]
        : res["KolomOmschrijving"];
    weight = (res["Weging"] as num?)?.toDouble() ?? weight;
    testDate = res["InvoerDatum"] == null
        ? (res["WerkinformatieDatumIngevoerd"] == null
            ? null
            : DateTime.parse(res["WerkinformatieDatumIngevoerd"]).toUtc())
        : DateTime.parse(res["InvoerDatum"]).toUtc();
    isar.writeTxnSync(() {
      schoolyear.value!.grades.saveSync();
      isar.grades.putSync(this);
    });
    return;
  }

  @ignore
  int get cijferKolomId => cijferKolom.id;

  @ignore
  int get idEloOpdracht => cijferKolomIdEloOpdracht;

  Map<String, dynamic> toMap() => {
        "CijferId": id,
        "CijferStr": cijferStr,
        "IsVoldoende": isVoldoende,
        "IngevoerdDoor": ingevoerdDoor,
        "DatumIngevoerd": datumIngevoerd?.toIso8601String(),
        "Weging": weight,
        "Inhalen": inhalen,
        "Vrijstelling": vrijstelling,
        "TeltMee": teltMee,
        "CijferKolom": cijferKolom.toMap(),
        "CijferKolomIdEloOpdracht": cijferKolomIdEloOpdracht,
        "Docent": docent,
        "VakOntheffing": vakOntheffing,
        "VakVrijstelling": vakVrijstelling,
        "isArchived": isArchived,
        "CijferPeriode": period.value?.toMap(),
        "Vak": subject.value?.toMap(),
      };
}

class GradeChange {
  double averageBefore;
  double avarageAfter;
  double get change => (!avarageAfter.isNaN && !averageBefore.isNaN)
      ? avarageAfter - averageBefore
      : 0;

  GradeChange({required this.avarageAfter, required this.averageBefore});
}

@embedded
class CijferKolom {
  final int id;
  final String? kolomNaam;
  final String? kolomNummer;
  final String kolomVolgNummer;
  final String? kolomKop;
  final String? kolomOmschrijving;

  /// 1. Grade
  /// 2. Average
  final int kolomSoort;
  final bool isHerkansingKolom;
  final bool isDocentKolom;
  final bool heeftOnderliggendeKolommen;
  final bool isPtaKolom;

  CijferKolom({
    this.id = 0,
    this.kolomNaam,
    this.kolomNummer,
    this.kolomVolgNummer = "",
    this.kolomKop,
    this.kolomOmschrijving = "",
    this.kolomSoort = 0,
    this.isHerkansingKolom = false,
    this.isDocentKolom = false,
    this.heeftOnderliggendeKolommen = false,
    this.isPtaKolom = false,
  });

  factory CijferKolom.fromJson(String str) =>
      CijferKolom.fromMap(json.decode(str));

  factory CijferKolom.fromMap(Map<String, dynamic> json) => CijferKolom(
        id: json["Id"] ?? 0,
        kolomNaam: json["KolomNaam"],
        kolomNummer: json["KolomNummer"],
        kolomVolgNummer: json["KolomVolgNummer"]?.toString() ?? "",
        kolomKop: json["KolomKop"],
        kolomOmschrijving: json["KolomOmschrijving"],
        kolomSoort: json["KolomSoort"] ?? 0,
        isHerkansingKolom: json["IsHerkansingKolom"] ?? false,
        isDocentKolom: json["IsDocentKolom"] ?? false,
        heeftOnderliggendeKolommen: json["HeeftOnderliggendeKolommen"] ?? false,
        isPtaKolom: json["IsPTAKolom"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "KolomNaam": kolomNaam,
        "KolomNummer": kolomNummer,
        "KolomVolgNummer": kolomVolgNummer,
        "KolomKop": kolomKop,
        "KolomOmschrijving": kolomOmschrijving,
        "KolomSoort": kolomSoort,
        "IsHerkansingKolom": isHerkansingKolom,
        "IsDocentKolom": isDocentKolom,
        "HeeftOnderliggendeKolommen": heeftOnderliggendeKolommen,
        "IsPTAKolom": isPtaKolom,
      };
}

@Collection()
@Name("GradePeriod")
class GradePeriod {
  @Backlink(to: 'period')
  final grades = IsarLinks<Grade>();
  @Backlink(to: 'periods')
  final schoolyear = IsarLink<Schoolyear>();

  final subjects = IsarLinks<Subject>();

  Id get uuid => "${schoolyear.value!.id}$id".hashCode;

  final int id;
  final String naam;
  final int volgNummer;
  final DateTime? start;
  final DateTime? end;

  GradePeriod({
    this.start,
    this.end,
    this.id = 0,
    this.naam = "",
    this.volgNummer = 0,
  });

  factory GradePeriod.fromJson(String str) =>
      GradePeriod.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GradePeriod.fromMap(Map<String, dynamic> json) => GradePeriod(
        id: json["Id"] ?? 0,
        naam: json["Naam"] ?? json["Omschrijving"] ?? "",
        volgNummer: json["VolgNummer"] ?? 0,
        start: json["Start"] != null
            ? DateTime.parse(json["Start"]).toUtc()
            : null,
        end: json["Einde"] != null
            ? DateTime.parse(json["Einde"]).toUtc()
            : null,
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Naam": naam,
        "VolgNummer": volgNummer,
      };
}

@embedded
class Vak {
  final int id;
  final String afkorting;
  final String omschrijving;
  final int volgnr;

  Vak({
    this.id = 0,
    this.afkorting = "",
    this.omschrijving = "",
    this.volgnr = 0,
  });

  factory Vak.fromJson(String str) => Vak.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Vak.fromMap(Map<String, dynamic> json) => Vak(
        id: json["Id"] ?? 0,
        afkorting: json["Afkorting"] ?? "",
        omschrijving: json["Omschrijving"] ?? json["Naam"] ?? "",
        volgnr: json["Volgnr"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Afkorting": afkorting,
        "Omschrijving": omschrijving,
        "Volgnr": volgnr,
      };
}
