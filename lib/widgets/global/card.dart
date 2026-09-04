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
    super.clipBehavior,
  });

  static CustomCard? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<CustomCard>();

  /// Gets the elevation of the parent card context (defaults to 0, or 1 inside InverseCardElevation/CustomCard)
  double getBackdropElevation(BuildContext context) {
    return CardTheme.of(context).elevation ?? 0;
  }

  /// Target elevation for this card:
  /// - If `elevation` is explicitly passed, honor it.
  /// - Otherwise, invert the backdrop elevation (0 -> 1, 1 -> 0).
  double cardElevation(BuildContext context) =>
      elevation ?? (getBackdropElevation(context) == 0 ? 1 : 0);

  Color? invertedColor(BuildContext context) =>
      cardElevation(context) >= 1
          ? ElevationOverlay.applySurfaceTint(
              Theme.of(context).colorScheme.surface,
              surfaceTintColor ?? Theme.of(context).colorScheme.surfaceTint,
              elevation != null && elevation! > 1 ? elevation! : 1,
            )
          :  Theme.of(context).colorScheme.surface;

  @override
  Widget build(BuildContext context) {
    final double thisElevation = cardElevation(context);

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: thisElevation,
          color: invertedColor(context),
        ),
      ),
      child: Card(
        shape: shape,
        surfaceTintColor: surfaceTintColor,
        margin: margin,
        color: color ?? invertedColor(context),
        clipBehavior: clipBehavior,
        elevation: thisElevation,
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
    final elevatedColor = ElevationOverlay.applySurfaceTint(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surfaceTint,
      1,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: elevatedColor,
        cardTheme: CardTheme.of(context).copyWith(elevation: 1),
      ),
      child: child,
    );
  }
}
