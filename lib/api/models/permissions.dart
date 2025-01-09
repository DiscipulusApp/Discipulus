import 'package:isar/isar.dart';

part 'permissions.g.dart';

@embedded
class Permission {
  @enumerated
  final PermissionType type;
  @enumerated
  final List<PermissionStatus> statuses;

  Permission({this.statuses = const [], this.type = PermissionType.unknown});

  factory Permission.fromMap(Map<String, dynamic> json) => Permission(
        type: permissionTypes.map[json["Naam"]] ?? PermissionType.unknown,
        statuses: List<PermissionStatus>.from(json["AccessType"]
            .map((x) => permissionStatuses.map[x] ?? PermissionStatus.unknown)),
      );
}

/// This contains all **known** permissions, more probably exist
enum PermissionType {
  cijfers,
  aanmeldingen,
  wachtwoordWijzigen,
  profielEmail,
  digitaalLesmateriaal,
  eloOpdracht,
  studiewijzers,
  projecten,
  bronnen,
  berichten,
  profiel,
  profielMobiel,
  absenties,
  afspraken,
  aftekenen,
  contactpersonen,
  roosterwijzigingen,
  kinderen,
  instellingen,
  activiteiten,
  mataHuiswerk,
  mataWidgets,
  mataBerichtMappen,
  mataKinderen,
  mataDigitaalLesmateriaal,
  mataEloOpdracht,
  mataBerichten,
  mataContactpersonen,
  mataStudiewijzer,
  mataProjecten,
  mataRoosterwijzigingen,
  ouderavond,
  mataAftekenen,
  oauth,
  leerlingAutorisatie,
  logboeken,
  lesperioden,
  portfolio,
  persoonsgegevens,
  lOOfficielePersoonsgegevens,
  examenresultaten,
  terugkommaatregelen,
  leerlingen,
  vakken,
  mededelingen,
  keuzelijsten,
  administratieveEenheid,
  contactsoorten,
  absentiemeldingen,
  overeenkomsten,
  toestemmingen,
  berichtenNotificatie,
  geboortegegevens,
  privemail,
  leerlingFoto,
  unknown
}

final permissionTypes = EnumValues({
  "Cijfers": PermissionType.cijfers,
  "Aanmeldingen": PermissionType.aanmeldingen,
  "WachtwoordWijzigen": PermissionType.wachtwoordWijzigen,
  "ProfielEmail": PermissionType.profielEmail,
  "DigitaalLesmateriaal": PermissionType.digitaalLesmateriaal,
  "EloOpdracht": PermissionType.eloOpdracht,
  "Studiewijzers": PermissionType.studiewijzers,
  "Projecten": PermissionType.projecten,
  "Bronnen": PermissionType.bronnen,
  "Berichten": PermissionType.berichten,
  "Profiel": PermissionType.profiel,
  "ProfielMobiel": PermissionType.profielMobiel,
  "Absenties": PermissionType.absenties,
  "Afspraken": PermissionType.afspraken,
  "Aftekenen": PermissionType.aftekenen,
  "Contactpersonen": PermissionType.contactpersonen,
  "Roosterwijzigingen": PermissionType.roosterwijzigingen,
  "Kinderen": PermissionType.kinderen,
  "Instellingen": PermissionType.instellingen,
  "Activiteiten": PermissionType.activiteiten,
  "MataHuiswerk": PermissionType.mataHuiswerk,
  "MataWidgets": PermissionType.mataWidgets,
  "MataBerichtMappen": PermissionType.mataBerichtMappen,
  "MataKinderen": PermissionType.mataKinderen,
  "MataDigitaalLesmateriaal": PermissionType.mataDigitaalLesmateriaal,
  "MataEloOpdracht": PermissionType.mataEloOpdracht,
  "MataBerichten": PermissionType.mataBerichten,
  "MataContactpersonen": PermissionType.mataContactpersonen,
  "MataStudiewijzer": PermissionType.mataStudiewijzer,
  "MataProjecten": PermissionType.mataProjecten,
  "MataRoosterwijzigingen": PermissionType.mataRoosterwijzigingen,
  "Ouderavond": PermissionType.ouderavond,
  "MataAftekenen": PermissionType.mataAftekenen,
  "Oauth": PermissionType.oauth,
  "LeerlingAutorisatie": PermissionType.leerlingAutorisatie,
  "Logboeken": PermissionType.logboeken,
  "Lesperioden": PermissionType.lesperioden,
  "Portfolio": PermissionType.portfolio,
  "Persoonsgegevens": PermissionType.persoonsgegevens,
  "LOOfficielePersoonsgegevens": PermissionType.lOOfficielePersoonsgegevens,
  "Examenresultaten": PermissionType.examenresultaten,
  "Terugkommaatregelen": PermissionType.terugkommaatregelen,
  "Leerlingen": PermissionType.leerlingen,
  "Vakken": PermissionType.vakken,
  "Mededelingen": PermissionType.mededelingen,
  "Keuzelijsten": PermissionType.keuzelijsten,
  "AdministratieveEenheid": PermissionType.administratieveEenheid,
  "Contactsoorten": PermissionType.contactsoorten,
  "Absentiemeldingen": PermissionType.absentiemeldingen,
  "Overeenkomsten": PermissionType.overeenkomsten,
  "Toestemmingen": PermissionType.toestemmingen,
  "BerichtenNotificatie": PermissionType.berichtenNotificatie,
  "Geboortegegevens": PermissionType.geboortegegevens,
  "Privemail": PermissionType.profielEmail,
  "LeerlingFoto": PermissionType.leerlingFoto
});

enum PermissionStatus { read, update, create, delete, unknown }

final permissionStatuses = EnumValues({
  "Create": PermissionStatus.create,
  "Delete": PermissionStatus.delete,
  "Read": PermissionStatus.read,
  "Update": PermissionStatus.update
});

extension PermissionsExt on List<Permission> {
  /// Check if a permission is present
  bool hasPermissions(
    PermissionType type, {
    List<PermissionStatus> statuses = const [PermissionStatus.read],
  }) =>
      where((p) =>
              p.type == type && statuses.every((s) => p.statuses.contains(s)))
          .isNotEmpty;
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
