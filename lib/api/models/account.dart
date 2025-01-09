import 'dart:convert';

import 'package:discipulus/api/models/permissions.dart';

class ApiAccount {
  final String uuid;
  final ApiPersoon persoon;
  final List<Groep> groep;

  ApiAccount({
    required this.uuid,
    required this.persoon,
    required this.groep,
  });

  factory ApiAccount.fromJson(String str) =>
      ApiAccount.fromMap(json.decode(str));

  factory ApiAccount.fromMap(Map<String, dynamic> json) => ApiAccount(
        uuid: json["UuId"],
        persoon: ApiPersoon.fromMap(json["Persoon"]),
        groep: List<Groep>.from(json["Groep"].map((x) => Groep.fromMap(x))),
      );
}

class Groep {
  final String naam;
  final List<Permission> privileges;
  final dynamic links;

  Groep({
    required this.naam,
    required this.privileges,
    this.links,
  });

  factory Groep.fromJson(String str) => Groep.fromMap(json.decode(str));

  factory Groep.fromMap(Map<String, dynamic> json) => Groep(
        naam: json["Naam"],
        privileges: List<Permission>.from(
            json["Privileges"].map((x) => Permission.fromMap(x))),
        links: json["Links"],
      );
}

class ApiPersoon {
  final int id;
  final String? roepnaam;
  final String? tussenvoegsel;
  final String achternaam;
  final String? officieleVoornamen;
  final String voorletters;
  final String? officieleTussenvoegsels;
  final String? officieleAchternaam;
  final DateTime geboortedatum;
  final String? geboorteAchternaam;
  final String? geboortenaamTussenvoegsel;
  final bool gebruikGeboortenaam;

  ApiPersoon({
    required this.id,
    required this.roepnaam,
    this.tussenvoegsel,
    required this.achternaam,
    required this.officieleVoornamen,
    required this.voorletters,
    this.officieleTussenvoegsels,
    required this.officieleAchternaam,
    required this.geboortedatum,
    this.geboorteAchternaam,
    this.geboortenaamTussenvoegsel,
    required this.gebruikGeboortenaam,
  });

  factory ApiPersoon.fromJson(String str) =>
      ApiPersoon.fromMap(json.decode(str));

  factory ApiPersoon.fromMap(Map<String, dynamic> json) => ApiPersoon(
        id: json["Id"],
        roepnaam: json["Roepnaam"],
        tussenvoegsel: json["Tussenvoegsel"],
        achternaam: json["Achternaam"],
        officieleVoornamen: json["OfficieleVoornamen"],
        voorletters: json["Voorletters"],
        officieleTussenvoegsels: json["OfficieleTussenvoegsels"],
        officieleAchternaam: json["OfficieleAchternaam"],
        geboortedatum: DateTime.parse(json["Geboortedatum"]).toUtc(),
        geboorteAchternaam: json["GeboorteAchternaam"],
        geboortenaamTussenvoegsel: json["GeboortenaamTussenvoegsel"],
        gebruikGeboortenaam: json["GebruikGeboortenaam"],
      );
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class ApiChild {
  final int stamnummer;
  final bool zichtbaarVoorOuder;
  final int id;
  final String roepnaam;
  final dynamic tussenvoegsel;
  final String achternaam;
  final String officieleVoornamen;
  final String? voorletters;
  final String? officieleTussenvoegsels;
  final String officieleAchternaam;
  final DateTime geboortedatum;
  final String? geboorteAchternaam;
  final String? geboortenaamTussenvoegsel;
  final bool gebruikGeboortenaam;

  ApiChild({
    required this.stamnummer,
    required this.zichtbaarVoorOuder,
    required this.id,
    required this.roepnaam,
    this.tussenvoegsel,
    required this.achternaam,
    required this.officieleVoornamen,
    this.voorletters,
    this.officieleTussenvoegsels,
    required this.officieleAchternaam,
    required this.geboortedatum,
    this.geboorteAchternaam,
    this.geboortenaamTussenvoegsel,
    required this.gebruikGeboortenaam,
  });

  factory ApiChild.fromJson(String str) => ApiChild.fromMap(json.decode(str));

  factory ApiChild.fromMap(Map<String, dynamic> json) => ApiChild(
        stamnummer: json["Stamnummer"],
        zichtbaarVoorOuder: json["ZichtbaarVoorOuder"],
        id: json["Id"],
        roepnaam: json["Roepnaam"],
        tussenvoegsel: json["Tussenvoegsel"],
        achternaam: json["Achternaam"],
        officieleVoornamen: json["OfficieleVoornamen"],
        voorletters: json["Voorletters"],
        officieleTussenvoegsels: json["OfficieleTussenvoegsels"],
        officieleAchternaam: json["OfficieleAchternaam"],
        geboortedatum: DateTime.parse(json["Geboortedatum"]).toUtc(),
        geboorteAchternaam: json["GeboorteAchternaam"],
        geboortenaamTussenvoegsel: json["GeboortenaamTussenvoegsel"],
        gebruikGeboortenaam: json["GebruikGeboortenaam"] ?? false,
      );
}
