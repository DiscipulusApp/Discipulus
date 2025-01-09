import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/chat_screen.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class EmailGenerationScreen extends StatefulWidget {
  const EmailGenerationScreen({super.key, this.customSystemInstruction});

  final Content? customSystemInstruction;

  @override
  State<EmailGenerationScreen> createState() => _EmailGenerationScreenState();
}

class _EmailGenerationScreenState extends State<EmailGenerationScreen> {
  final TextEditingController _inputController = TextEditingController();
  late GenerativeModel? _model;
  String _generatedEmail = '';
  bool _isLoading = false;

  Future<void> _generateEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prompt = _inputController.text;
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      setState(() {
        _generatedEmail = response.text ?? 'Failed to generate email.';
      });
    } catch (e) {
      setState(() {
        _generatedEmail = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = appSettings.geminiAPIKey != null
        ? GenerativeModel(
            model: 'gemini-1.5-flash',
            apiKey: appSettings.geminiAPIKey!,
            systemInstruction: widget.customSystemInstruction ??
                GeminiInstructions.emailWriter,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Email'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_generatedEmail.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context, _generatedEmail);
              },
              child: const Text("Invoegen"),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HTMLDisplay(html: _generatedEmail),
              ),
            ),
          ),
          ChatInputField(
            textController: _inputController,
            onSubmitted: (content) => _generateEmail(),
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

Future<String?> showGenerationDialog(BuildContext context, String? currentEmail,
    {Content? customSystemInstruction}) {
  return showDialog<String>(
    useSafeArea: false,
    context: context,
    builder: (context) =>
        EmailGenerationScreen(customSystemInstruction: customSystemInstruction),
  );
}
