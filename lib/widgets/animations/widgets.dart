import 'dart:math';

import 'package:flutter/material.dart';

class CustomAnimatedSize extends StatelessWidget {
  const CustomAnimatedSize({
    super.key,
    required this.child,
    this.duration = Durations.medium2,
    this.curve = Easing.standard,
    this.alignment = Alignment.topCenter,
    this.visible = true,
  });

  final Duration duration;
  final Curve curve;
  final Widget child;
  final Alignment alignment;

  final bool visible;

  /// Default aniamtion for Discipulus
  static AnimationStyle style({Duration? duration}) => AnimationStyle(
        curve: Easing.standard,
        duration: duration ?? Durations.medium1,
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: alignment,
      curve: curve,
      duration: duration,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: visible ? double.infinity : 0,
        ),
        child: visible ? child : const SizedBox.shrink(),
      ),
    );
  }
}

class AppearAnimation extends StatefulWidget {
  const AppearAnimation({
    super.key,
    required this.child,
    this.curve = Easing.linear,
    this.duration = Durations.short3,
    this.delay = Duration.zero,
  });

  final Widget Function(Animation<double> animation) child;
  final Curve curve;
  final Duration duration;
  final Duration delay;

  @override
  State<AppearAnimation> createState() => _AppearAnimationState();
}

class _AppearAnimationState extends State<AppearAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;

  @override
  void initState() {
    animation = AnimationController(vsync: this, value: 0);
    super.initState();
    animation
      ..drive(CurveTween(curve: widget.curve))
      ..duration = widget.duration
      ..animateTo(0);
    Future.delayed(widget.delay, () {
      if (mounted) animation.forward();
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child.call(animation);
  }
}

class CoinflipTransition extends StatefulWidget {
  const CoinflipTransition({
    super.key,
    required this.front,
    required this.back,
    this.duration = Durations.long3,
    this.curve = Easing.emphasizedDecelerate,
    this.reverseCurve = Easing.emphasizedAccelerate,
    this.turned = false,
    this.childBuilder,
  });

  final Widget front;
  final Widget back;
  final bool turned;

  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;

  /// Can be used as a boilerplate to both sides.
  final Widget Function(Widget sideChild)? childBuilder;

  @override
  State<CoinflipTransition> createState() => _CoinflipTransitionState();
}

class _CoinflipTransitionState extends State<CoinflipTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
    );

    if (widget.turned) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CoinflipTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.turned != oldWidget.turned) {
      if (widget.turned) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calculate the rotation angle
        final angle = _animation.value * pi;

        // Determine the widget to display based on rotation angle
        final isFrontVisible = angle < pi / 2;
        final childToShow = isFrontVisible
            ? (widget.childBuilder?.call(widget.front) ?? widget.front)
            : Transform(
                transform: Matrix4.rotationY(pi),
                alignment: Alignment.center,
                child: widget.childBuilder?.call(widget.back) ?? widget.back,
              );

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: childToShow,
        );
      },
    );
  }
}
