import 'package:discipulus/screens/grades/widgets/grade_header.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';

export 'package:discipulus/screens/grades/widgets/grade_header.dart'
    show HeaderTile;

class CalendarStatisticalTilesHeader extends StatelessWidget {
  const CalendarStatisticalTilesHeader({
    super.key,
    required this.tiles,
  });

  final List<HeaderTile> tiles;

  factory CalendarStatisticalTilesHeader.general({
    Key? key,
    required double totalHours,
    required int canceledCount,
    required int subjectCount,
    required int teacherCount,
  }) {
    return CalendarStatisticalTilesHeader(
      key: key,
      tiles: [
        HeaderTile(
          isSpecial: true,
          icon: const Icon(Icons.schedule),
          value: "${totalHours.round()} uur",
        ),
        HeaderTile(
          icon: const Icon(Icons.event_busy),
          negative: canceledCount > 0,
          value: "$canceledCount uur uitval",
        ),
        HeaderTile(
          icon: const Icon(Icons.auto_stories),
          value: "$subjectCount vakken",
        ),
        HeaderTile(
          icon: const Icon(Icons.people_alt_outlined),
          value: "$teacherCount docenten",
        ),
      ],
    );
  }

  factory CalendarStatisticalTilesHeader.teacher({
    Key? key,
    required double totalHours,
    required int totalLessons,
    required int canceledCount,
    required double canceledPercentage,
    required int schoolyearsCount,
  }) {
    return CalendarStatisticalTilesHeader(
      key: key,
      tiles: [
        HeaderTile(
          isSpecial: true,
          icon: const Icon(Icons.schedule),
          value: "${totalHours.round()} uur",
        ),
        HeaderTile(
          icon: const Icon(Icons.meeting_room_outlined),
          value: "$totalLessons lessen",
        ),
        HeaderTile(
          icon: const Icon(Icons.event_busy),
          negative: canceledCount > 0,
          value:
              "$canceledCount uitval (${canceledPercentage.toStringAsFixed(1)}%)",
        ),
        HeaderTile(
          icon: const Icon(Icons.school_outlined),
          value:
              "$schoolyearsCount ${schoolyearsCount == 1 ? 'schooljaar' : 'schooljaren'}",
        ),
      ],
    );
  }

  factory CalendarStatisticalTilesHeader.subject({
    Key? key,
    required double totalHours,
    required int totalLessons,
    required int canceledCount,
    required double canceledPercentage,
    required int teachersCount,
  }) {
    return CalendarStatisticalTilesHeader(
      key: key,
      tiles: [
        HeaderTile(
          isSpecial: true,
          icon: const Icon(Icons.schedule),
          value: "${totalHours.round()} uur",
        ),
        HeaderTile(
          icon: const Icon(Icons.auto_stories_outlined),
          value: "$totalLessons lessen",
        ),
        HeaderTile(
          icon: const Icon(Icons.event_busy),
          negative: canceledCount > 0,
          value:
              "$canceledCount uitval (${canceledPercentage.toStringAsFixed(1)}%)",
        ),
        HeaderTile(
          icon: const Icon(Icons.people_alt_outlined),
          value:
              "$teachersCount ${teachersCount == 1 ? 'docent' : 'docenten'}",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            children: tiles
                .splitByChunks(constraints.maxWidth > 600 ? 4 : 2)
                .map(
                  (row) => Row(
                    children: row.map((e) {
                      final color = e.negative
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant;
                      return Expanded(
                        child: CustomCard(
                          elevation: e.isSpecial ? 5 : null,
                          surfaceTintColor: e.negative
                              ? theme.colorScheme.error
                              : null,
                          child: ListTile(
                            leading: e.icon,
                            iconColor: color,
                            textColor: color,
                            title: ElasticAnimation(
                              child: Text(
                                key: ValueKey(e.value),
                                e.value,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: e.onTap,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
