import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/grades/widgets/grade_header.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:isar/isar.dart';

class SchoolyearSelector extends StatefulWidget {
  const SchoolyearSelector({
    super.key,
    this.allowedUUIDS = const [],
    this.initValue,
    this.onSelected,
    this.gradesInformation,
  });

  /// this list contains all UUIDs that will be displayed. If empty it will use
  /// the enabled schoolyears from the current active profile
  final List<int> allowedUUIDS;

  final SchoolyearObject? initValue;

  /// This will run when the user selects a [Schoolyear]
  final void Function(Schoolyear?)? onSelected;

  /// This can be set when the selector should display some information about
  /// grades. When left empty no extra bottom widget will be displayed.
  final QueryBuilder<Grade, Grade, QAfterFilterCondition> Function(
      QueryBuilder<Grade, Grade, QAfterFilterCondition> q)? gradesInformation;
  @override
  State<SchoolyearSelector> createState() => _SchoolyearSelectorState();
}

class SchoolyearObject {
  final int uuid;
  final Groep group;

  SchoolyearObject(this.uuid, {required this.group});
}

class _SchoolyearSelectorState extends State<SchoolyearSelector> {
  DropDownChipItem<int>? currentValue;

  Future<Schoolyear?> uuidToSchoolyear(int uuid) async =>
      isar.schoolyears.filter().uuidEqualTo(uuid).findFirst();

  Future<Groep> getSchoolyearName(int uuid) async {
    return (await isar.schoolyears
        .filter()
        .uuidEqualTo(uuid)
        .groepProperty()
        .findFirst())!;
  }

  @override
  Widget build(BuildContext context) {
    return DropDownChip<int>(
      defaultTitle: "Schooljaren",
      defaultIcon: const Icon(Icons.school),
      currentValue: currentValue ??
          (widget.initValue?.uuid != null
              ? DropDownChipItem(
                  title: widget.initValue?.group.omschrijving ??
                      widget.initValue!.group.code,
                  shortTitle: widget.initValue!.group.code,
                  item: widget.initValue!.uuid,
                )
              : null),
      items: () async {
        List<SchoolyearObject> schoolyearObjects = await Future.wait(
          [
            for (int uuid in await activeProfile.schoolyears
                .filter()
                .optional(
                  widget.allowedUUIDS.isNotEmpty,
                  (q) => q.anyOf(
                    widget.allowedUUIDS,
                    (q, uuid) => q.uuidEqualTo(uuid),
                  ),
                )
                .isHoofdAanmeldingEqualTo(true)
                .sortByEindeDesc()
                .uuidProperty()
                .findAll())
              Future<SchoolyearObject>(
                () async => SchoolyearObject(
                  uuid,
                  group: (await isar.schoolyears
                      .filter()
                      .uuidEqualTo(uuid)
                      .groepProperty()
                      .findFirst())!,
                ),
              ),
          ],
        );

        List<DropDownChipItem<int>> items = [];

        for (SchoolyearObject item in schoolyearObjects) {
          items.add(
            DropDownChipItem(
              title: item.group.omschrijving ?? item.group.code,
              shortTitle: item.group.code,
              item: item.uuid,
              bottomWiget: widget.gradesInformation != null
                  ? () async {
                      dynamic grades =
                          (await uuidToSchoolyear(item.uuid))?.grades.filter();
                      if (grades != null) {
                        grades = widget.gradesInformation!.call(grades);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: StatisticalTilesHeader(grades: grades),
                        );
                      }
                      return null;
                    }
                  : null,
            ),
          );
        }

        return items;
      },
      onSelected: (value) async {
        setState(() {
          currentValue = value;
        });
        Schoolyear? schoolyear = await uuidToSchoolyear(value!.item);
        if (schoolyear != null) {
          Profile.activeSchoolyearUUID = schoolyear.uuid;
        }
        widget.onSelected!.call(schoolyear);
      },
    );
  }
}
