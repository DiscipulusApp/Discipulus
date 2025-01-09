import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

/// Displays a card that warns the user that not all the weights have been fetched.
/// When no grades need fetching this will draw an empty [SizedBox]
class NoWeightsWarning extends StatefulWidget {
  const NoWeightsWarning({
    super.key,
    required this.schoolyear,
    this.subject,
    this.onDone,
  });

  /// The schoolyear with incomplete weights
  final Schoolyear schoolyear;

  /// The subject with incomplete weights. When this is null all the grades
  /// of a schoolyear will be able to get fetched.
  final Subject? subject;

  /// This function will be called when the user has fetched the weights
  final Function()? onDone;

  @override
  State<NoWeightsWarning> createState() => _NoWeightsWarningState();
}

class _NoWeightsWarningState extends State<NoWeightsWarning> {
  late final ValueNotifier<int> gottenGrades;
  int alreadyFetched = 0;
  int totalGrades = 0;

  Future<void> setGrades() async {
    // Set the amount of grades that needs to be fetched.

    List<int> amounts = await Future.wait([
      (widget.subject?.grades ?? widget.schoolyear.grades)
          .filter()
          .useable()
          .weightIsNull()
          .count(),
      (widget.subject?.grades ?? widget.schoolyear.grades)
          .filter()
          .useable()
          .count()
    ]);
    gottenGrades.value = 0;
    alreadyFetched = amounts.last - amounts.first;
    totalGrades = amounts.last;
  }

  Future<void> fetchWeights() async {
    //TODO: Isolate?
    await progressWait(
      [
        for (Grade grade
            in await (widget.subject?.grades ?? widget.schoolyear.grades)
                .filter()
                .useable()
                .weightIsNull()
                .findAll())
          grade.fill(),
      ],
      progress: (completed, total) {
        // Update the amount of fetched grades
        gottenGrades.value = completed;
      },
    );
    await setGrades();
    widget.onDone?.call();
  }

  @override
  void dispose() {
    gottenGrades.dispose();
    super.dispose();
  }

  @override
  void initState() {
    gottenGrades = ValueNotifier(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setGrades(),
        builder: (context, snapshot) {
          return ValueListenableBuilder(
            valueListenable: gottenGrades,
            builder: (context, gottonGrades, child) {
              return CustomAnimatedSize(
                child: alreadyFetched == totalGrades
                    ? const SizedBox()
                    : Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        surfaceTintColor: Theme.of(context).colorScheme.error,
                        child: ListTile(
                          isThreeLine: false,
                          leading: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.warning),
                          ),
                          title: const Text("Niet alle wegingen opgehaald!"),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                  "Niet alle wegingen zijn opgehaald, waardoor sommige informatie niet correct is."),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton.icon(
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.onError,
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                    onPressed: fetchWeights,
                                    icon: gottonGrades + alreadyFetched != 0 &&
                                            gottonGrades + alreadyFetched !=
                                                totalGrades
                                        ? SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                                strokeCap: StrokeCap.round,
                                                value: (gottonGrades +
                                                        alreadyFetched) /
                                                    totalGrades,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .errorContainer,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onErrorContainer
                                                // color: Theme.of(context).colorScheme.onError,
                                                ),
                                          )
                                        : null,
                                    label: Text(
                                      gottonGrades != 0 &&
                                              gottonGrades + alreadyFetched !=
                                                  totalGrades
                                          ? "${gottonGrades + alreadyFetched}/$totalGrades"
                                          : "Ophalen",
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
              );
            },
          );
        });
  }
}
