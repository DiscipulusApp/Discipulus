import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class ListTitle extends StatefulWidget {
  const ListTitle({
    super.key,
    required this.child,
    this.children = const [],
    this.selected,
  });

  final Text child;
  final List<Widget> children;

  /// When set, the tile will show a selectable trailing icon.
  final bool? selected;

  @override
  State<ListTitle> createState() => _ListTitleState();
}

class _ListTitleState extends State<ListTitle> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: AbsorbPointer(
        absorbing: widget.children.isEmpty,
        child: ExpansionTile(
          onExpansionChanged: (value) => setState(() {
            isExpanded = value;
          }),
          backgroundColor: widget.children.isNotEmpty
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          trailing: widget.selected != null
              ? Icon(
                  widget.selected!
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_outlined,
                )
              : widget.children.isEmpty
                  ? const SizedBox()
                  : null,
          title: AnimatedDefaultTextStyle(
              curve: CustomAnimatedSize.style().curve!,
              duration: CustomAnimatedSize.style().duration!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: isExpanded
                      ? Theme.of(context).textTheme.headlineSmall?.fontSize
                      : null,
                  color: isExpanded
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.primary),
              child: widget.child),
          children: widget.children,
        ),
      ),
    );
  }
}

extension IterableStringExtension on Iterable<String?> {
  /// Creates "a, b, c en d" from ["a","b","c","d"]
  String get formattedJoin {
    Iterable<String> strings = toList().nonNulls;
    if (strings.isEmpty) {
      return "";
    } else if (length == 1) {
      return strings.first;
    } else {
      return [
        strings.toList().sublist(0, strings.length - 1).join(", "),
        strings.last
      ].join(" en ");
    }
  }
}

extension ListStringExtension on List<String?> {
  List<String?> simplifyPatterns() {
    if (isEmpty) return [];

    // Convert to list immediately to preserve order
    final validStrings = where((s) => s != null).map((s) => s!).toList();
    if (validStrings.length == 1) return validStrings;

    // Split all strings into parts while maintaining order
    final List<List<String>> allSplitStrings = validStrings.map((str) {
      return str.split(RegExp(r'[\s-_]+')).toList();
    }).toList();

    // Find common parts at each position
    final commonParts = <int, String>{};
    final maxParts = allSplitStrings.map((parts) => parts.length).reduce(max);

    for (int position = 0; position < maxParts; position++) {
      if (allSplitStrings.every((parts) =>
          parts.length > position &&
          parts[position] == allSplitStrings[0][position])) {
        commonParts[position] = allSplitStrings[0][position];
      }
    }

    // Build simplified strings with ellipsis
    return List<String>.generate(validStrings.length, (index) {
      final parts = allSplitStrings[index];
      final List<String> resultParts = [];
      int lastNonCommonIndex = -1;

      for (int i = 0; i < parts.length; i++) {
        if (!commonParts.containsKey(i)) {
          // Add ellipsis only if there's a gap of more than 1 part
          if (i - lastNonCommonIndex > 1) {
            // if (parts[i].length > 1) {
            resultParts.add('...');
          }
          resultParts.add(parts[i]);
          lastNonCommonIndex = i;
        }
      }

      // Ensure the result is not an empty string
      final result = resultParts
          .join(' ')
          .replaceAll(" ... ", "...")
          .replaceAll(" ...", "...")
          .replaceAll("... ", "...");
      return result.isNotEmpty ? result : validStrings[index];
    });
  }
}

extension DateList<E> on List<E> {
  ///Uses [sortByDate] to insert a date separator in a list. This does not sort.
  List<Widget> insertDateSeparatorWidget(
      DateTime? Function(E element)? dateTime,
      {required Widget Function(
              {required String title, required List<E> values})
          separator,
      required Widget Function(E) tile}) {
    return sortByDate(dateTime, doNotSort: true)
        .entries
        .map((e) => <Widget>[
              separator.call(title: e.key, values: e.value),
              ...e.value.map((e) => tile.call(e))
            ])
        .expand<Widget>(
          (e) => e,
        )
        .toList();
  }

  Map<String, List<E>> sortByDate(DateTime? Function(E element)? dateTime,
      {bool inplace = false,
      int? take,
      bool removeNull = false,
      bool removeDuplicates = false,
      bool doNotSort = false}) {
    final today = DateTime.now();
    final lastSevenDays = today.subtract(const Duration(days: 7));

    final groupedByTime = <String, List<E>>{};
    final seenMessages = <int, bool>{};

    void addToMap(Map<String, List<E>> groupedByTime, String key, E element) {
      if (!groupedByTime.containsKey(key)) {
        groupedByTime[key] = [];
      }
      groupedByTime[key]!.add(element);
    }

    customSort(List list) {
      return doNotSort ? list : list
        ..sort((a, b) =>
            dateTime!(b)?.compareTo(dateTime(a) ?? DateTime(2000)) ?? 0);
    }

    for (final bericht in customSort(
            where((e) => dateTime!(e) != null || !removeNull).toList())
        .take(take ?? length)) {
      if (dateTime!(bericht) == null) {
        if (!seenMessages.containsKey(bericht.hashCode)) {
          addToMap(groupedByTime, 'Overige data', bericht);
        }
      } else if (dateTime(bericht)!.isToday) {
        if (!seenMessages.containsKey(bericht.hashCode)) {
          addToMap(groupedByTime, 'Vandaag', bericht);
          seenMessages[bericht.hashCode] = true;
        }
      } else if (dateTime(bericht)!.add(const Duration(days: 1)).isToday) {
        if (!seenMessages.containsKey(bericht.hashCode)) {
          addToMap(groupedByTime, 'Gisteren', bericht);
          seenMessages[bericht.hashCode] = true;
        }
      } else if (dateTime(bericht)!.isAfter(lastSevenDays)) {
        if (!seenMessages.containsKey(bericht.hashCode)) {
          addToMap(groupedByTime, 'Afgelopen 7 dagen', bericht);
          seenMessages[bericht.hashCode] = true;
        }
      } else {
        final monthName = DateFormat.yMMMM().format(dateTime(bericht)!);
        if (!groupedByTime.containsKey(monthName)) {
          groupedByTime[monthName] = [];
        }
        if (!seenMessages.containsKey(bericht.hashCode)) {
          groupedByTime[monthName]!.add(bericht);
          seenMessages[bericht.hashCode] = true;
        }
      }
    }

    return groupedByTime;
  }
}

extension DoubleExtention on double {
  String displayNumber({int? decimalDigits, int maxDecimalDigits = 2}) {
    var precisionWithPow10 = pow(10, maxDecimalDigits);
    return isNaN
        ? "-"
        : NumberFormat.decimalPatternDigits(
                locale: Platform.localeName, decimalDigits: decimalDigits)
            .format(decimalDigits != null
                ? num.parse(toStringAsFixed(decimalDigits))
                : (this * precisionWithPow10).round() / precisionWithPow10);
  }
}

// var precisionWithPow10 = pow(10, precision);
// return (number * precisionWithPow10).round() / precisionWithPow10;

class EllipsisInMiddleText extends StatelessWidget {
  final String text;
  final int maxLines;

  const EllipsisInMiddleText(this.text, {super.key, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: DefaultTextStyle.of(context).style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: double.infinity);

        final textWidth = textPainter.width;

        if (textWidth <= availableWidth) {
          // Text fits within the available width, no need for ellipsis.
          return Text(text);
        } else {
          // Calculate the maxLength based on available space.
          final maxLength = (availableWidth / textWidth * text.length).floor();
          final firstPart = text.substring(0, maxLength ~/ 2);
          final secondPart = text.substring(text.length - maxLength ~/ 2);
          return FittedBox(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: firstPart,
                    style: DefaultTextStyle.of(context).style,
                  ),
                  TextSpan(
                    text: '...',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  TextSpan(
                    text: secondPart,
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class AllowedNotAllowedIcon extends StatelessWidget {
  const AllowedNotAllowedIcon({super.key, required this.allowed});

  final bool allowed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: allowed
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.error,
      foregroundColor: allowed
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onError,
      child: allowed ? const Icon(Icons.done) : const Icon(Icons.close),
    );
  }
}

class RowTile extends StatelessWidget {
  const RowTile({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Text(
              title,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
