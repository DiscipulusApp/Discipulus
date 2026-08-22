import 'package:dio/dio.dart';
import 'package:discipulus/models/settings.dart';

class OpenRouterClient {
  static Dio dio = Dio(BaseOptions(
    baseUrl: 'https://openrouter.ai/api/v1/',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static String? get apiKey {
    try {
      return appSettings.openRouterAPIKey;
    } catch (_) {
      return null;
    }
  }

  static String get defaultModel {
    try {
      return appSettings.openRouterModel;
    } catch (_) {
      return "google/gemini-2.0-flash-lite:free";
    }
  }

  static Future<Response> sendMessage({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>>? tools,
    String? apiKey,
    String? model,
    bool stream = false,
  }) async {
    final key = apiKey ?? OpenRouterClient.apiKey;
    if (key == null) throw Exception('OpenRouter API key not set');

    try {
      return await dio.post(
        'chat/completions',
        data: {
          'model': model ?? defaultModel,
          'messages': messages,
          if (tools != null) 'tools': tools,
          'stream': stream,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $key',
            'HTTP-Referer': 'https://github.com/DiscipulusApp/Discipulus',
            'X-Title': 'Discipulus',
            'X-OpenRouter-Title': 'Discipulus',
          },
          responseType: stream ? ResponseType.stream : ResponseType.json,
        ),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String? errorMessage;
      if (errorData is Map && errorData['error'] != null) {
        if (errorData['error'] is Map && errorData['error']['message'] != null) {
          errorMessage = errorData['error']['message'].toString();
        } else if (errorData['error'] is String) {
          errorMessage = errorData['error'];
        }
      }
      throw Exception(errorMessage ??
          e.message ??
          'OpenRouter error: ${e.response?.statusCode ?? "onbekend"}');
    }
  }
}
