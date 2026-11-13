# Windows

## Overzicht

Windows support is geïmplementeerd als Flutter desktop build met custom URL protocol registration, zodat de app deep links zoals `m6loapp` en `discipulus` kan ontvangen zonder handmatige setup. Dit is een sterke aanwijzing dat de app is ontworpen voor meer dan een simpele desktop wrapper.

## Belangrijkste technologieën en dependencies

- Flutter desktop runtime
- `app_links` plugin integratie
- Windows native URL registration
- MSIX packaging metadata in [../../pubspec.yaml](../../pubspec.yaml)

## Hoofdmapstructuur en verantwoordelijkheden

- [../../windows](../../windows) — Windows runner en packaging code
- [../../windows/runner/main.cpp](../../windows/runner/main.cpp) — URL protocol registration en window bootstrap
- [../../pubspec.yaml](../../pubspec.yaml) — MSIX configuratie

## Platformgedrag

De Windows runner registreert de volgende custom protocols:

- `m6loapp`
- `discipulus`

Het stuurt app-link requests ook door naar een bestaande app-instantie, wat een standaard patroon is voor single-instance desktop apps.

## Build en run

```bash
flutter run -d windows
```

Voor een packaged build:

```bash
flutter build windows
```

Het package bevat ook een MSIX configuratieblock in [../../pubspec.yaml](../../pubspec.yaml), wat extra packaging support voor Windows installs aangeeft.

## Risico’s en beperkingen

- Windows deeplink registratie is user-scoped en vereist correcte app protocol registration.
- Desktop support introduceert extra build variance in vergelijking met mobile-only Flutter apps.
- De app hangt nog steeds af van dezelfde lokale data en Magister APIs als alle andere platforms.

## Referenties

- [../../windows/runner/main.cpp](../../windows/runner/main.cpp)
- [../../pubspec.yaml](../../pubspec.yaml)
- [../../lib/main.dart](../../lib/main.dart)
- [../../lib/mcp/local_ipc.dart](../../lib/mcp/local_ipc.dart)
