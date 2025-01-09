import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';

class RecentGrades extends StatefulWidget {
  const RecentGrades({super.key});

  @override
  State<RecentGrades> createState() => _RecentGradesState();
}

class _RecentGradesState extends State<RecentGrades> {
  List<Grade> grades = [];

  update() async {
    grades = await activeProfile.schoolyears.last.grades
        .filter()
        .useable()
        .sortByDatumIngevoerdDesc()
        .thenById()
        .limit(20)
        .findAll();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...grades
            .sortByDate((e) => e.datumIngevoerd,
                take: 3, removeNull: true, doNotSort: true)
            .entries
            .toList()
            .map((e) => Column(
                  children: [
                    ListTitle(child: Text(e.key)),
                    ...e.value.map((e) => GradeTile(
                          grade: e,
                        )),
                  ],
                ))
            
      ],
    );
  }
}
