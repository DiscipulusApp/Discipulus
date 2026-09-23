import 'dart:async';
import 'dart:convert';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/ai/ai_service.dart';
import 'package:discipulus/screens/ai/chat_screen.dart';
import 'package:discipulus/screens/ai/instructions.dart';
import 'package:discipulus/screens/ai/openai.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:flutter_local_ai/flutter_local_ai.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:mime/mime.dart';

bool _isImageMime(String mime) {
  final lower = mime.toLowerCase();
  return lower == 'image/jpeg' ||
      lower == 'image/jpg' ||
      lower == 'image/png' ||
      lower == 'image/webp' ||
      lower == 'image/gif';
}

Stream<AIStreamChunk> summarizeTextStream(
  String text, {
  Iterable<Bron> bronnen = const [],
}) async* {
  if (appSettings.aiProvider == AIProvider.systemLocalAI) {
    if (!await FlutterLocalAi().isAvailable()) return;
    await FlutterLocalAi().initialize(
      instructions: GeminiInstructions.summarizer.content ?? '',
    );

    final response = await FlutterLocalAi().generateText(
      prompt: '$text\n\nAttachments are omitted for local AI.',
      config: const GenerationConfig(temperature: 0.2),
    );
    yield AIStreamChunk(content: response.text, isDone: true);
    return;
  }

  if (!appSettings.isAiConfigured) return;

  if (bronnen.isNotEmpty) {
    // There are attachments, but we first have to download them
    await Future.wait([
      for (Bron bron in bronnen.where((e) => e.rawSavedPath == null))
        bron.download()
    ]);
  }

  final textBuffer = StringBuffer(text);
  final List<Map<String, dynamic>> imageParts = [];

  for (final bron in bronnen) {
    final file = bron.localFile;
    if (file == null || !file.existsSync()) continue;

    final detectedMime = lookupMimeType(file.path) ?? bron.contentType;
    final lowerMime = detectedMime.toLowerCase();

    if (_isImageMime(lowerMime)) {
      try {
        final bytes = file.readAsBytesSync();
        final effectiveMime =
            lowerMime == 'image/jpg' ? 'image/jpeg' : lowerMime;
        imageParts.add({
          "type": "image_url",
          "image_url": {
            "url": "data:$effectiveMime;base64,${base64Encode(bytes)}",
          }
        });
      } catch (_) {}
    } else if (lowerMime.startsWith('text/') ||
        bron.rawNaam.endsWith('.txt') ||
        bron.rawNaam.endsWith('.md') ||
        bron.rawNaam.endsWith('.csv') ||
        bron.rawNaam.endsWith('.json')) {
      try {
        final content =
            utf8.decode(file.readAsBytesSync(), allowMalformed: true);
        final trimmed = content.length > 30000
            ? '${content.substring(0, 30000)}\n[...afgekapt...]'
            : content;
        textBuffer.writeln('\n\n--- Bijlage: ${bron.naam} ---\n$trimmed');
      } catch (_) {
        textBuffer.writeln('\n\n[Bijlage: ${bron.naam}]');
      }
    } else {
      textBuffer.writeln('\n\n[Bijlage: ${bron.naam} (${bron.contentType})]');
    }
  }

  try {
    yield const AIStreamChunk(status: "Verbinden...", isThinking: true);

    Response response;
    if (imageParts.isNotEmpty) {
      try {
        response = await OpenAIClient.sendMessage(
          messages: [
            GeminiInstructions.summarizer.toJson(),
            {
              "role": "user",
              "content": [
                {"type": "text", "text": textBuffer.toString()},
                ...imageParts,
              ],
            }
          ],
          stream: true,
        );
      } catch (e) {
        // If sending with images fails (e.g. text-only model like Gemma), retry with text-only
        final textOnlyPrompt =
            '${textBuffer.toString()}\n\n(Let op: afbeeldingen uit bijlagen zijn weggelaten omdat het gekozen AI-model geen afbeeldingen ondersteunt.)';
        response = await OpenAIClient.sendMessage(
          messages: [
            GeminiInstructions.summarizer.toJson(),
            {
              "role": "user",
              "content": textOnlyPrompt,
            }
          ],
          stream: true,
        );
      }
    } else {
      response = await OpenAIClient.sendMessage(
        messages: [
          GeminiInstructions.summarizer.toJson(),
          {
            "role": "user",
            "content": textBuffer.toString(),
          }
        ],
        stream: true,
      );
    }

    if (response.statusCode != 200) {
      yield AIStreamChunk(
          content: 'Error: ${response.statusMessage}', isDone: true);
      return;
    }

    final responseBody = response.data as ResponseBody;
    final stream = responseBody.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    bool inThinkTag = false;
    bool hasYieldedThinkingStatus = false;

    await for (final line in stream) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (!trimmed.startsWith("data:")) continue;

      final dataStr = trimmed.substring(5).trim();
      if (dataStr == "[DONE]") break;

      Map<String, dynamic> data;
      try {
        data = jsonDecode(dataStr) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }

      final choices = data['choices'] as List?;
      if (choices == null || choices.isEmpty) continue;
      final choice = choices[0] as Map<String, dynamic>;
      final delta = choice['delta'] as Map<String, dynamic>?;
      if (delta == null) continue;

      final reasoning = delta['reasoning_content'] ?? delta['reasoning'];
      if (reasoning != null && reasoning is String && reasoning.isNotEmpty) {
        if (!hasYieldedThinkingStatus) {
          hasYieldedThinkingStatus = true;
          yield const AIStreamChunk(
              status: "Aan het nadenken...", isThinking: true);
        }
        yield AIStreamChunk(thinking: reasoning, isThinking: true);
      }

      final content = delta['content'];
      if (content != null && content is String && content.isNotEmpty) {
        String remaining = content;

        while (remaining.isNotEmpty) {
          if (!inThinkTag) {
            if (remaining.contains("<think>")) {
              final parts = remaining.split("<think>");
              if (parts[0].isNotEmpty) {
                yield AIStreamChunk(content: parts[0], isThinking: false);
              }
              inThinkTag = true;
              hasYieldedThinkingStatus = true;
              yield const AIStreamChunk(
                  status: "Aan het nadenken...", isThinking: true);
              remaining = parts.sublist(1).join("<think>");
            } else {
              yield AIStreamChunk(content: remaining, isThinking: false);
              remaining = "";
            }
          } else {
            if (remaining.contains("</think>")) {
              final parts = remaining.split("</think>");
              if (parts[0].isNotEmpty) {
                yield AIStreamChunk(thinking: parts[0], isThinking: true);
              }
              inThinkTag = false;
              remaining = parts.sublist(1).join("</think>");
            } else {
              yield AIStreamChunk(thinking: remaining, isThinking: true);
              remaining = "";
            }
          }
        }
      }
    }

  } catch (e) {
    String errorMsg = e.toString();
    if (errorMsg.startsWith("Exception: ")) {
      errorMsg = errorMsg.substring(11);
    }
    yield AIStreamChunk(content: 'Fout bij samenvatten: $errorMsg', isDone: true);
  }
}

Future<String?> summarizeText(
  String text, {
  Iterable<Bron> bronnen = const [],
}) async {
  final buffer = StringBuffer();
  await for (final chunk in summarizeTextStream(text, bronnen: bronnen)) {
    if (chunk.content != null) {
      buffer.write(chunk.content);
    }
  }
  return buffer.isEmpty ? null : buffer.toString();
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
    initiallyOpen: true,
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
