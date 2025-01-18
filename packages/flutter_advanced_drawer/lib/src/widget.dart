part of '../flutter_advanced_drawer.dart';

/// AdvancedDrawer widget.
class AdvancedDrawer extends StatefulWidget {
  const AdvancedDrawer({
    Key? key,
    required this.child,
    required this.drawer,
    this.controller,
    this.backdropColor,
    this.backdrop,
    this.openRatio = 0.75,
    this.openScale = 0.85,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve,
    this.childDecoration,
    this.animateChildDecoration = true,
    this.rtlOpening = false,
    this.disabledGestures = false,
    this.disableFling = false,
    this.animationController,
  }) : super(key: key);

  final Widget child;
  final Widget drawer;
  final AdvancedDrawerController? controller;
  final Color? backdropColor;
  final Widget? backdrop;
  final double openRatio;
  final double openScale;
  final Duration animationDuration;
  final Curve? animationCurve;
  final BoxDecoration? childDecoration;
  final bool animateChildDecoration;
  final bool rtlOpening;
  final bool disabledGestures;
  final bool disableFling;
  final AnimationController? animationController;

  @override
  _AdvancedDrawerState createState() => _AdvancedDrawerState();
}

class _AdvancedDrawerState extends State<AdvancedDrawer>
    with TickerProviderStateMixin {
  final _spareController = AdvancedDrawerController();

  AnimationController? _spareAnimationController;
  AnimationController? _animationController;

  Animation<double>? _drawerScaleAnimation;
  Animation<double>? _drawerFadeAnimation;
  Animation<Offset>? _childSlideAnimation;
  Animation<double>? _childScaleAnimation;
  Animation<Decoration>? _childDecorationAnimation;

  late double _offsetValue;
  late Offset _freshPosition;

  bool _captured = false;
  Offset? _startPosition;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AdvancedDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _controller.addListener(_handleControllerChanged);
    }
    if (widget.animationController != oldWidget.animationController) {
      _animationController = null; // Reset to recreate on-demand
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backdropColor,
      child: GestureDetector(
        onHorizontalDragStart:
            widget.disabledGestures ? null : _handleDragStart,
        onHorizontalDragUpdate:
            widget.disabledGestures ? null : _handleDragUpdate,
        onHorizontalDragEnd: widget.disabledGestures ? null : _handleDragEnd,
        onHorizontalDragCancel:
            widget.disabledGestures ? null : _handleDragCancel,
        child: Stack(
          children: [
            if (widget.backdrop != null) widget.backdrop!,
            Align(
              alignment: widget.rtlOpening
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: widget.openRatio,
                child: ScaleTransition(
                  scale: _drawerScaleAnimation!,
                  alignment: widget.rtlOpening
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: FadeTransition(
                    opacity: _drawerFadeAnimation!,
                    child: RepaintBoundary(
                      child: widget.drawer,
                    ),
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _childSlideAnimation!,
              textDirection:
                  widget.rtlOpening ? TextDirection.rtl : TextDirection.ltr,
              child: ScaleTransition(
                scale: _childScaleAnimation!,
                alignment: widget.rtlOpening
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  clipBehavior: widget.childDecoration != null
                      ? Clip.antiAlias
                      : Clip.none,
                  decoration: widget.animateChildDecoration &&
                          widget.childDecoration != null
                      ? _childDecorationAnimation?.value
                      : widget.childDecoration,
                  child: RepaintBoundary(
                    child: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: _controller,
                      builder: (_, value, __) {
                        return InkWell(
                          onTap: value.visible ? _controller.hideDrawer : null,
                          overlayColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                          child: AbsorbPointer(
                            absorbing: value.visible,
                            child: widget.child,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AdvancedDrawerController get _controller {
    return widget.controller ?? _spareController;
  }

  AnimationController get _getSpareAnimationController {
    if (_spareAnimationController == null) {
      _spareAnimationController = AnimationController(
        vsync: this,
        value: _controller.value.visible ? 1 : 0,
      );
    }
    return _spareAnimationController!;
  }

  AnimationController get _getAnimationController {
    if (_animationController == null) {
      _animationController =
          widget.animationController ?? _getSpareAnimationController;
      _animationController!.reverseDuration =
          _animationController!.duration = widget.animationDuration;
      _initAnimations();
    }
    return _animationController!;
  }

  void _initAnimations() {
    final parentAnimation = widget.animationCurve == null
        ? _getAnimationController
        : CurvedAnimation(
            curve: widget.animationCurve!,
            parent: _getAnimationController,
          );

    _drawerScaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(parentAnimation);

    _drawerFadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(parentAnimation);

    _childSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(widget.openRatio, 0),
    ).animate(parentAnimation);

    _childScaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.openScale,
    ).animate(parentAnimation);

    if (widget.animateChildDecoration && widget.childDecoration != null) {
      _childDecorationAnimation = DecorationTween(
        begin: const BoxDecoration(),
        end: widget.childDecoration,
      ).animate(parentAnimation);
    }
  }

  void _handleControllerChanged() {
    if (context.mounted) {
      _controller.value.visible
          ? _getAnimationController.forward()
          : _getAnimationController.reverse();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _captured = true;
    _startPosition = details.globalPosition;
    _offsetValue = _getAnimationController.value;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_captured) return;

    final screenSize = MediaQuery.of(context).size; // Cache MediaQuery
    _freshPosition = details.globalPosition;

    final diff = (_freshPosition - _startPosition!).dx;
    _getAnimationController.value = _offsetValue +
        (diff / (screenSize.width * widget.openRatio)) *
            (widget.rtlOpening ? -1 : 1);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_captured) return;

    _captured = false;

    double velocity = details.primaryVelocity! * (widget.rtlOpening ? -1 : 1);
    bool isOpening = _getAnimationController.value >= 0.5;
    if (velocity.abs() >= kMinFlingVelocity && !widget.disableFling) {
      isOpening = velocity > 0;
    }

    if (isOpening) {
      if (mounted) _controller.showDrawer();
    } else {
      if (mounted) _controller.hideDrawer();
    }
  }

  void _handleDragCancel() {
    _captured = false;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _spareAnimationController?.dispose();
    super.dispose();
  }
}
