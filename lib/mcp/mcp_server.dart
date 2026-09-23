import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/mcp/local_ipc.dart';
import 'package:discipulus/mcp/mcp_service.dart';
import 'package:discipulus/mcp/mcp_tools.dart';
import 'package:discipulus/utils/app_info.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:timezone/data/latest.dart';

/// Entrypoint for running Discipulus as an MCP server over stdio using mcp_dart.
Future<void> runMcpServer() async {
  final mcp = await DiscipulusMcpServer.create();
  await mcp.start();
}

class DiscipulusMcpServer {
  final Dio _ipcDio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:${LocalIpcServer.port}',
    connectTimeout: const Duration(milliseconds: 350),
    receiveTimeout: const Duration(seconds: 10),
  ));

  late final McpServer _server;
  bool _isarInitialized = false;
  final String version;

  DiscipulusMcpServer({this.version = "0.0.0"}) {
    _server = McpServer(
      Implementation(name: "discipulus", version: version),
    );
    DiscipulusMcpTools.registerAll(_server, _dispatchTool);
  }

  static Future<DiscipulusMcpServer> create() async {
    final version = await AppInfo.version;
    return DiscipulusMcpServer(version: version);
  }

  Future<CallToolResult> _dispatchTool(
      String name, Map<String, dynamic> args) async {
    try {
      // 1. Live IPC (if Discipulus GUI is running)
      if (await _isIpcAlive()) {
        stderr.writeln("Routing '$name' via live desktop IPC");
        final res = await _ipcDio
            .post('/tool', data: {'tool': name, 'arguments': args});
        final data = res.data is Map<String, dynamic>
            ? res.data as Map<String, dynamic>
            : (res.data is String
                ? jsonDecode(res.data as String) as Map<String, dynamic>
                : <String, dynamic>{});
        final text = data['result']?.toString() ?? '';
        return CallToolResult(content: [TextContent(text: text)]);
      }

      // 2. Direct Headless fallback (Isar database)
      stderr.writeln("Routing '$name' via direct Isar database access");
      await _ensureIsar();

      final result = await McpService.executeTool(name, args);
      return CallToolResult(content: [TextContent(text: result)]);
    } catch (e, stack) {
      stderr.writeln("Tool '$name' error: $e\n$stack");
      final message = (e.toString().contains('No active') ||
              e.toString().contains('No active profile') ||
              e is StateError)
          ? 'No active Magister account found in Discipulus.\n\n'
              'Please log in to Discipulus first to sign in to your Magister account.'
          : 'Error: $e';
      return CallToolResult(content: [TextContent(text: message)], isError: true);
    }
  }

  Future<bool> _isIpcAlive() async {
    try {
      final res = await _ipcDio.get('/status');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _ensureIsar() async {
    if (_isarInitialized) return;
    initializeTimeZones();
    initializeDateFormatting("nl-NL");
    await initIsar(true);
    _isarInitialized = true;
  }

  Future<void> start() async {
    final completer = Completer<void>();
    final transport = StdioServerTransport();
    _server.server.onclose = () {
      if (!completer.isCompleted) completer.complete();
    };
    _server.server.onerror = (error) {
      if (!completer.isCompleted) completer.complete();
    };
    await _server.connect(transport);
    await completer.future;
  }
}
