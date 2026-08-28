import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/screens/settings/pages/gateway_settings.dart';
import 'package:discipulus/screens/settings/pages/proxy_status.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/utils/proxy.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthQrResult {
  String requestId;
  String backendUrl;
  final String? callbackUrl;
  final bool? isWii;
  final bool requireRefreshToken;
  final List<String> scopes;

  AuthQrResult({
    required this.requestId,
    required this.backendUrl,
    required this.callbackUrl,
    this.isWii,
    this.requireRefreshToken = false,
    this.scopes = const [],
  });

  factory AuthQrResult.fromRawJson(String str) {
    final trimmed = str.trim();
    if (trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        trimmed.startsWith('discipulus://')) {
      final uri = Uri.parse(trimmed);

      if (uri.queryParameters.containsKey('data')) {
        try {
          final decoded = json.decode(uri.queryParameters['data']!);
          if (decoded is Map<String, dynamic>) {
            return AuthQrResult.fromJson(decoded);
          }
        } catch (_) {}
      }

      final rawScope = uri.queryParameters['scope'] ?? uri.queryParameters['scopes'] ?? '';
      final parsedScopes = rawScope.split(RegExp(r'[\s,+]+')).where((s) => s.isNotEmpty).toList();
      final requireRefresh = uri.queryParameters['requireRefreshToken'] == 'true' ||
          uri.queryParameters['require_refresh_token'] == 'true' ||
          parsedScopes.contains('offline_access') ||
          parsedScopes.contains('offline');

      return AuthQrResult(
        requestId: uri.queryParameters['requestId'] ?? uri.queryParameters['request_id'] ?? uri.queryParameters['id'] ?? '',
        backendUrl: uri.queryParameters['backendUrl'] ?? uri.queryParameters['baseUrl'] ?? uri.queryParameters['url'] ?? '',
        callbackUrl: uri.queryParameters['callbackUrl'] ?? uri.queryParameters['callback_url'],
        isWii: uri.queryParameters['isWii'] == 'true' || uri.queryParameters['is_wii'] == 'true' || uri.queryParameters['isWii'] == '1',
        requireRefreshToken: requireRefresh,
        scopes: parsedScopes,
      );
    }
    return AuthQrResult.fromJson(json.decode(trimmed));
  }

  String toRawJson() => json.encode(toJson());

  factory AuthQrResult.fromJson(Map<String, dynamic> json) {
    final rawScope = json['scope'] ?? json['scopes'];
    final List<String> parsedScopes = [];
    if (rawScope is String) {
      parsedScopes.addAll(rawScope.split(RegExp(r'[\s,+]+')).where((s) => s.isNotEmpty));
    } else if (rawScope is List) {
      parsedScopes.addAll(rawScope.map((e) => e.toString()));
    }

    final requireRefresh = json['requireRefreshToken'] == true ||
        json['requireRefreshToken'] == 'true' ||
        json['require_refresh_token'] == true ||
        parsedScopes.contains('offline_access') ||
        parsedScopes.contains('offline');

    return AuthQrResult(
      requestId: (json["requestId"] ?? json["request_id"] ?? json["id"] ?? "").toString(),
      backendUrl: (json["backendUrl"] ?? json["baseUrl"] ?? json["url"] ?? "").toString(),
      callbackUrl: json["callbackUrl"]?.toString() ?? json["callback_url"]?.toString(),
      isWii: json["isWii"] == true || json["isWii"] == "true",
      requireRefreshToken: requireRefresh,
      scopes: parsedScopes,
    );
  }

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "backendUrl": backendUrl,
        if (callbackUrl != null) "callbackUrl": callbackUrl,
        if (isWii != null) "isWii": isWii,
        if (requireRefreshToken) "requireRefreshToken": requireRefreshToken,
        if (scopes.isNotEmpty) "scopes": scopes,
      };
}

Future<void> completeGatewayLogin({
  required String requestId,
  required String backendUrl,
  TokenSet? tokenSet,
  String? accessToken,
  String? userCustomGatewayUrl,
  bool requireRefreshToken = false,
}) async {
  final customGateway = userCustomGatewayUrl ?? appSettings.customGatewayUrl;
  final hasCustomGateway = customGateway != null &&
      customGateway.trim().isNotEmpty &&
      !backendUrl.startsWith(customGateway.trim());

  final dio = Dio();

  if (hasCustomGateway) {
    final initRes = await dio.post(
      '${customGateway.trim()}/api/auth/custom-login/initiate',
    );
    final dynamic rawData = initRes.data;
    final Map<String, dynamic> initData = rawData is String
        ? jsonDecode(rawData) as Map<String, dynamic>
        : Map<String, dynamic>.from(rawData as Map);
    final handoffId = initData['requestId'];

    await dio.post(
      '${customGateway.trim()}/api/auth/custom-login/complete',
      data: {
        'requestId': handoffId,
        if (accessToken != null) 'accessToken': accessToken,
        if (tokenSet != null) 'tokenSet': tokenSet.toJson(),
      },
    );

    await dio.post(
      '${backendUrl.trim()}/api/auth/custom-login/complete',
      data: {
        'requestId': requestId,
        'userGatewayUrl': customGateway.trim(),
        'handoffId': handoffId,
      },
    );
  } else {
    await dio.post(
      '${backendUrl.trim()}/api/auth/custom-login/complete',
      data: {
        'requestId': requestId,
        if (accessToken != null) 'accessToken': accessToken,
        if (tokenSet != null) 'tokenSet': tokenSet.toJson(),
      },
    );
  }
}

Future<bool> isTrustedBackendUrl(
  BuildContext context, {
  required String backendUrl,
}) async {
  if (appSettings.customGatewayUrl != null &&
      backendUrl.startsWith(appSettings.customGatewayUrl!)) {
    return true;
  }

  bool? trusted = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Vertrouw je deze server?"),
      content: Text(
        "Weet je zeker dat je wilt inloggen via $backendUrl?\n\n"
        "Alle gegevens die je via deze app verstuurt kunnen door de eigenaar van de server worden ingezien.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Annuleren"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Vertrouw server"),
        ),
      ],
    ),
  );

  return trusted == true;
}

Future<void> loginToAlternativeService(
  BuildContext context, {
  Profile? profile,
  required AuthQrResult payload,
  bool skipTrustDialog = false,
  bool resetServerOnSuccess = false,
  bool redirect = true,
}) async {
  // Wii Support
  if (payload.isWii == true) {
    if (profile == null) {
      if (context.widget is! LoginWithDiscipulusAccountSelector) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginWithDiscipulusAccountSelector(
              payload: payload,
              redirect: false,
            ),
          ),
        );
        return;
      }
    } else {
      String? proxyUrl = await WiiProxyService.start(profile);
      if (proxyUrl != null) {
        try {
          await Dio().post(
            '${payload.backendUrl}/api/auth/custom-login/complete',
            data: {"proxyUrl": proxyUrl},
          );
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => WiiProxyStatusScreen(proxyUrl: proxyUrl),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Kon Wii niet bereiken: $e")),
            );
          }
        }
      }
      return;
    }
  }

  // Step 1: Confirm Trust
  if (!skipTrustDialog) {
    bool? trusted = await isTrustedBackendUrl(
      context,
      backendUrl: payload.backendUrl,
    );
    if (trusted != true || !context.mounted) return;
  }

  TokenSet? newTokenSet;
  String? existingAccessToken;

  // Step 2: Fast Path (Existing Token)
  if (profile != null && !payload.requireRefreshToken) {
    final DiscipulusAccount? account = profile.account.value;
    await account?.api.refreshTokenSet();
    final TokenSet? currentTokenSet = await account?.api.tokenSet();
    existingAccessToken = currentTokenSet?.accessToken;

    if (existingAccessToken != null) {
      try {
        await completeGatewayLogin(
          requestId: payload.requestId,
          backendUrl: payload.backendUrl,
          accessToken: existingAccessToken,
          requireRefreshToken: payload.requireRefreshToken,
        );
      } on DioException catch (_) {
        existingAccessToken = null;
      } catch (_) {
        existingAccessToken = null;
      }
    }
  }

  // Step 3: Slow Path (Interactive Login)
  if (existingAccessToken == null) {
    if (!context.mounted) return;
    String? tenant;
    if (profile?.account.value?.endPoint != null) {
      final host = Uri.tryParse(profile!.account.value!.endPoint)?.host;
      if (host != null && RegExp(r'^[a-zA-Z0-9-]+\.magister\.net$').hasMatch(host)) {
        tenant = host;
      }
    }
    newTokenSet = await showMagisterLoginDialog(context, tenant: tenant);

    if (newTokenSet == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login geannuleerd.")),
      );
      return;
    }

    try {
      await completeGatewayLogin(
        requestId: payload.requestId,
        backendUrl: payload.backendUrl,
        tokenSet: newTokenSet,
        requireRefreshToken: payload.requireRefreshToken,
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Handshake mislukt: $errorMsg"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Onbekende fout opgetreden."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
  }

  // Step 4: Callback or Success Navigation
  if (redirect && payload.callbackUrl != null) {
    final uri = Uri.parse(payload.callbackUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kon callback URL niet openen. Ga handmatig terug naar uw browser."),
        ),
      );
    }
  } else if (!redirect) {
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginWithDiscipulusSuccessScreen(backendUrl: payload.backendUrl),
      ),
    );
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login geslaagd! Ga terug naar uw browser om door te gaan."),
      ),
    );
  }
}

class LoginWithDiscipulusPage extends StatefulWidget {
  const LoginWithDiscipulusPage({super.key});

  @override
  State<LoginWithDiscipulusPage> createState() =>
      _LoginWithDiscipulusPageState();
}

class _LoginWithDiscipulusPageState extends State<LoginWithDiscipulusPage> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture result) async {
    await controller.stop();
    try {
      final AuthQrResult qrResult =
          AuthQrResult.fromRawJson(result.barcodes.first.rawValue ?? "");

      if (!mounted) return;

      await loginToAlternativeService(
        context,
        profile: activeProfile,
        payload: qrResult,
        redirect: false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Ongeldige QR code: ${e.toString()}"),
          ),
        );
      }
      await controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Login met Discipulus"),
        actions: [
          IconButton(
            tooltip: "Server instellingen",
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => const CustomGatewaySettingsPage().push(context),
          ),
        ],
      ),
      children: [
        if (Platform.isMacOS)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: CustomCard(
              child: ListTile(
                leading: Icon(Icons.error_outline),
                title: Text("Niet beschikbaar op macOS"),
                subtitle: Text(
                  "QR-code scannen is momenteel niet beschikbaar op macOS. Gebruik een ander platform of login met uw Magister account.",
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CustomCard(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        MobileScanner(
                          controller: controller,
                          onDetect: _onDetect,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class LoginWithDiscipulusAccountSelector extends StatefulWidget {
  const LoginWithDiscipulusAccountSelector({
    super.key,
    required this.payload,
    this.redirect = true,
  });

  final AuthQrResult payload;
  final bool redirect;

  @override
  State<LoginWithDiscipulusAccountSelector> createState() =>
      _LoginWithDiscipulusAccountSelectorState();
}

class _LoginWithDiscipulusAccountSelectorState
    extends State<LoginWithDiscipulusAccountSelector> {
  bool isTrusted = false;

  Future<void> trustDialog() async {
    bool? trusted = await isTrustedBackendUrl(
      context,
      backendUrl: widget.payload.backendUrl,
    );
    if (mounted) setState(() => isTrusted = trusted);
    if (!trusted && mounted) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => trustDialog());
  }

  @override
  Widget build(BuildContext context) {
    if (!isTrusted) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profiles = isar.profiles.where().findAllSync();

    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Selecteer account"),
      ),
      children: [
        for (final profile in profiles)
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: ProfilePicture(
                base64ProfilePicture: profile.base64ProfilePicture,
              ),
              title: Text(profile.name),
              subtitle: Text(profile.account.value?.endPoint ?? ""),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await loginToAlternativeService(
                  context,
                  profile: profile,
                  payload: widget.payload,
                  redirect: widget.redirect,
                  skipTrustDialog: true,
                );
              },
            ),
          ),
        CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text("Inloggen met een ander account"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await loginToAlternativeService(
                context,
                payload: widget.payload,
                redirect: widget.redirect,
                skipTrustDialog: true,
              );
            },
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

class LoginWithDiscipulusSuccessScreen extends StatefulWidget {
  final String? backendUrl;
  const LoginWithDiscipulusSuccessScreen({super.key, this.backendUrl});

  @override
  State<LoginWithDiscipulusSuccessScreen> createState() =>
      _LoginWithDiscipulusSuccessScreenState();
}

class _LoginWithDiscipulusSuccessScreenState
    extends State<LoginWithDiscipulusSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..reverse(from: 1).then((_) {
        if (mounted) Navigator.of(context).pop();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.3),
                      );
                    },
                  ),
                ),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 80,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              "Inloggen geslaagd!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text("Je wordt automatisch teruggestuurd"),
          ],
        ),
      ),
    );
  }
}
