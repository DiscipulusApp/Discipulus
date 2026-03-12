import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/ai_service.dart';
import 'package:discipulus/screens/gemini/chat_screen.dart';
import 'package:discipulus/screens/gemini/functions/ai_models.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:flutter/material.dart';

class EmailGenerationScreen extends StatefulWidget {
  const EmailGenerationScreen({super.key, this.customSystemInstruction});

  final AIContent? customSystemInstruction;

  @override
  State<EmailGenerationScreen> createState() => _EmailGenerationScreenState();
}

class _EmailGenerationScreenState extends State<EmailGenerationScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _generatedEmail = '';
  bool _isLoading = false;

  Future<void> _generateEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prompt = _inputController.text;
      final response = await AIService.sendMessage(
        history: [AIContent.user(prompt)],
        systemInstruction: widget.customSystemInstruction ?? GeminiInstructions.emailWriter,
      );
      setState(() {
        _generatedEmail = response;
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
    {AIContent? customSystemInstruction}) {
  return showDialog<String>(
    useSafeArea: false,
    context: context,
    builder: (context) =>
        EmailGenerationScreen(customSystemInstruction: customSystemInstruction),
  );
}

Future<String> generateEmailSubject(String htmlBody) async {
  if (htmlBody.withoutHTML?.isEmpty ?? true) return "";

  try {
    return await AIService.sendMessage(
      history: [AIContent.user(htmlBody)],
      systemInstruction: GeminiInstructions.emailSubjectWriter(htmlBody),
    );
  } catch (e) {
    return 'Error: $e';
  }
}
