import 'dart:io';

import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RefreshableCustomScrollView extends StatefulWidget {
  const RefreshableCustomScrollView(
      {super.key,
      this.onRefresh,
      this.appBar,
      required this.children,
      this.slivers = const [],
      this.isExternalRefreshing,
      this.injectOverlap = false});

  final Future<void> Function()? onRefresh;
  final ValueNotifier<bool>? isExternalRefreshing;
  final SliverAppBar Function(bool isRefreshing, List<Widget> trailingButton)?
      appBar;
  final List<Widget>? children;
  final List<Widget> slivers;
  final bool injectOverlap;

  @override
  State<RefreshableCustomScrollView> createState() =>
      _RefreshableCustomScrollViewState();
}

class _RefreshableCustomScrollViewState
    extends State<RefreshableCustomScrollView> {
  /// Whether or not a refresh is taking place
  ///   0 - not refreshing
  ///   1 - refreshing though pull action
  ///   2 - refreshing though other ways
  final ValueNotifier<int> isRefreshing = ValueNotifier<int>(0);

  /// On desktop refreshing with the mouse is not supported, so a button is added instead.
  Widget _getRefreshButton() => AnimatedSwitcher(
        duration: Durations.short3,
        switchInCurve: Easing.standard,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: IconButton(
          key: ValueKey(isRefreshing.value),
          icon: isRefreshing.value == 2
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    strokeCap: StrokeCap.round,
                  ),
                )
              : const Icon(Icons.sync),
          onPressed: isRefreshing.value != 0
              ? null
              : () async {
                  isRefreshing.value = 2;
                  await widget.onRefresh!.call();
                  isRefreshing.value = 0;
                },
        ),
      );

  @override
  initState() {
    if (widget.isExternalRefreshing != null) {
      isRefreshing.value = widget.isExternalRefreshing!.value ? 2 : 0;
      widget.isExternalRefreshing?.addListener(() {
        isRefreshing.value = widget.isExternalRefreshing!.value ? 2 : 0;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    isRefreshing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(
          parent: widget.onRefresh != null
              ? const AlwaysScrollableScrollPhysics()
              : null,
          decelerationRate: Platform.isAndroid
              ? ScrollDecelerationRate.fast
              : ScrollDecelerationRate.normal),
      slivers: [
        if (widget.appBar != null)
          DefaultTextStyle(
            maxLines: 2,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            child: ValueListenableBuilder(
              valueListenable: isRefreshing,
              builder: (context, value, child) {
                return widget.appBar!.call(
                  value != 0,
                  (Platform.isLinux ||
                          Platform.isWindows ||
                          Platform.isMacOS ||
                          isRefreshing.value == 2)
                      ? [_getRefreshButton()]
                      : [],
                );
              },
            ),
          ),
        if (widget.injectOverlap)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (widget.onRefresh != null)
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              isRefreshing.value = 1;
              await widget.onRefresh!.call();
              isRefreshing.value = 0;
            },
          ),
        ...widget.slivers,
        if (widget.children != null && widget.children!.isNotEmpty)
          SliverList.builder(
            itemCount: widget.children!.length + 1,
            itemBuilder: (BuildContext context, int index) =>
                index == widget.children!.length
                    ? const BottomSheetBottomContentPadding()
                    : widget.children![index],
          ),
        if (widget.children != null &&
            (widget.children!
                    .where((e) => e.key != const HeaderKey())
                    .isEmpty ||
                widget.children!.lastOrNull.runtimeType == FilterChipList))
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 64,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                    ),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}

class TabbedScaffoldSkeleton extends StatefulWidget {
  const TabbedScaffoldSkeleton(
      {super.key,
      this.sliverAppBar,
      required this.tabs,
      this.initialIndex = 0,
      this.onIndexChanged,
      this.showTabs = true});

  final SliverAppBar Function(
      TabController tabcontroller,
      bool innerBoxIsScrolled,
      List<Tab> tabs,
      ValueNotifier<Tab> activeTab)? sliverAppBar;

  ///This will run every time the user navigated to a new tab
  final void Function(int index)? onIndexChanged;

  //The initial index of the TabbedScaffoldSkeleton... Kind of speaks for itself
  final int initialIndex;

  ///Name as key, widgets as value
  final Map<Tab, Widget> tabs;

  ///This value has no effect if [sliverAppBar] is not null.
  final bool showTabs;

  @override
  State<TabbedScaffoldSkeleton> createState() => _TabbedScaffoldSkeletonState();
}

class _TabbedScaffoldSkeletonState extends State<TabbedScaffoldSkeleton>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final TabController _tabController;
  late ValueNotifier<Tab> activeTab;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(
        initialIndex: widget.initialIndex,
        vsync: this,
        length: widget.tabs.length)
      ..addListener(() {
        widget.onIndexChanged?.call(_tabController.index);
        activeTab.value = widget.tabs.keys.toList()[_tabController.index];
      });
    activeTab = ValueNotifier(widget.tabs.keys.toList()[_tabController.index]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: widget.sliverAppBar != null
                  ? widget.sliverAppBar!(_tabController, innerBoxIsScrolled,
                      widget.tabs.keys.toList(), activeTab)
                  : SliverAppBar.large(
                      title: ValueListenableBuilder(
                          valueListenable: activeTab,
                          builder: (context, value, child) {
                            return Text(value.text ?? "");
                          }),
                      forceElevated: innerBoxIsScrolled,
                      bottom: widget.showTabs
                          ? TabBar(
                              isScrollable: true,
                              tabAlignment: TabAlignment.center,
                              tabs: widget.tabs.keys.toList(),
                              controller: _tabController,
                            )
                          : null,
                    ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: widget.tabs.values.toList(),
        ),
      ),
    );
  }
}

class SearchBarCard extends StatelessWidget {
  const SearchBarCard({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.search),
              hintText: 'Zoeken',
            ),
          ),
        ));
  }
}

///This widget provides correct scrolling and swiping behavior when scrolling view are placed inside pageview with same direction
///The widget works both for vertical and horizontal scrolling direction
///To use this widget you have to do following:
///* set physics: NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()) argument for both PageView and ScrollView
///* create scrollController for ScrollView and pageController for PageView. Do not forget to dispose then at dispose() State callback
///* make sure that scrolling direction on both views are the same and equals to scrollDirection argument here

class PageViewScrollableChild extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final PageController pageController;
  final Axis scrollDirection;

  const PageViewScrollableChild(
      {super.key,
      required this.scrollController,
      required this.pageController,
      required this.child,
      required this.scrollDirection});

  @override
  State<StatefulWidget> createState() {
    return _PageViewScrollableChildState();
  }
}

class _PageViewScrollableChildState extends State<PageViewScrollableChild> {
  late bool atTheStart;
  late bool atTheEnd;

  ///true if scroll view content does not overscroll screen size
  late bool bothSides;

  ScrollController? activeScrollController;
  Drag? drag;

  @override
  void initState() {
    super.initState();

    atTheStart = true;
    atTheEnd = false;
    bothSides = false;
  }

  void handleDragStart(
      DragStartDetails details, ScrollController scrollController) {
    if (scrollController.hasClients) {
      if (scrollController.position.minScrollExtent == 0 &&
          scrollController.position.maxScrollExtent == 0) {
        bothSides = true;
      } else if (scrollController.position.pixels <=
          scrollController.position.minScrollExtent) {
        atTheStart = true;
      } else if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        atTheEnd = true;
      } else {
        atTheStart = false;
        atTheEnd = false;

        activeScrollController = scrollController;
        drag = activeScrollController?.position.drag(details, disposeDrag);
        return;
      }
    }

    activeScrollController = widget.pageController;
    drag = widget.pageController.position.drag(details, disposeDrag);
  }

  void handleDragUpdate(
      DragUpdateDetails details, ScrollController scrollController) {
    final offset = widget.scrollDirection == Axis.vertical
        ? details.delta.dy
        : details.delta.dx;
    if (offset > 0 && (atTheStart || bothSides)) {
      //Arrow direction is to the bottom.
      //Swiping up.

      activeScrollController = widget.pageController;
      drag?.cancel();
      drag = widget.pageController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          disposeDrag);
    } else if (offset < 0 && (atTheEnd || bothSides)) {
      //Arrow direction is to the top.
      //Swiping down.

      activeScrollController = widget.pageController;
      drag?.cancel();
      drag = widget.pageController.position.drag(
          DragStartDetails(
            globalPosition: details.globalPosition,
            localPosition: details.localPosition,
          ),
          disposeDrag);
    } else if (atTheStart || atTheEnd) {
      activeScrollController = scrollController;
      drag?.cancel();
      drag = scrollController.position.drag(
          DragStartDetails(
            globalPosition: details.globalPosition,
            localPosition: details.localPosition,
          ),
          disposeDrag);
    }

    drag?.update(details);
  }

  void handleDragEnd(DragEndDetails details) {
    drag?.end(details);

    if (atTheStart) {
      atTheStart = false;
    } else if (atTheEnd) {
      atTheEnd = false;
    }
  }

  void handleDragCancel() {
    drag?.cancel();
  }

  void disposeDrag() {
    drag = null;
  }

  @override
  Widget build(BuildContext context) {
    final scrollDirection = widget.scrollDirection;
    return GestureDetector(
      onVerticalDragStart: scrollDirection == Axis.vertical
          ? (details) => handleDragStart(details, widget.scrollController)
          : null,
      onVerticalDragUpdate: scrollDirection == Axis.vertical
          ? (details) => handleDragUpdate(details, widget.scrollController)
          : null,
      onVerticalDragEnd: scrollDirection == Axis.vertical
          ? (details) => handleDragEnd(details)
          : null,
      onHorizontalDragStart: scrollDirection == Axis.horizontal
          ? (details) => handleDragStart(details, widget.scrollController)
          : null,
      onHorizontalDragUpdate: scrollDirection == Axis.horizontal
          ? (details) => handleDragUpdate(details, widget.scrollController)
          : null,
      onHorizontalDragEnd: scrollDirection == Axis.horizontal
          ? (details) => handleDragEnd(details)
          : null,
      child: widget.child,
    );
  }
}
