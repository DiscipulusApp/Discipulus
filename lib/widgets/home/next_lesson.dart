// import 'package:discipulus/screens/calendar/calendar_details.dart';
// import 'package:discipulus/utils/ext_calendar.dart';
// import 'package:discipulus/utils/extensions.dart';
// import 'package:discipulus/widgets/animations/widgets.dart';
// import 'package:discipulus/widgets/calendar/calendar_tiles.dart';
// import 'package:discipulus/widgets/global/bottom_sheet.dart';
// import 'package:discipulus/widgets/global/card.dart';
// import 'package:discipulus/widgets/global/list_decoration.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
// import 'package:isar/isar.dart';
// import 'package:discipulus/api/models/calendar.dart';
// import 'package:discipulus/utils/account_manager.dart';

// class NextEvents extends StatefulWidget {
//   const NextEvents({super.key});

//   @override
//   State<NextEvents> createState() => _NextEventsState();
// }

// class _NextEventsState extends State<NextEvents> {
//   late final CarouselController controller;
//   Map<DateTime, List<CalendarEvent>> events = {};
//   Set<String> selectedSegments = {};
//   late final ValueNotifier<Map<DateTime, CalendarEvent?>?> event =
//       ValueNotifier(null);

//   Future<void> update() async {
//     List<CalendarEvent> rawEvents = await activeProfile.calendarEvents
//         .filter()
//         .duurtHeleDagEqualTo(false)
//         .eindeGreaterThan(DateTime.now().dayOnly)
//         .sortByStart()
//         .limit(25)
//         .findAll();
//     events = rawEvents
//         .where((event) =>
//             (selectedSegments.contains("homework") &&
//                 event.infoType == InfoType.homework) ||
//             (selectedSegments.contains("test") &&
//                 event.infoType.index >= InfoType.test.index &&
//                 event.infoType.index <= InfoType.oralExam.index) ||
//             selectedSegments.isEmpty &&
//                 event.start.dayOnly == rawEvents.first.start.dayOnly)
//         .toList()
//         .splitPerDay;
//   }

//   @override
//   void initState() {
//     controller = CarouselController();
//     super.initState();
//     update().then((value) => setState(() {
//           event.value = {
//             events.values.first.first.start: events.values.first.first
//           };
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//         builder: (context, constraints) => SizedBox(
//               height: constraints.maxWidth > 600 ? 225 : 225 * (5 / 3),
//               child: Wrap(
//                 children: <Widget>[
//                   if (events.isNotEmpty)
//                     SizedBox(
//                         height: 225,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Expanded(
//                               child: CustomCard(
//                                 elevation: 0,
//                                 margin: const EdgeInsets.all(8.0),
//                                 child: ValueListenableBuilder<
//                                     Map<DateTime, CalendarEvent?>?>(
//                                   valueListenable: event,
//                                   builder: (context, value, child) {
//                                     return value == null
//                                         ? const SizedBox()
//                                         : value.values.first != null
//                                             ? InkWell(
//                                                 onTap: () =>
//                                                     showScrollableModalBottomSheet(
//                                                       context: context,
//                                                       builder: (context,
//                                                               setState,
//                                                               scrollcontroller) =>
//                                                           SingleChildScrollView(
//                                                               controller:
//                                                                   scrollcontroller,
//                                                               child:
//                                                                   CalendarEventDetails(
//                                                                 event: value
//                                                                     .values
//                                                                     .first!,
//                                                                 callback: () =>
//                                                                     setState(
//                                                                         () {}),
//                                                               )),
//                                                     ),
//                                                 child: Padding(
//                                                     padding: const EdgeInsets
//                                                             .all(12.0)
//                                                         .copyWith(bottom: 0),
//                                                     child: NextEventBigCard(
//                                                       event:
//                                                           value.values.first!,
//                                                     )))
//                                             : Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(12.0),
//                                                 child: DaySumCard(
//                                                   events:
//                                                       events[value.keys.first]!,
//                                                 ),
//                                               );
//                                   },
//                                 ),
//                               ),
//                             ),
//                             CustomAnimatedSize(
//                               child: ValueListenableBuilder<
//                                       Map<DateTime, CalendarEvent?>?>(
//                                   valueListenable: event,
//                                   builder: (context, value, child) {
//                                     return value?.values.first
//                                                 ?.importantDetails !=
//                                             null
//                                         ? Padding(
//                                             padding: const EdgeInsets.all(8.0)
//                                                 .copyWith(top: 0),
//                                             child: Row(
//                                                 children: value!.values.first!
//                                                     .importantDetails
//                                                     .map<Widget>((e) =>
//                                                         Expanded(
//                                                           child: CustomCard(
//                                                             margin:
//                                                                 EdgeInsets.zero,
//                                                             elevation: 0,
//                                                             child: ListTile(
//                                                               leading: Icon(Icons
//                                                                   .info_outline),
//                                                               title: Text(
//                                                                 e.change,
//                                                                 maxLines: 1,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ))
//                                                     .intersperse(
//                                                         SizedBox(width: 8))
//                                                     .toList()),
//                                           )
//                                         : const SizedBox();
//                                   }),
//                             ),
//                             //
//                             //  This widget could originally look into the future and display tests and
//                             //  homework, but since it was not a good way of looking at events the functionallity was removed
//                             //
//                             // Padding(
//                             //   padding:
//                             //       const EdgeInsets.all(8.0).copyWith(top: 0),
//                             //   child: SegmentedButton(
//                             //       emptySelectionAllowed: true,
//                             //       multiSelectionEnabled: true,
//                             //       onSelectionChanged: (selection) {
//                             //         selectedSegments = selection;
//                             //         update().then((value) => setState(() {
//                             //               event.value = null;
//                             //             }));
//                             //       },
//                             //       style: const ButtonStyle(
//                             //           visualDensity: VisualDensity.compact),
//                             //       segments: const [
//                             //         ButtonSegment(
//                             //             value: "homework",
//                             //             label: Text("Huiswerk")),
//                             //         ButtonSegment(
//                             //             value: "test", label: Text("Toetsen"))
//                             //       ],
//                             //       selected: selectedSegments),
//                             // )
//                           ],
//                         )),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: ClipRect(
//                       child: Transform.translate(
//                           offset: Offset(
//                               0,
//                               constraints.maxWidth > 600
//                                   ? 0
//                                   : -(225 - ((225 * (5 / 3)) - 225))),
//                           child: _carousel()),
//                     ),
//                   )
//                 ]
//                     .toList()
//                     .splitByChunks(constraints.maxWidth > 600 ? 2 : 1)
//                     .map((e) => Row(
//                           children: e.map((e) => Expanded(child: e)).toList(),
//                         ))
//                     .toList(),
//               ),
//             ));
//   }

//   /// Courousel widget
//   Widget _carousel() {
//     return FlutterCarousel(
//         items: [
//           ...events.entries
//               .map((m) => [
//                     Card.outlined(
//                         key: ValueKey(m.key),
//                         elevation: 1,
//                         child: ListTile(
//                           leading: const Icon(Icons.calendar_today),
//                           title: Text(m.key.formattedDateWithoutYear),
//                           subtitle: Text("${m.value.length} evenementen"),
//                         )),
//                     ...m.value.map((e) => Theme(
//                         key: ValueKey(e.id),
//                         data: Theme.of(context).copyWith(
//                             cardTheme:
//                                 CardTheme.of(context).copyWith(elevation: 0)),
//                         child: InkWell(
//                           onTap: () => controller.animateToPage(
//                               m.value.indexWhere((ev) => ev.id == e.id) + 1,
//                               duration: const Duration(milliseconds: 100)),
//                           child: AbsorbPointer(
//                             child: CalendarEventTile(
//                               event: e,
//                             ),
//                           ),
//                         )))
//                   ])
//               .expand((e) => e)

//           // ...events.keys
//           //     .map((e) => e.start.dayOnly)
//           //     .toSet()
//           //     .map((e) => Card.outlined(
//           //         elevation: 1,
//           //         child: ListTile(
//           //           leading: const Icon(Icons.calendar_today),
//           //           title: Text(e.formattedDateWithoutYear),
//           //           subtitle: Text("${events.length} evenementen"),
//           //         ))),
//           // ...events
//           //     .map((e) => Theme(
//           //         data: Theme.of(context).copyWith(
//           //             cardTheme: CardTheme.of(context).copyWith(elevation: 0)),
//           //         child: InkWell(
//           //           onTap: () => controller.animateToPage(
//           //               events.indexWhere((ev) => ev.id == e.id) + 1,
//           //               duration: const Duration(milliseconds: 100)),
//           //           child: AbsorbPointer(
//           //             child: CalendarEventTile(
//           //               event: e,
//           //             ),
//           //           ),
//           //         )))
//           //     .toList()
//         ],
//         options: CarouselOptions(
//             controller: controller,
//             initialPage: events.entries
//                 .expand((e) => [null, ...e.value])
//                 .toList()
//                 .indexWhere((e) =>
//                     e != null &&
//                         e.start.millisecondsSinceEpoch >=
//                             DateTime.now().millisecondsSinceEpoch &&
//                         e.einde.millisecondsSinceEpoch <=
//                             DateTime.now().millisecondsSinceEpoch ||
//                     true),
//             scrollDirection: Axis.vertical,
//             height: 225,
//             enlargeCenterPage: true,
//             padEnds: true,
//             viewportFraction: 1 / 3,
//             showIndicator: false,
//             scrollBehavior: const MaterialScrollBehavior(),
//             onPageChanged: (index, reason) {
//               List<CalendarEvent?> entries =
//                   events.entries.expand((e) => [null, ...e.value]).toList();
//               event.value = {
//                 (entries[index]?.start ?? entries[index + 1]!.start).dayOnly:
//                     entries[index]
//               };
//             },
//             enlargeStrategy: CenterPageEnlargeStrategy.scale));
//   }
// }

// class DaySumCard extends StatelessWidget {
//   const DaySumCard({super.key, required this.events});

//   final List<CalendarEvent> events;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             events.first.start.formattedDateWithoutYear.capitalized,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//         ]);
//   }
// }

// class NextEventBigCard extends StatelessWidget {
//   const NextEventBigCard({super.key, required this.event});

//   final CalendarEvent event;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomRight,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               event.title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             Row(children: [
//               Icon(Icons.access_time, size: 16),
//               Text(
//                   " ${event.start.formattedTime} - ${event.einde.formattedTime}"),
//             ]),
//             Row(children: [
//               Icon(Icons.pin_drop, size: 16),
//               Text(" ${event.lokatie}"),
//             ]),
//             Row(children: [
//               Icon(Icons.supervisor_account, size: 16),
//               Text(
//                   " ${event.docenten?.map((e) => e.naam).nonNulls.toList().formattedJoin}"),
//             ]),
//             const SizedBox(height: 4),
//             Expanded(child: Text(event.inhoud?.withoutHTML ?? ""))
//           ],
//         ),
//       ],
//     );
//   }
// }
