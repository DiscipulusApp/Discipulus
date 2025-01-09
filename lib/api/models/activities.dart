import 'dart:convert';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:isar/isar.dart';

part 'activities.g.dart';

@Collection()
@Name("Activity")
class Activity {
  @Backlink(to: 'activities')
  final profile = IsarLink<Profile>();
  final elements = IsarLinks<ActivityElement>();

  Id get uuid => "${profile.value!.uuid}$id".hashCode;

  int id;
  String titel;
  String? details;
  DateTime zichtbaarVanaf;
  DateTime zichtbaarTotEnMet;
  int maximumAantalInschrijvingenPerActiviteit;
  int minimumAantalInschrijvingenPerActiviteit;
  int status;
  DateTime startInschrijfdatum;
  DateTime eindeInschrijfdatum;
  int toegangstype;
  int aantalInschrijvingen;

  String elementsLink;

  Activity(
      {required this.id,
      required this.titel,
      required this.details,
      required this.zichtbaarVanaf,
      required this.zichtbaarTotEnMet,
      required this.maximumAantalInschrijvingenPerActiviteit,
      required this.minimumAantalInschrijvingenPerActiviteit,
      required this.status,
      required this.startInschrijfdatum,
      required this.eindeInschrijfdatum,
      required this.toegangstype,
      required this.aantalInschrijvingen,
      required this.elementsLink});

  factory Activity.fromJson(String str) => Activity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
        id: json["Id"],
        titel: json["Titel"],
        details: json["Details"],
        zichtbaarVanaf: DateTime.parse(json["ZichtbaarVanaf"]).toUtc(),
        zichtbaarTotEnMet: DateTime.parse(json["ZichtbaarTotEnMet"]),
        maximumAantalInschrijvingenPerActiviteit:
            json["MaximumAantalInschrijvingenPerActiviteit"],
        minimumAantalInschrijvingenPerActiviteit:
            json["MinimumAantalInschrijvingenPerActiviteit"],
        status: json["Status"],
        startInschrijfdatum:
            DateTime.parse(json["StartInschrijfdatum"]).toUtc(),
        eindeInschrijfdatum:
            DateTime.parse(json["EindeInschrijfdatum"]).toUtc(),
        toegangstype: json["Toegangstype"],
        aantalInschrijvingen: json["AantalInschrijvingen"],
        elementsLink: List<Link>.from(json["Links"].map((x) => Link.fromMap(x)))
            .where((l) => l.rel == "Self")
            .firstOrNull!
            .href
            .replaceAll("/api/", ""),
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Titel": titel,
        "Details": details,
        "ZichtbaarVanaf": zichtbaarVanaf.toIso8601String(),
        "ZichtbaarTotEnMet": zichtbaarTotEnMet.toIso8601String(),
        "MaximumAantalInschrijvingenPerActiviteit":
            maximumAantalInschrijvingenPerActiviteit,
        "MinimumAantalInschrijvingenPerActiviteit":
            minimumAantalInschrijvingenPerActiviteit,
        "Status": status,
        "StartInschrijfdatum": startInschrijfdatum.toIso8601String(),
        "EindeInschrijfdatum": eindeInschrijfdatum.toIso8601String(),
        "Toegangstype": toegangstype,
        "AantalInschrijvingen": aantalInschrijvingen,
      };

  /// fetches the elements that you can sign up for
  Future<void> getElements() async {
    // Check permissions
    if (!(profile.value?.account.value?.permissions
            .hasPermissions(PermissionType.activiteiten) ??
        false)) {
      return;
    }

    // Get data
    var res = (await profile.value!.account.value!.api.dio
            .get("$elementsLink/onderdelen"))
        .data;
    var newElements = List<ActivityElement>.from(res["Items"]
        .map((x) => ActivityElement.fromMap(x)..activity.value = this));

    // Add to classes
    elements.addAll(newElements);

    // Write to internal database
    isar.writeTxnSync(() {
      isar.activityElements.putAllSync(elements.toList());
      isar.activitys.putSync(this);
      elements.saveSync();
    });
  }

  /// Weather or not a user can sign up for this activity
  bool get canSignUp =>
      aantalInschrijvingen < maximumAantalInschrijvingenPerActiviteit &&
      DateTime.now().difference(eindeInschrijfdatum).isNegative &&
      !DateTime.now().difference(startInschrijfdatum).isNegative;
}

@Collection()
@Name("ActivityElement")
class ActivityElement {
  @Backlink(to: 'elements')
  final activity = IsarLink<Activity>();

  Id get uuid => "${activity.value!.uuid}$id".hashCode;

  int id;
  DateTime startInschrijfdatum;
  DateTime eindeInschrijfdatum;
  String titel;
  int volgnummer;
  String? details;
  int activiteitId;
  int maxAantalDeelnemers;
  int minAantalDeelnemers;
  int kleurstelling;
  bool isIngeschreven;
  bool isVerplichtIngeschreven;
  int aantalPlaatsenBeschikbaar;
  bool isOpInTeSchrijven;
  final bronnen = IsarLinks<Bron>();

  String subscriptionLink;
  String selfLink;

  ActivityElement({
    required this.id,
    required this.startInschrijfdatum,
    required this.eindeInschrijfdatum,
    required this.titel,
    required this.volgnummer,
    required this.details,
    required this.activiteitId,
    required this.maxAantalDeelnemers,
    required this.minAantalDeelnemers,
    required this.kleurstelling,
    required this.isIngeschreven,
    required this.isVerplichtIngeschreven,
    required this.aantalPlaatsenBeschikbaar,
    required this.isOpInTeSchrijven,
    required this.subscriptionLink,
    required this.selfLink,
  });

  factory ActivityElement.fromJson(String str) =>
      ActivityElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ActivityElement.fromMap(Map<String, dynamic> json) => ActivityElement(
        id: json["Id"],
        startInschrijfdatum:
            DateTime.parse(json["StartInschrijfdatum"]).toUtc(),
        eindeInschrijfdatum:
            DateTime.parse(json["EindeInschrijfdatum"]).toUtc(),
        titel: json["Titel"],
        volgnummer: json["Volgnummer"],
        details: json["Details"],
        activiteitId: json["ActiviteitId"],
        maxAantalDeelnemers: json["MaxAantalDeelnemers"],
        minAantalDeelnemers: json["MinAantalDeelnemers"],
        kleurstelling: json["Kleurstelling"],
        isIngeschreven: json["IsIngeschreven"],
        isVerplichtIngeschreven: json["IsVerplichtIngeschreven"],
        aantalPlaatsenBeschikbaar: json["AantalPlaatsenBeschikbaar"],
        isOpInTeSchrijven: json["IsOpInTeSchrijven"],
        subscriptionLink:
            List<Link>.from(json["Links"].map((x) => Link.fromMap(x)))
                .where((l) => l.rel == "Subscriptions")
                .firstOrNull!
                .href
                .replaceAll("/api/", ""),
        selfLink: List<Link>.from(json["Links"].map((x) => Link.fromMap(x)))
            .where((l) => l.rel == "Self")
            .firstOrNull!
            .href
            .replaceAll("/api/", ""),
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "StartInschrijfdatum": startInschrijfdatum.toIso8601String(),
        "EindeInschrijfdatum": eindeInschrijfdatum.toIso8601String(),
        "Titel": titel,
        "Volgnummer": volgnummer,
        "Details": details,
        "ActiviteitId": activiteitId,
        "MaxAantalDeelnemers": maxAantalDeelnemers,
        "MinAantalDeelnemers": minAantalDeelnemers,
        "Kleurstelling": kleurstelling,
        "IsIngeschreven": isIngeschreven,
        "IsVerplichtIngeschreven": isVerplichtIngeschreven,
        "AantalPlaatsenBeschikbaar": aantalPlaatsenBeschikbaar,
        "IsOpInTeSchrijven": isOpInTeSchrijven,
      };

  /// sign up for this activity
  Future<void> signUp() async {
    await activity.value!.profile.value!.account.value!.api.dio
        .post(subscriptionLink, data: {
      "persoonId": activity.value!.profile.value!.id,
      "activiteitId": activity.value!.id,
      "onderdeelId": id
    }).whenComplete(() async {
      // When we have subscribed the local database should reflect that
      isIngeschreven = true;
      aantalPlaatsenBeschikbaar -= 1;
      activity.value!.aantalInschrijvingen += 1;
      isar.writeTxnSync(() {
        isar.activitys.putSync(activity.value!);
        isar.activityElements.putSync(this);
      });
      await activity.value!.getElements();
    });
  }

  /// Remove sign up for activity
  Future<void> removeSignUp() async {
    await activity.value!.profile.value!.account.value!.api.dio
        .delete(subscriptionLink)
        .whenComplete(() async {
      // When we have subscribed the local database should reflect that
      isIngeschreven = false;
      aantalPlaatsenBeschikbaar += 1;
      activity.value!.aantalInschrijvingen -= 1;
      isar.writeTxnSync(() {
        isar.activitys.putSync(activity.value!);
        isar.activityElements.putSync(this);
      });
      await activity.value!.getElements();
    });
  }

  bool get canSignUp => isOpInTeSchrijven && activity.value!.canSignUp;
}
