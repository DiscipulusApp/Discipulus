import 'dart:io';

import 'package:dio/dio.dart';
import 'package:discipulus/api/dummy_magister_api_dart.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/isar_cleaner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:isar/isar.dart';

part 'account.g.dart';

@collection
@Name("Account")
class DiscipulusAccount {
  /// This is the id returned from the Magister API
  int id;

  /// TokenSet for this account, when null the account will be offline only.
  TokenSet? tokenSet;
  String endPoint;

  /// Contains the permissions for this account
  List<Permission> permissions;

  /// I'm unsure if id's can be the same across different schools,
  /// so a special uuid is constructed.
  Id get uuid => "${endPoint.toString()}$id".hashCode;

  @ignore
  Magister get api {
    if (tokenSet == null) {
      // Account is an offline account.
      return DummyMagister();
    } else {
      // Online Account
      return Magister(
        uuid: uuid,
        apiEndpoint: Uri.parse(endPoint),
        tokenSet: () async => (await isar.discipulusAccounts
                .filter()
                .uuidEqualTo(uuid)
                .tokenSetProperty()
                .findFirst() ??
            tokenSet)!, //This is to insure that the latest tokenSet is used
        onTokenRefresh: (newTokenSet) async {
          tokenSet = newTokenSet;
          isar.writeTxnSync(() {
            isar.discipulusAccounts.putSync(this);
          });
        },
      );
    }
  }

  DiscipulusAccount({
    required this.tokenSet,
    required this.endPoint,
    required this.id,
    this.permissions = const [],
  });

  final profiles = IsarLinks<Profile>();

  /// This will save the current values to the database
  void save() => isar.writeTxnSync(() => isar.discipulusAccounts.putSync(this));

  Future<void> fill() async {
    // Construct account
    ApiAccount apiAccount = await api.account;

    if (permissions.hasPermissions(PermissionType.kinderen)) {
      // Parent account
      await Future.forEach(
        (await api.person(apiAccount.persoon.id).children)
            .where((ch) => ch.zichtbaarVoorOuder),
        (child) async {
          return profiles.add(Profile(
            id: child.id,
            name: child.roepnaam,
            magisterBase64ProfilePicture:
                await api.person(child.id).profilepicture,
          )..account.value = this);
        },
      );
    } else {
      profiles.add(Profile(
        id: apiAccount.persoon.id,
        name: apiAccount.persoon.roepnaam ??
            "${apiAccount.persoon.voorletters} ${apiAccount.persoon.achternaam}",
        magisterBase64ProfilePicture:
            await api.person(apiAccount.persoon.id).profilepicture,
      )..account.value = this);
    }

    DiscipulusAccount? found =
        await isar.discipulusAccounts.filter().uuidEqualTo(uuid).findFirst();

    if (found != null) {
      // At least one of these accounts already exist, removing profiles that
      // already exist.
      profiles.removeWhere(
          (p) => found.profiles.map((e) => e.uuid).contains(p.uuid));
      if (profiles.isNotEmpty) {
        // A profile that does not exist in the already existing account, adding
        // it.
        found.profiles.addAll(profiles);
      } else {
        return;
      }
    }

    // Save value into database
    isar.writeTxnSync(() {
      if (found == null) isar.discipulusAccounts.putSync(this);
      isar.profiles.putAllSync(profiles.toList());
    });

    // Set Magister values as local values for caching
    await Future.wait(profiles
        .map((p) => [
              p.getSchoolyears(),
              if (permissions.hasPermissions(PermissionType.afspraken))
                p.getEvents(
                  DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 31)),
                    end: DateTime.now().add(const Duration(days: 14)),
                  ),
                ),
              if (permissions.hasPermissions(PermissionType.eloOpdracht))
                p.getAssignments(
                  DateTimeRange(
                    start: DateTime(2013),
                    end: DateTime.now(),
                  ),
                ),
              if (permissions.hasPermissions(PermissionType.studiewijzers))
                p.fetchStudiewijzers(),
              if (permissions.hasPermissions(PermissionType.berichten))
                p.getBerichtMappen
            ])
        .expand((e) => e));

    await Future.wait(profiles
        .map((e) => e.schoolyears.map((e) => e.fillGrades()))
        .expand((e) => e));
  }

  @ignore
  DiscipulusAccount get copy {
    DiscipulusAccount objectInstance =
        DiscipulusAccount(tokenSet: tokenSet, endPoint: endPoint, id: id);
    return objectInstance;
  }
}

@embedded
@Name("TokenSet")
class TokenSet {
  String accessToken;
  String idToken;
  DateTime? expiredDate;
  String? refreshToken;

  TokenSet({
    this.accessToken = "",
    this.expiredDate,
    this.idToken = "",
    this.refreshToken,
  });

  factory TokenSet.fromJSON(Map<dynamic, dynamic> json) => TokenSet(
        accessToken: json["access_token"],
        expiredDate:
            DateTime.now().add(Duration(seconds: json['expires_in'] ?? 3600)),
        idToken: json["id_token"],
        refreshToken: json["refresh_token"],
      );

  /// Refresh current [TokenSet]
  Future<TokenSet> refresh([TokenSet? tokenSet]) async {
    assert((tokenSet?.refreshToken ?? refreshToken) != null,
        "No refresh token found!");
    return TokenSet.fromJSON((await Dio(
      BaseOptions(
        contentType: Headers.formUrlEncodedContentType,
      ),
    ).post(
      "https://accounts.magister.net/connect/token",
      data:
          "refresh_token=${tokenSet?.refreshToken ?? refreshToken}&client_id=M6LOAPP&grant_type=refresh_token",
    ))
        .data!);
  }
}

@collection
@Name("Profile")

/// A child class of [DiscipulusAccount]
class Profile {
  /// This field is used for linking the profile to the parent account that contains the tokens.
  @Backlink(to: 'profiles')
  final account = IsarLink<DiscipulusAccount>();

  /// This is the id returned from the Magister API
  late int id;
  late String name;

  /// The profile picture that is used for this profile. This can be edited, but
  /// the original will always be saved.
  @ignore
  String? get base64ProfilePicture =>
      customBase64ProfilePicture ?? magisterBase64ProfilePicture;
  set base64ProfilePicture(String? base64String) {
    customBase64ProfilePicture = base64String;
  }

  String? magisterBase64ProfilePicture;
  String? customBase64ProfilePicture;

  /// I'm unsure if id's can be the same across different schools, so a special uuid is constructed.
  Id get uuid => "${account.value!.uuid}$id".hashCode;
  @ignore
  bool get isActive => uuid == activeProfile.uuid;
  bool isOffline = false;

  /// Contains some profile specific settings
  late ProfileSettings settings =
      ProfileSettings(mailFooter: "\nMet vriendelijke groeten,\n$name");

  /// Contains the schoolyears, which contain the grades.
  /// Will get all if no range has been provided.
  final schoolyears = IsarLinks<Schoolyear>();
  Future<List<Schoolyear>> getSchoolyears({DateTimeRange? range}) async {
    Iterable<Schoolyear> newSchoolyears =
        (await account.value!.api.person(id).schoolyear().schoolyears(
                  range: range ??
                      DateTimeRange(start: DateTime(2013), end: DateTime.now()),
                ))
            .map((e) => e..profile.value = this);

    await isar.schoolyears.removeChecker(
      localUUIDs: schoolyears.filter().uuidProperty().findAll(),
      newUUIDs: Future.value(
          [for (Schoolyear schoolyear in newSchoolyears) schoolyear.uuid]),
      findUUIDs: (q, uuid) => q.uuidEqualTo(uuid),
    );

    schoolyears.addAll(newSchoolyears);

    isar.writeTxnSync(() {
      isar.schoolyears.putAllSync(newSchoolyears.toList());
    });
    return schoolyears.toList();
  }

  static int? activeSchoolyearUUID;

  set activeSchoolyear(Schoolyear activeSchoolyear) {
    Profile.activeSchoolyearUUID = activeSchoolyear.uuid;
    // For now we are not saving the value
    //
    // settings.activeSchoolyearUUID = activeSchoolyear.uuid;
    // save();
  }

  @ignore
  Schoolyear get activeSchoolyear {
    Schoolyear? schoolyear;

    if (Profile.activeSchoolyearUUID != null) {
      // Active schoolyear has been set.
      schoolyear = schoolyears
          .filter()
          .uuidEqualTo(Profile.activeSchoolyearUUID!)
          .findFirstSync();
    }
    // Active schoolyear has not been set, getting the last one and setting one
    schoolyear ??= schoolyears.filter().sortByEindeDesc().findFirstSync();
    activeSchoolyear = schoolyear!;

    return schoolyear;
  }

  Future<void> processCalendarEvent(
      DateTimeRange range, CalendarEvent event) async {
    // Assign this profile to the event
    event.profile.value = this;
    // Try to find the correct schoolyear in which this event took places
    Schoolyear? schoolyear = await schoolyears
        .filter()
        .beginLessThan(range.start)
        .eindeGreaterThan(range.end)
        .sortByBeginDesc()
        .findFirst();
    // Try to find the correct subject in that year and assign it.
    event.subject.value = await schoolyear?.subjects
        .filter()
        .naamEqualTo(event.vakken?.firstOrNull?.naam ?? "")
        .findFirst();
  }

  /// Contains the calendar events.
  @Backlink(to: 'profile')
  final calendarEvents = IsarLinks<CalendarEvent>();
  Future<List<CalendarEvent>> getEvents(DateTimeRange range) async {
    var events = (await account.value!.api.person(id).calendarEvents(range));

    await Future.wait([
      for (var event in events) processCalendarEvent(range, event),
    ]);

    await isar.calendarEvents.removeChecker(
      localUUIDs: calendarEvents
          .filter()
          .startGreaterThan(range.start)
          .and()
          .eindeLessThan(range.end)
          .uuidProperty()
          .findAll(),
      newUUIDs: Future.value([for (CalendarEvent event in events) event.uuid]),
      findUUIDs: (q, uuid) => q.uuidEqualTo(uuid),
    );

    isar.writeTxnSync(() async {
      events.map(
        (e) => e..subject.saveSync(),
      );
      isar.calendarEvents.putAllSync(events);
    });
    return events;
  }

  /// Contains the assignments.
  final assignments = IsarLinks<Assignment>();
  Future<List<Assignment>> getAssignments([DateTimeRange? range]) async {
    DateTimeRange fetchRange = range ??
        DateTimeRange(
          start: DateTime(2000),
          end: DateTime.now().add(const Duration(days: 365)),
        );

    List<Assignment> newAssignments =
        await account.value!.api.person(id).assignments(fetchRange);

    for (Assignment assignment in newAssignments) {
      assignment.profile.value = this;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      await CoreSpotlight.instance.indexSearchableItems([
        for (Assignment assignment in newAssignments) assignment.spotlightItem
      ].nonNulls);
    }

    assignments.addAll(newAssignments);

    await isar.assignments.removeChecker(
      localUUIDs: assignments
          .filter()
          .inleverenVoorBetween(fetchRange.start, fetchRange.end)
          .uuidProperty()
          .findAll(),
      newUUIDs: Future.value(
          [for (Assignment assignment in newAssignments) assignment.uuid]),
      findUUIDs: (q, uuid) => q.uuidEqualTo(uuid),
      beforeRemoval: (deathRow) {
        for (Assignment assignment in deathRow) {
          isar.writeTxnSync(() {
            isar.brons.filter().anyOf(
              [for (Bron bron in assignment.bronnen) bron.uuid],
              (q, uuid) => q.uuidEqualTo(uuid),
            ).deleteAllSync();
          });
        }
      },
    );

    isar.writeTxnSync(() {
      isar.assignments.putAllSync(newAssignments);
    });
    return assignments.toList();
  }

  /// Contains the activities.
  final activities = IsarLinks<Activity>();
  Future<List<Activity>> getActivities() async {
    List<Activity> newActivities =
        await account.value!.api.person(id).activiteiten;

    activities.addAll(newActivities.map((e) => e..profile.value = this));

    await isar.activitys.removeChecker(
      localUUIDs: activities.filter().uuidProperty().findAll(),
      newUUIDs: Future.value(
          [for (Activity activity in newActivities) activity.uuid]),
      findUUIDs: (q, uuid) => q.uuidEqualTo(uuid),
      beforeRemoval: (deathRow) {
        for (Activity activity in deathRow) {
          isar.writeTxnSync(() {
            isar.activityElements.filter().anyOf(
              [for (ActivityElement elm in activity.elements) elm.uuid],
              (q, uuid) => q.uuidEqualTo(uuid),
            ).deleteAllSync();
          });
        }
      },
    );

    isar.writeTxnSync(() {
      isar.activitys.putAllSync(newActivities);
    });
    return await activities.filter().findAll();
  }

  /// Contains the studiewijzers.
  final studiewijzers = IsarLinks<Studiewijzer>();
  Future<void> fetchStudiewijzers() async {
    // Get studiewijzers if the right permissions are present
    List<Studiewijzer> newStudiewijzers = (await account.value!.api
            .person(id)
            .studiewijzers(
                includeProjects: account.value!.permissions
                    .hasPermissions(PermissionType.projecten),
                includeStudiewijzers: account.value!.permissions
                    .hasPermissions(PermissionType.studiewijzers)))
        .map((e) => e..profile.value = this)
        .map((e) {
      Studiewijzer? original =
          studiewijzers.filter().uuidEqualTo(e.uuid).findFirstSync();
      return e
        ..titel = original?.titel
        ..isFavorite = original?.isFavorite ?? false
        ..lastUsed = original?.lastUsed
        ..customEmojiIcon = original?.customEmojiIcon
        ..groupedUUIDS = original?.groupedUUIDS ?? []
        ..groupName = original?.groupName
        ..updateSpotlight();
    }).toList();

    await isar.studiewijzers.removeChecker(
      localUUIDs: studiewijzers.filter().uuidProperty().findAll(),
      newUUIDs: Future.value([
        for (Studiewijzer studiewijzer in newStudiewijzers) studiewijzer.uuid
      ]),
      findUUIDs: (q, uuid) => q.uuidEqualTo(uuid),
      beforeRemoval: (deathRow) async {
        for (Studiewijzer studiewijzer in deathRow) {
          // Remove from groups
          if (studiewijzer.groupedUUIDS.isNotEmpty) {
            List<Studiewijzer> group = await isar.studiewijzers
                .filter()
                .anyOf(
                  studiewijzer.groupedUUIDS,
                  (q, uuid) => q.uuidEqualTo(uuid),
                )
                .findAll();
            for (Studiewijzer gWijzer in group) {
              gWijzer.groupedUUIDS.remove(studiewijzer.uuid);
              if (gWijzer.groupedUUIDS.length == 1 &&
                  gWijzer.groupedUUIDS.contains(gWijzer.uuid)) {
                gWijzer.groupedUUIDS = [];
                gWijzer.groupName = null;
              }
              gWijzer.save();
            }
          }

          // Remove onderdelen
          isar.writeTxnSync(() {
            isar.studiewijzerOnderdeels.filter().anyOf(
              [
                for (StudiewijzerOnderdeel stOn in studiewijzer.onderdelen)
                  stOn.uuid
              ],
              (q, uuid) => q.uuidEqualTo(uuid),
            ).deleteAllSync();
          });
        }
      },
    );

    // Write changes to the datebase
    studiewijzers.addAll(newStudiewijzers);
    isar.writeTxnSync(() {
      isar.studiewijzers.putAllSync(newStudiewijzers);
      studiewijzers.saveSync();
    });
  }

  /// Contains the external bronnen.
  final externalBronnen = IsarLinks<ExternalBronSource>();
  Future<void> fetchExternalBronnen() async {
    // Get studiewijzers if the right permissions are present
    List<ExternalBronSource> newExternalBronnen =
        (await account.value!.api.person(id).getBronSources)
            .map((e) => e..profile.value = this)
            .toList();

    await isar.externalBronSources.removeChecker(
      localUUIDs: studiewijzers.filter().uuidProperty().findAll(),
      newUUIDs: Future.value([
        for (ExternalBronSource externalBron in newExternalBronnen)
          externalBron.uuid
      ]),
      findUUIDs: (q, uuid) => q.uuidEqualTo(uuid),
    );

    // Write changes to the datebase
    externalBronnen.addAll(newExternalBronnen);
    isar.writeTxnSync(() {
      isar.externalBronSources.putAllSync(newExternalBronnen);
      externalBronnen.saveSync();
    });
  }

  /// Contains the studiewijzers.
  final berichtMappen = IsarLinks<MessagesFolder>();
  @ignore
  Future<List<MessagesFolder>> get getBerichtMappen async {
    // The concepts folder does not exist when getting folder from the Magister API,
    // so it will be created manually. Since the folder does not exist it also has
    // no identifier. The lowest id is 1, so we will assign -1 as the id of the concepts
    // folder

    List<MessagesFolder> folders = [];

    if ((await berichtMappen.filter().idEqualTo(-1).findFirst()) == null) {
      // TODO: Some accounts do not support this?
      // The concepts folder does not exist, creating one
      folders.add(MessagesFolder(
          aantalOngelezen: 0,
          id: -1,
          bovenliggendeId: 0,
          naam: "Concepten",
          berichtenLink: "/api/berichten/concepten")
        ..profile.value = this);
    }

    folders.addAll((await account.value!.api.messages.folders)
        .map((e) => e..profile.value = this));

    await isar.messagesFolders.removeChecker(
      localUUIDs: berichtMappen.filter().uuidProperty().findAll(),
      newUUIDs: Future(() async => [
            // Concept folder, should not be removed.
            (await berichtMappen.filter().idEqualTo(-1).findFirst())
                ?.uuid
                .toInt(),
            for (MessagesFolder folder in folders) folder.uuid
          ].nonNulls),
      findUUIDs: (q, uuid) => q.uuidEqualTo(uuid),
      beforeRemoval: (deathRow) {
        for (MessagesFolder folder in deathRow) {
          isar.writeTxnSync(() async {
            isar.berichts.filter().anyOf(
              [for (Bericht message in folder.berichten) message.uuid],
              (q, uuid) => q.uuidEqualTo(uuid),
            ).deleteAllSync();
          });
        }
      },
    );

    berichtMappen.addAll(folders);

    isar.writeTxnSync(() {
      isar.messagesFolders.putAllSync(folders.toList());
    });
    return berichtMappen.toList();
  }

  void save() => isar.writeTxnSync(() => isar.profiles.putSync(this));

  Profile({
    required this.id,
    required this.name,
    this.magisterBase64ProfilePicture,
    this.isOffline = false,
  });
}
