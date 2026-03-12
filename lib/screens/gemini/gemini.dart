import 'package:discipulus/models/settings.dart';

/// Contains some general settings about AI

class AISettings {
  static AIModel model =
      AIModel(name: "google/gemini-2.0-flash-lite:free", friendlyName: "Gemini 2.0 Flash Lite");
  static String? get openRouterApiKey => appSettings.openRouterAPIKey;
}

class AIModel {
  String name;
  String friendlyName;
  bool isThinking;

  AIModel({
    required this.name,
    required this.friendlyName,
    this.isThinking = false,
  });
}
