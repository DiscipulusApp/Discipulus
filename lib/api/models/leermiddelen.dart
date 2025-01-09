import 'dart:convert';

import 'package:discipulus/api/magister_api_dart.dart';

class Leermiddel extends MagisterBase {
  final int id;
  final int materiaalType;
  final List<Link> links;
  final String titel;
  final String uitgeverij;
  final int status;
  final DateTime start;
  final DateTime eind;
  final String ean;
  final String? previewImageUrl;
  final Vak vak;

  Leermiddel(
    super.magister, {
    required this.id,
    required this.materiaalType,
    required this.links,
    required this.titel,
    required this.uitgeverij,
    required this.status,
    required this.start,
    required this.eind,
    required this.ean,
    this.previewImageUrl,
    required this.vak,
  });

  factory Leermiddel.fromJson(String str, Magister magister) =>
      Leermiddel.fromMap(json.decode(str), magister);

  factory Leermiddel.fromMap(Map<String, dynamic> json, Magister magister) =>
      Leermiddel(
        magister,
        id: json["Id"],
        materiaalType: json["MateriaalType"],
        links: List<Link>.from(json["Links"].map((x) => Link.fromMap(x))),
        titel: json["Titel"],
        uitgeverij: json["Uitgeverij"],
        status: json["Status"],
        start: DateTime.parse(json["Start"]).toUtc(),
        eind: DateTime.parse(json["Eind"]).toUtc(),
        ean: json["EAN"],
        previewImageUrl: json["PreviewImageUrl"],
        vak: Vak.fromMap(json["Vak"]),
      );

  Future<Uri> get redirectLocation async => Uri.parse((await magister.dio.get(
          "${links.firstWhere((l) => l.rel == "content").href.replaceAll("/api/", "")}?redirect_type=body"))
      .data["location"]);
}

class Link {
  final String rel;
  final String href;

  Link({
    required this.rel,
    required this.href,
  });

  factory Link.fromJson(String str) => Link.fromMap(json.decode(str));

  factory Link.fromMap(Map<String, dynamic> json) => Link(
        rel: json["Rel"],
        href: json["Href"],
      );
}

class Vak {
  final int id;
  final String? afkorting;
  final String omschrijving;
  final int volgnr;
  final String licentieUrl;

  Vak({
    required this.id,
    this.afkorting,
    required this.omschrijving,
    required this.volgnr,
    required this.licentieUrl,
  });

  factory Vak.fromJson(String str) => Vak.fromMap(json.decode(str));

  factory Vak.fromMap(Map<String, dynamic> json) => Vak(
        id: json["Id"],
        afkorting: json["Afkorting"],
        omschrijving: json["Omschrijving"],
        volgnr: json["Volgnr"],
        licentieUrl: json["LicentieUrl"],
      );
}
