import 'package:discipulus/models/settings.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Contains some general settings about Gemini

class GeminiSettings {
  static GeminiModel model = GeminiModel(
      name: "gemini-2.0-flash-lite", friendlyName: "Flash 2.0 Lite");
  static String? get apiKey => appSettings.geminiAPIKey;
  static List<SafetySetting> safetySettings = [
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
  ];
}

class GeminiModel {
  String name;
  String friendlyName;
  bool isThinking;

  GeminiModel({
    required this.name,
    required this.friendlyName,
    this.isThinking = false,
  });
}
