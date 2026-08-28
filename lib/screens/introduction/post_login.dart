import 'dart:io';
import 'dart:math' as math;

import 'package:discipulus/core/ad_service.dart';
import 'package:discipulus/core/notifications.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/introduction/expressive_components.dart';
import 'package:discipulus/screens/settings/pages/discipulus_settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class PostLoginScreen extends StatefulWidget {
  const PostLoginScreen({super.key});

  @override
  State<PostLoginScreen> createState() => _PostLoginScreenState();
}

class _PostLoginScreenState extends State<PostLoginScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  static const int _totalPages = 5;

  bool get _isDesktop {
    if (kIsWeb) return true;
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    AdService.initialize();
    Layout.of(context)?.update();
    Layout.of(context)?.goToPageFromIndex(
      activeProfile.settings.startingPageIndex,
    );
    Layout.of(context)?.setState(() {});
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;
            final double cardMaxWidth = isCompact ? 520 : 680;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardMaxWidth),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Header Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Text(
                        "Klaar voor de start",
                        style: textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Carousel View
                    Expanded(
                      child: PageView.builder(
                        scrollBehavior: const MaterialScrollBehavior()
                            .copyWith(overscroll: false),
                        controller: _pageController,
                        itemCount: _totalPages,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return _buildNotificationsCard();
                            case 1:
                              return _buildThemeCard();
                            case 2:
                              return _buildAiCard();
                            case 3:
                              return _buildCommunityCard();
                            case 4:
                            default:
                              return _buildFinalActionCard();
                          }
                        },
                      ),
                    ),
                    // Desktop Navigation Row
                    if (_isDesktop) ...[
                      const SizedBox(height: 6),
                      _buildDesktopNavigationRow(),
                      const SizedBox(height: 6),
                    ] else
                      const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Card 1: Meldingen & Herinneringen
  Widget _buildNotificationsCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveSplitCard(
      topFlex: 6,
      bottomFlex: 4,
      previewChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCard(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 2),
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.grade_rounded,
                      color: colorScheme.primary, size: 15),
                ),
                title: const Text(
                  "Nieuwe cijfers gevonden",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                ),
                subtitle: const Text(
                  "Je hebt een 8,5 voor Wiskunde B gehaald",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Text(
                  "Zojuist",
                  style: TextStyle(
                      fontSize: 9.5, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            CustomCard(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 2),
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.event_busy_rounded,
                      color: colorScheme.error, size: 15),
                ),
                title: const Text(
                  "Nederlands komt te vervallen",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                ),
                subtitle: const Text(
                  "Nederlands op 24 mei (4e uur) komt te vervallen",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Text(
                  "08:15",
                  style: TextStyle(
                    fontSize: 9.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            // Notification Banner 3: Reminder / Herinnering
            CustomCard(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 2),
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.alarm_on_rounded,
                      color: colorScheme.tertiary, size: 15),
                ),
                title: const Text(
                  "Herinnering: Geschiedenis toets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                ),
                subtitle: const Text(
                  "Morgen 2e uur • Hoofdstuk 3 & 4 doornemen",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Text(
                  "19:00",
                  style: TextStyle(
                    fontSize: 9.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Giant Material You Interactive Toggle Button
            const Expanded(
              child: Center(
                child: _ExpressiveNotificationToggleButton(),
              ),
            ),
          ],
        ),
      ),
      title: "Meldingen & Herinneringen",
      description:
          "Blijf direct op de hoogte van nieuwe cijfers, roosterwijzigingen en herinneringen. Jij bepaalt wat je ontvangt.",
      bottomColor: colorScheme.primaryContainer,
      onBottomColor: colorScheme.onPrimaryContainer,
    );
  }

  /// Card 2: Thema & Personalisatie
  Widget _buildThemeCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveSplitCard(
      topFlex: 6,
      bottomFlex: 4,
      previewChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Theme Brightness Selector (System, Light, Dark)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeBrightness>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: ThemeBrightness.system,
                        icon: Icon(Icons.brightness_auto_outlined, size: 16),
                        label: Text("Systeem", style: TextStyle(fontSize: 11)),
                      ),
                      ButtonSegment(
                        value: ThemeBrightness.light,
                        icon: Icon(Icons.light_mode_outlined, size: 16),
                        label: Text("Licht", style: TextStyle(fontSize: 11)),
                      ),
                      ButtonSegment(
                        value: ThemeBrightness.dark,
                        icon: Icon(Icons.dark_mode_outlined, size: 16),
                        label: Text("Donker", style: TextStyle(fontSize: 11)),
                      ),
                    ],
                    selected: {appSettings.brightness},
                    onSelectionChanged: (selection) async {
                      setState(() {
                        appSettings
                          ..brightness = selection.first
                          ..save();
                      });
                      await MainApp.of(context).updateTheme();
                    },
                  ),
                ),
              ),
              // 2. Full Personal Color Palette & Dynamic Picker
              CustomCard(
                margin:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
                elevation: 0,
                color: colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: SizedBox(width: double.infinity, child: PersonalColorSetting(),),
                ),
              ),
              // 3. Theme Variant Swatches (Expressive, Vibrant, Fidelity, etc.)
              CustomCard(
                margin:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
                elevation: 0,
                color: colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: ThemeVariantWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
      title: "Thema & Personalisatie",
      description:
          "Kies je favoriete accentkleur, wissel tussen licht en donker of laat Discipulus automatisch meekleuren.",
      bottomColor: colorScheme.secondaryContainer,
      onBottomColor: colorScheme.onSecondaryContainer,
    );
  }

  /// Card 3: AI & Gemini Assistent
  Widget _buildAiCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(38),
          border: Border.all(
            color: colorScheme.outlineVariant.withAlpha(70),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: Column(
            children: [
              // Top Showcase Area (White Card replicating AI Assistant sheet)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(50),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: _buildAiAssistantShowcase(colorScheme),
                    ),
                  ),
                ),
              ),
              // Extra Card inbetween Top and Bottom: "Configureer AI"
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: CustomCard(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colorScheme.secondaryContainer,
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.auto_awesome,
                      color: colorScheme.onSecondaryContainer,
                      size: 20,
                    ),
                    title: Text(
                      "Configureer AI",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondaryContainer,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      "Kies je model of stel een API-sleutel in",
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSecondaryContainer.withAlpha(200),
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_rounded,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    onTap: () =>
                        const DiscipulusSettingsPage().push(context),
                  ),
                ),
              ),
              // Bottom Information Container
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "AI & Slimme Hulp",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onTertiaryContainer,
                                    letterSpacing: -0.3,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Bespaar tijd met slimme samenvattingen of e-mail generaties via online of lokale AI.",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onTertiaryContainer
                                        .withAlpha(230),
                                    height: 1.2,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiAssistantShowcase(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. User Prompt Bubble (Aligned Right)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withAlpha(10),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Maak een samenvatting van deze mail",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 2. AI Response Bubble (Aligned Left with avatar & styled bullets)
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: colorScheme.outlineVariant.withAlpha(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI Bubble Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "AI",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Styled Bullet Points
                  _buildAiBulletPoint(
                    "Op vrijdag staat er een bak bij de conciërge voor geleende boeken (Reinaert, Karel & Elegast, Warenar).",
                    colorScheme,
                  ),
                  const SizedBox(height: 5),
                  _buildAiBulletPoint(
                    "Je mag het boek ook in het postvak van je docent laten neerleggen.",
                    colorScheme,
                  ),
                  const SizedBox(height: 5),
                  _buildAiBulletPoint(
                    "Wij hopen op jullie medewerking, zodat volgend jaar de boeken weer uitgeleend kunnen worden!",
                    colorScheme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiBulletPoint(String text, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4, right: 6),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              height: 1.3,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
  /// Card 4: Community & GitHub Open Source
  Widget _buildCommunityCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(38),
          border: Border.all(
            color: colorScheme.outlineVariant.withAlpha(70),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: Column(
            children: [
              // Top Showcase Area (Community link cards)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  child: Column(
                    children: [
                      _buildCommunityLinkCard(
                        icon: Icons.discord_rounded,
                        title: "Praat mee op Discord",
                        subtitle: "Stel vragen, deel suggesties en klets mee",
                        url: "https://discord.gg/3VA54yr4Vv",
                        color: const Color(0xFF5865F2),
                      ),
                      _buildCommunityLinkCard(
                        icon: Icons.code_rounded,
                        title: "Discipulus op GitHub",
                        subtitle: "Bekijk de code, meld bugs of draag bij",
                        url: "https://github.com/DiscipulusApp/Discipulus",
                        color: colorScheme.primary,
                      )
                    ],
                  ),
                ),
              ),
              // Bottom Information Container
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Doe mee & Denk mee",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onPrimaryContainer,
                                    letterSpacing: -0.3,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Discipulus groeit dankzij feedback van gebruikers. Word lid van de community of draag bij via GitHub!",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onPrimaryContainer
                                        .withAlpha(230),
                                    height: 1.2,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityLinkCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withAlpha(50),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 20, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.open_in_new_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Card 5: Final Action Step
  Widget _buildFinalActionCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExpressiveMorphButton(
              onTap: _navigateToHome,
              icon: Icons.check_rounded,
              color: colorScheme.primary,
              iconColor: colorScheme.onPrimary,
            ),
            const SizedBox(height: 16),
            Text(
              "Klaar!",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavigationRow() {
    final isFinalPage = _currentPage == _totalPages - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _navigateToHome,
            child: const Text("Overslaan"),
          ),
          // Page Indicator Dots
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_totalPages, (index) {
              final isSelected = index == _currentPage;
              return AnimatedContainer(
                duration: Durations.medium1,
                curve: Easing.standard,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isSelected ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          // Next or Finish Action
          if (isFinalPage)
            FilledButton.icon(
              onPressed: _navigateToHome,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text("Aan de slag"),
            )
          else
            IconButton.filledTonal(
              onPressed: () {
                _pageController.nextPage(
                  duration: Durations.medium3,
                  curve: Easing.emphasizedDecelerate,
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
        ],
      ),
    );
  }
}

// --- GIANT MATERIAL YOU NOTIFICATION TOGGLE BUTTON ---

// --- MATERIAL YOU JAGGED / ORGANIC NOTIFICATION TOGGLE BUTTON ---

class _NotificationJaggedMorphShapePainter extends CustomPainter {
  final Color color;
  final double morphProgress; // 0.0 = sharp jagged star (disabled), 1.0 = smooth organic cookie (enabled)

  _NotificationJaggedMorphShapePainter({
    required this.color,
    required this.morphProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.92;
    final path = Path();

    const points = 180;
    const numSpikes = 12; // 12-point jagged star

    for (int i = 0; i <= points; i++) {
      final theta = (i / points) * 2 * math.pi;

      // Jagged sharp star formula (linear triangle wave with sharp crisp peaks)
      final triangleWave =
          (2 / math.pi) * math.asin(math.sin(numSpikes * theta));
      final rJagged = radius * (0.76 + 0.24 * triangleWave);

      // Smooth 7-lobed organic flower/cookie formula
      final rSmooth = radius * (1.0 + 0.12 * math.sin(7 * theta));

      final r = (1.0 - morphProgress) * rJagged + morphProgress * rSmooth;

      final x = center.dx + r * math.cos(theta);
      final y = center.dy + r * math.sin(theta);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NotificationJaggedMorphShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.morphProgress != morphProgress;
  }
}

class _ExpressiveNotificationToggleButton extends StatefulWidget {
  const _ExpressiveNotificationToggleButton();

  @override
  State<_ExpressiveNotificationToggleButton> createState() =>
      _ExpressiveNotificationToggleButtonState();
}

class _ExpressiveNotificationToggleButtonState
    extends State<_ExpressiveNotificationToggleButton>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _isAllowed = false;
  late final AnimationController _rotationController;
  late final AnimationController _morphController;
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 0.0,
    );

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );

    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _rotationController.dispose();
    _morphController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final allowed = await NotificationController.isAllowed;
    if (mounted) {
      setState(() {
        _isAllowed = allowed;
      });
      if (allowed) {
        _morphController.animateTo(1.0, curve: Curves.easeInOutCubic);
      } else {
        _morphController.animateTo(0.0, curve: Curves.easeInOutCubic);
      }
    }
  }

  Future<void> _toggleNotifications() async {
    if (!_isAllowed) {
      await NotificationController.requestPermissions();
      final allowed = await NotificationController.isAllowed;
      if (mounted) {
        setState(() {
          _isAllowed = allowed;
        });
        if (allowed) {
          _morphController.animateTo(1.0, curve: Curves.easeInOutCubic);
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isAllowed = false;
        });
        _morphController.animateTo(0.0, curve: Curves.easeInOutCubic);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => _pressController.forward(),
          onTapUp: (_) {
            _pressController.reverse();
            _toggleNotifications();
          },
          onTapCancel: () => _pressController.reverse(),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _rotationController,
              _morphController,
              _pressController,
            ]),
            builder: (context, child) {
              final currentColor = Color.lerp(
                colorScheme.errorContainer,
                colorScheme.primary,
                _morphController.value,
              )!;

              final currentIconColor = Color.lerp(
                colorScheme.onErrorContainer,
                colorScheme.onPrimary,
                _morphController.value,
              )!;

              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: CustomPaint(
                          size: const Size(90, 90),
                          painter: _NotificationJaggedMorphShapePainter(
                            color: currentColor,
                            morphProgress: _morphController.value,
                          ),
                        ),
                      ),
                      Icon(
                        _morphController.value > 0.5
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_rounded,
                        size: 38,
                        color: currentIconColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Status Badge Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
          decoration: BoxDecoration(
            color: _isAllowed
                ? colorScheme.primaryContainer.withAlpha(200)
                : colorScheme.errorContainer.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isAllowed
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                size: 13,
                color: _isAllowed
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 5),
              Text(
                _isAllowed
                    ? "Meldingen actief"
                    : "Meldingen staan nog uit",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _isAllowed
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),

        Text(
          _isAllowed
              ? "Tik op het icoon om te wijzigen"
              : "Tik op het icoon om in te schakelen",
          style: TextStyle(
            fontSize: 10,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
