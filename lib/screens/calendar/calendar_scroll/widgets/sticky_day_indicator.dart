import 'dart:math' as math;
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// A render object widget that pins its child at [topPadding] relative to
/// the scrollable viewport.
class StickyHeaderBox extends SingleChildRenderObjectWidget {
  const StickyHeaderBox({
    super.key,
    required super.child,
    this.topPadding = 0.0,
  });

  final double topPadding;

  @override
  RenderStickyHeaderBox createRenderObject(BuildContext context) {
    return RenderStickyHeaderBox(
      topPadding: topPadding,
      scrollPosition: Scrollable.maybeOf(context)?.position,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderStickyHeaderBox renderObject) {
    renderObject
      ..topPadding = topPadding
      ..scrollPosition = Scrollable.maybeOf(context)?.position;
  }
}

class RenderStickyHeaderBox extends RenderShiftedBox {
  RenderStickyHeaderBox({
    RenderBox? child,
    double topPadding = 0.0,
    ScrollPosition? scrollPosition,
  })  : _topPadding = topPadding,
        _scrollPosition = scrollPosition,
        super(child);

  double _topPadding;
  double get topPadding => _topPadding;
  set topPadding(double value) {
    if (_topPadding == value) return;
    _topPadding = value;
    markNeedsPaint();
  }

  ScrollPosition? _scrollPosition;
  ScrollPosition? get scrollPosition => _scrollPosition;
  set scrollPosition(ScrollPosition? value) {
    if (_scrollPosition == value) return;
    if (attached) {
      _scrollPosition?.removeListener(_onScrollChanged);
    }
    _scrollPosition = value;
    if (attached) {
      _scrollPosition?.addListener(_onScrollChanged);
    }
    markNeedsPaint();
  }

  void _onScrollChanged() {
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scrollPosition?.addListener(_onScrollChanged);
  }

  @override
  void detach() {
    _scrollPosition?.removeListener(_onScrollChanged);
    super.detach();
  }

  double _lastShift = 0.0;

  double _calculateShift(Offset offset) {
    if (child == null) return 0.0;
    final double maxShift = math.max(0.0, size.height - child!.size.height);

    double currentDy = offset.dy;
    if (_scrollPosition != null) {
      final viewport = RenderAbstractViewport.of(this);
      final revealed = viewport.getOffsetToReveal(this, 0.0);
      currentDy = revealed.offset - _scrollPosition!.pixels;
    }

    final double shift = _topPadding - currentDy;
    return shift.clamp(0.0, maxShift);
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      child?.getMinIntrinsicWidth(height) ?? 0.0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      child?.getMaxIntrinsicWidth(height) ?? 0.0;

  @override
  double computeMinIntrinsicHeight(double width) =>
      child?.getMinIntrinsicHeight(width) ?? 0.0;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      child?.getMaxIntrinsicHeight(width) ?? 0.0;

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(
        constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
        parentUsesSize: true,
      );
      final double width = constraints.hasBoundedWidth
          ? constraints.maxWidth
          : child!.size.width;
      final double height = constraints.hasBoundedHeight
          ? constraints.maxHeight
          : child!.size.height;
      size = Size(width, height);
    } else {
      size = constraints.smallest;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    _lastShift = _calculateShift(offset);
    context.paintChild(child!, offset + Offset(0, _lastShift));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) return false;
    return result.addWithPaintOffset(
      offset: Offset(0, _lastShift),
      position: position,
      hitTest: (result, transformed) =>
          child!.hitTest(result, position: transformed),
    );
  }
}

/// The circular day indicator badge with day number, weekday, and node dot.
class DayIndicatorBadge extends StatelessWidget {
  const DayIndicatorBadge({
    super.key,
    required this.date,
    this.onTap,
  });

  final DateTime date;
  final VoidCallback? onTap;

  void _handleTap(BuildContext context) {
    HapticFeedback.selectionClick();
    if (onTap != null) {
      onTap!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(date);
    } else {
      CalendarDayView(displayedDay: date).push(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isToday = date.isToday;
    final theme = Theme.of(context);

    return SizedBox(
      width: 56,
      child: Tooltip(
        message: "Naar dagweergave",
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _handleTap(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circle Day Number Badge
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainer,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${date.day}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.dayNameShort.toLowerCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.w500,
                          color: isToday
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StickyDayIndicator extends StatelessWidget {
  const StickyDayIndicator({
    super.key,
    required this.date,
    this.topOffset = 0.0,
    this.dayRowKey,
    this.onTap,
  });

  final DateTime date;
  final double topOffset;
  final GlobalKey? dayRowKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return StickyHeaderBox(
      topPadding: topOffset,
      child: DayIndicatorBadge(date: date, onTap: onTap),
    );
  }
}
