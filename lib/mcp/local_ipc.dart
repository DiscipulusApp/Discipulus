import 'dart:convert';
import 'dart:io';

import 'package:discipulus/mcp/mcp_service.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/app_info.dart';

/// Lightweight local loopback IPC server on port 3377.
/// Allows the Discipulus MCP Server (or local tools) to execute tools directly
/// against the running app instance.
class LocalIpcServer {
  static final LocalIpcServer _instance = LocalIpcServer._internal();
  factory LocalIpcServer() => _instance;
  LocalIpcServer._internal();

  HttpServer? _server;
  static const int port = 3377;

  bool get isRunning => _server != null;

  /// Starts the local IPC server.
  Future<void> init() async {
    if (_server != null) return;

    try {
      _server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        port,
        shared: true,
      );
      stderr.writeln("Discipulus Local IPC Server listening on http://127.0.0.1:$port");
      _server!.listen(_handleRequest);
    } catch (e) {
      stderr.writeln("Failed to start Discipulus Local IPC Server: $e");
    }
  }

  /// Stops the local IPC server.
  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _handleRequest(HttpRequest request) async {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');
    request.response.headers.contentType = ContentType.json;

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      return;
    }

    try {
      if (request.uri.path == '/status') {
        final profile = activeProfileNullable;
        final version = await AppInfo.version;
        _sendJson(request.response, {
          'status': 'ok',
          'app': 'Discipulus',
          'version': version,
          'profile': profile != null
              ? {
                  'uuid': profile.uuid,
                  'name': profile.name,
                  'school': profile.account.value?.endPoint,
                }
              : null,
        });
        return;
      }

      if (request.uri.path == '/tool' && request.method == 'POST') {
        final body = await utf8.decoder.bind(request).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final tool = data['tool'] as String;
        final args = data['arguments'] as Map<String, dynamic>? ?? {};

        final result = await McpService.executeTool(tool, args);
        _sendJson(request.response, {'result': result});
        return;
      }

      _sendError(request.response, 'Endpoint not found', HttpStatus.notFound);
    } catch (e, stack) {
      stderr.writeln("Local IPC error: $e\n$stack");
      _sendError(request.response, e.toString(), HttpStatus.internalServerError);
    }
  }

  void _sendJson(HttpResponse response, dynamic data) {
    response.statusCode = HttpStatus.ok;
    response.write(jsonEncode(data));
    response.close();
  }

  void _sendError(HttpResponse response, String message, int code) {
    response.statusCode = code;
    response.write(jsonEncode({'error': message, 'code': code}));
    response.close();
  }
}
