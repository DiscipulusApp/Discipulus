import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/screens/grades/grades_subject.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';

class AverageGrades extends StatefulWidget {
  const AverageGrades({super.key, this.schoolYear});

  final Schoolyear? schoolYear;

  @override
  State<AverageGrades> createState() => _AverageGradesState();
}

class _AverageGradesState extends State<AverageGrades> {
  List<Subject> subjects = [];

  update() async {
    subjects =
        (widget.schoolYear ?? activeProfile.schoolyears.last).subjects.toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...subjects
              .where((g) => g.grades.toList().useable.isNotEmpty)
              .map((e) => InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SubjectGradesScreen(subject: e),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        direction: Axis.vertical,
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          GradeAvatar(
                            gradeString:
                                e.grades.filter().averageSync.toString(),
                          ),
                          Text(e.afkorting.capitalized)
                        ],
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
