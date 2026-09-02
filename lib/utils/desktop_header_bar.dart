import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


///
/// This is for some linux desktop environments (like GNOME) that have a 
/// header bar that can be changed to match the theme of the app. It will
/// calling this on any other platform will do nothing.
///
///

class DesktopHeaderBar {
  static const MethodChannel _channel =
      MethodChannel('dev.harrydekat.discipulus/header_bar');

  static String _colorToHex(Color color) {
    final a = (color.a * 255).round();
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();

    if (a < 255) {
      return 'rgba($r, $g, $b, ${(color.a).toStringAsFixed(2)})';
    }
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }

  /// Updates header bar to match the Layout background color exactly
  /// Overrides the theme's color scheme and uses the provided colors if specified
  static Future<void> updateHeaderBarTheme(ThemeData theme, {Color? background, Color? foreground, Color? border}) async {
    if (kIsWeb || !Platform.isLinux) return;
    try {
      final colorScheme = theme.colorScheme;
      // Layout uses surface with surfaceTint applied at elevation 1
      final layoutBgColor = ElevationOverlay.applySurfaceTint(
        colorScheme.surface,
        colorScheme.surfaceTint,
        1,
      );
      final bg = _colorToHex(background ?? layoutBgColor);
      final fg = _colorToHex(foreground ?? colorScheme.onSurface);
      final finalborder =
          _colorToHex(border ?? colorScheme.outlineVariant.withValues(alpha: 0.3));

      await _channel.invokeMethod('setHeaderBarColor', {
        'background': bg,
        'foreground': fg,
        'border': finalborder,
      });
    } catch (_) {}
  }

  /// Updates header bar with explicit background and foreground colors
  static Future<void> updateHeaderBarColor({
    required Color background,
    required Color foreground,
    Color? border,
  }) async {
    if (kIsWeb || !Platform.isLinux) return;
    try {
      final bg = _colorToHex(background);
      final fg = _colorToHex(foreground);
      final b = border != null ? _colorToHex(border) : 'transparent';

      await _channel.invokeMethod('setHeaderBarColor', {
        'background': bg,
        'foreground': fg,
        'border': b,
      });
    } catch (_) {}
  }
}
