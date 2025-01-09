import 'dart:math';

import 'package:discipulus/api/dummy_routes/interceptors.dart';

class GradesInterceptor extends DemoInterceptor {
  GradesInterceptor(super.options, super.handler);

  dynamic get gradeInterceptor {
    if (options.path.contains("aanmeldingen")) {
      // Normal grades
      if (options.path.contains("cijfers/cijferoverzichtvooraanmelding")) {
        // Simulate grade data for fillGrades()
        return {
          "Items": _generateDummyGrades(
            20,
            seed: options.queryParameters["peildatum"] != null
                ? DateTime.tryParse(options.queryParameters["peildatum"])
                    ?.millisecondsSinceEpoch
                : null,
          ), // Generate 20 dummy grades for example
          "TotalCount": 20,
          "Links": []
        };
      }
      // Extra grade info
      if (options.path.contains("cijfers/extracijferkolominfo/")) {
        return {
          "KolomSoortKolom": 1,
          "KolomNaam": "Prev300",
          "KolomKopnaam": "lit",
          "KolomNiveau": null,
          "KolomOmschrijving":
              "When everyone sings your praises, consider yourself worthy of none",
          "Weging": 1.0,
          "WerkinformatieDatumIngevoerd": null,
          "WerkInformatieOmschrijving": null
        };
      }
    }
  }
}

List<Map<String, dynamic>> _generateDummyGrades(int count, {int? seed}) {
  Random random = Random(seed ?? "dummy".hashCode);

  return List.generate(count, (index) {
    DateTime date = DateTime.now().subtract(Duration(days: index * 5));
    bool isSufficient =
        (random.nextDouble() > 0.2); // Sufficient in 80% of the time

    return {
      "CijferId": index,
      "CijferStr": ((isSufficient ? 6 : 2) + random.nextDouble() * 3.5)
          .toStringAsFixed(1), // Random grade between 6.0 and 9.5
      "IsVoldoende": isSufficient,
      "IngevoerdDoor": "Teacher $index",
      "DatumIngevoerd": date.toIso8601String(),
      "CijferPeriode": {
        "Id": index * 10,
        "Naam": "Period ${index + 1}",
        "VolgNummer": index + 1,
        "Start": date.subtract(const Duration(days: 14)).toIso8601String(),
        "Einde": date.toIso8601String()
      },
      "Vak": {
        "Id": index ~/ 2,
        "Naam": "Subject ${index ~/ 2}",
        "Afkorting": "SUB${index ~/ 2}",
        "Omschrijving": "Subject ${index ~/ 2}",
        "Volgnr": index ~/ 2
      },
      "Inhalen": index.isEven,
      "Vrijstelling": false,
      "TeltMee": true,
      "CijferKolom": {
        "Id": index * 3,
        "KolomNaam": "Column ${index + 1}",
        "KolomNummer": (index + 100).toString(),
        "KolomVolgNummer": "${index + 1}",
        "KolomKop": "PT",
        "KolomOmschrijving": "Test $index",
        "KolomSoort": 1,
        "Weging": 1,
        "IsHerkansingKolom": false,
        "IsDocentKolom": false,
        "HeeftOnderliggendeKolommen": false,
        "IsPTAKolom": true
      },
      "CijferKolomIdEloOpdracht": index,
      "Docent": "Teacher Name",
      "VakOntheffing": false,
      "VakVrijstelling": false
    };
  });
}
