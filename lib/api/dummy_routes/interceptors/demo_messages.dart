import 'package:dio/dio.dart';
import 'package:discipulus/api/dummy_routes/interceptors.dart';

class MessagesInterceptor extends DemoInterceptor {
  MessagesInterceptor(super.options, super.handler);

  dynamic get messageInterceptor {
    if (options.path.contains("berichten/concepten") &&
        !options.path.contains("count")) {
      // Get concepten (without count): /berichten/concepten
      return {
        "items": List.generate(12, (index) {
          return {
            "id": index,
            "onderwerp": "Concept ${index + 1}",
            "afzender": null, // Concepten don't have a sender initially
            "heeftPrioriteit": false,
            "heeftBijlagen": false,
            "isGelezen": true, // Concepten are considered read
            "verzondenOp": DateTime.now().toIso8601String(),
            "links": {
              "self": {"href": "/api/berichten/concepten/$index"},
              "map": {"href": "/api/berichten/concepten"}
            }
          };
        }),
        "totalCount": 14,
        "links": {
          "first": {"href": "/api/berichten/concepten?top=12"},
          "next": {"href": "/api/berichten/concepten?top=12&skip=12"},
          "last": {"href": "/api/berichten/concepten?top=12&skip=12"}
        }
      };
    } else if (options.path.contains("concepten") &&
        options.path.contains("count")) {
      //Get concept count
      return {"count": 14};
    } else if (options.path.contains("berichten/mappen/alle")) {
      // Get all message folders
      return {
        "items": [
          {
            "id": 1,
            "naam": "Postvak in",
            "aantalOngelezen": 2,
            "bovenliggendeId": 0,
            "links": {
              "berichten": {"href": "/api/berichten/postvakin"}
            }
          },
          {
            "id": 2,
            "naam": "Verzonden items",
            "aantalOngelezen": 0,
            "bovenliggendeId": 0,
            "links": {
              "berichten": {"href": "/api/berichten/verzonden"}
            }
          },
          {
            "id": 3,
            "naam": "Verwijderde items",
            "aantalOngelezen": 0,
            "bovenliggendeId": 0,
            "links": {
              "berichten": {"href": "/api/berichten/verwijderd"}
            }
          }
        ]
      };
    } else if ((options.path.contains("berichten/mappen") ||
        options.path.contains("berichten/postvakin") ||
        options.path.contains("berichten/verzonden") ||
        options.path.contains("berichten/verwijderd") ||
        options.path.contains("berichten/dummy"))) {
      // Get messages for a specific folder (inbox, sent, etc.): berichten/mappen/{mapId}/berichten
      return {
        "items": _generateDummyMessages(options, 12),
        "totalCount": 200,
        "links": {
          "first": {"href": "/api/berichten/dummy?top=12&skip=0"},
          "next": {"href": "/api/berichten/dummy?top=12&skip=12"},
          "last": {"href": "/api/berichten/dummy?top=12&skip=12"}
        }
      };
    } else if (options.path.contains("berichten/concepten/")) {
      return {
        "id":
            int.parse(options.path.split("/").last), // Use the ID from the path
        "onderwerp": "Onderwerp van het concept bericht",
        "mapId": -1, // Concepten don't have a mapId
        "afzender": null,
        "heeftPrioriteit": false,
        "heeftBijlagen": true,
        "isGelezen": true,
        "verzondenOp": DateTime.now().toIso8601String(),
        "links": {
          "self": "/api/berichten/concepten/${options.path.split("/").last}",
          "map": "/api/berichten/concepten",
          "bijlagen":
              "/api/berichten/concepten/${options.path.split("/").last}/bijlagen"
        },
        "inhoud":
            "<h1>Inhoud van het concept bericht</h1>", // Add dummy content
        "ontvangers": [],
        "kopieOntvangers": [],
        "blindeKopieOntvangers": []
      };
    } else if (options.path.contains("berichten/concepten/") &&
        options.path.contains("bijlagen")) {
      return {"items": [], "totalCount": 0, "links": []};
    } else if (options.path.contains("berichten/berichten") &&
        options.path.contains("/bijlagen")) {
      return {"items": [], "totalCount": 0, "links": []};
    }
  }

  List<Map<String, dynamic>> _generateDummyMessages(
      RequestOptions options, int count) {
    int mapId = 1;
    if (options.path.contains("verzonden")) {
      mapId = 2;
    } else if (options.path.contains("verwijderd")) {
      mapId = 3;
    } else {
      mapId = int.tryParse(options.path
              .split("/")
              .where((p) => int.tryParse(p) != null)
              .firstOrNull ??
          "") ??
          1;
    }

    final predefined = [
      (
        sender: "M. Eijkelkamp (Ekl)",
        subject: "Practicum Natuurkunde: Valversnelling & Meetverslagen",
        body:
            "<p>Beste leerlingen,</p><p>Denk eraan om morgen je grafische rekenmachine en practicumboek mee te nemen naar lokaal N003. We gaan aan de slag met de valbeweging en energiebehoud. Zorg dat je de theorie hebt doorgelezen.</p><p>Met vriendelijke groet,<br>M. Eijkelkamp</p>",
        priority: true,
        daysAgo: 0,
      ),
      (
        sender: "M. Eijkelkamp (Ekl)",
        subject: "Mentorupdate: Voortgangsgesprekken en profielkeuze",
        body:
            "<p>Beste klas,</p><p>Komende week starten we met de individuele mentor-voortgangsgesprekken. Schrijf je in voor een tijdslot via het intekenformulier.</p><p>Hartelijke groet,<br>M. Eijkelkamp (mentor 5 VWO)</p>",
        priority: false,
        daysAgo: 1,
      ),
      (
        sender: "Maarten van Rossem (ros)",
        subject: "Geschiedenis H4: De Koude Oorlog en het tijdperk",
        body:
            "<p>Beste leerlingen,</p><p>Voor de les van woensdag verwacht ik dat iedereen paragraaf 4.2 grondig heeft bestudeerd. Verwacht geen gemakkelijke toets; het vereist daadwerkelijk historisch inzicht.</p><p>M. van Rossem</p>",
        priority: false,
        daysAgo: 2,
      ),
      (
        sender: "Freek Vonk (vnk)",
        subject: "Practicum Biologie: Veldwerk & Microscopie in B012",
        body:
            "<p>Hoi allemaal!</p><p>Morgen gaan we cellen en preparaten onderzoeken met de microscopen in B012! Zorg dat je op tijd bent en je practicumjas meeneemt!</p><p>Groeten,<br>Freek Vonk</p>",
        priority: false,
        daysAgo: 3,
      ),
      (
        sender: "René Descartes (des)",
        subject: "Wiskunde B: Uitwerkingen hoofdstuk 4 online",
        body:
            "<p>Beste leerlingen,</p><p>De modeluitwerkingen voor Goniometrie en Differentiëren zijn toegevoegd aan de studiewijzer. Bestudeer vooral opgave 24 en 27 goed ter voorbereiding op het SE.</p><p>R. Descartes</p>",
        priority: false,
        daysAgo: 5,
      ),
      (
        sender: "Schoolleiding",
        subject: "Inschrijving Schoolreis Berlijn 5 VWO geopend",
        body:
            "<p>Beste leerlingen en ouders,</p><p>De inschrijving voor de jaarlijkse culturele reis naar Berlijn is geopend. Schrijf je in via het Activiteiten-overzicht in Discipulus.</p><p>Met vriendelijke groet,<br>Schoolleiding</p>",
        priority: true,
        daysAgo: 7,
      ),
    ];

    return List.generate(count, (index) {
      final msg = predefined[index % predefined.length];
      DateTime date = DateTime.now().subtract(Duration(days: msg.daysAgo + (index ~/ predefined.length) * 7));
      return {
        "id": index + mapId * 1000,
        "onderwerp": msg.subject,
        "mapId": mapId,
        "afzender": {"id": (index + 1) * 10, "naam": msg.sender},
        "heeftPrioriteit": msg.priority,
        "heeftBijlagen": index % 2 == 0,
        "isGelezen": index > 1,
        "verzondenOp": date.toIso8601String(),
        "links": {
          "self": {
            "href": "/api/berichten/${index == 1 ? "postvakin" : index}"
          },
          "map": {
            "href": "/api/berichten/${index == 1 ? "postvakin" : index}"
          },
          "bijlagen": {
            "href":
                "/api/berichten/${index == 1 ? "postvakin" : index}/bijlagen"
          },
        },
        "inhoud": msg.body,
      };
    });
  }
}
