import 'package:package_info_plus/package_info_plus.dart';

/// Centralized utility for obtaining app metadata and version details via [package_info_plus].
abstract final class AppInfo {
  static PackageInfo? _packageInfo;

  /// Returns the cached or newly fetched [PackageInfo].
  static Future<PackageInfo> get info async {
    if (_packageInfo != null) return _packageInfo!;
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {
      // Fallback for tests or headless environments where platform channels are unavailable
      _packageInfo = PackageInfo(
        appName: 'Discipulus',
        packageName: 'dev.harrydekat.discipulus',
        version: '0.0.0',
        buildNumber: '',
        buildSignature: '',
      );
    }
    return _packageInfo!;
  }

  /// Returns the full version string formatted as "${version}+${buildNumber}"
  static Future<String> get version async {
    final pInfo = await info;
    return pInfo.buildNumber.isNotEmpty
        ? '${pInfo.version}+${pInfo.buildNumber}'
        : pInfo.version;
  }

  static Future<String> get versionNumber async => (await info).version;
  static Future<String> get buildNumber async => (await info).buildNumber;
  static Future<String> get appName async => (await info).appName;
  static Future<String> get packageName async => (await info).packageName;
}
