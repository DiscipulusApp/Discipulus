import 'dart:io';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Exports all grades for the active profile to a CSV file and opens the share sheet.
Future<void> exportGradesToCSV() async {
  // Fetch all grades for the active profile across all schoolyears
  final grades = await isar.grades
      .filter()
      .schoolyear((q) => q.profile((q) => q.uuidEqualTo(activeProfile.uuid)))
      .useable()
      .sortByDatumIngevoerdDesc()
      .findAll();

  if (grades.isEmpty) return;

  // CSV Headers
  final StringBuffer csvBuffer = StringBuffer();
  csvBuffer.writeln("Datum;Vak;Cijfer;Weging;Omschrijving;Docent;Periode;Jaar");

  final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  for (final grade in grades) {
    final datum = grade.datumIngevoerd != null
        ? dateFormat.format(grade.datumIngevoerd!.toLocal())
        : "";
    final vak = grade.subject.value?.naam ?? "";
    final cijfer = grade.cijferStr ?? "";
    final weging = grade.weight?.toString() ?? "";
    final omschrijving = (grade.description ?? "").replaceAll(';', ',');
    final docent = grade.docent ?? "";
    final periode = grade.period.value?.naam ?? "";
    final jaar = grade.schoolyear.value?.groep.code ?? "";

    csvBuffer.writeln(
        "$datum;$vak;$cijfer;$weging;$omschrijving;$docent;$periode;$jaar");
  }

  // Save to temporary file
  final directory = await getTemporaryDirectory();
  final file = File(
      '${directory.path}/cijfers_export_${DateTime.now().millisecondsSinceEpoch}.csv');
  await file.writeAsString(csvBuffer.toString());

  // Share file
  await Share.shareXFiles([XFile(file.path)]);
}
