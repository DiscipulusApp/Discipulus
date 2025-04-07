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
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/authentication.dart';
import 'package:discipulus/models/account.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<TokenSet?> showMagisterLoginDialog(BuildContext context) async {
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
    ..loadRequest(auth.generateLoginURL());

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
        ..launch(auth.generateLoginURL().toString());
    } else {
      await launchUrl(
        auth.generateLoginURL(),
        mode: LaunchMode.externalNonBrowserApplication,
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
                        onPressed: () => webViewController
                            .loadRequest(auth.generateLoginURL()),
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

  @override
  void initState() {
    super.initState();
    tokenSet = ValueNotifier(null);
    textState = ValueNotifier("");
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
    tokenSet.value = await showMagisterLoginDialog(context);
    // If the dialog was dismissed and no token was retrieved,
    // return to the previous page.
    if (tokenSet.value == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) async => Navigator.of(context).pop());
    }
    await getAccount();
  }

  Future<void> getAccount() async {
    try {
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
          if (!textState.value.contains("ERROR: ")) {
            textState.value = "Nog even wachten, je data wordt opgehaald...";
          }
        },
      );

      // Fill account
      await discipulusAccount.fill();

      // Set active profile and navigate to main screen
      activeProfile = activeProfile;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Layout.of(context)?.update();
        Layout.of(context)?.goToPageFromIndex(0);
        Layout.of(context)?.setState(() {});
        PostLoginScreen().push(context);
      });
    } catch (e) {
      textState.value = "ERROR: $e";
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
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
