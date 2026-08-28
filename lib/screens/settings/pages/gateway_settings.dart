import 'package:dio/dio.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomGatewaySettingsPage extends StatefulWidget {
  const CustomGatewaySettingsPage({super.key});

  @override
  State<CustomGatewaySettingsPage> createState() =>
      _CustomGatewaySettingsPageState();
}

class _CustomGatewaySettingsPageState extends State<CustomGatewaySettingsPage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isTesting = false;
  String? _testResult;
  bool? _testSuccess;

  @override
  void initState() {
    super.initState();
    _urlController.text = appSettings.customGatewayUrl ?? "";
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _saveGateway() {
    final text = _urlController.text.trim();
    String finalUrl = "";
    if (text.isNotEmpty) {
      if (!text.startsWith('http://') && !text.startsWith('https://')) {
        finalUrl = 'https://$text';
      } else {
        finalUrl = text;
      }
      // Remove trailing slashes
      while (finalUrl.endsWith('/')) {
        finalUrl = finalUrl.substring(0, finalUrl.length - 1);
      }
    }

    appSettings
      ..customGatewayUrl = finalUrl
      ..save();

    setState(() {
      _urlController.text = finalUrl ?? "";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          finalUrl != null
              ? "Eigen gateway ingesteld op $finalUrl"
              : "Eigen gateway verwijderd. Publieke fallback actief.",
        ),
      ),
    );
  }

  Future<void> _testConnection() async {
    final text = _urlController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _testResult = "Voer eerst een URL in om te testen.";
        _testSuccess = false;
      });
      return;
    }

    String url = text;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
      _testSuccess = null;
    });

    try {
      final res = await Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ).post('$url/api/auth/custom-login/initiate');

      if (res.statusCode == 200 && res.data != null) {
        setState(() {
          _testSuccess = true;
          _testResult = "Verbinding geslaagd! Server ondersteunt Zero-Trust.";
        });
      } else {
        setState(() {
          _testSuccess = false;
          _testResult =
              "Server reageerde met statuscode ${res.statusCode}. Controleer de URL.";
        });
      }
    } on DioException catch (e) {
      setState(() {
        _testSuccess = false;
        _testResult = "Kon server niet bereiken: ${e.message}";
      });
    } catch (e) {
      setState(() {
        _testSuccess = false;
        _testResult = "Onbekende fout: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isTesting = false;
        });
      }
    }
  }

  Future<void> _openGuide() async {
    final uri = Uri.parse("https://harrydekat.dev/Discipulus");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kon webpagina niet openen: https://harrydekat.dev/Discipulus"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasGateway = (appSettings.customGatewayUrl ?? "").trim().isNotEmpty;

    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Eigen Server & Gateway"),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Configuration Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withAlpha(70),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Serveradres (URL)",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Voer het adres in van je eigen private authentication gateway (bijv. https://auth.mijndomein.nl)",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        hintText: "https://auth.mijndomein.nl",
                        prefixIcon: const Icon(Icons.link_rounded),
                        suffixIcon: _urlController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _urlController.clear();
                                  _saveGateway();
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _saveGateway(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: _isTesting ? null : _testConnection,
                            icon: _isTesting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.network_check_rounded),
                            label: const Text("Test verbinding"),
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saveGateway,
                            icon: const Icon(Icons.save_rounded),
                            label: const Text("Opslaan"),
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_testResult != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: (_testSuccess ?? false)
                              ? colorScheme.primaryContainer.withAlpha(120)
                              : colorScheme.errorContainer.withAlpha(120),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              (_testSuccess ?? false)
                                  ? Icons.check_circle_rounded
                                  : Icons.error_outline_rounded,
                              size: 18,
                              color: (_testSuccess ?? false)
                                  ? colorScheme.primary
                                  : colorScheme.error,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _testResult!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: (_testSuccess ?? false)
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      customBuilder: (body) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: body,
          ),
        );
      },
    );
  }
}
