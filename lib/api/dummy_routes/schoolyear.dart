import 'package:discipulus/api/dummy_magister_api_dart.dart';
import 'package:discipulus/api/routes/schoolyear.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/models/schoolyears.dart';

class DummySchoolyearsRoute extends DummyMagisterBase
    implements SchoolyearsRoute {
  DummySchoolyearsRoute(super.magister);

  @override
  int? get id => 0;

  @override
  int? get personId => 0;

  @override
  Future<List<Schoolyear>> schoolyears({DateTimeRange? range}) {
    return Future.value(List.generate(
      5,
      (index) {
        Groep group = index == 0
            ? Groep(id: 0, code: "5VWO", omschrijving: "5 VWO")
            : Groep(id: index, code: "KL$index", omschrijving: "Klas $index");
        return Schoolyear(
          studie: group,
          groep: group,
          lesperiode: Lesperiode(code: "EXT"),
          profielen: [group],
          begin: index == 0
              ? DateTime.now().subtract(const Duration(days: 60))
              : DateTime.now().subtract(Duration(days: 60 + 365 * index)),
          einde: index == 0
              ? DateTime.now().add(const Duration(days: 300))
              : DateTime.now().subtract(Duration(days: 60 + 365 * (index - 1))),
          id: index,
          indicatie: group.code,
          isHoofdAanmelding: true,
          isZittenBlijver: false,
          opleidingCode: OpleidingCode(
              code: 12, omschrijving: index == 0 ? "VWO Bovenbouw" : "VWO Onderbouw"),
          persoonlijkeMentor: PersoonlijkeMentor(
            voorletters: "M.",
            achternaam: "Eijkelkamp",
          ),
        );
      },
    ));
  }
}
