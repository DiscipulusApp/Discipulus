import 'dart:io';
import 'dart:math' as math;

import 'package:discipulus/screens/calendar/calendar_statistics/widgets/appie_receipt_export.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Controller for programmatic navigation in [ExpressiveIntroScaffold].
class ExpressiveIntroController {
  _ExpressiveIntroScaffoldState? _state;

  void _attach(_ExpressiveIntroScaffoldState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  PageController? get pageController => _state?._pageController;

  int get currentPage => _state?._currentPage ?? 0;

  void animateToPage(
    int page, {
    Duration duration = Durations.long1,
    Curve curve = Easing.emphasizedDecelerate,
  }) {
    if (_state?._pageController.hasClients == true) {
      _state?._pageController.animateToPage(
        page,
        duration: duration,
        curve: curve,
      );
    }
  }

  void nextPage({
    Duration duration = Durations.medium3,
    Curve curve = Easing.emphasizedDecelerate,
  }) {
    if (_state?._pageController.hasClients == true) {
      _state?._pageController.nextPage(
        duration: duration,
        curve: curve,
      );
    }
  }

  void previousPage({
    Duration duration = Durations.medium3,
    Curve curve = Easing.emphasizedDecelerate,
  }) {
    if (_state?._pageController.hasClients == true) {
      _state?._pageController.previousPage(
        duration: duration,
        curve: curve,
      );
    }
  }
}

/// Reusable full-screen scaffold and carousel layout for Expressive introduction flows.
class ExpressiveIntroScaffold extends StatefulWidget {
  final String title;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final ExpressiveIntroController? controller;
  final ValueChanged<int>? onPageChanged;
  final int initialPage;
  final bool hasOpeningSlide;
  final Widget? openingWidget;

  const ExpressiveIntroScaffold({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.onPageChanged,
    this.initialPage = 0,
    this.hasOpeningSlide = false,
    this.openingWidget,
  });

  @override
  State<ExpressiveIntroScaffold> createState() =>
      _ExpressiveIntroScaffoldState();
}

class _ExpressiveIntroScaffoldState extends State<ExpressiveIntroScaffold> {
  late PageController _pageController;
  late int _currentPage;
  late final ValueNotifier<double> _scrollProgress;
  DateTime _lastScrollTime = DateTime.now();

  bool get _isDesktop {
    if (kIsWeb) return true;
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  bool get _useTransparency {
    if (kIsWeb) return false;
    return Platform.isMacOS || Platform.isWindows;
  }

  double get _platformTopCornerRadius {
    if (kIsWeb) return 0.0;
    if (Platform.isWindows)
      return 8.0; // Windows 11 default window corner radius
    if (Platform.isMacOS) return 10.0; // macOS default window corner radius
    return 0.0;
  }

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _scrollProgress = ValueNotifier<double>(
      (widget.hasOpeningSlide && widget.initialPage == 0) ? 0.0 : 1.0,
    );
    _pageController = PageController(
      viewportFraction: 0.86,
      initialPage: _currentPage,
    )..addListener(_onScroll);
    widget.controller?._attach(this);
  }

  void _onScroll() {
    if (!mounted || !widget.hasOpeningSlide) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.hasOpeningSlide) return;
      if (_pageController.hasClients &&
          _pageController.position.hasContentDimensions) {
        final clamped =
            (_pageController.page ?? _currentPage.toDouble()).clamp(0.0, 1.0);
        if ((_scrollProgress.value - clamped).abs() > 0.002) {
          _scrollProgress.value = clamped;
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ExpressiveIntroScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    _scrollProgress.dispose();
    super.dispose();
  }

  void _handleWheelScroll(PointerSignalEvent event) {
    if (event is PointerScrollEvent &&
        event.kind != PointerDeviceKind.trackpad) {
      final now = DateTime.now();
      if (now.difference(_lastScrollTime).inMilliseconds < 160) return;

      final delta = event.scrollDelta.dy != 0
          ? event.scrollDelta.dy
          : event.scrollDelta.dx;

      if (delta > 3) {
        _lastScrollTime = now;
        if (_pageController.hasClients && _currentPage < widget.itemCount - 1) {
          _pageController.nextPage(
            duration: Durations.medium3,
            curve: Easing.emphasizedDecelerate,
          );
        }
      } else if (delta < -3) {
        _lastScrollTime = now;
        if (_pageController.hasClients && _currentPage > 0) {
          _pageController.previousPage(
            duration: Durations.medium3,
            curve: Easing.emphasizedDecelerate,
          );
        }
      }
    }
  }

  void _updateViewportFraction(double width) {
    final double targetFraction =
        width > 700 ? (480.0 / width).clamp(0.28, 0.86) : 0.86;
    if ((_pageController.viewportFraction - targetFraction).abs() > 0.02) {
      final old = _pageController;
      old.removeListener(_onScroll);
      _pageController = PageController(
        viewportFraction: targetFraction,
        initialPage: _currentPage,
      )..addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        old.dispose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final topRadius = _platformTopCornerRadius;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius),
          topRight: Radius.circular(topRadius),
        ),
        child: Stack(
          children: [
            // Background Color fill reacting to scroll progress with platform-appropriate top rounding
            Positioned.fill(
              child: ValueListenableBuilder<double>(
                valueListenable: _scrollProgress,
                builder: (context, progress, _) {
                  final Color backgroundColor = (widget.hasOpeningSlide &&
                          _useTransparency)
                      ? colorScheme.surface.withAlpha((255 * progress).toInt())
                      : colorScheme.surface;
                  if (topRadius > 0.0) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(topRadius),
                          topRight: Radius.circular(topRadius),
                        ),
                      ),
                    );
                  }
                  return ColoredBox(color: backgroundColor);
                },
              ),
            ),
            // Centered Opening Widget in the whole window
            if (widget.hasOpeningSlide && widget.openingWidget != null)
              Positioned.fill(
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollProgress,
                  builder: (context, progress, _) {
                    final double opacity =
                        (1.0 - progress * 1.25).clamp(0.0, 1.0);
                    if (opacity <= 0.0) return const SizedBox.shrink();
                    final double scale =
                        (1.0 - progress * 0.12).clamp(0.8, 1.0);
                    return IgnorePointer(
                      ignoring: progress > 0.05,
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: Center(
                            child: widget.openingWidget!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _updateViewportFraction(constraints.maxWidth);

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      // Header Area - smoothly fades in as user leaves the opening slide
                      ValueListenableBuilder<double>(
                        valueListenable: _scrollProgress,
                        builder: (context, progress, _) {
                          return Opacity(
                            opacity: widget.hasOpeningSlide ? progress : 1.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                              child: Text(
                                widget.title,
                                style: textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.primary,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      // Carousel View with drawer-matching feather at the sides
                      Expanded(
                        child: ClipRect(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.white,
                                  Colors.transparent,
                                ],
                                stops: [
                                  0.0,
                                  20 / MediaQuery.of(context).size.width,
                                  1 - 20 / MediaQuery.of(context).size.width,
                                  1.0,
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Listener(
                              onPointerSignal: _handleWheelScroll,
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (widget.hasOpeningSlide &&
                                      notification
                                          .metrics.hasContentDimensions) {
                                    double page = 0.0;
                                    if (notification.metrics is PageMetrics) {
                                      page =
                                          (notification.metrics as PageMetrics)
                                                  .page ??
                                              (_pageController.hasClients
                                                  ? _pageController.page ?? 0.0
                                                  : 0.0);
                                    } else if (notification
                                            .metrics.viewportDimension >
                                        0) {
                                      page = notification.metrics.pixels /
                                          notification
                                              .metrics.viewportDimension;
                                    }
                                    final clamped = page.clamp(0.0, 1.0);
                                    if ((_scrollProgress.value - clamped)
                                            .abs() >
                                        0.002) {
                                      _scrollProgress.value = clamped;
                                    }
                                  }
                                  return false;
                                },
                                child: PageView.builder(
                                  scrollBehavior: const MaterialScrollBehavior()
                                      .copyWith(overscroll: false),
                                  controller: _pageController,
                                  padEnds: true,
                                  itemCount: widget.itemCount,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                    if (widget.hasOpeningSlide) {
                                      if (index >= 1 &&
                                          _scrollProgress.value < 1.0) {
                                        _scrollProgress.value = 1.0;
                                      } else if (index == 0 &&
                                          _scrollProgress.value > 0.0) {
                                        _scrollProgress.value = 0.0;
                                      }
                                    }
                                    widget.onPageChanged?.call(index);
                                  },
                                  itemBuilder: (context, index) {
                                    final child =
                                        widget.itemBuilder(context, index);
                                    if (child == null) return null;
                                    if (widget.hasOpeningSlide && index >= 1) {
                                      final double normalVisible =
                                          (constraints.maxWidth -
                                                  (constraints.maxWidth *
                                                      _pageController
                                                          .viewportFraction)) /
                                              2.0;
                                      final double desiredPeek =
                                          constraints.maxWidth > 700
                                              ? 80.0
                                              : 14.0;
                                      final double maxExtraOffset =
                                          (normalVisible - desiredPeek)
                                              .clamp(0.0, 180.0);

                                      return ValueListenableBuilder<double>(
                                        valueListenable: _scrollProgress,
                                        builder: (context, progress, child) {
                                          final double factor =
                                              (1.0 - progress).clamp(0.0, 1.0);
                                          final double extraOffset =
                                              factor * maxExtraOffset;
                                          if (extraOffset == 0.0) {
                                            return child!;
                                          }
                                          return Transform.translate(
                                            offset: Offset(extraOffset, 0),
                                            child: child,
                                          );
                                        },
                                        child: child,
                                      );
                                    }
                                    return child;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Desktop-only Navigation Dots Row - fades in alongside content
                      if (_isDesktop) ...[
                        const SizedBox(height: 6),
                        ValueListenableBuilder<double>(
                          valueListenable: _scrollProgress,
                          builder: (context, progress, _) {
                            return Opacity(
                              opacity: widget.hasOpeningSlide ? progress : 1.0,
                              child: _buildDesktopNavigationRow(),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                      ] else
                        const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavigationRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.itemCount, (index) {
              final isSelected = index == _currentPage;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: Durations.long1,
                    curve: Easing.emphasizedDecelerate,
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
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
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Reusable M3 Expressive Split Card layout container.
class ExpressiveSplitCard extends StatelessWidget {
  final Widget previewChild;
  final Widget? middleChild;
  final String title;
  final String description;
  final Color bottomColor;
  final Color onBottomColor;
  final int topFlex;
  final int bottomFlex;

  const ExpressiveSplitCard({
    super.key,
    required this.previewChild,
    this.middleChild,
    required this.title,
    required this.description,
    required this.bottomColor,
    required this.onBottomColor,
    this.topFlex = 6,
    this.bottomFlex = 4,
  });

  @override
  Widget build(BuildContext context) {
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
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38),
          child: Column(
            children: [
              // Top Showcase Area
              Expanded(
                flex: topFlex,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    10,
                    10,
                    10,
                    middleChild != null ? 4 : 6,
                  ),
                  child: Container(
                    width: double.infinity,
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
                      child: previewChild,
                    ),
                  ),
                ),
              ),
              // Optional Middle in-between Area
              if (middleChild != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  child: middleChild!,
                ),
              // Bottom Information Container
              Expanded(
                flex: bottomFlex,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    10,
                    middleChild != null ? 4 : 0,
                    10,
                    10,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: bottomColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: onBottomColor,
                                          letterSpacing: -0.3,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: onBottomColor.withAlpha(230),
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
                        );
                      },
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
}

/// Reusable link card for external documentation, community, or TOS links.
class ExpressiveLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String url;
  final Color? iconColor;

  const ExpressiveLinkCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.url,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = iconColor ?? colorScheme.primary;

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
                        color: effectiveColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 20, color: effectiveColor),
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
}

/// Opening slide card displaying the official Discipulus logo in the center of the screen.
class ExpressiveLogoCard extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const ExpressiveLogoCard({
    super.key,
    this.onTap,
    this.size = 130,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Tooltip(
        message: "Klik om te beginnen",
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(36),
          splashColor: colorScheme.primary.withAlpha(25),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AppearAnimation(
                duration: Durations.long2,
                curve: Easing.emphasizedDecelerate,
                child: (animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale:
                        Tween<double>(begin: 0.85, end: 1.0).animate(animation),
                    child: CustomPaint(
                      size: Size(size, size),
                      painter: DiscipulusLogoPainter(
                        primaryColor: colorScheme.primary,
                        secondaryColor: colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable action card combining [ExpressiveMorphButton] with title text.
class ExpressiveActionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final IconData icon;
  final Color? buttonColor;
  final Color? iconColor;

  const ExpressiveActionCard({
    super.key,
    required this.title,
    required this.onTap,
    this.onLongPress,
    this.icon = Icons.arrow_forward_rounded,
    this.buttonColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExpressiveMorphButton(
                      onTap: onTap,
                      onLongPress: onLongPress,
                      icon: icon,
                      color: buttonColor,
                      iconColor: iconColor,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      title,
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
          },
        ),
      ),
    );
  }
}

/// Signature M3 Expressive Morphing Button.
/// Morphs smoothly between 7-sided cookie shape and soft burst star,
/// with slow continuous ambient rotation and spring scale response on press.
class ExpressiveMorphButton extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  final double size;

  const ExpressiveMorphButton({
    super.key,
    required this.onTap,
    this.onLongPress,
    this.icon = Icons.arrow_forward_rounded,
    this.color,
    this.iconColor,
    this.size = 140,
  });

  @override
  State<ExpressiveMorphButton> createState() => _ExpressiveMorphButtonState();
}

class _ExpressiveMorphButtonState extends State<ExpressiveMorphButton>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );

    _morphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonColor = widget.color ?? colorScheme.tertiary;
    final iconColor = widget.iconColor ?? colorScheme.onTertiary;
    final size = widget.size;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pressController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: _rotationController.value * 2 * math.pi,
                      child: CustomPaint(
                        size: Size(size, size),
                        painter: M3MorphShapePainter(
                          color: buttonColor,
                          morphProgress: _morphAnimation.value,
                        ),
                      ),
                    ),
                    Icon(
                      widget.icon,
                      size: size * 0.35,
                      color: iconColor,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class M3MorphShapePainter extends CustomPainter {
  final Color color;
  final double morphProgress; // 0.0 = 7-sided cookie, 1.0 = soft burst star

  M3MorphShapePainter({
    required this.color,
    required this.morphProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.9;
    final path = Path();

    const points = 140;
    for (int i = 0; i <= points; i++) {
      final theta = (i / points) * 2 * math.pi;

      // 7-sided cookie formula
      final rCookie = radius * (1.0 + 0.12 * math.sin(7 * theta));

      // Soft burst star formula (10 lobes)
      final rBurst = radius * (0.85 + 0.22 * math.cos(10 * theta).abs());

      final r = (1.0 - morphProgress) * rCookie + morphProgress * rBurst;

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
  bool shouldRepaint(M3MorphShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.morphProgress != morphProgress;
  }
}
