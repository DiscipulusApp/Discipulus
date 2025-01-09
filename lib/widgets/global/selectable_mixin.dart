import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

mixin SelectableList<T extends StatefulWidget> on State<T> {
  static SelectableList? maybyOf(BuildContext context) =>
      context.findAncestorStateOfType<SelectableList>();

  List selectedItems = [];

  final GlobalKey<State<StatefulWidget>> sheetKey = GlobalKey();

  List<Widget>? selectionSheetContentBuilder(BuildContext context) {
    return null;
  }

  List<Widget>? headerOptionsBuilder(BuildContext context) {
    return null;
  }

  /// Returns a popScope that will add a clear all selected items when the back
  /// button is pressed.
  Widget selectableListPopScope({required Widget child}) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          selectedItems.clear();
          setState(() {});
        }
      },
      child: child,
    );
  }

  /// Builds the extra padding that is needed to access content behind the option
  /// sheet when shown.
  Widget? buildExtraSheetPadding(BuildContext context) =>
      selectedItems.isNotEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            )
          : null;

  Future<void> showSelectionSheet(BuildContext context) async {
    if (headerOptionsBuilder.call(context) != null ||
        selectionSheetContentBuilder.call(context) != null) {
      // Calculate maxExtent, since DraggableScrollableSheet for some reason can't
      // do this automatically
      double maxExtent = (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) /
          MediaQuery.of(context).size.height;

      // Display the sheet
      await showBottomSheet(
        context: context,
        enableDrag: true,
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
          child: DraggableScrollableSheet(
            key: sheetKey,
            shouldCloseOnMinExtent: false,
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: maxExtent,
            snap: true,
            snapSizes: [.2, maxExtent],
            expand: false,
            builder: (context, scrollController) => StatefulBuilder(
              builder: (context, setState) => SafeArea(
                child: ListView(
                  controller: scrollController,
                  children: [
                    if (headerOptionsBuilder.call(context) != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [...headerOptionsBuilder.call(context)!],
                          ),
                        ),
                      ),
                    if (headerOptionsBuilder.call(context) != null &&
                        selectionSheetContentBuilder.call(context) != null)
                      const Divider(
                        indent: 16,
                        endIndent: 16,
                      ),
                    if (selectionSheetContentBuilder.call(context) != null)
                      ...selectionSheetContentBuilder.call(context)!,
                    const BottomSheetBottomContentPadding()
                  ],
                ),
              ),
            ),
          ),
        ),
      ).closed.then(
        (value) {
          selectedItems.clear();
          setState(() {});
        },
      );
    }
  }
}

mixin SelectableListItem<T extends StatefulWidget> on State<T> {
  dynamic get selectableId;

  bool get isSelected =>
      SelectableList.maybyOf(context)?.selectedItems.contains(selectableId) ??
      false;

  void selection(BuildContext context) {
    SelectableList? list = SelectableList.maybyOf(context);

    if (list != null) {
      // The bron should be selected
      bool selected = list.selectedItems.contains(selectableId);
      bool isFirst = list.selectedItems.isEmpty;

      if (!selected) {
        list.selectedItems.add(selectableId);
      } else {
        list.selectedItems.remove(selectableId);
      }

      if (list.selectedItems.isEmpty && list.sheetKey.currentContext != null) {
        // The selection is now empty, so we should hide the selection sheet
        Navigator.of(list.sheetKey.currentContext!).pop();
      } else if (isFirst) {
        // The selection was empty before, so we still need to show the sheet
        list.showSelectionSheet(context);
      } else {
        // Update the sheet
        list.sheetKey.currentState?.setState(() {});
      }

      setState(() {});
      list.setState(() {});
    }
  }
}

class SelectionSheetBigOption extends StatelessWidget {
  const SelectionSheetBigOption({
    super.key,
    this.onTap,
    required this.title,
    required this.icon,
  });

  final void Function()? onTap;
  final Widget title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 100,
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge!,
                  child: title,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
