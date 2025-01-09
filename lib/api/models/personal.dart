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
        straat: json["straat"],
        huisnummer: json["huisnummer"],
        toevoeging: json["toevoeging"],
        postcode: json["postcode"],
        plaats: json["plaats"],
        land: json["land"],
        type: json["type"],
        isGeheim: json["isGeheim"],
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
    required this.studie,
    required this.klas,
    required this.stamNr,
    required this.examenNr,
    required this.profielen,
  });

  factory ProfileCareer.fromMap(Map<String, dynamic> json) => ProfileCareer(
        studie: json["Studie"],
        klas: json["Klas"],
        stamNr: json["StamNr"],
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
    required this.oudersMogenGegevensZien,
    required this.magInzageOudersInstellen,
    required this.meerderJarigeLeeftijd,
  });

  factory ProfileAuthorization.fromMap(Map<String, dynamic> json) =>
      ProfileAuthorization(
        oudersMogenGegevensZien: json["oudersMogenGegevensZien"],
        magInzageOudersInstellen: json["magInzageOudersInstellen"],
        meerderJarigeLeeftijd: json["meerderJarigeLeeftijd"],
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
    required this.href,
    required this.lastModified,
  });

  factory ProfileiCalendar.fromMap(Map<String, dynamic> json) =>
      ProfileiCalendar(
        href: json["href"],
        lastModified: DateTime.parse(json["lastModified"]),
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
    required this.vraagId,
    required this.code,
    required this.omschrijving,
    required this.uitleg,
    required this.volgnummer,
    required this.datumAangepast,
    required this.toestemming,
  });

  factory ProfileAnswer.fromMap(Map<String, dynamic> json) => ProfileAnswer(
        vraagId: json["vraagId"],
        code: json["code"],
        omschrijving: json["omschrijving"],
        uitleg: json["uitleg"],
        volgnummer: json["volgnummer"],
        datumAangepast: DateTime.parse(json["datumAangepast"]),
        toestemming: json["toestemming"],
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
    required this.type,
    required this.id,
    required this.voorletters,
    required this.roepnaam,
    required this.tussenvoegsel,
    required this.achternaam,
    required this.volgnummer,
    required this.naam,
  });

  factory ProfileMentor.fromMap(Map<String, dynamic> json) => ProfileMentor(
        type: List<String>.from(json["type"].map((x) => x)),
        id: json["id"],
        voorletters: json["voorletters"],
        roepnaam: json["roepnaam"],
        tussenvoegsel: json["tussenvoegsel"],
        achternaam: json["achternaam"],
        volgnummer: json["volgnummer"],
        naam: json["naam"],
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
