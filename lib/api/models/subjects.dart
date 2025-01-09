import 'dart:convert';

import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';

part 'subjects.g.dart';

@Collection()
@Name("Subject")
class Subject {
  Id get uuid => "${schoolyear.value!.id}$id".hashCode;
  final int id;
  String afkorting;
  String naam;
  int volgnr;

  @Backlink(to: 'subjects')
  final schoolyear = IsarLink<Schoolyear>();

  @Backlink(to: 'subject')
  final grades = IsarLinks<Grade>();

  @Backlink(to: 'subjects')
  final periods = IsarLinks<GradePeriod>();

  @Backlink(to: 'subject')
  final events = IsarLinks<CalendarEvent>();

  //  Why is the backlink to events sometimes incorrect?
  //
  //  Magister has, as usual, decided to make things that shouldn't differ, differ.
  //  It is incomprehensible that this mess is the basis of almost all secondary
  //  schools in the Netherlands. After six versions, they still haven't figured
  //  out what "reuse" means. Why the Id for exactly the same field has to differ
  //  between grades and events is a mystery to me. Hopeless company.

  @ignore

  /// Tries to find related schoolyears where the same subject is present.
  /// In some situations this does not work, because it can only check if the
  /// same subject exist based on the name, so when the name differs it will not
  /// find the correct subjects. Also, it only checks it one way, so searching
  /// from a subject called "Wiskunde" will result in all Wiskunde years, but
  /// when searching from a a subject called "Wiskunde A/B/C/D" with the same
  /// account will not find the years with "Wiskunde" as subject.
  Future<List<Subject>> get relatedSchoolyears async {
    return await isar.subjects
        .filter()
        .schoolyear((q) => q
            .profile(
                (q) => q.uuidEqualTo(schoolyear.value!.profile.value!.uuid))
            .and()
            .isHoofdAanmeldingEqualTo(true))
        .and()
        .group((q) => q.naamContains(naam).or().naamMatches(naam))
        .sortById()
        .findAll();
  }

  @ignore

  /// Tries to find related studiewijzers based on the name from Magister and the
  /// the custom name if set.
  Future<List<Studiewijzer>> get relatedStudiewijzers async {
    return await isar.studiewijzers
        .filter()
        .profile((q) => q.uuidEqualTo(schoolyear.value!.profile.value!.uuid))
        .group(
          (q) => q
              .customNameContains(naam, caseSensitive: false)
              .or()
              .rawTitelContains(naam, caseSensitive: false)
              .or()
              .customNameContains(afkorting, caseSensitive: false)
              .or()
              .rawTitelContains(afkorting, caseSensitive: false),
        )
        .findAll();
  }

  Subject({
    this.id = 0,
    this.afkorting = "",
    this.naam = "",
    this.volgnr = 0,
  });

  factory Subject.fromJson(String str) => Subject.fromMap(json.decode(str));

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
        id: json["Id"],
        afkorting: json["Afkorting"] ?? "",
        naam: json["Omschrijving"] ?? json["Naam"] ?? "",
        volgnr: json["Volgnr"] ?? 0,
      );
}
