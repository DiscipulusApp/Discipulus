import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/schoolyears.dart';

class SchoolyearsRoute extends MagisterBase {
  SchoolyearsRoute(super.magister, {this.id, this.personId}) : super();

  ///Schoolyear id
  final int? id;
  final int? personId;

  /// Returns a list of schoolyears.
  ///
  /// The Magister API is a bit odd, so not setting a [range], will result in a list containing only the current [Schoolyear].
  /// If you want to get every avalible [Schoolyear], just do what magister does and use the daterange 2013-01-01 - [DateTime.now].
  Future<List<Schoolyear>> schoolyears({DateTimeRange? range}) async {
    return List<Schoolyear>.from((await magister.dio.get(
            "leerlingen/$personId/aanmeldingen${(id == null && range != null) ? "?begin=${DateFormat("yyyy-01-01").format(range.start)}&einde=${DateFormat("yyyy-01-01").format(range.end)}" : "/"}${id ?? ""}"))
        .data["items"]
        .map((x) => Schoolyear.fromMap(x)));
  }
}
