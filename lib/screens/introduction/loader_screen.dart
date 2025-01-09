import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CircleLoaderLoopWidget extends StatefulWidget {
  const CircleLoaderLoopWidget(
      {super.key, this.colors = const [Colors.red, Colors.blue, Colors.green]});

  final List<Color> colors;

  @override
  State<CircleLoaderLoopWidget> createState() => _CircleLoaderLoopWidgetState();
}

class _CircleLoaderLoopWidgetState extends State<CircleLoaderLoopWidget>
    with SingleTickerProviderStateMixin {
  double _width = 100;
  double _height = 100;
  double _borderRadiusValue = 32;
  Color _color = Colors.blue;
  int colorIndex = 0;
  late AnimationController _controller;
  final Random _random = Random();

  // Previous values to ensure significant changes
  double _prevWidth = 100;
  double _prevHeight = 100;
  double _prevBorderRadius = 32;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Timer to change size every 1.5 seconds
    Timer.periodic(const Duration(milliseconds: 1500), (Timer timer) {
      _changeSize();
    });
  }

  void _changeSize() {
    if (mounted) {
      setState(() {
        // Ensure new width is at least 50 units different from previous
        do {
          _width = _random.nextInt(150).toDouble() + 25;
        } while ((_width - _prevWidth).abs() < 20);

        // Ensure new height is at least 50 units different from previous
        do {
          _height = _random.nextInt(150).toDouble() + 25;
        } while ((_height - _prevHeight).abs() < 20);

        // Ensure new border radius is at least 20 units different from previous
        do {
          _borderRadiusValue = _random.nextInt(64).toDouble() + 16;
        } while ((_borderRadiusValue - _prevBorderRadius).abs() < 10);

        // Update previous values
        _prevWidth = _width;
        _prevHeight = _height;
        _prevBorderRadius = _borderRadiusValue;
        colorIndex++;
        _color = widget.colors[colorIndex % widget.colors.length];
      });
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
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * pi,
          child: AnimatedContainer(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(_borderRadiusValue),
            ),
            duration: Durations.extralong4,
            curve: Easing.standard,
          ),
        );
      },
    );
  }
}
