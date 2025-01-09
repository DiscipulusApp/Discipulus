import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class GradesTableView extends StatefulWidget {
  const GradesTableView({super.key, required this.schoolyear});

  final Schoolyear schoolyear;

  @override
  State<GradesTableView> createState() => _GradesTableViewState();
}

class GradesTableCell {
  int sortNumber;
  String columnNumber;
  String header;

  String content;
  Color color;

  GradesTableCell({
    required this.color,
    required this.content,
    required this.sortNumber,
    required this.header,
    required this.columnNumber,
  });
}

class _GradesTableViewState extends State<GradesTableView> {
  /// Map<Subject, Map<PeriodName, List<GradesTableCell>>>
  Map<String, Map<String, List<GradesTableCell>>> data = {};

  List<GradesTableCell> get sortedTableCells {
    final ids = <dynamic>{};
    return [
      for (List<GradesTableCell> cellsInPeriod
          in data.values.expand((e) => e.values))
        ...cellsInPeriod..sort((a, b) => a.sortNumber.compareTo(b.sortNumber))
    ]..retainWhere((x) => ids.add(x.columnNumber));
  }

  // Null when cell is empty
  Map<String, List<GradesTableCell?>> get gradesPerSubject {
    Map<String, List<GradesTableCell?>> newData = Map.fromEntries([
      for (String subject in data.keys) MapEntry(subject, sortedTableCells)
    ]);
    for (String subject in data.keys) {
      List<GradesTableCell> cells =
          data[subject]!.values.expand((e) => e).toList();

      for ((int, GradesTableCell) cell in cells.indexed) {
        int index = newData[subject]!
            .indexWhere((e) => e?.columnNumber == cell.$2.columnNumber);

        if (index != -1) {
          newData[subject]?[cell.$1]?.content = "";
        }
        newData[subject]?[index] = cell.$2;
      }
    }
    return newData;
  }

  @override
  void initState() {
    super.initState();
    data = Map.fromEntries(
      widget.schoolyear.subjects
          .filter()
          .sortByVolgnr()
          .findAllSync()
          .map((s) => MapEntry(
              s.naam,
              Map.fromEntries(
                widget.schoolyear.periods
                    .filter()
                    .sortByVolgNummer()
                    .findAllSync()
                    .map((e) => MapEntry(e.naam, [
                          for (Grade grade in e.grades
                              .filter()
                              .subject(
                                (q) => q.idEqualTo(s.id),
                              )
                              .findAllSync())
                            GradesTableCell(
                              color: Colors.red,
                              content: grade.cijferStr ?? "",
                              sortNumber:
                                  int.parse(grade.cijferKolom.kolomVolgNummer),
                              header: grade.cijferKolom.kolomKop ?? "No Name",
                              columnNumber: grade.cijferKolom.kolomNummer ?? "",
                            )
                        ])),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: CustomCard(
          margin: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(200),
            },
            defaultColumnWidth: const FixedColumnWidth(200),
            children: [
              // Headers
              TableRow(
                children: [
                  const TableCell(child: Text('Subject')),
                  for (GradesTableCell grade in sortedTableCells)
                    TableCell(
                        child: Text("${grade.header} ${grade.columnNumber}"))
                ],
              ),
              // Every subject
              for (MapEntry<String, List<GradesTableCell?>> subject
                  in gradesPerSubject.entries)
                TableRow(
                  children: [
                    TableCell(child: Text(subject.key)),
                    // Block of grades
                    for (GradesTableCell? cell in subject.value)
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Text(cell?.content ?? ""),
                      )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
