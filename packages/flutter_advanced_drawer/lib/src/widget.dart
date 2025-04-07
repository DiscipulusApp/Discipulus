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
    this.childDecoration,
    this.animateChildDecoration = true,
    this.rtlOpening = false,
    this.disabledGestures = false,
    this.animationController,
    // Adjusted SpringDescription for a potentially bouncier feel
    this.springDescription = const SpringDescription(
      mass: 5,
      stiffness: 100, // Increased stiffness for quicker response
      damping:
          22, // Adjusted damping (slightly underdamped relative to stiffness)
    ),
  }) : super(key: key);

  /// Child widget. (Usually widget that represent a screen)
  final Widget child;

  /// Drawer widget. (Widget behind the [child]).
  final Widget drawer;

  /// Controller that controls widget state.
  final AdvancedDrawerController? controller;

  /// Backdrop color.
  final Color? backdropColor;

  /// Backdrop widget for custom background.
  final Widget? backdrop;

  /// Opening ratio (fraction of screen width).
  final double openRatio;

  /// Scale factor for the child widget when the drawer is open.
  final double openScale;

  /// Child container decoration in open widget state.
  final BoxDecoration? childDecoration;

  /// Indicates that [childDecoration] might be animated or not.
  /// NOTICE: It may cause animation jerks if complex.
  final bool animateChildDecoration;

  /// Opening from Right-to-left.
  final bool rtlOpening;

  /// Disable gestures.
  final bool disabledGestures;

  /// Optional external controller for the animation.
  final AnimationController? animationController;

  /// Describes the spring physics properties (mass, stiffness, damping).
  final SpringDescription springDescription;

  @override
  _AdvancedDrawerState createState() => _AdvancedDrawerState();
}

class _AdvancedDrawerState extends State<AdvancedDrawer>
    with TickerProviderStateMixin {
  // Controllers
  late AdvancedDrawerController _drawerController; // Use a local final variable
  late AnimationController _animationController;
  // Keep track if controllers were provided externally to manage disposal
  bool _isExternalDrawerController = false;
  bool _isExternalAnimationController = false;

  // Animations
  late Animation<double> _drawerScaleAnimation;
  late Animation<double> _drawerFadeAnimation;
  late Animation<Offset> _childSlideAnimation;
  late Animation<double> _childScaleAnimation;
  late Animation<Decoration> _childDecorationAnimation;

  // Drag state
  double _offsetValueDuringDrag = 0.0; // Tracks animation value during drag
  Offset? _startPosition; // Drag start position
  bool _captured = false; // Whether a drag is currently active

  @override
  void initState() {
    super.initState();
    _isExternalDrawerController = widget.controller != null;
    _isExternalAnimationController = widget.animationController != null;

    _drawerController = widget.controller ?? AdvancedDrawerController();
    _initAnimationController(); // Initialize _animationController
    _updateAnimations(); // Setup tweens based on the controller

    _drawerController.addListener(_handleDrawerControllerChanged);
    // Set initial animation value based on controller state AFTER init
    _animationController.value = _drawerController.value.visible ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant AdvancedDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsAnimationUpdate = false;

    // --- Handle Drawer Controller Changes ---
    if (widget.controller != oldWidget.controller) {
      // Remove listener from the old controller if it was internal or different
      if (!_isExternalDrawerController ||
          oldWidget.controller != widget.controller) {
        (oldWidget.controller ?? _drawerController)
            .removeListener(_handleDrawerControllerChanged);
      }

      _isExternalDrawerController = widget.controller != null;
      final oldInternalController = _isExternalDrawerController
          ? _drawerController
          : null; // Store ref if replacing internal
      _drawerController = widget.controller ??
          (oldInternalController ??
              AdvancedDrawerController()); // Reuse or create new internal

      // Add listener to the new controller
      _drawerController.addListener(_handleDrawerControllerChanged);
      // Sync animation state
      _animationController.value = _drawerController.value.visible ? 1.0 : 0.0;

      // Dispose old internal controller if it was replaced by an external one
      if (oldInternalController != null && _isExternalDrawerController) {
        // Delay disposal slightly to avoid issues if listener is still pending
        WidgetsBinding.instance.addPostFrameCallback((_) {
          oldInternalController.dispose();
        });
      }
    }

    // --- Handle Animation Controller Changes ---
    if (widget.animationController != oldWidget.animationController) {
      // Dispose internal animation controller if it's being replaced or no longer needed
      if (!_isExternalAnimationController) {
        _animationController.removeListener(
            _handleDrawerControllerChanged); // Ensure listener removed before dispose
        _animationController.dispose();
      }

      _isExternalAnimationController = widget.animationController != null;
      _initAnimationController(); // Re-initialize _animationController
      _animationController.value = _drawerController.value.visible ? 1.0 : 0.0;
      needsAnimationUpdate = true; // Animations depend on the controller
    }

    // --- Handle Animation Parameter Changes ---
    if (widget.openRatio != oldWidget.openRatio ||
        widget.openScale != oldWidget.openScale ||
        widget.childDecoration != oldWidget.childDecoration ||
        widget.springDescription !=
            oldWidget.springDescription || // Check springDescription too
        widget.animateChildDecoration != oldWidget.animateChildDecoration) {
      needsAnimationUpdate = true;
    }

    // --- Update Animations if Needed ---
    if (needsAnimationUpdate) {
      _updateAnimations();
    }
  }

  // --- Initialization Helpers ---

  void _initAnimationController() {
    _animationController = widget.animationController ??
        AnimationController(
          vsync: this,
          // Value set after listener is added in initState/didUpdateWidget
        );

    // Check vsync compatibility if external controller is provided
    if (_isExternalAnimationController) {
      // Throwing an error is often better for developers than a silent warning.
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
            'External AnimationController provided to AdvancedDrawer has incorrect vsync.'),
        ErrorDescription(
            'The AnimationController instance provided to the `animationController` property of AdvancedDrawer '
            'must use the same TickerProvider (vsync) as the _AdvancedDrawerState. '
            'Typically, this means the State hosting the AdvancedDrawer should mixin TickerProviderStateMixin '
            'and pass `this` as the vsync argument when creating the AnimationController.'),
      ]);
    }
  }

  void _updateAnimations() {
    // Use the animation controller directly as the parent animation.
    // The physics simulation will drive this controller's value.
    // The Linear curve ensures the Tweens map linearly to the controller's value.
    final parentAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );

    // Drawer Animations
    _drawerScaleAnimation = Tween<double>(
      begin: 0.75, // Keep drawer slightly scaled down when closed
      end: 1.0,
    ).animate(parentAnimation);

    _drawerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(parentAnimation);

    // Child Animations
    _childSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(widget.openRatio, 0),
    ).animate(parentAnimation);

    _childScaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.openScale,
    ).animate(parentAnimation);

    // Child Decoration Animation (if enabled and decoration exists)
    _childDecorationAnimation = DecorationTween(
      begin: const BoxDecoration(), // Start with no decoration
      end: widget.childDecoration ?? const BoxDecoration(), // End decoration
    ).animate(parentAnimation);
    // Note: The AnimatedBuilder later decides whether to use this animated value
    // or the static widget.childDecoration based on widget.animateChildDecoration.
  }

  // --- Animation Control ---

  void _runSpringAnimation({required double target, double velocity = 0.0}) {
    // Stop any existing animation (like tweens) before starting physics simulation
    _animationController.stop();

    // Create the spring simulation using the widget's springDescription
    final simulation = SpringSimulation(
      widget.springDescription,
      _animationController.value, // Current position
      target, // Target position (0.0 for hidden, 1.0 for visible)
      velocity, // Initial velocity from gesture or 0.0
    );

    // Run the simulation. The controller's value will be driven by this.
    // The controller will tick, and the tweens will update accordingly.
    // `animateWith` respects the controller's bounds (0.0, 1.0) but the
    // simulation itself can overshoot these internally before settling.
    _animationController.animateWith(simulation);
  }

  // --- Listener & Gesture Handlers ---

  void _handleDrawerControllerChanged() {
    if (!mounted) return;

    final target = _drawerController.value.visible ? 1.0 : 0.0;
    final currentValue = _animationController.value;

    // Only animate if the state needs to change
    if (currentValue != target && !_animationController.isAnimating) {
      // Trigger the spring animation towards the target with zero initial velocity
      // (since this change is programmatic, not from a gesture).
      _runSpringAnimation(target: target, velocity: 0.0);
    }
    // If it's already animating, let the current animation finish or be overridden
    // by user gestures. Avoid starting a new programmatic animation if one is running.
  }

  void _handleDragStart(DragStartDetails details) {
    if (widget.disabledGestures) return;
    _captured = true;
    _startPosition = details.globalPosition;
    _offsetValueDuringDrag = _animationController.value;
    // Stop any ongoing animation when dragging starts
    _animationController.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_captured || !mounted || widget.disabledGestures) return;

    final screenSize = MediaQuery.of(context).size;
    if (screenSize.width <= 0) return; // Avoid division by zero

    final currentPosition = details.globalPosition;
    final diff = (currentPosition - _startPosition!).dx;

    // Calculate the new value based on drag delta relative to the open width
    final openWidth = screenSize.width * widget.openRatio;
    if (openWidth <= 0) return; // Avoid division by zero

    final dragValueDelta = (diff / openWidth) * (widget.rtlOpening ? -1 : 1);
    final newValue = _offsetValueDuringDrag + dragValueDelta;

    // Update the animation controller's value directly during drag, clamping it
    // visually to the 0-1 range. The physics simulation handles bounce later.
    _animationController.value = newValue.clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_captured || !mounted || widget.disabledGestures) return;
    _captured = false;

    final screenSize = MediaQuery.of(context).size;
    if (screenSize.width <= 0) return; // Avoid issues if width is zero

    final currentVal = _animationController.value;
    final velocityPixelsPerSecond = details.primaryVelocity ?? 0.0;

    // Calculate velocity in terms of animation value units per second
    final openWidth = screenSize.width * widget.openRatio;
    final double velocity = (openWidth > 0)
        ? (velocityPixelsPerSecond / openWidth) * (widget.rtlOpening ? -1 : 1)
        : 0.0;

    // Determine the target state (open or closed) based on position and velocity
    bool isOpening;
    // Velocity threshold to determine fling override
    // Adjust this value to control fling sensitivity
    const flingVelocityThreshold = 0.5; // units per second
    const positionThreshold = 0.5; // Position threshold if velocity is low

    if (velocity.abs() > flingVelocityThreshold) {
      // If fling velocity is high enough, open/close based on direction
      isOpening = velocity > 0;
    } else {
      // If velocity is low, decide based on current position relative to threshold
      isOpening = currentVal >= positionThreshold;
    }

    final target = isOpening ? 1.0 : 0.0;

    // Update the drawer controller state *immediately* if it doesn't match the target.
    // This ensures ValueListenableBuilders using the controller react instantly.
    if (_drawerController.value.visible != isOpening) {
      // Use the setter, which notifies listeners
      _drawerController.value = isOpening
          ? AdvancedDrawerValue.visible()
          : AdvancedDrawerValue.hidden();
      // Note: _handleDrawerControllerChanged might be triggered, but the animation
      // started below with velocity should take precedence.
    }

    // Run the spring animation from the current position with the calculated velocity
    _runSpringAnimation(target: target, velocity: velocity);
  }

  void _handleDragCancel() {
    if (!_captured || widget.disabledGestures) return;
    _captured = false;

    // Animate to the nearest state (open/closed) based on current position
    final currentVal = _animationController.value;
    const positionThreshold = 0.5;
    final isOpening = currentVal >= positionThreshold;
    final target = isOpening ? 1.0 : 0.0;

    // Update controller state if needed
    if (_drawerController.value.visible != isOpening) {
      _drawerController.value = isOpening
          ? AdvancedDrawerValue.visible()
          : AdvancedDrawerValue.hidden();
    }

    // Animate with zero velocity
    _runSpringAnimation(target: target, velocity: 0.0);
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    // Ensure listener is attached (important after potential didUpdateWidget changes)
    // This check prevents adding multiple listeners if build is called without didUpdateWidget
    if (!_drawerController.hasListeners) {
      _drawerController.addListener(_handleDrawerControllerChanged);
    }

    return Material(
      color: widget.backdropColor,
      child: GestureDetector(
        // Use DragStartBehavior.down to capture drag start immediately
        dragStartBehavior: DragStartBehavior.down,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        onHorizontalDragCancel: _handleDragCancel,
        child: Stack(
          children: [
            // --- BACKDROP ---
            if (widget.backdrop != null) widget.backdrop!,

            // --- DRAWER ---
            // Use AnimatedBuilder to ensure drawer rebuilds when animation ticks
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // Optimization: Only build the drawer part when needed
                // (e.g., could potentially check if _animationController.value > 0)
                // For simplicity, we build it always but rely on transitions.
                return Align(
                  alignment: widget.rtlOpening
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: widget.openRatio,
                    child: ScaleTransition(
                      scale: _drawerScaleAnimation,
                      alignment: widget.rtlOpening
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: FadeTransition(
                        opacity: _drawerFadeAnimation,
                        // Use RepaintBoundary for performance optimization
                        child: RepaintBoundary(
                          child: widget.drawer,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // --- CHILD ---
            // Use AnimatedBuilder for the child as well, to handle tap-to-close,
            // absorb pointer, and animated decoration correctly based on animation value.
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // Only allow tapping to close if the drawer is significantly open
                final canTapToClose = _animationController.value > 0.5;
                // Absorb pointers only when drawer is mostly open to prevent interaction bleed
                final absorbPointers = _animationController.value > 0.9;

                // Apply transformations using Transition widgets linked to the animation controller
                Widget transformedChild = SlideTransition(
                  position: _childSlideAnimation,
                  textDirection:
                      widget.rtlOpening ? TextDirection.rtl : TextDirection.ltr,
                  child: ScaleTransition(
                    scale: _childScaleAnimation,
                    alignment: widget.rtlOpening
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: InkWell(
                      onTap:
                          canTapToClose ? _drawerController.hideDrawer : null,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      child: Container(
                        clipBehavior: widget.childDecoration != null
                            ? Clip.antiAlias
                            : Clip.none,
                        // Use animated decoration value if enabled, otherwise static
                        decoration: widget.animateChildDecoration
                            ? _childDecorationAnimation.value
                            : widget.childDecoration,
                        child: AbsorbPointer(
                          absorbing: absorbPointers,
                          child: RepaintBoundary(child: widget.child),
                        ),
                      ),
                    ),
                  ),
                );

                // Wrap with InkWell for tap-to-close functionality
                return transformedChild;
              },
              // Pass the original child widget here, it will be used by the builder
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }

  // --- Dispose ---

  @override
  void dispose() {
    _drawerController.removeListener(_handleDrawerControllerChanged);

    // Dispose the internal animation controller only if it wasn't provided externally
    if (!_isExternalAnimationController) {
      _animationController.dispose();
    }
    // Dispose the internal drawer controller only if it wasn't provided externally
    if (!_isExternalDrawerController) {
      _drawerController.dispose();
    }

    super.dispose();
  }
}
