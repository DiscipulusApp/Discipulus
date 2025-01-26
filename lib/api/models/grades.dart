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
  });

  factory Grade.fromJson(String str) => Grade.fromMap(json.decode(str));

  factory Grade.fromMap(Map<String, dynamic> json) => Grade(
      id: json["CijferId"],
      cijferStr: json["CijferStr"],
      isVoldoende: json["IsVoldoende"],
      ingevoerdDoor: json["IngevoerdDoor"],
      datumIngevoerd: json["DatumIngevoerd"] == null
          ? null
          : DateTime.parse(json["DatumIngevoerd"]).toUtc(),
      weight: json["Weging"],
      inhalen: json["Inhalen"],
      vrijstelling: json["Vrijstelling"],
      teltMee: json["TeltMee"],
      cijferKolom: CijferKolom.fromMap(json["CijferKolom"]),
      cijferKolomIdEloOpdracht: json["CijferKolomIdEloOpdracht"],
      docent: json["Docent"],
      vakOntheffing: json["VakOntheffing"],
      vakVrijstelling: json["VakVrijstelling"])
    ..period.value = json["CijferPeriode"] == null
        ? null
        : GradePeriod.fromMap(json["CijferPeriode"])
    ..subject.value = Subject.fromMap(json["Vak"])
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
            "personen/${schoolyear.value!.profile.value!.id}/aanmeldingen/${schoolyear.value!.id}/cijfers/extracijferkolominfo/${cijferKolom.id}"))
        .data;

    weight = res["Weging"];
    testDate = res["WerkinformatieDatumIngevoerd"] == null
        ? null
        : DateTime.parse(res["WerkinformatieDatumIngevoerd"]);
    description = res["WerkInformatieOmschrijving"] != null &&
            res["WerkInformatieOmschrijving"] != ""
        ? res["WerkInformatieOmschrijving"]
        : res["KolomOmschrijving"];
    isar.writeTxnSync(() {
      schoolyear.value!.grades.saveSync();
      isar.grades.putSync(this);
    });
  }
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
        id: json["Id"],
        kolomNaam: json["KolomNaam"],
        kolomNummer: json["KolomNummer"],
        kolomVolgNummer: json["KolomVolgNummer"],
        kolomKop: json["KolomKop"],
        kolomOmschrijving: json["KolomOmschrijving"],
        kolomSoort: json["KolomSoort"],
        isHerkansingKolom: json["IsHerkansingKolom"],
        isDocentKolom: json["IsDocentKolom"],
        heeftOnderliggendeKolommen: json["HeeftOnderliggendeKolommen"],
        isPtaKolom: json["IsPTAKolom"],
      );
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
    required this.id,
    required this.naam,
    required this.volgNummer,
  });

  factory GradePeriod.fromJson(String str) =>
      GradePeriod.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GradePeriod.fromMap(Map<String, dynamic> json) => GradePeriod(
        id: json["Id"],
        naam: json["Naam"],
        volgNummer: json["VolgNummer"],
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
        id: json["Id"],
        afkorting: json["Afkorting"],
        omschrijving: json["Omschrijving"],
        volgnr: json["Volgnr"],
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Afkorting": afkorting,
        "Omschrijving": omschrijving,
        "Volgnr": volgnr,
      };
}
