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
        Groep group =
            Groep(id: index, code: "KL$index", omschrijving: "Klas $index");
        return Schoolyear(
          studie: group,
          groep: group,
          lesperiode: Lesperiode(code: "EXT"),
          profielen: [group],
          begin: DateTime.now().subtract(Duration(days: 365 * (index + 1))),
          einde: DateTime.now().subtract(Duration(days: 365 * index)),
          id: index,
          indicatie: group.code,
          isHoofdAanmelding: true,
          isZittenBlijver: false,
          opleidingCode: OpleidingCode(code: 12, omschrijving: "Geen idee"),
          persoonlijkeMentor: PersoonlijkeMentor(
            voorletters: "J.",
            achternaam: "de Kat",
          ),
        );
      },
    ));
  }
}
