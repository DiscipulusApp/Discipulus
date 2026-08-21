import 'dart:io';

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


class PostLoginScreen extends StatefulWidget {
  const PostLoginScreen({super.key});

  @override
  State<PostLoginScreen> createState() => _PostLoginScreenState();
}

class _PostLoginScreenState extends State<PostLoginScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  static const int _totalPages = 4;

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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

  // --- CARDS ---

  /// Card 1: Meldingen & Herinneringen (With giant Material You interactive button)
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
            // Notification Banner 1: New Grade (matching _quickRefreshGrades)
            CustomCard(
              margin: const EdgeInsets.symmetric(vertical: 2),
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              child: ListTile(
                dense: true,
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.grade_rounded,
                      color: colorScheme.primary, size: 16),
                ),
                title: const Text(
                  "Nieuwe cijfers gevonden",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                subtitle: const Text(
                  "Je hebt een 8,5 voor Wiskunde B gehaald",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Text(
                  "Zojuist",
                  style: TextStyle(
                      fontSize: 10, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            // Notification Banner 2: Schedule Change (matching _buildEventNotification)
            CustomCard(
              margin: const EdgeInsets.symmetric(vertical: 2),
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              child: ListTile(
                dense: true,
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.event_busy_rounded,
                      color: colorScheme.error, size: 16),
                ),
                title: const Text(
                  "Nederlands komt te vervallen",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                subtitle: const Text(
                  "Nederlands op 24 mei (4e uur) komt te vervallen",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Text(
                  "08:15",
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Giant Material You Interactive Toggle Button
            Expanded(
              child: Center(
                child: const _ExpressiveNotificationToggleButton(),
              ),
            ),
          ],
        ),
      ),
      title: "Meldingen & Herinneringen",
      description:
          "Blijf direct op de hoogte van nieuwe cijfers, roosterwijzigingen of berichten. Jij bepaalt wat je ontvangt.",
      bottomColor: colorScheme.primaryContainer,
      onBottomColor: colorScheme.onPrimaryContainer,
    );
  }

  /// Card 2: Thema & Personalisatie (Rich, uniform padding, no double text)
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

  /// Card 3: AI & Gemini Assistent (With middle configuration button and authentic AI sheet showcase)
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
                          "Bespaar tijd met slimme samenvattingen, e-mail generatie en huiswerkhulp via online of lokale AI.",
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

  /// Card 4: Final Action Step
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

class _ExpressiveNotificationToggleButton extends StatefulWidget {
  const _ExpressiveNotificationToggleButton();

  @override
  State<_ExpressiveNotificationToggleButton> createState() =>
      _ExpressiveNotificationToggleButtonState();
}

class _ExpressiveNotificationToggleButtonState
    extends State<_ExpressiveNotificationToggleButton>
    with SingleTickerProviderStateMixin {
  bool _isAllowed = false;
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _checkPermission();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final allowed = await NotificationController.isAllowed;
    if (mounted) {
      setState(() {
        _isAllowed = allowed;
      });
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
      }
    } else {
      if (mounted) {
        setState(() {
          _isAllowed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _toggleNotifications,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isAllowed)
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * 3.14159,
                        child: CustomPaint(
                          size: const Size(84, 84),
                          painter: M3MorphShapePainter(
                            color: colorScheme.primary,
                            morphProgress: 0,
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(80),
                        width: 1.5,
                      ),
                    ),
                  ),
                Icon(
                  _isAllowed
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_off_outlined,
                  size: 34,
                  color: _isAllowed
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _isAllowed ? "Meldingen aan" : "Meldingen uit",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _isAllowed ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
          Text(
            _isAllowed ? "Tik om te wijzigen" : "Tik om in te schakelen",
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
