import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/mcp/mcp_tools.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/ai/ai_models.dart';
import 'package:discipulus/screens/ai/ai_service.dart';
import 'package:discipulus/screens/ai/instructions.dart';
import 'package:discipulus/screens/ai/summarizer.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatMessage {
  String text;
  String? thinking;
  final bool isUser;
  bool usedFunction;
  bool isThinkingExpanded;
  bool isStreamingThinking;

  ChatMessage({
    required this.text,
    this.thinking,
    required this.isUser,
    this.usedFunction = false,
    this.isThinkingExpanded = false,
    this.isStreamingThinking = false,
  });
}

class _ThinkingBlock extends StatefulWidget {
  final String thinking;
  final bool isStreaming;
  final bool initiallyExpanded;

  const _ThinkingBlock({
    required this.thinking,
    this.isStreaming = false,
    this.initiallyExpanded = false,
  });

  @override
  State<_ThinkingBlock> createState() => _ThinkingBlockState();
}

class _ThinkingBlockState extends State<_ThinkingBlock> {
  late bool _expanded = widget.initiallyExpanded || widget.isStreaming;
  bool _manuallyToggled = false;

  @override
  void didUpdateWidget(covariant _ThinkingBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_manuallyToggled) {
      if (widget.isStreaming) {
        _expanded = true;
      } else if (oldWidget.isStreaming && !widget.isStreaming) {
        _expanded = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
        elevation: 0,
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _manuallyToggled = true;
              _expanded = !_expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.isStreaming
                            ? "Aan het nadenken..."
                            : "Gedachtegang",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0.0,
                      duration: Durations.short3,
                      child: Icon(
                        Icons.expand_more,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (_expanded)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 26, right: 8, bottom: 4),
                    child: Text(
                      widget.thinking,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.85),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
              margin: EdgeInsets.zero,
              child: CustomCard(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: textController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
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
        ),
      ],
    );
  }
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
  final AIChatMessage? systemInstruction;

  @override
  State<ChatPromptSheetBody> createState() => _ChatPromptSheetBodyState();
}

class _ChatPromptSheetBodyState extends State<ChatPromptSheetBody> {
  final List<ChatMessage> _messages = [];
  final List<AIChatMessage> _history = [];

  String? loadingState;
  TextEditingController controller = TextEditingController();
  String? summary;
  String? summaryThinking;
  bool isSummaryLoading = false;

  bool _userScrolledUp = false;
  bool _scrollScheduled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    if (widget.settings != null) {
      summary = widget.settings?.initialSummary;
      if (summary == null && widget.settings!.instantSummery) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _performSummary(bronnen: widget.settings!.bronnen);
        });
      }
    }
    _initializeChatModel();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    final pos = widget.controller.position;
    final isAway = (pos.maxScrollExtent - pos.pixels) > 80;
    if (isAway != _userScrolledUp) {
      setState(() {
        _userScrolledUp = isAway;
      });
    }
  }

  void _initializeChatModel() {
    setState(() {
      loadingState = null;
    });
  }

  void _scrollToEnd({bool isStreamChunk = false, bool force = false}) {
    if (!mounted) return;
    // Don't auto-scroll if the user has deliberately scrolled up to read earlier messages
    if (!force && _userScrolledUp) return;

    if (_scrollScheduled) return;
    _scrollScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollScheduled = false;
      if (!mounted || !widget.controller.hasClients) return;

      final pos = widget.controller.position;
      if (!force && (pos.maxScrollExtent - pos.pixels) > 120) {
        return;
      }

      if (isStreamChunk) {
        // Pin to bottom smoothly during active streaming without canceling/restarting animations
        widget.controller.jumpTo(pos.maxScrollExtent);
      } else {
        // Smooth easeOut animation for complete messages
        widget.controller.animateTo(
          pos.maxScrollExtent,
          duration: Durations.short4,
          curve: Easing.standard,
        );
      }
    });
  }

  Future<void> _performSummary({Iterable<Bron> bronnen = const []}) async {
    if (widget.settings == null) return;
    setState(() {
      summary = "";
      summaryThinking = null;
      isSummaryLoading = true;
      loadingState = "Samenvatting maken...";
    });

    try {
      await for (final chunk in summarizeTextStream(
        widget.settings!.text,
        bronnen: bronnen,
      )) {
        if (!mounted) break;
        setState(() {
          if (chunk.status != null) {
            loadingState = chunk.status;
          }
          if (chunk.thinking != null && chunk.thinking!.isNotEmpty) {
            summaryThinking = (summaryThinking ?? "") + chunk.thinking!;
          }
          if (chunk.content != null && chunk.content!.isNotEmpty) {
            summary = (summary ?? "") + chunk.content!;
            if (loadingState != null) loadingState = null;
          }
        });
        _scrollToEnd(isStreamChunk: true);
      }

      if (summary != null && summary!.isNotEmpty) {
        widget.settings?.onSummary?.call(summary!);
      }
    } catch (e) {
      debugPrint("Error summarizing: $e");
      if (mounted) {
        setState(() {
          summary = "Er is een fout opgetreden bij het samenvatten: $e";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isSummaryLoading = false;
          loadingState = null;
        });
        HapticFeedback.heavyImpact();
        _scrollToEnd(force: false);
      }
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _history.add(AIChatMessage.user(text));
      controller.clear();
      loadingState = "Aan het denken...";
      _userScrolledUp = false;
    });

    _scrollToEnd(force: true);

    ChatMessage? currentAssistantMessage;

    try {
      final stream = AIService.sendMessageStream(
        history: _history,
        systemInstruction: widget.systemInstruction ??
            (widget.settings != null
                ? GeminiInstructions.textChatter(widget.settings!.text)
                : GeminiInstructions.generalDiscipulus),
        tools: DiscipulusMcpTools.openAiTools,
      );

      await for (final chunk in stream) {
        if (!mounted) break;

        setState(() {
          if (chunk.status != null) {
            loadingState = chunk.status;
          }

          if (chunk.status != null && chunk.status!.contains("Functie")) {
            currentAssistantMessage?.usedFunction = true;
          }

          // Handle thinking chunks
          if (chunk.thinking != null && chunk.thinking!.isNotEmpty) {
            if (currentAssistantMessage == null) {
              currentAssistantMessage = ChatMessage(
                text: "",
                thinking: chunk.thinking,
                isUser: false,
                isThinkingExpanded: true,
                isStreamingThinking: true,
              );
              _messages.add(currentAssistantMessage!);
            } else {
              currentAssistantMessage!.thinking =
                  (currentAssistantMessage!.thinking ?? "") + chunk.thinking!;
              currentAssistantMessage!.isStreamingThinking = true;
            }

            if (loadingState == "Aan het nadenken..." ||
                loadingState == "Aan het denken...") {
              loadingState = null;
            }
          }

          // Handle content chunks
          if (chunk.content != null && chunk.content!.isNotEmpty) {
            if (currentAssistantMessage == null) {
              currentAssistantMessage = ChatMessage(
                text: chunk.content!,
                isUser: false,
                isThinkingExpanded: false,
              );
              _messages.add(currentAssistantMessage!);
              HapticFeedback.lightImpact();
            } else {
              currentAssistantMessage!.isStreamingThinking = false;
              currentAssistantMessage!.text += chunk.content!;
            }

            if (loadingState != null && !loadingState!.contains("Functie")) {
              loadingState = null;
            }
          }

          if (chunk.isDone) {
            loadingState = null;
            currentAssistantMessage?.isStreamingThinking = false;
          }
        });

        _scrollToEnd(isStreamChunk: true);
      }

      if (currentAssistantMessage != null &&
          currentAssistantMessage!.text.isNotEmpty) {
        _history.add(AIChatMessage.assistant(currentAssistantMessage!.text));
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: "Sorry, er is iets misgegaan: ${e.toString()}",
            isUser: false,
          ));
          loadingState = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          loadingState = null;
          currentAssistantMessage?.isStreamingThinking = false;
        });
        HapticFeedback.heavyImpact();
        _scrollToEnd(force: false);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.thinking != null && message.thinking!.isNotEmpty)
              _ThinkingBlock(
                thinking: message.thinking!,
                isStreaming: message.isStreamingThinking,
                initiallyExpanded: message.isThinkingExpanded,
              ),
            if (message.text.isNotEmpty)
              HTMLDisplay(
                html: message.text,
                convertMarkdown: true,
              ),
          ],
        ),
      );
    }
  }

  Widget systemState([bool show = true]) {
    if (!show || loadingState == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4)
          .copyWith(bottom: 8),
      child: AnimatedSwitcher(
        duration: Durations.short2,
        child: Row(
          key: ValueKey(loadingState),
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              loadingState!,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          ListView(
            controller: widget.controller,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const RowTile(
                        icon: Icons.auto_awesome, title: "AI Assistant"),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              if (widget.settings != null)
                _buildMessage(
                    ChatMessage(text: "Maak een samenvatting", isUser: true)),
              if ((summary == null ||
                      (summary!.isEmpty && !isSummaryLoading)) &&
                  widget.settings != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24 + 4, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed: isSummaryLoading
                          ? null
                          : () => _performSummary(
                              bronnen: widget.settings!.bronnen),
                      child: const Text("Maak samenvatting"),
                    ),
                  ),
                ),
              if (isSummaryLoading &&
                  (summary == null || summary!.isEmpty) &&
                  (summaryThinking == null || summaryThinking!.isEmpty))
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24 + 4, vertical: 8),
                  child: ShimmeringTextPlaceholder(
                    lineCount: 3,
                    highlightColor: Theme.of(context).colorScheme.primary,
                    baseColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              if (summaryThinking != null && summaryThinking!.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: _ThinkingBlock(
                    thinking: summaryThinking!,
                    isStreaming: isSummaryLoading &&
                        (summary == null || summary!.isEmpty),
                    initiallyExpanded: isSummaryLoading,
                  ),
                ),
              if (summary != null && summary!.isNotEmpty) ...[
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
                            "Samenvattingen kunnen fouten bevatten. Controleer altijd de inhoud.",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.settings?.bronnen.isNotEmpty ?? false)
                            IconButton(
                              tooltip: "Samenvatten met bijlagen",
                              onPressed: isSummaryLoading
                                  ? null
                                  : () => _performSummary(
                                      bronnen: widget.settings!.bronnen),
                              icon: isSummaryLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    )
                                  : const Icon(Icons.upload_file),
                            ),
                          if (widget.settings != null)
                            IconButton(
                              tooltip: "Opnieuw samenvatten",
                              onPressed: isSummaryLoading
                                  ? null
                                  : () => _performSummary(
                                      bronnen: widget.settings!.bronnen),
                              icon: isSummaryLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    )
                                  : const Icon(Icons.refresh),
                            ),
                          IconButton(
                            tooltip: "Kopiëren",
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
          if (_userScrolledUp)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.small(
                elevation: 2,
                onPressed: () {
                  setState(() => _userScrolledUp = false);
                  _scrollToEnd(force: true);
                },
                tooltip: "Naar beneden scrollen",
                child: const Icon(Icons.arrow_downward, size: 18),
              ),
            ),
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
