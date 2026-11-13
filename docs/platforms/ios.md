# iOS

## Overzicht

iOS is een first-class app target en bevat app-group sharing, widget support, background data refresh, Handoff, live activities en share extensions. De configuratie zit vooral in [../../ios](../../ios), met bijbehorende widget- en app-group logica in [../../darwin](../../darwin).

## Belangrijkste technologieën en dependencies

- Flutter app runtime
- `home_widget` voor native widgets
- `flutter_apple_handoff`
- `flutter_local_notifications`
- `live_activities`
- `watch_connectivity` voor companion apps
- app-group en entitlement-based sharing

## Hoofdmapstructuur en verantwoordelijkheden

- [../../ios/Runner](../../ios/Runner) — main app bundle, AppDelegate en Info.plist
- [../../ios/NavigatorWidget](../../ios/NavigatorWidget) — widget extension files
- [../../ios/Share Extension](../../ios/Share%20Extension) — sharing support
- [../../darwin/NavigatorWidget](../../darwin/NavigatorWidget) — gedeelde Apple widget implementatie

## Platformgedrag

De app registreert meerdere custom URL schemes in [../../ios/Runner/Info.plist](../../ios/Runner/Info.plist):

- `m6loapp`
- `discipulus`
- `ShareMedia-$(PRODUCT_BUNDLE_IDENTIFIER)`

De Info.plist meldt ook support voor live activities, user activity types en background modes zoals fetch en processing. De app group identifier is hetzelfde over Apple targets:

- `group.DUGUWCFH8P.dev.harrydekat.discipulus`

Dit maakt widget-, share- en continuity features mogelijk in het Apple-ecosysteem.

## Handoff en widgets

De app-startup logica zet `FlutterAppleHandoff` aan en registreert Home Widget interactivity voor iOS/macOS. De logica zit in [../../lib/main.dart](../../lib/main.dart) en de echte handoff routing in [../../lib/core/handoff.dart](../../lib/core/handoff.dart).

De widget-implementatie onder [../../darwin/NavigatorWidget](../../darwin/NavigatorWidget) wordt gebruikt om informatie over de volgende les te tonen en snelle navigatie terug naar de app mogelijk te maken.

## Build en run

```bash
flutter run -d ios
```

Voor een release build:

```bash
flutter build ios
```

## Risico’s en beperkingen

- Apple app signing en entitlements zijn vereist.
- Widget-, app-group- en live-activity features vereisen zorgvuldige provisioning en app-group setup.
- Sommige platform-specifieke gedrag is alleen beschikbaar op nieuwere OS-versies.
- Het project bevat een bekende beperking rond notificatiekwaliteit vanwege upstream Magister constraints.

## Referenties

- [../../ios/Runner/Info.plist](../../ios/Runner/Info.plist)
- [../../ios/Runner/AppDelegate.swift](../../ios/Runner/AppDelegate.swift)
- [../../darwin/NavigatorWidget](../../darwin/NavigatorWidget)
- [../../lib/core/handoff.dart](../../lib/core/handoff.dart)
- [../../lib/core/live_activity_service.dart](../../lib/core/live_activity_service.dart)
