import 'package:discipulus/models/settings.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Contains some general settings about Gemini

class GeminiSettings {
  static String model = "gemini-1.5-flash-8b";
  static String? get apiKey => appSettings.geminiAPIKey;
  static List<SafetySetting> safetySettings = [
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
  ];
}
