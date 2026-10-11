import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';

Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  String hint = "",
  String? prefill,
  String? suffix,
  int? maxLength,
  bool emptyOnEmpty = false,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _TextInputDialog(
      title: title,
      hint: hint,
      prefill: prefill,
      suffix: suffix,
      maxLength: maxLength,
      emptyOnEmpty: emptyOnEmpty,
    ),
  );
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    this.hint = "",
    this.prefill,
    this.suffix,
    this.maxLength,
    this.emptyOnEmpty = false,
  });

  final String title;
  final String hint;
  final String? prefill;
  final String? suffix;
  final int? maxLength;
  final bool emptyOnEmpty;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController(text: widget.prefill);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: CustomCard(
        margin: EdgeInsets.zero,
        elevation: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: TextField(
            maxLength: widget.maxLength,
            controller: _textFieldController,
            onSubmitted: (value) => Navigator.pop(context, value),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              counterText: "",
              hintText: widget.hint,
              suffixText: widget.suffix,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FilledButton.tonal(
          child: const Text("Annuleer"),
          onPressed: () => Navigator.pop(context),
        ),
        ElasticAnimation(
          child: FilledButton(
            key: ValueKey(_textFieldController.text.isEmpty),
            child: Text(_textFieldController.text.isEmpty
                ? widget.emptyOnEmpty
                    ? "Legen"
                    : "Origineel"
                : 'Oke'),
            onPressed: () =>
                Navigator.pop(context, _textFieldController.text),
          ),
        ),
      ],
    );
  }
}

