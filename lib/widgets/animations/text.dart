import 'dart:math';

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

/// A widget that displays placeholder lines with a shimmer effect,
/// typically used while waiting for text content to load.
class ShimmeringTextPlaceholder extends StatefulWidget {
  /// The number of placeholder lines to display.
  final int lineCount;

  /// The approximate height of each placeholder line.
  final double lineHeight;

  /// The vertical spacing between placeholder lines.
  final double lineSpacing;

  /// The base color of the placeholder shapes (usually a light grey).
  final Color baseColor;

  /// The color of the moving highlight shimmer.
  final Color highlightColor;

  /// The duration for one cycle of the shimmer animation.
  final Duration shimmerDuration;

  /// The range (min, max) of width factors for the lines, relative to available width.
  /// Creates variation in line length for a more realistic text placeholder look.
  /// Values should be between 0.0 and 1.0.
  final RangeValues widthFactorRange;

  ShimmeringTextPlaceholder({
    super.key,
    this.lineCount = 3,
    this.lineHeight = 16.0,
    this.lineSpacing = 8.0,
    this.baseColor = Colors.black26, // Use a slightly transparent grey
    this.highlightColor = Colors.black12, // Even more transparent/lighter
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.widthFactorRange =
        const RangeValues(0.7, 0.95), // Lines vary between 70% and 95% width
  })  : assert(widthFactorRange.start >= 0.0 && widthFactorRange.start <= 1.0),
        assert(widthFactorRange.end >= 0.0 && widthFactorRange.end <= 1.0),
        assert(widthFactorRange.start <= widthFactorRange.end);

  @override
  State<ShimmeringTextPlaceholder> createState() =>
      _ShimmeringTextPlaceholderState();
}

class _ShimmeringTextPlaceholderState extends State<ShimmeringTextPlaceholder>
    with SingleTickerProviderStateMixin {
  // Needed for vsync

  late AnimationController _shimmerController;
  late List<double> _lineWidthFactors; // Store generated widths

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: widget.shimmerDuration);

    // Generate random width factors once
    final random = Random();
    _lineWidthFactors = List.generate(widget.lineCount, (index) {
      // Generate random value within the specified range
      return widget.widthFactorRange.start +
          random.nextDouble() *
              (widget.widthFactorRange.end - widget.widthFactorRange.start);
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  // Get the gradient for the shimmer effect
  LinearGradient get _shimmerGradient {
    // Use the controller value to slide the gradient stops
    // This creates the moving highlight effect
    final S = _shimmerController.value;
    // Define the width of the highlight band in terms of gradient stops (0.0 to 1.0)
    const highlightWidth = 0.35; // e.g., 35% wide highlight

    return LinearGradient(
      colors: [
        widget.baseColor,
        widget.highlightColor,
        widget.baseColor,
      ],
      stops: [
        (S - highlightWidth).clamp(0.0, 1.0), // Start of highlight
        S.clamp(0.0, 1.0), // Center of highlight
        (S + highlightWidth).clamp(0.0, 1.0), // End of highlight
      ],
      begin: const Alignment(
          -1.2, -0.3), // Slightly angled diagonal gradient start
      end: const Alignment(1.2, 0.3), // Slightly angled diagonal gradient end
      tileMode: TileMode.clamp, // Clamp prevents repeating within the bounds
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use AnimatedBuilder to efficiently rebuild only the ShaderMask
    // when the animation controller ticks.
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        // Apply the shader mask to the column of placeholder lines
        return ShaderMask(
          blendMode: BlendMode.srcATop, // Apply gradient on top of the shapes
          shaderCallback: (bounds) {
            // Create the shader from the gradient using the widget's bounds
            return _shimmerGradient.createShader(bounds);
          },
          child: child, // The child is the Column of placeholder lines
        );
      },
      // This child is built only once and passed to the builder above
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align lines to the left
        mainAxisSize: MainAxisSize.min, // Take minimum vertical space
        children: List.generate(widget.lineCount, (index) {
          // Check if it's the last line to avoid extra spacing
          final bool isLastLine = index == widget.lineCount - 1;

          // Use FractionallySizedBox to control width relative to parent
          return FractionallySizedBox(
            widthFactor:
                _lineWidthFactors[index], // Use pre-generated random width
            alignment: Alignment.centerLeft,
            child: Container(
              height: widget.lineHeight,
              // Add margin below each line except the last one
              margin:
                  EdgeInsets.only(bottom: isLastLine ? 0 : widget.lineSpacing),
              decoration: BoxDecoration(
                color: widget.baseColor, // The actual shape color
                borderRadius: BorderRadius.circular(
                    widget.lineHeight / 4), // Slightly rounded corners
              ),
            ),
          );
        }),
      ),
    );
  }
}
