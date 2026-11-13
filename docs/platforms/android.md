# Android

## Overzicht

Android is een primaire target voor de app en bevat ook het companion Wear OS-project. De Android app-entry is geconfigureerd in [../../android/app](../../android/app), en de app registreert Magister OAuth deep links plus app-sharing hooks.

## Belangrijkste technologieën

- Flutter app runtime
- Android native manifest config
- `android_alarm_manager_plus`
- `flutter_local_notifications`
- `watch_connectivity` voor de watch app
- `permission_handler`
- `mobile_scanner` en camera-gebaseerde flows wanneer gebruikt in schermmodules

## Hoofdmapstructuur

- [../../android/app](../../android/app) — app package en Android-settings
- [../../android/wear](../../android/wear) — Wear OS companion app

## Runtimegedrag

Het Android-manifest registreert:

- launcher entry
- `m6loapp` OAuth callback scheme
- `discipulus` scheme
- HTTP deep links voor app login routes
- share intents voor ontvangen bestanden en media
- Boot-completed en notification broadcast receivers

Dit is zichtbaar in [../../android/app/src/main/AndroidManifest.xml](../../android/app/src/main/AndroidManifest.xml).

## Achtergrond- en planning gedrag

De app zet Android-specifieke achtergrondrefresh en alarm scheduling aan via:

- [../../lib/main.dart](../../lib/main.dart)
- [../../lib/core/background_tasks.dart](../../lib/core/background_tasks.dart)
- `android_alarm_manager_plus`

De app vraagt ook om notification permission en plant reminder-logica in.

## Wear OS

Het Android Wear companion project bestaat onder [../../android/wear](../../android/wear). Het deelt dezelfde app-identiteit en is gekoppeld aan rooster- en cijfer synchronisatie via `WatchService`.

## Build en run

```bash
flutter run -d android
```

Voor een release build:

```bash
flutter build apk
```

## Risico’s en beperkingen

- Android-specifieke permission en background scheduling gedrag kan fragiel zijn over OEM-implementaties heen.
- Het repo bevat meerdere Android-specifieke services en notifiers, die device testing vereisen.
- De app is geen minimale Flutter build; het hangt af van meerdere native Android-integratiepunten.

## Referenties

- [../../android/app/src/main/AndroidManifest.xml](../../android/app/src/main/AndroidManifest.xml)
- [../../android/wear](../../android/wear)
- [../../lib/core/watch_service.dart](../../lib/core/watch_service.dart)
- [../../lib/core/background_tasks.dart](../../lib/core/background_tasks.dart)
