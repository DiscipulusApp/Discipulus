import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class CalendarStatistics extends StatefulWidget {
  const CalendarStatistics({super.key});

  @override
  State<CalendarStatistics> createState() => _CalendarStatisticsState();
}

class _CalendarStatisticsState extends State<CalendarStatistics> {
  int amountOfMinutes = 0;

  Future<void> refresh() async {
    amountOfMinutes = 0;
    List<DateTime> start = await activeProfile.calendarEvents
        .filter()
        .startLessThan(DateTime.now())
        .sortByStart()
        .startProperty()
        .findAll();

    List<DateTime> end = await activeProfile.calendarEvents
        .filter()
        .startLessThan(DateTime.now())
        .sortByStart()
        .eindeProperty()
        .findAll();

    for ((int, DateTime) i in start.indexed) {
      amountOfMinutes += end[i.$1].difference(i.$2).inMinutes;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      fetch: (_) => refresh(),
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Statistieken"),
        leading: leading,
        actions: [if (trailingRefreshButton != null) trailingRefreshButton],
      ),
      children: [Center(child: Text("$amountOfMinutes minuten"))],
    );
  }
}
