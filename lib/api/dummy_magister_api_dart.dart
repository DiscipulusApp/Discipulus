import 'package:dio/dio.dart';
import 'package:discipulus/api/dummy_routes/interceptors.dart';
import 'package:discipulus/api/dummy_routes/messages.dart';
import 'package:discipulus/api/dummy_routes/persons.dart';
import 'package:discipulus/api/magister_api_dart.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/api/routes/messages.dart';
import 'package:discipulus/api/routes/persons.dart';
import 'package:discipulus/models/account.dart';

class DummyMagister implements Magister {
  @override
  Uri apiEndpoint = Uri.base;

  @override
  Future<void> Function(TokenSet tokenSet)? onTokenRefresh;

  @override
  Future<TokenSet> Function() tokenSet = () => Future.value(TokenSet());

  @override
  int? uuid;

  @override
  Future<ApiAccount> get account => Future.value(
        ApiAccount(
          uuid: "ThisIsADummyAccount",
          groep: [
            Groep(
              naam: "Dummy",
              privileges: [
                ...[
                  // There are more permissions, but these are just some
                  // permissions that I know that exist and will be enough to
                  // copy and paste for testing. (This is a student account)
                  "Cijfers",
                  "Aanmeldingen",
                  "WachtwoordWijzigen",
                  "ProfielEmail",
                  "DigitaalLesmateriaal",
                  "EloOpdracht",
                  "Studiewijzers",
                  "Projecten",
                  "Bronnen",
                  "Berichten",
                  "Profiel",
                  "ProfielMobiel",
                  "Absenties",
                  "Afspraken",
                  "Aftekenen",
                  "Contactpersonen",
                  "Roosterwijzigingen",
                  "Instellingen",
                  "Activiteiten",
                  "MataHuiswerk",
                  "MataWidgets",
                  "MataBerichtMappen",
                  "MataKinderen",
                  "MataDigitaalLesmateriaal",
                  "MataEloOpdracht",
                  "MataBerichten",
                  "MataContactpersonen",
                  "MataStudiewijzer",
                  "MataProjecten",
                  "MataRoosterwijzigingen",
                  "MataAftekenen",
                  "Oauth",
                  "LeerlingAutorisatie",
                  "Logboeken",
                  "Lesperioden",
                  "Portfolio",
                  "Persoonsgegevens",
                  "LOOfficielePersoonsgegevens",
                  "Examenresultaten",
                  "Terugkommaatregelen",
                  "Leerlingen",
                  "Vakken",
                  "Mededelingen",
                  "Keuzelijsten",
                  "Administratieve eenheid",
                  "Contactsoorten",
                  "Overeenkomsten",
                  "Toestemmingen",
                  "BerichtenNotificatie",
                  "Geboortegegevens",
                  "privemail",
                  "LeerlingFoto"
                ].map(
                  (e) => Permission.fromMap({
                    "Naam": e,
                    "AccessType": ["Read"]
                  }),
                )
              ],
            ),
          ],
          persoon: ApiPersoon(
            id: 0,
            roepnaam: "Harry",
            achternaam: "Kat",
            officieleVoornamen: "Harry",
            voorletters: "H.",
            officieleAchternaam: "Kat",
            geboortedatum: DateTime(2000),
            gebruikGeboortenaam: true,
            geboorteAchternaam: "de Kat",
            geboortenaamTussenvoegsel: "de",
            officieleTussenvoegsels: "de",
            tussenvoegsel: "de",
          ),
        ),
      );

  @override
  Dio get dio => Dio()
    ..interceptors.addAll([
      DummyInterceptors(),
    ]);

  @override
  MessagesRoute get messages => DummyMessagesRoute();

  @override
  PersonRoute person(int personId) {
    return DummyPersonRoute(this);
  }
}

abstract class DummyMagisterBase {
  final DummyMagister magister;

  DummyMagisterBase(this.magister);
}
