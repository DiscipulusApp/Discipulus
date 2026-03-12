import 'package:dio/dio.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserRoute extends MagisterBase {
  UserRoute(super.magister, {required this.uuid}) : super();

  final String uuid;

  /// Fetches additional appointments for the user.
  /// These are events that are not in the standard calendar.
  ///
  /// *** Warning ***
  /// At the moment this fails with a 401 error. This is because of:
  /// ```
  /// [Bearer error="invalid_token", error_description="The audience
  /// 'magister.ecs, https://accounts.magister.net/resources' is invalid"]
  /// ```
  /// Adding the scopes from the online version results in incorrect scopes
  /// THough I am not completely sure, there is a possibility that this has just
  /// forcefully been disabled for the native Magister apps.
  ///
  Future<List<CalendarEvent>> additionalAppointments(
      DateTimeRange range) async {
    return [];

    var res = await magister.dio.getUri(
        Uri.https("calendar.magister.net",
            "/api/user/$uuid/additional-appointments", {
          "start":
              "${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(range.start)}%2B01:00",
          "end":
              "${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(range.end)}%2B01:00",
        }),
        options: Options(
          responseType: ResponseType.json,
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "origin": magister.dio.options.baseUrl.replaceAll("/api/", "")
          },
        ));

    return List<CalendarEvent>.from(
        res.data.map((x) => CalendarEvent.fromExtensionMap(x, uuid)));
  }
}
