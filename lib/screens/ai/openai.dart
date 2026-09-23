import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:discipulus/models/settings.dart';

class OpenAIClient {
  static Dio dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 180),
  ));

  static String get baseUrl {
    try {
      String url = appSettings.aiBaseUrl.trim();
      if (!url.endsWith('/')) url += '/';
      return url;
    } catch (_) {
      return 'https://api.openai.com/v1/';
    }
  }

  static String? get apiKey {
    try {
      return appSettings.aiApiKey;
    } catch (_) {
      return null;
    }
  }

  static String get defaultModel {
    try {
      return appSettings.aiModel;
    } catch (_) {
      return "gpt-5.6-luna";
    }
  }

  static Future<Response> sendMessage({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>>? tools,
    String? baseUrl,
    String? apiKey,
    String? model,
    bool stream = false,
  }) async {
    final effectiveBase = baseUrl?.trim() ?? OpenAIClient.baseUrl;
    final baseWithSlash =
        effectiveBase.endsWith('/') ? effectiveBase : '$effectiveBase/';
    final key = apiKey?.trim() ?? OpenAIClient.apiKey;
    final effectiveModel = model?.trim() ?? defaultModel;

    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      if (key != null && key.isNotEmpty) 'Authorization': 'Bearer $key',
      'HTTP-Referer': 'https://github.com/DiscipulusApp/Discipulus',
      'X-Title': 'Discipulus',
      'X-OpenRouter-Title': 'Discipulus',
    };

    try {
      return await dio.post(
        '${baseWithSlash}chat/completions',
        data: {
          'model': effectiveModel,
          'messages': messages,
          if (tools != null && tools.isNotEmpty) 'tools': tools,
          'stream': stream,
        },
        options: Options(
          headers: headers,
          responseType: stream ? ResponseType.stream : ResponseType.json,
        ),
      );
    } on DioException catch (e) {
      dynamic errorData = e.response?.data;
      if (errorData is String) {
        try {
          errorData = jsonDecode(errorData);
        } catch (_) {}
      }

      String? errorMessage;
      if (errorData is Map && errorData['error'] != null) {
        if (errorData['error'] is Map &&
            errorData['error']['message'] != null) {
          errorMessage = errorData['error']['message'].toString();
        } else if (errorData['error'] is String) {
          errorMessage = errorData['error'];
        }
      }

      if (errorMessage == null) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Verbinding time-out: de server reageerde niet op tijd.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage =
              'Kan geen verbinding maken met $baseWithSlash. Controleer of de server online is en de URL klopt.';
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'Ongeldige API key (401 Unauthorized).';
        } else if (e.response?.statusCode == 404) {
          errorMessage =
              'Endpoint niet gevonden (404 Not Found). Controleer de Base URL en modelnaam.';
        }
      }

      throw Exception(errorMessage ??
          e.message ??
          'AI API fout: ${e.response?.statusCode ?? "onbekend"}');
    }
  }

  static Future<bool> testConnection({
    String? baseUrl,
    String? apiKey,
    String? model,
  }) async {
    try {
      final response = await sendMessage(
        baseUrl: baseUrl,
        apiKey: apiKey,
        model: model,
        messages: [
          {"role": "user", "content": "Hi"}
        ],
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

/// Backwards compatibility alias
typedef OpenRouterClient = OpenAIClient;
