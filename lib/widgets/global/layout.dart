import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:discipulus/core/notifications.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/core/spotlight_search.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:collection/collection.dart';

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

class LayoutState extends State<Layout> with SingleTickerProviderStateMixin {
  // The current active destinations
  late final ValueNotifier<List<DestinationSegement>> _desinations;

  // Small drawer
  late final AdvancedDrawerController drawerController;
  late final AnimationController animationController;
  bool persistantDrawer = true;

  // Global drawer
  late final ValueNotifier<int> selectedIndex;
  bool _showDrawer = true;

  // unilink subscription
  late final StreamSubscription _linkSub;

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
    bool makeFirst = true,
    String? routeName,
  }) async {
    // If the drawer is present, it should be closed
    if (mounted) drawerController.hideDrawer();

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
      onlyRefreshNeeded: !kDebugMode,
    ); // TODO: Turn this off (debugging)

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
        }),
      );

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
    _linkSub = appLinks.uriLinkStream.listen(Intents.uniLinkListener);
    Intents.uniLinkListener(Uri());
  }

  @override
  void dispose() {
    drawerController.dispose();
    animationController.dispose();
    _desinations.dispose();
    selectedIndex.dispose();
    _linkSub.cancel();
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
        curve: CustomAnimatedSize.style().curve!,
      ),
      axis: Axis.horizontal,
      child: child,
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
      // This widget is not a widget that should contain a sidebar, so we will
      // not do anything
      return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Platform.isMacOS ? Colors.transparent : null,
        ),
        child: widget.child,
      );
    } else {
      return Scaffold(
        backgroundColor:
            Platform.isMacOS ? Colors.transparent : backgroundColor,
        body: AdaptiveLayout(
          transitionDuration: Durations.short3,
          primaryNavigation: SlotLayout(
            config: {
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('primaryNavigation'),
                inAnimation: _slotLayoutAnimation,
                outAnimation: _slotLayoutAnimation,
                duration: Durations.short3,
                builder: (_) {
                  return largeSideBar();
                },
              ),
              Breakpoints.medium: SlotLayout.from(
                key: const Key('primaryNavigation'),
                inAnimation: _slotLayoutAnimation,
                outAnimation: _slotLayoutAnimation,
                duration: Durations.short3,
                builder: (_) {
                  return mediumSideBar();
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
                duration: Durations.short3,
                key: const Key('body'),
                builder: (_) {
                  persistantDrawer = true;
                  return Padding(
                    padding: padding,
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
        disabledGestures: Platform.isAndroid
            ? appSettings.drawerOnBack
            : false, //TODO: Disable when route is not first
        controller: drawerController,
        animationController: animationController,
        backdropColor: backgroundColor,
        openRatio: (304 / MediaQuery.of(context).size.width),
        animationCurve: Easing.linear,
        animationDuration: const Duration(milliseconds: 125),
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
    return Padding(
      padding: padding.copyWith(right: 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, index, child) {
              return ValueListenableBuilder(
                valueListenable: _desinations,
                builder: (context, desinations, child) {
                  return AdaptiveScaffold.standardNavigationRail(
                    labelType: NavigationRailLabelType.selected,
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    selectedIndex: _getIndex(index, toIntersperse: true),
                    onDestinationSelected: (int index) => goToPageFromIndex(
                      _getIndex(index, toIntersperse: false),
                    ),
                    leading: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Icon(Icons.query_stats_rounded),
                    ),
                    destinations: <NavigationRailDestination>[
                      ...<List<NavigationRailDestination>>[
                        for (DestinationSegement segment in desinations)
                          [
                            for (Destination destination
                                in segment.destinations)
                              NavigationRailDestination(
                                indicatorColor: Layout.of(context)?.alpha == 255
                                    ? null
                                    : Layout.of(context)
                                        ?.backgroundColor
                                        ?.withAlpha(255),
                                selectedIcon: destination.filledIcon,
                                icon: destination.icon,
                                label: Text(
                                  destination.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ]
                      ].intersperse([
                        NavigationRailDestination(
                          disabled: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          label: const SizedBox(),
                          icon: Divider(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        )
                      ]).expand((e) => e),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget largeSideBar() {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Padding(
        padding: padding.copyWith(left: 0, right: 0),
        child: const BigDrawerBase(),
      ),
    );
  }
}

class BigDrawerBase extends StatelessWidget {
  const BigDrawerBase({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
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
                    : Layout.of(context)!.backgroundColor?.withAlpha(255),
                onDestinationSelected: Layout.of(context)!.goToPageFromIndex,
                selectedIndex: Layout.of(context)!._getIndex(index),
                elevation: 0,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    child: Text(
                      "Discipulus",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    for (DestinationSegement segment in desinations)
                      [
                        if (segment.name != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                            child: Text(
                              segment.name!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        for (Destination destination in segment.destinations)
                          NavigationDrawerDestination(
                            selectedIcon: destination.filledIcon,
                            icon: destination.icon,
                            label: Text(destination.label),
                          ),
                      ]
                  ].intersperse([
                    const Divider(indent: 28, endIndent: 28),
                  ]).expand((element) => element)
                ],
              );
            },
          );
        },
      ),
    );
  }
}
