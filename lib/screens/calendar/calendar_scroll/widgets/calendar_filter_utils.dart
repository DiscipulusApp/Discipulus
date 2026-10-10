import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:isar/isar.dart';

enum FilterCategory {
  teachers,
  classrooms,
  infoTypes,
}

class FilterTeacherItem {
  final String name;
  final String? code;
  const FilterTeacherItem({required this.name, this.code});
}

/// Utility functions to gather unique filter options from cached calendar events.
class CalendarFilterUtils {
  /// Returns a sorted list of unique teachers.
  static List<FilterTeacherItem> getAvailableTeachers() {
    try {
      final events = activeProfile.calendarEvents
          .filter()
          .docentenIsNotNull()
          .findAllSync();

      final Map<String, FilterTeacherItem> teacherMap = {};
      for (final event in events) {
        final docenten = event.docenten;
        if (docenten != null) {
          for (final d in docenten) {
            final name = d.naam ?? d.docentcode;
            if (name != null && name.trim().isNotEmpty) {
              final cleanName = name.trim();
              if (!teacherMap.containsKey(cleanName)) {
                teacherMap[cleanName] = FilterTeacherItem(
                  name: cleanName,
                  code: d.docentcode?.trim(),
                );
              }
            }
          }
        }
      }

      final list = teacherMap.values.toList();
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Returns a sorted list of unique classrooms.
  static List<String> getAvailableClassrooms() {
    try {
      final events = activeProfile.calendarEvents
          .filter()
          .group((q) => q.lokalenIsNotNull().or().rawLokatieIsNotNull())
          .findAllSync();

      final Set<String> classrooms = {};
      for (final event in events) {
        if (event.lokatie != null && event.lokatie!.trim().isNotEmpty) {
          for (final part in event.lokatie!.split(RegExp(r'[,/]+'))) {
            final clean = part.trim();
            if (clean.isNotEmpty) classrooms.add(clean);
          }
        } else if (event.rawLokatie != null && event.rawLokatie!.trim().isNotEmpty) {
          for (final part in event.rawLokatie!.split(RegExp(r'[,/]+'))) {
            final clean = part.trim();
            if (clean.isNotEmpty) classrooms.add(clean);
          }
        }
        if (event.lokalen != null) {
          for (final l in event.lokalen!) {
            if (l.naam != null && l.naam!.trim().isNotEmpty) {
              classrooms.add(l.naam!.trim());
            }
          }
        }
      }

      final list = classrooms.toList();
      list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return list;
    } catch (_) {
      return [];
    }
  }
}
