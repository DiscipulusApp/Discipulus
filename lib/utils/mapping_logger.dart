import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class MappingError {
  final DateTime timestamp;
  final String modelName;
  final String error;
  final StackTrace? stackTrace;
  final dynamic sanitizedPayload;

  MappingError({
    required this.timestamp,
    required this.modelName,
    required this.error,
    this.stackTrace,
    this.sanitizedPayload,
  });

  String get formattedSchema {
    if (sanitizedPayload == null) return "Geen data beschikbaar";
    try {
      return const JsonEncoder.withIndent("  ").convert(sanitizedPayload);
    } catch (e) {
      return sanitizedPayload.toString();
    }
  }

    String toReport() {
    final buffer = StringBuffer();
    buffer.writeln("=== MAPPING FOUT RAPPORT ===");
    buffer.writeln("Model: $modelName");
    buffer.writeln("Tijdstip: ${timestamp.toIso8601String()}");
    buffer.writeln("Fout: $error");
    buffer.writeln("\n--- GEANONIMISEERDE STRUCTUUR (TYPE SCHEMA) ---");
    buffer.writeln(formattedSchema);
    if (stackTrace != null) {
      buffer.writeln("\n--- STACKTRACE ---");
      buffer.writeln(stackTrace.toString());
    }
    buffer.writeln("============================");
    return buffer.toString();
  }
}

/// Global list of mapping errors
List<MappingError> mappingErrors = [];


class MappingLogger {
  MappingLogger._();
  static final MappingLogger instance = MappingLogger._();

  static const int maxStoredErrors = 100;

  List<MappingError> get errors => List.unmodifiable(mappingErrors);

  /// Recursively sanitizes any Map or List so that ONLY keys and data types remain.
  /// This is needed, as we cannot leak private data and asking people to manually remove
  /// it from it is just sad. 
  static dynamic sanitize(dynamic data) {
    if (data == null) {
      return null;
    } else if (data is Map) {
      return data.map(
        (key, value) => MapEntry(key.toString(), sanitize(value)),
      );
    } else if (data is List) {
      if (data.isEmpty) return [];
      return data.map((item) => sanitize(item)).toList();
    } else if (data is bool) {
      return "<bool>";
    } else if (data is int) {
      return "<int>";
    } else if (data is double) {
      return "<double>";
    } else if (data is String) {
      if (data.isEmpty) return "<String: empty>";
      if (DateTime.tryParse(data) != null) return "<String: ISO-8601>";
      if (RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
          .hasMatch(data)) {
        return "<String: UUID>";
      }
      if (RegExp(r'^https?://[^\s]+$').hasMatch(data)) {
        return "<String: URL>";
      }
      return "<String>";
    } else {
      return "<${data.runtimeType}>";
    }
  }

  static String scrubMessage(String message) {
    var result = message;
    result = result.replaceAll(
      RegExp(r'Bearer\s+[A-Za-z0-9\-_=.]+'),
      'Bearer [REDACTED_TOKEN]',
    );
    result = result.replaceAllMapped(
      RegExp(r'([\w\-]+)\.magister\.net'),
      (match) => '***.magister.net',
    );
    result = result.replaceAll(
      RegExp(r'[\w\.-]+@[\w\.-]+\.\w+'),
      '***@***.***',
    );
    return result;
  }

  /// Record a mapping error with its sanitized payload
  void record({
    required String modelName,
    required Object error,
    StackTrace? stackTrace,
    dynamic rawData,
  }) {
    final sanitized = rawData != null ? sanitize(rawData) : null;
    final scrubbedErr = scrubMessage(error.toString());

    final mappingError = MappingError(
      timestamp: DateTime.now(),
      modelName: modelName,
      error: scrubbedErr,
      stackTrace: stackTrace,
      sanitizedPayload: sanitized,
    );

    mappingErrors.insert(0, mappingError);

    if (mappingErrors.length > maxStoredErrors) {
      mappingErrors.removeLast();
    }

    if (kDebugMode) {
      debugPrint("⚠️ [MappingLogger] Mapping failure in $modelName: $scrubbedErr");
    }
  }


  /// Exports all recorded errors into a single diagnostic text
  String exportReport() {
    if (mappingErrors.isEmpty) {
      return "Geen mapping-fouten geregistreerd.";
    }

    final buffer = StringBuffer();
    buffer.writeln("=== DISCIPULUS MAPPING DIAGNOSTIEK ===");
    buffer.writeln("Totaal fouten: ${mappingErrors.length}");
    buffer.writeln("Geëxporteerd op: ${DateTime.now().toIso8601String()}");
    buffer.writeln("======================================\n");

    for (int i = 0; i < mappingErrors.length; i++) {
      buffer.writeln("#${i + 1}");
      buffer.writeln(mappingErrors[i].toReport());
      buffer.writeln();
    }

    return buffer.toString();
  }

  Future<void> copyToClipboard(BuildContext context, {MappingError? specificError}) async {
    final text = specificError != null ? specificError.toReport() : exportReport();
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(specificError != null
              ? "Mapping-fout gekopieerd naar klembord"
              : "Alle mapping-fouten gekopieerd naar klembord"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> shareLog(BuildContext context, {MappingError? specificError}) async {
    final text = specificError != null ? specificError.toReport() : exportReport();
    // ignore: deprecated_member_use
    await Share.share(
      text,
      subject: "Discipulus Mapping Foutrapport",
    );
  }

  /// Safely maps a single object, capturing any failure and returning [fallback] (or null).
  static T? safeMap<T>(
    T Function() mapFn, {
    String? modelName,
    dynamic rawData,
    T? fallback,
  }) {
    try {
      return mapFn();
    } catch (e, st) {
      instance.record(
        modelName: modelName ?? T.toString(),
        error: e,
        stackTrace: st,
        rawData: rawData,
      );
      return fallback;
    }
  }

  static List<T> safeMapList<T>(
    dynamic rawList,
    T Function(Map<String, dynamic> item) mapper, {
    String? modelName,
    bool continueOnError = true,
  }) {
    if (rawList == null || rawList is! Iterable) return [];
    final result = <T>[];

    for (final raw in rawList) {
      Map<String, dynamic>? mapItem;
      if (raw is Map<String, dynamic>) {
        mapItem = raw;
      } else if (raw is Map) {
        mapItem = Map<String, dynamic>.from(raw);
      }

      if (mapItem != null) {
        try {
          result.add(mapper(mapItem));
        } catch (e, st) {
          instance.record(
            modelName: modelName ?? T.toString(),
            error: e,
            stackTrace: st,
            rawData: mapItem,
          );
          if (!continueOnError) rethrow;
        }
      }
    }

    return result;
  }
}
