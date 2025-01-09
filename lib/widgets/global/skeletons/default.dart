import 'dart:async';
import 'dart:io';

import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// This is just a wrapper for a [ValueKey], but when this is used for a child
/// of [ScaffoldSkeleton] it will be ignored for the child count, so we will
/// know when the list of children is actually empty.
class HeaderKey<T> extends ValueKey {
  const HeaderKey({this.noPadding = false}) : super(null);

  final bool noPadding;
}

/// Can be used in combination with [ScaffoldSkeleton] to use the refresh
/// indicators built by it.
mixin ExternalRefresh<T extends StatefulWidget> on State<T> {
  late final ValueNotifier<bool> isLoadingExternally;

  @override
  void initState() {
    isLoadingExternally = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    isLoadingExternally.dispose();
    super.dispose();
  }

  static ExternalRefresh? maybyOf(BuildContext context) =>
      context.findAncestorStateOfType<ExternalRefresh>();
}

/// Enables child widgets to update the top widgets. Keep in mind that is should
/// not be used everywhere a callback is needed, as this can be very expensive.
/// A small change in a widget does not mean that the whole view should be
/// reloaded.
mixin ChildCallback<T extends StatefulWidget> on State<T> {
  FutureOr<void> callback() {}

  static FutureOr<void> upperCallBack(BuildContext context,
          [void Function()? fn]) async =>
      await context.findAncestorStateOfType<ChildCallback>()?.callback();

  static void parentSetState(BuildContext context, [VoidCallback? fn]) {
    final state = context.findAncestorStateOfType<ChildCallback>();
    if (state != null) {
      state.setState(fn ?? () {});
    }
  }
}

class ScaffoldSkeleton extends StatefulWidget {
  const ScaffoldSkeleton({
    super.key,
    this.customBuilder,
    required this.children,
    this.fetch,
    this.appBar,
    this.padding,
    this.emptyBuilder,
    this.activity,
    this.extraSlivers = const [],
    this.noWait = false,
    this.noInitialFetch = false,
    this.scrollController,
  });

  /// If custom properties need to be set in the scaffold, this property can be
  /// used.
  final Widget Function(Widget body)? customBuilder;

  /// This contains the children of the scaffold. To differentiate between
  /// elements in a list and widgets that are permenant you can use the
  /// [HeaderKey].
  final List<Widget> children;

  /// This property can be used for fetching of the required data.
  final Future<void> Function(bool isOffline)? fetch;

  /// With this property you can set an appBar.
  /// The trailing widget will be a refresh button that will be visible on
  /// desktops.
  /// The leading widget will be a button that triggers the drawer on smaller
  /// views.
  final SliverAppBar Function(
          bool isRefreshing, Widget? trailingRefreshButton, Widget? leading)?
      appBar;

  /// This can be used to add padding to all children, unless specified
  /// otherwise in the [HeaderKey].
  final EdgeInsetsGeometry? padding;

  /// Get the padding, but non-null
  EdgeInsetsGeometry getpadding([Key? key]) {
    if (padding != null &&
        ((key.runtimeType == HeaderKey &&
                (key as HeaderKey).noPadding == false) ||
            key.runtimeType != HeaderKey)) {
      return padding!;
    } else {
      return EdgeInsets.zero;
    }
  }

  /// This will be built when the list is empty otherwise it will display a
  /// default message, telling the user that the screen is empty.
  final Widget Function()? emptyBuilder;

  /// This is used to indicate to handoff what the current activity is.
  final NSUserActivity? activity;

  /// This can be used in certain circumstances where slivers are necessary.
  final List<Widget> extraSlivers;

  /// To prevent unwanted load on the server we can wait before performing the
  /// initial fetch. In some view though, this is not needed.
  final bool noWait;

  /// Whether or not an initial fetch should be performed.
  final bool noInitialFetch;

  /// The scroll controller for the list.
  final ScrollController? scrollController;

  @override
  State<ScaffoldSkeleton> createState() => _ScaffoldSkeletonState();
}

class _ScaffoldSkeletonState extends State<ScaffoldSkeleton> {
  /// Whether or not a refresh is taking place
  ///   0 - not refreshing
  ///   1 - refreshing though pull action
  ///   2 - refreshing though other ways
  final ValueNotifier<int> isRefreshing = ValueNotifier<int>(0);

  /// Whether or not the device is in an offline state
  final ValueNotifier<bool> isOffline = ValueNotifier<bool>(false);
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  void _externalRefreshListener() {
    if (ExternalRefresh.maybyOf(context)?.isLoadingExternally.value ?? false) {
      if (mounted) isRefreshing.value = 2;
    } else {
      if (mounted) isRefreshing.value = 0;
    }
  }

  void _connectivityListener(List<ConnectivityResult> result) {
    if (result.every(
      (e) => e == ConnectivityResult.none,
    )) {
      // Device is offline
      isOffline.value = true;
    } else if (isOffline.value) {
      // Device is back online
      isOffline.value = false;
    }
  }

  Future<void> _fetch({int type = 2, bool wait = false}) async {
    // To prevent a DDOS attack due to bored students that just switch between
    // views, we will only perform the initial fetch after 500ms. This will only
    // happen when the `wait` property is set to true. After the 500ms we can
    // check if the widget us still mounted, if so, then we will perform the
    // fetch.
    if (wait) {
      Future.delayed(const Duration(milliseconds: 500), _fetch);
    }
    if (mounted && isRefreshing.value == 0) {
      isRefreshing.value = type;
      try {
        await widget.fetch?.call(wait ? wait : isOffline.value);
      } catch (e) {
        if (mounted) isRefreshing.value = 0;
        rethrow;
      }
      if (mounted) isRefreshing.value = 0;
    }
  }

  @override
  void initState() {
    // Setup refreshing indicator
    ExternalRefresh.maybyOf(context)
        ?.isLoadingExternally
        .addListener(_externalRefreshListener);

    // Setup offline indicator
    _subscription =
        Connectivity().onConnectivityChanged.listen(_connectivityListener);
    Future(() async =>
        _connectivityListener(await Connectivity().checkConnectivity()));

    // Perform the initial fetch
    if (!widget.noInitialFetch) {
      _fetch(wait: !widget.noWait);
    }

    super.initState();
  }

  @override
  void dispose() {
    isRefreshing.dispose();
    isOffline.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HandoffFocus(
      activity: widget.activity,
      onForegroundGained: _fetch,
      child: Builder(
        builder: (context) {
          if (widget.customBuilder != null) {
            return widget.customBuilder!.call(_childBuilder(context));
          }
          return Scaffold(
            primary: false,
            body: _childBuilder(context),
          );
        },
      ),
    );
  }

  Widget? _appBarBuilder(BuildContext context) {
    return DefaultTextStyle(
      maxLines: 2,
      style: const TextStyle(overflow: TextOverflow.ellipsis),
      child: ValueListenableBuilder(
        valueListenable: isRefreshing,
        builder: (context, value, _) => widget.appBar?.call(
          value != 0,
          _refreshButtonBuilder(),
          leadingAppBarButton(context),
        ) as Widget,
      ),
    );
  }

  /// On desktop refreshing with the mouse is not supported, so a button is added instead.
  Widget? _refreshButtonBuilder() => widget.fetch == null
      ? null
      : ValueListenableBuilder<bool>(
          valueListenable: isOffline,
          builder: (context, isOffline, child) {
            return ValueListenableBuilder<int>(
              valueListenable: isRefreshing,
              builder: (context, value, child) {
                return AnimatedSwitcher(
                  duration: Durations.short3,
                  switchInCurve: Easing.standard,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: IconButton(
                    key: ValueKey(value),
                    icon: isOffline
                        ? const Icon(Icons.wifi_off_outlined)
                        : value == 2
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  strokeCap: StrokeCap.round,
                                ),
                              )
                            : (Platform.isAndroid || Platform.isIOS)
                                ? const SizedBox()
                                : const Icon(Icons.sync),
                    onPressed: value != 0 ? null : _fetch,
                  ),
                );
              },
            );
          });

  Widget _buildEmpty(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: isRefreshing,
      builder: (context, isRefreshing, child) {
        if (isRefreshing == 2) {
          // Something is being loaded
          return const ScaffoldSkeletonEmptyLoadingIndicator();
        }
        // No loading is taking place, or the refresh already has an indicator
        return widget.emptyBuilder != null &&
                widget.emptyBuilder!().runtimeType != Text
            ? widget.emptyBuilder!()
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        child: widget.emptyBuilder != null
                            ? widget.emptyBuilder!()
                            : const Text(
                                "Hmm, hier is niet veel te zien",
                              ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _childBuilder(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: BouncingScrollPhysics(
        parent:
            widget.fetch != null ? const AlwaysScrollableScrollPhysics() : null,
        decelerationRate: Platform.isAndroid
            ? ScrollDecelerationRate.fast
            : ScrollDecelerationRate.normal,
      ),
      slivers: [
        // Build the appbar
        _appBarBuilder(context) as Widget,

        // Build the refresh controller
        if (widget.fetch != null)
          CupertinoSliverRefreshControl(
            onRefresh: () => _fetch(type: 1),
          ),

        // Build the children, plus one, because we will add padding.
        SliverPadding(
          padding:
              EdgeInsets.symmetric(vertical: widget.getpadding().vertical / 2),
          sliver: SliverList.builder(
            itemCount: widget.children.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      widget.getpadding(widget.children[index].key).horizontal /
                          2,
                ),
                child: widget.children[index],
              );
            },
          ),
        ),

        // Sometimes there is no other alternative then using slivers as a body,
        // so when that is necessary we will put those here
        ...widget.extraSlivers,

        const SliverToBoxAdapter(child: BottomSheetBottomContentPadding()),

        // When the list of children is empty we will add a screen-filling
        // message
        if (widget.children
                .where((e) => e.key.runtimeType != HeaderKey)
                .isEmpty &&
            widget.extraSlivers.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmpty(context),
          ),
      ],
    );
  }
}

class ScaffoldSkeletonEmptyLoadingIndicator extends StatelessWidget {
  const ScaffoldSkeletonEmptyLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
            ),
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
