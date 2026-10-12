import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// A session secret shared by the desktop Flutter application and its stdio
/// MCP process. The latter has no Flutter engine, so path_provider cannot be
/// used to locate this file: both processes must derive the same native path.
class IpcCredentials {
  static const _fileName = '.discipulus-ipc-token';

  static Future<File> get tokenFile async {
    final env = Platform.environment;
    String? root;
    if (Platform.isWindows) {
      root = env['LOCALAPPDATA'] ?? env['APPDATA'] ?? env['USERPROFILE'];
    } else if (Platform.isMacOS) {
      final home = env['HOME'];
      if (home != null && home.isNotEmpty) {
        root = '$home/Library/Application Support';
      }
    } else {
      root = env['XDG_RUNTIME_DIR'] ?? env['XDG_DATA_HOME'];
      if (root == null || root.isEmpty) {
        final home = env['HOME'];
        if (home != null && home.isNotEmpty) root = '$home/.local/share';
      }
    }
    if (root == null || root.isEmpty) {
      throw const FileSystemException('Gebruikersmap voor IPC niet gevonden');
    }

    final directory = Directory('$root${Platform.pathSeparator}Discipulus');
    if (!await directory.exists()) await directory.create(recursive: true);
    if (!Platform.isWindows) {
      // The directory must remain private even if the host has a loose umask.
      final result = await Process.run('chmod', ['700', directory.path]);
      if (result.exitCode != 0) {
        throw FileSystemException('Kan IPC-map niet beveiligen', directory.path);
      }
    }
    return File('${directory.path}${Platform.pathSeparator}$_fileName');
  }

  static Future<String> rotate() async {
    final file = await tokenFile;
    final random = Random.secure();
    final token = base64UrlEncode(List<int>.generate(32, (_) => random.nextInt(256)));
    if (!await file.exists()) await file.create();
    if (!Platform.isWindows) {
      final result = await Process.run('chmod', ['600', file.path]);
      if (result.exitCode != 0) {
        await file.delete();
        throw FileSystemException('Kan IPC-toegangsrechten niet beveiligen', file.path);
      }
    }
    await file.writeAsString(token, flush: true);
    return token;
  }

  static Future<String?> read() async {
    try {
      final file = await tokenFile;
      if (!await file.exists()) return null;
      final token = (await file.readAsString()).trim();
      return token.isEmpty ? null : token;
    } on FileSystemException {
      return null;
    }
  }

  static Future<void> clear() async {
    final file = await tokenFile;
    if (await file.exists()) await file.delete();
  }
}
