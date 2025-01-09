import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart'; // Make sure to import your Isar instance
import 'package:discipulus/models/account.dart';
import 'package:isar/isar.dart';

extension AccountExtensions on DiscipulusAccount {
  Future<void> logoutAndRemoveAllData() async {
    // Get all linked profiles
    final profiles = this.profiles.toList();

    // Get all the schoolyears that are bound to this profile
    Iterable<int> schoolyearUUIDS = [
      for (Profile p in profiles) ...p.schoolyears.map((e) => e.uuid)
    ];

    // TODO: Remove Spotlight entries.

    // Remove all the data that is part of a schoolyear
    await isar.writeTxn(
      () async {
        await isar.grades
            .filter()
            .schoolyear((q) =>
                q.anyOf(schoolyearUUIDS, (q, uuid) => q.uuidEqualTo(uuid)))
            .deleteAll();
        await isar.gradePeriods
            .filter()
            .schoolyear((q) =>
                q.anyOf(schoolyearUUIDS, (q, uuid) => q.uuidEqualTo(uuid)))
            .deleteAll();
        await isar.subjects
            .filter()
            .schoolyear((q) =>
                q.anyOf(schoolyearUUIDS, (q, uuid) => q.uuidEqualTo(uuid)))
            .deleteAll();
        await isar.schoolyears
            .filter()
            .anyOf(schoolyearUUIDS, (q, uuid) => q.uuidEqualTo(uuid))
            .deleteAll();
      },
    );

    for (Profile p in profiles) {
      Iterable<int> assignmentversieUUIDs = [
        for (var p in p.assignments) ...p.versies.map((e) => e.uuid)
      ];
      Iterable<int> activityUUIDs = [
        for (var p in p.activities) ...p.elements.map((e) => e.uuid)
      ];
      Iterable<int> studiewijzerUUIDs = [
        for (var p in p.studiewijzers) ...p.onderdelen.map((e) => e.uuid)
      ];
      Iterable<int> berichtMapUUIDs = [
        for (var p in p.berichtMappen) ...p.berichten.map((e) => e.uuid)
      ];

      // Remove bronnen
      List<Bron> bronnen = await isar.brons
          .filter()
          .profile((q) => q.uuidEqualTo(p.uuid))
          .findAll();

      for (Bron bron in bronnen) {
        bron
          ..removeFromSpotlight()
          ..remove();
      }

      await isar.writeTxn(() async {
        // Remove Calendar events
        await isar.calendarEvents
            .filter()
            .profile((q) => q.uuidEqualTo(p.uuid))
            .deleteAll();

        // Remove assignments
        await isar.assignmentVersions
            .filter()
            .anyOf(assignmentversieUUIDs, (q, uuid) => q.uuidEqualTo(uuid))
            .deleteAll();
        await isar.assignments
            .filter()
            .profile((q) => q.uuidEqualTo(p.uuid))
            .deleteAll();

        // Remove activities
        await isar.activityElements
            .filter()
            .anyOf(activityUUIDs, (q, uuid) => q.uuidEqualTo(uuid))
            .deleteAll();
        await isar.activitys
            .filter()
            .profile((q) => q.uuidEqualTo(p.uuid))
            .deleteAll();

        // Remove Studiewijzers
        await isar.studiewijzerOnderdeels
            .filter()
            .anyOf(studiewijzerUUIDs, (q, uuid) => q.uuidEqualTo(uuid))
            .deleteAll();
        await isar.studiewijzers
            .filter()
            .profile((q) => q.uuidEqualTo(p.uuid))
            .deleteAll();

        // Remove externalBronnen
        await isar.externalBronSources
            .filter()
            .profile((q) => q.uuidEqualTo(p.uuid))
            .deleteAll();

        // Remove messages
        await isar.berichts
            .filter()
            .anyOf(berichtMapUUIDs, (q, uuid) => q.uuidEqualTo(uuid))
            .deleteAll();
        await isar.messagesFolders
            .filter()
            .profile((q) => q.uuidEqualTo(p.uuid))
            .deleteAll();

        await isar.brons
            .filter()
            .profile((q) => q.uuidEqualTo(p.uuid))
            .deleteAll();
      });
    }
    Iterable<int> profileUUIDs = profiles.map((e) => e.uuid);

    await isar.writeTxn(() async {
      // Remove profiles
      await isar.profiles
          .filter()
          .anyOf(profileUUIDs, (q, uuid) => q.uuidEqualTo(uuid))
          .deleteAll();

      // Remove account
      await isar.discipulusAccounts.filter().uuidEqualTo(uuid).deleteAll();
    });
  }
}
