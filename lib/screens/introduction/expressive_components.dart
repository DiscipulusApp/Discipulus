import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Reusable M3 Expressive Split Card layout container.
class ExpressiveSplitCard extends StatelessWidget {
  final Widget previewChild;
  final String title;
  final String description;
  final Color bottomColor;
  final Color onBottomColor;
  final int topFlex;
  final int bottomFlex;

  const ExpressiveSplitCard({
    super.key,
    required this.previewChild,
    required this.title,
    required this.description,
    required this.bottomColor,
    required this.onBottomColor,
    this.topFlex = 6,
    this.bottomFlex = 4,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(38),
          border: Border.all(
            color: colorScheme.outlineVariant.withAlpha(70),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: Column(
            children: [
              // Top Showcase Area
              Expanded(
                flex: topFlex,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(50),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: previewChild,
                    ),
                  ),
                ),
              ),
              // Bottom Information Container
              Expanded(
                flex: bottomFlex,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: bottomColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: onBottomColor,
                                    letterSpacing: -0.3,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: onBottomColor.withAlpha(230),
                                    height: 1.2,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Signature M3 Expressive Morphing Button.
/// Morphs smoothly between 7-sided cookie shape and soft burst star,
/// with slow continuous ambient rotation and spring scale response on press.
class ExpressiveMorphButton extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final IconData icon;
  final Color? color;
  final Color? iconColor;

  const ExpressiveMorphButton({
    super.key,
    required this.onTap,
    this.onLongPress,
    this.icon = Icons.arrow_forward_rounded,
    this.color,
    this.iconColor,
  });

  @override
  State<ExpressiveMorphButton> createState() => _ExpressiveMorphButtonState();
}

class _ExpressiveMorphButtonState extends State<ExpressiveMorphButton>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );

    _morphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonColor = widget.color ?? colorScheme.tertiary;
    final iconColor = widget.iconColor ?? colorScheme.onTertiary;

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _pressController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi,
                    child: CustomPaint(
                      size: const Size(140, 140),
                      painter: M3MorphShapePainter(
                        color: buttonColor,
                        morphProgress: _morphAnimation.value,
                      ),
                    ),
                  ),
                  Icon(
                    widget.icon,
                    size: 48,
                    color: iconColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class M3MorphShapePainter extends CustomPainter {
  final Color color;
  final double morphProgress; // 0.0 = 7-sided cookie, 1.0 = soft burst star

  M3MorphShapePainter({
    required this.color,
    required this.morphProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.9;
    final path = Path();

    const points = 140;
    for (int i = 0; i <= points; i++) {
      final theta = (i / points) * 2 * math.pi;

      // 7-sided cookie formula
      final rCookie = radius * (1.0 + 0.12 * math.sin(7 * theta));

      // Soft burst star formula (10 lobes)
      final rBurst = radius * (0.85 + 0.22 * math.cos(10 * theta).abs());

      final r = (1.0 - morphProgress) * rCookie + morphProgress * rBurst;

      final x = center.dx + r * math.cos(theta);
      final y = center.dy + r * math.sin(theta);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(M3MorphShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.morphProgress != morphProgress;
  }
}
