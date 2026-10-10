import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/calendar_scroll/calendar_scroll.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper widget that listens for bottom overscroll gestures on its [child].
class CalendarBottomPullLauncher extends StatefulWidget {
  const CalendarBottomPullLauncher({
    super.key,
    required this.child,
    required this.day,
    this.selectedDay,
    this.threshold = 70.0,
    this.onLaunch,
  });

  /// The scrollable child widget (e.g. CustomScrollView).
  final Widget child;

  /// The date represented by this day view.
  final DateTime day;

  /// The notifier for the currently selected day in [CalendarDayView].
  final ValueNotifier<DateTime>? selectedDay;

  /// Drag distance threshold in logical pixels to activate the launch.
  final double threshold;

  /// Optional override for the launch action.
  final Future<void> Function(BuildContext context, DateTime day)? onLaunch;

  @override
  State<CalendarBottomPullLauncher> createState() =>
      _CalendarBottomPullLauncherState();
}

class _CalendarBottomPullLauncherState extends State<CalendarBottomPullLauncher>
    with SingleTickerProviderStateMixin {
  late final AnimationController _retractController;
  Animation<double>? _retractAnimation;

  double _pullDistance = 0.0;
  bool _isThresholdReached = false;
  bool _isPointerDown = false;
  bool _hasFiredTick = false;
  bool _isLaunching = false;

  @override
  void initState() {
    super.initState();
    _retractController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _retractController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_isLaunching) return;
    _isPointerDown = true;
    if (_retractController.isAnimating) {
      _retractController.stop();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _isPointerDown = false;
    _handleRelease();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _isPointerDown = false;
    _handleRelease();
  }

  void _setPullDistance(double distance) {
    final clamped = distance.clamp(0.0, 160.0);
    final bool reached = clamped >= widget.threshold;

    if (reached && !_isThresholdReached) {
      if (!_hasFiredTick) {
        HapticFeedback.lightImpact();
        _hasFiredTick = true;
      }
    } else if (!reached && _isThresholdReached) {
      _hasFiredTick = false;
    }

    setState(() {
      _pullDistance = clamped;
      _isThresholdReached = reached;
    });
  }

  void _handleRelease() {
    if (_isThresholdReached && !_isLaunching) {
      _isLaunching = true;
      HapticFeedback.mediumImpact();
      _launchListView();
    } else {
      _animateRetract();
    }
  }

  void _animateRetract() {
    if (_pullDistance <= 0.0) return;
    _retractAnimation = Tween<double>(
      begin: _pullDistance,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _retractController,
      curve: Curves.easeOutCubic,
    ))..addListener(() {
        setState(() {
          _pullDistance = _retractAnimation!.value;
          if (_pullDistance < widget.threshold) {
            _isThresholdReached = false;
            _hasFiredTick = false;
          }
        });
      });
    _retractController.forward(from: 0.0);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (_isLaunching) return false;

    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;

    // Check if the scroll position is overscrolling at the bottom
    if (metrics.pixels > metrics.maxScrollExtent) {
      final double overscroll = metrics.pixels - metrics.maxScrollExtent;
      if (_isPointerDown) {
        _setPullDistance(overscroll);
      }
    } else if (notification is OverscrollNotification &&
        notification.overscroll > 0 &&
        metrics.extentAfter <= 0) {
      if (_isPointerDown) {
        _setPullDistance(_pullDistance + notification.overscroll);
      }
    } else if (metrics.pixels <= metrics.maxScrollExtent && !_isPointerDown) {
      if (_pullDistance > 0 && !_retractController.isAnimating) {
        _animateRetract();
      }
    }

    if (notification is ScrollEndNotification) {
      if (!_isPointerDown) {
        _handleRelease();
      }
    }

    return false;
  }

  Future<void> _launchListView() async {
    try {
      if (widget.onLaunch != null) {
        await widget.onLaunch!(context, widget.day);
      } else {
        final DateTime? targetDate = await Navigator.of(context).push<DateTime>(
          PageRouteBuilder<DateTime>(
            transitionDuration: Durations.short4,
            reverseTransitionDuration: Durations.short4,
            pageBuilder: (context, animation, secondaryAnimation) =>
                ScrollCalendar(
              initdate: widget.day,
              onDaySelected: (day) => Navigator.of(context).pop(day),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Easing.standardDecelerate,
                reverseCurve: Easing.standardAccelerate,
              );
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              );
            },
          ),
        );

        if (targetDate != null && mounted) {
          widget.selectedDay?.value = targetDate;
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLaunching = false;
          _isThresholdReached = false;
          _hasFiredTick = false;
          _pullDistance = 0.0;
        });
      }
    }
  }

  Widget _buildIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final double progress = (_pullDistance / widget.threshold).clamp(0.0, 1.0);
    final double opacity = (_pullDistance / 25.0).clamp(0.0, 1.0);
    final double translateY = (1.0 - progress) * 16.0;

    return Positioned(
      bottom: 24.0 + MediaQuery.of(context).viewPadding.bottom,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: AnimatedContainer(
              duration: Durations.short3,
              curve: Easing.standard,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _isThresholdReached
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isThresholdReached
                      ? theme.colorScheme.primary.withValues(alpha: 0.6)
                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  width: _isThresholdReached ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomAnimatedSize(
                child: Row(
                  key: ValueKey<bool>(_isThresholdReached),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isThresholdReached
                          ? Icons.view_agenda_rounded
                          : Icons.arrow_upward_rounded,
                      size: 18,
                      color: _isThresholdReached
                          ? theme.colorScheme.onPrimaryContainer
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isThresholdReached
                          ? "Laat los voor lijstweergave"
                          : "Sleep verder voor lijstweergave",
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: _isThresholdReached
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: _isThresholdReached
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
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

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            widget.child,
            if (_pullDistance > 0.0 || _isThresholdReached)
              _buildIndicator(context),
          ],
        ),
      ),
    );
  }
}
