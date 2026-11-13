# Platformoverzicht

## Ondersteunde targets

Het repository is opgezet voor deze besturingssystemen en app-targets:

- Android
- iOS
- macOS
- Linux
- Windows
- watchOS

Het repository bevat ook Android Wear app-code, die functioneel is gekoppeld aan de telefoonapp via `watch_connectivity` en ingebouwde app-logica.

## Platformspecifieke kenmerken

### Mobiel

- Android: native meldingen, alarm manager, deep links en Android-specifieke permissions
- iOS: shared app groups, widgets, Handoff, live activities, permission- en meldingsverzoeken

### Desktop

- macOS: desktop app plus widget- en menu-integratie
- Linux: GTK desktop shell en app bundle configuratie
- Windows: custom URI registratie en deep-link handling

### Wear

- watchOS en Android Wear worden behandeld als companion experiences voor het actieve rooster en cijferdata, niet als zelfstandige full applications.

## Gemeenschappelijk appgedrag over platforms

Alle platformentrypoints draaien uiteindelijk door naar dezelfde Flutter-app-logica, maar platformspecifieke services worden aangezet via OS-checks in [../../lib/main.dart](../../lib/main.dart).

De app is ontworpen als één product met veel adaptatielagen in plaats van een aparte app per platform.

## Platformspecifieke documentatie

- [android.md](android.md)
- [ios.md](ios.md)
- [macos.md](macos.md)
- [linux.md](linux.md)
- [windows.md](windows.md)
- [watchos.md](watchos.md)

## Cross-platform notities

Het project gebruikt een gedeelde app group identifier en ook aangepaste URL schemes over platforms. Dit geeft aan dat de app is ontworpen om te communiceren met native besturingssysteemfuncties in plaats van een puur browser-achtige app shell te leveren.

## Referenties

- [../../lib/main.dart](../../lib/main.dart)
- [../../pubspec.yaml](../../pubspec.yaml)
- [../../android](../../android)
- [../../ios](../../ios)
- [../../macos](../../macos)
- [../../linux](../../linux)
- [../../windows](../../windows)
- [../../watchOS](../../watchOS)
