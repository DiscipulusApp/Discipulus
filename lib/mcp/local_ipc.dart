import 'dart:convert';
import 'dart:io';

import 'package:discipulus/mcp/ipc_credentials.dart';
import 'package:discipulus/mcp/mcp_service.dart';
import 'package:discipulus/utils/app_info.dart';

/// Loopback IPC for the desktop MCP bridge. Requests require a secret generated
/// on each GUI launch; websites and unauthenticated local clients cannot use it.
class LocalIpcServer {
  static final LocalIpcServer _instance = LocalIpcServer._internal();
  factory LocalIpcServer() => _instance;
  LocalIpcServer._internal();

  HttpServer? _server;
  String? _token;
  static const int port = 3377;
  static const int _maxBodyBytes = 64 * 1024;

  bool get isRunning => _server != null;

  Future<void> init() async {
    if (_server != null) return;
    try {
      _server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        port,
      );
      // Do not rotate the credential until we own the port. Another running
      // instance may be serving the same user's live MCP connection.
      _token = await IpcCredentials.rotate();
      stderr.writeln('Discipulus IPC listening on 127.0.0.1:$port');
      _server!.listen(_handleRequest);
    } catch (e) {
      if (_server != null) {
        await _server!.close(force: true);
        _server = null;
        await IpcCredentials.clear();
      }
      _token = null;
      stderr.writeln('Failed to start Discipulus IPC: $e');
    }
  }

  Future<void> stop() async {
    // A second desktop instance cannot bind this port. It must not delete
    // the credential owned by the instance that is actually serving IPC.
    final server = _server;
    if (server == null) return;
    await server.close(force: true);
    _server = null;
    _token = null;
    await IpcCredentials.clear();
  }

  Future<void> _handleRequest(HttpRequest request) async {
    request.response.headers.contentType = ContentType.json;
    request.response.headers.set('Cache-Control', 'no-store');

    // Origin requests from web pages are never part of the desktop bridge.
    // Authentication is mandatory even for /status, which reveals that the
    // school app is running. Do not enable wildcard CORS or preflights.
    final host = request.headers.host;
    final validHost = host == '127.0.0.1' || host == 'localhost';
    final credential = request.headers.value(HttpHeaders.authorizationHeader);
    if (!validHost ||
        request.headers.value('origin') != null ||
        request.connectionInfo?.remoteAddress.isLoopback != true ||
        _token == null ||
        credential != 'Bearer $_token') {
      await _sendError(request.response, 'Geen toegang', HttpStatus.forbidden);
      return;
    }

    try {
      if (request.uri.path == '/status' && request.method == 'GET') {
        await _sendJson(request.response, {
          'status': 'ok',
          'app': 'Discipulus',
          'version': await AppInfo.version,
        });
        return;
      }

      if (request.uri.path == '/tool' && request.method == 'POST') {
        if (request.headers.contentLength > _maxBodyBytes) {
          await _sendError(request.response, 'Verzoek te groot', HttpStatus.requestEntityTooLarge);
          return;
        }
        final bytes = <int>[];
        await for (final chunk in request) {
          if (bytes.length + chunk.length > _maxBodyBytes) {
            await _sendError(request.response, 'Verzoek te groot', HttpStatus.requestEntityTooLarge);
            return;
          }
          bytes.addAll(chunk);
        }
        final data = jsonDecode(utf8.decode(bytes));
        if (data is! Map<String, dynamic> ||
            data['tool'] is! String ||
            (data['arguments'] != null && data['arguments'] is! Map<String, dynamic>)) {
          await _sendError(request.response, 'Ongeldig verzoek', HttpStatus.badRequest);
          return;
        }
        final result = await McpService.executeTool(
          data['tool'] as String,
          data['arguments'] as Map<String, dynamic>? ?? {},
        );
        await _sendJson(request.response, {'result': result});
        return;
      }
      await _sendError(request.response, 'Endpoint niet gevonden', HttpStatus.notFound);
    } on FormatException {
      await _sendError(request.response, 'Ongeldige JSON', HttpStatus.badRequest);
    } catch (e, stack) {
      stderr.writeln('Discipulus IPC request failed: $e\n$stack');
      await _sendError(request.response, 'Verzoek mislukt', HttpStatus.internalServerError);
    }
  }

  Future<void> _sendJson(HttpResponse response, dynamic data) async {
    response.statusCode = HttpStatus.ok;
    response.write(jsonEncode(data));
    await response.close();
  }

  Future<void> _sendError(HttpResponse response, String message, int code) async {
    response.statusCode = code;
    response.write(jsonEncode({'error': message, 'code': code}));
    await response.close();
  }
}
