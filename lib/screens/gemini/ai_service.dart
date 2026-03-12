import 'dart:convert';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/functions/ai_models.dart';
import 'package:discipulus/screens/gemini/functions/functions.dart';
import 'package:discipulus/screens/gemini/open_router.dart';
import 'package:flutter_local_ai/flutter_local_ai.dart';

class AIService {
  static Future<String> sendMessage({
    required List<AIContent> history,
    required AIContent systemInstruction,
    List<AIFunctionDeclaration>? tools,
  }) async {
    if (appSettings.useLocalAI && await FlutterLocalAi().isAvailable()) {
      return _sendLocalAI(history, systemInstruction);
    } else if (appSettings.openRouterAPIKey != null) {
      return _sendOpenRouter(history, systemInstruction, tools: tools);
    } else {
      throw Exception('Geen AI provider geconfigureerd (Lokale AI uit en geen OpenRouter API key).');
    }
  }

  static Future<String> _sendLocalAI(
    List<AIContent> history,
    AIContent systemInstruction,
  ) async {
    final instructions = systemInstruction.parts
        .whereType<AITextPart>()
        .map((p) => p.text)
        .join('\n');

    await FlutterLocalAi().initialize(instructions: instructions);

    String fullPrompt = "";
    for (var content in history) {
      final role = content.role == "model" ? "Assistant" : "User";
      final text = content.parts.whereType<AITextPart>().map((p) => p.text).join("\n");
      fullPrompt += "$role: $text\n";
    }
    fullPrompt += "Assistant: ";

    final response = await FlutterLocalAi().generateText(
      prompt: fullPrompt,
      config: const GenerationConfig(temperature: 0.2),
    );

    return response.text;
  }

  static Future<String> _sendOpenRouter(
    List<AIContent> history,
    AIContent systemInstruction, {
    List<AIFunctionDeclaration>? tools,
    int depth = 0,
  }) async {
    if (depth > 5) return "Te veel functie aanroepen, stoppen om oneindige loop te voorkomen.";

    final List<Map<String, dynamic>> messages = [
      systemInstruction.toOpenRouterJson(),
      ...history.map((h) => h.toOpenRouterJson()),
    ];

    final response = await OpenRouterClient.sendMessage(
      messages: messages,
      tools: tools?.map((t) => t.toOpenRouterJson()).toList(),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final message = data['choices'][0]['message'];

      if (message['tool_calls'] != null) {
        final toolCalls = message['tool_calls'] as List;

        // Add the assistant's request for tool calls to history
        history.add(AIContent(role: "model", parts: [AITextPart(message['content'] ?? "")])
          ..extra = {"tool_calls": toolCalls});

        for (var toolCall in toolCalls) {
          final function = toolCall['function'];
          final name = function['name'];
          final args = jsonDecode(function['arguments']);

          final result = await handleFunctionCall(AIFunctionCall(name, args));

          // Add the tool result to history
          history.add(AIContent(role: "tool", parts: [AITextPart(result)])
            ..extra = {"tool_call_id": toolCall['id']});
        }

        // Recursively call to get the final response
        return _sendOpenRouter(history, systemInstruction, tools: tools, depth: depth + 1);
      }

      return message['content'] ?? "";
    } else {
      throw Exception('OpenRouter error: ${response.statusMessage}');
    }
  }
}
