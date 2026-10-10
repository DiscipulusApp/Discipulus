
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
  final subjectConfigs = [
    (
      id: 1,
      naam: "Natuurkunde",
      afk: "NA",
      docent: "M. Eijkelkamp",
      docentCode: "Ekl",
      tests: [
        ("PW Elektriciteit & Magnetisme", 8.4, 2, true),
        ("Practicum Valversnelling & Energie", 7.8, 1, false),
        ("Toets Newtoniaanse Mechanica", 8.8, 2, true),
        ("SO Kwantumwereld", 9.1, 1, false),
      ]
    ),
    (
      id: 2,
      naam: "Wiskunde B",
      afk: "WISB",
      docent: "R. Descartes",
      docentCode: "des",
      tests: [
        ("PW Goniometrie & Periodieke Functies", 7.6, 3, true),
        ("Toets Differentiaalrekening", 8.2, 2, true),
        ("SO Vectoren & Ruimtemeetkunde", 8.7, 1, false),
        ("PW Integreren & Primitiveren", 7.4, 3, true),
      ]
    ),
    (
      id: 3,
      naam: "Geschiedenis",
      afk: "GS",
      docent: "M. van Rossem",
      docentCode: "ros",
      tests: [
        ("PW Koude Oorlog & Dekolonisatie", 7.2, 2, true),
        ("Essay Totalitaire Systemen", 6.8, 2, true),
        ("Toets Verlichting & Revoluties", 7.5, 1, false),
      ]
    ),
    (
      id: 4,
      naam: "Nederlands",
      afk: "NED",
      docent: "P.C. Hooft",
      docentCode: "pch",
      tests: [
        ("Betoog Argumentatieve Vaardigheden", 8.0, 2, true),
        ("Literatuurgeschiedenis & Poëzie", 7.5, 1, false),
        ("Toets Tekstbegrip & Formuleren", 8.5, 2, true),
      ]
    ),
    (
      id: 5,
      naam: "Engels",
      afk: "ENTL",
      docent: "L. van Gaal",
      docentCode: "cls",
      tests: [
        ("Cambridge Advanced Essay", 8.8, 2, true),
        ("Listening Comprehension C1", 9.2, 1, false),
        ("Literature & Shakespeare", 8.5, 2, true),
      ]
    ),
    (
      id: 6,
      naam: "Scheikunde",
      afk: "SK",
      docent: "W.H. White",
      docentCode: "sam",
      tests: [
        ("PW Organische Chemie & Polymeren", 7.5, 3, true),
        ("Practicum Zuren, Basen & pH", 8.0, 1, false),
        ("Toets Redoxreacties & Elektrochemie", 7.1, 2, true),
      ]
    ),
    (
      id: 7,
      naam: "Biologie",
      afk: "BIO",
      docent: "F. Vonk",
      docentCode: "vnk",
      tests: [
        ("PW Genetica, DNA & Eiwitsynthese", 8.5, 3, true),
        ("Practicum Veldwerk & Ecologie", 9.0, 1, false),
        ("Toets Evolutieleer & Soortvorming", 8.2, 2, true),
      ]
    ),
  ];

  List<Map<String, dynamic>> items = [];
  int gradeId = 0;

  for (final sc in subjectConfigs) {
    for (int tIdx = 0; tIdx < sc.tests.length; tIdx++) {
      final test = sc.tests[tIdx];
      DateTime date = DateTime.now().subtract(Duration(days: (gradeId * 4) + 3));
      double gradeVal = test.$2;
      bool isSufficient = gradeVal >= 5.5;

      items.add({
        "CijferId": gradeId,
        "CijferStr": gradeVal.toStringAsFixed(1),
        "IsVoldoende": isSufficient,
        "IngevoerdDoor": sc.docent,
        "DatumIngevoerd": date.toIso8601String(),
        "Weging": test.$3,
        "CijferPeriode": {
          "Id": 101,
          "Naam": "Periode 1",
          "VolgNummer": 1,
          "Start": DateTime(DateTime.now().year, 9, 1).toIso8601String(),
          "Einde": DateTime(DateTime.now().year, 11, 30).toIso8601String()
        },
        "Vak": {
          "Id": sc.id,
          "Naam": sc.naam,
          "Afkorting": sc.afk,
          "Omschrijving": sc.naam,
          "Volgnr": sc.id
        },
        "Inhalen": false,
        "Vrijstelling": false,
        "TeltMee": true,
        "CijferKolom": {
          "Id": gradeId * 10 + 1,
          "KolomNaam": "Kolom ${gradeId + 1}",
          "KolomNummer": (gradeId + 100).toString(),
          "KolomVolgNummer": "${gradeId + 1}",
          "KolomKop": test.$4 ? "PTA" : "PO",
          "KolomOmschrijving": test.$1,
          "KolomSoort": 1,
          "Weging": test.$3,
          "IsHerkansingKolom": false,
          "IsDocentKolom": false,
          "HeeftOnderliggendeKolommen": false,
          "IsPTAKolom": test.$4
        },
        "CijferKolomIdEloOpdracht": gradeId,
        "Docent": sc.docent,
        "VakOntheffing": false,
        "VakVrijstelling": false
      });
      gradeId++;
    }
  }

  return items;
}
