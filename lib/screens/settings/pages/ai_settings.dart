import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/ai/openai.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_ai/flutter_local_ai.dart';
import 'package:url_launcher/url_launcher.dart';

class AiPreset {
  final String name;
  final String baseUrl;
  final String? infoUrl;

  const AiPreset({
    required this.name,
    required this.baseUrl,
    this.infoUrl,
  });
}

const List<AiPreset> aiPresets = [
  AiPreset(
    name: "OpenAI",
    baseUrl: "https://api.openai.com/v1/",
    infoUrl: "https://platform.openai.com/api-keys",
  ),
  AiPreset(
    name: "OpenRouter",
    baseUrl: "https://openrouter.ai/api/v1/",
    infoUrl: "https://openrouter.ai/keys",
  ),
  AiPreset(
    name: "Groq",
    baseUrl: "https://api.groq.com/openai/v1/",
    infoUrl: "https://console.groq.com/keys",
  ),
  AiPreset(
    name: "DeepSeek",
    baseUrl: "https://api.deepseek.com/v1/",
    infoUrl: "https://platform.deepseek.com/api_keys",
  ),
  AiPreset(
    name: "Mistral",
    baseUrl: "https://api.mistral.ai/v1/",
    infoUrl: "https://console.mistral.ai/api-keys/",
  ),
  AiPreset(
    name: "LM Studio (Lokaal)",
    baseUrl: "http://localhost:1234/v1/",
    infoUrl: "https://lmstudio.ai",
  ),
  AiPreset(
    name: "Ollama (Lokaal)",
    baseUrl: "http://localhost:11434/v1/",
    infoUrl: "https://ollama.com",
  ),
];

class AiSettingsPage extends StatefulWidget {
  const AiSettingsPage({super.key});

  @override
  State<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends State<AiSettingsPage> {
  late TextEditingController _baseUrlController;
  late TextEditingController _apiKeyController;
  late TextEditingController _modelController;
  bool _obscureApiKey = true;
  bool? _isTestingConnection;
  bool? _testConnectionSuccess;
  String? _testConnectionMessage;
  bool _localAIAvailable = false;
  bool? _isTestingLocalAi;
  bool? _testLocalAiSuccess;
  String? _testLocalAiMessage;

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController(text: appSettings.aiBaseUrl);
    _baseUrlController.addListener(_onBaseUrlChanged);
    _apiKeyController = TextEditingController(text: appSettings.aiApiKey ?? "");
    _modelController = TextEditingController(text: appSettings.aiModel);

    Future.microtask(() async {
      final isAvailable = await FlutterLocalAi().isAvailable();
      if (mounted) {
        setState(() {
          _localAIAvailable = isAvailable;
        });
      }
    });
  }

  void _onBaseUrlChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _baseUrlController.removeListener(_onBaseUrlChanged);
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  AiPreset? get _currentPreset {
    final text = _baseUrlController.text.trim().nullOnEmpty ??
        appSettings.aiBaseUrl.trim();
    if (text.isEmpty) return null;

    String normalize(String url) {
      var u = url.trim().toLowerCase();
      while (u.endsWith('/')) {
        u = u.substring(0, u.length - 1);
      }
      return u;
    }

    final norm = normalize(text);
    for (final preset in aiPresets) {
      if (normalize(preset.baseUrl) == norm) {
        return preset;
      }
    }

    try {
      final currentUri =
          Uri.tryParse(text.startsWith("http") ? text : "https://$text");
      if (currentUri != null && currentUri.host.isNotEmpty) {
        for (final preset in aiPresets) {
          final presetUri = Uri.tryParse(preset.baseUrl);
          if (presetUri != null &&
              currentUri.host.toLowerCase() == presetUri.host.toLowerCase()) {
            if (presetUri.hasPort && currentUri.hasPort) {
              if (presetUri.port == currentUri.port) return preset;
            } else if (!presetUri.hasPort && !currentUri.hasPort) {
              return preset;
            }
          }
        }
      }
    } catch (_) {}

    return null;
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
      _testConnectionMessage = null;
      _testConnectionSuccess = null;
    });

    final baseUrl = _baseUrlController.text.trim().nullOnEmpty ??
        appSettings.aiBaseUrl.trim();
    final apiKey = _apiKeyController.text.trim().nullOnEmpty ??
        appSettings.aiApiKey?.trim();
    final model =
        _modelController.text.trim().nullOnEmpty ?? appSettings.aiModel.trim();

    try {
      final response = await OpenAIClient.sendMessage(
        baseUrl: baseUrl,
        apiKey: apiKey,
        model: model,
        messages: [
          {"role": "user", "content": "Hallo, reageer kort met 'OK'."}
        ],
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _isTestingConnection = false;
          _testConnectionSuccess = true;
          _testConnectionMessage =
              "Verbinding geslaagd! Model '$model' heeft succesvol geantwoord.";
        });
      } else {
        setState(() {
          _isTestingConnection = false;
          _testConnectionSuccess = false;
          _testConnectionMessage =
              "Server antwoordde met code ${response.statusCode}: ${response.statusMessage ?? 'Onbekend'}";
        });
      }
    } catch (e) {
      if (!mounted) return;
      String error = e.toString();
      if (error.startsWith("Exception: ")) {
        error = error.substring(11);
      }
      setState(() {
        _isTestingConnection = false;
        _testConnectionSuccess = false;
        _testConnectionMessage = error;
      });
    }
  }

  Future<void> _testLocalAi() async {
    setState(() {
      _isTestingLocalAi = true;
      _testLocalAiMessage = null;
      _testLocalAiSuccess = null;
    });

    try {
      await FlutterLocalAi().initialize(instructions: 'You are a test.');
      final response = await FlutterLocalAi().generateText(
        prompt: 'Say hi',
        config: const GenerationConfig(maxTokens: 5),
      );

      if (!mounted) return;
      setState(() {
        _isTestingLocalAi = false;
        _testLocalAiSuccess = true;
        _testLocalAiMessage =
            "Systeem AI werkt! Reactie: \"${response.text.trim()}\"";
      });
    } catch (e) {
      if (!mounted) return;
      String error = e.toString();
      if (error.startsWith("Exception: ")) {
        error = error.substring(11);
      }
      setState(() {
        _isTestingLocalAi = false;
        _testLocalAiSuccess = false;
        _testLocalAiMessage = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("AI Instellingen"),
      ),
      children: [
        // Provider selectie
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: RadioGroup<AIProvider>(
            groupValue: appSettings.aiProvider,
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  appSettings
                    ..aiProvider = val
                    ..hasConfiguredAi = true
                    ..save();
                });
              }
            },
            child: Column(
              children: [
                CustomCard(
                  child: RadioListTile<AIProvider>(
                    value: AIProvider.none,
                    title: const Text("Geen"),
                    subtitle:
                        const Text("Haalt alle AI functionaliteit uit de app"),
                    secondary: const Icon(Icons.block),
                  ),
                ),
                CustomCard(
                  child: RadioListTile<AIProvider>(
                    value: AIProvider.openAI,
                    title: const Text("OpenAI-compatibel endpoint"),
                    subtitle: const Text("Cloud of zelf gehost"),
                    secondary: const Icon(Icons.cloud_outlined),
                  ),
                ),
                CustomCard(
                  child: RadioListTile<AIProvider>(
                    value: AIProvider.systemLocalAI,
                    enabled: _localAIAvailable,
                    title: const Text("Lokaal: Systeem AI (Offline)"),
                    subtitle: const Text(
                        "Gebruikt Apple Intelligence of Android AI Core"),
                    secondary: const Icon(Icons.phone_android_outlined),
                  ),
                ),
              ].toMaterial3List(seperation: 2, overridemargin: EdgeInsets.zero),
            ),
          ),
        ),

        // Configuratie afhankelijk van gekozen provider
        if (appSettings.aiProvider == AIProvider.openAI) ...[
          const ListTitle(child: Text("OpenAI-compatibele Instellingen")),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  // Base URL
                  CustomCard(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.link),
                      title: const Text("Base URL"),
                      subtitle: TextField(
                        controller: _baseUrlController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "https://api.openai.com/v1/",
                        ),
                        onChanged: (value) {
                          appSettings
                            ..aiBaseUrl = value.nullOnEmpty ??
                                "https://api.openai.com/v1/"
                            ..save();
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.restore),
                        tooltip: "Standaard herstellen",
                        onPressed: () {
                          setState(() {
                            _baseUrlController.text =
                                "https://api.openai.com/v1/";
                            appSettings
                              ..aiBaseUrl = "https://api.openai.com/v1/"
                              ..save();
                          });
                        },
                      ),
                    ),
                  ),

                  // API Key
                  CustomCard(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.vpn_key),
                      title: const Text("API Key"),
                      subtitle: TextField(
                        controller: _apiKeyController,
                        obscureText: _obscureApiKey,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Voer je API key in",
                          suffixIcon: IconButton(
                            icon: Icon(_obscureApiKey
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(
                                () => _obscureApiKey = !_obscureApiKey),
                          ),
                        ),
                        onChanged: (value) {
                          appSettings
                            ..aiApiKey = value.nullOnEmpty
                            ..save();
                        },
                      ),
                    ),
                  ),

                  // Model name
                  CustomCard(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.tune),
                      title: const Text("Model"),
                      subtitle: TextField(
                        controller: _modelController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          hintText: "gpt-5.6-luna",
                        ),
                        onChanged: (value) {
                          appSettings
                            ..aiModel = value.nullOnEmpty ?? "gpt-5.6-luna"
                            ..save();
                        },
                      ),
                    ),
                  ),

                  // Status
                  if (_testConnectionMessage != null) ...[
                    CustomCard(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      color: _testConnectionSuccess == true
                          ? Colors.green.withValues(alpha: 0.15)
                          : Colors.red.withValues(alpha: 0.15),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              _testConnectionSuccess == true
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              color: _testConnectionSuccess == true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _testConnectionMessage!,
                                style: TextStyle(
                                  color: _testConnectionSuccess == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ].toMaterial3List(
                    seperation: 2,
                    overridemargin: EdgeInsets.symmetric(horizontal: 12)),
              ),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: _currentPreset?.infoUrl != null ? 4 : 12,
                      ),
                      child: FilledButton.icon(
                        onPressed: _isTestingConnection == true
                            ? null
                            : _testConnection,
                        icon: _isTestingConnection == true
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.network_check),
                        label: const Text(
                          "Verbinding testen",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  if (_currentPreset?.infoUrl != null)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12, left: 4),
                        child: Tooltip(
                          message: "Ga naar ${_currentPreset!.infoUrl}",
                          child: FilledButton.tonalIcon(
                            onPressed: () async {
                              final uri =
                                  Uri.tryParse(_currentPreset!.infoUrl!);
                              if (uri != null) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            icon: const Icon(Icons.vpn_key_outlined, size: 18),
                            label: const Text("Keys"),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Presets
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    SizedBox(width: 8),
                    for (final preset in aiPresets)
                      ActionChip(
                        avatar: const Icon(Icons.bolt, size: 16),
                        label: Text(preset.name),
                        onPressed: () {
                          setState(() {
                            _baseUrlController.text = preset.baseUrl;
                            _testConnectionMessage = null;
                            _testConnectionSuccess = null;
                            appSettings
                              ..aiBaseUrl = preset.baseUrl
                              ..save();
                          });
                        },
                      ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ],

        // Systeem AI instellingen
        if (appSettings.aiProvider == AIProvider.systemLocalAI) ...[
          const ListTitle(child: Text("Systeem AI Status")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: FutureBuilder<bool>(
              future: FlutterLocalAi().isAvailable(),
              builder: (context, snapshot) {
                final isAvailable = snapshot.data ?? false;
                return Column(
                  children: [
                    CustomCard(
                      child: ListTile(
                        leading: Icon(
                          isAvailable
                              ? Icons.check_circle
                              : Icons.cancel_outlined,
                          color: isAvailable ? Colors.green : Colors.orange,
                        ),
                        title: Text(isAvailable
                            ? "Systeem AI is beschikbaar"
                            : "Systeem AI niet beschikbaar"),
                        subtitle: Text(isAvailable
                            ? "Je apparaat ondersteunt lokale tekstgeneratie via het besturingssysteem."
                            : "Dit apparaat of besturingssysteem ondersteunt momenteel geen lokale systeem AI."),
                      ),
                    ),
                    if (isAvailable) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: _isTestingLocalAi == true
                                  ? null
                                  : _testLocalAi,
                              icon: _isTestingLocalAi == true
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Icons.play_arrow_outlined),
                              label: const Text("Systeem AI testen"),
                            ),
                          ),
                        ],
                      ),
                      if (_testLocalAiMessage != null) ...[
                        const SizedBox(height: 8),
                        CustomCard(
                          color: _testLocalAiSuccess == true
                              ? Colors.green.withValues(alpha: 0.15)
                              : Colors.red.withValues(alpha: 0.15),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  _testLocalAiSuccess == true
                                      ? Icons.check_circle_outline
                                      : Icons.error_outline,
                                  color: _testLocalAiSuccess == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _testLocalAiMessage!,
                                    style: TextStyle(
                                      color: _testLocalAiSuccess == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
