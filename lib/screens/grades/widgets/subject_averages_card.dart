import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/grades_subject.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/screens/grades/widgets/graphs/barchart_averages.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class AveragesTile extends StatefulWidget {
  const AveragesTile({
    super.key,
    required this.subjects,
  });

  final IsarLinks<Subject> subjects;

  @override
  State<AveragesTile> createState() => _AveragesTileState();
}

class _AveragesTileState extends State<AveragesTile> {
  late final ValueNotifier<List<Subject>> subjects;

  // Filters
  bool rounded = false;
  bool showTrend = false;

  /// Calculates the subjects that will be displayed
  Future<List<Subject>> setSubjects() async => subjects.value =
      ((await (await widget.subjects.filter().gradesIsNotEmpty().findAll())
          .sortSubjects())
        ..removeWhere((g) =>
            g.grades.filter().useable().applyGradeFilter().isEmptySync()));

  @override
  void initState() {
    subjects = ValueNotifier([]);
    setSubjects();
    super.initState();
  }

  @override
  void dispose() {
    subjects.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setSubjects();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 4),
          child: BarChartAverages(
            subjects: widget.subjects,
            rounded: rounded,
            showTrend: showTrend,
          ),
        ),

        // Average Settings
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(top: 0),
          child: FilterChipList(
            chips: [
              _sortingChip(),
              ToggleChip(
                label: const Text("Afgerond"),
                onChanged: (value) => setState(() => rounded = value),
                initalValue: rounded,
              ),
              ToggleChip(
                label: const Text("Maandelijkse trend"),
                icon: const Icon(Icons.trending_up),
                onChanged: (value) => setState(() => showTrend = value),
                initalValue: showTrend,
              )
            ],
          ),
        ),

        // Averages
        // ValueListenableBuilder(
        //     valueListenable: subjects,
        //     builder: (context, value, child) {
        //       return LayoutBuilder(builder: (context, constraints) {
        //         return Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: value.isNotEmpty
        //               ? Wrap(
        //                   children: value
        //                       .map<Widget>((e) => CustomCard(
        //                             child: SubjectAverageTile(
        //                               subject: e,
        //                               big: true,
        //                               rounded: rounded,
        //                               showTrend: showTrend,
        //                             ),
        //                           ))
        //                       .wrapOn(constraints,
        //                           insertOnOdd: const SizedBox()),
        //                 )
        //               : const Padding(
        //                   padding: EdgeInsets.all(16.0),
        //                   child: Center(
        //                     child: Text("Geen gemiddeldes gevonden 🤷"),
        //                   ),
        //                 ),
        //         );
        //       });
        //     })
      ],
    );
  }

  Widget _sortingChip() {
    return DropDownChip<SubjectSortType>(
      defaultIcon: const Icon(Icons.sort),
      currentValue: DropDownChipItem(
        title: appSettings.subjectSortType.toName,
        item: appSettings.subjectSortType,
      ),
      defaultTitle: "Sorteren",
      onSelected: (value) => setState(() {
        appSettings
          ..subjectSortType = value!.item
          ..save();
      }),
      items: () async {
        return [
          for (var sortType in SubjectSortType.values)
            DropDownChipItem(item: sortType, title: sortType.toName)
        ];
      },
    );
  }
}

class SubjectAverageTile extends StatefulWidget {
  const SubjectAverageTile(
      {super.key,
      required this.subject,
      this.big = false,
      this.rounded = false,
      this.showTrend = false});

  final Subject subject;
  final bool big;
  final bool rounded;
  final bool showTrend;

  @override
  State<SubjectAverageTile> createState() => _SubjectAverageTileState();
}

class _SubjectAverageTileState extends State<SubjectAverageTile> {
  TextStyle? get textStyle => widget.big
      ? Theme.of(context).listTileTheme.titleTextStyle ??
          Theme.of(context).textTheme.bodyLarge
      : Theme.of(context).textTheme.titleSmall;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => SubjectGradesScreen(subject: widget.subject).push(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: widget.big ? 1 : 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (widget.big ? widget.subject.naam : widget.subject.afkorting)
                    .capitalized,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
          ),
          FutureBuilder(
            future: Future(() async => await widget.subject.grades
                .filter()
                .applyGradeFilter()
                .changeInAverageLastMonth()),
            builder: (context, snapshot) => CustomCard(
              margin: EdgeInsets.zero,
              elevation: 9,
              surfaceTintColor: (snapshot.data?.change.isNegative ?? false)
                  ? Theme.of(context).colorScheme.error
                  : null,
              child: Row(
                children: [
                  CustomAnimatedSize(
                    child: ConstrainedBox(
                      // When the change tile should be shown the width
                      // should be more than 0
                      constraints:
                          ((widget.big && (snapshot.data?.change ?? 0) >= 0.1 ||
                                      (snapshot.data?.change ?? 0) <= -0.1) &&
                                  widget.showTrend)
                              ? const BoxConstraints(
                                  minWidth: 78, // 64 + 8 * 2
                                )
                              : const BoxConstraints(maxWidth: 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                (snapshot.data?.change ?? 0).isNegative
                                    ? Icons.trending_down
                                    : Icons.trending_up,
                                color: (snapshot.data?.change ?? 0).isNegative
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                size: 22,
                              ),
                            ),
                            Text(
                              snapshot.data?.change
                                      .displayNumber(decimalDigits: 1) ??
                                  "",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: textStyle?.copyWith(
                                color:
                                    (snapshot.data?.change.isNegative ?? false)
                                        ? Theme.of(context).colorScheme.error
                                        : null,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: Future(() async => (await widget.subject.grades
                            .filter()
                            .applyGradeFilter()
                            .findAll())
                        .average),
                    builder: (context, snapshot) {
                      return CustomCard(
                        color: snapshot.hasData &&
                                snapshot.data! < appSettings.sufficientFrom
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomAnimatedSize(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: widget.rounded ? 24 : 40,
                              ),
                              child: ElasticAnimation(
                                alignment: Alignment.center,
                                child: Text(
                                  key: ValueKey(snapshot.data ?? ""),
                                  snapshot.data?.displayNumber(
                                        decimalDigits: widget.rounded ? 0 : 2,
                                      ) ??
                                      "-",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: textStyle?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: snapshot.hasData &&
                                              snapshot.data! <
                                                  appSettings.sufficientFrom
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onErrorContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
