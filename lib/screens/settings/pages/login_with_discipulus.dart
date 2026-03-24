import 'dart:io';
import 'package:dio/dio.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

import 'package:discipulus/utils/proxy.dart';
import 'package:discipulus/screens/settings/pages/proxy_status.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthQrResult {
  String requestId;
  String backendUrl;
  final String? callbackUrl;
  final bool? isWii;

  AuthQrResult({
    required this.requestId,
    required this.backendUrl,
    required this.callbackUrl,
    this.isWii,
  });

  factory AuthQrResult.fromRawJson(String str) =>
      AuthQrResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthQrResult.fromJson(Map<String, dynamic> json) => AuthQrResult(
        requestId: json["requestId"],
        backendUrl: json["backendUrl"],
        callbackUrl: json["callbackUrl"],
        isWii: json["isWii"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "backendUrl": backendUrl,
        "callbackUrl": callbackUrl,
        "isWii": isWii,
      };
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
            content: Text(
              "Ongeldige QR code: ${e.toString()}",
            ),
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
                  "QR-code scannen is momenteel niet beschikbaar op macOS omdat dit voor problemen zorgt. Gebruik een ander platform of login met uw Magister account.",
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
                          onDetect: (result) => _onDetect(result),
                        ),
                        // Scanner overlay/mask
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
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: body,
          ),
        );
      },
    );
  }
}

Future<bool> isTrustedBackendUrl(
  BuildContext context, {
  required String backendUrl,
}) async {
  bool? trusted = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Vertrouw je deze server?"),
      content: Text(
        "Weet je zeker dat je wilt inloggen via de server op $backendUrl? "
        "Alle gegevens die je via deze app verstuurt naar deze server kunnen "
        "door de eigenaar van de server worden ingezien.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Annuleren"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Vertrouw deze server"),
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
      // If we are already in the selector, don't push another one.
      // Instead, we might want to add a new account.
      // For now, let's just push the selector if it's the first call.
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

  // --- Step 1: Confirm Trust ---
  if (!skipTrustDialog) {
    bool? trusted = await isTrustedBackendUrl(
      context,
      backendUrl: payload.backendUrl,
    );
    if (trusted != true || !context.mounted) return;
  }

  // Define variables to hold our authentication material
  TokenSet? newTokenSet;
  String? existingAccessToken;

  // --- Step 2: Attempt to get an existing access token (Fast Path) ---
  if (profile != null) {
    // We have a profile, let's try to use its token
    final DiscipulusAccount? account = profile.account.value;
    await account?.api.refreshTokenSet();
    final TokenSet? currentTokenSet = await account?.api.tokenSet();
    existingAccessToken = currentTokenSet?.accessToken;

    if (existingAccessToken != null) {
      try {
        // Make the "Fast Path" API call
        await Dio().post(
          '${payload.backendUrl}/api/auth/custom-login/complete',
          data: {
            "requestId": payload.requestId,
            "accessToken": existingAccessToken,
          },
        );
        // If we reach here, the fast path was successful!
      } on DioException catch (_) {
        // The fast path failed (e.g., token expired, account not registered).
        // This is an expected failure. We'll clear the token and fall back to full login.
        existingAccessToken = null; // Clear the token to signal a fallback
      }
    }
  }

  // --- Step 3: Perform Full Login if needed (Slow Path) ---
  if (existingAccessToken == null) {
    // We need to do a full login if:
    // a) There was no initial profile, OR
    // b) The fast path attempt failed.
    if (!context.mounted) return;
    newTokenSet = await showMagisterLoginDialog(context);

    // If the user cancelled the login dialog, we stop here.
    if (newTokenSet == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login geannuleerd.")),
      );
      return;
    }

    // --- Step 4: Make the "Slow Path" API call ---
    try {
      await Dio().post(
        '${payload.backendUrl}/api/auth/custom-login/complete',
        data: {
          'requestId': payload.requestId,
          'tokenSet': newTokenSet.toJson(),
        },
      );
      // If we reach here, the slow path was successful!
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Handshake mislukt: $errorMsg"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return; // Stop on failure
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Onbekende fout opgetreden."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return; // Stop on failure
    }
  }

  // --- Step 5: Navigate to Callback URL on ANY success ---
  // This code is now guaranteed to run only after a successful handshake (either fast or slow path).
  if (redirect && payload.callbackUrl != null) {
    final uri = Uri.parse(payload.callbackUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // It's better not to show a SnackBar here, as the context is about to be lost.
      // The web page is responsible for showing the final success message.
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Kon callback URL niet openen. Ga handmatig terug naar uw browser.")),
      );
    }
  } else if (!redirect) {
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginWithDiscipulusSuccessScreen(),
      ),
    );
  } else {
    // Fallback for older QR codes without a callback, or when redirect is disabled
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text("Login geslaagd! Ga terug naar uw browser om door te gaan."),
      ),
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

    if (trusted != true && mounted) {
      // if not trusted, pop the page
      Navigator.of(context).pop();
    } else if (trusted == true && mounted) {
      // If trusted, refresh the state to show the account selector
      setState(() {
        isTrusted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    trustDialog();
  }

  @override
  Widget build(BuildContext context) {
    if (!isTrusted) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Account Kiezen"),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Selecteer het account waarmee u wilt inloggen op ${widget.payload.backendUrl}",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomCard(
            child: Column(
              children: [
                for (Profile profile in isar.profiles
                    .filter()
                    .not()
                    .accountIsNull()
                    .findAllSync()) ...[
                  ListTile(
                    leading: ProfilePicture(
                      base64ProfilePicture: profile.base64ProfilePicture,
                    ),
                    title: Text(profile.name),
                    onTap: () async {
                      await loginToAlternativeService(
                        context,
                        profile: profile,
                        payload: widget.payload,
                        redirect: widget.redirect,
                      );
                    },
                    trailing: const Icon(Icons.navigate_next),
                  ),
                  if (profile !=
                      isar.profiles
                          .filter()
                          .not()
                          .accountIsNull()
                          .findAllSync()
                          .last)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomCard(
            child: ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Nieuw account toevoegen"),
              trailing: const Icon(Icons.navigate_next),
              onTap: () async {
                await loginToAlternativeService(
                  context,
                  payload: widget.payload,
                  redirect: widget.redirect,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LoginWithDiscipulusSuccessScreen extends StatefulWidget {
  const LoginWithDiscipulusSuccessScreen({super.key});

  @override
  State<LoginWithDiscipulusSuccessScreen> createState() =>
      _LoginWithDiscipulusSuccessScreenState();
}

class _LoginWithDiscipulusSuccessScreenState
    extends State<LoginWithDiscipulusSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
