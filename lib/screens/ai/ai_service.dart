import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:discipulus/mcp/mcp_tools.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/ai/ai_models.dart';
import 'package:discipulus/screens/ai/openai.dart';
import 'package:flutter_local_ai/flutter_local_ai.dart';


//
// As I only have a surface level understanding if openAI type api's
// and I do not have any previous experience with streaming content, 
// much of this file was written with a lot of help from, ironically, 
// LLMs. Please keep that in mind as you read the code. I did review it, 
// but I have noticed that it does not always do what I think is right,
// and it could be that in my rather lacking knowledge in this area it 
// has done things that can be done in better ways. If so, please make a 
// PR. Yours, Harry
//

class AIStreamChunk {
  final String? content;
  final String? thinking;
  final String? status;
  final bool isThinking;
  final bool isDone;

  const AIStreamChunk({
    this.content,
    this.thinking,
    this.status,
    this.isThinking = false,
    this.isDone = false,
  });
}

class AIService {
  static Future<String> sendMessage({
    required List<AIChatMessage> history,
    required AIChatMessage systemInstruction,
    List<Map<String, dynamic>>? tools,
  }) async {
    final buffer = StringBuffer();
    await for (final chunk in sendMessageStream(
      history: history,
      systemInstruction: systemInstruction,
      tools: tools,
    )) {
      if (chunk.content != null) {
        buffer.write(chunk.content);
      }
    }
    return buffer.toString();
  }

  static Stream<AIStreamChunk> sendMessageStream({
    required List<AIChatMessage> history,
    required AIChatMessage systemInstruction,
    List<Map<String, dynamic>>? tools,
  }) async* {
    switch (appSettings.aiProvider) {
      case AIProvider.none:
        throw Exception('AI is uitgeschakeld in de instellingen.');
      case AIProvider.systemLocalAI:
        if (await FlutterLocalAi().isAvailable()) {
          final result = await _sendLocalAI(history, systemInstruction);
          yield AIStreamChunk(content: result, isDone: true);
          return;
        }
        throw Exception('Systeem AI is niet beschikbaar op dit apparaat.');
      case AIProvider.openAI:
        if (appSettings.isAiConfigured) {
          yield* _sendOpenAIStream(history, systemInstruction, tools: tools);
          return;
        }
        throw Exception(
            'Geen AI provider geconfigureerd. Configureer een OpenAI-compatibel endpoint in de AI-instellingen.');
    }
  }

  /// Checks if a local AI model is available on this device and automatically enables it
  /// when first starting the app if the user hasn't explicitly configured a provider.
  /// A quick generation test is performed to confirm that local models (and language-specific
  /// safety filters) are actually operational.
  static Future<void> checkAndEnableLocalAi() async {
    if (!appSettings.hasConfiguredAi && appSettings.aiProvider == AIProvider.none) {
      try {
        final available = await FlutterLocalAi()
            .isAvailable()
            .timeout(const Duration(seconds: 2), onTimeout: () => false);
        if (available) {
          await FlutterLocalAi().initialize(instructions: 'Test');
          final test = await FlutterLocalAi()
              .generateText(
                prompt: 'Hi',
                config: const GenerationConfig(maxTokens: 5),
              )
              .timeout(const Duration(seconds: 3));
          if (test.text.isNotEmpty) {
            appSettings
              ..aiProvider = AIProvider.systemLocalAI
              ..hasConfiguredAi = true
              ..save();
          }
        }
      } catch (_) {
        // Local AI is present in OS but cannot generate.
        // Do not auto-enable it so the user is not stuck with error messages.
      }
    }
  }

  static Future<String> _sendLocalAI(
    List<AIChatMessage> history,
    AIChatMessage systemInstruction,
  ) async {
    await FlutterLocalAi().initialize(instructions: systemInstruction.content ?? '');

    String fullPrompt = "";
    for (AIChatMessage message in history) {
      final String role = (message.role == "assistant" || message.role == "model")
          ? "Assistant"
          : "User";
      fullPrompt += "$role: ${message.content ?? ''}\n";
    }
    fullPrompt += "Assistant: ";

    final response = await FlutterLocalAi().generateText(
      prompt: fullPrompt,
      config: const GenerationConfig(temperature: 0.2),
    );

    return response.text;
  }

  static Stream<AIStreamChunk> _sendOpenAIStream(
    List<AIChatMessage> history,
    AIChatMessage systemInstruction, {
    List<Map<String, dynamic>>? tools,
    int depth = 0,
  }) async* {
    if (depth > 5) {
      yield const AIStreamChunk(
        content:
            "Te veel functie aanroepen, stoppen om oneindige loop te voorkomen.",
        isDone: true,
      );
      return;
    }

    final List<Map<String, dynamic>> messages = [
      systemInstruction.toJson(),
      ...history.map((h) => h.toJson()),
    ];

    yield const AIStreamChunk(status: "Verbinden...", isThinking: true);

    final response = await OpenAIClient.sendMessage(
      messages: messages,
      tools: tools,
      stream: true,
    );

    if (response.statusCode != 200) {
      throw Exception('AI fout: ${response.statusMessage}');
    }

    final responseBody = response.data as ResponseBody;
    final stream = responseBody.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    final Map<int, Map<String, dynamic>> toolCallsMap = {};
    final StringBuffer fullContent = StringBuffer();
    final StringBuffer fullThinking = StringBuffer();
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

      // 1. Check for reasoning_content or reasoning
      final reasoning = delta['reasoning_content'] ?? delta['reasoning'];
      if (reasoning != null && reasoning is String && reasoning.isNotEmpty) {
        if (!hasYieldedThinkingStatus) {
          hasYieldedThinkingStatus = true;
          yield const AIStreamChunk(
              status: "Aan het nadenken...", isThinking: true);
        }
        fullThinking.write(reasoning);
        yield AIStreamChunk(
          thinking: reasoning,
          isThinking: true,
        );
      }

      // 2. Check for content
      final content = delta['content'];
      if (content != null && content is String && content.isNotEmpty) {
        String remaining = content;

        while (remaining.isNotEmpty) {
          if (!inThinkTag) {
            if (remaining.contains("<think>")) {
              final parts = remaining.split("<think>");
              if (parts[0].isNotEmpty) {
                fullContent.write(parts[0]);
                yield AIStreamChunk(content: parts[0], isThinking: false);
              }
              inThinkTag = true;
              hasYieldedThinkingStatus = true;
              yield const AIStreamChunk(
                  status: "Aan het nadenken...", isThinking: true);
              remaining = parts.sublist(1).join("<think>");
            } else {
              fullContent.write(remaining);
              yield AIStreamChunk(content: remaining, isThinking: false);
              remaining = "";
            }
          } else {
            if (remaining.contains("</think>")) {
              final parts = remaining.split("</think>");
              if (parts[0].isNotEmpty) {
                fullThinking.write(parts[0]);
                yield AIStreamChunk(thinking: parts[0], isThinking: true);
              }
              inThinkTag = false;
              remaining = parts.sublist(1).join("</think>");
            } else {
              fullThinking.write(remaining);
              yield AIStreamChunk(thinking: remaining, isThinking: true);
              remaining = "";
            }
          }
        }
      }

      // 3. Check for tool_calls chunks
      if (delta['tool_calls'] != null) {
        final toolCallsList = delta['tool_calls'] as List;
        for (final tc in toolCallsList) {
          final index = tc['index'] as int? ?? 0;
          final existing = toolCallsMap.putIfAbsent(index, () => {
                'id': '',
                'type': 'function',
                'function': {'name': '', 'arguments': ''},
              });

          if (tc['id'] != null && (tc['id'] as String).isNotEmpty) {
            existing['id'] = tc['id'];
          }
          if (tc['function'] != null) {
            final func = tc['function'] as Map<String, dynamic>;
            if (func['name'] != null && (func['name'] as String).isNotEmpty) {
              existing['function']['name'] =
                  "${existing['function']['name']}${func['name']}";
            }
            if (func['arguments'] != null &&
                (func['arguments'] as String).isNotEmpty) {
              existing['function']['arguments'] =
                  "${existing['function']['arguments']}${func['arguments']}";
            }
          }
        }
      }
    }

    // If there were tool calls, execute them and recurse
    if (toolCallsMap.isNotEmpty) {
      final List<Map<String, dynamic>> completedToolCalls =
          toolCallsMap.values.toList();

      history.add(
        AIChatMessage.assistant(
          fullContent.toString(),
          toolCalls: completedToolCalls,
        ),
      );

      for (var toolCall in completedToolCalls) {
        final function = toolCall['function'];
        final name = function['name'] as String;
        final argsStr = function['arguments'] as String;
        dynamic args = {};
        try {
          args = jsonDecode(argsStr);
        } catch (_) {}

        yield AIStreamChunk(
          status: "Functie uitvoeren ($name)...",
          isThinking: true,
        );

        final result = await DiscipulusMcpTools.execute(
          name,
          args is Map<String, dynamic> ? args : {},
        );

        history.add(
          AIChatMessage.tool(
            result,
            toolCallId: toolCall['id'] as String,
          ),
        );
      }

      yield* _sendOpenAIStream(history, systemInstruction,
          tools: tools, depth: depth + 1);
      return;
    }

    yield const AIStreamChunk(isDone: true);
  }
}
