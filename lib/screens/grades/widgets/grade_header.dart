import 'package:collection/collection.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class StatisticalTilesHeader extends StatelessWidget {
  const StatisticalTilesHeader({super.key, required this.grades});

  final QueryBuilder<Grade, Grade, QAfterFilterCondition> grades;

  @override
  Widget build(BuildContext context) {
    List<double> doubles = grades.numericalGrades
        .cijferStrProperty()
        .findAllSync()
        .map((e) => double.parse(e!.replaceAll(',', '.')))
        .toList();
    double average = grades.useable().averageSync;
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            children: [
              HeaderTile(
                isSpecial: true,
                icon: const Icon(Icons.numbers),
                negative: average < appSettings.sufficientFrom,
                value: average.displayNumber(decimalDigits: 2),
              ),
              HeaderTile(
                icon: const Icon(Icons.grading_rounded),
                value:
                    "${(doubles.where((d) => d >= appSettings.sufficientFrom).length / doubles.length * 100).displayNumber(maxDecimalDigits: 1)}%",
              ),
              HeaderTile(
                icon: const Icon(Icons.arrow_upward),
                value: (doubles.isEmpty ? double.nan : doubles.max)
                    .displayNumber(),
              ),
              HeaderTile(
                icon: const Icon(Icons.arrow_downward),
                value: (doubles.isEmpty ? double.nan : doubles.min)
                    .displayNumber(),
              )
            ]
                .splitByChunks(constraints.maxWidth > 600 ? 4 : 2)
                .map((e) => Row(
                      children: [
                        ...e.map((e) {
                          Color color = e.negative
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant;
                          return Expanded(
                            child: CustomCard(
                                elevation: e.isSpecial ? 5 : null,
                                surfaceTintColor: e.negative
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                                child: ListTile(
                                  leading: e.icon,
                                  iconColor: color,
                                  textColor: color,
                                  title: ElasticAnimation(
                                    child: Text(
                                      key: ValueKey(e.value),
                                      e.value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                  ),
                                  onTap: e.onTap,
                                )),
                          );
                        }),
                      ],
                    ))
                .toList(),
          ));
    });
  }
}

class HeaderTile {
  final String value;
  final Icon icon;
  void Function()? onTap;
  final bool isSpecial;
  final bool negative;

  HeaderTile({
    required this.value,
    required this.icon,
    this.isSpecial = false,
    this.negative = false,
    this.onTap,
  });
}
