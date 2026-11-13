# Ontwikkelaarsgids

## Overzicht

Dit document is de praktische gids voor bijdragen aan Discipulus. Het project is een Flutter-app met platformcode en lokale Isar-persistentie. Bij bijdragen is het belangrijk om de app te behandelen als een cross-platform product en niet als een eenvoudige single-screen Flutter-app.

## Aan de slag

### Vereisten

Gebruik de tooling die nodig is voor het platform waarop je wilt testen of bouwen:

- Flutter SDK, compatibel met de vereisten in [../pubspec.yaml](../pubspec.yaml)
- Android SDK en Android Studio voor Android / Wear OS
- Xcode voor iOS/macOS/watchOS
- Linux build dependencies voor desktop builds
- Windows build toolchain voor desktop builds

### Dependencies installeren

```bash
cd Discipulus
flutter pub get
```

### App draaien

```bash
flutter run
```

Of op een specifiek platform:

```bash
flutter run -d android
flutter run -d ios
flutter run -d macos
flutter run -d linux
flutter run -d windows
```

## Build-opdrachten

Het project ondersteunt meerdere targets. Veelgebruikte build-opdrachten zijn:

```bash
flutter build apk
flutter build ios
flutter build macos
flutter build linux
flutter build windows
```

Windows-installerconfiguratie is ook aanwezig in de package-settings, en het project bevat een MSIX-config in [../pubspec.yaml](../pubspec.yaml).

## Werkflow voor lokale ontwikkeling

### Werken met data en persistentie

De meeste gebruikersdata wordt opgeslagen in Isar. Als je een persistent model wijzigt, controleer dan de gegenereerde schema-bestanden en pas veldstructuren zorgvuldig aan, omdat deze gegenereerd zijn en belangrijk zijn voor runtime-correctheid.

De belangrijkste entrypoints voor persistentie zijn:

- [../lib/core/isar.dart](../lib/core/isar.dart)
- [../lib/models/account.dart](../lib/models/account.dart)
- [../lib/models/settings.dart](../lib/models/settings.dart)

### Werken aan Magister-integratie

De kern van de HTTP-integratie zit in:

- [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart)
- [../lib/api/authentication.dart](../lib/api/authentication.dart)
- [../lib/api/routes](../lib/api/routes)

Bij wijzigingen in het Magistergedrag controleer je altijd:

- token refresh en verlopen sessies
- handling van ontbrekende of rate-limited API-responses

### Werken aan schermmodules

UI-modules zijn bewust opgesplitst per domein onder [../lib/screens](../lib/screens). Bij een nieuw scherm of feature houdt het goed bij het permissiemodel en de destination registry in [../lib/core/routes.dart](../lib/core/routes.dart).

## Richtlijnen voor bijdragers uit de repo

De hoofd-README geeft ook een paar verwachtingen mee:

- probeer problemen eerst zelf op te lossen voordat je een PR indient
- houd de stijl in lijn met Material 3
- respecteer de bestaande projectstructuur en conventies
- gebruik Flutter lints en vermijd ad-hoc patronen

Het project is bewust georganiseerd om bestaande architectuurpatronen te behouden; grote rewrites zijn minder aantrekkelijk dan kleine, gerichte wijzigingen binnen de bestaande structuur.

## Testen en verifiëren

Gebruik de testopzet van het project:

```bash
flutter test
```

Golden screenshot-tests staan ook in [../test/screenshot_test.dart](../test/screenshot_test.dart). Die zijn handig voor UI-validatie op iPhone, iPad en Pixel-emulators.

## Platformspecifieke ontwikkelopmerkingen

- Android en Wear OS vereisen de Android toolchain en manifest-updates.
- iOS/macOS vereisen Apple signing en app-group entitlements.
- Linux heeft GTK en desktop packaging support nodig.
- macOS en iOS hebben Handoff, widgets en app-groupvereisten.

Ga niet uit van hetzelfde gedrag op elk platform; native setup is een echt onderdeel van het project.

## Risico’s en beperkingen

- Native integraties verhogen de setuplast voor medewerkers die maar op één platform werken.
- Sommige features zijn afhankelijk van externe services en platformspecifieke permissions.
- Buildgedrag kan variëren per lokale omgeving en SDK-versie.

## Referenties

- [../README.md](../README.md)
- [../pubspec.yaml](../pubspec.yaml)
- [../lib/main.dart](../lib/main.dart)
- [../lib/core/routes.dart](../lib/core/routes.dart)
- [../lib/core/isar.dart](../lib/core/isar.dart)
- [../test/screenshot_test.dart](../test/screenshot_test.dart)
