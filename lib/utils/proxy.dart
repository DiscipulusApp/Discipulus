import 'dart:convert';
import 'dart:io';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/models/account.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WiiProxyService {
  static HttpServer? _server;
  static Profile? _activeProfile;
  static List<CalendarEvent> _lastFetchedEvents = [];

  static String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }

  static Future<String?> start(Profile profile) async {
    await stop();
    _activeProfile = profile;

    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);
      print("Wii Proxy started on port 8081");

      _server!.listen((HttpRequest request) async {
        final path = request.uri.path;
        final response = request.response;
        print(
            "Proxy received request: ${request.method} $path from ${request.connectionInfo?.remoteAddress.address}");

        try {
          if (path == '/account') {
            final acc = _activeProfile!.account.value!;
            final resp = "${acc.endPoint}|${_activeProfile!.id}";
            response
              ..statusCode = HttpStatus.ok
              ..headers.contentType = ContentType.text
              ..write(resp);
          } else if (path == '/schedule') {
            final now = DateTime.now();
            final range = DateTimeRange(
              start: DateTime(now.year, now.month, now.day),
              end: DateTime(now.year, now.month, now.day)
                  .add(const Duration(days: 7)),
            );

            _lastFetchedEvents = await _activeProfile!.getEvents(range);
            final jsonList = _lastFetchedEvents
                .map((e) => {
                      'id': e.id,
                      'start': e.start?.toLocal().toIso8601String() ?? "",
                      'topic': e.vakken?.firstOrNull?.naam ??
                          e.omschrijving ??
                          "Geen les",
                      'location': e.lokatie ?? "??",
                      'inhoud': _stripHtml(e.inhoud ?? ""),
                      'infoType': e.infoType.index,
                    })
                .toList();

            final responseJson = jsonEncode(jsonList);
            response
              ..statusCode = HttpStatus.ok
              ..headers.contentType = ContentType.json
              ..headers.set('Content-Length', responseJson.length.toString())
              ..write(responseJson);
          } else if (path == '/mark-done') {
            final id = int.tryParse(request.uri.queryParameters['id'] ?? "");
            if (id != null) {
              final event =
                  _lastFetchedEvents.where((e) => e.id == id).firstOrNull;
              if (event != null) {
                event.afgerond = true;
                event.save();
                await event.sync();
                response
                  ..statusCode = HttpStatus.ok
                  ..write("OK");
              } else {
                response
                  ..statusCode = HttpStatus.notFound
                  ..write("Event not found");
              }
            } else {
              response
                ..statusCode = HttpStatus.badRequest
                ..write("Missing ID");
            }
          } else {
            response.statusCode = HttpStatus.notFound;
          }
        } catch (e) {
          response
            ..statusCode = HttpStatus.internalServerError
            ..write(e.toString());
        } finally {
          await response.close();
        }
      });

      // Find local IP using network_info_plus
      final wifiIp = await NetworkInfo().getWifiIP();
      if (wifiIp != null) {
        return "http://$wifiIp:8081";
      }

      // Fallback for non-Wi-Fi interfaces
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            final ip = addr.address;
            if (ip.startsWith('192.168.') ||
                ip.startsWith('10.') ||
                ip.startsWith('172.')) {
              if (!ip.startsWith('100.')) {
                return "http://$ip:8081";
              }
            }
          }
        }
      }
      return "http://localhost:8081";
    } catch (e) {
      print("Error starting Wii Proxy: $e");
      return null;
    }
  }

  static Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    _activeProfile = null;
  }
}
