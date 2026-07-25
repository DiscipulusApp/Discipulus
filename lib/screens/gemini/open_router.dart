import 'package:dio/dio.dart';
import 'package:discipulus/models/settings.dart';

class OpenRouterClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://openrouter.ai/api/v1/',
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
      'chat/completions',
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

  static String getFriendlyError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 404) {
        return "Fout: De AI-dienst kon niet worden bereikt (404). Controleer of de modelnaam '${appSettings.openRouterModel}' nog geldig is op OpenRouter.";
      } else if (statusCode == 401) {
        return "Fout: Ongeldige API-key (401). Controleer de API-key in de instellingen.";
      } else if (statusCode == 402) {
        return "Fout: Onvoldoende saldo (402). OpenRouter meldt dat het tegoed op is.";
      } else if (statusCode == 429) {
        return "Fout: Te veel verzoeken (429). De limiet is bereikt, probeer het later opnieuw.";
      } else if (error.type == DioExceptionType.connectionTimeout ||
                 error.type == DioExceptionType.receiveTimeout ||
                 error.type == DioExceptionType.sendTimeout) {
        return "Fout: Verbinding met OpenRouter mislukt. Controleer je internetverbinding.";
      }
      return "Fout bij OpenRouter-verbinding: ${error.message ?? error.toString()}";
    }
    return "Fout: ${error.toString()}";
  }
}
