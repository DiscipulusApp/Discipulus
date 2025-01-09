import 'package:flutter/material.dart';

/// This is a wrapper around card that will change the color of the card based
/// on the color of the card before it.
class CustomCard extends Card {
  const CustomCard({
    super.surfaceTintColor,
    super.shape,
    super.key,
    super.child,
    super.color,
    super.margin,
    super.elevation,
  });

  static CustomCard? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<CustomCard>();

  /// Gets the elevation of the parent card
  double getBackdropElevation(BuildContext context) {
    double? backdropElevation = elevation != null
        ? elevation == 0
            ? 1
            : 0
        : null;

    return backdropElevation ?? CardTheme.of(context).elevation ?? 0;
  }

  double cardElevation(BuildContext context) =>
      getBackdropElevation(context) == 0 ? 1 : 0;

  Color? invertedColor(BuildContext context) =>
      getBackdropElevation(context) == 0
          ? ElevationOverlay.applySurfaceTint(
              Theme.of(context).colorScheme.surface,
              surfaceTintColor ?? Theme.of(context).colorScheme.surfaceTint,
              elevation != null && elevation! > 1 ? elevation! : 1,
            )
          : Theme.of(context).colorScheme.surface;

  @override
  Widget build(BuildContext context) {
    // print(getBackdropElevation(context));
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: getBackdropElevation(context) == 0 ? 1 : 0,
          color: invertedColor(context),
        ),
      ),
      child: Card(
        shape: shape,
        surfaceTintColor: surfaceTintColor,
        margin: margin,
        color: color,
        // clipBehavior: Clip.hardEdge, // This is not that great for performance
        child: child,
      ),
    );
  }
}

class InverseCardElevation extends StatelessWidget {
  const InverseCardElevation({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(elevation: 1),
      ),
      child: child,
    );
  }
}
