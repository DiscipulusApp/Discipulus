// You might be thinking: "What the hell is the difference between an external
// bron and a normal bron?", well the answer is quite simple, though I get
// that the naming can be a bit confusing. External bronnen are the bronnen
// from the Magister page literally titled "Bronnen". The "normal" bronnen are
// the bronnen that are used all over the place in Magister as attachments.
// In the end the goal is still to have a single Bron class that is sufficient
// for every place in the Magister API, since for some reason every page has
// it's own implementation, but you can thank Magister for that. The bronnen in
// the Magister API, just like the other pages, also has it's own implementation,
// but this will just become, just like with the other pages, a [Bron] class.
// "Then what is this file for?" you might be asking yourself. A valid question.
// This file contains the implementation for the page titled "Bronnen" in
// Magister, meaning that it just implements that part of the API.

import 'package:dio/dio.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:isar/isar.dart';

part 'external_bron.g.dart';

@Collection()
@Name("ExternalBronSource")
class ExternalBronSource {
  @Backlink(to: 'externalBronnen')
  final profile = IsarLink<Profile>();
  Id get uuid => "${profile.value!.uuid}$id".hashCode;

  int id;
  List<ExternalResourceLink> links;
  int bronSoort;
  String naam;

  // * -1 = "MijnEloDocumenten",
  // * -9 = "GedeeldeDocumenten",
  // * -12 = "PortFolioDocumenten",
  // * -18 = "ProjectDocumenten",
  // * -99 = "Prullenbak",
  // * -100 = "Kennisnet",
  // * -102 = "OneDriveForBusiness"
  int referentie;
  String? uri;
  int grootte;
  int privilege;
  int type;
  String contentType;
  DateTime? gewijzigdOp;
  String? geplaatstDoor;
  DateTime? gemaaktOp;
  int fileBlobId;
  int parentId;
  String uniqueId;
  int volgnr;
  int moduleSoort;

  ExternalBronSource({
    required this.id,
    required this.links,
    required this.bronSoort,
    required this.naam,
    required this.referentie,
    required this.uri,
    required this.grootte,
    required this.privilege,
    required this.type,
    required this.contentType,
    required this.gewijzigdOp,
    required this.geplaatstDoor,
    required this.gemaaktOp,
    required this.fileBlobId,
    required this.parentId,
    required this.uniqueId,
    required this.volgnr,
    required this.moduleSoort,
  });

  factory ExternalBronSource.fromMap(Map<String, dynamic> json) =>
      ExternalBronSource(
        id: json["Id"],
        links: List<ExternalResourceLink>.from(
            json["Links"].map((x) => ExternalResourceLink.fromMap(x))),
        bronSoort: json["BronSoort"],
        naam: json["Naam"],
        referentie: json["Referentie"],
        uri: json["Uri"],
        grootte: json["Grootte"],
        privilege: json["Privilege"],
        type: json["Type"],
        contentType: json["ContentType"],
        gewijzigdOp: json["GewijzigdOp"] != null
            ? DateTime.parse(json["GewijzigdOp"])
            : null,
        geplaatstDoor: json["GeplaatstDoor"],
        gemaaktOp: json["GemaaktOp"] != null
            ? DateTime.parse(json["GemaaktOp"])
            : null,
        fileBlobId: json["FileBlobId"],
        parentId: json["ParentId"],
        uniqueId: json["UniqueId"],
        volgnr: json["Volgnr"],
        moduleSoort: json["ModuleSoort"],
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "BronSoort": bronSoort,
        "Naam": naam,
        "Referentie": referentie,
        "Uri": uri,
        "Grootte": grootte,
        "Privilege": privilege,
        "Type": type,
        "ContentType": contentType,
        "GewijzigdOp": gewijzigdOp,
        "GeplaatstDoor": geplaatstDoor,
        "GemaaktOp": gemaaktOp,
        "FileBlobId": fileBlobId,
        "ParentId": parentId,
        "UniqueId": uniqueId,
        "Volgnr": volgnr,
        "ModuleSoort": moduleSoort,
      };

  /// The linked bronnen.
  final bronnen = IsarLinks<Bron>();

  /// Syncs the bronnen with the API
  Future<void> syncBronnen([String? customURL]) async {
    Response? res = await profile.value?.account.value?.api.dio.get(
      customURL ??
          links
              .where((l) => l.rel == "Children")
              .first
              .href
              .replaceAll("/api/", ""),
    );
    if (res != null && (res.data["Items"] ?? res.data["items"]) != null) {
      // Request succeeded
      bronnen.addAll(
          List<Bron>.from((res.data["Items"] ?? res.data["items"]).map((x) {
        if (referentie == -102) {
          // Onedrive file
          return Bron.fromOnedriveMap(x,
              // The root folders need to know that they are in fact the root
              // folders
              customParentId: customURL == null ? -1 : null)
            ..profile.value = profile.value
            ..source.value = this;
        } else {
          return Bron.fromMap(x)
            ..profile.value = profile.value
            ..source.value = this;
        }
      })));

      isar.writeTxnSync(() {
        isar.brons.putAllSync(bronnen.toList());
        isar.externalBronSources.putSync(this);
        bronnen.saveSync();
      });
    }
  }
}

@embedded
class ExternalResourceLink {
  String rel;
  String href;

  ExternalResourceLink({
    this.rel = "",
    this.href = "",
  });

  factory ExternalResourceLink.fromMap(Map<String, dynamic> json) =>
      ExternalResourceLink(
        rel: json["Rel"],
        href: json["Href"],
      );

  Map<String, dynamic> toMap() => {
        "Rel": rel,
        "Href": href,
      };
}
