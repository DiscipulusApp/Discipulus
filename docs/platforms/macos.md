# macOS

## Overzicht

Het macOS-target is geconfigureerd als desktop app met dezelfde kern Flutter runtime en native Apple integration points als iOS. Het bevat custom URL registration, Handoff support, shared widgets en app-group data integration.

## Belangrijkste technologieën en dependencies

- Flutter desktop app shell
- `home_widget`
- `flutter_apple_handoff`
- `flutter_local_notifications`
- app-group based shared state

## Hoofdmapstructuur en verantwoordelijkheden

- [../../macos](../../macos) — macOS app configuratie en entitlements
- [../../darwin/NavigatorWidget](../../darwin/NavigatorWidget) — Apple widget implementatie gebruikt door macOS en iOS
- [../../lib/core/handoff.dart](../../lib/core/handoff.dart) — route restoration logic

## Platformgedrag

Het macOS Info.plist bevat:

- custom URL schemes voor `m6loapp` en `discipulus`
- `NSUserActivityTypes` metadata voor root-page, sub-page en bottom-sheet activiteiten
- app bundle identifiers voor app group sharing

Dit past bij de focus van de app op platformbewuste continuity en widgetinteracties.

## Build en run

```bash
flutter run -d macos
```

Of bouw een package:

```bash
flutter build macos
```

## Risico’s en beperkingen

- macOS builds hangen af van Apple-specifieke signing en app-group entitlements.
- Het widget- en continuitygedrag is sterk gekoppeld aan native Apple APIs en hun compatibiliteit met de huidige OS-versie.
- Desktop builds zijn niet zomaar “op elke machine draaien”; ze vereisen de juiste platform toolchain en certificaten.

## Referenties

- [../../macos/Runner/Info.plist](../../macos/Runner/Info.plist)
- [../../darwin/NavigatorWidget](../../darwin/NavigatorWidget)
- [../../lib/main.dart](../../lib/main.dart)
- [../../lib/core/handoff.dart](../../lib/core/handoff.dart)
