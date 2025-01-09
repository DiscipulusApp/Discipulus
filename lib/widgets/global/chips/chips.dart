import 'dart:async';

import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_context_menu/super_context_menu.dart';

abstract class DiscipulusFilterChip {}

class CustomDropDownChip extends StatelessWidget {
  const CustomDropDownChip({
    super.key,
    required this.label,
    this.icon,
    this.filled = true,
    this.onPressed,
  });

  final Widget label;
  final Widget? icon;
  final bool filled;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      deleteIcon: const Icon(
        Icons.arrow_drop_down,
        size: 18,
      ), //Dankjewel Google voor het automatisch goed zetten van de grootte
      label: label,
      selected: filled,
      showCheckmark: false,
      avatar: icon != null
          ? IconTheme(
              data: IconTheme.of(context).copyWith(
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              child: icon!,
            )
          : null,
      onDeleted: onPressed,
      onPressed: onPressed,
    );
  }
}

class DropDownChipItem<T> {
  Widget? icon;
  final String title;
  final String? shortTitle;
  final T item;

  final Future<Widget?> Function()? bottomWiget;

  DropDownChipItem({
    required this.title,
    this.shortTitle,
    required this.item,
    this.icon,
    this.bottomWiget,
  });
}

class DropDownChip<T> extends StatefulWidget {
  const DropDownChip({
    super.key,
    required this.items,
    required this.onSelected,
    this.defaultIcon,
    required this.defaultTitle,
    this.emptySelectionAllowed = false,
    this.currentValue,
  });

  final Icon? defaultIcon;
  final String defaultTitle;
  final Future<List<DropDownChipItem<T>>> Function() items;
  final void Function(DropDownChipItem<T>? item) onSelected;
  final DropDownChipItem<T>? currentValue;
  final bool emptySelectionAllowed;

  @override
  State<DropDownChip<T>> createState() => _DropDownChipState<T>();
}

class _DropDownChipState<T> extends State<DropDownChip<T>>
    with SingleTickerProviderStateMixin {
  List<DropDownChipItem<T>?>? _items;
  int _currentIndex = -1;
  int _hoverIndex = -1;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isScrolling = false;
  Timer? _scrollTimer;
  final GlobalKey _chipKey = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.short3,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Easing.standard,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    _items = [if (widget.emptySelectionAllowed) null, ...await widget.items()];
    if (widget.currentValue != null) {
      _currentIndex = _items!
          .map((e) => e?.item)
          .toList()
          .indexOf(widget.currentValue!.item);
    }
    setState(() {});
  }

  void _handleScroll(PointerScrollEvent event) {
    if (_isScrolling) return;
    _isScrolling = true;
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 200), () {
      _isScrolling = false;
    });

    if (_items == null || _items!.isEmpty) return;
    setState(() {
      if (event.scrollDelta.dy > 0) {
        _currentIndex = (_currentIndex - 1).clamp(-1, _items!.length - 1);
      } else {
        _currentIndex = (_currentIndex + 1).clamp(-1, _items!.length - 1);
      }

      widget.onSelected(_currentIndex == -1 ? null : _items![_currentIndex]);
    });
  }

  void _showOverlay(BuildContext context) {
    HapticFeedback.lightImpact();
    final RenderBox renderBox =
        _chipKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _items?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = _items![index];
                    return AnimatedContainer(
                      color: _getItemColor(index),
                      duration: Durations.short1,
                      child: ListTile(
                        dense: true,
                        leading: item?.icon ??
                            (widget.defaultIcon != null
                                ? const SizedBox()
                                : null),
                        minLeadingWidth: 4,
                        title: Text(
                          item?.shortTitle ?? item?.title ?? "Geen",
                          style: Theme.of(context).textTheme.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  Color _getItemColor(int index) {
    Color color = _currentIndex == index
        ? Theme.of(context).colorScheme.primaryContainer
        : Colors.transparent;

    if (_hoverIndex == index) {
      return Color.lerp(color, Theme.of(context).colorScheme.onSurface,
          Theme.of(context).brightness == Brightness.dark ? 0.4 : 0.2)!;
    }
    return color;
  }

  void _hideOverlay() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    _hoverIndex = -1;
  }

  void _selectItem(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentIndex = index;
      widget.onSelected(_items![index]);
    });
  }

  void _handleTouchMove(Offset globalPosition) {
    if (_overlayEntry != null) {
      final RenderBox renderBox =
          _chipKey.currentContext!.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(globalPosition);
      final itemHeight = renderBox.size.height;
      final index = ((localPosition.dy - itemHeight) / itemHeight)
          .floor()
          .clamp(0, (_items?.length ?? 1) - 1);
      if (_hoverIndex != index) {
        HapticFeedback.selectionClick();
        setState(() {
          _hoverIndex = index;
        });
        _overlayEntry?.markNeedsBuild();
      }
    }
  }

  void _handleTouchEnd(Offset? globalPosition) {
    if (_overlayEntry != null && globalPosition != null) {
      if (_hoverIndex != -1) {
        _selectItem(_hoverIndex);
      }
    }
    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContextMenuWidget(
      menuProvider: (MenuRequest request) async {
        return Menu(children: await menu);
      },
      child: CustomAnimatedSize(
        alignment: Alignment.centerLeft,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPressStart: (details) {
              _showOverlay(context);
              _handleTouchMove(details.globalPosition);
            },
            onLongPressMoveUpdate: (details) {
              _handleTouchMove(details.globalPosition);
            },
            onLongPressEnd: (details) {
              _handleTouchEnd(details.globalPosition);
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  _handleScroll(event);
                }
              },
              child: MouseRegion(
                onEnter: (_) => _isScrolling = false,
                child: TooltipVisibility(
                  visible: false,
                  child: CustomDropDownChip(
                    key: _chipKey,
                    label: ElasticAnimation(
                      child: Text(
                        key: ValueKey(widget.currentValue?.title),
                        widget.currentValue?.shortTitle ??
                            widget.currentValue?.title ??
                            widget.defaultTitle,
                      ),
                    ),
                    filled: widget.currentValue != null,
                    icon: widget.currentValue?.icon ?? widget.defaultIcon,
                    onPressed: () async => await _showSelectionSheet(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<MenuElement>> get menu async {
    List<DropDownChipItem<T>> items = await widget.items();

    return [
      for (DropDownChipItem<T> item in items)
        MenuAction(
          state: item.item == widget.currentValue?.item
              ? MenuActionState.checkOn
              : MenuActionState.none,
          callback: () {
            if (item.item == widget.currentValue?.item &&
                widget.emptySelectionAllowed) {
              widget.onSelected(null);
            } else {
              widget.onSelected(item);
            }
            setState(() {});
          },
          title: item.title,
        )
    ];
  }

  Future<void> _showSelectionSheet(context) async {
    return await showScrollableModalBottomSheet(
      context: context,
      builder: (context, setState, scrollcontroller) {
        return ListView(
          controller: scrollcontroller,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 16),
              child: Text(
                widget.defaultTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            FutureBuilder<List<DropDownChipItem<T>>>(
              future: widget.items(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (DropDownChipItem<T> item in snapshot.data!)
                          CustomCard(
                            elevation: 0,
                            child: Column(
                              children: [
                                RadioListTile<T>(
                                  title: Text(item.title),
                                  value: item.item,
                                  groupValue: widget.currentValue?.item,
                                  toggleable: widget.emptySelectionAllowed,
                                  onChanged: (sItem) {
                                    widget.onSelected(
                                      sItem == null ? null : item,
                                    );
                                    setState(() {});
                                  },
                                ),
                                if (item.bottomWiget != null)
                                  FutureBuilder<Widget?>(
                                    future: item.bottomWiget!(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(snapshot.error.toString());
                                      } else if (snapshot.hasData) {
                                        return snapshot.data ??
                                            const SizedBox();
                                      } else {
                                        return const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: LinearProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            const BottomSheetBottomContentPadding()
          ],
        );
      },
    );
  }
}

class ToggleChip extends StatefulWidget {
  const ToggleChip({
    super.key,
    required this.label,
    this.icon,
    this.initalValue = false,
    required this.onChanged,
  });

  final Widget label;
  final Widget? icon;
  final bool initalValue;
  final void Function(bool value)? onChanged;

  @override
  State<ToggleChip> createState() => _ToggleChipState();
}

class _ToggleChipState extends State<ToggleChip> {
  late bool value = widget.initalValue;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: widget.label,
      selected: value,
      // We want to show the checkmark when the togglechip is enabled , so the
      // icon should be null if the chip is enabled
      avatar: value || widget.icon == null
          ? null
          : IconTheme.merge(
              data: IconThemeData(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: widget.icon!,
            ),

      onSelected: (newValue) {
        if (newValue) HapticFeedback.heavyImpact();
        if (!newValue) HapticFeedback.mediumImpact();
        widget.onChanged?.call(newValue);
        setState(() {
          value = newValue;
        });
      },
    );
  }
}

class DateRangeChip extends StatefulWidget {
  const DateRangeChip({
    super.key,
    this.callback,
    this.selectedRange,
    this.title = const Text("Datum"),
  });

  final Widget title;
  final Function(DateTimeRange? range)? callback;
  final DateTimeRange? selectedRange;

  @override
  State<DateRangeChip> createState() => _DateRangeChipState();
}

class _DateRangeChipState extends State<DateRangeChip> {
  late DateTimeRange? selectedRange = widget.selectedRange;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: selectedRange != null
          ? Theme.of(context).colorScheme.secondaryContainer
          : null,
      side: selectedRange != null
          ? const BorderSide(style: BorderStyle.none)
          : null,
      avatar: Icon(
        Icons.date_range,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      label: widget.title,
      onPressed: () async {
        DateTimeRange? range = await showDateRangePicker(
          useRootNavigator: false,
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDateRange: widget.selectedRange,
        );
        widget.callback?.call(range);
        setState(() {
          selectedRange = range;
        });
      },
    );
  }
}

class FilterChipList extends StatefulWidget {
  const FilterChipList({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.chips = const [],
  });

  /// This is padding inserted at the beginning of the row,
  /// so when the row is scrolled, it will not cut off in the middel of the screen,
  /// but will still, in an unscrolled state, have padding.
  final EdgeInsets padding;

  /// This list should contain the listed chips.
  final List<Widget> chips;

  @override
  State<FilterChipList> createState() => _FilterChipListState();
}

class _FilterChipListState extends State<FilterChipList> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: widget.padding.copyWith(left: 0, right: 0),
          child: Row(
            children: [
              SizedBox(width: widget.padding.left), // Start Padding
              ...widget.chips.intersperse(
                const SizedBox(
                  width: 8,
                ),
              ),
              SizedBox(width: widget.padding.right) // End padding
            ],
          ),
        ),
      ),
    );
  }
}
