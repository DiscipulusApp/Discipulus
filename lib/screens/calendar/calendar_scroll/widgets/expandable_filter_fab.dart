import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/screens/calendar/calendar_scroll/widgets/calendar_filter_utils.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpandableCalendarFilterFab extends StatefulWidget {
  const ExpandableCalendarFilterFab({
    super.key,
    required this.activeFilters,
    required this.onFiltersChanged,
    this.onExpandedChanged,
    this.defaultCategory,
  });

  final List<CalendarFilter> activeFilters;
  final VoidCallback onFiltersChanged;
  final ValueChanged<bool>? onExpandedChanged;
  final FilterCategory? defaultCategory;

  @override
  State<ExpandableCalendarFilterFab> createState() => _ExpandableCalendarFilterFabState();
}

class _ExpandableCalendarFilterFabState extends State<ExpandableCalendarFilterFab>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  FilterCategory? _activeCategory;
  FilterCategory? _displayedCategory;
  final TextEditingController _searchController = TextEditingController();

  List<FilterTeacherItem> _allTeachers = [];
  List<String> _allClassrooms = [];
  List<InfoType> _allInfoTypes = [];

  late final AnimationController _expansionController;
  late final Animation<double> _expansionAnimation;
  late final Animation<Offset> _categorySlideAnimation;

  late final AnimationController _menuController;
  late final Animation<double> _menuAnimation;
  late final Animation<Offset> _menuSlideAnimation;

  late final AnimationController _clearController;
  late final Animation<double> _clearAnimation;
  late final Animation<Offset> _clearSlideAnimation;

  @override
  void initState() {
    super.initState();
    _loadAvailableOptions();

    _displayedCategory = widget.defaultCategory;

    _expansionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _expansionAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _categorySlideAnimation = Tween<Offset>(
      begin: const Offset(0.35, 0.0),
      end: Offset.zero,
    ).animate(_expansionAnimation);

    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _menuSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(_menuAnimation);

    _clearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 200),
      value: widget.activeFilters.isNotEmpty ? 1.0 : 0.0,
    );
    _clearAnimation = CurvedAnimation(
      parent: _clearController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _clearSlideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(_clearAnimation);
  }

  void _loadAvailableOptions() {
    _allTeachers = CalendarFilterUtils.getAvailableTeachers();
    _allClassrooms = CalendarFilterUtils.getAvailableClassrooms();
    _allInfoTypes = InfoType.values;
  }

  @override
  void didUpdateWidget(covariant ExpandableCalendarFilterFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeFilters.isNotEmpty != oldWidget.activeFilters.isNotEmpty) {
      _updateClearButtonState();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _expansionController.dispose();
    _menuController.dispose();
    _clearController.dispose();
    super.dispose();
  }

  void _updateClearButtonState() {
    if (widget.activeFilters.isNotEmpty) {
      if (!_clearController.isCompleted &&
          _clearController.status != AnimationStatus.forward) {
        _clearController.forward();
      }
    } else {
      if (!_clearController.isDismissed &&
          _clearController.status != AnimationStatus.reverse) {
        _clearController.reverse();
      }
    }
  }

  void _open() {
    HapticFeedback.lightImpact();
    _loadAvailableOptions();
    setState(() {
      _isExpanded = true;
      _expansionController.forward();
      _activeCategory = widget.defaultCategory;
      if (widget.defaultCategory != null) {
        _displayedCategory = widget.defaultCategory;
        _menuController.forward();
      }
      _searchController.clear();
      _updateClearButtonState();
    });
    widget.onExpandedChanged?.call(true);
  }

  void _closeAll() {
    if (!_isExpanded) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isExpanded = false;
      _activeCategory = null;
      _searchController.clear();
      _menuController.reverse();
      _expansionController.reverse();
    });
    widget.onExpandedChanged?.call(false);
  }

  void _toggleCategory(FilterCategory category) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_activeCategory == category) {
        _activeCategory = null;
        _searchController.clear();
        _menuController.reverse();
      } else {
        final wasClosed =
            _activeCategory == null && _menuController.isDismissed;
        _activeCategory = category;
        _displayedCategory = category;
        _searchController.clear();
        if (wasClosed) {
          _menuController.forward(from: 0.0);
        } else {
          _menuController.forward();
        }
      }
    });
  }

  bool _isInfoTypeActive(InfoType type) {
    return widget.activeFilters
        .whereType<CalendarInfoTypeFilter>()
        .any((f) => f.infoType == type);
  }

  bool _isTeacherActive(FilterTeacherItem teacher) {
    return widget.activeFilters
        .whereType<CalendarTeacherFilter>()
        .any((f) => f.name == teacher.name);
  }

  bool _isClassroomActive(String classroom) {
    return widget.activeFilters
        .whereType<CalendarClassroomFilter>()
        .any((f) => f.classroom.toLowerCase() == classroom.toLowerCase());
  }

  void _toggleInfoType(InfoType type) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_isInfoTypeActive(type)) {
        widget.activeFilters.removeWhere(
            (f) => f is CalendarInfoTypeFilter && f.infoType == type);
      } else {
        widget.activeFilters.add(
          CalendarInfoTypeFilter(
            type.hashCode,
            infoType: type,
            name: type.toName,
          ),
        );
      }
      _updateClearButtonState();
    });
    widget.onFiltersChanged();
  }

  void _toggleTeacher(FilterTeacherItem teacher) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_isTeacherActive(teacher)) {
        widget.activeFilters.removeWhere(
            (f) => f is CalendarTeacherFilter && f.name == teacher.name);
      } else {
        widget.activeFilters.add(
          CalendarTeacherFilter(
            teacher.name.hashCode,
            name: teacher.name,
            code: teacher.code,
          ),
        );
      }
      _updateClearButtonState();
    });
    widget.onFiltersChanged();
  }

  void _toggleClassroom(String classroom) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_isClassroomActive(classroom)) {
        widget.activeFilters.removeWhere((f) =>
            f is CalendarClassroomFilter &&
            f.classroom.toLowerCase() == classroom.toLowerCase());
      } else {
        widget.activeFilters.add(
          CalendarClassroomFilter(
            classroom.hashCode,
            classroom: classroom,
          ),
        );
      }
      _updateClearButtonState();
    });
    widget.onFiltersChanged();
  }

  void _clearAllFilters() {
    HapticFeedback.mediumImpact();
    setState(() {
      widget.activeFilters.clear();
      _clearController.reverse();
    });
    widget.onFiltersChanged();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = widget.activeFilters.length;
    final hasActiveFilters = activeCount > 0;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildAnimatedOptionsCard(context),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAnimatedCategoryBar(),
            _buildActionButton(context,
                hasActiveFilters: hasActiveFilters, activeCount: activeCount),
          ],
        ),
      ],
    );

    if (_isExpanded) {
      content = TapRegion(
        onTapOutside: (_) => _closeAll(),
        child: content,
      );
    }

    return content;
  }

  Widget _buildAnimatedOptionsCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _menuAnimation,
      builder: (context, child) {
        if (_menuController.isDismissed && _activeCategory == null) {
          return const SizedBox.shrink();
        }
        return SizeTransition(
          axis: Axis.vertical,
          alignment: Alignment.bottomCenter,
          sizeFactor: _menuAnimation,
          child: FadeTransition(
            opacity: _menuAnimation,
            child: SlideTransition(
              position: _menuSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 32),
                child: _buildFloatingMenuCard(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCategoryBar() {
    return AnimatedBuilder(
      animation: _expansionAnimation,
      builder: (context, child) {
        if (_expansionController.isDismissed && !_isExpanded) {
          return const SizedBox.shrink();
        }
        return SizeTransition(
          axis: Axis.horizontal,
          alignment: Alignment.centerRight,
          sizeFactor: _expansionAnimation,
          child: FadeTransition(
            opacity: _expansionAnimation,
            child: SlideTransition(
              position: _categorySlideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildFilterPill(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedClearButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _clearAnimation,
      builder: (context, child) {
        if (_clearController.isDismissed && widget.activeFilters.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizeTransition(
          axis: Axis.horizontal,
          alignment: Alignment.centerRight,
          sizeFactor: _clearAnimation,
          child: FadeTransition(
            opacity: _clearAnimation,
            child: SlideTransition(
              position: _clearSlideAnimation,
              child: _buildClearFiltersButton(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    bool hasActiveFilters = false,
    int activeCount = 0,
  }) {
    return Material(
      key: const ValueKey('unfocused_button'),
      elevation: _isExpanded ? 0 : 4,
      borderRadius: BorderRadius.circular(22),
      color: context.cs.tertiaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: _isExpanded ? _closeAll : _open,
        child: AnimatedContainer(
          duration: Durations.medium1,
          curve: Easing.standard,
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: Durations.short4,
              child: _isExpanded
                  ? Icon(
                      Icons.close_rounded,
                      key: const ValueKey('close_icon'),
                      size: 24,
                      color: context.cs.onTertiaryContainer,
                    )
                  : Badge(
                      key: const ValueKey('tune_icon'),
                      backgroundColor: context.cs.tertiary,
                      textColor: context.cs.onTertiary,
                      isLabelVisible: hasActiveFilters,
                      label: Text("$activeCount"),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        size: 24,
                        color: context.cs.onTertiaryContainer,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Clear filters button: appears on the left, emerging from underneath "Soort"
          _buildAnimatedClearButton(context),
          _buildCategoryButton(
            context,
            position: 0,
            category: FilterCategory.infoTypes,
            icon: Icons.label_outlined,
            label: "Soort",
            count:
                widget.activeFilters.whereType<CalendarInfoTypeFilter>().length,
          ),
          _buildCategoryButton(
            context,
            position: 1,
            category: FilterCategory.teachers,
            icon: Icons.school_outlined,
            label: "Docenten",
            count:
                widget.activeFilters.whereType<CalendarTeacherFilter>().length,
          ),
          _buildCategoryButton(
            context,
            position: 2,
            category: FilterCategory.classrooms,
            icon: Icons.meeting_room_outlined,
            label: "Lokalen",
            count: widget.activeFilters
                .whereType<CalendarClassroomFilter>()
                .length,
          ),
        ],
      ),
    );
  }

  Widget _buildClearFiltersButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        color: context.cs.errorContainer,
        borderRadius: BorderRadius.circular(32),
        child: SizedBox(
          height: 56,
          width: 56,
          child: IconButton(
            tooltip: "Filters wissen",
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 24,
              color: context.cs.onErrorContainer,
            ),
            onPressed: _clearAllFilters,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context, {
    required FilterCategory category,
    required IconData icon,
    required String label,
    required int count,
    int? position, // 0 first, 1 middle, 2 last
  }) {
    final bool isSelected = _activeCategory == category;
    final bool hasActive = count > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: isSelected ? context.cs.primary : context.cs.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSelected ? 32 : 8).copyWith(
            topLeft: position == 0 ? const Radius.circular(32) : null,
            bottomLeft: position == 0 ? const Radius.circular(32) : null,
            topRight: position == 2 ? const Radius.circular(32) : null,
            bottomRight: position == 2 ? const Radius.circular(32) : null,
          ),
        ),
        child: Badge(
          isLabelVisible: hasActive,
          alignment: Alignment.bottomRight,
          offset: isSelected ? Offset(-12, -22) : Offset(-6, -22),
          label: Text("$count"),
          backgroundColor: isSelected ? null : context.cs.inverseSurface,
          textColor: isSelected ? null : context.cs.onInverseSurface,
          child: SizedBox(
            height: 56,
            child: IconButton(
              tooltip: label,
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  icon,
                  size: 28,
                  color: isSelected
                      ? context.cs.onPrimary
                      : context.cs.onSurfaceVariant,
                ),
              ),
              onPressed: () => _toggleCategory(category),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMenuCard(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double cardWidth = (screenWidth - 32).clamp(280.0, 500.0);

    return SizedBox(
      width: cardWidth,
      child: _buildOptionsCard(context),
    );
  }

  Widget _buildSearchBar(
    BuildContext context, {
    FilterCategory? category,
  }) {
    final effectiveCategory = category ?? _activeCategory ?? _displayedCategory;
    String hintText;
    switch (effectiveCategory) {
      case FilterCategory.infoTypes:
        hintText = "Zoek soort...";
        break;
      case FilterCategory.teachers:
        hintText = "Zoek docent...";
        break;
      case FilterCategory.classrooms:
        hintText = "Zoek lokaal...";
        break;
      default:
        hintText = "Zoeken...";
    }

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16).copyWith(
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      ),
      color: context.cs.surfaceContainerHigh,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: _searchController,
          style: Theme.of(context).textTheme.bodyMedium,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 24,
              color: context.cs.onSurfaceVariant,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  tooltip: "Wissen",
                  onPressed: () => _searchController.clear(),
                );
              },
            ),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.cs.onSurfaceVariant.withValues(alpha: 0.7),
                ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    final effectiveCategory = _activeCategory ?? _displayedCategory;
    return Column(
      children: [
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: const Radius.circular(8),
            bottomRight: const Radius.circular(8),
          ),
          color: context.cs.surfaceContainerHigh,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, searchValue, _) {
                  final query = searchValue.text.trim().toLowerCase();
                  return AnimatedSwitcher(
                    duration: Durations.short3,
                    child: KeyedSubtree(
                      key: ValueKey(effectiveCategory),
                      child: _buildCategoryItemsList(
                        context,
                        query: query,
                        category: effectiveCategory,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        _buildSearchBar(context, category: effectiveCategory),
      ],
    );
  }

  Widget _buildCategoryItemsList(
    BuildContext context, {
    required String query,
    FilterCategory? category,
  }) {
    final effectiveCategory = category ?? _activeCategory ?? _displayedCategory;
    switch (effectiveCategory) {
      case FilterCategory.infoTypes:
        final items = _allInfoTypes.where((t) {
          final label = t.toName.toLowerCase();
          return query.isEmpty || label.contains(query);
        }).toList();

        if (items.isEmpty) return _buildEmptyResults();

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(4),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final type = items[index];
            final label = type.toName;
            final bool isSelected = _isInfoTypeActive(type);

            return _buildOptionRow(
              title: label,
              isSelected: isSelected,
              onTap: () => _toggleInfoType(type),
            );
          },
        );

      case FilterCategory.teachers:
        final items = _allTeachers.where((t) {
          final name = t.name.toLowerCase();
          final code = t.code?.toLowerCase() ?? "";
          return query.isEmpty || name.contains(query) || code.contains(query);
        }).toList();

        if (items.isEmpty) return _buildEmptyResults();

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(4),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final teacher = items[index];
            final title = teacher.code != null && teacher.code!.isNotEmpty
                ? "${teacher.name} (${teacher.code})"
                : teacher.name;
            final bool isSelected = _isTeacherActive(teacher);

            return _buildOptionRow(
              title: title,
              isSelected: isSelected,
              onTap: () => _toggleTeacher(teacher),
            );
          },
        );

      case FilterCategory.classrooms:
        final items = _allClassrooms.where((c) {
          return query.isEmpty || c.toLowerCase().contains(query);
        }).toList();

        if (items.isEmpty) return _buildEmptyResults();

        return Padding(
          padding: const EdgeInsets.all(4),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final classroom = items[index];
              final bool isSelected = _isClassroomActive(classroom);

              return _buildOptionRow(
                title: classroom,
                isSelected: isSelected,
                onTap: () => _toggleClassroom(classroom),
              );
            },
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyResults() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          "Geen resultaten gevonden",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      color: isSelected
          ? context.cs.primaryContainer
          : context.cs.surfaceContainer,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? context.cs.primary
                            : context.cs.onSurface,
                      ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: context.cs.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
