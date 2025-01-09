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
}) async {
  final textFieldController = TextEditingController(text: prefill);
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: CustomCard(
              margin: EdgeInsets.zero,
              elevation: 0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: TextField(
                  maxLength: maxLength,
                  controller: textFieldController,
                  onSubmitted: (value) => Navigator.pop(context, value),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: hint,
                    suffixText: suffix,
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
                  key: ValueKey(textFieldController.text.isEmpty),
                  child: Text(textFieldController.text.isEmpty
                      ? emptyOnEmpty
                          ? "Legen"
                          : "Origineel"
                      : 'Oke'),
                  onPressed: () =>
                      Navigator.pop(context, textFieldController.text),
                ),
              ),
            ],
          );
        },
      );
    },
  )..then((_) {
      textFieldController.dispose();
    });
}
