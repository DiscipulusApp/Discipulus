import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class RecentGradesWidget extends StatefulWidget {
  const RecentGradesWidget({super.key});

  @override
  State<RecentGradesWidget> createState() => _RecentGradesWidgetState();
}

class _RecentGradesWidgetState extends State<RecentGradesWidget> {
  List<Grade> grades = [];

  Future<void> setGrades() async {
    grades = await (await activeProfile.schoolyears
                .filter()
                .sortByEindeDesc()
                .findFirst())
            ?.grades
            .filter()
            .useable()
            .datumIngevoerdBetween(
                DateTime.now().subtract(const Duration(days: 7)),
                DateTime.now())
            .sortByDatumIngevoerdDesc()
            .limit(3)
            .findAll() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setGrades(),
        builder: (context, snapshot) {
          return CustomCard(
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FixedColumnWidth(48)
              },
              children: [
                TableRow(
                  key: ValueKey(activeProfile.settings.lastRefresh),
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(4)..copyWith(right: 0),
                        child: CustomCard(
                          child: Column(
                            children: [
                              if (grades.isEmpty)
                                const SizedBox(
                                  height: 80,
                                  child: Center(
                                    child: Text("Geen cijfers deze week"),
                                  ),
                                ),
                              for (Grade grade in grades)
                                GradeTile(
                                  grade: grade,
                                  setStateTop: setState,
                                )
                            ],
                          ),
                        )),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                        child: IconButton.filledTonal(
                          onPressed: () => Layout.of(context)?.goToPage(
                              const GradesListScreen(),
                              makeFirst: false),
                          icon: const Icon(Icons.navigate_next),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
