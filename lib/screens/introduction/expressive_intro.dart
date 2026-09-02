import 'dart:io';

import 'package:discipulus/screens/grades/widgets/grade_calc_card.dart';
import 'package:discipulus/screens/grades/widgets/graphs/line_chart.dart';
import 'package:discipulus/screens/grades/widgets/sufficient_grades_card.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/screens/introduction/expressive_components.dart';
import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/screens/settings/pages/login_with_discipulus.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExpressiveIntroductionScreen extends StatefulWidget {
  const ExpressiveIntroductionScreen({super.key});

  @override
  State<ExpressiveIntroductionScreen> createState() =>
      _ExpressiveIntroductionScreenState();
}

class _ExpressiveIntroductionScreenState
    extends State<ExpressiveIntroductionScreen> {
  final ExpressiveIntroController _introController = ExpressiveIntroController();
  static const int _totalPages = 5;
  bool _agreeToMagisterTOS = false;
  bool _agreeToDiscipulusTOS = false;

  bool get _allTOSAccepted => _agreeToMagisterTOS && _agreeToDiscipulusTOS;

  int get _accessiblePages => _allTOSAccepted ? _totalPages : 4;

  bool get _isApple {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS;
  }

  final ValueNotifier<HighlightGrade?> _highlightGrade =
      ValueNotifier<HighlightGrade?>(null);

  @override
  void dispose() {
    _highlightGrade.dispose();
    super.dispose();
  }

  void _onBothTOSAccepted() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted && _allTOSAccepted) {
        _introController.animateToPage(4);
      }
    });
  }

  void _showAlternativeLogins() {
    showScrollableModalBottomSheet(
      context: context,
      builder: (context, setState, scrollController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Wrap(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    "Alternatieve inlogmethoden",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (!kIsWeb && !Platform.isMacOS)
                  CustomCard(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.qr_code_scanner),
                      title: const Text("Login met Discipulus QR-code"),
                      subtitle: const Text(
                          "Scan een QR-code van een ander Discipulus apparaat"),
                      trailing: const Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.pop(context);
                        const LoginWithDiscipulusPage().push(context);
                      },
                    ),
                  ),
                CustomCard(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.bug_report_outlined),
                    title: const Text("Login met dummy account"),
                    subtitle: const Text("Voor testdoeleinden"),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      Navigator.pop(context);
                      const CreateAccountScreen(dummy: true).push(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _proceedToLogin({bool dummy = false}) {
    if (!_allTOSAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "Ga eerst akkoord met de voorwaarden om in te loggen."),
          action: SnackBarAction(
            label: "Accepteer alles",
            onPressed: () {
              setState(() {
                _agreeToMagisterTOS = true;
                _agreeToDiscipulusTOS = true;
              });
              CreateAccountScreen(dummy: dummy).push(context);
            },
          ),
        ),
      );
      return;
    }
    CreateAccountScreen(dummy: dummy).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return ExpressiveIntroScaffold(
      controller: _introController,
      title: "Welkom bij Discipulus",
      itemCount: _accessiblePages,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildGradesCard();
          case 1:
            return _buildArchivedGradesCard();
          case 2:
            return _buildPlatformFeatureCard();
          case 3:
            return _buildTermsOfServiceCard();
          case 4:
          default:
            return _buildFinalActionCard();
        }
      },
    );
  }

  // --- CARDS ---

  /// Cijfers & Gemiddelden
  Widget _buildGradesCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveSplitCard(
      previewChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Real GradesLineChart element reacting live to calculation inputs
              CustomCard(
                margin: const EdgeInsets.symmetric(vertical: 3),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 6, 8, 4),
                  child: ValueListenableBuilder<HighlightGrade?>(
                    valueListenable: _highlightGrade,
                    builder: (context, highlight, _) {
                      return ExcludeSemantics(
                        child: GradesLineChart(
                          grades: null,
                          highlightGrade: highlight,
                          showAverage: true,
                          height: 110,
                        ),
                      );
                    },
                  ),
                ),
              ),
              CustomCard(
                margin: const EdgeInsets.symmetric(vertical: 3),
                elevation: 0,
                child: GradeCalculationCard(
                  grades: null,
                  initialGrade: 6.5,
                  weight: 2,
                  onResult: (grade, average, weight) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _highlightGrade.value = HighlightGrade(
                          id: null,
                          customGrade: grade,
                          customWeight: weight,
                        );
                      }
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: SufficientGradesCard(
                  grades: null,
                ),
              ),
            ],
          ),
        ),
      ),
      title: "Cijfers & Gemiddelden",
      description:
          "Bereken direct welk cijfer je nodig hebt voor je volgende toets en houd al je gemiddelden en grafieken bij",
      bottomColor: colorScheme.secondaryContainer,
      onBottomColor: colorScheme.onSecondaryContainer,
    );
  }

  /// Gearchiveerde Cijfers
  Widget _buildArchivedGradesCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveSplitCard(
      previewChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning preview card
              CustomCard(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                surfaceTintColor: colorScheme.tertiary,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.tertiary,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "3 cijfers gearchiveerd",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Verborgen door school (toetsweek)",
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Alles uitschakelen",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Sample archived grade 1
              CustomCard(
                margin: const EdgeInsets.symmetric(vertical: 2),
                elevation: 0,
                child: Opacity(
                  opacity: 0.65,
                  child: ListTile(
                    dense: true,
                    leading: const GradeAvatar(
                      gradeString: "7.8",
                      badge: "2x",
                    ),
                    title: const Text(
                      "Wiskunde B",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: const Text(
                      "Hoofdstuk 4: Goniometrie",
                      style: TextStyle(fontSize: 11),
                      maxLines: 1,
                    ),
                    trailing: Badge(
                      backgroundColor: colorScheme.tertiaryContainer,
                      textColor: colorScheme.onTertiaryContainer,
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 10),
                          SizedBox(width: 3),
                          Text("Gearchiveerd", style: TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Sample archived grade 2
              CustomCard(
                margin: const EdgeInsets.symmetric(vertical: 2),
                elevation: 0,
                child: Opacity(
                  opacity: 0.65,
                  child: ListTile(
                    dense: true,
                    leading: const GradeAvatar(
                      gradeString: "6.4",
                      badge: "1x",
                    ),
                    title: const Text(
                      "Nederlands",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: const Text(
                      "Literatuur: Verwerkingsopdracht",
                      style: TextStyle(fontSize: 11),
                      maxLines: 1,
                    ),
                    trailing: Badge(
                      backgroundColor: colorScheme.tertiaryContainer,
                      textColor: colorScheme.onTertiaryContainer,
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 10),
                          SizedBox(width: 3),
                          Text("Gearchiveerd", style: TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      title: "Cijfers eruit tijdens toetsweken?",
      description:
          "Discipulus bewaart ze automatisch als gearchiveerde cijfers :)",
      bottomColor: colorScheme.tertiaryContainer,
      onBottomColor: colorScheme.onTertiaryContainer,
    );
  }

  /// Platform specific feature card
  Widget _buildPlatformFeatureCard() {
    if (_isApple) {
      return _buildNavigatorWidgetCard();
    } else {
      return _buildAutoDNDCard();
    }
  }

  /// Apple Navigator Widget Card
  Widget _buildNavigatorWidgetCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveSplitCard(
      previewChild: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Image.asset(
            'assets/images/apple_widget_preview.webp',
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
      title: "Navigator Widget",
      description:
          "Weet direct waar je moet zijn zonder überhaupt je telefoon te openen",
      bottomColor: colorScheme.primaryContainer,
      onBottomColor: colorScheme.onPrimaryContainer,
    );
  }

  /// Android Auto-DND Card
  Widget _buildAutoDNDCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveSplitCard(
      previewChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.do_not_disturb_on_rounded,
                              color: colorScheme.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Automatische stille modus",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "DND actief tijdens lessen (08:30 - 15:15)",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.check_circle_rounded,
                            color: colorScheme.primary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.notifications_off_outlined,
                                  size: 14,
                                  color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text("Meldingen gedempt",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: colorScheme.onSurfaceVariant)),
                            ],
                          ),
                          Text("Stil",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      title: "Automatische 'Niet Storen'",
      description:
          "Discipulus zet je telefoon automatisch op stil (als je dat wilt) tijdens lessen en schakelt het geluid weer in zodra je vrij bent.",
      bottomColor: colorScheme.tertiary,
      onBottomColor: colorScheme.onTertiary,
    );
  }

  /// Card 3: Voorwaarden & Privacy (With 3 link cards and inbetween 'Accepteer alles' switch card)
  Widget _buildTermsOfServiceCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveSplitCard(
      topFlex: 5,
      bottomFlex: 4,
      previewChild: const Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
        child: Column(
          children: [
            ExpressiveLinkCard(
              icon: Icons.description_outlined,
              title: "Voorwaarden van Magister",
              subtitle: "Juridische informatie & privacy",
              url: "https://magister.nl/over-ons/juridische-zaken/",
            ),
            ExpressiveLinkCard(
              icon: Icons.shield_outlined,
              title: "Voorwaarden van Discipulus",
              subtitle: "Gebruikersvoorwaarden & privacy",
              url: "https://harrydekat.dev/Discipulus/voorwaarden",
            ),
            ExpressiveLinkCard(
              icon: Icons.code_rounded,
              title: "Broncode op GitHub",
              subtitle: "100% open-source en transparant",
              url: "https://github.com/DiscipulusApp/Discipulus",
            ),
          ],
        ),
      ),
      middleChild: CustomCard(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colorScheme.secondaryContainer,
        child: SwitchListTile(
          dense: true,
          value: _allTOSAccepted,
          title: Text(
            "Accepteer alles",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _allTOSAccepted
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            "Ga direct akkoord met alle voorwaarden",
            style: TextStyle(
              color: _allTOSAccepted
                  ? colorScheme.onSecondaryContainer.withAlpha(200)
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          secondary: Icon(
            Icons.done_all_rounded,
            color: _allTOSAccepted
                ? colorScheme.onSecondaryContainer
                : colorScheme.primary,
          ),
          onChanged: (value) {
            setState(() {
              _agreeToMagisterTOS = value;
              _agreeToDiscipulusTOS = value;
            });
            if (value) {
              _onBothTOSAccepted();
            }
          },
        ),
      ),
      title: "Voorwaarden & Privacy",
      description:
          "Discipulus is 100% open-source en respecteert je privacy. Je kan zelfs zelf de code doorspitten ;)",
      bottomColor: colorScheme.primaryContainer,
      onBottomColor: colorScheme.onPrimaryContainer,
    );
  }

  /// Card 4: Final Action
  Widget _buildFinalActionCard() {
    return ExpressiveActionCard(
      title: "Aan de slag",
      onTap: () => _proceedToLogin(),
      onLongPress: () => _showAlternativeLogins(),
    );
  }
}
