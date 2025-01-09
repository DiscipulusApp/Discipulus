import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/core/spotlight_search.dart';
import 'package:discipulus/screens/messages/message_extensions.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';

part 'messages.g.dart';

@Collection()
@Name("Bericht")
class Bericht with SpotlightSearchElementMixin {
  @Backlink(to: 'berichten')
  final map = IsarLink<MessagesFolder>();
  Id get uuid => "${map.value!.profile.value!.uuid}$id".hashCode;

  final int id;

  String? get onderwerp => rawOnderwerp != null
      ? HtmlUnescape().convert(rawOnderwerp!)
      : null; // When the mail is a concept, this can be null
  set onderwerp(String? value) => rawOnderwerp = value;
  String? rawOnderwerp;

  int mapId;
  final Afzender? afzender;
  bool heeftPrioriteit;
  bool heeftBijlagen;
  bool isGelezen;
  DateTime verzondenOp; // Can change in concepts
  final DateTime? doorgestuurdOp;
  final DateTime? beantwoordOp;
  ItemLinks links;
  String? inhoud;
  List<Ontvanger>? ontvangers;
  List<Ontvanger>? kopieOntvangers;
  List<Ontvanger>? blindeKopieOntvangers;
  final bronnen = IsarLinks<Bron>();

  String? aiSummary;

  Bericht({
    required this.id,
    required this.rawOnderwerp,
    required this.mapId,
    required this.afzender,
    required this.heeftPrioriteit,
    required this.heeftBijlagen,
    required this.isGelezen,
    required this.verzondenOp,
    this.doorgestuurdOp,
    this.beantwoordOp,
    required this.links,
    this.inhoud,
    this.ontvangers,
    this.kopieOntvangers,
    this.blindeKopieOntvangers,
  });

  factory Bericht.fromJson(String str) => Bericht.fromMap(json.decode(str));

  factory Bericht.fromMap(Map<String, dynamic> json) => Bericht(
        id: json["id"],
        rawOnderwerp: json["onderwerp"],
        mapId: json["mapId"] ?? -1, // Concepts do not have a mapId
        afzender: json["afzender"] != null
            ? Afzender.fromMap(json["afzender"])
            : null,
        heeftPrioriteit: json["heeftPrioriteit"],
        heeftBijlagen: json["heeftBijlagen"],
        isGelezen: json["isGelezen"] ?? true, // Concepts are always read
        verzondenOp: DateTime.parse(
                json["laatsteWijzigingDatumTijd"] ?? json["verzondenOp"])
            .toUtc(),
        doorgestuurdOp: json["doorgestuurdOp"] != null
            ? DateTime.parse(json["doorgestuurdOp"])
            : null,
        beantwoordOp: json["beantwoordOp"] != null
            ? DateTime.parse(json["beantwoordOp"])
            : null,
        links: ItemLinks.fromMap(json["links"]),
        inhoud: json["inhoud"],
      );

  static Bericht? fromMapAnnouncement(
      Map<String, dynamic> json, Profile profile) {
    if (json["school_url"] != null &&
        !profile.account.value!.endPoint
            .split("/")
            .contains(json["school_url"])) {
      // This message is not meant for the current user
      return null;
    } else if (DateTime.now()
        .difference(DateTime.parse(json["verzondenOp"]))
        .isNegative) {
      // This message is not meant to be sent yet.
      return null;
    } else {
      return Bericht(
        id: -DateTime.parse(json["verzondenOp"] ?? DateTime.now())
            .millisecondsSinceEpoch,
        mapId: 1,
        afzender: Afzender(naam: "HarryDeKat"),
        ontvangers: [
          Ontvanger(
              weergavenaam: (json["school_url"] as String?)
                      ?.replaceAll(".magister.net", "")
                      .capitalized ??
                  "Alle leerlingen")
        ],
        heeftPrioriteit: false,
        heeftBijlagen: false,
        isGelezen: false,
        verzondenOp: DateTime.parse(json["verzondenOp"]).toUtc(),
        links: ItemLinks.fromMap({}),
        rawOnderwerp: json["onderwerp"],
        inhoud: json["inhoud"],
      );
    }
  }

  /// Fill the content, recepients, copy recepients, the blind copy recepients and bronnen.
  Future<void> fill() async {
    /// Fetch data from API

    // When the message in an announcement do not fill
    if (id.isNegative) return;

    // Check permissions
    if (!(map.value!.profile.value!.account.value?.permissions
            .hasPermissions(PermissionType.berichten) ??
        false)) {
      return;
    }

    Magister api = map.value!.profile.value!.account.value!.api;
    List data = (await Future.wait([
      api.dio.get(links.self.replaceAll("/api/", "")),
      if (links.bijlagen != null)
        api.dio.get(links.bijlagen!.replaceAll("/api/", ""))
    ]))
        .map((e) => e.data)
        .toList();

    // Check if new attachments were added (for concepts)
    if (data.first?["links"]?["bijlagen"]?["href"] != null &&
        links.bijlagen == null) {
      links.bijlagen = data.first?["links"]?["bijlagen"]?["href"];
      data.add(
          (await api.dio.get(links.bijlagen!.replaceAll("/api/", ""))).data);
    }

    heeftBijlagen = data.first["heeftBijlagen"];
    inhoud = data.first["inhoud"];
    isGelezen = data.first["isGelezen"] ?? true;
    ontvangers = data.first["ontvangers"] == null
        ? []
        : List<Ontvanger>.from(
            data.first["ontvangers"]!.map((x) => Ontvanger.fromMap(x)));
    kopieOntvangers = data.first["kopieOntvangers"] == null
        ? []
        : List<Ontvanger>.from(
            data.first["kopieOntvangers"]!.map((x) => Ontvanger.fromMap(x)));
    blindeKopieOntvangers = data.first["blindeKopieOntvangers"] == null
        ? []
        : List<Ontvanger>.from(data.first["blindeKopieOntvangers"]!
            .map((x) => Ontvanger.fromMap(x)));

    // Add attachments
    if (links.bijlagen != null) {
      List<Bron> newBronnen = List<Bron>.from(data.last["items"].map(
          (x) => Bron.fromMap(x)..profile.value = map.value!.profile.value!));
      await bronnen.load();
      bronnen.removeWhere((e) => !newBronnen.map((e) => e.id).contains(e.id));
      bronnen.addAll(newBronnen);
    }

    updateSpotlight();

    // Save to the database
    isar.writeTxnSync(() {
      isar.brons.putAllSync(bronnen.toList());
      isar.berichts.putSync(this);
      map.value?.berichten.saveSync();
      bronnen.saveSync();
    });
  }

  ///Mark a message as read
  Future<void> markAsRead({bool read = true}) async {
    // Check permissions
    if (!id.isNegative) {
      if (!(map.value!.profile.value!.account.value?.permissions.hasPermissions(
              PermissionType.berichten,
              statuses: [PermissionStatus.update]) ??
          true)) {
        return;
      }

      await map.value!.profile.value!.account.value!.api.dio
          .patch("/berichten/berichten", data: {
        "berichten": [
          {
            "berichtId": id,
            "operations": [
              {"op": "replace", "path": "/IsGelezen", "value": read}
            ]
          }
        ]
      });
    }
    // Save to the database
    isar.writeTxnSync(() {
      isar.berichts.putSync(this..isGelezen = read);
    });
  }

  Future<void> moveToFolder(int folderId) async {
    // Check permissions
    if (!id.isNegative) {
      if (!(map.value!.profile.value!.account.value?.permissions.hasPermissions(
              PermissionType.berichten,
              statuses: [PermissionStatus.update]) ??
          false)) {
        return;
      }

      await map.value!.profile.value!.account.value!.api.messages
          .moveToFolder([this], folderId: folderId);
    }
    map.value = await map.value?.profile.value?.berichtMappen
        .filter()
        .idEqualTo(folderId)
        .findFirst();
    isar.writeTxnSync(() {
      isar.berichts.putSync(this);
      map.value?.berichten.saveSync();
    });
  }

  ///Move the message to the removed messages folder
  Future<void> remove() async {
    if (!id.isNegative) {
      if (map.value!.id != -1) {
        /// Move to removed messages folder
        await moveToFolder(3);
      } else {
        /// Permantly delete
        if (!(map.value!.profile.value!.account.value?.permissions
                .hasPermissions(PermissionType.berichten,
                    statuses: [PermissionStatus.delete]) ??
            false)) {
          return;
        }
        removeFromSpotlight();
        await map.value!.profile.value!.account.value!.api.dio
            .delete("/berichten/concepten", data: [
          {"conceptId": id}
        ]);
      }
    }
    isar.writeTxnSync(() async {
      isar.berichts.filter().uuidEqualTo(uuid).deleteFirstSync();
    });
  }

  /// This only works if the message is a concept
  Future<void> syncConcept({List<int> newAttachmentIds = const []}) async {
    assert(map.value!.id == -1, "Bericht is geen concept!");

    if (!(map.value!.profile.value!.account.value?.permissions.hasPermissions(
            PermissionType.berichten,
            statuses: [PermissionStatus.update]) ??
        false)) {
      return;
    }

    await map.value!.profile.value!.account.value!.api.dio
        .put("/berichten/concepten/$id", data: {
      "ontvangers": ontvangers != null
          ? List<dynamic>.from(
              ontvangers!.map((x) => {"id": x.id, "type": x.type}))
          : [],
      "kopieOntvangers": kopieOntvangers != null
          ? List<dynamic>.from(
              kopieOntvangers!.map((x) => {"id": x.id, "type": x.type}))
          : [],
      "blindeKopieOntvangers": blindeKopieOntvangers != null
          ? List<dynamic>.from(
              blindeKopieOntvangers!.map((x) => {"id": x.id, "type": x.type}))
          : [],
      "heeftPrioriteit": heeftPrioriteit,
      "inhoud": inhoud,
      "onderwerp": onderwerp,
      "verzendOptie": "standaard",
      "bijlagen": bronnen.map((e) => {"id": e.id, "type": "bijlage"}).toList()
        ..addAll(newAttachmentIds.map((e) => {"id": e, "type": "upload"}))
    });
  }

  @override
  @ignore
  SpotlightSearchElement? get spotlightItem =>
      map.value?.profile.value?.settings.spotlightIndexMessages == true
          ? SpotlightSearchElement(
              domainIdentifier:
                  "dev.harrydekat.discipulus.message.${map.value?.profile.value?.uuid}",
              uniqueIdentifier: "message_$uuid",
              attributeSet: CoreSpotlightItemAttributeSet(
                UTType.emailMessage,
                title: onderwerp ??
                    "Bericht van ${afzender?.naam ?? map.value!.profile.value!.name}",
                contentDescription: (() {
                  String desc = verzondenOp.formattedDateAndTime;

                  if (afzender != null) {
                    desc = "Bericht van ${afzender?.naam} op $desc";
                  } else {
                    desc = "Concept van $desc";
                  }

                  if (isar.profiles.countSync() > 1) {
                    desc += " (${map.value?.profile.value?.name})";
                  }
                  return desc;
                })(),
                authorNames: [afzender?.naam ?? map.value!.profile.value!.name],
                recipientNames:
                    ontvangers?.map((e) => e.weergavenaam).nonNulls.toList(),
                textContent: inhoud?.withoutHTML,
                addedDate: verzondenOp,
                keywords: [
                  for (String item in [
                    "Magister",
                    "Discipulus",
                    "Berichten",
                    "Mail",
                    afzender?.naam
                  ].nonNulls) ...[item.capitalized, item.toLowerCase()]
                ],
              ),
            )
          : null;

  void save() => isar.writeTxnSync(() => isar.berichts.putSync(this));
}

@embedded
class Afzender {
  final int id;
  final String naam;

  Afzender({
    this.id = 0,
    this.naam = "",
  });

  factory Afzender.fromJson(String str) => Afzender.fromMap(json.decode(str));

  factory Afzender.fromMap(Map<String, dynamic> json) => Afzender(
        id: json["id"],
        naam: json["naam"],
      );
}

@embedded
class ItemLinks {
  final String self;
  final String map;
  String? bijlagen;

  ItemLinks({
    this.self = "",
    this.map = "",
    this.bijlagen,
  });

  factory ItemLinks.fromJson(String str) => ItemLinks.fromMap(json.decode(str));

  factory ItemLinks.fromMap(Map<String, dynamic> json) => ItemLinks(
        self: json["self"]?["href"] ?? "",
        map: json["map"]?["href"] ?? "/api/berichten/concepten/",
        bijlagen: json["bijlagen"]?["href"],
      );
}

@embedded
class Ontvanger {
  final int id;
  final String weergavenaam;
  final String type;
  final String? mailGroep;

  Ontvanger({
    this.id = 0,
    this.weergavenaam = "",
    this.type = "",
    this.mailGroep,
  });

  factory Ontvanger.fromJson(String str) => Ontvanger.fromMap(json.decode(str));

  factory Ontvanger.fromMap(Map<String, dynamic> json) => Ontvanger(
        id: json["id"],
        weergavenaam: json["weergavenaam"],
        type: json["type"],
        mailGroep: json["mailGroep"],
      );
}

@embedded
class UploadedAttachment {
  final int id;
  final String naam;
  final String type;
  final String? storageId;

  @ignore
  String? path;
  @ignore
  Bron? bron;

  UploadedAttachment({
    this.id = 0,
    this.naam = "",
    this.type = "upload",
    this.bron,
    this.storageId,
  });

  factory UploadedAttachment.fromJson(String str) =>
      UploadedAttachment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UploadedAttachment.fromMap(Map<String, dynamic> json) =>
      UploadedAttachment(
        id: json["id"],
        naam: json["naam"],
      );

  Map<String, dynamic> toMap() => {"id": id, "naam": naam, "type": type};
}

@Collection()
@Name("BerichtFolder")
class MessagesFolder {
  final berichten = IsarLinks<Bericht>();
  @Backlink(to: 'berichtMappen')
  final profile = IsarLink<Profile>();
  Id get uuid => "${profile.value!.uuid}$id".hashCode;

  final int aantalOngelezen;
  final int id;
  final int bovenliggendeId;
  final String naam;
  final String berichtenLink;

  MessagesFolder({
    required this.aantalOngelezen,
    required this.id,
    required this.bovenliggendeId,
    required this.naam,
    required this.berichtenLink,
  });

  factory MessagesFolder.fromJson(String str) =>
      MessagesFolder.fromMap(json.decode(str));

  factory MessagesFolder.fromMap(Map<String, dynamic> json) => MessagesFolder(
      aantalOngelezen: json["aantalOngelezen"],
      id: json["id"],
      bovenliggendeId: json["bovenliggendeId"],
      naam: json["naam"],
      berichtenLink: json["links"]["berichten"]["href"]);

  CancelToken _cancelToken = CancelToken();

  Future<List<Bericht>> getMessages({
    int amount = 15,
    int skip = 0,
    String? query,
    bool? heeftPrioriteit,
    bool? heeftGelezen,
    bool? heeftBijlage,
    bool returnAll = true,
  }) async {
    assert(query != null && query.length >= 2 || query == null);

    if (!(profile.value!.account.value?.permissions
            .hasPermissions(PermissionType.berichten) ??
        false)) {
      return [];
    }

    // Cancel searches that were taking place
    if (query != null) {
      _cancelToken.cancel("New query has been made");
      _cancelToken = CancelToken();
    }

    List<Response> responses = await Future.wait([
      // From annoucements
      if (id == 1 && query == null && skip == 0)
        Future(() async {
          Response? res;
          try {
            res = await Dio().get(
              "https://discipulus.harrydekat.dev/annoucements.json",
              options: Options(sendTimeout: const Duration(seconds: 5)),
            );
          } catch (e) {
            res = Response(requestOptions: RequestOptions(), data: []);
          }
          return Future.value(res);
        }),

      // From Magister
      profile.value!.account.value!.api.dio.get(
        berichtenLink.replaceAll("/api/", ""),
        cancelToken: query != null ? _cancelToken : null,
        queryParameters: {
          "top": amount,
          "skip": skip,
          if (heeftGelezen != null)
            "gelezenStatus": heeftGelezen ? "gelezen" : "ongelezen",
          if (heeftPrioriteit != null) "heeftPrioriteit": heeftPrioriteit,
          if (heeftBijlage != null) "heeftBijlage": heeftBijlage,
          if (query != null) "trefwoorden": query.replaceAll(" ", "+")
        },
      ).onError<DioException>(
        (error, stackTrace) {
          print(error);
          return Future.value(error.response);
        },
      )
    ]);

    // Get messages from API
    var b = List<Bericht>.from([
      if (responses.last.data["items"] != null)
        ...responses.last.data["items"]
            ?.map((x) => Bericht.fromMap(x)..map.value = this),
      if (id == 1 && query == null && skip == 0)
        ...responses.first.data.map((x) =>
            Bericht.fromMapAnnouncement(x, profile.value!)?..map.value = this)
    ].nonNulls);

    // Check for removal
    if (query == null) {
      await b.removeChecker(
          latestIsNow: skip == 0 &&
              heeftBijlage == null &&
              heeftPrioriteit == null &&
              heeftGelezen == null);
    }

    Iterable<Bericht> newMessages = berichten.map((e) {
      Bericht? currentMessage = isar.berichts.getSync(e.uuid);
      return e
        ..inhoud =
            e.id.isNegative ? e.inhoud : currentMessage?.inhoud ?? e.inhoud
        ..ontvangers = currentMessage?.ontvangers ?? e.ontvangers
        ..kopieOntvangers = currentMessage?.kopieOntvangers ?? e.kopieOntvangers
        ..blindeKopieOntvangers =
            currentMessage?.blindeKopieOntvangers ?? e.blindeKopieOntvangers
        // Annoucements will be marked as read only though the local database
        ..isGelezen = e.id.isNegative
            ? currentMessage?.isGelezen ?? e.isGelezen
            : e.isGelezen
        ..mapId = e.id.isNegative ? currentMessage?.mapId ?? e.mapId : e.mapId;
    });

    if (Platform.isIOS || Platform.isMacOS) {
      await CoreSpotlight.instance.indexSearchableItems([
        for (Bericht message in newMessages) message.spotlightItem
      ].nonNulls);
    }

    // Add to local database
    berichten.addAll(b);
    isar.writeTxnSync(() {
      isar.berichts.putAllSync(newMessages.toList());
      berichten.saveSync();
    });
    return returnAll ? berichten.toList() : b;
  }

  Future<void> createChildFolder(String name) async {
    assert(
        id != 0, "Er kunnen geen mappen in de concepten map gemaakt worden!");

    if (!(profile.value!.account.value?.permissions.hasPermissions(
            PermissionType.mataBerichtMappen,
            statuses: [PermissionStatus.create]) ??
        false)) {
      return;
    }

    await profile.value!.account.value!.api.dio.post(
        "${berichtenLink.replaceAll("/api/", "")}/mappen",
        data: {"naam": name});
  }

  Future<void> editFolder({String? name, int? bovenliggendeId}) async {
    assert((name ?? naam).isNotEmpty,
        "$name is te kort! Geef een naam van minimaal één karakter op.");

    if (!(profile.value!.account.value?.permissions.hasPermissions(
            PermissionType.mataBerichtMappen,
            statuses: [PermissionStatus.update]) ??
        false)) {
      return;
    }

    await profile.value!.account.value!.api.dio
        .put(berichtenLink.replaceAll("/api/", ""), data: {
      "naam": name ?? naam,
      "bovenliggendeId": bovenliggendeId ?? this.bovenliggendeId
    });
  }

  Future<void> remove({bool permanent = false}) async => permanent
      ? await profile.value!.account.value!.api.dio
          .delete(berichtenLink.replaceAll("/api/", ""))
      : await editFolder(bovenliggendeId: 3);
}

@embedded
class Contact {
  final int id;
  final String voorletters;
  final String? roepnaam;
  final String? tussenvoegsel;
  final String achternaam;
  final String? code;
  final String? klas;
  final String type;

  Contact({
    this.id = 0,
    this.voorletters = "",
    this.roepnaam,
    this.tussenvoegsel,
    this.achternaam = "",
    this.code,
    this.klas,
    this.type = "",
  });

  factory Contact.fromJson(String str) => Contact.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        id: json["id"],
        voorletters: json["voorletters"],
        roepnaam: json["roepnaam"],
        tussenvoegsel: json["tussenvoegsel"],
        achternaam: json["achternaam"],
        code: json["code"],
        klas: json["klas"],
        type: json["type"]!,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "voorletters": voorletters,
        "roepnaam": roepnaam,
        "tussenvoegsel": tussenvoegsel,
        "achternaam": achternaam,
        "code": code,
        "klas": klas,
        "type": type,
      };

  @ignore
  String get fullName => "${roepnaam ?? voorletters} $achternaam";
}
