import 'dart:async';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/chat_screen.dart';
import 'package:discipulus/screens/gemini/gemini.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String?> summarizeText(
  String text, {
  Iterable<Bron> bronnen = const [],
}) async {
  if (appSettings.geminiAPIKey == null) return null;

  final model = GenerativeModel(
    model: GeminiSettings.model.name,
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

    return response.text;
  } catch (e) {
    return 'Error: $e';
  }
}

Future<void> showSummarizeSheet(
  BuildContext context, {
  required String text,
  String? initialSummary,
  void Function(String)? onSummary,
  Iterable<Bron> bronnen = const [],
  bool instantSummery = true,
}) async {
  showScrollableModalBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.surface,
    context: context,
    builder: (context, setState, scrollController) {
      return ChatPromptSheetBody(
        controller: scrollController,
        settings: ChatPromptSheetBodySettings(
          text: text,
          bronnen: bronnen,
          instantSummery: instantSummery,
          onSummary: onSummary,
          initialSummary: initialSummary,
        ),
      );
    },
  );
}
