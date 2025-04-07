import 'dart:convert';
import 'dart:math';

import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/models/settings.dart';
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
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatMessage {
  final String text;
  final bool
      isUser; // True if the message is from the user, false for the chatbot
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
                    child: Expanded(
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
                  ),
                  IconButton(
                    icon: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: const CircularProgressIndicator(
                              strokeCap: StrokeCap.round,
                            ),
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
  if (appSettings.geminiAPIKey == null) return;
  showScrollableModalBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.surface,
    initiallyOpen: true,
    context: context,
    builder: (context, setState, scrollController) {
      return ChatPromptSheetBody(
        controller: scrollController,
      );
    },
  );
}

class ChatPromptSheetBodySettings {
  final String text; // Text to be summarized
  final String? initialSummary; // Already existing summery
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
  final Content? systemInstruction;

  @override
  State<ChatPromptSheetBody> createState() => _ChatPromptSheetBodyState();
}

class _ChatPromptSheetBodyState extends State<ChatPromptSheetBody> {
  // Model Settings
  late GeminiModel model = widget.settings != null
      ? GeminiSettings.model
      : GeminiModel(name: "gemini-2.0-flash", friendlyName: "2.0 Flash");
  final List<ChatMessage> _messages = [];
  late GenerativeModel? _model;
  late ChatSession? _chat;

  // State variables
  String? loadingState; // null is not loading
  TextEditingController controller = TextEditingController();

  // Summery variables
  String? summary;

  // Models
  List<GeminiModel> models = [
    GeminiModel(
      name: "gemini-2.0-flash-lite",
      friendlyName: "2.0 Flash Lite",
    ),
    GeminiModel(
      name: "gemini-2.0-flash",
      friendlyName: "2.0 Flash",
    ),
    GeminiModel(
      name: "gemini-2.5-pro-exp-03-25",
      friendlyName: "2.5 Pro Thinking",
    )
  ];

  @override
  void initState() {
    super.initState();

    if (widget.settings != null) {
      // Apply summery settings
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
    _model = appSettings.geminiAPIKey != null
        ? GenerativeModel(
            generationConfig:
                GenerationConfig(temperature: 0.2, topK: 40, topP: 0.8),
            model: model.name,
            apiKey: appSettings.geminiAPIKey!,
            systemInstruction: widget.systemInstruction ??
                (widget.settings != null
                    ? GeminiInstructions.textChatter(widget.settings!.text)
                    : GeminiInstructions.generalDiscipulus),
            safetySettings: GeminiSettings.safetySettings,
            tools: [Tool(functionDeclarations: discipulusFunctions)],
          )
        : null;

    if (_model != null) {
      _chat = _model!.startChat(
        history: _messages
            .map((msg) => Content(
                  msg.isUser ? 'user' : 'model',
                  [if (msg.text.isNotEmpty) TextPart(msg.text)],
                ))
            .toList(),
      );
    } else {
      _chat = null;
    }

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
    if (text.trim().isEmpty || _chat == null) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      controller.clear();
      loadingState = "Aan het denken..."; // Initial thought
    });

    _scrollToEnd();

    String accumulatedText = "";
    bool functionCallHandled = false; // Track if a function response is awaited

    try {
      Stream<GenerateContentResponse> responseStream =
          _chat!.sendMessageStream(Content.text(text));

      await for (final response in responseStream) {
        // --- Handle Text Chunks ---
        final chunk = response.text;
        if (chunk != null && chunk.isNotEmpty) {
          functionCallHandled = false; // Reset flag if text arrives
          _scrollToEnd();
          setState(() {
            // Ensure loadingState reflects model activity if thoughts are shown
            if (loadingState != "Aan het schrijven...") {
              loadingState = "Aan het schrijven...";
            }
            accumulatedText += chunk;
            if (_messages.isNotEmpty && !_messages.last.isUser) {
              // Append to the last message if it's from the bot
              _messages[_messages.length - 1] =
                  ChatMessage(text: accumulatedText, isUser: false);
            } else {
              // Add a new message if the last one was from the user or list is empty
              _messages.add(ChatMessage(
                  text: accumulatedText,
                  isUser: false)); // Start with accumulated
              HapticFeedback.lightImpact();
            }
          });
        }

        // --- Handle Function Calls ---
        final functionCalls =
            response.functionCalls.toList(); // Get all calls in this response
        if (functionCalls.isNotEmpty) {
          functionCallHandled = true; // We are now waiting for function results
          final responses = <FunctionResponse>[];

          setState(() {
            loadingState = "Functie aanroep starten...";
          });

          await Future.forEach(functionCalls, (functionCall) async {
            // Display thought: Executing specific function

            setState(() {
              loadingState = "Actie uitvoeren: ${functionCall.readableName}";
            });

            final result = await handleFunctionCall(functionCall);
            responses
                .add(FunctionResponse(functionCall.name, jsonDecode(result)));
          });

          // Display thought: Sending function results back

          setState(() {
            loadingState = "Resultaten verwerken...";
          });

          final functionCallContent = Content.functionResponses(responses);

          // Send function responses back to the model
          // Note: Use sendMessageStream again to continue the conversation flow naturally
          final newResponseStream =
              _chat!.sendMessageStream(functionCallContent);

          // Handle the subsequent response (which should contain the text reply after function call)
          // Reset accumulated text for the *new* response part
          accumulatedText = "";
          await for (final fr in newResponseStream) {
            final functionResponseChunk = fr.text;
            if (functionResponseChunk != null &&
                functionResponseChunk.isNotEmpty) {
              _scrollToEnd();
              setState(() {
                if (loadingState != "Aan het schrijven...") {
                  loadingState = "Aan het schrijven...";
                }
                accumulatedText += functionResponseChunk;
                // Check if the *very last* message was the user's initial prompt
                // or if the last message was already a bot message (potentially from before the function call stream)
                if (_messages.isNotEmpty && !_messages.last.isUser) {
                  _messages[_messages.length - 1] =
                      ChatMessage(text: accumulatedText, isUser: false);
                } else {
                  _messages
                      .add(ChatMessage(text: accumulatedText, isUser: false));
                  HapticFeedback.lightImpact();
                }
              });
            }
            // Note: We might receive more function calls here in complex scenarios,
            // but this basic implementation handles one level.
          }
          functionCallHandled =
              false; // Function interaction complete for this turn
        }
      }
    } catch (e) {
      print("Error sending message: $e"); // Log the error
      if (mounted) {
        setState(() {
          // Add a distinct error message
          _messages.add(ChatMessage(
              text: "Sorry, er is iets misgegaan: ${e.toString()}",
              isUser: false));
        });
      }
    } finally {
      HapticFeedback.heavyImpact();
      _scrollToEnd();
      if (mounted && !functionCallHandled) {
        // Only clear loading if not waiting for func response
        setState(() {
          loadingState = null;
        });
      } else if (mounted && functionCallHandled) {
        // If we finished the loop but are stuck waiting (e.g., error during function call response)
        // Ensure loading state reflects this if thoughts are shown

        setState(() {
          loadingState = "Wachten op functie resultaat...";
        });
      }
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
                const RowTile(icon: Icons.auto_awesome, title: "Gemini"),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0), // Adjust padding if needed
                      child: DropdownButtonHideUnderline(
                        // Hide default underline
                        child: DropdownButton<String>(
                          icon: const Icon(Icons.arrow_drop_down, size: 20),
                          value: model.name,
                          elevation: 2, // Dropdown shadow
                          items: models
                              .map((e) => DropdownMenuItem(
                                  value: e.name, child: Text(e.friendlyName)))
                              .toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null && newValue != model) {
                              // Optional: Add confirmation dialog here
                              // showDialog(...);
                              setState(() {
                                model = models
                                    .where((e) => e.name == newValue)
                                    .first;
                                _messages
                                    .clear(); // Clear messages on model change
                                _initializeChatModel(); // Re-initialize with the new model
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
                      if (widget.settings!.bronnen.isNotEmpty)
                        LoadingButton(
                          future: () async {
                            // Summarize with attachments
                            summary = await summarizeText(
                              widget.settings!.text,
                              bronnen: widget.settings!.bronnen,
                            );
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
