import 'dart:convert';

class AIContent {
  final String role;
  final List<AIPart> parts;

  AIContent({required this.role, required this.parts});

  static AIContent system(String text) =>
      AIContent(role: "system", parts: [AITextPart(text)]);

  static AIContent user(String text) =>
      AIContent(role: "user", parts: [AITextPart(text)]);

  static AIContent model(String text) =>
      AIContent(role: "model", parts: [AITextPart(text)]);

  Map<String, dynamic> toJson() => {
        "role": role == "model" ? "assistant" : role,
        "content": parts.map((p) => p.toJson()).toList(),
      };
}

abstract class AIPart {
  Map<String, dynamic> toJson();
}

class AITextPart extends AIPart {
  final String text;

  AITextPart(this.text);

  @override
  Map<String, dynamic> toJson() => {"type": "text", "text": text};
}

class AIDataPart extends AIPart {
  final String mimeType;
  final List<int> data;

  AIDataPart(this.mimeType, this.data);

  @override
  Map<String, dynamic> toJson() => {
        "type": "image_url",
        "image_url": {
          "url": "data:$mimeType;base64,${base64Encode(data)}",
        }
      };
}

class AIFunctionCall {
  final String name;
  final Map<String, dynamic> args;

  AIFunctionCall(this.name, this.args);
}

class AIFunctionResponse {
  final String name;
  final Map<String, dynamic> response;

  AIFunctionResponse(this.name, this.response);
}

class AIFunctionDeclaration {
  final String name;
  final String description;
  final AISchema parameters;

  AIFunctionDeclaration(this.name, this.description, this.parameters);

  Map<String, dynamic> toOpenRouterJson() => {
        "type": "function",
        "function": {
          "name": name,
          "description": description,
          "parameters": parameters.toJson(),
        }
      };
}

class AISchema {
  final String type;
  final String? description;
  final Map<String, AISchema>? properties;
  final List<String>? requiredProperties;
  final List<String>? enumValues;
  final AISchema? items;
  final bool? nullable;

  AISchema({
    required this.type,
    this.description,
    this.properties,
    this.requiredProperties,
    this.enumValues,
    this.items,
    this.nullable,
  });

  static AISchema object({
    Map<String, AISchema>? properties,
    List<String>? requiredProperties,
    String? description,
    bool? nullable,
  }) =>
      AISchema(
        type: "object",
        properties: properties,
        requiredProperties: requiredProperties,
        description: description,
        nullable: nullable,
      );

  static AISchema string({String? description, bool? nullable}) =>
      AISchema(type: "string", description: description, nullable: nullable);

  static AISchema integer({String? description, bool? nullable}) =>
      AISchema(type: "integer", description: description, nullable: nullable);

  static AISchema boolean({String? description, bool? nullable}) =>
      AISchema(type: "boolean", description: description, nullable: nullable);

  static AISchema number({String? description, bool? nullable}) =>
      AISchema(type: "number", description: description, nullable: nullable);

  static AISchema array({required AISchema items, String? description, bool? nullable}) =>
      AISchema(type: "array", items: items, description: description, nullable: nullable);

  static AISchema enumString({
    required List<String> enumValues,
    String? description,
    bool? nullable,
  }) =>
      AISchema(
        type: "string",
        enumValues: enumValues,
        description: description,
        nullable: nullable,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        if (description != null) "description": description,
        if (properties != null)
          "properties": properties!.map((k, v) => MapEntry(k, v.toJson())),
        if (requiredProperties != null) "required": requiredProperties,
        if (enumValues != null) "enum": enumValues,
        if (items != null) "items": items!.toJson(),
        if (nullable != null) "nullable": nullable,
      };
}

extension AIContentExtension on AIContent {
  static final _extras = Expando<Map<String, dynamic>>();
  Map<String, dynamic>? get extra => _extras[this];
  set extra(Map<String, dynamic>? value) => _extras[this] = value;

  Map<String, dynamic> toOpenRouterJson() {
    final base = {
      "role": role == "model" ? "assistant" : (role == "tool" ? "tool" : role),
      "content": parts.whereType<AITextPart>().map((p) => p.text).join("\n"),
    };
    if (extra != null) {
      if (extra!.containsKey("tool_calls")) {
        base["tool_calls"] = extra!["tool_calls"];
      }
      if (extra!.containsKey("tool_call_id")) {
        base["tool_call_id"] = extra!["tool_call_id"];
      }
    }
    return base;
  }
}
