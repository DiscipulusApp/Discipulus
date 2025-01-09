import 'dart:convert';

import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/core/spotlight_search.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';

part 'studiewijzers.g.dart';

///This is the same for projects
@Collection()
@Name("Studiewijzer")
class Studiewijzer with SpotlightSearchElementMixin {
  @Backlink(to: 'studiewijzers')
  final profile = IsarLink<Profile>();
  Id get uuid => "${profile.value!.uuid}$id".hashCode;

  final int id;
  final DateTime van;
  final DateTime totEnMet;
  final String rawTitel;
  bool? isZichtbaar;
  final bool inLeerlingArchief;
  final onderdelen = IsarLinks<StudiewijzerOnderdeel>();
  final String? selfUrl;

  bool isFavorite = false;
  @ignore
  String get titel => customName ?? rawTitel;

  set titel(String? newTitle) {
    customName = newTitle;
    updateSpotlight();
  }

  String? customName;

  @Name("lastUsed")
  DateTime? lastUsed;

  @Name("customEmojiIcon")
  String? customEmojiIcon;
  List<int> groupedUUIDS = [];
  String? groupName;

  Studiewijzer({
    required this.id,
    required this.van,
    required this.totEnMet,
    required this.rawTitel,
    required this.isZichtbaar,
    required this.inLeerlingArchief,
    this.selfUrl,
    this.lastUsed,
    this.customEmojiIcon,
  });

  factory Studiewijzer.fromJson(String str) =>
      Studiewijzer.fromMap(json.decode(str));

  factory Studiewijzer.fromMap(Map<String, dynamic> json) => Studiewijzer(
      id: json["Id"],
      van: DateTime.parse(json["Van"]).toUtc(),
      totEnMet: DateTime.parse(json["TotEnMet"]).toUtc(),
      rawTitel: json["Titel"],
      isZichtbaar: json["IsZichtbaar"],
      inLeerlingArchief: json["InLeerlingArchief"],
      selfUrl: json["Links"] != null
          ? List<BronLink>.from(json["Links"].map((x) => BronLink.fromMap(x)))
              .firstWhere((l) => l.rel == "Self")
              .href
              .replaceAll("/api/", "")
          : null);

  Future<void> fill() async {
    assert(selfUrl != null, "Can't find correct URL");

    if (!(profile.value!.account.value?.permissions
            .hasPermissions(PermissionType.studiewijzers) ??
        false)) {
      return;
    }

    var res = (await profile.value!.account.value!.api.dio.get(selfUrl!)).data;

    List<StudiewijzerOnderdeel> tempOnderdelen =
        List<StudiewijzerOnderdeel>.from(res["Onderdelen"]["Items"].map(
      (x) => StudiewijzerOnderdeel.fromMap(x)..studiewijzer.value = this,
    ));

    onderdelen
      ..addAll(tempOnderdelen)
      ..toList().sort(((a, b) => a.volgnummer.compareTo(b.volgnummer)));

    isar.writeTxnSync(() {
      isar.studiewijzerOnderdeels.putAllSync(onderdelen
          .map(
            (x) => x
              ..omschrijving =
                  isar.studiewijzerOnderdeels.getSync(x.uuid)?.omschrijving,
          )
          .toList());
      onderdelen.saveSync();
    });
    isZichtbaar = res["IsZichtbaar"];
    updateSpotlight();
  }

  void save() => isar.writeTxnSync(() {
        isar.studiewijzers.putSync(this);
      });

  @override
  @ignore
  SpotlightSearchElement? get spotlightItem =>
      profile.value?.settings.spotlightIndexStudiewijzers == true
          ? SpotlightSearchElement(
              domainIdentifier:
                  "dev.harrydekat.discipulus.studiewijzer.${profile.value?.uuid}",
              uniqueIdentifier: "studiewijzer_$uuid",
              expirationDate: totEnMet,
              attributeSet: CoreSpotlightItemAttributeSet(
                UTType.folder,
                title: titel,
                lastUsedDate: lastUsed,
                contentDescription: (() {
                  late String desc;
                  if (lastUsed == null) {
                    desc = "Ongebruikte studiewijzer";
                  } else if (onderdelen.isEmpty) {
                    desc = "Studiewijzer zonder onderdelen";
                  } else {
                    desc = "Studiewijzer met ${onderdelen.length} onderdelen";
                  }
                  if (isar.profiles.countSync() > 1) {
                    desc += " van ${profile.value?.name}";
                  }
                  return desc;
                })(),
                keywords: [
                  for (String item in [
                    "magister",
                    "discipulus",
                    "studiewijzers",
                    "studiewijzer"
                  ]) ...[item.capitalized, item.toLowerCase()]
                ],
              ),
            )
          : null;
}

@Collection()
@Name("StudiewijzerOnderdeel")
class StudiewijzerOnderdeel {
  final bronnen = IsarLinks<Bron>();
  @Backlink(to: 'onderdelen')
  final studiewijzer = IsarLink<Studiewijzer>();
  Id get uuid => "${studiewijzer.value!.uuid}$id".hashCode;

  final int id;
  List<BronLink>? links;
  DateTime? van;
  DateTime? totEnMet;
  final String titel;
  String omschrijvingShort;
  String? omschrijving;
  final bool isZichtbaar;
  final int kleur;
  @ignore
  Color get color {
    switch (kleur) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.cyan;
      case 6:
        return Colors.deepOrange;
      case 7:
        return Colors.indigo;
      case 8:
        return Colors.blueGrey;
      case 9:
        return Colors.deepPurple;
      case 10:
        return Colors.orange;
      case 11:
        return Colors.yellowAccent;
      case 12:
        return Colors.greenAccent;
      case 13:
        return Colors.redAccent;
      case 14:
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  final int volgnummer;
  final String selfUrl;

  StudiewijzerOnderdeel(
      {this.id = 0,
      this.links,
      this.van,
      this.totEnMet,
      this.titel = "",
      this.omschrijvingShort = "",
      this.isZichtbaar = false,
      this.kleur = 0,
      this.volgnummer = 0,
      this.selfUrl = ""});

  factory StudiewijzerOnderdeel.fromJson(String str) =>
      StudiewijzerOnderdeel.fromMap(json.decode(str));

  factory StudiewijzerOnderdeel.fromMap(Map<String, dynamic> json) =>
      StudiewijzerOnderdeel(
        id: json["Id"],
        links: json["Links"] == null
            ? []
            : List<BronLink>.from(
                json["Links"]!.map((x) => BronLink.fromMap(x))),
        van: json["Van"],
        totEnMet: json["TotEnMet"],
        titel: json["Titel"],
        omschrijvingShort: json["Omschrijving"],
        isZichtbaar: json["IsZichtbaar"],
        kleur: json["Kleur"],
        volgnummer: json["Volgnummer"],
        selfUrl:
            List<BronLink>.from(json["Links"].map((x) => BronLink.fromMap(x)))
                .firstWhere((l) => l.rel == "Self")
                .href
                .replaceAll("/api/", ""),
      );

  Future<void> fill() async {
    var res = (await studiewijzer.value!.profile.value!.account.value!.api.dio
            .get("$selfUrl?gebruikMappenStructuur=true"))
        .data;

    if (!(studiewijzer.value?.profile.value!.account.value?.permissions
            .hasPermissions(PermissionType.studiewijzers) ??
        false)) {
      return;
    }

    omschrijving = res["Omschrijving"];
    bronnen.addAll(List<Bron>.from(res["Bronnen"].map((x) =>
        Bron.fromMap(x)..profile.value = studiewijzer.value!.profile.value!)));
    isar.writeTxnSync(() {
      isar.brons.putAllSync(bronnen.toList());
      bronnen.saveSync();
      isar.studiewijzerOnderdeels.putSync(this);
    });
  }
}
