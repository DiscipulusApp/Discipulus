import 'dart:convert';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/screens/gemini/functions/ai_models.dart';
import 'package:discipulus/screens/gemini/functions/logic.dart';
import 'package:discipulus/utils/account_manager.dart';

List<AIFunctionDeclaration> discipulusFunctions = [
  AIFunctionDeclaration(
    'navigateToScreen',
    'Navigeer naar een specifiek scherm binnen de Discipulus app.',
    AISchema.object(
      properties: {
        "screen": AISchema.enumString(
          enumValues: [
            for (var segment
                in destinations(activeProfile.account.value!.permissions))
              for (var destination in segment.destinations) destination.label
          ],
          description:
              "De naam van het scherm waarnaar genavigeerd moet worden. Bijvoorbeeld: 'Rooster', 'Cijfers', 'Berichten'. Kies exact één van de beschikbare opties.",
        ),
      },
      requiredProperties: ["screen"],
    ),
  ),
  AIFunctionDeclaration(
    'getScheduleForDateRange',
    'Haal het lesrooster op voor een bepaalde periode. De periode mag maximaal 30 dagen lang zijn.',
    AISchema.object(
      properties: {
        "date": AISchema.string(
          description:
              "De startdatum van de periode waarvoor het rooster moet worden opgehaald. Formatteer de datum als YYYY-MM-DD. Bijvoorbeeld: '2024-09-15'.",
        ),
        "dayAmount": AISchema.integer(
          description:
              "Het aantal dagen van het rooster dat moet worden opgehaald, beginnend vanaf de opgegeven startdatum. Moet een geheel getal zijn. Standaard is dit 1 dag, maximum is 12 dagen.",
        ),
      },
      requiredProperties: ["date"],
    ),
  ),
  AIFunctionDeclaration(
    'changeEvent',
    'Verander de details van een specifiek rooster item.',
    AISchema.object(
      properties: {
        "eventId": AISchema.string(
          description:
              "De unieke ID van het rooster item dat veranderd moet worden. Dit ID identificeert de specifieke les, toets of huiswerkopdracht.",
        ),
        "location": AISchema.string(
          description:
              "De nieuwe locatie van de les, bijvoorbeeld 'Lokaal 101' of 'Gymzaal'.",
          nullable: true,
        ),
        "content": AISchema.string(
          description:
              "Extra details over de les, bijvoorbeeld 'Hoofdstuk 3' of 'Projectwerk'.",
          nullable: true,
        ),
        "status": AISchema.enumString(
          enumValues: [for (var e in Status.values) e.toName],
          description:
              "De nieuwe status van het rooster item, bijvoorbeeld 'Gepland', 'Uitgevallen', 'Verplaatst'. Kies exact één van de beschikbare opties.",
          nullable: true,
        ),
        "infoType": AISchema.enumString(
          enumValues: [for (var e in InfoType.values) e.toName],
          description:
              "Het nieuwe type rooster item, bijvoorbeeld 'Les', 'Toets', 'Huiswerk'. Kies exact één van de beschikbare opties.",
          nullable: true,
        ),
        "done": AISchema.boolean(
          description:
              "Geef aan of het rooster item als 'afgerond' (waar) of 'niet afgerond' (niet waar) moet worden gemarkeerd.",
          nullable: true,
        ),
      },
      requiredProperties: ["eventId"],
    ),
  ),
  AIFunctionDeclaration(
    'getMessages',
    'Haal een lijst op van de meest recente berichten van de gebruiker.',
    AISchema.object(
      properties: {},
    ),
  ),
  AIFunctionDeclaration(
    'searchMessages',
    'Zoek berichten van de gebruiker op basis van een zoekterm.',
    AISchema.object(
      properties: {
        "searchTerm": AISchema.string(
          description:
              "De zoekterm die gebruikt moet worden om berichten te zoeken. Bijvoorbeeld: 'huiswerk' of 'cijferlijst'.",
        ),
      },
      requiredProperties: ["searchTerm"],
    ),
  ),
  AIFunctionDeclaration(
    'writeEmail',
    'Stel een nieuwe e-mail op.',
    AISchema.object(
      properties: {
        "recipient": AISchema.string(
          description: "De naam van de ontvanger. Bijvoorbeeld: 'Joost'.",
        ),
        "subject": AISchema.string(
          description: "Het onderwerp van de e-mail.",
        ),
        "body": AISchema.string(
          description:
              "De hoofdtekst van de e-mail. Dit is de inhoud van het bericht dat je wilt versturen.",
        ),
      },
      requiredProperties: ["recipient", "subject", "body"],
    ),
  ),
  AIFunctionDeclaration(
    'getMessageDetail',
    'Haal de volledige details van een specifiek bericht op, inclusief de inhoud en bijlagen.',
    AISchema.object(
      properties: {
        "id": AISchema.string(
          description:
              "De ID van het bericht waarvan de details moeten worden opgehaald. Gebruik de ID van een bericht verkregen via `getMessages` of `searchMessages`.",
        ),
      },
      requiredProperties: ["id"],
    ),
  ),
  AIFunctionDeclaration(
    'getSchoolYears',
    'Haal een lijst op van alle beschikbare schooljaren.',
    AISchema.object(
      properties: {},
    ),
  ),
  AIFunctionDeclaration(
    'getSubjectsForSchoolYear',
    'Haal een lijst op van de vakken die horen bij een specifiek schooljaar.',
    AISchema.object(
      properties: {
        "schoolYearId": AISchema.string(
          description:
              "De ID van het schooljaar waarvoor de vakken moeten worden opgehaald. Gebruik een ID verkregen via `getSchoolYears`.",
        ),
      },
      requiredProperties: ["schoolYearId"],
    ),
  ),
  AIFunctionDeclaration(
    'getGradesForSubjects',
    'Haal de cijfers op voor een of meerdere specifieke vakken.',
    AISchema.object(
      properties: {
        "subjects": AISchema.array(
          items: AISchema.string(
              description:
                  "Een lijst van de namen van de vakken waarvoor de cijfers moeten worden opgehaald. Bijvoorbeeld: ['wiskunde', 'nederlands']. Gebruik de exacte vaknamen zoals weergegeven in Discipulus."),
        ),
      },
      requiredProperties: ["subjects"],
    ),
  ),
  AIFunctionDeclaration(
    'getStudiewijzers',
    'Haal een lijst op van alle beschikbare studiewijzers.',
    AISchema.object(
      properties: {},
    ),
  ),
  AIFunctionDeclaration(
    'editStudiewijzer',
    'Pas een studiewijzer aan.',
    AISchema.object(
      properties: {
        "id": AISchema.number(description: "De unieke ID van de studiewijzer."),
        "name": AISchema.string(
          description: "De nieuwe naam van de studiewijzer.",
          nullable: true,
        ),
        "emoji": AISchema.string(
          description: "Het nieuwe emoji dat gebruikt wordt voor herkenning",
          nullable: true,
        ),
        "favorite": AISchema.boolean(
          description: "Of de studiewijzer een favoriet is",
          nullable: true,
        )
      },
      requiredProperties: ["id"],
    ),
  ),
  AIFunctionDeclaration(
    'searchPeople',
    'Zoek naar mensen in de school.',
    AISchema.object(
      properties: {
        "searchTerm": AISchema.string(
          description:
              "De zoekterm die gebruikt moet worden om mensen te zoeken. Bijvoorbeeld: 'Jan Jansen' of 'jansen'.",
        ),
      },
      requiredProperties: ["searchTerm"],
    ),
  ),
];

Future<String> handleFunctionCall(AIFunctionCall functionCall) async {
  try {
    final result = await _executeFunction(functionCall);
    return jsonEncode(result);
  } catch (e) {
    return jsonEncode({'error': true, 'message': 'Error: ${e.toString()}'});
  }
}

Future<Map<String, dynamic>> _executeFunction(AIFunctionCall functionCall) async {
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

extension AIFunctionCallExtension on AIFunctionCall {
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
