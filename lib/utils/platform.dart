import 'dart:io' as io;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';

/// A web-safe wrapper around platform checks.
///
/// Calling `Platform.is*` from `dart:io` directly on Flutter Web throws
/// an [UnsupportedError]. [AppPlatform] safely checks [kIsWeb] first so
/// platform queries never throw on the web.
abstract final class AppPlatform {
  static const bool isWeb = kIsWeb;

  static bool get isAndroid => !kIsWeb && io.Platform.isAndroid;
  static bool get isIOS => !kIsWeb && io.Platform.isIOS;
  static bool get isMacOS => !kIsWeb && io.Platform.isMacOS;
  static bool get isWindows => !kIsWeb && io.Platform.isWindows;
  static bool get isLinux => !kIsWeb && io.Platform.isLinux;
  static bool get isFuchsia => !kIsWeb && io.Platform.isFuchsia;
  static bool get isApple => isIOS || isMacOS;
  static bool get isDesktop => isMacOS || isWindows || isLinux;
  static bool get isMobile => isAndroid || isIOS;

  static String get operatingSystem =>
      kIsWeb ? 'web' : io.Platform.operatingSystem;

  static String get operatingSystemVersion =>
      kIsWeb ? 'web' : io.Platform.operatingSystemVersion;

  /// The system locale name. Returns browser locale on Web.
  static String get localeName {
    if (kIsWeb) {
      return ui.PlatformDispatcher.instance.locale.toLanguageTag();
    }
    return io.Platform.localeName;
  }
}
