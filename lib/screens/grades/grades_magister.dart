import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/scaffold_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class GradesMagisterView extends StatelessWidget {
  const GradesMagisterView({super.key, required this.schoolyear});

  final Schoolyear schoolyear;

  @override
  Widget build(BuildContext context) {
    return TabbedScaffoldSkeleton(
      tabs: {}..addEntries(
          schoolyear.periods
              .filter()
              .grades((q) => q.cijferKolom((q) => q.kolomSoortEqualTo(2)))
              .gradesIsNotEmpty()
              .sortByNaam()
              .findAllSync()
              .map((e) {
            Map<String, Map<String, String>> createGradeTable(
                List<Grade> data) {
              Map<String, Map<String, String>> result = {};

              for (Grade entry in data) {
                final subjectUUID = entry.subject.value?.naam.capitalized;
                final kolomNummer = entry.cijferKolom.kolomNummer;
                final cijferStr = entry.cijferStr;

                result.putIfAbsent(subjectUUID ?? "", () => {});
                result[subjectUUID]![kolomNummer ?? ""] = cijferStr ?? "";
              }

              return result;
            }

            Map<String, Map<String, String>> gradeData =
                createGradeTable(e.grades.toList());

            final allKolomNummers = gradeData.values
                .expand((element) => element.keys)
                .toSet()
                .toList();

            return MapEntry(
              Tab(text: e.naam),
              RefreshableCustomScrollView(
                injectOverlap: true,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        const DataColumn(label: Text('Vak')),
                        for (var kolomNummer in allKolomNummers)
                          DataColumn(
                            label: Text(kolomNummer),
                          ),
                      ],
                      rows: gradeData.entries.map((entry) {
                        final subject = entry.key;
                        final grades = entry.value;

                        return DataRow(
                          cells: [
                            DataCell(Text(subject)),
                            for (var kolomNummer in allKolomNummers)
                              DataCell(
                                Text(grades[kolomNummer] ?? ""),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
    );
  }
}

class AverageGradeTile extends StatelessWidget {
  const AverageGradeTile({
    super.key,
    required this.gradeStrings,
    required this.subject,
    this.updatedDate,
  });

  final List<String> gradeStrings;
  final String subject;
  final DateTime? updatedDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Material(
        child: Wrap(
          spacing: 8,
          children: [
            for ((int, String) indexed in gradeStrings.indexed)
              GradeAvatar(
                gradeString: indexed.$2,
                decimalDigits: (indexed.$2.length - 2).clamp(0, 3),
              ),
          ],
        ),
      ),
      title: Text(
        subject,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: updatedDate != null
          ? Text(updatedDate!.formattedDateWithoutYear)
          : null,
    );
  }
}
