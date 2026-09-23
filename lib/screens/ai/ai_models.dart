/// Represents a message in an AI chat conversation (compatible with OpenAI and OpenRouter).
class AIChatMessage {
  final String role; // "system", "user", "assistant", or "tool"
  final String? content;
  final List<Map<String, dynamic>>? toolCalls;
  final String? toolCallId;

  const AIChatMessage({
    required this.role,
    this.content,
    this.toolCalls,
    this.toolCallId,
  });

  factory AIChatMessage.system(String text) =>
      AIChatMessage(role: "system", content: text);

  factory AIChatMessage.user(String text) =>
      AIChatMessage(role: "user", content: text);

  factory AIChatMessage.assistant(String text,
          {List<Map<String, dynamic>>? toolCalls}) =>
      AIChatMessage(role: "assistant", content: text, toolCalls: toolCalls);

  factory AIChatMessage.tool(String content, {required String toolCallId}) =>
      AIChatMessage(role: "tool", content: content, toolCallId: toolCallId);

  Map<String, dynamic> toJson() => {
        "role": role,
        if (content != null) "content": content,
        if (toolCalls != null && toolCalls!.isNotEmpty) "tool_calls": toolCalls,
        if (toolCallId != null) "tool_call_id": toolCallId,
      };
}
