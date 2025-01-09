import 'dart:io';

import 'package:dio/dio.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:mime/mime.dart';

class MessagesRoute extends MagisterBase {
  MessagesRoute(super.magister) : super();

  Future<UploadedAttachment> uploadFile(
    File file,
    void Function(int, int)? onSendProgres, {
    bool messageAttachment = true,
    // For some reason this is different sometimes, Magister is a true mystery.
  }) async {
    assert(file.existsSync(), "File does not exist");

    // Get file name
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    if (messageAttachment) {
      return List<UploadedAttachment>.from((await magister.dio.post(
        "/bestanden",
        data: formData,
        onSendProgress: onSendProgres,
      ))
          .data
          .map((x) => UploadedAttachment.fromMap(x))).first
        ..path = file.path;
    } else {
      // Upload the file to Magister
      UploadedFile onlineFile = UploadedFile.fromMap((await magister.dio.post(
        "/bestanden/upload",
        data: {"name": fileName},
      ))
          .data);

      String minetype = lookupMimeType(file.path)!;

      await Dio().request(onlineFile.uri,
          options: Options(
            method: "OPTIONS",
            headers: {
              "sec-fetch-dest": "empty",
              "sec-fetch-mode": "cors",
              "sec-fetch-site": "cross-site",
              "access-control-request-headers":
                  "x-ms-blob-content-type,x-ms-blob-type",
              "access-control-request-method": "PUT",
              "origin": magister.apiEndpoint.host,
              "referer": magister.apiEndpoint.host
            },
          ));

      await Dio().put(
        onlineFile.uri,
        data: formData,
        onSendProgress: onSendProgres,
        options: Options(
          headers: {
            "x-ms-blob-content-type": minetype,
            "x-ms-blob-type": "BlockBlob"
          },
        ),
      );

      return UploadedAttachment(
        id: onlineFile.id,
        storageId: onlineFile.storageId,
        naam: fileName,
        type: minetype,
      );
    }
  }

  Future<List<MessagesFolder>> get folders async => List<MessagesFolder>.from(
      (await magister.dio.get("berichten/mappen/alle"))
          .data["items"]
          .map((x) => MessagesFolder.fromMap(x)));

  Future<void> moveToFolder(List<Bericht> messages,
      {required int folderId}) async {
    await magister.dio.patch("berichten/berichten", data: {
      "berichten": [
        for (Bericht message in messages)
          {
            "berichtId": message.id,
            "operations": [
              {"op": "replace", "path": "/MapId", "value": folderId}
            ]
          }
      ]
    });
  }

  // Remove messages permanently
  Future<void> remove(List<Bericht> messages) async {
    // Concepts and normal messages are removed at a different endpoint
    Iterable<Bericht> concepts = messages.where((e) => e.mapId == -1);
    Iterable<Bericht> normalMessages = messages.where((e) => e.mapId != -1);

    if (concepts.isNotEmpty) {
      await magister.dio.delete("/berichten/concepten", data: [
        for (int id in concepts.map((e) => e.id)) {"conceptId": id}
      ]);
    }

    if (normalMessages.isNotEmpty) {
      await magister.dio.delete("/berichten/berichten", data: [
        for (int id in normalMessages.map((e) => e.id)) {"berichtId": id}
      ]);
    }
  }

  Future<void> markAsRead(List<Bericht> messages, {required bool read}) async {
    await magister.dio.patch("berichten/berichten", data: {
      "berichten": [
        for (Bericht message in messages)
          {
            "berichtId": message.id,
            "operations": [
              {"op": "replace", "path": "/IsGelezen", "value": read}
            ]
          }
      ]
    });
  }

  Future<List<Bericht>> getConcepts(
      {int amount = 15, int skip = 0, String? query}) async {
    assert(query != null && query.length >= 2 || query == null);
    return List<Bericht>.from(
        (await magister.dio.get("berichten/concepten", queryParameters: {
      "top": amount,
      "skip": skip,
      if (query != null) "trefwoorden": query.replaceAll(" ", "+")
    }))
            .data["items"]
            .map((x) => Bericht.fromMap(x)));
  }

  Future<void> sendMessage(
      {List<Contact> recepients = const [],
      List<Contact> copyRecepients = const [],
      List<Contact> blindCopyRecepients = const [],
      String subject = "",
      String htmlContent = "",
      bool heeftPrioriteit = false,
      bool isConcept = false,
      VerzendOptie verzendOptie = VerzendOptie.standaard,
      int? gerelateerdBerichtId,
      List<UploadedAttachment> attachments = const []}) async {
    assert(
        verzendOptie != VerzendOptie.standaard &&
                gerelateerdBerichtId != null ||
            verzendOptie == VerzendOptie.standaard,
        "Duurgestuurde en beantwoordings berichten hebben een gerelateerdBerichtId nodig!");
    assert((recepients.isNotEmpty && !isConcept) || isConcept,
        "Er moeten 1 of meer ontvangers worden geselecteerd!");
    await magister.dio
        .post("berichten/${isConcept ? "concepten" : "berichten"}", data: {
      "ontvangers": List<dynamic>.from(
          recepients.map((x) => x.toMap()..["type"] = "persoon")),
      "kopieOntvangers": List<dynamic>.from(
          copyRecepients.map((x) => x.toMap()..["type"] = "persoon")),
      "blindeKopieOntvangers": List<dynamic>.from(
          blindCopyRecepients.map((x) => x.toMap()..["type"] = "persoon")),
      "heeftPrioriteit": heeftPrioriteit,
      "inhoud": htmlContent,
      "onderwerp": subject,
      "verzendOptie": verzendOptie.name,
      if (verzendOptie != VerzendOptie.standaard)
        "gerelateerdBerichtId": gerelateerdBerichtId,
      "bijlagen": List<dynamic>.from(attachments.map((x) => x.toMap()))
    });
  }

  Future<List<Contact>> searchContacts(
    String query, {
    int maxResults = 250,
  }) async {
    assert(query.length >= 2, "Query has to contain at least two characters");
    return List<Contact>.from((await magister.dio
            .get("contacten/personen?q=$query&top=$maxResults&type=alle"))
        .data["items"]
        .map((x) => Contact.fromMap(x)));
  }
}

enum VerzendOptie { beantwoord, standaard, doorgestuurd }

class UploadedFile {
  int id;
  String storageId;
  String uri;
  String method;

  UploadedFile({
    required this.id,
    required this.storageId,
    required this.uri,
    required this.method,
  });

  factory UploadedFile.fromMap(Map<String, dynamic> json) => UploadedFile(
        id: json["id"],
        storageId: json["storageId"],
        uri: json["uri"],
        method: json["method"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "storageId": storageId,
        "uri": uri,
        "method": method,
      };
}
