class ProfileInfo {
  String? mobiel;
  String? emailAdres;
  String? emailAdresPrive;
  bool eloBerichtenDoorsturen;

  ProfileInfo({
    required this.mobiel,
    required this.emailAdres,
    required this.emailAdresPrive,
    required this.eloBerichtenDoorsturen,
  });

  factory ProfileInfo.fromMap(Map<String, dynamic> json) => ProfileInfo(
        mobiel: json["Mobiel"],
        emailAdres: json["EmailAdres"],
        emailAdresPrive: json["EmailAdresPrive"],
        eloBerichtenDoorsturen: json["EloBerichtenDoorsturen"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "Mobiel": mobiel,
        "EmailAdres": emailAdres,
        "EmailAdresPrive": emailAdresPrive,
        "EloBerichtenDoorsturen": eloBerichtenDoorsturen,
      };
}

class ProfileAddress {
  String straat;
  String huisnummer;
  String? toevoeging;
  String postcode;
  String plaats;
  String land;
  String type;
  bool isGeheim;

  ProfileAddress({
    required this.straat,
    required this.huisnummer,
    required this.toevoeging,
    required this.postcode,
    required this.plaats,
    required this.land,
    required this.type,
    required this.isGeheim,
  });

  factory ProfileAddress.fromMap(Map<String, dynamic> json) => ProfileAddress(
        straat: json["straat"] ?? "",
        huisnummer: json["huisnummer"] ?? "",
        toevoeging: json["toevoeging"],
        postcode: json["postcode"] ?? "",
        plaats: json["plaats"] ?? "",
        land: json["land"] ?? "",
        type: json["type"] ?? "",
        isGeheim: json["isGeheim"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "straat": straat,
        "huisnummer": huisnummer,
        "toevoeging": toevoeging,
        "postcode": postcode,
        "plaats": plaats,
        "land": land,
        "type": type,
        "isGeheim": isGeheim,
      };
}

class ProfileCareer {
  String studie;
  String? klas;
  String stamNr;
  String? examenNr;
  String? profielen;

  ProfileCareer({
    this.studie = "",
    this.klas,
    this.stamNr = "",
    this.examenNr,
    this.profielen,
  });

  factory ProfileCareer.fromMap(Map<String, dynamic> json) => ProfileCareer(
        studie: json["Studie"] ?? "",
        klas: json["Klas"],
        stamNr: json["StamNr"] ?? "",
        examenNr: json["ExamenNr"],
        profielen: json["Profielen"],
      );

  Map<String, dynamic> toMap() => {
        "Studie": studie,
        "Klas": klas,
        "StamNr": stamNr,
        "ExamenNr": examenNr,
        "Profielen": profielen,
      };
}

class ProfileAuthorization {
  bool oudersMogenGegevensZien;
  bool magInzageOudersInstellen;
  int meerderJarigeLeeftijd;

  ProfileAuthorization({
    this.oudersMogenGegevensZien = false,
    this.magInzageOudersInstellen = false,
    this.meerderJarigeLeeftijd = 18,
  });

  factory ProfileAuthorization.fromMap(Map<String, dynamic> json) =>
      ProfileAuthorization(
        oudersMogenGegevensZien: json["oudersMogenGegevensZien"] ?? false,
        magInzageOudersInstellen: json["magInzageOudersInstellen"] ?? false,
        meerderJarigeLeeftijd: json["meerderJarigeLeeftijd"] ?? 18,
      );

  Map<String, dynamic> toMap() => {
        "oudersMogenGegevensZien": oudersMogenGegevensZien,
        "magInzageOudersInstellen": magInzageOudersInstellen,
        "meerderJarigeLeeftijd": meerderJarigeLeeftijd,
      };
}

class ProfileiCalendar {
  String href;
  DateTime lastModified;

  ProfileiCalendar({
    this.href = "",
    required this.lastModified,
  });

  factory ProfileiCalendar.fromMap(Map<String, dynamic> json) =>
      ProfileiCalendar(
        href: json["href"] ?? "",
        lastModified: json["lastModified"] != null
            ? DateTime.parse(json["lastModified"])
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        "href": href,
        "lastModified": lastModified.toIso8601String(),
      };
}

class ProfileAnswer {
  int vraagId;
  String code;
  String omschrijving;
  String uitleg;
  int volgnummer;
  DateTime datumAangepast;
  bool toestemming;

  ProfileAnswer({
    this.vraagId = 0,
    this.code = "",
    this.omschrijving = "",
    this.uitleg = "",
    this.volgnummer = 0,
    required this.datumAangepast,
    this.toestemming = false,
  });

  factory ProfileAnswer.fromMap(Map<String, dynamic> json) => ProfileAnswer(
        vraagId: json["vraagId"] ?? 0,
        code: json["code"] ?? "",
        omschrijving: json["omschrijving"] ?? "",
        uitleg: json["uitleg"] ?? "",
        volgnummer: json["volgnummer"] ?? 0,
        datumAangepast: json["datumAangepast"] != null
            ? DateTime.parse(json["datumAangepast"])
            : DateTime.now(),
        toestemming: json["toestemming"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "vraagId": vraagId,
        "code": code,
        "omschrijving": omschrijving,
        "uitleg": uitleg,
        "volgnummer": volgnummer,
        "datumAangepast": datumAangepast.toIso8601String(),
        "toestemming": toestemming,
      };
}

class ProfileMentor {
  List<String> type;
  int id;
  String voorletters;
  String? roepnaam;
  String? tussenvoegsel;
  String achternaam;
  int volgnummer;
  String naam;

  ProfileMentor({
    this.type = const [],
    this.id = 0,
    this.voorletters = "",
    this.roepnaam,
    this.tussenvoegsel,
    this.achternaam = "",
    this.volgnummer = 0,
    this.naam = "",
  });

  factory ProfileMentor.fromMap(Map<String, dynamic> json) => ProfileMentor(
        type: json["type"] != null
            ? List<String>.from(json["type"].map((x) => x.toString()))
            : [],
        id: json["id"] ?? 0,
        voorletters: json["voorletters"] ?? "",
        roepnaam: json["roepnaam"],
        tussenvoegsel: json["tussenvoegsel"],
        achternaam: json["achternaam"] ?? "",
        volgnummer: json["volgnummer"] ?? 0,
        naam: json["naam"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "type": List<dynamic>.from(type.map((x) => x)),
        "id": id,
        "voorletters": voorletters,
        "roepnaam": roepnaam,
        "tussenvoegsel": tussenvoegsel,
        "achternaam": achternaam,
        "volgnummer": volgnummer,
        "naam": naam,
      };
}
