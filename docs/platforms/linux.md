# Linux

## Overzicht

Het Linux-target is een desktop Flutter build geconfigureerd met GTK en een custom application ID. Het is een standaard Flutter desktop app, maar het project voegt ook een lokale IPC-server en headless MCP-server support toe voor tooling-integratie.

## Belangrijkste technologieën en dependencies

- Flutter desktop runtime
- GTK package configuratie
- CMake-based native bundle setup
- `app_links` voor link handling
- lokale loopback IPC-server voor MCP-integratie

## Hoofdmapstructuur en verantwoordelijkheden

- [../../linux](../../linux) — Linux desktop entrypoint en native wrapper
- [../../lib/mcp/local_ipc.dart](../../lib/mcp/local_ipc.dart) — localhost IPC bridge
- [../../lib/mcp/mcp_server.dart](../../lib/mcp/mcp_server.dart) — stdio MCP-server

## Platformgedrag

Het Linux CMake-bestand zet de application ID op `dev.harrydekat.discipulus` en bouwt een GTK app. De app heeft ook een fallback path voor Isar native library extraction op Linux in [../../lib/core/isar.dart](../../lib/core/isar.dart).

Dit laat zien dat de app niet alleen een generieke Flutter-installatie target is; het bevat custom handling voor lokale data en headless server scenarios.

## Build en run

```bash
flutter run -d linux
```

Voor een build artifact:

```bash
flutter build linux
```

## Risico’s en beperkingen

- Linux builds vereisen GTK/system dependencies op de hostmachine.
- Native libraries voor Isar worden geëxtraheerd of geladen op custom manieren, wat platform-specifieke onderhoud kan vereisen.
- Het desktopgedrag van de app is cross-platform, maar enkele geavanceerde integraties zijn alleen voor Apple of Windows targets geïmplementeerd.

## Referenties

- [../../linux/CMakeLists.txt](../../linux/CMakeLists.txt)
- [../../lib/core/isar.dart](../../lib/core/isar.dart)
- [../../lib/mcp/local_ipc.dart](../../lib/mcp/local_ipc.dart)
- [../../lib/mcp/mcp_server.dart](../../lib/mcp/mcp_server.dart)
