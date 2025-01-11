import 'dart:async';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/chat_screen.dart';
import 'package:discipulus/screens/gemini/gemini.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      return _SummarizePromptBody(
          controller: scrollController,
          initialSummary: initialSummary,
          text: text,
          onSummary: onSummary,
          bronnen: bronnen,
          instantSummery: instantSummery);
    },
  );
}

class _SummarizePromptBody extends StatefulWidget {
  const _SummarizePromptBody(
      {required this.controller,
      required this.text,
      this.initialSummary,
      this.onSummary,
      this.bronnen = const [],
      this.instantSummery = true});

  final ScrollController controller;
  final String text;
  final String? initialSummary;
  final void Function(String)? onSummary;
  final Iterable<Bron> bronnen;
  final bool instantSummery;

  @override
  State<_SummarizePromptBody> createState() => _SummarizePromptBodyState();
}

class _SummarizePromptBodyState extends State<_SummarizePromptBody> {
  late String? summary = widget.initialSummary;
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  final List<ChatMessage> _messages = [];
  late GenerativeModel? _model;
  late ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _model = appSettings.geminiAPIKey != null
        ? GenerativeModel(
            model: 'gemini-1.5-flash',
            apiKey: appSettings.geminiAPIKey!,
            systemInstruction: GeminiInstructions.textChatter(widget.text),
            safetySettings: [
              SafetySetting(
                  HarmCategory.dangerousContent, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
              SafetySetting(
                  HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
            ],
          )
        : null;

    if (_model != null) {
      _chat = _model!.startChat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _scrollToEnd() => WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.controller.animateTo(
          widget.controller.position.maxScrollExtent,
          duration: Durations.medium3,
          curve: Easing.standard,
        ),
      );

  Future<void> _sendMessage(String text) async {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      controller.clear();
      isLoading = true;
    });

    _scrollToEnd();

    String accumulatedText = "";
    try {
      final responseStream = _chat.sendMessageStream(Content.text(text));
      await for (final response in responseStream) {
        final chunk =
            response.text?.replaceAll("```html", "").replaceAll("```", "");
        if (chunk != null) {
          _scrollToEnd();
          setState(() {
            accumulatedText += chunk;
            if (_messages.isNotEmpty && !_messages.last.isUser) {
              _messages[_messages.length - 1] =
                  ChatMessage(text: accumulatedText, isUser: false);
            } else {
              _messages.add(ChatMessage(text: chunk, isUser: false));
              HapticFeedback.lightImpact();
            }
          });
        }
      }
    } catch (e) {
      setState(() {
        _messages
            .add(ChatMessage(text: "Error: ${e.toString()}", isUser: false));
      });
    } finally {
      HapticFeedback.heavyImpact();
      _scrollToEnd();
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildMessage(String content, {bool fromUser = true}) {
    if (fromUser) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Align(
          alignment: Alignment.centerRight,
          child: CustomCard(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                content,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: HTMLDisplay(html: content),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: widget.controller,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RowTile(icon: Icons.auto_awesome, title: "Gemini"),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          _buildMessage("Maak een samenvattig"),
          if (summary == null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24 + 4, vertical: 8),
              child: widget.instantSummery
                  ? FutureBuilder(
                      future: Future(() async {
                        summary = await summarizeText(widget.text);
                        HapticFeedback.heavyImpact();
                        widget.onSummary?.call(summary!);
                        setState(() {});
                      }),
                      builder: (context, snapshot) {
                        return const Text("Bezig met samenvatten...");
                      },
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: LoadingButton(
                        future: () async {
                          summary = await summarizeText(widget.text);
                          HapticFeedback.heavyImpact();
                          widget.onSummary?.call(summary!);
                          setState(() {});
                        },
                        child: (isLoading, onTap) => FilledButton(
                          onPressed: isLoading ? null : onTap,
                          child: const Text("Maak samenvatting"),
                        ),
                      ),
                    ),
            ),
          if (summary != null) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: HTMLDisplay(html: summary!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Text(
                        "Samenvattigen kunnen fouten bevatten. Controleer altijd de inhoud.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.bronnen.isNotEmpty)
                        LoadingButton(
                          future: () async {
                            // Summarize with attachments
                            summary = await summarizeText(
                              widget.text,
                              bronnen: widget.bronnen,
                            );
                            widget.onSummary?.call(summary!);
                            setState(() {});
                          },
                          child: (isLoading, onTap) => IconButton(
                            onPressed: isLoading ? null : onTap,
                            icon: const Icon(Icons.upload_file),
                          ),
                        ),
                      IconButton(
                        onPressed: () async {
                          // Copy the summery
                          await Clipboard.setData(
                            ClipboardData(text: summary!.withoutHTML!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Gekopieerd"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
          ],
          for (var message in _messages)
            _buildMessage(message.text, fromUser: message.isUser),
          const BottomSheetBottomContentPadding()
        ],
      ),
      persistentFooterButtons: [
        ChatInputField(
          maxLines: 1,
          isLoading: isLoading,
          hintText: "Schrijf een vervolg prompt...",
          textController: controller,
          onSubmitted: _sendMessage,
        )
      ],
    );
  }
}
