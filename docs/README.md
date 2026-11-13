# Documentatie van Discipulus

## Overzicht

Discipulus is een Flutter-applicatie voor meerdere platforms die als open-source alternatief voor de Magister-app werkt. In dit repository zit niet alleen de app zelf, maar ook de native platform-ondersteuning voor Android, iOS, macOS, Linux, Windows en watchOS, plus een ingebouwde Model Context Protocol (MCP)-server voor toegang tot Magister-data via AI-tools en lokale tooling.

De kern van de app bestaat uit een lokale Isar-database, een aangepaste Magister-API-client en een verzameling schermmodules voor rooster, cijfers, berichten, huiswerk, studiewijzers, activiteiten en instellingen. De codebase is dus geen demo of starterproject: het bevat echte app-werkstromen voor authenticatie, achtergrondvernieuwing, meldingen, widgets, Handoff, lokale AI-configuratie en desktop-integraties.

## Scope van het project

Dit is geen generiek Flutter-template. Het is een product dat is gericht op Nederlandse middelbare scholieren die Magister gebruiken, met functionaliteit voor:

- rooster en agenda
- cijfers en gemiddelden
- berichten en bijlagen
- opdrachten en leermiddelen
- activiteiten en absenties
- native platform-integraties
- offline lokaal opslag
- MCP-toegang voor externe tools

## Overzicht van de documentatie

- [architecture.md](architecture.md) — architectuur, runtime en dataflow
- [project-structure.md](project-structure.md) — mappenstructuur en verantwoordelijkheden
- [features.md](features.md) — functie-overzicht van de app
- [developer-guide.md](developer-guide.md) — setup, build en bijdrageproces
- [integrations.md](integrations.md) — platformservices en externe integraties
- [mcp-server.md](mcp-server.md) — details van de ingebouwde MCP-server
- [testing.md](testing.md) — tests en screenshot-validatie
- [platforms/README.md](platforms/README.md) — overzicht per platform

## Aan de slag

### Vereisten

Het project is een Flutter-app zoals gedefinieerd in [../pubspec.yaml](../pubspec.yaml) en gebruikt de Flutter SDK-vereisten die daar staan. Voor ontwikkeling of validatie op platforms is daarnaast een platform-omgeving nodig:

- Flutter SDK
- Android Studio / Android SDK voor Android en Wear OS
- Xcode en Apple Developer tools voor iOS, macOS en watchOS
- GTK/build-tooling voor Linux
- Windows desktop toolchain voor Windows

### Installeren en draaien

```bash
git clone <repo-url>
cd Discipulus
flutter pub get
flutter run
```

Voor een specifiek platform:

```bash
flutter run -d android
flutter run -d ios
flutter run -d macos
flutter run -d linux
flutter run -d windows
```

## Belangrijkste entrypoints in de code

- [../lib/main.dart](../lib/main.dart) — app-start, platforminitialisatie, achtergrondservices en hoofdapp
- [../lib/core/routes.dart](../lib/core/routes.dart) — navigatie en domeinmenu’s
- [../lib/models/account.dart](../lib/models/account.dart) — account-, profiel- en opslagmodel
- [../lib/models/settings.dart](../lib/models/settings.dart) — instellingen en AI-configuratie
- [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart) — Magister-client en Dio-interceptorlogica
- [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart) — MCP-server in stdio-modus
- [../lib/core/notifications.dart](../lib/core/notifications.dart) — native meldingen en scheduling

## Belangrijke code-opmerkingen

- De app bewaart de meeste gegevens lokaal in Isar in plaats van in een eigen backend.
- Magister wordt gezien als de bron van waarheid voor rooster, berichten, cijfers en opdrachten.
- Het project bevat native platformcode en widget-integraties, vooral op iOS/macOS en Android.
- De hoofd-README noemt expliciet een bekende beperking: pushmeldingen werken nog niet optimaal door beperkingen in de Magister-API.

## Referenties

- [../README.md](../README.md)
- [../pubspec.yaml](../pubspec.yaml)
- [../lib/main.dart](../lib/main.dart)
- [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart)
