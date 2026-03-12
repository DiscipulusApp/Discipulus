import 'package:dio/dio.dart';
import 'package:discipulus/models/settings.dart';

class OpenRouterClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://openrouter.ai/api/v1',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static String? get apiKey => appSettings.openRouterAPIKey;

  static Future<Response> sendMessage({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>>? tools,
    bool stream = false,
  }) async {
    if (apiKey == null) throw Exception('OpenRouter API key not set');

    return await _dio.post(
      '/chat/completions',
      data: {
        'model': appSettings.openRouterModel,
        'messages': messages,
        if (tools != null) 'tools': tools,
        'stream': stream,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://github.com/DiscipulusApp/Discipulus',
          'X-Title': 'Discipulus',
        },
        responseType: stream ? ResponseType.stream : ResponseType.json,
      ),
    );
  }
}
