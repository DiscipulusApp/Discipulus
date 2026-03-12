import 'dart:convert';
import 'dart:math';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/ai_service.dart';
import 'package:discipulus/screens/gemini/functions/ai_models.dart';
import 'package:discipulus/screens/gemini/functions/functions.dart';
import 'package:discipulus/screens/gemini/gemini.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:discipulus/screens/gemini/summarizer.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_ai/flutter_local_ai.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool usedFunction;

  ChatMessage(
      {required this.text, required this.isUser, this.usedFunction = false});
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    super.key,
    required this.textController,
    required this.onSubmitted,
    this.isLoading = false,
    this.hintText,
    this.maxLines,
  });

  final TextEditingController textController;
  final Function(String content) onSubmitted;
  final bool isLoading;
  final int? maxLines;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomCard(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: textController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: hintText ?? 'Typ je bericht...',
                      ),
                      maxLines: maxLines,
                      onSubmitted: onSubmitted,
                    ),
                  ),
                  IconButton(
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round),
                          )
                        : const Icon(Icons.send),
                    onPressed: isLoading
                        ? null
                        : () => onSubmitted(textController.text),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showGeminiChatSheet(BuildContext context) async {
  if (appSettings.openRouterAPIKey == null && !appSettings.useLocalAI) return;
  showScrollableModalBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.surface,
    initiallyOpen: true,
    context: context,
    builder: (context, setState, scrollController) {
      return ChatPromptSheetBody(controller: scrollController);
    },
  );
}

class ChatPromptSheetBodySettings {
  final String text;
  final String? initialSummary;
  final void Function(String)? onSummary;
  final Iterable<Bron> bronnen;
  final bool instantSummery;

  const ChatPromptSheetBodySettings({
    required this.text,
    this.initialSummary,
    this.onSummary,
    required this.bronnen,
    this.instantSummery = false,
  });
}

class ChatPromptSheetBody extends StatefulWidget {
  const ChatPromptSheetBody({
    super.key,
    required this.controller,
    this.settings,
    this.systemInstruction,
  });

  final ScrollController controller;
  final ChatPromptSheetBodySettings? settings;
  final AIContent? systemInstruction;

  @override
  State<ChatPromptSheetBody> createState() => _ChatPromptSheetBodyState();
}

class _ChatPromptSheetBodyState extends State<ChatPromptSheetBody> {
  late AIModel model = widget.settings != null
      ? AISettings.model
      : AIModel(name: appSettings.openRouterModel, friendlyName: "OpenRouter");
  final List<ChatMessage> _messages = [];
  final List<AIContent> _history = [];

  String? loadingState;
  TextEditingController controller = TextEditingController();
  String? summary;

  List<AIModel> models = [
    AIModel(name: appSettings.openRouterModel, friendlyName: "OpenRouter"),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.settings != null) {
      summary = widget.settings?.initialSummary;
    }
    _initializeChatModel();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _initializeChatModel() {
    setState(() {
      loadingState = null;
    });
  }

  void _scrollToEnd() => mounted
      ? WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.controller.animateTo(
            widget.controller.position.maxScrollExtent,
            duration: Durations.medium3,
            curve: Easing.standard,
          ),
        )
      : null;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _history.add(AIContent.user(text));
      controller.clear();
      loadingState = "Aan het denken...";
    });

    _scrollToEnd();

    try {
      final response = await AIService.sendMessage(
        history: _history,
        systemInstruction: widget.systemInstruction ??
            (widget.settings != null
                ? GeminiInstructions.textChatter(widget.settings!.text)
                : GeminiInstructions.generalDiscipulus),
        tools: discipulusFunctions,
      );

      if (response.isNotEmpty) {
        setState(() {
          _messages.add(ChatMessage(text: response, isUser: false));
          _history.add(AIContent.model(response));
          loadingState = null;
          HapticFeedback.lightImpact();
        });
      }
    } catch (e) {
      print("Error sending message: $e");
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
              text: "Sorry, er is iets misgegaan: ${e.toString()}",
              isUser: false));
          loadingState = null;
        });
      }
    } finally {
      HapticFeedback.heavyImpact();
      _scrollToEnd();
    }
  }

  Widget _buildMessage(ChatMessage message) {
    if (message.isUser) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Align(
          alignment: Alignment.centerRight,
          child: CustomCard(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                message.text,
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
        child: HTMLDisplay(
          html: message.text,
          convertMarkdown: true,
        ),
      );
    }
  }

  Widget systemState([bool show = true]) {
    return CustomAnimatedSize(
      child: SizedBox(
        key: ValueKey(show),
        height: show ? null : 0,
        child: show
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2)
                        .copyWith(bottom: 8),
                child: ElasticAnimation(
                  child: Text(
                    key: ValueKey(loadingState!),
                    loadingState!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildExampleTiles() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 8,
        children: [
          const SizedBox(width: 24),
          for (var e in {
            "Hoeveelheid uren":
                "Hoeveel uur zit ik deze week (maandag tot vrijdag) totaal in de les? Geef het antwoord per vak en in het totaal. Doe dit door het rooster op te halen.",
            "Ongelezen berichten": "Heb ik ongelezen berichten?",
            "Uitval check": "Vallen er in de komende twee weken lessen uit?",
            "Waar moet ik zijn": "Waar moet ik zijn voor mijn volgende les?",
            "Weekend overzicht":
                "Maak een overzicht van al mijn toetsen en onafgerond huiswerk van de week na het weekend. Laat alle toetsen los zien van het huiswerk.",
            "Vakken":
                "Geef een overzicht van alle vakken die ik aankomende lesdag (eerste dag dat ik weer les heb, haal hiervoor maar gewoon de komende week op) heb. Alle lessen die uitvallen tellen niet mee.",
            "Ben ik te laat?":
                "Ben ik te laat voor mijn eerst volgende les? Haal mijn rooster op om het te checken."
          }.entries)
            ActionChip(
              avatar: const Icon(Icons.subdirectory_arrow_right),
              label: Text(e.key),
              onPressed: () => _sendMessage(e.value),
            ),
          const SizedBox(width: 24),
        ],
      ),
    );
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
                const RowTile(icon: Icons.auto_awesome, title: "AI Assistant"),
                Row(
                  children: [
                    if (!appSettings.useLocalAI)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: const Icon(Icons.arrow_drop_down, size: 20),
                            value: model.name,
                            elevation: 2,
                            items: models
                                .map((e) => DropdownMenuItem(
                                    value: e.name, child: Text(e.friendlyName)))
                                .toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null && newValue != model.name) {
                                setState(() {
                                  model = models
                                      .where((e) => e.name == newValue)
                                      .first;
                                  appSettings
                                    ..openRouterModel = newValue
                                    ..save();
                                  _messages.clear();
                                  _history.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.settings != null)
            _buildMessage(
                ChatMessage(text: "Maak een samenvattig", isUser: true)),
          if (widget.settings == null && _messages.isEmpty)
            _buildExampleTiles(),
          if (summary == null && widget.settings != null)
            CustomAnimatedSize(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24 + 4, vertical: 8),
                child: widget.settings!.instantSummery
                    ? FutureBuilder(
                        future: Future(() async {
                          summary = await summarizeText(widget.settings!.text);
                          HapticFeedback.heavyImpact();
                          widget.settings?.onSummary?.call(summary!);
                          setState(() {});
                        }),
                        builder: (context, snapshot) {
                          return ShimmeringTextPlaceholder(
                            lineCount: 3,
                            highlightColor:
                                Theme.of(context).colorScheme.primary,
                            baseColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          );
                        },
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: LoadingButton(
                          future: () async {
                            summary =
                                await summarizeText(widget.settings!.text);
                            HapticFeedback.heavyImpact();
                            widget.settings?.onSummary?.call(summary!);
                            setState(() {});
                          },
                          child: (isLoading, onTap) => FilledButton(
                            onPressed: isLoading ? null : onTap,
                            child: const Text("Maak samenvatting"),
                          ),
                        ),
                      ),
              ),
            ),
          if (summary != null) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: HTMLDisplay(
                html: summary!,
                convertMarkdown: true,
              ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Samenvattigen kunnen fouten bevatten. Controleer altijd de inhoud.",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.settings!.bronnen.isNotEmpty)
                        LoadingButton(
                          future: () async {
                            summary = await summarizeText(widget.settings!.text,
                                bronnen: widget.settings!.bronnen);
                            widget.settings!.onSummary?.call(summary!);
                            setState(() {});
                          },
                          child: (isLoading, onTap) => IconButton(
                            onPressed: isLoading ? null : onTap,
                            icon: const Icon(Icons.upload_file),
                          ),
                        ),
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: summary!.withoutHTML!));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Gekopieerd")));
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(indent: 16, endIndent: 16),
          ],
          for (var (i, message) in _messages.indexed) ...[
            if (!_messages.last.isUser && i == _messages.length - 1)
              systemState(loadingState != null),
            _buildMessage(message),
            if (_messages.last.isUser && i == _messages.length - 1)
              systemState(loadingState != null),
          ],
          const BottomSheetBottomContentPadding()
        ],
      ),
      persistentFooterButtons: [
        ChatInputField(
          maxLines: 1,
          isLoading: loadingState != null,
          hintText: "Schrijf een vervolg prompt...",
          textController: controller,
          onSubmitted: _sendMessage,
        )
      ],
    );
  }
}
