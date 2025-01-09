import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/filter.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:isar/isar.dart';

extension FilterExtension on IsarLinks<GradePeriod> {
  Future<List<Widget>> periodChips(
          {bool removeAverages = true,
          bool showFilterButton = true,
          void Function()? onChanged,
          int? forceEnabledUUID}) async =>
      [
        if (showFilterButton && firstOrNull?.schoolyear.value != null)
          GradeFilterMenuChip(
            key: const ValueKey("FilterButton"),
            title: const Text("Filter"),
            schoolyear: firstOrNull!.schoolyear.value!,
            onChanged: onChanged,
          ),
        for (var period in (await filter()
            .optional(
                removeAverages,
                (q) => q.grades(
                    (q) => q.cijferKolom((q) => q.kolomSoortEqualTo(1))))
            .sortByNaamDesc()
            .findAll()))
          ToggleChip(
            key: ValueKey(
              period.uuid.hashCode +
                  Settings.activeGradeFilters
                      .map((e) => e.uuid)
                      .contains(period.uuid)
                      .hashCode,
            ),
            label: Text(period.naam),
            initalValue: Settings.activeGradeFilters
                    .map((e) => e.uuid)
                    .contains(period.uuid) ||
                period.uuid == forceEnabledUUID,
            onChanged: period.uuid != forceEnabledUUID
                ? (isEnabled) {
                    if (Settings.activeGradeFilters
                            .map((e) => e.uuid)
                            .contains(period.uuid) &&
                        period.uuid != forceEnabledUUID) {
                      Settings.activeGradeFilters.removeWhere(
                        (f) => f.uuid == period.uuid,
                      );
                    } else {
                      Settings.activeGradeFilters.add(PeriodFilter(
                        period.uuid,
                        schoolyearUuid: period.schoolyear.value!.uuid,
                      ));
                    }
                    onChanged?.call();
                  }
                : null,
          )
      ];
}

class GradeFilterMenuChip extends StatefulWidget {
  const GradeFilterMenuChip(
      {super.key,
      required this.title,
      required this.schoolyear,
      this.onChanged});

  final Widget title;
  final Schoolyear schoolyear;
  final void Function()? onChanged;

  @override
  State<GradeFilterMenuChip> createState() => _FilterMenuChipState();
}

class _FilterMenuChipState extends State<GradeFilterMenuChip> {
  @override
  Widget build(BuildContext context) {
    /// Whether or not the button should be displayed as active
    bool isActive = Settings.activeGradeFilters
        .where((f) => f.schoolyearUuid == widget.schoolyear.uuid)
        .isNotEmpty;
    return ActionChip(
      backgroundColor:
          isActive ? Theme.of(context).colorScheme.secondaryContainer : null,
      side: isActive ? const BorderSide(style: BorderStyle.none) : null,
      avatar: const Icon(Icons.filter_list),
      label: widget.title,
      onPressed: () => showScrollableModalBottomSheet(
        context: context,
        builder: (context, setState, scrollcontroller) => ListView(
          controller: scrollcontroller,
          children: [
            GradesFilterMenu(
              schoolyear: widget.schoolyear,
              onChanged: () {
                setState(() {});
                widget.onChanged?.call();
              },
            )
          ],
        ),
      ),
    );
  }
}

class GradesFilterMenu extends StatelessWidget {
  const GradesFilterMenu({super.key, required this.schoolyear, this.onChanged});

  final Schoolyear schoolyear;
  final void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16)
                .copyWith(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filters",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                FilledButton.tonal(
                  onPressed: Settings.activeGradeFilters
                          .where((f) => f.schoolyearUuid == schoolyear.uuid)
                          .isEmpty
                      ? null
                      : () {
                          Settings.activeGradeFilters.removeWhere(
                              (f) => f.schoolyearUuid == schoolyear.uuid);
                          onChanged?.call();
                        },
                  child: const Text("Alles uitzetten"),
                )
              ],
            ),
          ),
          const ListTitle(child: Text("Periodes")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder(
                future: schoolyear.periods
                    .periodChips(showFilterButton: false, onChanged: onChanged),
                builder: (context, snapshot) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: snapshot.data ?? [],
                  );
                }),
          ),
          const ListTitle(child: Text("Vakken")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: schoolyear.subjects
                  .filter()
                  .sortByNaam()
                  .findAllSync()
                  .map(
                    (e) => ToggleChip(
                      label: Text(e.naam.capitalized),
                      initalValue: Settings.activeGradeFilters
                          .map((e) => e.uuid)
                          .contains(e.uuid),
                      onChanged: (isEnabled) {
                        if (Settings.activeGradeFilters
                            .map((e) => e.uuid)
                            .contains(e.uuid)) {
                          Settings.activeGradeFilters.removeWhere(
                            (f) => f.uuid == e.uuid,
                          );
                        } else {
                          Settings.activeGradeFilters.add(SubjectFilter(e.uuid,
                              schoolyearUuid: schoolyear.uuid));
                        }
                        onChanged?.call();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const ListTitle(child: Text("Docenten")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (var e in schoolyear.grades
                    .filter()
                    .numericalGrades
                    .docentIsNotNull()
                    .docentProperty()
                    .findAllSync()
                    .toSet())
                  ToggleChip(
                    label: Text(e!),
                    initalValue: Settings.activeGradeFilters
                        .map((e) => e.uuid)
                        .contains(e.hashCode),
                    onChanged: (isEnabled) {
                      if (Settings.activeGradeFilters
                          .map((e) => e.uuid)
                          .contains(e.hashCode)) {
                        Settings.activeGradeFilters.removeWhere(
                          (f) => f is TeacherFilter && f.shortName == e,
                        );
                      } else {
                        Settings.activeGradeFilters.add(TeacherFilter(
                            e.hashCode,
                            shortName: e,
                            schoolyearUuid: schoolyear.uuid));
                      }
                      onChanged?.call();
                    },
                  ),
              ],
            ),
          ),
          const ListTitle(child: Text("Cijfers")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (int grade in List.generate(10, (i) => i + 1))
                  ToggleChip(
                    label: Text(grade.toString()),
                    initalValue: Settings.activeGradeFilters
                        .where(
                          (e) =>
                              e.runtimeType == RoundedGradeRangeFilter &&
                              e.uuid == grade,
                        )
                        .isNotEmpty,
                    onChanged: (isEnabled) {
                      if (Settings.activeGradeFilters
                          .where(
                            (e) =>
                                e.runtimeType == RoundedGradeRangeFilter &&
                                e.uuid == grade,
                          )
                          .isEmpty) {
                        // This filter does not yet exist, so we are adding it
                        Settings.activeGradeFilters.add(
                          RoundedGradeRangeFilter(grade,
                              range: grade, schoolyearUuid: schoolyear.uuid),
                        );
                      } else {
                        // The filter does exist, so we need to remove it.
                        Settings.activeGradeFilters.removeWhere((e) =>
                            e.runtimeType == RoundedGradeRangeFilter &&
                            e.uuid == grade);
                      }
                      onChanged?.call();
                    },
                  )
              ],
            ),
          ),
          const ListTitle(child: Text("Data")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ActionChip(
                  label: const Text("Toevoegen"),
                  avatar: const Icon(Icons.add),
                  onPressed: () => showDateRangePicker(
                          currentDate: DateTime.now(),
                          context: context,
                          firstDate: schoolyear.grades
                                  .filter()
                                  .sortByDatumIngevoerd()
                                  .datumIngevoerdProperty()
                                  .findFirstSync() ??
                              schoolyear.begin,
                          lastDate: schoolyear.grades
                                  .filter()
                                  .sortByDatumIngevoerdDesc()
                                  .datumIngevoerdProperty()
                                  .findFirstSync() ??
                              schoolyear.einde)
                      .then((value) {
                    Settings.activeGradeFilters.addAll([
                      if (value != null)
                        GradeDateRangeFilter(
                            value.start.millisecondsSinceEpoch +
                                value.end.millisecondsSinceEpoch,
                            range: value,
                            schoolyearUuid: schoolyear.uuid)
                    ]);
                    onChanged?.call();
                  }),
                ),
                ...Settings.activeGradeFilters
                    .whereType<GradeDateRangeFilter>()
                    .map(
                      (e) => InputChip(
                        label: Text(
                            "${e.range.start.formattedDate} - ${e.range.end.formattedDate}"),
                        onDeleted: () {
                          Settings.activeGradeFilters.removeWhere(
                            (f) =>
                                f is GradeDateRangeFilter && f.uuid == e.uuid,
                          );
                          onChanged?.call();
                        },
                      ),
                    ),
              ],
            ),
          ),
          const BottomSheetBottomContentPadding()
        ],
      ),
    );
  }
}
