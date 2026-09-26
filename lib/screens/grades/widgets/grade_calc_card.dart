import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/screens/grades/widgets/calculator/average_to_grade_card.dart';
import 'package:discipulus/screens/grades/widgets/calculator/grade_to_average_card.dart';

export 'package:discipulus/screens/grades/widgets/calculator/average_to_grade_card.dart';
export 'package:discipulus/screens/grades/widgets/calculator/grade_to_average_card.dart';
export 'package:discipulus/screens/grades/widgets/calculator/grade_calculator_models.dart';
export 'package:discipulus/screens/grades/widgets/calculator/multigrade_tradeoff_graph.dart';

class GradeCalculationCard extends StatelessWidget {
  const GradeCalculationCard({
    super.key,
    this.toNewAverage = false,
    this.grades,
    this.initialGrade,
    this.weight,
    this.ignoredGradeUUID,
    this.onResult,
  });

  final bool toNewAverage;
  final int? ignoredGradeUUID;
  final QueryBuilder<Grade, Grade, QAfterFilterCondition>? grades;
  final double? initialGrade;
  final double? weight;
  final void Function(List<DummyGrade> grades, double? average)? onResult;

  @override
  Widget build(BuildContext context) {
    if (toNewAverage) {
      return GradeToAverageCalculatorCard(
        grades: grades,
        ignoredGradeUUID: ignoredGradeUUID,
        initialGrade: initialGrade,
        initialWeight: weight,
        onResult: onResult,
      );
    } else {
      return AverageToGradeCalculatorCard(
        grades: grades,
        ignoredGradeUUID: ignoredGradeUUID,
        initialTargetAverage: initialGrade,
        initialWeight: weight,
        onResult: onResult,
      );
    }
  }
}
