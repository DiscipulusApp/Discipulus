import 'package:flutter/material.dart';

/// Left axis displaying hour markers (01:00 to 23:00)
class HourAxis extends StatelessWidget {
  const HourAxis({
    super.key,
    required this.hourHeight,
    required this.width,
  });

  final double hourHeight;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          for (int hour = 1; hour < 24; hour++)
            Positioned(
              top: hour * hourHeight - 7,
              left: 0,
              right: 6,
              child: Text(
                "${hour.toString().padLeft(2, '0')}:00",
                textAlign: TextAlign.right,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
