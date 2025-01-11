import 'package:discipulus/models/settings.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatMessage {
  final String text;
  final bool
      isUser; // True if the message is from the user, false for the chatbot

  ChatMessage({required this.text, required this.isUser});
}

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key, this.systemInstruction});

  final Content? systemInstruction;

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
        text:
            "Ik ben je AI-therapeut. Ik heb toegang tot je cijfers van de vak. Ik help je je gevoelens te verwerken en positief vooruit te kijken. Wat kan ik voor je doen?",
        isUser: false)
  ];
  final TextEditingController _textController = TextEditingController();
  late GenerativeModel? _model;
  late ChatSession _chat;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = appSettings.geminiAPIKey != null
        ? GenerativeModel(
            model: 'gemini-1.5-flash',
            apiKey: appSettings.geminiAPIKey!,
            systemInstruction: widget.systemInstruction,
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

    if (_model != null) {
      _chat = _model!.startChat();
    }
  }

  Future<void> _sendMessage(String text) async {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _textController.clear();
      _isLoading = true;
    });

    String accumulatedText = "";
    try {
      final responseStream = _chat.sendMessageStream(Content.text(text));
      await for (final response in responseStream) {
        final chunk = response.text;
        if (chunk != null) {
          setState(() {
            accumulatedText += chunk;
            if (_messages.isNotEmpty && !_messages.last.isUser) {
              _messages[_messages.length - 1] =
                  ChatMessage(text: accumulatedText, isUser: false);
            } else {
              _messages.add(ChatMessage(text: chunk, isUser: false));
            }
          });
        }
      }
    } catch (e) {
      setState(() {
        _messages
            .add(ChatMessage(text: "Error: ${e.toString()}", isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editMessage(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final message = _messages[index];
        final controller = TextEditingController(text: message.text);
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _messages[index] = ChatMessage(
                    text: controller.text,
                    isUser: message.isUser,
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _removeMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praat met Gemini'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return GestureDetector(
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _editMessage(index);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Remove'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _removeMessage(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: HTMLDisplay(html: message.text),
                    ),
                  ),
                );
              },
            ),
          ),
          ChatInputField(
            textController: _textController,
            onSubmitted: _sendMessage,
            isLoading: _isLoading,
          )
        ],
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
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
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
                    icon: const Icon(Icons.send),
                    onPressed: () => onSubmitted(textController.text),
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
