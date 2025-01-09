import 'dart:io';

import 'package:discipulus/api/dummy_magister_api_dart.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/routes/messages.dart';

class DummyMessagesRoute implements MessagesRoute {
  @override
  Future<List<MessagesFolder>> get folders async => Future.value([
        MessagesFolder(
          aantalOngelezen: 2,
          id: 1,
          bovenliggendeId: 0,
          naam: "Postvak in",
          berichtenLink: "/api/berichten/postvakin",
        ),
        MessagesFolder(
          aantalOngelezen: 0,
          id: 2,
          bovenliggendeId: 0,
          naam: "Verzonden items",
          berichtenLink: "/api/berichten/dummy",
        ),
        MessagesFolder(
          aantalOngelezen: 0,
          id: 3,
          bovenliggendeId: 0,
          naam: "Verwijderde items",
          berichtenLink: "/api/berichten/dummy",
        ),
      ]);

  @override
  Future<List<Bericht>> getConcepts(
      {int amount = 15, int skip = 0, String? query}) async {
    return Future.value(List.generate(
      amount,
      (index) => Bericht(
        id: index,
        rawOnderwerp:
            query != null ? "$query bericht $index" : "Bericht $index",
        mapId: 0,
        afzender: Afzender(naam: "Deurmat"),
        heeftPrioriteit: index.isEven,
        heeftBijlagen: (index * 3).isEven,
        isGelezen: index < 2,
        verzondenOp: DateTime.now().subtract(Duration(days: index)),
        inhoud: "<h1>Kijk voor de broncode op Github ;)</h1>",
        ontvangers: [
          Ontvanger(weergavenaam: "Harry", type: "Leerling"),
          Ontvanger(weergavenaam: "Loo", type: "Docent")
        ],
        links: ItemLinks(),
      ),
    ));
  }

  @override
  Magister get magister => DummyMagister();

  @override
  Future<List<Contact>> searchContacts(
    String query, {
    int maxResults = 15,
  }) async {
    return Future.value(List.generate(
      maxResults,
      (index) => Contact(id: index, roepnaam: query),
    ));
  }

  @override
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
    // This does not do anything, because you can't send messages in demo or
    // dummy mode!
  }

  @override
  Future<UploadedAttachment> uploadFile(
    File file,
    void Function(int p1, int p2)? onSendProgres, {
    bool messageAttachment = true,
  }) async {
    return Future.value(
      UploadedAttachment(
        id: file.hashCode,
        naam: file.path.split("/").last,
      ),
    );
  }

  @override
  Future<void> moveToFolder(List<Bericht> messages,
      {required int folderId}) async {}

  @override
  Future<void> remove(List<Bericht> messages) async {}

  @override
  Future<void> markAsRead(List<Bericht> messages, {required bool read}) async {}
}
