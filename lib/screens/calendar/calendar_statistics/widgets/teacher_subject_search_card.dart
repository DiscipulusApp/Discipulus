import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/pages/subject_detail_statistics.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/pages/teacher_detail_statistics.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';

enum SearchCategory { all, teachers, subjects }

extension on SearchCategory {
  String get title {
    switch (this) {
      case SearchCategory.all:
        return "Alles";
      case SearchCategory.teachers:
        return "Docenten";
      case SearchCategory.subjects:
        return "Vakken";
    }
  }

  IconData get icon {
    switch (this) {
      case SearchCategory.all:
        return Icons.search;
      case SearchCategory.teachers:
        return Icons.people_alt_outlined;
      case SearchCategory.subjects:
        return Icons.auto_stories_outlined;
    }
  }
}

class TeacherSubjectSearchCard extends StatelessWidget {
  const TeacherSubjectSearchCard({
    super.key,
    required this.allEvents,
    required this.allSchoolyears,
  });

  final List<CalendarEvent> allEvents;
  final List<Schoolyear> allSchoolyears;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          showScrollableModalBottomSheet(
            initiallyOpen: true,
            context: context,
            builder: (context, setState, scrollcontroller) =>
                _TeacherSubjectSearchModal(
              scrollController: scrollcontroller,
              allEvents: allEvents,
              allSchoolyears: allSchoolyears,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Zoek een docent of vak...",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeacherSubjectSearchModal extends StatefulWidget {
  const _TeacherSubjectSearchModal({
    required this.scrollController,
    required this.allEvents,
    required this.allSchoolyears,
  });

  final ScrollController scrollController;
  final List<CalendarEvent> allEvents;
  final List<Schoolyear> allSchoolyears;

  @override
  State<_TeacherSubjectSearchModal> createState() =>
      _TeacherSubjectSearchModalState();
}

class _TeacherSubjectSearchModalState
    extends State<_TeacherSubjectSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  SearchCategory _selectedCategory = SearchCategory.all;

  List<_SearchResultItem> _allResults = [];
  List<_SearchResultItem> _filteredResults = [];

  @override
  void initState() {
    super.initState();
    _buildSearchData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _buildSearchData() {
    final Map<String, _TeacherData> teachersMap = {};
    final Map<String, _SubjectData> subjectsMap = {};

    for (final e in widget.allEvents) {
      final isCancel = e.isCanceled;
      final dur = e.einde.difference(e.start).inMinutes;
      final hours = (!isCancel && dur > 0 && dur <= 600) ? dur / 60.0 : 0.0;

      // Extract teachers
      final docenten = e.docenten;
      if (docenten != null && docenten.isNotEmpty) {
        for (final d in docenten) {
          final tName = d.naam?.trim() ?? d.docentcode?.trim() ?? "";
          if (tName.isEmpty) continue;

          if (!teachersMap.containsKey(tName)) {
            teachersMap[tName] = _TeacherData(
              name: tName,
              code: d.docentcode,
            );
          }
          final t = teachersMap[tName]!;
          t.totalHours += hours;
          t.totalLessons++;
          t.events.add(e);
        }
      }

      // Extract subjects
      final sName = e.subject.value?.naam.capitalized ??
          (e.title.isNotEmpty ? e.title.capitalized : "");
      final sShort = e.subject.value?.afkorting ?? e.vakken?.firstOrNull?.naam;

      if (sName.isNotEmpty) {
        if (!subjectsMap.containsKey(sName)) {
          subjectsMap[sName] = _SubjectData(
            name: sName,
            shortName: sShort,
          );
        }
        final s = subjectsMap[sName]!;
        s.totalHours += hours;
        s.totalLessons++;
        s.events.add(e);
      }
    }

    final List<_SearchResultItem> results = [];

    // Convert teachers
    for (final t in teachersMap.values) {
      final activeYears = widget.allSchoolyears.where((sy) {
        return t.events.any((e) =>
            e.start.isAfter(sy.begin.subtract(const Duration(days: 1))) &&
            e.start.isBefore(sy.einde.add(const Duration(days: 1))));
      }).length;

      results.add(
        _SearchResultItem(
          isTeacher: true,
          title: t.name,
          subtitle:
              "${t.code != null && t.code!.isNotEmpty ? '${t.code} • ' : ''}${t.totalHours.round()} uur • $activeYears ${activeYears == 1 ? 'schooljaar' : 'schooljaren'}",
          code: t.code,
          hours: t.totalHours,
          lessonsCount: t.totalLessons,
          schoolyearsCount: activeYears,
        ),
      );
    }

    // Convert subjects
    for (final s in subjectsMap.values) {
      final activeYears = widget.allSchoolyears.where((sy) {
        return s.events.any((e) =>
            e.start.isAfter(sy.begin.subtract(const Duration(days: 1))) &&
            e.start.isBefore(sy.einde.add(const Duration(days: 1))));
      }).length;

      results.add(
        _SearchResultItem(
          isTeacher: false,
          title: s.name,
          subtitle:
              "${s.totalHours.round()} uur • $activeYears ${activeYears == 1 ? 'jaar' : 'jaren'}",
          code: s.shortName,
          hours: s.totalHours,
          lessonsCount: s.totalLessons,
          schoolyearsCount: activeYears,
        ),
      );
    }

    results.sort((a, b) => b.hours.compareTo(a.hours));
    _allResults = results;
    _filteredResults = results;
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredResults = _allResults.where((item) {
        // Category filter
        if (_selectedCategory == SearchCategory.teachers && !item.isTeacher) {
          return false;
        }
        if (_selectedCategory == SearchCategory.subjects && item.isTeacher) {
          return false;
        }

        // Query filter
        if (query.isEmpty) return true;
        final titleMatch = item.title.toLowerCase().contains(query);
        final codeMatch =
            item.code != null && item.code!.toLowerCase().contains(query);
        return titleMatch || codeMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Zoeken",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "Zoek op docent, vak of code...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              // Category Selection Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in SearchCategory.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: _selectedCategory == category,
                          avatar: Icon(category.icon, size: 18),
                          label: Text(category.title),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _onSearchChanged();
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Search Results List
        Expanded(
          child: _filteredResults.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Geen docenten of vakken gevonden",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: widget.scrollController,
                  itemCount: _filteredResults.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _filteredResults.length) {
                      return const BottomSheetBottomContentPadding();
                    }

                    final item = _filteredResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.isTeacher
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.secondaryContainer,
                        child: Icon(
                          item.isTeacher ? Icons.person : Icons.auto_stories,
                          color: item.isTeacher
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSecondaryContainer,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(item.subtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (item.isTeacher) {
                          TeacherDetailStatisticsScreen(
                            teacherName: item.title,
                            teacherCode: item.code,
                            allEvents: widget.allEvents,
                            allSchoolyears: widget.allSchoolyears,
                          ).push(context);
                        } else {
                          SubjectDetailStatisticsScreen(
                            subjectName: item.title,
                            subjectShortName: item.code,
                            allEvents: widget.allEvents,
                            allSchoolyears: widget.allSchoolyears,
                          ).push(context);
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SearchResultItem {
  final bool isTeacher;
  final String title;
  final String subtitle;
  final String? code;
  final double hours;
  final int lessonsCount;
  final int schoolyearsCount;

  const _SearchResultItem({
    required this.isTeacher,
    required this.title,
    required this.subtitle,
    this.code,
    required this.hours,
    required this.lessonsCount,
    required this.schoolyearsCount,
  });
}

class _TeacherData {
  final String name;
  final String? code;
  double totalHours = 0.0;
  int totalLessons = 0;
  final List<CalendarEvent> events = [];

  _TeacherData({required this.name, this.code});
}

class _SubjectData {
  final String name;
  final String? shortName;
  double totalHours = 0.0;
  int totalLessons = 0;
  final List<CalendarEvent> events = [];

  _SubjectData({required this.name, this.shortName});
}
