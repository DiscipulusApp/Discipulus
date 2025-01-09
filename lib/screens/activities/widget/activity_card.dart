import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/screens/activities/activity_detail.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard(
      {super.key, required this.activity, this.navigationCard = true});

  final Activity activity;

  /// If this is true the title and buttons will be shown
  final bool navigationCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Hero(
              tag: "ActivityCardHeadlineInformation_${activity.id}",
              child: Table(
                columnWidths: [
                  if (activity.eindeInschrijfdatum
                      .difference(DateTime.now())
                      .isNegative)
                    const FixedColumnWidth(56.0),
                  const FlexColumnWidth(),
                ].asMap(),
                children: [
                  TableRow(
                    children: [
                      if (activity.eindeInschrijfdatum
                          .difference(DateTime.now())
                          .isNegative)
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Card(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: const Icon(Icons.lock_rounded),
                          ),
                        ),
                      LayoutBuilder(builder: (context, constraints) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.date_range),
                              title: Text(activity.eindeInschrijfdatum
                                  .formattedDateAndTimWithoutYear),
                            ),
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(
                                  "${activity.aantalInschrijvingen} (${activity.minimumAantalInschrijvingenPerActiviteit}/${activity.maximumAantalInschrijvingenPerActiviteit})"),
                              trailing: (activity.aantalInschrijvingen >=
                                      activity
                                          .minimumAantalInschrijvingenPerActiviteit)
                                  ? (activity.aantalInschrijvingen > 0)
                                      ? const Icon(Icons.done_all)
                                      : const Icon(Icons.done)
                                  : const Icon(Icons.warning_amber),
                            )
                          ]
                              .map((e) => CustomCard(
                                    elevation: 0,
                                    child: e,
                                  ))
                              .wrapOn(constraints, wrapWidth: 500),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            );
          }),
          if (navigationCard)
            ListTile(
              leading: const Icon(Icons.short_text),
              title: Text(activity.titel),
            ),
          Table(columnWidths: const {
            0: FlexColumnWidth(),
            1: FixedColumnWidth(56.0)
          }, children: [
            TableRow(
              children: [
                CustomCard(
                  elevation: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: navigationCard
                        ? Text(
                            activity.details!.withoutHTML ?? "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        : HTMLDisplay(html: activity.details!),
                  ),
                ),
                if (navigationCard)
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: IconButton.filled(
                        constraints:
                            const BoxConstraints(minHeight: double.infinity),
                        onPressed: () =>
                            ActivityDetailScreen(activity: activity)
                                .push(context),
                        icon: const Icon(Icons.navigate_next),
                      ),
                    ),
                  )
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
