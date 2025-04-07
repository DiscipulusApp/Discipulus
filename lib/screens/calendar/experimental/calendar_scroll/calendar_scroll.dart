// import 'package:discipulus/api/models/calendar.dart';
// import 'package:discipulus/core/routes.dart';
// import 'package:discipulus/screens/calendar/calendar_day/calendar_day_header.dart';
// import 'package:discipulus/screens/calendar/widgets/calendar_listtile.dart';
// import 'package:discipulus/utils/account_manager.dart';
// import 'package:discipulus/screens/calendar/ext_calendar.dart';
// import 'package:discipulus/widgets/global/list_decoration.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:isar/isar.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';

// DateTime indexToDate(int index) {
//   return DateTime(1970, 01, 05).add(Duration(days: index));
// }

// int dateToIndex(DateTime date) {
//   return date.difference(DateTime(1970, 01, 05)).inDays;
// }

// class DayEntry {
//   final List<List<CalendarEvent>> events;
//   final DateTime date;

//   const DayEntry({required this.events, required this.date});
// }

// /// Shows a dayview of the calendar
// class CalendarScrollView extends StatefulWidget {
//   const CalendarScrollView({super.key});

//   @override
//   State<CalendarScrollView> createState() => _CalendarDayViewState();
// }

// class _CalendarDayViewState extends State<CalendarScrollView> {
//   final Key downListKey = UniqueKey();
//   late final ValueNotifier<DateTime> selectedDay;

//   late final PagingController<int, DayEntry> _downPagingController;
//   late final PagingController<int, DayEntry> _upPagingController;
//   late final AutoScrollController _autoScrollController;

//   @override
//   void initState() {
//     selectedDay = ValueNotifier(DateTime.now());

//     // Create controllers
//     _autoScrollController = AutoScrollController();
//     _upPagingController =
//         PagingController(firstPageKey: dateToIndex(selectedDay.value));
//     _downPagingController =
//         PagingController(firstPageKey: dateToIndex(selectedDay.value));

//     // Add listeners
//     _upPagingController.addPageRequestListener((pageKey) {
//       _fetchPrevious(pageKey);
//     });
//     _downPagingController.addPageRequestListener((pageKey) {
//       _fetchNext(pageKey);
//     });
//     selectedDay.addListener(() {
//       _autoScrollController.scrollToIndex(
//         dateToIndex(selectedDay.value),
//         preferPosition: AutoScrollPosition.middle,
//         duration: Duration.zero,
//       );
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     selectedDay.dispose();
//     _autoScrollController.dispose();
//     _upPagingController.dispose();
//     _downPagingController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchNext(int pageKey) async {
//     try {
//       DateTime day = indexToDate(pageKey);

//       List<List<CalendarEvent>> events = (await activeProfile.calendarEvents
//               .filter()
//               .eindeBetween(day, day.add(const Duration(days: 1)))
//               .sortByStart()
//               .findAll())
//           .combineEvents();

//       DayEntry entry = DayEntry(date: day, events: events);

//       _downPagingController.appendPage([entry], pageKey + 1);
//     } catch (error) {
//       _downPagingController.error = error;
//     }
//   }

//   Future<void> _fetchPrevious(int pageKey) async {
//     try {
//       DateTime day = indexToDate(pageKey);

//       List<List<CalendarEvent>> events = (await activeProfile.calendarEvents
//               .filter()
//               .eindeBetween(day.subtract(const Duration(days: 1)), day)
//               .sortByStart()
//               .findAll())
//           .combineEvents();

//       DayEntry entry = DayEntry(date: day, events: events);

//       _upPagingController.appendPage([entry], pageKey - 1);
//     } catch (error) {
//       _upPagingController.error = error;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           SliverOverlapAbsorber(
//             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//             sliver: ValueListenableBuilder(
//               valueListenable: selectedDay,
//               builder: (context, date, child) => SliverAppBar(
//                 leading: leadingAppBarButton(context),
//                 pinned: true,
//                 forceElevated: innerBoxIsScrolled,
//                 title: Text("${date.formattedDate}, Week ${date.weekNumber}"),
//                 actions: [
//                   if (date.dayOnly != DateTime.now().dayOnly)
//                     IconButton(
//                       onPressed: () async => selectedDay.value = DateTime.now(),
//                       icon: const Icon(Icons.today),
//                     ),
//                   IconButton(
//                     onPressed: () async {
//                       DateTime? date = await showDatePicker(
//                         context: context,
//                         firstDate: DateTime(1970, 01, 05),
//                         lastDate: DateTime.now().add(
//                           const Duration(days: 365 * 2),
//                         ),
//                       );
//                       // If the selected date is a day, go to that day
//                       if (date != null) selectedDay.value = date;
//                     },
//                     icon: const Icon(Icons.date_range),
//                   )
//                 ],
//                 bottom: child! as PreferredSizeWidget,
//               ),
//               child: BottomDaySelectHeader(
//                 selectedDay: selectedDay,
//               ),
//             ),
//           ),
//         ],
//         body: Builder(
//           builder: (context) {
//             return Scrollable(
//               controller: _autoScrollController,
//               viewportBuilder: (BuildContext context, ViewportOffset position) {
//                 return Viewport(
//                   offset: position,
//                   center: downListKey,
//                   slivers: [
//                     SliverOverlapInjector(
//                       handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                           context),
//                     ),
//                     PagedSliverList<int, DayEntry>.separated(
//                       pagingController: _upPagingController,
//                       builderDelegate:
//                           PagedChildBuilderDelegate(itemBuilder: itemBuilder),
//                       separatorBuilder: (context, index) =>
//                           separatorBuilder(context, index, false),
//                     ),
//                     PagedSliverList<int, DayEntry>.separated(
//                       key: downListKey,
//                       pagingController: _downPagingController,
//                       builderDelegate:
//                           PagedChildBuilderDelegate(itemBuilder: itemBuilder),
//                       separatorBuilder: (context, index) =>
//                           separatorBuilder(context, index, true),
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget itemBuilder(BuildContext context, DayEntry item, int index) {
//     if (item.date.weekday < 6 && item.events.isEmpty) {
//       return const ListTile(
//         title: Text("Geen lessen"),
//       );
//     }
//     return AutoScrollTag(
//       key: ValueKey(item.date),
//       controller: _autoScrollController,
//       index: dateToIndex(item.date),
//       child: Column(
//         children:
//             item.events.map((e) => SimpleDayViewEventTile(event: e)).toList(),
//       ),
//     );
//   }

//   Widget separatorBuilder(BuildContext context, int index, bool isDown) {
//     DayEntry? day = (isDown
//         ? (_downPagingController.itemList?[index + 1])
//         : _upPagingController.itemList?[index + 1]);

//     if (day != null && day.date.weekday == 7) {
//       // Week indicator
//       return SizedBox(
//         height: 200,
//         child: Material(
//           color: Theme.of(context).colorScheme.primaryContainer,
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Week ${day.date.weekNumber}",
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 Text(day.date.formattedDate)
//               ],
//             ),
//           ),
//         ),
//       );
//     } else if (day != null &&
//         ((day.date.weekday <= 5 && day.events.isEmpty) ||
//             day.events.isNotEmpty)) {
//       // Day indicator
//       return ListTitle(child: Text(day.date.dayName));
//     }
//     return const SizedBox();
//   }
// }
