import 'dart:io';
import 'dart:ui';

import 'package:discipulus/core/routes.dart';
import 'package:discipulus/widgets/ads/banner_ad_widget.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';

Future<T?> showScrollableModalBottomSheet<T>(
    {required BuildContext context,
    NSUserActivity? activity,
    bool isDismissible = true,
    bool initiallyOpen = false,
    bool modelSheet = true,
    bool useSidePane = true,
    required Widget Function(
      BuildContext context,
      void Function(void Function()) setState,
      ScrollController scrollController,
    ) builder,
    Color? backgroundColor}) async {
  final layoutState = Layout.of(context) ??
      (navKey.currentContext != null
          ? Layout.of(navKey.currentContext!)
          : null);

  if (useSidePane &&
      modelSheet &&
      layoutState != null &&
      layoutState.canShowSecondaryPane(context)) {
    return await layoutState.showSecondaryPane<T>(
      builder: builder,
      showHeader: true,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      activity: activity,
    );
  }

  Widget child = DraggableScrollableSheet(
    initialChildSize: initiallyOpen
        ? 0.8
        : modelSheet
            ? 0.4
            : 0.2,
    minChildSize: 0.2,
    maxChildSize: 1,
    snap: true,
    shouldCloseOnMinExtent: isDismissible,
    snapSizes: const [.4, 1],
    expand: false,
    builder: (context, scrollController) => PrimaryScrollController(
      controller: scrollController,
      child: StatefulBuilder(
        builder: (context, setState) =>
            builder(context, setState, scrollController),
      ),
    ),
  );

  if (modelSheet) {
    // Set activity
    if (Platform.isIOS || Platform.isMacOS) {
      activity?.becomeCurrent();
    }

    // Show the sheet
    T? value = await showModalBottomSheet(
      backgroundColor: backgroundColor,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      isDismissible: isDismissible,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: Theme.of(context).bottomSheetTheme.shape,
      builder: (context) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown,
            PointerDeviceKind.stylus
          },
        ),
        child: InverseCardElevation(child: child),
      ),
    );

    // Remove the activity
    if (activity != null && (Platform.isIOS || Platform.isMacOS)) {
      await FlutterAppleHandoff.updateActivity(null);
    }

    return value;
  } else {
    Scaffold.of(context).showBottomSheet(
      backgroundColor: backgroundColor,
      elevation: 1,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: Theme.of(context).bottomSheetTheme.shape,
      (context) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown,
            PointerDeviceKind.stylus
          },
        ),
        child: SafeArea(
          bottom: false,
          child: child,
        ),
      ),
    );
    return null;
  }
}

class BottomSheetBottomContentPadding extends StatelessWidget {
  const BottomSheetBottomContentPadding({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: BannerAdWidget.of(context)?.isEnabled() == true
            ? 0
            : MediaQuery.of(context).viewPadding.bottom + 16,
      );
}

Future dropdownSheet(context,
        {String? title,
        List<RadioListTile> Function(void Function(void Function()) setState)?
            radioListTiles}) =>
    showScrollableModalBottomSheet(
      context: context,
      builder: (context, modelSetState, controller) {
        return ListView(
          controller: controller,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ...(radioListTiles?.call(modelSetState) ?? []),
          ],
        );
      },
    );

/// Shows a view in the supporting side pane on wide screens (if 3-pane layout is available),
/// or pushes it to the navigator on compact/mobile screens.
Future<T?> showSideView<T>({
  required BuildContext context,
  required Widget child,
  Color? backgroundColor,
  bool isDismissible = true,
  NSUserActivity? activity,
}) async {
  final layoutState = Layout.of(context) ??
      (navKey.currentContext != null
          ? Layout.of(navKey.currentContext!)
          : null);

  if (layoutState != null && layoutState.canShowSecondaryPane(context)) {
    return await layoutState.showSecondaryPane<T>(
      builder: (context, setState, scrollController) => child,
      showHeader: false,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      activity: activity,
    );
  } else {
    return await Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (context) => child),
    );
  }
}

extension SideViewWidgetExtension on Widget {
  /// Opens this widget in the supporting side pane on wide screens,
  /// or pushes it to the Navigator on mobile screens.
  Future<T?> pushSideView<T>(
    BuildContext? context, {
    Color? backgroundColor,
    bool isDismissible = true,
    NSUserActivity? activity,
  }) =>
      showSideView<T>(
        context: context ?? navKey.currentContext!,
        child: this,
        backgroundColor: backgroundColor,
        isDismissible: isDismissible,
        activity: activity,
      );
}

