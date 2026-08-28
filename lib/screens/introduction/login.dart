import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:discipulus/api/dummy_magister_api_dart.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/introduction/loader_screen.dart';
import 'package:discipulus/screens/introduction/post_login.dart';
import 'package:discipulus/screens/introduction/vertical_intro.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/utils/login_logger.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/authentication.dart';
import 'package:discipulus/models/account.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<TokenSet?> showMagisterLoginDialog(
  BuildContext context, {
  String? tenant,
  String? username,
}) async {
  ValueNotifier<Uri?> redirectUrl = ValueNotifier<Uri?>(null);
  Authentication auth = Authentication();

  //The cookies have to be cleared otherwise you will not be able to login multiple times.
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    WebViewCookieManager().clearCookies();
  }

  //Settings for the webview (iOS & Android only)
  late final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.contains("#code")) {
            redirectUrl.value = Uri.parse(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(auth.generateLoginURL(tenant: tenant, username: username));

  Future<void> loginWithBrowser({bool noWebview = false}) async {
    if (!noWebview &&
        await WebviewWindow.isWebviewAvailable() &&
        !Platform.isMacOS) {
      WebviewWindow.clearAll();
      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          windowWidth: 400,
          windowHeight: 640,
          title: 'Login met Magister',
          titleBarTopPadding: Platform.isMacOS ? 30 : 0,
          titleBarHeight: 0,
          useWindowPositionAndSize: true,
          userDataFolderWindows: (await getTemporaryDirectory()).path,
        ),
      );
      webview
        ..addOnUrlRequestCallback((requestUrl) async {
          final uri = Uri.parse(requestUrl);
          print("PATH: ${uri.path}");
          if (uri.scheme == "m6loapp") {
            redirectUrl.value = uri;
            webview.close();
          } else if (uri.path.contains("account/login")) {
            await Dio().getUri(uri).then((value) => print(value.realUri));
          }
        })
        ..launch(auth
            .generateLoginURL(tenant: tenant, username: username)
            .toString());
    } else {
      await launchUrl(
        auth.generateLoginURL(tenant: tenant, username: username),
        mode: LaunchMode.externalApplication,
        webViewConfiguration:
            const WebViewConfiguration(enableDomStorage: false),
      );
      appLinks.uriLinkStream.listen((uri) => redirectUrl.value = uri);
    }
  }

  if (!Platform.isAndroid && !Platform.isIOS && !Platform.isMacOS) {
    loginWithBrowser();
  }

  Future<void> returnWithTokenSet(Uri redirectURL) async =>
      Navigator.of(context).pop(await auth.returnURLToTokenSet(redirectURL));

  return await showDialog<TokenSet?>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Inloggen"),
            actions: (Platform.isAndroid ||
                    Platform.isIOS ||
                    Platform
                        .isMacOS) //Only iOS, macOS & Android are supported for logging in with a webview
                ? [
                    IconButton(
                        onPressed: () => webViewController.loadRequest(
                            auth.generateLoginURL(
                                tenant: tenant, username: username)),
                        icon: const Icon(Icons.refresh)),
                    IconButton(
                        onPressed: () => loginWithBrowser(noWebview: true),
                        icon: const Icon(Icons.open_in_browser))
                  ]
                : [],
          ),
          body: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: redirectUrl,
              builder: (context, value, child) {
                if (value != null) {
                  // Redirect value has been set!
                  returnWithTokenSet(value);
                  return const Center(child: CircleLoaderLoopWidget());
                }
                // Waiting for redirectUrl
                if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
                  return WebViewWidget(controller: webViewController);
                } else {
                  return AlertDialog(
                    title: const Text("Browser-login"),
                    content: const Text("Please login with the opened window"),
                    actions: [
                      FilledButton.tonalIcon(
                        onPressed: () => loginWithBrowser(noWebview: true),
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text("Openen in browser"),
                      ),
                      if (!Platform.isMacOS) // This does not work in macOS.
                        FilledButton.icon(
                          onPressed: () => loginWithBrowser(),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text("Openen"),
                        )
                    ],
                  );
                }
              },
            ),
          ),
        ),
      );
    },
  );
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, this.dummy = false});

  final bool dummy;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late final ValueNotifier<TokenSet?> tokenSet;
  late Magister magister;
  late final ValueNotifier<String> textState;
  bool _hasError = false;
  String? _errorMessage;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
    tokenSet = ValueNotifier(null);
    textState = ValueNotifier("");
    LoginLogger.instance.startSession(widget.dummy ? "Dummy Login" : "Magister Login");
    if (!widget.dummy) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setTokenSet());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => getAccount());
    }
  }

  @override
  void dispose() {
    tokenSet.dispose();
    textState.dispose();
    super.dispose();
  }

  Future<void> setTokenSet() async {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _stackTrace = null;
    });
    tokenSet.value = await showMagisterLoginDialog(context);
    // If the dialog was dismissed and no token was retrieved,
    // return to the previous page.
    if (tokenSet.value == null) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    await getAccount();
  }

  Future<void> getAccount() async {
    try {
      setState(() {
        _hasError = false;
        _errorMessage = null;
        _stackTrace = null;
        textState.value = "Gegevens ophalen van Magister...";
      });

      LoginLogger.instance.step("Bepalen van Magister API endpoint");
      // Get endpoint
      Uri endPoint = widget.dummy
          ? Uri.base
          : await Authentication.apiEndpoint(tokenSet.value!);
      magister = widget.dummy
          ? DummyMagister()
          : Magister(
              apiEndpoint: endPoint,
              tokenSet: () => Future.value(tokenSet.value!),
            );

      LoginLogger.instance.step("Ophalen van hoofdaccount & persoonsgegevens");
      // Get account
      ApiAccount account = await magister.account;
      DiscipulusAccount discipulusAccount = DiscipulusAccount(
        endPoint: endPoint.toString(),
        id: account.persoon.id,
        tokenSet: tokenSet.value,
        permissions: account.groep.expand((g) => g.privileges).toList(),
      );

      Future.delayed(
        const Duration(seconds: 5),
        () {
          if (!_hasError && mounted) {
            textState.value = "Nog even geduld, je schoolgegevens worden gesynchroniseerd...";
          }
        },
      );

      LoginLogger.instance.step("Synchroniseren van profiel en data");
      // Fill account
      await discipulusAccount.fill();

      LoginLogger.instance.step("Login succesvol voltooid!");
      // Set active profile and navigate to main screen
      activeProfile = activeProfile;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        Layout.of(context)?.update();
        Layout.of(context)?.goToPageFromIndex(0);
        Layout.of(context)?.setState(() {});
        PostLoginScreen().push(context);
      });
    } catch (e, s) {
      LoginLogger.instance.error("Fout bij ophalen/verwerken van account",
          error: e, stackTrace: s);
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _stackTrace = s;
          textState.value = "ERROR: $e";
        });
      }
    }
  }

  void _showLogModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final logText = LoginLogger.instance.getLogText();
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Diagnostisch Logboek"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: "Kopieer logboek",
                    onPressed: () => LoginLogger.instance.copyToClipboard(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    tooltip: "Deel logboek",
                    onPressed: () => LoginLogger.instance.shareLog(context),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: SelectableText(
                    logText,
                    style: const TextStyle(
                      fontFamily: "monospace",
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Inlogfout"),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withAlpha(80),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 56,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Inloggen mislukt",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Er is iets misgegaan tijdens het ophalen van je gegevens van Magister. Je kunt het diagnostisch rapport delen zodat we dit probleem kunnen oplossen.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(80),
                      ),
                    ),
                    child: SelectableText(
                      _errorMessage ?? "Onbekende fout",
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                        color: colorScheme.error,
                      ),
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () => LoginLogger.instance.shareLog(context),
                        icon: const Icon(Icons.share_rounded),
                        label: const Text("Deel foutrapport"),
                      ),
                      OutlinedButton.icon(
                        onPressed: () =>
                            LoginLogger.instance.copyToClipboard(context),
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text("Kopieer logboek"),
                      ),
                      TextButton.icon(
                        onPressed: () => _showLogModal(context),
                        icon: const Icon(Icons.article_outlined),
                        label: const Text("Bekijk details"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton.tonalIcon(
                    onPressed: () => setTokenSet(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Opnieuw proberen"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: useTransparency ? Colors.transparent : null,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: useTransparency ? Colors.transparent : null,
      ),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          AppearAnimation(
            curve: Easing.standard,
            child: (animation) => FadeTransition(
              opacity: animation,
              child: SizedBox(
                height: 300,
                child: Center(
                  child: CircleLoaderLoopWidget(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      if (!useTransparency)
                        Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.tertiary,
                      if (!useTransparency)
                        Theme.of(context).colorScheme.tertiaryContainer,
                      if (!useTransparency)
                        Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder(
                valueListenable: textState,
                builder: (context, string, _) {
                  return ElasticAnimation(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 64),
                      child: Text(
                        key: ValueKey(string),
                        string,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
