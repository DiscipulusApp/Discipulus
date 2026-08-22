import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

enum LogLevel { info, step, warn, error }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? category;
  final Object? error;
  final StackTrace? stackTrace;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.category,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    final timeStr = timestamp.toIso8601String().split('T').last.substring(0, 12);
    final levelStr = level.name.toUpperCase().padRight(5);
    final catStr = category != null ? '[$category] ' : '';
    var text = '[$timeStr] $levelStr $catStr$message';
    if (error != null) {
      text += '\n  Error: $error';
    }
    if (stackTrace != null) {
      text += '\n  StackTrace:\n$stackTrace';
    }
    return text;
  }
}

class LoginLogger {
  LoginLogger._();
  static final LoginLogger instance = LoginLogger._();

  final List<LogEntry> _entries = [];
  DateTime? _sessionStart;
  String _sessionName = "Login Session";

  List<LogEntry> get entries => List.unmodifiable(_entries);
  bool get hasErrors => _entries.any((e) => e.level == LogLevel.error);
  LogEntry? get lastError =>
      _entries.cast<LogEntry?>().lastWhere((e) => e?.level == LogLevel.error, orElse: () => null);

  /// Start a new logging session
  void startSession(String sessionName) {
    _sessionName = sessionName;
    _sessionStart = DateTime.now();
    _entries.clear();
    info("Sessie gestart: $sessionName", category: "SESSION");
    info("Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}", category: "DEVICE");
    info("Debug mode: $kDebugMode", category: "DEVICE");
  }

  void step(String description) {
    _log(LogLevel.step, description, category: "STEP");
    if (kDebugMode) {
      print("🚀 [LoginLogger STEP] $description");
    }
  }

  void info(String message, {String? category}) {
    _log(LogLevel.info, message, category: category);
    if (kDebugMode) {
      print("ℹ️ [LoginLogger INFO] ${category != null ? '[$category] ' : ''}$message");
    }
  }

  void warn(String message, {String? category, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warn, message, category: category, error: error, stackTrace: stackTrace);
    if (kDebugMode) {
      print("⚠️ [LoginLogger WARN] $message ${error ?? ''}");
    }
  }

  void error(String message, {String? category, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, category: category, error: error, stackTrace: stackTrace);
    if (kDebugMode) {
      print("❌ [LoginLogger ERROR] $message ${error ?? ''}\n${stackTrace ?? ''}");
    }
  }

  void http(String method, String url, {int? statusCode, dynamic responseData, String? error}) {
    final scrubbedUrl = _scrub(url);
    var msg = "$method $scrubbedUrl";
    if (statusCode != null) msg += " -> Status $statusCode";
    if (error != null) msg += " -> Error: ${_scrub(error)}";
    info(msg, category: "HTTP");
  }

  void _log(
    LogLevel level,
    String message, {
    String? category,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _entries.add(LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: _scrub(message),
      category: category,
      error: error != null ? _scrub(error.toString()) : null,
      stackTrace: stackTrace,
    ));
  }

  /// Scrub sensitive tokens, emails, and school subdomains from logs
  String _scrub(String text) {
    var result = text;
    // Scrub Bearer tokens
    result = result.replaceAll(RegExp(r'Bearer\s+[A-Za-z0-9\-_=.]+'), 'Bearer [REDACTED_TOKEN]');
    // Scrub code query param
    result = result.replaceAllMapped(
      RegExp(r'code=([A-Za-z0-9\-_=]+)'),
      (match) => 'code=[REDACTED_CODE]',
    );
    // Scrub access/refresh tokens in JSON strings
    result = result.replaceAllMapped(
      RegExp(r'"(access_token|refresh_token|id_token)"\s*:\s*"[^"]+"'),
      (match) => '"${match.group(1)}": "[REDACTED_TOKEN]"',
    );
    // Scrub subdomains (e.g. schoolname.magister.net -> ***.magister.net)
    result = result.replaceAllMapped(
      RegExp(r'([\w\-]+)\.magister\.net'),
      (match) => '***.magister.net',
    );
    // Scrub email addresses
    result = result.replaceAll(
      RegExp(r'[\w\.-]+@[\w\.-]+\.\w+'),
      '***@***.***',
    );
    return result;
  }

  /// Export formatted diagnostic report
  String getLogText() {
    final buffer = StringBuffer();
    buffer.writeln("=== DISCIPULUS LOGIN DIAGNOSTISCH RAPPORT ===");
    buffer.writeln("Sessie: $_sessionName");
    buffer.writeln("Tijdstip: ${_sessionStart ?? DateTime.now()}");
    buffer.writeln("Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}");
    buffer.writeln("==============================================\n");

    if (_entries.isEmpty) {
      buffer.writeln("Geen logregels geregistreerd.");
      return buffer.toString();
    }

    for (final entry in _entries) {
      buffer.writeln(entry.toString());
    }

    final err = lastError;
    if (err != null) {
      buffer.writeln("\n=== LAATSTE FOUT OVERZICHT ===");
      buffer.writeln("Foutmelding: ${err.message}");
      if (err.error != null) buffer.writeln("Details: ${err.error}");
      if (err.stackTrace != null) buffer.writeln("Stacktrace:\n${err.stackTrace}");
      buffer.writeln("================================");
    }

    return buffer.toString();
  }

  /// Share log using system share sheet
  Future<void> shareLog(BuildContext context) async {
    final text = getLogText();
    await Share.share(
      text,
      subject: "Discipulus Login Foutrapport",
    );
  }

  /// Copy log to clipboard
  Future<void> copyToClipboard(BuildContext context) async {
    final text = getLogText();
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Foutrapport gekopieerd naar klembord"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void clear() {
    _entries.clear();
    _sessionStart = null;
  }
}
