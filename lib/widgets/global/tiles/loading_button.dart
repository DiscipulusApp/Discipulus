import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    super.key,
    required this.child,
    required this.future,
  });

  final Widget Function(bool isLoading, void Function() onTap) child;
  final Future Function()? future;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return widget.child(
      isLoading,
      () async {
        // On tapped
        setState(() {
          isLoading = true;
          HapticFeedback.lightImpact();
        });
        try {
          if (widget.future != null) await widget.future!();
        } catch (e) {
          if (mounted) {
            setState(() {
              isLoading = false;
              HapticFeedback.heavyImpact();
            });
          }
          rethrow;
        }
        if (mounted) {
          setState(() {
            isLoading = false;
            HapticFeedback.heavyImpact();
          });
        }
      },
    );
  }
}
