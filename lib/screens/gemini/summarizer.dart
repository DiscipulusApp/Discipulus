import 'dart:async';
import 'dart:convert';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/chat_screen.dart';
import 'package:discipulus/screens/gemini/functions/ai_models.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:discipulus/screens/gemini/open_router.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:flutter_local_ai/flutter_local_ai.dart';
import 'package:flutter/material.dart';

Future<String?> summarizeText(
  String text, {
  Iterable<Bron> bronnen = const [],
}) async {
  if (appSettings.useLocalAI) {
    if (!await FlutterLocalAi().isAvailable()) return null;
    await FlutterLocalAi().initialize(
      instructions: GeminiInstructions.summarizer.parts
          .whereType<AITextPart>()
          .map((p) => p.text)
          .join('\n'),
    );

    try {
      final response = await FlutterLocalAi().generateText(
        prompt: '$text\n\nAttachments are omitted for local AI.',
        config: const GenerationConfig(temperature: 0.2),
      );
      return response.text;
    } catch (e) {
      return 'Error: $e';
    }
  }

  if (appSettings.openRouterAPIKey == null) return null;

  if (bronnen.isNotEmpty) {
    //   // There are attachments, but we first have to download them
    await Future.wait([
      for (Bron bron in bronnen.where((e) => e.rawSavedPath == null))
        bron.download()
    ]);
  }

  try {
    final List<Map<String, dynamic>> messages = [
      GeminiInstructions.summarizer.toOpenRouterJson(),
      {
        "role": "user",
        "content": [
          {"type": "text", "text": text},
          for (var bron in bronnen)
            {
              "type": "image_url",
              "image_url": {
                "url": "data:${bron.contentType};base64,${base64Encode(bron.localFile!.readAsBytesSync())}"
              }
            }
        ]
      }
    ];

    final response = await OpenRouterClient.sendMessage(messages: messages);

    if (response.statusCode == 200) {
      return response.data['choices'][0]['message']['content'];
    } else {
      return 'Error: ${response.statusMessage}';
    }
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
