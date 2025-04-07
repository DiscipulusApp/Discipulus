import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:isar/isar.dart';

Future<Map<String, dynamic>> getScheduleForDateRange(
    FunctionCall functionCall) async {
  final rawDate = functionCall.args['date'];
  final int? rawDays = int.tryParse(functionCall.args['dayAmount'].toString());

  DateTime date;
  try {
    date = DateTime.parse(rawDate.toString());
  } catch (e) {
    return {'error': true, 'message': 'Invalid date format. Use YYYY-MM-DD'};
  }

  List<CalendarEvent> events;
  try {
    events = await activeProfile.getEvents(
      DateTimeRange(
        start: date.dayOnly,
        end: date.dayOnly.add(Duration(days: rawDays ?? 1)),
      ),
    );
  } catch (e) {
    return {'error': true, 'message': 'Error fetching events: ${e.toString()}'};
  }

  return {
    "events": events
        .map((event) => {
              "id": event.id,
              "lesuurVan": event.lesuurVan,
              "lesuurTot": event.lesuurTotMet,
              "start": event.start.toLocal().toIso8601String(),
              "end": event.einde.toLocal().toIso8601String(),
              "title": event.title,
              "description": event.inhoud,
              "location": event.lokatie,
              "type": event.infoType.toName,
              "status": event.status.toName,
              "aanwezigheid": event.afwezigheid?.code ?? "onbepaald",
              "afgerond": event.afgerond,
            })
        .toList(),
  };
}

Future<Map<String, dynamic>> getMessages(FunctionCall functionCall) async {
  final folder =
      await activeProfile.berichtMappen.filter().idEqualTo(1).findFirst();
  if (folder == null) {
    return {'error': true, 'message': 'Message folder not found'};
  }
  final messages = await folder.berichten
      .filter()
      .sortByVerzondenOpDesc()
      .limit(50)
      .findAll();

  return {
    "messages": messages
        .map((message) => {
              "id": message.id,
              "subject": message.onderwerp,
              "sender": message.afzender?.naam,
              "date": message.verzondenOp.toIso8601String(),
              "read": message.isGelezen,
            })
        .toList(),
  };
}

Future<Map<String, dynamic>> searchMessages(FunctionCall functionCall) async {
  final searchTerm = functionCall.args['searchTerm'].toString();
  final folder =
      await activeProfile.berichtMappen.filter().idEqualTo(1).findFirst();
  if (folder == null) {
    return {'error': true, 'message': 'Message folder not found'};
  }
  await folder.getMessages(query: searchTerm, amount: 50);
  final messages = await folder.berichten
      .filter()
      .anyOf([searchTerm],
          (q, term) => q.onderwerpContains(term, caseSensitive: false))
      .or()
      .anyOf([searchTerm],
          (q, term) => q.inhoudContains(term, caseSensitive: false))
      .or()
      .anyOf(
          [searchTerm],
          (q, term) => q.afzender(
              (q) => q.naamContains(searchTerm, caseSensitive: false)))
      .sortByVerzondenOpDesc()
      .limit(50)
      .findAll();

  return {
    "messages": messages
        .map((message) => {
              "id": message.id,
              "subject": message.onderwerp,
              "sender": message.afzender?.naam,
              "date": message.verzondenOp.toIso8601String(),
              "read": message.isGelezen,
            })
        .toList(),
  };
}

Future<Map<String, dynamic>> getMessageDetail(FunctionCall functionCall) async {
  final messageId = int.tryParse(functionCall.args['id'].toString());
  if (messageId == null) {
    return {'error': true, 'message': 'Invalid message ID'};
  }
  final folder =
      await activeProfile.berichtMappen.filter().idEqualTo(1).findFirst();
  if (folder == null) {
    return {'error': true, 'message': 'Message folder not found'};
  }
  final message =
      await folder.berichten.filter().idEqualTo(messageId).findFirst();
  if (message == null) {
    return {'error': true, 'message': 'Message not found'};
  }

  await message.fill();

  return {
    "id": message.id,
    "subject": message.onderwerp,
    "content": message.inhoud,
    "sender": message.afzender?.naam,
    "date": message.verzondenOp.toIso8601String(),
    "read": message.isGelezen,
    "attachments": message.bronnen.length,
  };
}

Future<Map<String, dynamic>> getSchoolYears() async {
  final schoolYears = activeProfile.schoolyears.toList();
  return {
    "schoolYears": schoolYears
        .map((schoolYear) => {
              "id": schoolYear.uuid,
              "name": schoolYear.groep.omschrijving,
              "start": schoolYear.begin.toIso8601String(),
              "end": schoolYear.einde.toIso8601String(),
            })
        .toList(),
  };
}

Future<Map<String, dynamic>> getSubjectsForSchoolYear(
    FunctionCall functionCall) async {
  final schoolYearId =
      int.tryParse(functionCall.args['schoolYearId'].toString());
  if (schoolYearId == null) {
    return {'error': true, 'message': 'Invalid school year ID'};
  }
  final schoolYear = await activeProfile.schoolyears
      .filter()
      .uuidEqualTo(schoolYearId)
      .findFirst();
  if (schoolYear == null) {
    return {'error': true, 'message': 'School year not found'};
  }
  final subjects = schoolYear.subjects.toList();

  return {
    "schoolYearId": schoolYearId,
    "subjects": subjects
        .map((subject) => {
              "id": subject.uuid,
              "name": subject.naam,
            })
        .toList(),
  };
}

Future<Map<String, dynamic>> getGradesForSubjects(
    FunctionCall functionCall) async {
  final List<String> subjectNames =
      List<String>.from(functionCall.args['subjects'] as List);

  final subjects = await activeProfile.activeSchoolyear.subjects
      .filter()
      .anyOf(subjectNames, (q, name) => q.naamContains(name))
      .findAll();

  return {for (var subject in subjects) subject.naam: subject.grades.average};
}

Future<Map<String, dynamic>> navigateToScreen(FunctionCall functionCall) {
  final screenName = functionCall.args['screen'];
  final destination = destinations(activeProfile.account.value!.permissions)
      .expand((e) => e.destinations)
      .firstWhere((e) => e.label == screenName);

  Layout.of(navKey.currentContext!)!.goToPage(destination.view);

  return Future.value(
      {'success': true, 'message': 'Navigating to $screenName'});
}

Future<Map<String, dynamic>> writeEmail(FunctionCall functionCall) {
  final recipient = functionCall.args['recipient'].toString();
  final subject = functionCall.args['subject'].toString();
  final body = functionCall.args['body'].toString();

  showComposeMessageSheet(navKey.currentState!.context,
      message: Bericht(
        id: -1,
        rawOnderwerp: subject,
        mapId: 1,
        afzender: Afzender(),
        heeftPrioriteit: false,
        heeftBijlagen: false,
        isGelezen: false,
        verzondenOp: DateTime.now(),
        links: ItemLinks(),
        inhoud: body,
      ));

  return Future.value({
    'success': true,
    'message':
        'Opened concept with recipient $recipient, subject "$subject" and body "$body"'
  });
}

Future<Map<String, dynamic>> changeEvent(FunctionCall functionCall) async {
  final eventId = int.parse(functionCall.args['eventId'].toString());
  final done = functionCall.args['done'] as bool?;
  final location = functionCall.args['location']?.toString();
  final content = functionCall.args['content']?.toString();
  final status = functionCall.args['status']?.toString();
  final infoType = functionCall.args['infoType']?.toString();

  final event = await activeProfile.calendarEvents
      .filter()
      .idEqualTo(eventId)
      .findFirst();

  if (event == null) {
    return {'error': true, 'message': 'Event not found'};
  }

  if (location != null) {
    event.lokatie = location;
  }
  if (content != null) {
    event.inhoud = content;
  }
  if (status != null) {
    event.status = Status.values.firstWhere((e) => e.toName == status);
  }
  if (infoType != null) {
    event.infoType = InfoType.values.firstWhere((e) => e.toName == infoType);
  }
  if (done != null) {
    event.afgerond = done;
  }

  await event.sync();
  event.save();

  return {
    'success': true,
    'message': 'Event updated successfully',
    "event": {
      "eventId": event.id,
      "lesuurVan": event.lesuurVan,
      "lesuurTot": event.lesuurTotMet,
      "start": event.start.toIso8601String(),
      "end": event.einde.toIso8601String(),
      "title": event.title,
      "description": event.inhoud,
      "location": event.lokatie,
      "type": event.infoType.toName,
      "status": event.status.toName,
      "aanwezigheid": event.afwezigheid?.code ?? "onbepaald",
      "afgerond": event.afgerond,
    }
  };
}

Future<Map<String, dynamic>> getStudiewijzers() async {
  return {
    "studiewijzers": activeProfile.studiewijzers
        .toList()
        .map((studiewijzer) => {
              "id": studiewijzer.id,
              "name": studiewijzer.titel,
              "emoji": studiewijzer.customEmojiIcon,
              "favorite": studiewijzer.isFavorite,
            })
        .toList(),
  };
}

Future<Map<String, dynamic>> editStudiewijzer(FunctionCall functionCall) async {
  final studiewijzerId = int.parse(functionCall.args['id'].toString());
  final name = functionCall.args['name']?.toString();
  final emoji = functionCall.args['emoji']?.toString();
  final favorite = functionCall.args['favorite'] as bool?;

  final studiewijzer = await activeProfile.studiewijzers
      .filter()
      .idEqualTo(studiewijzerId)
      .findFirst();

  if (studiewijzer == null) {
    return {'error': true, 'message': 'Studiewijzer not found'};
  }

  if (name != null) {
    studiewijzer.titel = name;
  }
  if (emoji != null) {
    studiewijzer.customEmojiIcon = emoji;
  }
  if (favorite != null) {
    studiewijzer.isFavorite = favorite;
  }

  studiewijzer.save();

  return {
    'success': true,
    'message': 'Studiewijzer updated successfully',
    "studiewijzer": {
      "id": studiewijzer.id,
      "name": studiewijzer.titel,
      "emoji": studiewijzer.customEmojiIcon,
      "favorite": studiewijzer.isFavorite,
    }
  };
}

Future<Map<String, dynamic>> searchPeople(FunctionCall functionCall) async {
  final searchTerm = functionCall.args['searchTerm'].toString();
  final people = await activeProfile.account.value!.api.messages
      .searchContacts(searchTerm);

  return {
    "people": people
        .map((person) => {
              "id": person.id,
              "name": person.fullName,
              "type": person.type,
            })
        .toList(),
  };
}
