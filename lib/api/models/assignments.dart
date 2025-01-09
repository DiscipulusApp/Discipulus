import 'dart:convert';

import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/core/spotlight_search.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/calendar.dart' hide EnumValues;
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/utils/extensions.dart';

part 'assignments.g.dart';

@Collection()
@Name("Assignment")
class Assignment with SpotlightSearchElementMixin {
  @Backlink(to: 'assignments')
  final profile = IsarLink<Profile>();

  final bronnen = IsarLinks<Bron>();
  final versies = IsarLinks<AssignmentVersion>();

  Id get uuid => id;

  final int id;
  final List<BronLink> links;
  final String titel;
  final String vak;
  final DateTime inleverenVoor;
  final DateTime? ingeleverdOp;
  @enumerated
  VersieStatus statusLaatsteOpdrachtVersie;
  final int laatsteOpdrachtVersienummer;
  List<Docenten>? docenten;
  final String omschrijving;
  final String beoordeling;
  final DateTime? beoordeeldOp;
  final bool opnieuwInleveren;
  bool afgesloten;
  bool magInleveren;

  Assignment({
    required this.id,
    required this.links,
    required this.titel,
    required this.vak,
    required this.inleverenVoor,
    this.ingeleverdOp,
    required this.statusLaatsteOpdrachtVersie,
    required this.laatsteOpdrachtVersienummer,
    this.docenten,
    required this.omschrijving,
    required this.beoordeling,
    this.beoordeeldOp,
    required this.opnieuwInleveren,
    required this.afgesloten,
    required this.magInleveren,
  });

  factory Assignment.fromJson(String str, Magister magister) =>
      Assignment.fromMap(json.decode(str), magister);

  factory Assignment.fromMap(Map<String, dynamic> json, Magister magister) =>
      Assignment(
        id: json["Id"],
        links:
            List<BronLink>.from(json["Links"].map((x) => BronLink.fromMap(x))),
        titel: json["Titel"].toString().capitalized,
        vak: json["Vak"],
        inleverenVoor: DateTime.parse(json["InleverenVoor"]).toUtc(),
        ingeleverdOp: json["IngeleverdOp"] == null
            ? null
            : DateTime.parse(json["IngeleverdOp"]).toUtc(),
        statusLaatsteOpdrachtVersie:
            versionValues.map[json["StatusLaatsteOpdrachtVersie"].toString()] ??
                VersieStatus.geen,
        laatsteOpdrachtVersienummer: json["LaatsteOpdrachtVersienummer"],
        docenten: json["Docenten"] == null
            ? []
            : List<Docenten>.from(
                json["Docenten"]!.map((x) => Docenten.fromMap(x))),
        omschrijving: json["Omschrijving"],
        beoordeling: json["Beoordeling"],
        beoordeeldOp: json["BeoordeeldOp"] == null
            ? null
            : DateTime.parse(json["BeoordeeldOp"]).toUtc(),
        opnieuwInleveren: json["OpnieuwInleveren"],
        afgesloten: json["Afgesloten"],
        magInleveren: json["MagInleveren"],
      );

  @ignore
  AssignmentStatus get status => AssignmentStatus.getStatus(this);

  Future<void> fill() async {
    // Check permissions
    if (!(profile.value?.account.value?.permissions
            .hasPermissions(PermissionType.eloOpdracht) ??
        false)) {
      return;
    }

    var res = (await profile.value!.account.value!.api.dio.get(links
            .firstWhere((l) => l.rel == "Self")
            .href
            .replaceAll("/api/", "")))
        .data;
    bronnen.addAll(List<Bron>.from(res["Bijlagen"]
        .map((x) => Bron.fromMap(x)..profile.value = profile.value)));
    versies.addAll(List<AssignmentVersion>.from(res["VersieNavigatieItems"]
            .map((x) => AssignmentVersion.fromMap(x)))
        .map((e) => e..assignment.value = this));
    isar.writeTxnSync(() {
      isar.brons.putAllSync(bronnen.toList());
      isar.assignmentVersions.putAllSync(versies.toList());
      bronnen.saveSync();
      versies.saveSync();
      isar.assignments.putSync(this);
    });
    statusLaatsteOpdrachtVersie =
        versionValues.map[res["StatusLaatsteOpdrachtVersie"].toString()] ??
            VersieStatus.geen;
    magInleveren = res["MagInleveren"];
    docenten = res["Docenten"] == null
        ? []
        : List<Docenten>.from(res["Docenten"]!.map((x) => Docenten.fromMap(x)));
  }

  @override
  @ignore
  SpotlightSearchElement? get spotlightItem =>
      profile.value?.settings.spotlightIndexAssignments == true
          ? SpotlightSearchElement(
              domainIdentifier:
                  "dev.harrydekat.discipulus.assignment.${profile.value?.uuid}",
              uniqueIdentifier: "assignment$uuid",
              attributeSet: CoreSpotlightItemAttributeSet(
                UTType.item,
                title: titel,
                dueDate: inleverenVoor,
                contentDescription: (() {
                  late String desc;
                  desc =
                      "Opdracht met inleverdatum van ${inleverenVoor.formattedDateAndTimWithoutYear}";
                  if (isar.profiles.countSync() > 1) {
                    desc += " van ${profile.value?.name}";
                  }
                  return desc;
                })(),
                keywords: [
                  for (String item in [
                    "magister",
                    "discipulus",
                    "opdracht",
                    "opdrachten"
                  ]) ...[item.capitalized, item.toLowerCase()]
                ],
              ),
            )
          : null;
}

@collection
@Name("AssignmentVersion")
class AssignmentVersion {
  @Backlink(to: 'versies')
  final assignment = IsarLink<Assignment>();

  Id get uuid => "$id${assignment.value!.uuid}".hashCode;

  final int id;
  String vak;
  @enumerated
  VersieStatus status;
  int opdrachtId;
  String? leerlingOpmerking;
  String? docentOpmerking;
  final leerlingBijlagen = IsarLinks<Bron>();
  final feedbackBijlagen = IsarLinks<Bron>();
  DateTime? inleverenVoor;
  DateTime? ingeleverdOp;
  DateTime? gestartOp;
  String? beoordeling;
  DateTime? beoordeeldOp;
  int versieNummer;
  bool isTeLaat;
  final String omschrijving;
  final List<BronLink> links;

  AssignmentVersion(
      {this.id = 0,
      this.vak = "",
      this.status = VersieStatus.geen,
      this.opdrachtId = 0,
      this.leerlingOpmerking,
      this.docentOpmerking,
      this.inleverenVoor,
      this.ingeleverdOp,
      this.gestartOp,
      this.beoordeling,
      this.beoordeeldOp,
      this.versieNummer = 0,
      this.isTeLaat = false,
      this.omschrijving = "",
      this.links = const []});

  factory AssignmentVersion.fromJson(String str) =>
      AssignmentVersion.fromMap(json.decode(str));

  factory AssignmentVersion.fromMap(Map<String, dynamic> json) =>
      AssignmentVersion(
        id: json["Id"],
        links:
            List<BronLink>.from(json["Links"].map((x) => BronLink.fromMap(x))),
        omschrijving: json["Omschrijving"],
      );

  Future<void> handInVersion({
    String? comment,
    List<UploadedAttachment> attachments = const [],
  }) async {
    assert(comment != null || attachments.isNotEmpty);

    if (!(assignment.value?.profile.value?.account.value?.permissions
            .hasPermissions(PermissionType.eloOpdracht,
                statuses: [PermissionStatus.create]) ??
        false)) {
      return;
    }

    Magister magister = assignment.value!.profile.value!.account.value!.api;
    String path =
        links.firstWhere((l) => l.rel == "Self").href.replaceAll("/api/", "");

    magister.dio.post(
      path,
      queryParameters: {"opdrachtId": opdrachtId},
      data: {
        "Id": id,
        "Vak": vak,
        "Status": versionValues.reverse[status],
        "OpdrachtId": opdrachtId,
        "LeerlingOpmerking": leerlingOpmerking,
        "DocentOpmerking": docentOpmerking,
        "InleverenVoor": inleverenVoor?.toIso8601String(),
        "IngeleverdOp": ingeleverdOp?.toIso8601String(),
        "GestartOp": gestartOp?.toIso8601String(),
        "Beoordeling": beoordeling,
        "BeoordeeldOp": beoordeeldOp?.toIso8601String(),
        "VersieNummer": versieNummer,
        "IsTeLaat": isTeLaat,
        "Omschrijving": omschrijving,
        "LeerlingBijlagen": [
          for (UploadedAttachment attachment in attachments)
            {
              "Id": 0,
              "Naam": attachment.naam,
              "ContentType": attachment.type,
              "Datum": null,
              "Grootte": 0,
              "Url": "",
              "UniqueId": attachment.storageId,
              "BronSoort": 1,
              "Links": null,
            }
        ]
      },
    );
  }

  Future<void> fill() async {
    var json = (await assignment.value!.profile.value!.account.value!.api.dio
            .get(links
                .firstWhere((l) => l.rel == "Self")
                .href
                .replaceAll("/api/", "")))
        .data;
    vak = json["Vak"];
    status = versionValues.map[json["Status"].toString()] ?? VersieStatus.geen;
    opdrachtId = json["OpdrachtId"];
    leerlingOpmerking = json["LeerlingOpmerking"];
    docentOpmerking = json["DocentOpmerking"];
    inleverenVoor = json["InleverenVoor"] != null
        ? DateTime.parse(json["InleverenVoor"]).toUtc()
        : null;
    ingeleverdOp = json["IngeleverdOp"] != null
        ? DateTime.parse(json["IngeleverdOp"]).toUtc()
        : null;
    gestartOp = json["GestartOp"] != null
        ? DateTime.parse(json["GestartOp"]).toUtc()
        : null;
    beoordeling = json["Beoordeling"];
    beoordeeldOp = json["BeoordeeldOp"] != null
        ? DateTime.parse(json["BeoordeeldOp"])
        : null;
    versieNummer = json["VersieNummer"];
    isTeLaat = json["IsTeLaat"];
    leerlingBijlagen.addAll(List<Bron>.from(json["LeerlingBijlagen"].map((x) =>
        Bron.fromMap(x)..profile.value = assignment.value!.profile.value)));
    feedbackBijlagen.addAll(List<Bron>.from(json["FeedbackBijlagen"].map((x) =>
        Bron.fromMap(x)..profile.value = assignment.value!.profile.value)));
    isar.writeTxnSync(() {
      isar.brons.putAllSync([...leerlingBijlagen, ...feedbackBijlagen]);
      leerlingBijlagen.saveSync();
      feedbackBijlagen.saveSync();
      isar.assignmentVersions.putSync(this);
    });
  }
}

final versionValues = EnumValues({
  "0": VersieStatus.alle,
  "1": VersieStatus.ingeleverd,
  "2": VersieStatus.openstaand,
  "3": VersieStatus.beoordeeld,
  "4": VersieStatus.geen,
  "5": VersieStatus.afgesloten,
});

enum VersieStatus { alle, ingeleverd, openstaand, beoordeeld, geen, afgesloten }

enum AssignmentStatus {
  notStarted,
  toBeSubmitted,
  submitted,
  graded,
  closed;

  static AssignmentStatus getStatus(Assignment assignment) {
    final ingeleverdOp = assignment.ingeleverdOp;
    final inleverenVoor = assignment.inleverenVoor;
    final beoordeeldOp = assignment.beoordeeldOp;
    final afgesloten = assignment.afgesloten;
    final statusLaatsteOpdrachtVersie = assignment.statusLaatsteOpdrachtVersie;
    final magInleveren = assignment.magInleveren;

    if (afgesloten == true) {
      return AssignmentStatus.closed;
    }

    if (beoordeeldOp != null) {
      return AssignmentStatus.graded;
    }

    if (ingeleverdOp != null) {
      return AssignmentStatus.submitted;
    }

    if (statusLaatsteOpdrachtVersie == VersieStatus.geen ||
        (statusLaatsteOpdrachtVersie == VersieStatus.geen &&
            magInleveren == true &&
            ingeleverdOp == null)) {
      return AssignmentStatus.toBeSubmitted;
    }

    if (inleverenVoor.isAfter(DateTime.now()) &&
        ingeleverdOp == null &&
        beoordeeldOp == null) {
      return AssignmentStatus.toBeSubmitted;
    }

    return AssignmentStatus.notStarted;
  }
}

extension AssignmentStatusExt on AssignmentStatus {
  String get name {
    switch (this) {
      case AssignmentStatus.notStarted:
        return "Niet begonnen";
      case AssignmentStatus.toBeSubmitted:
        return "In te leveren";
      case AssignmentStatus.submitted:
        return "Ingeleverd";
      case AssignmentStatus.graded:
        return "Beoordeeld";
      case AssignmentStatus.closed:
        return "Afgesloten";
    }
  }
}
