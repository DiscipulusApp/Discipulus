import 'dart:math';

import 'package:discipulus/api/dummy_routes/interceptors.dart';

class ActivityInterceptor extends DemoInterceptor {
  ActivityInterceptor(super.options, super.handler);

  dynamic get activityInterceptor {
    if (options.path.contains("activiteiten") &&
        options.path.contains("onderdelen")) {
      int activityId = int.tryParse(options.path.split("/")[1]) ?? 0;

      return {
        "Items": _generateDummyActivityElements(activityId, 5),
        "TotalCount": 5,
        "Links": []
      };
    }
  }

  List<Map<String, dynamic>> _generateDummyActivityElements(
      int activityId, int count) {
    return List.generate(count, (index) {
      Random random = Random(activityId * 100 + index);
      int places = random.nextInt(19) + 1;

      DateTime startDate = DateTime.now().add(Duration(days: index * 7));
      DateTime endDate =
          startDate.add(const Duration(days: 5)); // Example end date
      return {
        "Id": index + activityId * 100, // Unique id based on activity
        "StartInschrijfdatum": startDate.toIso8601String(),
        "EindeInschrijfdatum": endDate.toIso8601String(),
        "Titel": "Activity Element ${index + 1}",
        "Volgnummer": index + 1,
        "Details": "Details for element ${index + 1}",
        "ActiviteitId": activityId,
        "MaxAantalDeelnemers": places, // Example
        "MinAantalDeelnemers": 0, // Example
        "Kleurstelling": 0, // You might want to randomize or vary this
        "IsIngeschreven": random.nextBool(),
        "IsVerplichtIngeschreven": false,
        "AantalPlaatsenBeschikbaar": places - random.nextInt(5),
        "IsOpInTeSchrijven": true,
        "Links": [
          {
            "Rel": "Subscriptions",
            "Href":
                "/api/inschrijvingen/$activityId/$index/aanmelden", // Example subscription link
          },
          {
            "Rel": "Self",
            "Href":
                "/api/inschrijvingen/$activityId/$index", // Example self link
          },
          {
            "Rel": "Bronnen",
            "Href": "/api/inschrijvingen/$activityId/$index/bronnen",
          },
        ],
        "Bronnen": []
      };
    });
  }
}
