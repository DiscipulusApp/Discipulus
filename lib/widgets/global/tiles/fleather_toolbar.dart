import 'package:discipulus/widgets/global/card.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

class CustomToolBar extends StatelessWidget {
  const CustomToolBar(
      {super.key, required this.controller, this.leading = const []});

  final FleatherController controller;
  final List<Widget> leading;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(indent: 12, endIndent: 12)),
      child: SizedBox(
        height: 48,
        child: IconTheme(
          data: IconTheme.of(context).copyWith(size: 18),
          child: FleatherToolbar(children: [
            if (leading.isNotEmpty) ...[
              ...leading,
              const VerticalDivider(),
            ],
            CustomUndoRedoButton.undo(
              controller: controller,
            ),
            CustomUndoRedoButton.redo(
              controller: controller,
            ),
            const VerticalDivider(),
            ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: SelectHeadingButton(controller: controller)),
            const VerticalDivider(),
            ToggleStyleButton(
              attribute: ParchmentAttribute.bold,
              icon: Icons.format_bold,
              controller: controller,
              childBuilder: buildButton,
            ),
            ToggleStyleButton(
              attribute: ParchmentAttribute.italic,
              icon: Icons.format_italic,
              controller: controller,
              childBuilder: buildButton,
            ),
            ToggleStyleButton(
              attribute: ParchmentAttribute.underline,
              icon: Icons.format_underline,
              controller: controller,
              childBuilder: buildButton,
            ),
            const VerticalDivider(),
            ToggleStyleButton(
              attribute: ParchmentAttribute.left,
              icon: Icons.format_align_left,
              controller: controller,
              childBuilder: buildButton,
            ),
            ToggleStyleButton(
              attribute: ParchmentAttribute.center,
              icon: Icons.format_align_center,
              controller: controller,
              childBuilder: buildButton,
            ),
            ToggleStyleButton(
              attribute: ParchmentAttribute.right,
              icon: Icons.format_align_right,
              controller: controller,
              childBuilder: buildButton,
            ),
            const VerticalDivider(),
            ToggleStyleButton(
              attribute: ParchmentAttribute.block.numberList,
              controller: controller,
              icon: Icons.format_list_numbered,
              childBuilder: buildButton,
            ),
            ToggleStyleButton(
              attribute: ParchmentAttribute.block.bulletList,
              controller: controller,
              icon: Icons.format_list_bulleted,
              childBuilder: buildButton,
            ),
            CustomIndentationButton(
              controller: controller,
            ),
            CustomIndentationButton(
              increase: false,
              controller: controller,
            ),
            const VerticalDivider(),
            CustomLinkStyleButton(controller: controller),
          ]),
        ),
      ),
    );
  }
}

Widget buildButton(BuildContext context, ParchmentAttribute<dynamic>? attr,
    IconData icon, bool isToggled, void Function()? onPressed) {
  return CustomCard(
    margin: const EdgeInsets.symmetric(horizontal: 2),
    elevation: isToggled ? 0 : 1,
    child: InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    ),
  );
}

class CustomUndoRedoButton extends UndoRedoButton {
  const CustomUndoRedoButton.undo(
      {super.key, required super.controller, this.isUndo = true})
      : super.undo();
  const CustomUndoRedoButton.redo(
      {super.key, required super.controller, this.isUndo = false})
      : super.redo();

  final bool isUndo;

  bool _isEnabled() {
    if (isUndo) {
      return controller.canUndo;
    } else {
      return controller.canRedo;
    }
  }

  void _onPressed() {
    if (isUndo) {
      controller.undo();
    } else {
      controller.redo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return buildButton(context, null, isUndo ? Icons.undo : Icons.redo,
              _isEnabled(), _isEnabled() ? _onPressed : null);
        });
  }
}

class CustomIndentationButton extends IndentationButton {
  const CustomIndentationButton(
      {super.key, required super.controller, super.increase});

  @override
  State<IndentationButton> createState() => _IndentationButtonState();
}

class _IndentationButtonState extends State<IndentationButton> {
  ParchmentStyle get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void didUpdateWidget(covariant IndentationButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled =
        !_selectionStyle.containsSame(ParchmentAttribute.block.code);
    return buildButton(
        context,
        null,
        widget.increase
            ? Icons.format_indent_increase
            : Icons.format_indent_decrease,
        false,
        isEnabled
            ? () {
                final indentLevel =
                    _selectionStyle.get(ParchmentAttribute.indent)?.value ?? 0;
                if (indentLevel == 0 && !widget.increase) {
                  return;
                }
                if (indentLevel == 1 && !widget.increase) {
                  widget.controller
                      .formatSelection(ParchmentAttribute.indent.unset);
                } else {
                  widget.controller.formatSelection(ParchmentAttribute.indent
                      .withLevel(indentLevel + (widget.increase ? 1 : -1)));
                }
              }
            : null);
  }
}

class CustomLinkStyleButton extends LinkStyleButton {
  const CustomLinkStyleButton({super.key, required super.controller});

  @override
  State<LinkStyleButton> createState() => _LinkStyleButtonState();
}

class _LinkStyleButtonState extends State<LinkStyleButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant LinkStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeSelection);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.controller.selection.isCollapsed;
    final pressedHandler = isEnabled ? () => _openLinkDialog(context) : null;

    return buildButton(
        context, null, widget.icon ?? Icons.link, isEnabled, pressedHandler);
  }

  void _openLinkDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return const _LinkDialog();
      },
    ).then(_linkSubmitted);
  }

  void _linkSubmitted(String? value) {
    if (value == null || value.isEmpty) return;
    widget.controller
        .formatSelection(ParchmentAttribute.link.fromString(value));
  }
}

class _LinkDialog extends StatefulWidget {
  const _LinkDialog();

  @override
  _LinkDialogState createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  String _link = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Plak een link"),
      content: TextField(
        decoration: const InputDecoration(hintText: 'https://harrydekat.dev'),
        autofocus: true,
        onChanged: _linkChanged,
      ),
      actions: [
        FilledButton(
          onPressed: _link.isNotEmpty ? _applyLink : null,
          child: const Text('Toevoegen'),
        ),
      ],
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link);
  }
}
