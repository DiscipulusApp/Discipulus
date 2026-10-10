import 'package:dio/dio.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/utils/app_info.dart';
import 'package:discipulus/utils/app_platform.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class UpdateChecker {
  static const _repo = 'DiscipulusApp/Discipulus';
  static bool _hasChecked = false;

  /// "v0.2.8", "0.2.8+12" or "0.2.8-beta" -> [0, 2, 8]
  static List<int> _parse(String v) => v
      .trim()
      .replaceFirst('v', '')
      .split(RegExp('[+-]'))
      .first
      .split('.')
      .map(int.parse)
      .toList();

  static bool isVersionNewer(String latest, String current) {
    final a = _parse(latest), b = _parse(current);
    for (var i = 0; i < a.length || i < b.length; i++) {
      final x = i < a.length ? a[i] : 0;
      final y = i < b.length ? b[i] : 0;
      if (x != y) return x > y;
    }
    return false;
  }

  static Future<void> checkOnLaunch({Dio? dio}) async {
    if (!(AppPlatform.isWindows || AppPlatform.isLinux) || _hasChecked) return;
    _hasChecked = true;

    try {
      final response = await (dio ?? Dio()).get<Map<String, dynamic>>(
        'https://api.github.com/repos/$_repo/releases/latest',
        options: Options(
          headers: {'Accept': 'application/vnd.github.v3+json'},
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final data = response.data;
      final tag = (data?['tag_name'] as String?)?.trim();
      if (data == null || tag == null || tag.isEmpty) return;

      final current = await AppInfo.versionNumber;
      if (!isVersionNewer(tag, current)) return;

      await WidgetsBinding.instance.endOfFrame;
      final context = navKey.currentContext;
      if (context == null || !context.mounted) return;

      final name = (data['name'] as String?)?.trim();
      await _showDialog(
        context,
        latest: (name?.isNotEmpty ?? false) ? name! : tag,
        current: current,
        url: data['html_url'] as String? ??
            'https://github.com/$_repo/releases/latest',
      );
    } catch (e) {
      debugPrint('Error checking for update: $e');
    }
  }

  static Future<void> _showDialog(
    BuildContext context, {
    required String latest,
    required String current,
    required String url,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.system_update_rounded),
        title: const Text('Update beschikbaar'),
        content: Text(
          'Er is een nieuwe versie van Discipulus beschikbaar ($latest).\n\n'
          'Huidige versie: $current',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            },
            child: const Text('Downloaden'),
          ),
        ],
      ),
    );
  }
}