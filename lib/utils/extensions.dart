import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:mime/mime.dart' show lookupMimeType;

extension FileExtension on File {
  bool get canPreview {
    if (["image/jpeg", "image/png", "image/gif", "image/webp", "image/bmp"]
        .contains(lookupMimeType(path))) {
      return true;
    }
    return false;
  }

  IconData? get iconForFile {
    String? mimeType = lookupMimeType(path);
    return mimeType?.iconForMime;
  }
}

extension StringExtension on String {
  String get capitalized =>
      length > 0 ? "${this[0].toUpperCase()}${substring(1)}" : "";

  String? get withoutHTML =>
      parse(parse(this).body?.text).documentElement?.text;

  /// Checks if a string contains anything
  bool get isEmptyHTML =>
      (parse(parse(this).body?.text).documentElement?.text ?? "").replaceAll(
          RegExp(r"\s|\u200B|\uFEFF"),
          "") == // For some reason Magister does not filter non-zero-whitespaces, so we will do that
      "";

  String? get nullOnEmpty => replaceAll(" ", "") == "" ? null : this;

  IconData get iconForMime {
    if (contains("audio")) {
      return Icons.audio_file_outlined;
    } else if (contains("video")) {
      return Icons.video_file_outlined;
    } else if (contains("image")) {
      return Icons.image_outlined;
    }
    switch (this) {
      // PDF
      case "application/pdf":
        return Icons.picture_as_pdf_outlined;

      // Word
      case "application/msword":
        return Icons.description_outlined;
      case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
        return Icons.description_outlined;

      // Powerpoint
      case "application/vnd.ms-powerpoint":
        return Icons.co_present_outlined;
      case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
        return Icons.co_present_outlined;

      // Excel
      case "application/vnd.ms-excel":
        return Icons.co_present_outlined;
      case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
        return Icons.table_view_outlined;
      case "text/csv":
        return Icons.table_view_outlined;

      // Compressed files
      case "application/zip":
        return Icons.folder_zip_outlined;
      case "application/x-7z-compressed":
        return Icons.folder_zip_outlined;

      // Ebooks
      case "application/epub+zip":
        return Icons.book_outlined;
      case "application/vnd.amazon.ebook":
        return Icons.book_outlined;

      // Unknown
      default:
        return Icons.file_present_outlined;
    }
  }
}

Future<List<T>> progressWait<T>(List<Future<T>> futures,
    {void Function(int completed, int total)? progress}) {
  int total = futures.length;
  int completed = 0;
  void complete() {
    completed++;
    if (progress != null) progress(completed, total);
  }

  return Future.wait<T>(
      [for (var future in futures) future.whenComplete(complete)]);
}

extension Bytes on int {
  String getFileSizeString({int decimals = 1}) {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    if (this == 0) return '0${suffixes[0]}';
    var i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}

extension CalendarEventListHelper on List<CalendarEvent> {
  List<List<CalendarEvent>> get splitPerWeek {
    var events = this..sort((a, b) => a.start.compareTo(b.start));

    List<List<CalendarEvent>> result = [];
    List<CalendarEvent> currentWeek = [];
    DateTime? currentWeekStartDate;

    for (CalendarEvent event in events) {
      final eventStart = event.start;
      final eventWeekStartDate = eventStart.startOfWeek;

      if (currentWeekStartDate == null) {
        currentWeekStartDate = eventWeekStartDate;
        currentWeek.add(event);
        continue;
      }

      if (eventWeekStartDate.isAtSameMomentAs(currentWeekStartDate)) {
        currentWeek.add(event);
      } else {
        result.add(currentWeek);
        currentWeek = [event];
        currentWeekStartDate = eventWeekStartDate;
      }
    }

    if (currentWeek.isNotEmpty) {
      result.add(currentWeek);
    }

    return result;
  }
}

extension Intersperse<T> on Iterable<T> {
  Iterable<T> intersperse(T separator) sync* {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield separator;
        yield iterator.current;
      }
    }
  }
}

extension ListSplit<T> on List<T> {
  List<List<T>> splitByChunks(int chunkSize, {T? insertOnOdd}) {
    if (chunkSize == 0) {
      throw ArgumentError('Chunk size cannot be zero.');
    }

    List<List<T>> list = List.generate(
      (length / chunkSize).ceil(),
      (index) =>
          sublist(index * chunkSize, min((index + 1) * chunkSize, length)),
    );

    if (insertOnOdd != null && list.last.length != chunkSize) {
      list.last.addAll(
          List.generate(chunkSize - list.last.length, (index) => insertOnOdd));
    }

    return list;
  }

  T nextInList(T current, {int step = 1}) {
    int currentIndex = indexWhere((e) => e == current);
    return this[((currentIndex + step).isNegative
            ? (currentIndex + step) * -1
            : (currentIndex + step)) %
        length];
  }
}

extension NavigatorExtension on Widget {
  ///Push this page to the navigator
  ///
  ///Equal to the following:
  ///```
  /// Navigator.of(context).push(MaterialPageRoute(
  ///   builder: (context) => this,
  /// ));
  ///```
  Future push(BuildContext? context) =>
      Navigator.of(context ?? navKey.currentContext!).push(MaterialPageRoute(
        builder: (context) => this,
      ));
}

extension NavigatorStateExtension on NavigatorState {
  String? get currentRouteName {
    String? name;
    popUntil((route) {
      name = route.settings.name;
      return true;
    });
    return name;
  }
}

extension WidgetListExtension on Iterable<Widget> {
  List<Widget> wrapOn(BoxConstraints constraints,
      {double wrapWidth = 600,
      int max = 2,
      int min = 1,
      Widget Function(List<Widget> widgets)? map,
      Widget? insertOnOdd}) {
    return toList()
        .splitByChunks(constraints.maxWidth > wrapWidth ? max : min,
            insertOnOdd: insertOnOdd)
        .map<Widget>(
          map ??
              (e) => Row(
                    children: e.map((e) => Expanded(child: e)).toList(),
                  ),
        )
        .toList();
  }
}

extension ColorExtension on Color {
  Color applySurfaceTint({required Color? tint, required double elevation}) {
    return ElevationOverlay.applySurfaceTint(
      this,
      tint,
      elevation,
    );
  }
}

extension PlatformExtension on Platform {
  static bool isApple = Platform.isIOS || Platform.isMacOS;
  static bool isDesktop =
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}

extension ContactListExtension on Iterable<Contact> {
  /// Sorts the list of contact, so that the selected people are in front
  List<Contact> selectiveSort([List<Contact>? selected]) {
    List<Contact> fav = selected ?? activeProfile.settings.favoritePeople;
    return [
      ...where((e) => fav.map((e) => e.id).contains(e.id)),
      ...where((e) => !fav.map((e) => e.id).contains(e.id))
    ];
  }
}

extension ContactExtension on Contact {
  bool get isFavorite =>
      activeProfile.settings.favoritePeople.map((e) => e.id).contains(id);

  void toggleFavorite() {
    if (activeProfile.settings.favoritePeople.map((e) => e.id).contains(id)) {
      // Remove
      activeProfile
        ..settings.favoritePeople = [
          ...activeProfile.settings.favoritePeople.where((e) => e.id != id)
        ]
        ..save();
    } else {
      // Add
      activeProfile
        ..settings.favoritePeople = [
          ...activeProfile.settings.favoritePeople,
          this
        ]
        ..save();
    }
  }
}
