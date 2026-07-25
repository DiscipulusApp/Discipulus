import 'package:discipulus/models/settings.dart';

/// Contains some general settings about AI

class AISettings {
  static AIModel model =
      AIModel(name: "meta-llama/llama-3.3-70b-instruct:free", friendlyName: "Llama 3.3 70B Free");
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
