import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// We are using Chromium's cubic bezier curve for smooth scrolling, 
/// as it is the most widely used and tested curve for this purpose.
abstract final class _ScrollPhysics {
  static const Curve chromiumBezier = Cubic(0.25, 0.1, 0.25, 1.0);

  static Duration calculateDuration(double delta) {
    final ms = (math.sqrt(delta.abs()) * 16.0 + 120.0).clamp(160.0, 340.0);
    return Duration(milliseconds: ms.round());
  }
}

/// Global scroll behavior that applies smooth scrolling,
/// drag support for all pointer devices, and desktop-optimized physics across
/// every scroll view in the entire app.
class GlobalScrollBehavior extends MaterialScrollBehavior {
  final bool? _scrollbars;
  final ScrollPhysics? _physics;

  const GlobalScrollBehavior({
    bool? scrollbars,
    ScrollPhysics? physics,
  })  : _scrollbars = scrollbars,
        _physics = physics;

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return _physics ??
        const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        );
  }

  @override
  GlobalScrollBehavior copyWith({
    bool? scrollbars,
    bool? overscroll,
    Set<PointerDeviceKind>? dragDevices,
    MultitouchDragStrategy? multitouchDragStrategy,
    Set<LogicalKeyboardKey>? pointerAxisModifiers,
    ScrollPhysics? physics,
    TargetPlatform? platform,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
  }) {
    return GlobalScrollBehavior(
      scrollbars: scrollbars ?? _scrollbars,
      physics: physics ?? _physics,
    );
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    Widget result = child;

    // Apply smooth mouse wheel scrolling on desktop platforms except for macOS, 
    // as they do know what they are doing it seems.
    if (kIsWeb || Platform.isLinux || Platform.isWindows) {
      result = _GlobalSmoothScrollWrapper(
        details: details,
        child: result,
      );

      if (_scrollbars ?? true) {
        result = RawScrollbar(
          controller: details.controller,
          thumbVisibility: false,
          shape: const StadiumBorder(),
          thickness: 6,
          crossAxisMargin: 2,
          mainAxisMargin: 2,
          thumbColor:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
          child: result,
        );
      }
    }

    return result;
  }
}

class _GlobalSmoothScrollWrapper extends StatefulWidget {
  final Widget child;
  final ScrollableDetails details;

  const _GlobalSmoothScrollWrapper({
    required this.child,
    required this.details,
  });

  @override
  State<_GlobalSmoothScrollWrapper> createState() =>
      _GlobalSmoothScrollWrapperState();
}

class _GlobalSmoothScrollWrapperState extends State<_GlobalSmoothScrollWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animator;
  double _targetOffset = 0.0;
  double _startOffset = 0.0;
  Animation<double>? _animation;
  ScrollableState? _scrollableState;

  @override
  void initState() {
    super.initState();
    _animator = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(_onAnimationTick);
  }

  @override
  void dispose() {
    _animator.dispose();
    super.dispose();
  }

  ScrollPosition? _resolvePosition() {
    if (widget.details.controller?.hasClients == true) {
      return widget.details.controller!.position;
    }
    if (_scrollableState != null &&
        _scrollableState!.mounted &&
        _scrollableState!.position.hasContentDimensions) {
      return _scrollableState!.position;
    }
    final primary = PrimaryScrollController.maybeOf(context);
    if (primary?.hasClients == true) {
      return primary!.position;
    }
    return null;
  }

  void _onAnimationTick() {
    final position = _resolvePosition();
    if (position != null &&
        position.hasContentDimensions &&
        _animation != null) {
      final target = _animation!.value;
      if (position.pixels != target) {
        position.jumpTo(target);
      }
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      // Keep trackpad 1:1 pixel gestures native
      if (event.kind == PointerDeviceKind.trackpad) return;

      final position = _resolvePosition();
      if (position == null || !position.hasContentDimensions) return;

      final isHorizontal = widget.details.direction == AxisDirection.left ||
          widget.details.direction == AxisDirection.right;

      final rawDelta = isHorizontal
          ? (event.scrollDelta.dx != 0
              ? event.scrollDelta.dx
              : event.scrollDelta.dy)
          : event.scrollDelta.dy;

      if (rawDelta == 0) return;

      final scaledDelta = rawDelta * 1.8;

      final currentPixels = position.pixels;
      if (!_animator.isAnimating) {
        _targetOffset = currentPixels;
      }

      _startOffset = currentPixels;
      _targetOffset = (_targetOffset + scaledDelta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );

      final totalDistance = (_targetOffset - _startOffset).abs();
      final duration = _ScrollPhysics.calculateDuration(totalDistance);

      _animator.duration = duration;
      _animation = Tween<double>(
        begin: _startOffset,
        end: _targetOffset,
      ).animate(
        CurvedAnimation(
          parent: _animator,
          curve: _ScrollPhysics.chromiumBezier,
        ),
      );

      _animator.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.context != null) {
          final state = Scrollable.maybeOf(notification.context!);
          if (state != null) {
            _scrollableState = state;
          }
        }
        return false;
      },
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          final state = Scrollable.maybeOf(notification.context);
          if (state != null) {
            _scrollableState = state;
          }
          return false;
        },
        child: Listener(
          onPointerSignal: _handlePointerSignal,
          child: widget.child,
        ),
      ),
    );
  }
}
