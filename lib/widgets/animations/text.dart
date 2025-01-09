import 'package:flutter/material.dart';

class ElasticAnimation extends StatelessWidget {
  const ElasticAnimation({
    super.key,
    required this.child,
    this.isEnabled = true,
    this.alignment = AlignmentDirectional.topStart,
  });

  final Widget child;
  final bool isEnabled;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return isEnabled
        ? AnimatedSwitcher(
            duration: Durations.long1,
            switchInCurve: Curves.elasticOut,
            reverseDuration: const Duration(milliseconds: 10),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.0, .2),
                end: const Offset(0.0, 0.0),
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: alignment,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            child: child,
          )
        : child;
  }
}

class RotateAnimation extends StatelessWidget {
  const RotateAnimation({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        reverseDuration: const Duration(milliseconds: 10),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation,
            child: child,
          );
        },
        child: child);
  }
}
