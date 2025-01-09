import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';

Future<T?> showScrollableModalBottomSheet<T>({
  required BuildContext context,
  NSUserActivity? activity,
  bool isDismissible = true,
  bool initiallyOpen = false,
  bool modelSheet = true,
  required Widget Function(
    BuildContext context,
    void Function(void Function()) setState,
    ScrollController scrollController,
  ) builder,
}) async {
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
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      isDismissible: isDismissible,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: Theme.of(context).bottomSheetTheme.shape,
      builder: (context) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown
          },
        ),
        child: child,
      ),
    );

    // Remove the activity
    if (activity != null && (Platform.isIOS || Platform.isMacOS)) {
      await FlutterAppleHandoff.updateActivity(null);
    }

    return value;
  } else {
    Scaffold.of(context).showBottomSheet(
      elevation: 1,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: Theme.of(context).bottomSheetTheme.shape,
      (context) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown
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
        height: MediaQuery.of(context).viewPadding.bottom + 16,
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
