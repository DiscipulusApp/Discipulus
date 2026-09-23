import 'dart:io';
import 'dart:math';

import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:path_provider/path_provider.dart';

import 'package:collection/collection.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/mcp/mcp_tools.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';


class McpService {

  static final String _noProfileError = "Discipulus does not have an active tokenSet, perhaps you forgot to login? Please set this up by opening the Discipulus app.";

  /// Fetches schedule timetable appointments for a date range
  static Future<String> getSchedule(Map<String, dynamic> args) async {

    // This can run with out an account being signed in, since 
    // it can be run without the app ever being opened, therefor we check
    // if there is a active tokenSet available.
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    // Args from discipulus_get_schedule
    final String startDateStr = args['startDate'] as String;
    final String endDateStr = args['endDate'] as String;
    final String? subject = args['subject'] as String?;
    final bool onlyTests = args['onlyTests'] as bool? ?? false;
    final bool onlyHomework = args['onlyHomework'] as bool? ?? false;

    DateTime start = DateTime.tryParse(startDateStr) ??
        DateTime.now().dayOnly; // Default today
    DateTime end = DateTime.tryParse(endDateStr) ?? 
       start.add(const Duration(days: 7)); // Default seven days from today

    // If both days are the same, add one day to end automatically
    if (start.dayOnly.millisecondsSinceEpoch == end.dayOnly.millisecondsSinceEpoch) {
      end = end.add(const Duration(days: 1));
    } 

    final range = DateTimeRange(start: start, end: end);

    try {
      await activeProfile.getEvents(range);
    } catch (e) {
      stderr.writeln("Could not fetch calendar events: $e");
    }

    // Get events from storage
    List<CalendarEvent> events = await activeProfile.calendarEvents
        .filter()
        .startGreaterThan(start, include: true)
        .and()
        .eindeLessThan(end, include: true)
        .optional(onlyHomework, (q) => q.infoTypeEqualTo(InfoType.homework))
        .optional(onlyTests, (q) => q.infoTypeBetween(InfoType.test, InfoType.oralExam))
        .optional(subject != null, (q) => q.subject((q) => q.naamContains(subject!, caseSensitive: false).or().afkortingContains(subject, caseSensitive: false)))
        .sortByStart()
        .findAll();

    if (events.isEmpty) return "No events found.";

    return events.map((e) {
      final desc = e.inhoud?.withoutHTML?.trim() ?? e.omschrijving?.withoutHTML?.trim() ?? '';
      final preview = desc.length > 50 ? '${desc.substring(0, 50)}...' : desc;
      final subjectName = e.vakken?.map((v) => v.naam).whereType<String>().join(', ') ?? '';
      final teachers = e.docenten?.map((d) => d.naam).whereType<String>().join(', ') ?? '';

      return """
ID: ${e.id}
Title: ${e.title}
Subject: $subjectName
Start: ${e.start.toIso8601String()}
End: ${e.einde.toIso8601String()}
Location: ${e.lokatie ?? ''}
Teacher: $teachers
Status: ${e.status.toName}
Type: ${e.infoType.toName}
IsCompleted: ${e.afgerond}
Notes: $preview""";
    }).join('\n---\n');
  }

  /// Fetches complete details for a single calendar event by its ID, also performs a refresh
  static Future<String> getEventDetail(Map<String, dynamic> args) async {

    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final int eventId = args['id'] as int;

    final CalendarEvent? event = await isar.calendarEvents.filter().idEqualTo(eventId).findFirst();
    if (event == null) return "Event with ID $eventId not found.";

    await event.sync();

    final content = event.inhoud?.withoutHTML?.trim() ?? event.omschrijving?.withoutHTML?.trim() ?? '';
    final subjectName = event.vakken?.map((v) => v.naam).whereType<String>().join(', ') ?? '';
    final teachers = event.docenten?.map((d) => d.naam).whereType<String>().join(', ') ?? '';
    final attachments = event.bronnen.isNotEmpty
        ? event.bronnen
            .map((b) =>
                "${b.naam} (ID: ${b.id}, Size: ${b.grootte} bytes, LocalPath: ${b.savedPath ?? 'Not downloaded'})")
            .join(', ')
        : 'None';

    return """
ID: ${event.id}
Title: ${event.title}
Subject: $subjectName
Start: ${event.start.toIso8601String()}
End: ${event.einde.toIso8601String()}
Location: ${event.lokatie ?? ''}
Teacher: $teachers
Type: ${event.infoType.toName}
Status: ${event.status.toName}
IsCompleted: ${event.afgerond}
Attachments: $attachments
Content: $content""";
  }

  /// Fetches grades from Magister across all school years, respecting the custom passing grade threshold.
  static Future<String> getGrades(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    // Args
    final int limit = (args['limit'] as int?) ?? 25;
    final String? startDateStr = args['startDate'] as String?;
    final String? endDateStr = args['endDate'] as String?;
    final String? subject = args['subject'] as String?;
    final DateTime? start = startDateStr != null ? DateTime.tryParse(startDateStr) : null;
    final DateTime? end = endDateStr != null ? DateTime.tryParse(endDateStr) : null;

    // Getting all the schoolyears as we still need to call `.syncGrades()`
    final List<Schoolyear> schoolyears = await activeProfile.schoolyears
        .filter()
        .optional(start != null, (q) => q.eindeGreaterThan(start!, include: true))
        .optional(end != null, (q) => q.beginLessThan(end!, include: true))
        .sortByEindeDesc()
        .findAll();

    try {
      await Future.wait(schoolyears.map((Schoolyear sy) => sy.fillGrades()));
    } catch (e) {
      stderr.writeln("Could not fetch grades: $e");
    }

    final List<Grade> grades = await isar.grades
        .filter()
        .schoolyear((q) => q
            .profile((q) => q.uuidEqualTo(activeProfile.uuid))
            .optional(start != null, (q) => q.eindeGreaterThan(start!, include: true))
            .optional(end != null, (q) => q.beginLessThan(end!, include: true)))
        .useable()
        .optional(
            subject != null && subject.trim().isNotEmpty,
            (q) => q.subject((q) => q
                .naamContains(subject!.trim(), caseSensitive: false)
                .or()
                .afkortingContains(subject.trim(), caseSensitive: false)))
        .optional(start != null,
            (q) => q.datumIngevoerdGreaterThan(start!, include: true))
        .optional(end != null,
            (q) => q.datumIngevoerdLessThan(end!, include: true))
        .sortByDatumIngevoerdDesc()
        .limit(limit)
        .findAll();

    if (grades.isEmpty) return "No grades found.";

    return grades.map((Grade g) {
      if (g.subject.value == null && g.subject.isAttached) {
        g.subject.loadSync();
      }
      final bool isVoldoende = g.grade != -1 ? g.grade >= appSettings.sufficientFrom : g.isVoldoende;
      return """
Subject: ${g.subject.value?.naam.capitalized ?? ''}
Grade: ${g.cijferStr ?? (g.grade != -1 ? g.grade.displayNumber(decimalDigits: 1) : '')}
IsVoldoende: $isVoldoende
Weight: ${g.weight != null ? g.weight!.displayNumber() : 0}
Description: ${g.cijferKolom.kolomOmschrijving ?? ''}
IsPTA: ${g.cijferKolom.isPtaKolom}
Date: ${g.datumIngevoerd?.toIso8601String() ?? ''}""";
    }).join('\n---\n');
  }

  /// Fetches calculated subject averages across all school years.
  static Future<String> getSubjectAverages(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final subject = args['subject'] as String?;
    final bool rounded = args['rounded'] as bool? ?? false;

    final schoolyears =
        await activeProfile.schoolyears.filter().sortByEindeDesc().findAll();

    try {
      await Future.wait(schoolyears.map((sy) => sy.fillGrades()));
    } catch (e) {
      stderr.writeln("Could not fetch grades for subject averages: $e");
    }

    final subFilter = subject?.trim().toLowerCase();
    final List<String> lines = [];

    for (final sy in schoolyears) {
      var subjects = sy.subjects.toList();
      if (subFilter != null && subFilter.isNotEmpty) {
        subjects = subjects
            .where((s) =>
                s.naam.toLowerCase().contains(subFilter) ||
                s.afkorting.toLowerCase().contains(subFilter))
            .toList();
      }

      for (final s in subjects) {
        final double avg = s.grades.average;
        if (!avg.isNaN) {
          final isVoldoende = avg >= appSettings.sufficientFrom;
          lines.add("""
Subject: ${s.naam.capitalized} (${s.afkorting})
Average: ${avg.displayNumber(decimalDigits: rounded ? 0 : 2)}
IsVoldoende: $isVoldoende
Schoolyear: ${sy.groep.omschrijving}""");
        }
      }
    }

    if (lines.isEmpty) return "No subject averages found.";
    return lines.join('\n---\n');
  }

  /// Fetches assignments.
  static Future<String> getAssignments(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final bool onlyOpen = args['onlyOpen'] as bool? ?? false;
    final String? subject = args['subject'] as String?;

    try {
      await activeProfile.getAssignments();
    } catch (e) {
      stderr.writeln("Could not fetch assignments: $e");
    }

    final List<Assignment> assignments = await activeProfile.assignments
        .filter()
        .optional(onlyOpen, (q) => q.afgeslotenEqualTo(false))
        .optional(subject != null && subject.trim().isNotEmpty,
            (q) => q.vakContains(subject!.trim(), caseSensitive: false))
        .sortByInleverenVoorDesc()
        .findAll();

    if (assignments.isEmpty) return "No assignments found.";

    return assignments.map((Assignment a) {
      final desc = (a.omschrijving.withoutHTML ?? '').trim();
      final preview = desc.length > 120 ? '${desc.substring(0, 120)}...' : desc;
      return """
ID: ${a.id}
Title: ${a.titel}
Subject: ${a.vak}
DueDate: ${a.inleverenVoor.toIso8601String()}
Status: ${a.statusLaatsteOpdrachtVersie.name}
IsClosed: ${a.afgesloten}
Description: $preview""";
    }).join('\n---\n');
  }

  /// Fetches full description, rubric, and submission versions of an assignment.
  static Future<String> getAssignmentDetail(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final int assignentId = args['id'] as int;

    final Assignment? assignment = await isar.assignments.filter().idEqualTo(assignentId).findFirst();
    if (assignment == null) return "Assignment with ID $assignentId not found.";

    try {
      await assignment.fill();
    } catch (e) {
      stderr.writeln("Could not fetch assignment detail: $e");
    }

    final desc = (assignment.omschrijving.withoutHTML ?? '').trim();
    final versions = await assignment.versies.filter().sortByIngeleverdOpDesc().findAll();
    final versionsText = versions.map((v) {
      final files = v.leerlingBijlagen.isNotEmpty
          ? v.leerlingBijlagen
              .map((b) =>
                  "${b.naam} (ID: ${b.id}, Size: ${b.grootte} bytes, LocalPath: ${b.savedPath ?? 'Not downloaded'})")
              .join(', ')
          : 'None';
      return """
- SubmittedAt: ${v.ingeleverdOp?.toIso8601String() ?? ''}
  VersionNumber: ${v.versieNummer}
  StudentNote: ${(v.leerlingOpmerking?.withoutHTML ?? '').trim()}
  TeacherFeedback: ${(v.docentOpmerking?.withoutHTML ?? '').trim()}
  Assessment: ${(v.beoordeling?.withoutHTML ?? '').trim()}
  Files: $files""";
    }).join('\n');

    return """
ID: ${assignment.id}
Title: ${assignment.titel}
Subject: ${assignment.vak}
DueDate: ${assignment.inleverenVoor.toIso8601String()}
Status: ${assignment.statusLaatsteOpdrachtVersie.name}
IsClosed: ${assignment.afgesloten}
Description: $desc
Submissions:
${versionsText.isEmpty ? 'None' : versionsText}""";
  }

  /// Fetches recent inbox messages, getting folders first.
  static Future<String> getMessages(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final limit = args['limit'] as int;
    final unreadOnly = args['unreadOnly'] as bool? ?? false;
    final query = args['query'] as String?;

    try {
      final List<MessagesFolder> folders = await activeProfile.getBerichtMappen;
      final MessagesFolder? inbox = folders.firstWhereOrNull((f) => f.id == 1) ??
          await activeProfile.berichtMappen.filter().idEqualTo(1).findFirst();
      final String? q = (query != null && query.trim().length >= 2) ? query.trim() : null;
      await inbox?.getMessages(amount: limit, query: q);

      if (inbox == null) return "No message folder found.";

      final List<Bericht> messages = await inbox.berichten
          .filter()
          .optional(unreadOnly, (q) => q.isGelezenEqualTo(false))
          .optional(query != null && query.trim().isNotEmpty, (q) {
            final qStr = query!.trim();
            return q.group((g) => g
                .onderwerpContains(qStr, caseSensitive: false)
                .or()
                .afzender((a) => a.naamContains(qStr, caseSensitive: false)));
          })
          .sortByVerzondenOpDesc()
          .limit(limit)
          .findAll();

      if (messages.isEmpty) return "No messages found.";

      return messages.map((m) {
        final content = m.inhoud?.withoutHTML?.trim() ?? '';
        final preview = content.length > 150 ? '${content.substring(0, 150)}...' : content;
        return """
ID: ${m.id}
Subject: ${m.onderwerp ?? ''}
Sender: ${m.afzender?.naam ?? 'Unknown'}
Date: ${m.verzondenOp.toIso8601String()}
IsRead: ${m.isGelezen}
Preview: $preview""";
      }).join('\n---\n');
    } catch (e) {
      return "Could not fetch messages: $e";
    }
  }
  

  /// Fetches full message content, recipients, and attachments.
  static Future<String> getMessageDetail(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final int msgId = args['id'] as int;

    final message = await isar.berichts.filter().idEqualTo(msgId).findFirst();
    if (message == null) return "Message with ID $msgId not found.";

    if (message.inhoud == null || message.ontvangers == null) {
      try {
        await message.fill();
      } catch (e) {
        stderr.writeln("Could not fetch full message detail from Magister: $e");
      }
    }

    final recipients = message.ontvangers?.map((o) => o.weergavenaam).formattedJoin;
    final attachments = message.bronnen.isNotEmpty
        ? message.bronnen
            .map((b) =>
                "${b.naam} (ID: ${b.id}, Size: ${b.grootte} bytes, LocalPath: ${b.savedPath ?? 'Not downloaded'})")
            .join(', ')
        : 'None';

    return """
ID: ${message.id}
Subject: ${message.onderwerp ?? ''}
Sender: ${message.afzender?.naam ?? 'Unknown'}
Date: ${message.verzondenOp.toIso8601String()}
IsRead: ${message.isGelezen}
Recipients: $recipients
Attachments: $attachments
Body:
${message.inhoud?.withoutHTML?.trim() ?? ''}""";
  }

  /// Fetches studiewijzers (study guides / project curricula).
  static Future<String> getStudiewijzers(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final query = args['query'] as String?;

    try {
      await activeProfile.fetchStudiewijzers();
    } catch (e) {
      stderr.writeln("Could not fetch studiewijzers: $e");
    }

    final List<Studiewijzer> list = await activeProfile.studiewijzers
        .filter()
        .optional(query != null && query.trim().isNotEmpty,
            (q) => q.rawTitelContains(query!.trim(), caseSensitive: false))
        .sortByRawTitel()
        .findAll();

    if (list.isEmpty) return "No study guides (studiewijzers) found.";

    return list.map((s) {
      final isLoaded = s.lastUsed != null;
      return """
ID: ${s.id}
Title: ${s.titel}
Period: ${s.van.toIso8601String().split('T').first} to ${s.totEnMet.toIso8601String().split('T').first}
Loaded: $isLoaded${isLoaded ? '' : ' (Never loaded, items unknown until details fetched)'}
LastUsed: ${s.lastUsed?.toIso8601String() ?? 'Never'}
SectionsCount: ${isLoaded ? s.onderdelen.length.toString() : 'Unknown (not loaded yet)'}
IsFavorite: ${s.isFavorite}""";
    }).join('\n---\n');
  }

  /// Fetches complete sections, descriptions, and attachments for a studiewijzer by its ID.
  static Future<String> getStudiewijzerDetail(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final int swId = args['id'] as int;

    final Studiewijzer? studiewijzer =
        await isar.studiewijzers.filter().idEqualTo(swId).findFirst();
    if (studiewijzer == null) {
      return "Studiewijzer with ID $swId not found.";
    }

    try {
      // If never loaded before or empty, fill the studiewijzer structure
      if (studiewijzer.lastUsed == null || studiewijzer.onderdelen.isEmpty) {
        await studiewijzer.fill();
      }
      // Mark as used now
      studiewijzer
        ..lastUsed = DateTime.now()
        ..save();

      // Fill section details and attachments if not yet loaded
      await Future.wait(
        studiewijzer.onderdelen.where((s) => s.omschrijving == null).map(
          (s) => s.fill().catchError((e) {
            stderr.writeln("Could not fill onderdeel ${s.id}: $e");
          }),
        ),
      );
    } catch (e) {
      stderr.writeln("Could not fill studiewijzer details: $e");
    }

    final bool isLoaded = studiewijzer.lastUsed != null;
    final List<StudiewijzerOnderdeel> sections =
        await studiewijzer.onderdelen.filter().sortByVolgnummer().findAll();
        
    final sectionsText = sections.map((sec) {
      final desc = (sec.omschrijving?.withoutHTML ??
              sec.omschrijvingShort.withoutHTML ??
              '')
          .trim();
      final preview =
          desc.length > 200 ? '${desc.substring(0, 200)}...' : desc;
      final attachmentsText = sec.bronnen.isNotEmpty
          ? sec.bronnen.map((b) => """
    - AttachmentID: ${b.id}
      Name: ${b.naam}
      Size: ${b.grootte} bytes
      LocalPath: ${b.savedPath ?? 'Not downloaded'}""").join('\n')
          : '  None';
      return """
- SectionID: ${sec.id}
  Title: ${sec.titel}
  Description: ${preview.isEmpty ? 'None' : preview}
  Attachments:
$attachmentsText""";
    }).join('\n');

    return """
ID: ${studiewijzer.id}
Title: ${studiewijzer.titel}
Period: ${studiewijzer.van.toIso8601String().split('T').first} to ${studiewijzer.totEnMet.toIso8601String().split('T').first}
Loaded: $isLoaded${isLoaded ? '' : ' (Never loaded offline; contents unknown)'}
LastUsed: ${studiewijzer.lastUsed?.toIso8601String() ?? 'Never'}
SectionsCount: ${isLoaded ? sections.length.toString() : 'Unknown'}
Sections:
${sectionsText.isEmpty ? 'None' : sectionsText}""";
  }

  /// Computes simple academic, schedule, and coursework statistics for the active profile across all school years.
  static Future<String> getStatistics(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final Profile p = activeProfile;
    final List<Schoolyear> schoolyears =
        await p.schoolyears.filter().sortByEindeDesc().findAll();

    // 1. Grade Statistics (Across all school years)
    final List<Grade> grades = [];
    final List<Subject> subjects = [];
    for (final sy in schoolyears) {
      grades.addAll(await sy.grades.filter().useable().numericalGrades.findAll());
      subjects.addAll(sy.subjects);
    }

    double totalWeighted = 0;
    double totalWeight = 0;
    for (final g in grades) {
      final w = g.weight ?? 1.0;
      totalWeighted += g.grade * w;
      totalWeight += w;
    }
    final overallAvg =
        totalWeight > 0 ? (totalWeighted / totalWeight) : double.nan;

    final sufficient =
        grades.where((g) => g.grade >= appSettings.sufficientFrom).length;
    final insufficient = grades.length - sufficient;
    final passRate = grades.isNotEmpty
        ? (sufficient / grades.length * 100).toStringAsFixed(1)
        : "0.0";

    final maxGrade =
        grades.isNotEmpty ? grades.map((g) => g.grade).reduce(max) : null;
    final minGrade =
        grades.isNotEmpty ? grades.map((g) => g.grade).reduce(min) : null;

    final subjectAverages = subjects
        .map((s) => MapEntry(s.naam, s.grades.average))
        .where((e) => !e.value.isNaN)
        .toList();
    final passingSubjects = subjectAverages
        .where((e) => e.value >= appSettings.sufficientFrom)
        .length;
    final failingSubjects = subjectAverages.length - passingSubjects;

    // 2. Schedule Statistics (Recent 30 days and upcoming 14 days)
    final now = DateTime.now();
    final scheduleStart = now.subtract(const Duration(days: 30));
    final scheduleEnd = now.add(const Duration(days: 14));
    final events = await p.calendarEvents
        .filter()
        .startBetween(scheduleStart, scheduleEnd)
        .findAll();

    final totalEvents = events.length;
    final cancelledEvents = events
        .where((e) =>
            e.status == Status.manuallyCanceled ||
            e.status == Status.automaticallyCanceled)
        .length;
    final homeworkEvents = events.where((e) => e.hasHomework).length;
    final testEvents =
        events.where((e) => InfoType.tests.contains(e.infoType)).length;

    // 3. Coursework Assignments
    final assignments = await p.assignments.filter().findAll();
    final openAssignments = assignments.where((a) => !a.afgesloten).length;
    final closedAssignments = assignments.where((a) => a.afgesloten).length;

    return """
=== Academic Statistics (${p.name}) ===

[Grades (All School Years)]
Overall Average: ${overallAvg.isNaN ? 'N/A' : overallAvg.displayNumber(decimalDigits: 2)}
Total Numerical Grades: ${grades.length}
Sufficient Grades: $sufficient ($passRate%) [threshold >= ${appSettings.sufficientFrom.toDouble().displayNumber()}]
Insufficient Grades: $insufficient (${(100 - (double.tryParse(passRate) ?? 0)).toDouble().displayNumber(decimalDigits: 1)}%)
Highest Grade: ${maxGrade != null ? maxGrade.displayNumber(decimalDigits: 1) : 'N/A'}
Lowest Grade: ${minGrade != null ? minGrade.displayNumber(decimalDigits: 1) : 'N/A'}
Subjects Status: $passingSubjects passing / $failingSubjects failing (${subjectAverages.length} graded subjects)

[Schedule & Timetable (Past 30 Days & Next 14 Days)]
Total Lessons: $totalEvents
Cancelled Lessons: $cancelledEvents (${totalEvents > 0 ? (cancelledEvents / totalEvents * 100).toStringAsFixed(1) : '0'}%)
Homework Assigned: $homeworkEvents lessons
Tests & Exams: $testEvents

[Assignments]
Open Coursework Assignments: $openAssignments
Closed / Completed Assignments: $closedAssignments""";
  }

  /// Fetches active student profile information only.
  static String getProfile([Map<String, dynamic>? args]) {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final Profile p = activeProfile;
    final schoolyears = p.schoolyears.map((s) => s.groep.omschrijving).join(', ');
    return """
Name: ${p.name}
UUID: ${p.uuid}
ID: ${p.id}
SchoolYears: $schoolyears""";
  }

  /// Switches the active profile using the app's established profile setter.
  static Future<String> switchProfile(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final int? uuid = args['uuid'] as int?;
    final String? name = args['name'] as String?;

    final List<Profile> profiles = await isar.profiles.where().findAll();

    Profile? target;
    if (uuid != null) {
      target = profiles.firstWhereOrNull((p) => p.uuid == uuid);
    } else if (name != null && name.trim().isNotEmpty) {
      final search = name.trim().toLowerCase();
      target = profiles.firstWhereOrNull((p) => p.name.toLowerCase().contains(search));
    }

    if (target == null) {
      final list = profiles.map((p) => "- ${p.name} (UUID: ${p.uuid})").join('\n');
      return "Profile not found. Available profiles:\n$list";
    }

    activeProfile = target;
    Layout.of(navKey.currentContext!)
      ?..update()
      ..goToPageFromIndex(null);

    return "Switched active profile to ${target.name} (UUID: ${target.uuid}).";
  }

  /// Edits one or multiple calendar events (notes/content, location, info type, status, completion)
  /// in Discipulus and syncs to Magister.
  ///
  /// Can be called in bulk with `events: [ { id: ..., isCompleted: ... }, ... ]`
  /// or for a single event with top-level `id`, `isCompleted`, etc.
  static Future<String> editEvent(Map<String, dynamic> args) async {
    final List<Map<String, dynamic>> itemsToEdit = [];

    if (args['events'] is List) {
      for (final dynamic item in (args['events'] as List)) {
        if (item is Map<String, dynamic>) {
          itemsToEdit.add(item);
        } else if (item is Map) {
          itemsToEdit.add(Map<String, dynamic>.from(item));
        }
      }
    } else if (args['id'] != null) {
      itemsToEdit.add(args);
    }

    if (itemsToEdit.isEmpty) {
      return "Error: No events provided to edit. Provide an 'events' list or a single event 'id'.";
    }

    if (activeProfileNullable?.account.value?.tokenSet == null) return McpService._noProfileError;

    final List<CalendarEvent> eventsToSave = [];
    final List<String> results = [];

    for (final Map<String, dynamic> item in itemsToEdit) {
      final int eventId = item['id'] as int;
      final CalendarEvent? event = await activeProfile.calendarEvents
          .filter()
          .idEqualTo(eventId)
          .findFirst();

      if (event == null) {
        results.add("Event with ID $eventId not found.");
        continue;
      }

      if (item['location'] != null) {
        event.lokatie = item['location'].toString();
      }
      if (item['content'] != null) {
        event.inhoud = item['content'].toString();
      }
      if (item['status'] != null) {
        final String statusStr = item['status'].toString();
        final Status? matchedStatus = Status.values.firstWhereOrNull(
            (Status e) => e.toName == statusStr || e.name == statusStr);
        if (matchedStatus != null) {
          event.status = matchedStatus;
        }
      }
      if (item['infoType'] != null) {
        final String infoStr = item['infoType'].toString();
        final InfoType? matchedType = InfoType.values
            .firstWhereOrNull((InfoType e) => e.toName == infoStr || e.name == infoStr);
        if (matchedType != null) {
          event.infoType = matchedType;
        }
      }
      if (item['isCompleted'] != null) {
        event.afgerond = item['isCompleted'] == true;
      }

      eventsToSave.add(event);
      final String completedStr = event.afgerond ? " (Completed)" : "";
      results.add("Updated event ${event.title} (ID: $eventId)$completedStr.");
    }

    if (eventsToSave.isNotEmpty) {
      // Sync in parallel to Magister
      try {
        await Future.wait(eventsToSave.map((CalendarEvent e) => e.sync().catchError((_) {})));
      } catch (_) {}

      // Save locally in Isar
      isar.writeTxnSync(() {
        isar.calendarEvents.putAllSync(eventsToSave);
        for (final CalendarEvent e in eventsToSave) {
          e.profile.saveSync();
        }
      });
    }

    return results.join('\n');
  }

  /// Opens the compose message sheet with prefilled recipient, subject, and body.
  static Future<String> composeMessage(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final String recipient = args['recipient']?.toString() ?? '';
    final String subject = args['subject']?.toString() ?? '';
    final String body = args['body']?.toString() ?? '';

    final BuildContext? context = navKey.currentContext;
    if (context == null) {
      return "App UI is not active; cannot open message composer.";
    }

    showComposeMessageSheet(
      context,
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
      ),
    );

    return 'Opened concept with recipient $recipient, subject "$subject" and body "$body"';
  }

  /// Navigates to a specific screen within the Discipulus app.
  static Future<String> navigateToScreen(Map<String, dynamic> args) async {
    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    final String? screenName = args['screen'] as String?;

    if (screenName == null || screenName.trim().isEmpty) {
      return "Geen scherm opgegeven om naar te navigeren.";
    }

    final BuildContext? context = navKey.currentContext;
    if (context == null) {
      return "Kan niet navigeren: app scherm is momenteel niet actief.";
    }

    final List<Destination> allDestinations =
        destinations(activeProfile.account.value!.permissions)
            .expand((DestinationSegement e) => e.destinations)
            .toList();

    final Destination? destination = allDestinations.firstWhereOrNull(
      (Destination e) => e.label.toLowerCase() == screenName.trim().toLowerCase(),
    );

    if (destination == null) {
      final String available = allDestinations.map((Destination e) => e.label).join(", ");
      return "Scherm '$screenName' niet gevonden. Beschikbare schermen: $available";
    }

    Layout.of(context)?.goToPage(destination.view);
    return "Navigating to $screenName";
  }

  /// Downloads a file or attachment (Bron) by ID or name
  /// Saves the file to the system temporary directory (/tmp) and returns the local filesystem path.
  static Future<String> downloadFile(Map<String, dynamic> args) async {
    final int? id = args['id'] as int?;
    final String? name = args['name'] as String?;

    if (id == null && (name == null || name.trim().isEmpty)) {
      return "Error: Please provide either 'id' or 'name' of the file/attachment to download.";
    }

    if (activeProfile.account.value?.tokenSet == null) return McpService._noProfileError;

    Bron? bron;
    if (id != null) {
      bron = await isar.brons.filter().idEqualTo(id).or().uuidEqualTo(id).findFirst();
    }

    if (bron == null && name != null && name.isNotEmpty) {
      final List<Bron> allMatching = await isar.brons
          .filter()
          .rawNaamContains(name, caseSensitive: false)
          .or()
          .customNameContains(name, caseSensitive: false)
          .findAll();
      bron = allMatching.firstOrNull;
    }

    if (bron == null) {
      return "File/attachment not found in database. Make sure the studiewijzer, message, or bronnen folder has been retrieved first so the attachment is known.";
    }

    if (bron.bronSoort == 3) {
      return "This resource is an external web link, not a downloadable file. URL: ${await bron.absoluteFileLocation}";
    }
    if (bron.bronSoort == 0) {
      return "This resource is a folder, not a downloadable file.";
    }

    // Ensure the file is downloaded to internal storage first if not already downloaded
    if (bron.savedPath == null) {
      if (activeProfile.account.value?.tokenSet == null) {
        return "Error: Cannot download file because no active session or credentials are available.";
      }

      try {
        await bron.download();
      } catch (e) {
        return "Error downloading file '${bron.naam}': $e";
      }
    }

    if (bron.savedPath == null) {
      return "Error: Download completed but local file path was not found.";
    }

    bron.updateLastUsed();
    final sourceFile = File(bron.savedPath!);
    final cleanFileName =
        bron.rawNaam.replaceAll(RegExp(r'[^A-Za-z0-9.\-_]'), '_');

    // Save to the system temporary directory (/tmp) so it is universally accessible
    String destinationPath;
    try {
      final tmpFile = File('/tmp/$cleanFileName');
      if (tmpFile.absolute.path != sourceFile.absolute.path) {
        await sourceFile.copy(tmpFile.path);
      }
      destinationPath = tmpFile.path;
    } catch (e) {
      stderr.writeln("Could not copy to /tmp: $e, falling back to temp directory");
      try {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$cleanFileName');
        if (tempFile.absolute.path != sourceFile.absolute.path) {
          await sourceFile.copy(tempFile.path);
        }
        destinationPath = tempFile.path;
      } catch (_) {
        destinationPath = sourceFile.path;
      }
    }

    return """
Status: Downloaded successfully
Name: ${bron.naam}
Path: $destinationPath
Size: ${bron.grootte} bytes
MIME: ${bron.contentType}
Note: Stored in the host system temporary directory ($destinationPath). You can only access this file if your environment has local filesystem access to /tmp on the computer running Discipulus.""";
  }


  /// Executes any tool by name with arguments.
  static Future<String> executeTool(String name, Map<String, dynamic> args) async {
    return await DiscipulusMcpTools.execute(name, args);
  }
}
