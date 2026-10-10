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
            Groep group = index == 0
                ? Groep(id: 0, code: "5VWO", omschrijving: "5 VWO")
                : Groep(id: index, code: "KL$index", omschrijving: "Klas $index");
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
              "opleidingCode": {
                "code": 12,
                "omschrijving": index == 0 ? "VWO Bovenbouw" : "VWO Onderbouw"
              },
              "persoonlijkeMentor": {
                "voorletters": "M.",
                "achternaam": "Eijkelkamp",
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
    } else if (options.path.contains("/mentoren")) {
      data = {
        "items": [
          {
            "id": 1,
            "naam": "M. Eijkelkamp",
            "docentcode": "Ekl",
            "email": "m.eijkelkamp@school.nl"
          }
        ],
        "totalCount": 1
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
            },
            {
              "Bronnen": [],
              "Id": 4,
              "Links": [
                {
                  "Rel": "Self",
                  "Href": "/api/leerlingen/0/studiewijzers/0/onderdelen/3"
                },
              ],
              "Van": null,
              "TotEnMet": null,
              "Titel": "Wanneer de Vorst des lichts slaet aen de gulden tóómen",
              "Omschrijving":
"""
  Alright, ik denk niet dat bijzonder veel mensen dit gaan zien, 
  misschien nog wel meer inde daadwerkelijke code dan het dummy account, 
  maar ik moest gewoon even dit gedicht erin zetten. 
  
  Staat als het goed is ergens in het 5VWO Nederlands literatuur boek van Noordhof, 
  en ik heb die dus ooit moeten vertalen, wat je hier ziet. Ik snapte er echt helemaal 
  niets van in oud Nederlands, maar het was zo achterlijk gaaf om de "daadwerkelijke"
  betekenis te vinden, dat ik hem gewoon hier even kwijt wil. Dit is wel mijn interpretatie 
  van echt jaren geleden toen ik de huiswerk opdracht had, dus die van jou is waarschijnlijk anders haha. 

  <h2>Origineel (P.C. Hooft)</h2>
    Wanneer de Vorst des lichts slaet aen de gulden tóómen<br>
    Sijn handt, en beurt om hooch aensienlijck wter Zee<br>
    Sijn wtgespreide pruick van levend goudt, waermee<br>
    Hij naere anxtvallicheit, en vaeck, en creple dróómen<br>
    Van 's menschen lichaem strijckt, en berch, en bos, en bóómen,<br>
    En steeden vollickrijck, en velden met het vee<br>
    Jn duisternis verdwaelt, ons levert op haer stee,<br>
    Verheucht hij, met den dach, het Aerdtrijck en de stroomen:<br>
    Maer d' andre starren als naeijvrich van sijn licht,<br>
    Begraeft hij, met sijn glans, in duisternissen dicht,<br>
    En van d' ontelbre schaer, mach 't niemand bij hem houwen.<br>
    Al eveneens, wanneer vw Geest de mijne roert,<br>
    Word jck gewaer dat ghij in 't haijlich aenschijn voert<br>
    Voor mij den dach, mijn Son, de nacht voor d' andre vrouwen.

  <h2>Interpretatie</h2>
    Wanneer de zon opkomt en de zonnestralen in het zee oppervlak schitteren, verdrijft hij de narigheid van de nacht

    Het ontdoet mens, berg, bos, bomen en steden vol volk van duisternis, waarna de natuur weer zal verschijnen.

    De sterren stralen tevergeefs en worden bedolven onder de sterkte van het zonlicht. Niemand kan hem bijbenen.

    Net als wanneer u mijn gedachtes deelt, ben ik ervan overtuigd dat u de mooiste bent. Voor mij zijn andere vrouwen als de nacht voor de zon.
""",
              "IsZichtbaar": true,
              "Kleur": 5,
              "Volgnummer": 0
            }
          ],
          "TotalCount": 4,
          "Links": []
        }
      };
    }

    handler.resolve(Response(requestOptions: options, data: data));
  }
}
