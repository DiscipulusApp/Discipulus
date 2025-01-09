import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/gemini/chat_screen.dart';
import 'package:discipulus/screens/gemini/instructions.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/chips/chip_filter.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/screens/grades/widgets/graphs/line_chart.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grades_subject.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/tiles.dart';
import 'package:discipulus/screens/grades/widgets/grade_calc_card.dart';

void showGradeDetailSheet(
  BuildContext context,
  GradeInformation gradeInformation, {
  bool modelSheet = true,
}) =>
    showScrollableModalBottomSheet(
      context: context,
      modelSheet: modelSheet,
      builder: (p0, p1, scrollcontroller) {
        return ListView(
          controller: scrollcontroller,
          children: [gradeInformation],
        );
      },
    );

class GradeInformation extends StatefulWidget {
  const GradeInformation({super.key, required this.grade, this.setStateTop});

  final Grade grade;
  final void Function(void Function())? setStateTop;

  @override
  State<GradeInformation> createState() => _GradeInformationState();
}

class _GradeInformationState extends State<GradeInformation> {
  late final ValueNotifier<HighlightGrade?> highlightGrade;
  GradeChange? changeInAverage;
  bool onlyUseSubjectGradesInCalc = true;
  bool includeFuture = true;
  QueryBuilder<Grade, Grade, QAfterFilterCondition> get includedFutureGrades =>
      (onlyUseSubjectGradesInCalc
              ? widget.grade.subject.value!.grades
              : widget.grade.schoolyear.value!.grades)
          .filter()
          .applyGradeFilter(forceAddFilters: [
        PeriodFilter(widget.grade.period.value!.uuid,
            schoolyearUuid: widget.grade.schoolyear.value!.uuid)
      ]);
  QueryBuilder<Grade, Grade, QAfterFilterCondition> get grades =>
      includedFutureGrades.optional(
          !includeFuture && widget.grade.datumIngevoerd != null,
          (q) => q.removeFuture(widget.grade.datumIngevoerd!));

  Future<void> setChangeInAverge() async => await includedFutureGrades
      .changeInAverage(grade: widget.grade, includeFuture: false)
      .then((value) => setState(() => changeInAverage = value));

  // Contains statistics about the grade
  GradeStatistics? gradeStatistics;

  @override
  void initState() {
    highlightGrade = ValueNotifier(HighlightGrade(id: widget.grade.id));
    super.initState();
    setChangeInAverge();

    // If the grade is a numerical grade, we can calculate the statistics
    if (widget.grade.grade > 0) {
      Future.microtask(
              () async => gradeStatistics = await widget.grade.gradeStatistics)
          .then((value) => setState(() {}));
    }
  }

  @override
  void dispose() {
    highlightGrade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      AbsorbPointer(child: GradeTile(grade: widget.grade)),
      ...[
        Row(
          children: [
            ListTile(
              title: const Text("Datum"),
              subtitle: Text(
                widget.grade.datumIngevoerd!.toLocal().formattedDate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: const Icon(Icons.calendar_today_outlined),
            ),
            ListTile(
              title: const Text("Tijd"),
              subtitle: Text(
                widget.grade.datumIngevoerd!.toLocal().formattedTime,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: const Icon(Icons.access_time),
            ),
          ]
              .map((e) => Expanded(child: CustomCard(elevation: 0, child: e)))
              .toList(),
        ),
        CustomCard(
            elevation: 0,
            child: Column(
              children: [
                if (widget.grade.weight != null)
                  ListTile(
                    title: const Text("Weging"),
                    subtitle: Text(widget.grade.weight!.displayNumber()),
                    leading: const Icon(Icons.balance),
                  ),
                ListTile(
                  title: const Text("Periode"),
                  subtitle: Text(
                      "${widget.grade.period.value?.naam} (${widget.grade.period.value?.schoolyear.value?.groep.code})"),
                  leading: const Icon(Icons.calendar_month),
                ),
                if (widget.grade.docent != null)
                  ListTile(
                    title: const Text("Docent"),
                    subtitle: Text(widget.grade.docent!),
                    leading: const Icon(Icons.supervisor_account),
                  ),
              ],
            )),
        const ListTile(
          leading: Icon(Icons.analytics_outlined),
          title: Text("Verandering van gemiddelde"),
        ),
        ...statisticsWidgets(),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                elevation: 0,
                child: changeInAverage != null
                    ? ChangeInAverageCard(changeInAverage: changeInAverage!)
                    : const Center(child: Icon(Icons.error)),
              ),
            ),
            CustomCard(
              elevation: 0,
              child: VerticalAverageTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectGradesScreen(
                          subject: widget.grade.subject.value!),
                    )),
                value:
                    includedFutureGrades.findAllSync().average.displayNumber(),
                name: onlyUseSubjectGradesInCalc
                    ? "Nu"
                    : widget.grade.schoolyear.value!.groep.code,
              ),
            )
          ],
        ),
        CustomCard(
          elevation: 0,
          child: ValueListenableBuilder(
            valueListenable: highlightGrade,
            builder: (context, value, child) {
              return GradesLineChart(
                  showAverage: true,
                  grades: includedFutureGrades,
                  highlightGrade: value);
            },
          ),
        ),
        FutureBuilder(
          future: widget.grade.schoolyear.value!.periods.periodChips(
            showFilterButton: true,
            forceEnabledUUID: widget.grade.period.value!.uuid,
            onChanged: () async {
              if (widget.setStateTop != null) widget.setStateTop!(() {});
              await setChangeInAverge();
            },
          ),
          builder: (context, snapshot) => CustomCard(
            elevation: 0,
            child: FilterChipList(
                padding: const EdgeInsets.all(12), chips: snapshot.data ?? []),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.calculate_outlined),
          title: Text("Wat als?"),
        ),
        FutureBuilder(
            future: grades.newGradeFromAverage(
                appSettings.sufficientFrom, widget.grade.weight ?? 1,
                grades: [DummyGrade(grade: appSettings.sufficientFrom)],
                ignoredGradeUUID: widget.grade.uuid),
            builder: (context, snapshot) => (snapshot.data != null &&
                    snapshot.data! > widget.grade.grade &&
                    grades.findAllSync().average < appSettings.sufficientFrom)
                ? CustomCard(
                    elevation: 0,
                    child: ListTile(
                        leading: const Icon(Icons.auto_awesome_outlined),
                        title: const Text(
                            "Benodigd herkansingscijfer voor voldoende"),
                        subtitle: Text(snapshot.data!.displayNumber())))
                : const SizedBox()),
        CustomCard(
            elevation: 0,
            child: GradeCalculationCard(
                toNewAverage: true,
                ignoredGradeUUID: widget.grade.uuid,
                weight: widget.grade.weight,
                grades: grades,
                onResult: (grade, average, weight) => WidgetsBinding.instance
                    .addPostFrameCallback((_) => highlightGrade.value =
                        HighlightGrade(
                            id: widget.grade.id,
                            customGrade: grade,
                            customWeight: weight)))),
        CustomCard(
            elevation: 0,
            child: GradeCalculationCard(
                ignoredGradeUUID: widget.grade.uuid,
                weight: widget.grade.weight,
                grades: grades,
                onResult: (grade, average, weight) => WidgetsBinding.instance
                    .addPostFrameCallback((_) => highlightGrade.value =
                        HighlightGrade(
                            id: widget.grade.id,
                            customGrade: grade,
                            customWeight: weight)))),
        const ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text("Instellingen"),
        ),
        CustomCard(
            elevation: 0,
            child: Column(
              children: [
                SwitchListTile(
                    secondary: const Icon(Icons.manage_history_rounded),
                    title: const Text("Reken met cijfers na dit cijfer"),
                    subtitle: Text(
                        "Neem de cijfers die na ${widget.grade.datumIngevoerd?.formattedDate} zijn gehaald mee in de berekeningen"),
                    value: includeFuture,
                    onChanged: (value) => setState(() {
                          includeFuture = value;
                          setChangeInAverge();
                        })),
                SwitchListTile(
                    secondary: const Icon(Icons.book_outlined),
                    title: const Text("Reken met vak specifieke cijfers"),
                    subtitle: Text(
                        "Kijk alleen naar cijfers voor ${widget.grade.subject.value!.naam}"),
                    value: onlyUseSubjectGradesInCalc,
                    onChanged: (value) => setState(() {
                          onlyUseSubjectGradesInCalc = value;
                          setChangeInAverge();
                        })),
                if (widget.setStateTop != null)
                  SwitchListTile(
                      secondary: const Icon(Icons.numbers_rounded),
                      title: const Text("Gebruik dit cijfer"),
                      subtitle:
                          const Text("Zet dit specifieke cijfer uit of aan"),
                      value: widget.grade.isEnabled,
                      onChanged: (value) => setState(() {
                            if (widget.setStateTop != null) {
                              widget.setStateTop!(() {});
                            }
                            isar.writeTxnSync(() => isar.grades
                                .putSync(widget.grade..isEnabled = value));
                          })),
                if (appSettings.geminiAPIKey != null)
                  ListTile(
                    leading: const Icon(Icons.chat_bubble),
                    title: const Text("AI therapeut"),
                    subtitle: const Text(
                        "Zo geschrokken van je resultaat? Praat me een ai therapeut!"),
                    trailing: IconButton.filledTonal(
                      onPressed: () async => GeminiChatScreen(
                        systemInstruction:
                            await GeminiInstructions.therapistFromGrade(
                                widget.grade),
                      ).push(context),
                      icon: const Icon(Icons.start),
                    ),
                  )
              ],
            )),
      ].map((e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), child: e)),
      const BottomSheetBottomContentPadding()
    ]);
  }

  List<Widget> statisticsWidgets() {
    //
    //  This is currently unused, but perhaps in the future we can show the
    //  grade in question when tapped.
    //
    // void onTap() => showGradeDetailSheet(
    //     context,
    //     GradeInformation(
    //       grade: widget.grade,
    //       setStateTop: (fn) {
    //         if (widget.setStateTop != null) widget.setStateTop!(fn);
    //         setState(fn);
    //       },
    //     ));

    return gradeStatistics != null
        ? [
            // Global
            if (gradeStatistics!.isAlltimeHighest)
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: Text(
                    "Dit is het hoogste cijfer wat je ooit hebt gehaald sinds ${gradeStatistics!.highestSinceGlobal!.formattedDate}!"),
              ),
            if (gradeStatistics!.isAlltimeLowest)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(
                    "Dit is het laagste cijfer wat je ooit hebt gehaald sinds ${gradeStatistics!.lowestSinceGlobal!.formattedDate}"),
              ),

            // Year
            if (gradeStatistics!.isHighestOfYear &&
                !gradeStatistics!.isAlltimeHighest)
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: Text(
                    "Dit is het hoogste cijfer wat je in ${widget.grade.schoolyear.value!.groep.code} hebt gehaald!"),
              ),
            if (gradeStatistics!.isLowestOfYear &&
                !gradeStatistics!.isAlltimeLowest)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(
                    "Dit is het laagste cijfer wat je in ${widget.grade.schoolyear.value!.groep.code} hebt gehaald"),
              ),

            // Subject in global
            if (gradeStatistics!.isHighestOfSubjectGlobal &&
                !gradeStatistics!.isAlltimeHighest &&
                !gradeStatistics!.isHighestOfYear)
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: Text(
                    "Dit is het hoogste cijfer wat je voor ${widget.grade.subject.value!.naam} hebt gehaald sinds ${gradeStatistics!.highestSinceSubjectGlobal!.formattedDate}!"),
              ),
            if (gradeStatistics!.isLowestOfSubjectGlobal &&
                !gradeStatistics!.isAlltimeLowest &&
                !gradeStatistics!.isLowestOfYear)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(
                    "Dit is het laagste cijfer wat je voor ${widget.grade.subject.value!.naam} hebt gehaald sinds ${gradeStatistics!.lowestSinceSubjectGlobal!.formattedDate}"),
              ),

            // Subject in year
            if (gradeStatistics!.isHighestOfSubject &&
                !gradeStatistics!.isAlltimeHighest &&
                !gradeStatistics!.isHighestOfSubjectGlobal &&
                !gradeStatistics!.isHighestOfYear)
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: Text(
                    "Dit is het hoogste cijfer wat je in ${widget.grade.schoolyear.value!.groep.code} voor ${widget.grade.subject.value!.naam} hebt gehaald!"),
              ),
            if (gradeStatistics!.isLowestOfSubject &&
                !gradeStatistics!.isAlltimeLowest &&
                !gradeStatistics!.isLowestOfSubjectGlobal &&
                !gradeStatistics!.isLowestOfYear)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(
                    "Dit is het laagste cijfer wat je in ${widget.grade.schoolyear.value!.groep.code} voor ${widget.grade.subject.value!.naam} hebt gehaald"),
              ),
            if (gradeStatistics?.lowestSinceGlobal != null &&
                gradeStatistics?.lowestSinceGlobal !=
                    widget.grade.datumIngevoerd &&
                !gradeStatistics!.isAlltimeLowest)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(
                    "Dit is het laagste cijfer in ${widget.grade.datumIngevoerd!.difference(gradeStatistics!.lowestSinceGlobal!).inDays} dagen"),
              ),
            if (gradeStatistics?.lowestSinceSubjectGlobal != null &&
                gradeStatistics?.lowestSinceSubjectGlobal !=
                    widget.grade.datumIngevoerd &&
                !gradeStatistics!.isAlltimeLowest &&
                !gradeStatistics!.isHighestOfSubjectGlobal)
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(
                    "Dit is het laagste cijfer voor ${widget.grade.subject.value!.naam} in ${widget.grade.datumIngevoerd!.difference(gradeStatistics!.lowestSinceSubjectGlobal!).toName} dagen"),
              ),
          ]
            .map(
              (e) => CustomCard(
                elevation: 0,
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: e,
              ),
            )
            .toList()
        : [];
  }
}

///Used to show the grades of which an average is made up, this only works with averages from Magister themselves.
class GradesInAverageDetailsView extends StatelessWidget {
  const GradesInAverageDetailsView({super.key, required this.grade});

  ///Make sure that this is an average, so
  final Grade grade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 16),
            child: Text(
              "Bestaat uit:",
              style: Theme.of(context).textTheme.titleLarge,
            )),
        // TODO: gerelateerdekolommen van Magister API
        // Geeft helaas geen id, dus je kan er weer helemaal niets mee.
        ...grade.period.value!.grades
            .filter()
            .subject((q) => q.idEqualTo(grade.subject.value!.id))
            .cijferKolom((q) => q.kolomSoortEqualTo(1))
            // .and()
            // .subject((q) => q.idEqualTo(grade.subject.value!.id))
            .findAllSync()
            .map((e) => GradeTile(grade: e))
      ],
    );
  }
}

class ChangeInAverageCard extends StatelessWidget {
  const ChangeInAverageCard({super.key, required this.changeInAverage});

  final GradeChange changeInAverage;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VerticalAverageTile(
              name: "Voor",
              value: changeInAverage.averageBefore.displayNumber()),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              size: (24 * MediaQuery.of(context).textScaleFactor),
              color: changeInAverage.change == 0
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : (changeInAverage.change < 0 || changeInAverage.change > 10)
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
              changeInAverage.change.isNegative
                  ? Icons.trending_down
                  : changeInAverage.change == 0 || changeInAverage.change.isNaN
                      ? Icons.trending_flat
                      : Icons.trending_up,
            ),
            if (!changeInAverage.change.isNaN)
              ElasticAnimation(
                  child: Text(
                key: ValueKey(changeInAverage.change.displayNumber()),
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.titleMedium?.fontSize ?? 24,
                    fontWeight: FontWeight.bold,
                    color: changeInAverage.change == 0
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : (changeInAverage.change < 0 ||
                                changeInAverage.change > 10)
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary),
                " ${changeInAverage.change.displayNumber(decimalDigits: 2)}",
              ))
          ]),
          VerticalAverageTile(
              name: "Na", value: changeInAverage.avarageAfter.displayNumber()),
        ]);
  }
}
