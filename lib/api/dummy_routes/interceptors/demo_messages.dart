import 'dart:math';

import 'package:dio/dio.dart';
import 'package:discipulus/api/dummy_routes/interceptors.dart';
import 'package:html_unescape/html_unescape.dart';

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
              "self": "/api/berichten/concepten/$index",
              "map": "/api/berichten/concepten"
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
    } else if ((options.path.contains("berichten/mappen") ||
        options.path == "berichten/postvakin")) {
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
    int mapId = int.tryParse(options.path.split("/")[1]) ?? 1;

    return List.generate(count, (index) {
      DateTime date = DateTime.now().subtract(Duration(days: index));
      return {
        "id": index + mapId * 1000, // Unique id based on folder
        "onderwerp": HtmlUnescape().convert("Bericht $index van map $mapId"),
        "mapId": mapId,
        "afzender": {"id": index * 5, "naam": "Afzender $index"},
        "heeftPrioriteit": Random().nextBool(),
        "heeftBijlagen": Random().nextBool(),
        "isGelezen": Random().nextBool(),
        "verzondenOp": date.toIso8601String(),
        "links": {
          "self": "/api/berichten/${index == 1 ? "postvakin" : index}",
          "map": "/api/berichten/${index == 1 ? "postvakin" : index}",
          "bijlagen":
              "/api/berichten/${index == 1 ? "postvakin" : index}/bijlagen",
        },
        "inhoud": "<h1>Inhoud van bericht $index van map $mapId</h1>"
      };
    });
  }
}
