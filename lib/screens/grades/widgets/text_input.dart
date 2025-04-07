import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/gemini/email_generation.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/tiles/fleather_toolbar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';

class RichTextInput extends StatefulWidget {
  const RichTextInput({
    super.key,
    required this.controller,
    this.minHeight,
    this.extraLeadingButton = const [],
    this.topWidget,
    this.onEmpty = const [],
    this.placeholderText,
  });

  final FleatherController controller;
  final List<Widget> extraLeadingButton;
  final double? minHeight;
  final Widget? topWidget;
  final List<Widget> onEmpty;
  final String? placeholderText;

  @override
  State<RichTextInput> createState() => _RichTextInputState();
}

class _RichTextInputState extends State<RichTextInput> {
  late bool isEmpty = widget.onEmpty.isNotEmpty &&
      widget.controller.document.toPlainText().isEmptyHTML;

  /// Checks if textarea is empty or not.
  void checkIfEmpty() {
    if (widget.controller.document.toPlainText().isEmptyHTML != isEmpty) {
      setState(() {
        isEmpty = !isEmpty;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(checkIfEmpty);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(checkIfEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.topWidget != null) ...[
                widget.topWidget!,
              ],
              CustomToolBar(
                controller: widget.controller,
                leading: [
                  ...widget.extraLeadingButton,
                  // if (appSettings.geminiAPIKey != null)
                  //   IconButton(
                  //     onPressed: () async {
                  //       String? email = await showGenerationDialog(context, "");
                  //       if (email?.nullOnEmpty != null) {
                  //         widget.controller.document.insert(
                  //             0,
                  //             parchmentHtml
                  //                 .decode(
                  //                   email!
                  //                       .replaceAll("```hmtl\n", "")
                  //                       .replaceAll("\n```", ""),
                  //                 )
                  //                 .toPlainText());
                  //         checkIfEmpty();
                  //         setState(() {});
                  //       }
                  //     },
                  //     icon: const Icon(Icons.auto_awesome),
                  //   )
                ],
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.minHeight ?? 0),
          child: Stack(
            children: [
              if (isEmpty && widget.placeholderText != null)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.placeholderText!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                ),
              FleatherTheme(
                key: ValueKey("writerBlock"),
                data: customFleatherTheme(context),
                child: FleatherEditor(
                  spellCheckConfiguration: SpellCheckConfiguration(
                      spellCheckService: DefaultSpellCheckService()),
                  controller: widget.controller,
                  scrollable: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(bottom: 8),
                ),
              ),
              if (isEmpty)
                Positioned.fill(
                  child: Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: widget.onEmpty,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
