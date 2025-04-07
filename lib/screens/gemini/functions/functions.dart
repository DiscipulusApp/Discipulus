import 'dart:convert';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/screens/gemini/functions/logic.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

List<FunctionDeclaration> discipulusFunctions = [
  FunctionDeclaration(
    'navigateToScreen',
    'Navigeer naar een specifiek scherm binnen de Discipulus app.',
    Schema.object(
      properties: {
        "screen": Schema.enumString(
          enumValues: [
            for (var segment
                in destinations(activeProfile.account.value!.permissions))
              for (var destination in segment.destinations) destination.label
          ],
          description:
              "De naam van het scherm waarnaar genavigeerd moet worden. Bijvoorbeeld: 'Rooster', 'Cijfers', 'Berichten'. Kies exact één van de beschikbare opties.", // Duidelijker beschrijving met voorbeelden en instructie
        ),
      },
      requiredProperties: ["screen"],
    ),
  ),
  FunctionDeclaration(
    'getScheduleForDateRange',
    'Haal het lesrooster op voor een bepaalde periode. De periode mag maximaal 30 dagen lang zijn.',
    Schema.object(
      properties: {
        "date": Schema.string(
          description:
              "De startdatum van de periode waarvoor het rooster moet worden opgehaald. Formatteer de datum als YYYY-MM-DD. Bijvoorbeeld: '2024-09-15'.", // Verbeterde beschrijving met formaat instructie en voorbeeld in het Nederlands
        ),
        "dayAmount": Schema.integer(
          description:
              "Het aantal dagen van het rooster dat moet worden opgehaald, beginnend vanaf de opgegeven startdatum.  Moet een geheel getal zijn. Standaard is dit 1 dag, maximum is 12 dagen.", // Verbeterde beschrijving in het Nederlands, type gespecificeerd, standaard en maximum vermeld
        ),
        "events": Schema.array(
          items: Schema.object(
              description: "Een individueel lesrooster item.",
              properties: {
                "eventId": Schema.integer(),
                "lesuurVan": Schema.integer(),
                "lesuurTot": Schema.integer(),
                "start": Schema.string(
                    description:
                        "Starttijd van de les in ISO 8601 formaat (YYYY-MM-DDTHH:mm:ssZ)."),
                "end": Schema.string(
                    description:
                        "Eindtijd van de les in ISO 8601 formaat (YYYY-MM-DDTHH:mm:ssZ)."),
                "title": Schema.string(
                    description:
                        "De titel van de les, bijvoorbeeld 'Wiskunde'."),
                "description": Schema.string(
                    description:
                        "Extra details over de les, bijvoorbeeld 'Hoofdstuk 3' of 'Projectwerk'."),
                "location": Schema.string(
                    description:
                        "De locatie van de les, bijvoorbeeld 'Lokaal 101' of 'Gymzaal'."),
                "type": Schema.enumString(
                    enumValues: [for (var e in InfoType.values) e.toName],
                    description:
                        "Het type rooster item, bijvoorbeeld 'Les', 'Toets', 'Huiswerk'. Kies exact één van de beschikbare opties."),
                "status": Schema.enumString(
                    enumValues: [for (var e in Status.values) e.toName],
                    description:
                        "De status van het rooster item, bijvoorbeeld 'Gepland', 'Uitgevallen', 'Verplaatst'. Kies exact één van de beschikbare opties."),
                "aanwezigheid": Schema.string(
                    description:
                        "Aanwezigheidsinformatie, bijvoorbeeld 'Verplicht' of 'Optioneel'."),
                "afgerond": Schema.boolean(
                    description:
                        "Geeft aan of het huiswerk of de toets is afgerond (waar of niet waar)."),
              },
              requiredProperties: [
                "eventId",
                "lesuurVan",
                "lesuurTot",
                "start",
                "end",
                "title",
                "description",
                "location",
                "type",
                "status",
                "aanwezigheid",
                "afgerond",
              ]),
        )
      },
      requiredProperties: ["date"],
    ),
  ),
  FunctionDeclaration(
    'changeEvent',
    'Verander de details van een specifiek rooster item.',
    Schema.object(
      properties: {
        "eventId": Schema.string(
          description:
              "De unieke ID van het rooster item dat veranderd moet worden. Dit ID identificeert de specifieke les, toets of huiswerkopdracht.",
        ),
        "location": Schema.string(
          description:
              "De nieuwe locatie van de les, bijvoorbeeld 'Lokaal 101' of 'Gymzaal'.",
          nullable: true,
        ),
        "content": Schema.string(
          description:
              "Extra details over de les, bijvoorbeeld 'Hoofdstuk 3' of 'Projectwerk'.",
          nullable: true,
        ),
        "status": Schema.enumString(
          enumValues: [for (var e in Status.values) e.toName],
          description:
              "De nieuwe status van het rooster item, bijvoorbeeld 'Gepland', 'Uitgevallen', 'Verplaatst'. Kies exact één van de beschikbare opties.",
          nullable: true,
        ),
        "infoType": Schema.enumString(
          enumValues: [for (var e in InfoType.values) e.toName],
          description:
              "Het nieuwe type rooster item, bijvoorbeeld 'Les', 'Toets', 'Huiswerk'. Kies exact één van de beschikbare opties.",
          nullable: true,
        ),
        "done": Schema.boolean(
          description:
              "Geef aan of het rooster item als 'afgerond' (waar) of 'niet afgerond' (niet waar) moet worden gemarkeerd.",
          nullable: true,
        ),
      },
      requiredProperties: ["eventId"],
    ),
  ),
  FunctionDeclaration(
    'getMessages',
    'Haal een lijst op van de meest recente berichten van de gebruiker.',
    Schema.object(
      properties: {
        "messages": Schema.array(
          items: Schema.object(
            description: "Een individueel bericht.",
            properties: {
              "id": Schema.string(description: "De unieke ID van het bericht."),
              "subject":
                  Schema.string(description: "Het onderwerp van het bericht."),
              "sender": Schema.string(
                  description: "De naam van de afzender van het bericht."),
              "date": Schema.string(
                  description:
                      "De datum en tijd waarop het bericht is verzonden, in ISO 8601 formaat (YYYY-MM-DDTHH:mm:ssZ)."),
              "read": Schema.boolean(
                  description:
                      "Geeft aan of het bericht al gelezen is (waar of niet waar)."),
            },
            requiredProperties: [
              "id",
              "subject",
              "sender",
              "date",
              "read",
            ],
          ),
        ),
      },
      requiredProperties: ["messages"],
    ),
  ),
  FunctionDeclaration(
    'searchMessages',
    'Zoek berichten van de gebruiker op basis van een zoekterm.',
    Schema.object(
      properties: {
        "searchTerm": Schema.string(
          description:
              "De zoekterm die gebruikt moet worden om berichten te zoeken. Bijvoorbeeld: 'huiswerk' of 'cijferlijst'.", // Verbeterde beschrijving met voorbeeld in het Nederlands
        ),
        "messages": Schema.array(
          // 'messages' array behouden, structuur is goed
          items: Schema.object(
            description:
                "Een individueel bericht dat overeenkomt met de zoekterm.",
            properties: {
              "id": Schema.string(description: "De unieke ID van het bericht."),
              "subject":
                  Schema.string(description: "Het onderwerp van het bericht."),
              "sender": Schema.string(
                  description: "De naam van de afzender van het bericht."),
              "date": Schema.string(
                  description:
                      "De datum en tijd waarop het bericht is verzonden, in ISO 8601 formaat (YYYY-MM-DDTHH:mm:ssZ)."),
              "read": Schema.boolean(
                  description:
                      "Geeft aan of het bericht al gelezen is (waar of niet waar)."),
            },
            requiredProperties: [
              "id",
              "subject",
              "sender",
              "date",
              "read",
            ],
          ),
        ),
      },
      requiredProperties: [
        "searchTerm"
      ], // Alleen searchTerm is input, 'messages' is output
    ),
  ),
  FunctionDeclaration(
    'writeEmail',
    'Stel een nieuwe e-mail op.', // Verbeterde beschrijving in het Nederlands
    Schema.object(
      properties: {
        "recipient": Schema.string(
          description:
              "De naam van de ontvanger. Bijvoorbeeld: 'Joost'.", // Verbeterde beschrijving met voorbeeld
        ),
        "subject": Schema.string(
          description: "Het onderwerp van de e-mail.", // Beschrijving behouden
        ),
        "body": Schema.string(
          description:
              "De hoofdtekst van de e-mail. Dit is de inhoud van het bericht dat je wilt versturen.", // Verbeterde beschrijving, verduidelijkt 'body'
        ),
      },
      requiredProperties: ["recipient", "subject", "body"],
    ),
  ),
  FunctionDeclaration(
    'getMessageDetail',
    'Haal de volledige details van een specifiek bericht op, inclusief de inhoud en bijlagen.', // Verbeterde beschrijving in het Nederlands, specificeert details en bijlagen
    Schema.object(
      properties: {
        "id": Schema.string(
          description:
              "De ID van het bericht waarvan de details moeten worden opgehaald. Gebruik de ID van een bericht verkregen via `getMessages` of `searchMessages`.", // Verbeterde beschrijving met context en instructie over ID herkomst
        ),
        "subject": Schema.string(
            description:
                "Het onderwerp van het bericht."), // Beschrijving toegevoegd
        "content": Schema.string(
            description:
                "De volledige inhoud van het bericht, inclusief de tekst van de e-mail zelf."), // Beschrijving toegevoegd
        "sender": Schema.string(
            description:
                "De naam van de afzender van het bericht."), // Beschrijving toegevoegd
        "date": Schema.string(
            description:
                "De datum en tijd waarop het bericht is verzonden, in ISO 8601 formaat (YYYY-MM-DDTHH:mm:ssZ)."), // Beschrijving toegevoegd met formaat
        "read": Schema.boolean(
            description:
                "Geeft aan of het bericht al gelezen is (waar of niet waar)."), // Beschrijving toegevoegd
        "attachments": Schema.integer(
            description:
                "Het aantal bijlagen dat bij dit bericht hoort. Let op: de details van de bijlagen zelf worden hier niet gegeven."), // Beschrijving verduidelijkt, en waarschuwing over details
      },
      requiredProperties: [
        "id",
        // 'subject', 'content', 'sender', 'date', 'read', 'attachments' zijn output, 'id' is input
      ], // Alleen 'id' is echt nodig als input om details op te halen
    ),
  ),
  FunctionDeclaration(
    'getSchoolYears',
    'Haal een lijst op van alle beschikbare schooljaren.', // Verbeterde beschrijving in het Nederlands
    Schema.object(
      properties: {
        "schoolYears": Schema.array(
          items: Schema.object(
            description:
                "Een individueel schooljaar.", // Duidelijkere beschrijving van 'schoolYears' array items
            properties: {
              "id": Schema.string(
                  description:
                      "De unieke ID van het schooljaar."), // Beschrijving toegevoegd
              "name": Schema.string(
                  description:
                      "De naam van het schooljaar, bijvoorbeeld '2023-2024'."), // Beschrijving toegevoegd met voorbeeld
              "start": Schema.string(
                  description:
                      "De startdatum van het schooljaar in YYYY-MM-DD formaat."), // Beschrijving toegevoegd met formaat
              "end": Schema.string(
                  description:
                      "De einddatum van het schooljaar in YYYY-MM-DD formaat."), // Beschrijving toegevoegd met formaat
            },
            requiredProperties: [
              "id",
              "name",
              "start",
              "end",
            ],
          ),
        ),
      },
      requiredProperties: [
        "schoolYears"
      ], // 'schoolYears' is output, niet echt 'required' als input
    ),
  ),
  FunctionDeclaration(
    'getSubjectsForSchoolYear',
    'Haal een lijst op van de vakken die horen bij een specifiek schooljaar.', // Verbeterde beschrijving in het Nederlands
    Schema.object(
      properties: {
        "schoolYearId": Schema.string(
          description:
              "De ID van het schooljaar waarvoor de vakken moeten worden opgehaald. Gebruik een ID verkregen via `getSchoolYears`.", // Verbeterde beschrijving met context en instructie over ID herkomst
        ),
        "subjects": Schema.array(
          items: Schema.object(
            description:
                "Een individueel vak binnen het schooljaar.", // Duidelijkere beschrijving van 'subjects' array items
            properties: {
              "id": Schema.string(
                  description:
                      "De unieke ID van het vak."), // Beschrijving toegevoegd
              "name": Schema.string(
                  description:
                      "De naam van het vak, bijvoorbeeld 'Wiskunde', 'Nederlands', 'Engels'."), // Beschrijving toegevoegd met voorbeelden
            },
            requiredProperties: [
              "id",
              "name",
            ],
          ),
        ),
      },
      requiredProperties: [
        "schoolYearId"
      ], // Alleen schoolYearId is input, 'subjects' is output
    ),
  ),
  FunctionDeclaration(
    'getGradesForSubjects',
    'Haal de cijfers op voor een of meerdere specifieke vakken.', // Verbeterde beschrijving in het Nederlands, "een of meerdere"
    Schema.object(properties: {
      "subjects": Schema.array(
        items: Schema.string(
            description:
                "Een lijst van de namen van de vakken waarvoor de cijfers moeten worden opgehaald. Bijvoorbeeld: ['wiskunde', 'nederlands']. Gebruik de exacte vaknamen zoals weergegeven in Discipulus."), // Verbeterde beschrijving met instructie over exacte namen en voorbeeld in het Nederlands
      ),
    }, requiredProperties: [
      "subjects"
    ]),
  ),
  FunctionDeclaration(
    'getStudiewijzers',
    'Haal een lijst op van alle beschikbare studiewijzers.',
    Schema.object(
      properties: {
        "studiewijzers": Schema.array(
          items: Schema.object(
            description: "Een individuele studiewijzer.",
            properties: {
              "id": Schema.number(
                  description: "De unieke ID van de studiewijzer."),
              "name": Schema.string(
                description: "De naam van de studiewijzer.",
                nullable: true,
              ),
              "emoji": Schema.string(
                description: "Het emoji dat gebruikt wordt voor herkenning",
                nullable: true,
              ),
              "favorite": Schema.boolean(
                description: "If the studiewijzer is a favorite",
                nullable: true,
              )
            },
            requiredProperties: ["id"],
          ),
        ),
      },
      requiredProperties: ["studiewijzers"],
    ),
  ),
  FunctionDeclaration(
    'editStudiewijzer',
    'Pas een studiewijzer aan.',
    Schema.object(
      properties: {
        "id": Schema.number(description: "De unieke ID van de studiewijzer."),
        "name": Schema.string(
          description: "De nieuwe naam van de studiewijzer.",
          nullable: true,
        ),
        "emoji": Schema.string(
          description: "Het nieuwe emoji dat gebruikt wordt voor herkenning",
          nullable: true,
        ),
        "favorite": Schema.boolean(
          description: "Of de studiewijzer een favoriet is",
          nullable: true,
        )
      },
      requiredProperties: ["id"],
    ),
  ),
  FunctionDeclaration(
    'searchPeople',
    'Zoek naar mensen in de school.',
    Schema.object(
      properties: {
        "searchTerm": Schema.string(
          description:
              "De zoekterm die gebruikt moet worden om mensen te zoeken. Bijvoorbeeld: 'Jan Jansen' of 'jansen'.",
        ),
        "people": Schema.array(
          items: Schema.object(
            description: "Een persoon die overeenkomt met de zoekterm.",
            properties: {
              "id": Schema.string(description: "De unieke ID van de persoon."),
              "name": Schema.string(description: "De naam van de persoon."),
              "type": Schema.string(
                  description:
                      "Het type van de persoon, bijvoorbeeld 'leerling' of 'docent'."),
            },
            requiredProperties: [
              "id",
              "name",
              "type",
            ],
          ),
        ),
      },
      requiredProperties: ["searchTerm"],
    ),
  ),
];

Future<String> handleFunctionCall(FunctionCall functionCall) async {
  try {
    final result = await _executeFunction(functionCall);
    return jsonEncode(result);
  } catch (e) {
    return jsonEncode({'error': true, 'message': 'Error: ${e.toString()}'});
  }
}

Future<Map<String, dynamic>> _executeFunction(FunctionCall functionCall) async {
  switch (functionCall.name) {
    case 'writeEmail':
      return writeEmail(functionCall);
    case 'navigateToScreen':
      return navigateToScreen(functionCall);
    case 'getScheduleForDateRange':
      return getScheduleForDateRange(functionCall);
    case 'changeEvent':
      return changeEvent(functionCall);
    case 'getMessages':
      return getMessages(functionCall);
    case 'searchMessages':
      return searchMessages(functionCall);
    case 'getMessageDetail':
      return getMessageDetail(functionCall);
    case 'getSchoolYears':
      return getSchoolYears();
    case 'getSubjectsForSchoolYear':
      return getSubjectsForSchoolYear(functionCall);
    case 'getGradesForSubjects':
      return getGradesForSubjects(functionCall);
    case 'getStudiewijzers':
      return getStudiewijzers();
    case 'editStudiewijzer':
      return editStudiewijzer(functionCall);
    case 'searchPeople':
      return searchPeople(functionCall);
    default:
      return {
        'error': true,
        'message': "Function '${functionCall.name}' not recognized."
      };
  }
}

extension FunctionCallExtension on FunctionCall {
  String get readableName {
    switch (name) {
      case 'writeEmail':
        return 'E-mail schrijven';
      case 'navigateToScreen':
        return 'Navigeren naar scherm';
      case 'getScheduleForDateRange':
        return 'Rooster ophalen';
      case 'changeEvent':
        return 'Rooster item aanpassen';
      case 'getMessages':
        return 'Berichten ophalen';
      case 'searchMessages':
        return 'Berichten zoeken';
      case 'getMessageDetail':
        return 'Bericht details ophalen';
      case 'getSchoolYears':
        return 'Schooljaren ophalen';
      case 'getSubjectsForSchoolYear':
        return 'Vakken voor schooljaar ophalen';
      case 'getGradesForSubjects':
        return 'Cijfers voor vakken ophalen';
      case 'getStudiewijzers':
        return 'Studiewijzers ophalen';
      case 'editStudiewijzer':
        return 'Studiewijzer aanpassen';
      default:
        return 'Functie uitvoeren';
    }
  }
}
