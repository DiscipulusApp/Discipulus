import 'dart:async';

import 'package:discipulus/utils/app_platform.dart';
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
  final ValueNotifier<String?> refreshError = ValueNotifier<String?>(null);
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  ExternalRefresh? _externalRefresh;
  int _fetchRequestVersion = 0;
  bool _localFetchRunning = false;
  int _localFetchType = 0;

  void _externalRefreshListener() {
    if (!mounted) return;
    isRefreshing.value = _localFetchRunning
        ? _localFetchType
        : (_externalRefresh?.isLoadingExternally.value ?? false)
            ? 2
            : 0;
  }

  void _connectivityListener(List<ConnectivityResult> result) {
    if (!mounted) return;
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
    if (widget.fetch == null) return;
    // A foreground/manual refresh supersedes a pending delayed initial one.
    final requestVersion = ++_fetchRequestVersion;
    if (wait) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    if (!mounted || requestVersion != _fetchRequestVersion ||
        isRefreshing.value != 0) return;
    _localFetchRunning = true;
    _localFetchType = type;
    isRefreshing.value = type;
    refreshError.value = null;
    try {
      await widget.fetch?.call(isOffline.value);
    } catch (error) {
      if (mounted) {
        // Retain cached content and show a recoverable error to the user.
        refreshError.value = 'Vernieuwen mislukt. Controleer je verbinding en probeer het opnieuw.';
        debugPrint('ScaffoldSkeleton refresh failed: $error');
      }
    } finally {
      _localFetchRunning = false;
      if (mounted) _externalRefreshListener();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final current = ExternalRefresh.maybyOf(context);
    if (current != _externalRefresh) {
      _externalRefresh?.isLoadingExternally.removeListener(_externalRefreshListener);
      _externalRefresh = current;
      current?.isLoadingExternally.addListener(_externalRefreshListener);
      _externalRefreshListener();
    }
  }

  @override
  void initState() {
    super.initState();
    // Setup offline indicator
    _subscription =
        Connectivity().onConnectivityChanged.listen(_connectivityListener);
    Connectivity().checkConnectivity().then(
      _connectivityListener,
      onError: (Object error) => debugPrint('Connectivity check failed: $error'),
    );

    // Perform the initial fetch
    if (!widget.noInitialFetch) {
      _fetch(wait: !widget.noWait);
    }
  }

  @override
  void dispose() {
    _externalRefresh?.isLoadingExternally.removeListener(_externalRefreshListener);
    isRefreshing.dispose();
    isOffline.dispose();
    refreshError.dispose();
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
            backgroundColor: Colors.transparent,
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
                    tooltip: isOffline ? 'Offline: lokale gegevens' : 'Vernieuwen',
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
                            : AppPlatform.isMobile
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
        decelerationRate: AppPlatform.isAndroid
            ? ScrollDecelerationRate.fast
            : ScrollDecelerationRate.normal,
      ),
      slivers: [
        // Build the appbar
        _appBarBuilder(context) as Widget,

        // Connection and refresh problems remain visible above cached data.
        ValueListenableBuilder<bool>(
          valueListenable: isOffline,
          builder: (context, offline, _) => SliverToBoxAdapter(
            child: offline
                ? _RefreshNotice(
                    icon: Icons.wifi_off_outlined,
                    message: 'Je bent offline. Opgeslagen gegevens blijven beschikbaar.',
                  )
                : const SizedBox.shrink(),
          ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: refreshError,
          builder: (context, error, _) => SliverToBoxAdapter(
            child: error == null
                ? const SizedBox.shrink()
                : _RefreshNotice(
                    icon: Icons.error_outline,
                    message: error,
                    retry: () => _fetch(),
                  ),
          ),
        ),

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

/// Shared, accessible refresh/connection feedback for every ScaffoldSkeleton.
class _RefreshNotice extends StatelessWidget {
  const _RefreshNotice({required this.icon, required this.message, this.retry});

  final IconData icon;
  final String message;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Semantics(
        liveRegion: true,
        child: Material(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: colors.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(child: Text(message)),
                if (retry != null)
                  TextButton(onPressed: retry, child: const Text('Opnieuw')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
