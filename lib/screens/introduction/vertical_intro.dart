import 'dart:io';

import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/screens/settings/pages/discipulus_settings.dart';
import 'package:discipulus/screens/settings/pages/login_with_discipulus.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

bool useTransparency = Platform.isMacOS;

class VerticalIntroductionScreen extends StatefulWidget {
  const VerticalIntroductionScreen({super.key});

  @override
  State<VerticalIntroductionScreen> createState() =>
      _VerticalIntroductionScreenState();
}

class IntroBulletPoint {
  Widget icon;
  String title;
  Widget subtitle;

  IntroBulletPoint({
    required this.icon,
    required this.subtitle,
    required this.title,
  });
}

extension IntroBulletPointExt on List<IntroBulletPoint> {
  List<Widget> get dislayCards {
    return [
      for (var point in indexed)
        CustomCard(
          elevation: 1,
          child: ListTile(
            leading: point.$1.isEven
                ? DefaultTextStyle(
                    style: const TextStyle(fontSize: 24), child: point.$2.icon)
                : null,
            trailing: point.$1.isOdd
                ? DefaultTextStyle(
                    style: const TextStyle(fontSize: 24), child: point.$2.icon)
                : null,
            title: Text(point.$2.title),
            subtitle: point.$2.subtitle,
          ),
        ),
    ];
  }
}

class _VerticalIntroductionScreenState
    extends State<VerticalIntroductionScreen> {
  late final ScrollController _controller;
  late final ValueNotifier<double> _offset;
  late final bool hasAppleWatch;

  @override
  void initState() {
    _controller = ScrollController();
    _offset = ValueNotifier(0);
    super.initState();
    _controller.addListener(() {
      _offset.value = _controller.offset;
    });
    Future(() async => hasAppleWatch = await WatchConnectivity().isPaired)
        .then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _offset.dispose();
    super.dispose();
  }

  void _showAlternativeLogins() {
    showScrollableModalBottomSheet(
      context: context,
      builder: (context, setState, scrollController) {
        return SafeArea(
          child: Wrap(
            children: [
              for (var tile in [
                if (!Platform.isMacOS)
                  ListTile(
                    leading: const Icon(Icons.qr_code_scanner),
                    title: const Text("Login met Discipulus QR-code"),
                    subtitle: const Text(
                        "Scan een QR-code van een ander Discipulus apparaat"),
                    onTap: () {
                      Navigator.pop(context);
                      const LoginWithDiscipulusPage().push(context);
                    },
                  ),
                if (!kReleaseMode)
                  ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text("Login met dummy account"),
                    subtitle: const Text("Voor testdoeleinden"),
                    onTap: () {
                      Navigator.pop(context);
                      const CreateAccountScreen(dummy: true).push(context);
                    },
                  ),
              ])
                CustomCard(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 0,
                  child: tile,
                )
            ],
          ),
        );
      },
    );
  }

  double get _screenFileHeight =>
      MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      64;

  // On supported platforms we will show a transparent background
  double get transparencyRatio =>
      useTransparency ? (_offset.value / _screenFileHeight).clamp(0, 1) : 1;

  Color get backgroundColor => Theme.of(context)
      .scaffoldBackgroundColor
      .withAlpha((255 * transparencyRatio).toInt());

  List<IntroBulletPoint> get bulletPoints => [
        IntroBulletPoint(
          icon: const Text('🏃‍♂️'),
          title: 'Supersnelle opstarttijd',
          subtitle: const Text(
              'Vergeet lange laadtijden! Discipulus start sneller op dan de originele Magister-app.'),
        ),
        IntroBulletPoint(
          icon: const Text('🖥️'),
          title: 'Multi-platform',
          subtitle: const Text(
              'Discipulus is beschikbaar op Android, iOS, macOS, Windows & Linux. Overal zaligheid!'),
        ),
        IntroBulletPoint(
          icon: const Text("🌍"),
          title: "Publiek",
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Alle code voor Discipulus is publiek beschikbaar voor volledige transparatie. Al heb je een leuk idee mag je het zelfs zelf toevoegen!"),
              Align(
                alignment: Alignment.bottomRight,
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () => launchUrl(
                      Uri.parse("https://github.com/DiscipulusApp/Discipulus"),
                      mode: LaunchMode.externalApplication),
                  label: const Text("Ga naar Github"),
                ),
              )
            ],
          ),
        ),
        IntroBulletPoint(
          icon: const Text("🎨"),
          title: "Persoonlijk",
          subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Personaliseer Discipulus volledig door de app aan te passen aan jouw favoriete kleuren. "),
              CustomCard(child: PersonalColorSetting())
            ],
          ),
        ),
      ];

  List<IntroBulletPoint> get iOSBulletPoints => [
        IntroBulletPoint(
          icon: const Text('🤝'),
          title: 'Handoff',
          subtitle: const Text(
              'Start een taak op je iPhone en zet moeiteloos verder op je Mac, zonder onderbrekingen.'),
        ),
        IntroBulletPoint(
          icon: const Text('💾'),
          title: 'Virtual Files',
          subtitle: const Text(
              'Er is ondersteuning voor zogeheten virtuele bestanden, wat betekent dat je bestanden niet eens hoeft te downloaden om ze in een andere app (zoals ChatGPT 😉) te slepen.'),
        ),
        IntroBulletPoint(
          icon: const Text('🖥️'),
          title: 'Widgets',
          subtitle: const Text(
              'Bekijk je rooster, cijfers of berichten direct vanuit je widget, zonder de app te hoeven openen.'),
        ),
        IntroBulletPoint(
          icon: const Text('🔍'),
          title: 'Spotlight-integratie',
          subtitle: const Text(
              'Zoek razendsnel naar berichten, studiewijzers en andere belangrijke informatie binnen Discipulus, rechtstreeks vanuit Spotlight.'),
        ),
      ];

  List<IntroBulletPoint> get watchOSBulletPoints => [
        IntroBulletPoint(
          icon: const Text('📆'),
          title: 'Rooster altijd bij de hand',
          subtitle: const Text(
              'Bekijk je lessen, lokalen en tijden direct op je horloge, zonder je telefoon te pakken.'),
        ),
        IntroBulletPoint(
          icon: const Text('👀'),
          title: 'Snel overzicht',
          subtitle: const Text(
              'Gebruik complicaties op je wijzerplaat om direct te zien waar je volgende les is.'),
        ),
        IntroBulletPoint(
          icon: const Text('📳'),
          title: 'Slimme meldingen',
          subtitle: const Text(
              'Ontvang subtiele trillingen op je pols voordat je volgende les begint, zodat je nooit meer te laat komt.'),
        ),
      ];

  List<IntroBulletPoint> get androidBulletPoints => [
        IntroBulletPoint(
          icon: const Text('🎨'),
          title: 'Material You-integratie',
          subtitle: const Text(
              'Discipulus past zich automatisch aan je systeemthema aan met dynamische kleuren, zodat de app naadloos aansluit bij je persoonlijke voorkeuren en het uiterlijk van je Android-apparaat.'),
        ),
        IntroBulletPoint(
          icon: const Text('📱'),
          title: 'Material 3-design',
          subtitle: const Text(
              'Geniet van een moderne, stijlvolle interface die perfect integreert met andere apps en een uniforme gebruikerservaring biedt die het Android-ecosysteem aanvult.'),
        ),
        IntroBulletPoint(
          title: "Bestanden delen",
          icon: const Text("📁"),
          subtitle: const Text(
              "Deel eenvoudig bestanden naar Discipulus vanuit andere apps, zodat je zonder moeite je werk kan delen."),
        ),
        IntroBulletPoint(
          icon: const Text('🤫'),
          title: 'Automatische niet-storen',
          subtitle: const Text(
              'Op Android is het mogelijk om je telefoon automatisch op stil te zetten tijdens lessen.'),
        ),
      ];

  Widget _buildAppearAnimation(Widget child, {Duration? delay}) {
    return AppearAnimation(
      delay: delay ?? Duration.zero,
      curve: Easing.emphasizedDecelerate,
      duration: Durations.long2,
      child: (animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: Offset.fromDirection(1.5, 0.05),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Easing.emphasizedDecelerate,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildLogoShadow({
    IconData icon = Icons.query_stats_rounded,
    double startYOffSet = 0,
    double startXOffSet = 0,
    double sizeRatio = 0.8,
    double scrollRatio = 2,
    bool highlight = false,
  }) {
    return ValueListenableBuilder(
      valueListenable: _offset,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(startXOffSet, startYOffSet - offset / scrollRatio),
          child: Icon(
            icon,
            size: MediaQuery.of(context).size.height * sizeRatio,
            color: useTransparency || !highlight
                ? Color.lerp(
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withAlpha((transparencyRatio + 100 * 255).toInt()),
                    Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withAlpha(
                          (255 * (1 - transparencyRatio))
                              .toInt()
                              .clamp(255 ~/ 5, 255),
                        ),
                    transparencyRatio,
                  )
                : Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        );
      },
    );
  }

  Widget _buildWelcomeTile() {
    Widget buildSlideAnimation(Widget child) {
      return AppearAnimation(
        duration: Durations.medium3,
        child: (animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(-0.1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Easing.emphasizedDecelerate,
              ),
            ),
            child: child,
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: ValueListenableBuilder(
                valueListenable: _offset,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: Offset(0, -offset / 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildSlideAnimation(
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Welkom bij Discipulus",
                              style: Theme.of(context).textTheme.displayMedium
                                ?..copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        buildSlideAnimation(
                          Text(
                            "Gelukkig geen onderdeel van Magister 🙌",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _offset,
              builder: (context, offset, child) {
                return Opacity(
                  opacity: (1 -
                          (_offset.value / _screenFileHeight).clamp(0, 1) *
                              (1 / 0.75))
                      .clamp(0, 1),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: _buildAppearAnimation(
                      delay: Durations.medium4,
                      FilledButton.icon(
                        onPressed: () => _controller.animateTo(
                          _screenFileHeight,
                          duration: Durations.long4,
                          curve: Easing.standard,
                        ),
                        icon: const Icon(Icons.expand_more),
                        label: const Text("Ga verder"),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Text(
              "Discipulus in de spotlights",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          ...bulletPoints.dislayCards,
        ],
      ),
    );
  }

  Widget _buildThirdPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Platform.isMacOS || Platform.isIOS) ...[
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                "Zien we daar ${Platform.isMacOS ? "macOS" : "iOS"} 👀",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                  "Met Discipulus op ${Platform.isMacOS ? "macOS" : "iOS"} haal je het maximale uit je apparaat met exclusieve functies."),
            ),
            ...iOSBulletPoints.dislayCards,
          ],
          if (Platform.isIOS && hasAppleWatch) ...[
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                "Zozo, wat heb jij een mooi klokje om je pols",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                  "Discipulus is ook gewoon beschikbaar op je Apple Watch."),
            ),
            ...watchOSBulletPoints.dislayCards,
          ],
          if (Platform.isAndroid) ...[
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                "Gemaakt voor Android 💪",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                  "Met Discipulus op Android profiteer je van Material You en Material 3 design, waardoor de app naadloos aansluit bij de uitstraling van je andere apps."),
            ),
            ...androidBulletPoints.dislayCards,
          ],
        ],
      ),
    );
  }

  Widget _buildForthPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: _screenFileHeight - 128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                "Nog een laatste dingetje",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                  "Om gebruik te maken van Discipulus moet je akkoord gaan met de voorwaarden van Magister en Discipulus. Discipulus is NIET verbonden met, of onderdeel van Iddink Group. Eigenlijk maar goed ook."),
            ),
            for (Widget widget in _buildTOSItems())
              CustomCard(
                elevation: 1,
                child: widget,
              )
          ],
        ),
      ),
    );
  }

  bool allowCrashanlytics = true;
  bool agreeToMagisterTOS = false;
  bool agreeToDiscipulusTOS = false;

  List<Widget> _buildTOSItems() {
    return [
      // SwitchListTile(
      //   value: allowCrashanlytics,
      //   title: const Text("Crashlytics"),
      //   subtitle: const Text("Automatische anonieme bug-rapportage"),
      //   secondary: const Icon(Icons.bug_report_outlined),
      //   onChanged: (value) => setState(() {
      //     allowCrashanlytics = value;
      //   }),
      // ),
      Column(
        children: [
          SwitchListTile(
            value: agreeToMagisterTOS,
            title: const Text("Voorwaarden van Magister"),
            subtitle:
                const Text("Ik ga akoord met de voorwaarden van Magister"),
            secondary: const Icon(Icons.description_outlined),
            onChanged: (value) => setState(() {
              agreeToMagisterTOS = value;
            }),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.open_in_browser),
            title: const Text("Lees de voorwaarden"),
            onTap: () => launchUrl(
                Uri.parse("https://magister.nl/over-ons/juridische-zaken/")),
          )
        ],
      ),
      Column(
        children: [
          SwitchListTile(
            value: agreeToDiscipulusTOS,
            title: const Text("Voorwaarden van Discipulus"),
            subtitle:
                const Text("Ik ga akoord met de voorwaarden van Discipulus"),
            secondary: const Icon(Icons.description_outlined),
            onChanged: (value) => setState(() {
              agreeToDiscipulusTOS = value;
            }),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.open_in_browser),
            title: const Text("Lees de voorwaarden"),
            onTap: () => launchUrl(
                Uri.parse("https://harrydekat.dev/Discipulus/voorwaarden")),
          )
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _offset,
      builder: (context, offset, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            scrolledUnderElevation: 0,
            backgroundColor: backgroundColor,
          ),
          backgroundColor: backgroundColor,
          body: child,
        );
      },
      child: Stack(
        children: [
          Center(
            child: _buildAppearAnimation(_buildLogoShadow(
              scrollRatio: 2,
              highlight: true,
            )),
          ),
          Center(
            child: _buildLogoShadow(
              startYOffSet: _screenFileHeight,
              startXOffSet: MediaQuery.of(context).size.width / 3,
              icon: Icons.auto_awesome,
              scrollRatio: 2,
            ),
          ),
          Center(
            child: _buildLogoShadow(
              startYOffSet: _screenFileHeight * 1.5,
              startXOffSet: -MediaQuery.of(context).size.width,
              icon: Icons.description_outlined,
              scrollRatio: 2,
            ),
          ),
          CustomScrollView(
            controller: _controller,
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 64)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: _screenFileHeight,
                  child: _buildWelcomeTile(),
                ),
              ),
              for (Widget widget in [
                _buildSecondPage(),
                _buildThirdPage(),
                _buildForthPage()
              ])
                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 640,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: _screenFileHeight - 64),
                        child: widget,
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(24).copyWith(top: 0),
                sliver: SliverToBoxAdapter(
                  child: SafeArea(
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        AppearAnimation(
                          delay: Durations.medium2,
                          duration: Durations.medium3,
                          child: (animation) => TextButton(
                            onPressed: (!Platform.isMacOS)
                                ? _showAlternativeLogins
                                : null,
                            child: FadeTransition(
                              opacity: animation,
                              child: const Text("Anders"),
                            ),
                          ),
                        ),
                        ElasticAnimation(
                          child: agreeToMagisterTOS && agreeToDiscipulusTOS
                              ? FilledButton.icon(
                                  key: ValueKey(agreeToMagisterTOS &&
                                      agreeToDiscipulusTOS),
                                  onPressed: () =>
                                      const CreateAccountScreen().push(context),
                                  onLongPress: () =>
                                      const CreateAccountScreen(dummy: true)
                                          .push(context),
                                  icon: const Icon(Icons.login_rounded),
                                  label: const Text("Login met Magister"),
                                )
                              : FilledButton.tonalIcon(
                                  key: ValueKey(agreeToMagisterTOS &&
                                      agreeToDiscipulusTOS),
                                  onPressed: () => setState(() {
                                    agreeToMagisterTOS = true;
                                    agreeToDiscipulusTOS = true;
                                  }),
                                  icon: const Icon(Icons.done_all_rounded),
                                  label: const Text("Accepteer alles"),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
