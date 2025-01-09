import 'package:dio/dio.dart';
import 'package:discipulus/api/dummy_routes/interceptors/demo_activity.dart';
import 'package:discipulus/api/dummy_routes/interceptors/demo_grades.dart';
import 'package:discipulus/api/dummy_routes/interceptors/demo_messages.dart';
import 'package:discipulus/api/models/schoolyears.dart';

class DemoInterceptor {
  RequestOptions options;
  final RequestInterceptorHandler handler;

  DemoInterceptor(this.options, this.handler);
}

class DummyInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dynamic data;

    data ??= MessagesInterceptor(options, handler).messageInterceptor;
    data ??= GradesInterceptor(options, handler).gradeInterceptor;
    data ??= ActivityInterceptor(options, handler).activityInterceptor;

    if (options.path.contains("leerlingen/0/aanmeldingen")) {
      data = {
        "items": List.generate(
          5,
          (index) {
            Groep group =
                Groep(id: index, code: "KL$index", omschrijving: "Klas $index");
            return {
              "id": index,
              "studie": {"id": index, "code": group.code},
              "groep": {
                "id": index,
                "code": group.code,
                "omschrijving": group.omschrijving,
              },
              "lesperiode": {"code": "EXT"},
              "profielen": [
                // group.toMap()
              ],
              "begin": DateTime.now()
                  .subtract(Duration(days: 365 * (index - 1)))
                  .toIso8601String(),
              "einde": DateTime.now()
                  .subtract(Duration(days: 365 * index))
                  .toIso8601String(),
              "isZittenBlijver": false,
              "indicatie": group.code,
              "opleidingCode": {"code": 12, "omschrijving": "Geen idee"},
              "persoonlijkeMentor": {
                "voorletters": "J.",
                "achternaam": "de Kat",
              },
              "links": {
                "self": {"href": "/api/aanmeldingen/$index"},
                "vakken": {"href": "/api/aanmeldingen/$index/vakken"},
                "perioden": {
                  "href": "/api/aanmeldingen/$index/cijfers/perioden"
                },
                "cijfers": {"href": "/api/aanmeldingen/$index/cijfers"},
                "mentoren": {"href": "/api/aanmeldingen/$index/mentoren"}
              },
            };
          },
        ),
        "totalCount": 5,
        "links": []
      };
    } else if (options.path.contains("leerlingen/0/studiewijzers/")) {
      data = {
        "Onderdelen": {
          "Items": [
            {
              "Bronnen": [],
              "Id": 1,
              "Links": [
                {
                  "Rel": "Self",
                  "Href": "/api/leerlingen/0/studiewijzers/0/onderdelen/1"
                },
              ],
              "Van": null,
              "TotEnMet": null,
              "Titel": "Dit is een voorbeeld",
              "Omschrijving":
                  "But we always blame anything other than our own perversity and bad nature, accusing old age, poverty, the circumstances, the day, the hour, the place",
              "IsZichtbaar": true,
              "Kleur": 0,
              "Volgnummer": 1
            },
            {
              "Bronnen": [],
              "Id": 2,
              "Links": [
                {
                  "Rel": "Self",
                  "Href": "/api/leerlingen/0/studiewijzers/0/onderdelen/2"
                },
              ],
              "Van": null,
              "TotEnMet": null,
              "Titel": "Dit is nog een voorbeeld",
              "Omschrijving":
                  "True Happiness is Founded in Invulnerability to Fortune",
              "IsZichtbaar": true,
              "Kleur": 2,
              "Volgnummer": 2
            },
            {
              "Bronnen": [],
              "Id": 3,
              "Links": [
                {
                  "Rel": "Self",
                  "Href": "/api/leerlingen/0/studiewijzers/0/onderdelen/3"
                },
              ],
              "Van": null,
              "TotEnMet": null,
              "Titel": "PTA",
              "Omschrijving":
                  "Just as you are master of your tongue, I am master of my ears",
              "IsZichtbaar": true,
              "Kleur": 4,
              "Volgnummer": 0
            }
          ],
          "TotalCount": 3,
          "Links": []
        }
      };
    }

    handler.resolve(Response(requestOptions: options, data: data));
  }
}
