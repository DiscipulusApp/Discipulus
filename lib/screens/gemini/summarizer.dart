import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/gemini.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String?> summarizeText(
  String text, {
  Iterable<Bron> bronnen = const [],
}) async {
  if (appSettings.geminiAPIKey == null) return null;

  final model = GenerativeModel(
    model: GeminiSettings.model,
    apiKey: GeminiSettings.apiKey!,
    systemInstruction: GeminiInstructions.summarizer,
    generationConfig: GenerationConfig(temperature: 0.2, topP: 1, topK: 1),
    safetySettings: GeminiSettings.safetySettings,
  );

  if (bronnen.isNotEmpty) {
    //   // There are attachments, but we first have to download them
    await Future.wait([
      for (Bron bron in bronnen.where((e) => e.rawSavedPath == null))
        bron.download()
    ]);
  }

  try {
    final content = [
      Content.text(text),
      for ((int, Bron) bron in bronnen.indexed)
        Content.data(bron.$2.contentType, bron.$2.localFile!.readAsBytesSync())
    ];
    final response = await model.generateContent(content);

    if (response.text?.contains("```html") ?? false) {
      // Sometimes for some reason, even though specified otherwise, Gemini still
      // generates markdown markup. This is really ugly, so we will remove it by
      // force
      return response.text!.replaceAll("```html", "").replaceAll("```", "");
    }

    return response.text;
  } catch (e) {
    return 'Error: $e';
  }
}
