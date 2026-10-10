import 'dart:io' as io;

/// A drop-in replacement for [io.Platform] that supports mocking/overriding
/// the current platform during tests, screenshot generation, and runtime.
class AppPlatform {
  static bool? _isIOS;
  static bool? _isAndroid;
  static bool? _isMacOS;
  static bool? _isWindows;
  static bool? _isLinux;
  static bool? _isFuchsia;

  /// Sets mock platform values. Any parameter left null will be treated as false
  /// if other platform flags are set, or will fall back to [io.Platform] if all are null.
  static void setMockPlatform({
    bool? isIOS,
    bool? isAndroid,
    bool? isMacOS,
    bool? isWindows,
    bool? isLinux,
    bool? isFuchsia,
  }) {
    _isIOS = isIOS;
    _isAndroid = isAndroid;
    _isMacOS = isMacOS;
    _isWindows = isWindows;
    _isLinux = isLinux;
    _isFuchsia = isFuchsia;
  }

  /// Resets all mock platform overrides back to the system [io.Platform].
  static void reset() {
    _isIOS = null;
    _isAndroid = null;
    _isMacOS = null;
    _isWindows = null;
    _isLinux = null;
    _isFuchsia = null;
  }

  static bool get isIOS => _isIOS ?? io.Platform.isIOS;
  static bool get isAndroid => _isAndroid ?? io.Platform.isAndroid;
  static bool get isMacOS => _isMacOS ?? io.Platform.isMacOS;
  static bool get isWindows => _isWindows ?? io.Platform.isWindows;
  static bool get isLinux => _isLinux ?? io.Platform.isLinux;
  static bool get isFuchsia => _isFuchsia ?? io.Platform.isFuchsia;

  static bool get isApple => isIOS || isMacOS;
  static bool get isDesktop => isMacOS || isWindows || isLinux;
  static bool get isMobile => isIOS || isAndroid;

  static String get operatingSystem {
    if (isIOS) return 'ios';
    if (isAndroid) return 'android';
    if (isMacOS) return 'macos';
    if (isWindows) return 'windows';
    if (isLinux) return 'linux';
    if (isFuchsia) return 'fuchsia';
    return io.Platform.operatingSystem;
  }

  static String get operatingSystemVersion => io.Platform.operatingSystemVersion;
  static Map<String, String> get environment => io.Platform.environment;
  static String get executable => io.Platform.executable;
  static String get resolvedExecutable => io.Platform.resolvedExecutable;
  static Uri get script => io.Platform.script;
  static List<String> get executableArguments => io.Platform.executableArguments;
  static String? get packageConfig => io.Platform.packageConfig;
  static String get version => io.Platform.version;
  static String get localeName => io.Platform.localeName;
  static String get pathSeparator => io.Platform.pathSeparator;
  static int get numberOfProcessors => io.Platform.numberOfProcessors;
}
