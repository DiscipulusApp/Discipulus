import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/core/notifications.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/core/spotlight_search.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/appie_receipt_export.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/settings/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/desktop_header_bar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:collection/collection.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/screens/grades/widgets/grade_reveal_dialog.dart';
import 'package:discipulus/widgets/ads/banner_ad_widget.dart';
import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';
import 'package:isar/isar.dart';

/// Creates the base layout of the app.
///
/// This means that a sidebar will be added on large and medium screens and a
/// smaller slideable sidebar on small screens.
class Layout extends StatefulWidget {
  const Layout({super.key, required this.child});

  final Widget child;

  @override
  State<Layout> createState() => LayoutState();

// We have to access variables from the current state
  static LayoutState? of(BuildContext context) =>
      context.findAncestorStateOfType<LayoutState>();
}

class LayoutState extends State<Layout>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // The current active destinations
  late final ValueNotifier<List<DestinationSegement>> _desinations;

  StreamSubscription? _gradeSubscription;
  bool _isRevealDialogOpen = false;
  bool _isCheckingForGrades = false;

  // Small drawer
  late final AdvancedDrawerController drawerController;
  late final AnimationController animationController;
  bool persistantDrawer = true;

  // Global drawer
  late final ValueNotifier<int> selectedIndex;
  bool _showDrawer = true;

  // Supporting pane (3rd pane)
  SecondaryPaneEntry? _activeSecondaryPane;

  // The index is not the actual index in some cases, since we use intersperse
  // to create dividers in the medium sidebar.
  int _getIndex(
    int index, {
    bool? toIntersperse,
  }) {
    int newIndex = index;

    // This list contains a 0 for every desination and a 1 for every divider.
    List<int> amountOfInterspaces = _desinations.value
        .map((e) => List.generate(e.destinations.length, (index) => 0))
        .intersperse([toIntersperse != null ? 1 : 0])
        .expand((e) => e)
        .toList();

    if (toIntersperse == false) {
      // Remove interspace, index too high
      newIndex -= amountOfInterspaces.take(index + 1).sum;
    } else if (toIntersperse == true) {
      // Add interspace, index too low
      newIndex = amountOfInterspaces
              .asMap()
              .entries
              .where((e) => e.value == 0)
              .take(index + 1) // Index starts a zero
              .lastOrNull
              ?.key ??
          0;
    }

    return newIndex;
  }

  // Navigation
  Future<void> goToPage(
    Widget screen, {
    bool showDrawer = true,
    bool skipDrawer = false,
    bool makeFirst = true,
    String? routeName,
  }) async {
    // If a secondary pane is open, close it when navigating to a new page
    if (_activeSecondaryPane != null) {
      closeSecondaryPane();
    }

    // If the drawer is present, it should be closed
    if (mounted && !skipDrawer) drawerController.hideDrawer();

    if (showDrawer != _showDrawer) {
      setState(() {
        _showDrawer = showDrawer;
      });
      // The drawer should be reverted the next time the state is set.
      _showDrawer = true;
    }

    int backupSelectedIndex = selectedIndex.value;
    Destination? rootDestination = _desinations.value
        .expand((e) => e.destinations)
        .where((e) => e.view.runtimeType == screen.runtimeType)
        .firstOrNull;
    if (rootDestination != null) {
      // The new screen is a root screen, so we need to adjust the selectedIndex
      // and add the [onPopToggleDrawer] if the route is first
      selectedIndex.value = _desinations.value
          .expand((e) => e.destinations)
          .toList()
          .indexWhere((e) => e.view.runtimeType == screen.runtimeType);
      if (makeFirst) screen = onPopToggleDrawer(child: screen);
    }

    // Perform a quick refresh if needed
    BackgroundRefresh.quickRefresh(
      onlyRefreshNeeded: true,
    );

    Route newPage = PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => screen,
      // When the slidable is used we want the transition in a diffrent axis
      transitionsBuilder: (context, animation, secAnimation, child) {
        return SharedAxisTransition(
          fillColor:
              (screen.key == const ValueKey("TRANSPARENT")) && Platform.isMacOS
                  ? Colors.transparent
                  : null,
          animation: animation,
          secondaryAnimation: secAnimation,
          transitionType: persistantDrawer
              ? SharedAxisTransitionType.vertical
              : SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );

    if (Platform.isIOS && !makeFirst) {
      // On iOS we would like to be able to show the previous page by swiping
      // from the side, so we will be using [CupertinoPageRoute] instead.
      newPage = CupertinoPageRoute(
        settings: newPage.settings,
        builder: (BuildContext context) => screen,
      );
    }

    if (makeFirst) {
      // We want to replace the top route, so we will remove all the history
      navKey.currentState!.popUntil((r) => r.isFirst);
      navKey.currentState!.pushReplacement(newPage);
    } else {
      // Push the new route and set the state when popped, so that the sidebar
      // will reappear.
      navKey.currentState!.push(newPage).then(
            (_) => setState(() {
              selectedIndex.value = backupSelectedIndex;
            }),
          );
    }
  }

  Future<void> goToPageFromIndex(int? index) async => await goToPage(
        _desinations.value
            .expand((e) => e.destinations)
            .toList()[index ?? selectedIndex.value]
            .view,
        // When the shift key is pressed we will not make the page first
        makeFirst: !ServicesBinding.instance.keyboard.isShiftPressed,
      );

  /// This will update the sidebar with the new active account
  void update([Profile? profile]) =>
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() {
          _desinations.value = destinations(
              (profile ?? activeProfile).account.value!.permissions);
          updateMenuBar(destinations: _desinations.value);
          _setupGradeListener(); // Reset listener for the new active profile
        }),
      );

  void updateShownPage() {
    Widget currentView = _desinations.value
        .expand((e) => e.destinations)
        .toList()[selectedIndex.value]
        .view;

    // Update
    update();

    // Set current view
    goToPage(currentView, skipDrawer: true, makeFirst: true);
  }

  //
  //  Core
  //

  @override
  void initState() {
    _desinations = ValueNotifier(
      destinations(appSettings.activeProfileUuid == null
          ? []
          : activeProfile.account.value!.permissions),
    );
    updateMenuBar(destinations: _desinations.value);

    drawerController = AdvancedDrawerController();
    animationController = AnimationController(vsync: this);

    selectedIndex = ValueNotifier(
      appSettings.activeProfileUuid != null
          ? activeProfile.settings.startingPageIndex
          : 0,
    );

    super.initState();

    // Spotlight
    initSpotlight();

    // Deep links
    Intents.uniLinkListener(Uri());

    // Lifecycle and Grade Reveal database listener
    WidgetsBinding.instance.addObserver(this);
    _setupGradeListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForNewGradesToReveal();
    });
  }

  @override
  void dispose() {
    _activeSecondaryPane?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _gradeSubscription?.cancel();
    drawerController.dispose();
    animationController.dispose();
    _desinations.dispose();
    selectedIndex.dispose();
    super.dispose();
  }

  //
  //  Style
  //

  EdgeInsets get padding => const EdgeInsets.all(24).copyWith(
        top: 24 +
            (Platform.isMacOS ? 4 : 0), // The title bar is hidden in macOS,
        // so we have to add some extra padding on top of the normal padding.
      );

  // The border radius that is used
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(16));

  // On macOS we would like the window to be semi-transparent
  int get alpha => (255 * (Platform.isMacOS ? 0.5 : 1)).toInt();

  Color? get backgroundColor => ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          1)
      .withAlpha(alpha);

  Widget _slotLayoutAnimation(Widget child, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Easing.standard,
      ),
      axis: Axis.horizontal,
      child: child,
    );
  }

  /// Minimum screen width required to show the secondary side pane (e.g. 3-pane layout)
  static const double secondaryPaneMinWidth = 1024;

  /// Returns whether the current layout context can host a 3-pane supporting side pane
  bool canShowSecondaryPane(BuildContext context) {
    if (widget.child.key == const ValueKey("NO_DRAWER") ||
        !_showDrawer ||
        appSettings.activeProfileUuid == null) {
      return false;
    }
    return MediaQuery.of(context).size.width >= secondaryPaneMinWidth;
  }

  Future<T?> showSecondaryPane<T>({
    required Widget Function(
      BuildContext context,
      void Function(void Function()) setState,
      ScrollController scrollController,
    ) builder,
    Color? backgroundColor,
    bool isDismissible = true,
    bool showHeader = true,
    NSUserActivity? activity,
  }) {
    if (_activeSecondaryPane != null) {
      if (!_activeSecondaryPane!.completer.isCompleted) {
        _activeSecondaryPane!.completer.complete(null);
      }
    }

    if (Platform.isIOS || Platform.isMacOS) {
      activity?.becomeCurrent();
    }

    final completer = Completer<T?>();
    final entry = SecondaryPaneEntry<T>(
      builder: builder,
      completer: completer,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      showHeader: showHeader,
      activity: activity,
    );

    setState(() {
      _activeSecondaryPane = entry;
    });

    completer.future.whenComplete(() async {
      if (activity != null && (Platform.isIOS || Platform.isMacOS)) {
        await FlutterAppleHandoff.updateActivity(null);
      }
    });

    return completer.future;
  }

  /// Closes the supporting side pane and resolves its future
  void closeSecondaryPane([dynamic result]) {
    if (_activeSecondaryPane != null) {
      final entry = _activeSecondaryPane!;
      setState(() {
        _activeSecondaryPane = null;
      });
      if (!entry.completer.isCompleted) {
        entry.completer.complete(result);
      }
    }
  }

  Widget secondarySidePane(BuildContext context) {
    if (_activeSecondaryPane == null) return const SizedBox.shrink();
    final entry = _activeSecondaryPane!;
    final surfaceColor = entry.backgroundColor ??
        ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          1,
        );

    return Padding(
      padding: padding.copyWith(left: 12),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: borderRadius,
          child: PageTransitionSwitcher(
            duration: Durations.short4,
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: surfaceColor,
                child: child,
              );
            },
            child: Material(
              key: ValueKey(entry.hashCode),
              color: surfaceColor,
              elevation: 1,
              shadowColor: Colors.transparent,
              child: SecondaryPaneContent(
                key: ValueKey(entry.hashCode),
                entry: entry,
                onClose: closeSecondaryPane,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We do not always want to show the sidebar, so we will check if the current
    // pushed child is an allowed widget. All disalowed widgets will have a [ValueKey]
    // with the string "NO_DRAWER".
    if ((widget.child.key == const ValueKey("NO_DRAWER") ||
        !_showDrawer ||
        appSettings.activeProfileUuid == null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DesktopHeaderBar.updateHeaderBarColor(
          background: Theme.of(context).colorScheme.surface,
          foreground: Theme.of(context).colorScheme.onSurface,
        );
      });
      // This widget is not a widget that should contain a sidebar, so we will
      // not do anything
      return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Platform.isMacOS ? Colors.transparent : null,
        ),
        child: widget.child,
      );
    } else {
      if (backgroundColor != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          DesktopHeaderBar.updateHeaderBarColor(
            background: backgroundColor!,
            foreground: Theme.of(context).colorScheme.onSurface,
          );
        });
      }
      final screenWidth = MediaQuery.of(context).size.width;
      final isWideForSecondaryPane = screenWidth >= secondaryPaneMinWidth;
      final bool hasSecondaryPane =
          _activeSecondaryPane != null && isWideForSecondaryPane;
      final double? dynamicBodyRatio = hasSecondaryPane
          ? (1.0 - (420.0 / (screenWidth - (persistantDrawer ? 80.0 : 0.0))))
              .clamp(0.5, 0.75)
          : null;

      final bool isSmall =
          hasSecondaryPane || Breakpoints.medium.isActive(context);

      return Scaffold(
        backgroundColor:
            Platform.isMacOS ? Colors.transparent : backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: AdaptiveLayout(
                transitionDuration: Durations.short4,
                bodyRatio: dynamicBodyRatio,
                primaryNavigation: SlotLayout(
                  config: {
                    Breakpoints.mediumAndUp: SlotLayout.from(
                      key: const Key('primaryNavigation'),
                      inAnimation: _slotLayoutAnimation,
                      outAnimation: _slotLayoutAnimation,
                      inDuration: Durations.short4,
                      outDuration: Durations.short4,
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: borderRadius,
                          child: BigDrawerBase(isSmall: isSmall),
                        );
                      },
                    ),
                  },
                ),
                body: SlotLayout(
                  config: <Breakpoint, SlotLayoutConfig?>{
                    Breakpoints.small: SlotLayout.from(
                      key: const Key('body'),
                      builder: (_) {
                        persistantDrawer = false;
                        return smallSideBar();
                      },
                    ),
                    Breakpoints.mediumAndUp: SlotLayout.from(
                      inDuration: Durations.short4,
                      outDuration: Durations.short4,
                      inAnimation: _slotLayoutAnimation,
                      outAnimation: _slotLayoutAnimation,
                      key: const Key('body'),
                      builder: (_) {
                        persistantDrawer = true;
                        return Padding(
                          padding: padding.copyWith(
                            right: hasSecondaryPane ? 12 : 24,
                            left: isSmall ? 0 : padding.left,
                          ),
                          child: RepaintBoundary(
                            child: ClipRRect(
                              borderRadius: borderRadius,
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  padding: EdgeInsets.zero,
                                  viewPadding: EdgeInsets.zero,
                                  viewInsets: EdgeInsets.zero,
                                ),
                                child: ScaffoldMessenger(child: widget.child),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  },
                ),
                secondaryBody: SlotLayout(
                  config: <Breakpoint, SlotLayoutConfig?>{
                    Breakpoints.mediumAndUp: hasSecondaryPane
                        ? SlotLayout.from(
                            key: const Key('secondaryBody'),
                            inAnimation: _slotLayoutAnimation,
                            outAnimation: _slotLayoutAnimation,
                            inDuration: Durations.short4,
                            outDuration: Durations.short4,
                            builder: (context) => secondarySidePane(context),
                          )
                        : null,
                  },
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      );
    }
  }

  //
  // Different types of sidebars
  //

  Widget smallSideBar() {
    return RepaintBoundary(
      child: AdvancedDrawer(
        rtlOpening: appSettings.drawerOpenOnRight,
        disabledGestures: Platform.isAndroid ? appSettings.drawerOnBack : false,
        controller: drawerController,
        backdropColor: backgroundColor,
        openRatio: (304 / MediaQuery.of(context).size.width),
        childDecoration: BoxDecoration(borderRadius: borderRadius),
        drawer: Padding(
          padding: padding.copyWith(left: 0, right: 0),
          child: const RepaintBoundary(
            child: BigDrawerBase(),
          ),
        ),
        child: ScaffoldMessenger(child: widget.child),
      ),
    );
  }

  Widget mediumSideBar() {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Padding(
        padding: padding.copyWith(left: 0, right: 0),
        child: const BigDrawerBase(isSmall: true),
      ),
    );
  }

  Widget largeSideBar() {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Padding(
        padding: padding.copyWith(left: 0, right: 0),
        child: const BigDrawerBase(isSmall: false),
      ),
    );
  }

  void _setupGradeListener() {
    _gradeSubscription?.cancel();
    if (appSettings.activeProfileUuid == null) return;

    _gradeSubscription = isar.grades
        .filter()
        .wasRevealedEqualTo(false)
        .useable()
        .schoolyear((q) => q.profile((q) => q.uuidEqualTo(activeProfile.uuid)))
        .watch(fireImmediately: true)
        .listen((unrevealedGrades) {
      if (unrevealedGrades.isNotEmpty &&
          (WidgetsBinding.instance.lifecycleState == null ||
              WidgetsBinding.instance.lifecycleState ==
                  AppLifecycleState.resumed)) {
        checkForNewGradesToReveal();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkForNewGradesToReveal();
    }
  }

  Future<void> checkForNewGradesToReveal() async {
    if (_isRevealDialogOpen || _isCheckingForGrades) return;
    if (appSettings.disableGradeReveal) return;
    if (appSettings.activeProfileUuid == null) return;

    _isCheckingForGrades = true;
    try {
      List<Grade> unrevealedGrades = await isar.grades
          .filter()
          .wasRevealedEqualTo(false)
          .useable()
          .schoolyear(
              (q) => q.profile((q) => q.uuidEqualTo(activeProfile.uuid)))
          .findAll();

      if (unrevealedGrades.isNotEmpty) {
        _isRevealDialogOpen = true;
        if (mounted && navKey.currentContext != null) {
          await showDialog(
            context: navKey.currentContext!,
            barrierDismissible: false,
            useSafeArea: false,
            builder: (context) => GradeRevealDialog(grades: unrevealedGrades),
          );
        }
        _isRevealDialogOpen = false;
      }
    } finally {
      _isCheckingForGrades = false;
    }
  }
}

class BigDrawerBase extends StatelessWidget {
  const BigDrawerBase({
    super.key,
    this.isSmall = false,
  });

  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final double targetWidth = isSmall ? 80.0 : 304.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: targetWidth),
      duration: Durations.short4,
      curve: Easing.standard,
      builder: (context, width, child) {
        final double progress =
            ((width - 80.0) / (304.0 - 80.0)).clamp(0.0, 1.0);
        final double textOpacity =
            ((width - 140.0) / (304.0 - 140.0)).clamp(0.0, 1.0);

        return ClipRect(
          child: SizedBox(
            width: width,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent, 
                    Colors.white, 
                    Colors.white, 
                    Colors.transparent, 
                  ],
                  stops: [
                    0.0,
                    0.05,
                    0.95,
                    1.0
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  physics: const ClampingScrollPhysics(),
                ),
                child: ValueListenableBuilder(
                  valueListenable: Layout.of(context)!._desinations,
                  builder: (context, desinations, child) {
                    return ValueListenableBuilder(
                      valueListenable: Layout.of(context)!.selectedIndex,
                      builder: (context, index, child) {
                        return NavigationDrawer(
                          backgroundColor: Colors.transparent,
                          indicatorColor: Layout.of(context)!.alpha == 255
                              ? null
                              : Layout.of(context)!
                                  .backgroundColor
                                  ?.withAlpha(255),
                          onDestinationSelected:
                              Layout.of(context)!.goToPageFromIndex,
                          selectedIndex: Layout.of(context)!._getIndex(index),
                          elevation: 0,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 26.0 + 2.0 * progress,
                                top: 16.0 +
                                    24, // 24 is added by global padding in the layout class,
                                bottom: 16.0,
                              ),
                              child: Row(
                                children: [
                                  CustomPaint(
                                    size: const Size(28, 28),
                                    painter: DiscipulusLogoPainter(
                                      primaryColor:
                                          Theme.of(context).colorScheme.primary,
                                      secondaryColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  if (width >= 120) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Opacity(
                                        opacity: textOpacity,
                                        child: Text(
                                          "Discipulus",
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.clip,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: -0.3,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...[
                              for (DestinationSegement segment in desinations)
                                [
                                  if (segment.name != null && width >= 140)
                                    Opacity(
                                      opacity: textOpacity,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 10),
                                        child: Text(
                                          segment.name!,
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.clip,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                  for (Destination destination
                                      in segment.destinations)
                                    NavigationDrawerDestination(
                                      selectedIcon: destination.filledIcon,
                                      icon: destination.icon,
                                      label: width < 120
                                          ? const SizedBox.shrink()
                                          : Opacity(
                                              opacity: textOpacity,
                                              child: Text(
                                                destination.label,
                                                maxLines: 1,
                                                softWrap: false,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                    ),
                                ]
                            ].intersperse([
                              Divider(
                                indent: 16.0 + 12.0 * progress,
                                endIndent: 16.0 + 12.0 * progress,
                              ),
                            ]).expand((element) => element),
                            if (isar.profiles.countSync() > 1)
                              CustomCard(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: ProfileChangeWidget(
                                  vertical: isSmall,
                                  showAddProfileButton: false,
                                  showName: progress > 0.6,
                                  updateState: (fn) => navKey.currentContext!
                                      .findAncestorStateOfType<LayoutState>()!
                                      .updateShownPage(),
                                ),
                              ),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        24)), // 24 is added by global padding in the layout class
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SecondaryPaneEntry<T> {
  final Widget Function(
    BuildContext context,
    void Function(void Function()) setState,
    ScrollController scrollController,
  ) builder;
  final Completer<T?> completer;
  final Color? backgroundColor;
  final bool isDismissible;
  final bool showHeader;
  final NSUserActivity? activity;
  final ScrollController scrollController;
  final GlobalKey<NavigatorState> navigatorKey;

  SecondaryPaneEntry({
    required this.builder,
    required this.completer,
    this.backgroundColor,
    this.isDismissible = true,
    this.showHeader = true,
    this.activity,
    ScrollController? scrollController,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : scrollController = scrollController ?? ScrollController(),
        navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  void dispose() {
    try {
      scrollController.dispose();
    } catch (_) {}
  }
}

class SecondaryPaneContent extends StatefulWidget {
  final SecondaryPaneEntry entry;
  final void Function([dynamic result]) onClose;

  const SecondaryPaneContent({
    super.key,
    required this.entry,
    required this.onClose,
  });

  @override
  State<SecondaryPaneContent> createState() => _SecondaryPaneContentState();
}

class _SecondaryPaneContentState extends State<SecondaryPaneContent> {
  @override
  void dispose() {
    widget.entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = widget.entry.backgroundColor ??
        ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          1,
        );

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: surfaceColor,
      ),
      child: HeroControllerScope.none(
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () {
              if (widget.entry.isDismissible) {
                widget.onClose();
              }
            },
          },
          child: FocusScope(
            autofocus: true,
            child: Navigator(
              key: widget.entry.navigatorKey,
              initialRoute: '/',
              onGenerateInitialRoutes: (navigator, initialRoute) {
                final activeRoute = MaterialPageRoute(
                  settings: const RouteSettings(name: 'secondary_pane_root'),
                  builder: (paneContext) {
                    final content = PrimaryScrollController(
                      controller: widget.entry.scrollController,
                      child: StatefulBuilder(
                        builder: (ctx, paneSetState) {
                          return widget.entry.builder(
                            paneContext,
                            paneSetState,
                            widget.entry.scrollController,
                          );
                        },
                      ),
                    );

                    if (!widget.entry.showHeader) {
                      return content;
                    }

                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: widget.entry.isDismissible
                          ? AppBar(
                              leading: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => widget.onClose(),
                              ),
                              title: const Text(""),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            )
                          : null,
                      body: content,
                    );
                  },
                );

                // Listen to when this route is popped (e.g. via Navigator.pop(paneContext, result))
                activeRoute.popped.then((result) {
                  widget.onClose(result);
                });

                return [
                  // Base placeholder route so that activeRoute can be popped without exhausting navigator history
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
                    transitionDuration: Duration.zero,
                  ),
                  activeRoute,
                ];
              },
            ),
          ),
        ),
      ),
    );
  }
}
