import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';

class GradeCalculationCard extends StatefulWidget {
  const GradeCalculationCard({
    super.key,
    this.toNewAverage = false,
    required this.grades,
    this.weight,
    this.ignoredGradeUUID,
    this.onResult,
  });

  final bool toNewAverage;
  final int? ignoredGradeUUID;
  final QueryBuilder<Grade, Grade, QAfterFilterCondition> grades;
  final double? weight;
  final void Function(double? grade, double? average, double? weight)? onResult;

  @override
  State<GradeCalculationCard> createState() => _GradeCalculationCardState();
}

class Result {
  double value;
  double change;
  Result({required this.value, required this.change});
}

class _GradeCalculationCardState extends State<GradeCalculationCard> {
  late TextEditingController gradeController;
  late TextEditingController weightController;
  late ValueKey key;
  // double result = double.nan;

  Future<Result?> calculate() async {
    double? gradeValue =
        double.tryParse(gradeController.text.replaceAll(',', '.'));
    double? weightValue =
        double.tryParse(weightController.text.replaceAll(',', '.'));

    if (gradeValue != null && weightValue != null && weightValue != 0) {
      if (widget.toNewAverage) {
        var newAverage = await widget.grades.newAverageFromGrade(
            [DummyGrade(grade: gradeValue, weight: weightValue)],
            ignoredGradeUUID: widget.ignoredGradeUUID);
        widget.onResult
            ?.call(gradeValue, newAverage, weightValue == 0 ? 1 : weightValue);
        return Result(
          value: newAverage,
          change: newAverage -
              widget.grades
                  .optional(widget.ignoredGradeUUID != null,
                      (q) => q.not().idEqualTo(widget.ignoredGradeUUID!))
                  .findAllSync()
                  .average,
        ); //TODO: Remove ignoredGrades
      } else {
        var newGrade = await widget.grades.newGradeFromAverage(
            gradeValue, weightValue,
            ignoredGradeUUID: widget.ignoredGradeUUID);
        Result result = Result(
          value: newGrade,
          change: gradeValue -
              widget.grades
                  .optional(widget.ignoredGradeUUID != null,
                      (q) => q.not().idEqualTo(widget.ignoredGradeUUID!))
                  .findAllSync()
                  .average,
        ); //TODO: Remove ignoredGrades
        widget.onResult?.call(newGrade, gradeValue, weightValue);
        return result;
      }
    } else {
      widget.onResult?.call(
          widget.toNewAverage
              ? double.tryParse(gradeController.text.replaceAll(',', '.'))
              : null,
          !widget.toNewAverage
              ? double.tryParse(gradeController.text.replaceAll(',', '.'))
              : null,
          double.tryParse(weightController.text.replaceAll(',', '.')));
      return null;
    }
  }

  @override
  void initState() {
    key = ValueKey(widget.toNewAverage);
    super.initState();
    gradeController = TextEditingController();
    weightController = TextEditingController(
      text: widget.weight?.displayNumber(),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculate();
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              visualDensity: VisualDensity.standard,
            ),
            child: SizedBox(
              width: (constraints.maxWidth / 2).clamp(100, 200),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomCard(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextField(
                          // This is to make the highlight grade reactivate
                          onTap: calculate,
                          onChanged: (value) =>
                              calculate().then((value) => setState(() {})),
                          controller: gradeController,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: widget.toNewAverage
                                  ? const Icon(Icons.numbers_outlined)
                                  : const Icon(Icons.show_chart_rounded),
                            ),
                            labelText:
                                widget.toNewAverage ? "Cijfer" : "Gemiddelde",
                            border: InputBorder.none,
                            filled: false,
                            isDense: false,
                          ),
                        ),
                        const CustomCard(
                          margin: EdgeInsets.zero,
                          child: Divider(
                            color: Colors.transparent,
                            thickness: 4,
                            height: 4,
                          ),
                        ),
                        TextField(
                          // This is to make the highlight grade reactivate
                          onTap: calculate,
                          onChanged: (value) =>
                              calculate().then((value) => setState(() {})),
                          controller: weightController,
                          textInputAction: TextInputAction.done,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: "Weging",
                            hintText: widget.weight?.displayNumber(),
                            border: InputBorder.none,
                            filled: false,
                            isDense: false,
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Icon(Icons.balance_outlined),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: Padding(
                padding: Theme.of(context)
                        .cardTheme
                        .margin
                        ?.subtract(const EdgeInsets.only(left: 0)) ??
                    EdgeInsets.zero,
                child: FutureBuilder<Result?>(
                    future: calculate(),
                    builder: (context, snapshot) {
                      return Center(
                        child:
                            snapshot.data == null || snapshot.data!.value.isNaN
                                ? Icon(
                                    !widget.toNewAverage
                                        ? Icons.numbers_outlined
                                        : Icons.show_chart_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                  )
                                : CalcResult(result: snapshot.data!),
                      );
                    }),
              ))
        ],
      ),
    );
  }
}

//  Change
//  - New average:
//    Show change current average vs newly calculated
//
//  - New grade
//    Show what the grade would do with the average

class CalcResult extends StatelessWidget {
  const CalcResult({super.key, required this.result});

  final Result result;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElasticAnimation(
          child: Text(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        key: ValueKey(result.value.displayNumber()),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 24,
          fontWeight: FontWeight.bold,
          color: (result.value < 1 || result.value > 10)
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
        result.value.displayNumber(decimalDigits: 2),
      )),
      SizedBox(
        width: 100,
        child: Divider(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          thickness: 4,
          height: 8,
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotateAnimation(
            child: Icon(
                color: result.change == 0
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : (result.change < 0 || result.change > 10)
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                size: (32 * MediaQuery.of(context).textScaleFactor),
                result.change.isNegative
                    ? Icons.trending_down
                    : result.change == 0
                        ? Icons.trending_flat
                        : Icons.trending_up),
          ),
          Flexible(
            child: ElasticAnimation(
                child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              key: ValueKey(result.change.displayNumber()),
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.titleLarge?.fontSize ?? 24,
                  fontWeight: FontWeight.bold,
                  color: result.change == 0
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : (result.change < 0 || result.change > 10)
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary),
              " ${result.change.displayNumber(decimalDigits: 2)}",
            )),
          ),
        ],
      ),
    ]);
  }
}
