import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard navigation wrapper
///
/// - Arrows: Navigate between days/weeks
/// - Shift + Arrows: Navigate between weeks/months
/// - T: Jump to today
/// - V: Switch between calendar views
// I really want to make a proper popup with the shortcuts, as this is just shit.
class CalendarKeyboardNavigation extends StatelessWidget {
  const CalendarKeyboardNavigation({
    super.key,
    required this.child,
    this.onPrevious,
    this.onNext,
    this.onToday,
    this.onSwitchView,
  });

  final Widget child;
  final Function(int days)? onPrevious;
  final Function(int days)? onNext;
  final VoidCallback? onToday;
  final VoidCallback? onSwitchView;

  bool _isEditingText() {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null) return false;
    final widget = focus.context?.widget;
    if (widget is EditableText) return true;
    return focus.context?.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  void _handle(Function? action) {
    if (_isEditingText()) return;
    action?.call();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            _handle(() => onPrevious?.call(1)),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            _handle(() => onNext?.call(1)),
        const SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true): () =>
            _handle(() => onPrevious?.call(7)),
        const SingleActivator(LogicalKeyboardKey.arrowRight, shift: true): () =>
            _handle(() => onNext?.call(7)),
        const SingleActivator(LogicalKeyboardKey.keyT): () =>
            _handle(onToday),
        const SingleActivator(LogicalKeyboardKey.keyV): () =>
            _handle(onSwitchView),
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}

