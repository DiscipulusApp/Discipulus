# Projectstructuur

## Overzicht van de repository

De repo is een Flutter-app met native platformondersteuning en een paar lokale packages. De belangrijkste mappen zijn:

- [../lib](../lib) — Flutter-applicatiecode
- [../android](../android) — Android-app en Wear OS-configuratie
- [../ios](../ios) — iOS-app en widget-extension configuratie
- [../macos](../macos) — macOS-app configuratie en widgets
- [../linux](../linux) — Linux desktop entrypoint en packaging
- [../windows](../windows) — Windows desktop URL-registration en packaging
- [../watchOS](../watchOS) — watchOS app-bestanden
- [../packages](../packages) — lokale package dependency, zoals de advanced drawer
- [../assets](../assets) — afbeeldingen en Isar native assets
- [../test](../test) — widget- en screenshot-tests

## Hoofdmapstructuur van de app

### lib/

Dit is de kern van de Flutter-app. De code is opgesplitst per verantwoordelijkheid:

- [../lib/api](../lib/api) — Magister HTTP-client, routes en modelklassen
- [../lib/core](../lib/core) — lifecycle, navigatie, meldingen, platformhooks, Isar init, achtergrondtaken
- [../lib/mcp](../lib/mcp) — MCP-server en lokale IPC-bridge
- [../lib/models](../lib/models) — Isar-persistente modellen en settings
- [../lib/screens](../lib/screens) — schermen voor functionaliteit en onboarding
- [../lib/utils](../lib/utils) — accountbeheer, platformhelpers, metadata, app-utils
- [../lib/widgets](../lib/widgets) — gedeelde UI-componenten en layout-elementen

### lib/api

Deze map is de Magister-integratielaag.

- [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart) — centrale client met auth-refresh en per-account Dio-handling
- [../lib/api/authentication.dart](../lib/api/authentication.dart) — Magister-login en OAuth-helperlogica
- [../lib/api/routes](../lib/api/routes) — routeklassen voor schooljaren, berichten, opdrachten, personen en andere endpoints
- [../lib/api/models](../lib/api/models) — datamodellen voor Magister-responses
- [../lib/api/dummy_magister_api_dart.dart](../lib/api/dummy_magister_api_dart.dart) — offline/test-compatibele implementatie

### lib/core

Deze map bevat gedrag dat de datalaag verbindt met native platforms en achtergrondtaken.

- [../lib/core/routes.dart](../lib/core/routes.dart) — destination registry
- [../lib/core/isar.dart](../lib/core/isar.dart) — Isar-initialisatie en schema-registratie
- [../lib/core/background_tasks.dart](../lib/core/background_tasks.dart) — achtergrondrefresh en widgetupdates
- [../lib/core/notifications.dart](../lib/core/notifications.dart) — native meldingen
- [../lib/core/watch_service.dart](../lib/core/watch_service.dart) — Watch-connectiviteit
- [../lib/core/handoff.dart](../lib/core/handoff.dart) — Apple Handoff-routing
- [../lib/core/live_activity_service.dart](../lib/core/live_activity_service.dart) — live lesson activity updates

### lib/mcp

Deze map bevat de ingebouwde model-context server:

- [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart) — stdio-server entrypoint
- [../lib/mcp/mcp_service.dart](../lib/mcp/mcp_service.dart) — tool-executie tegen actief profiel en data
- [../lib/mcp/mcp_tools.dart](../lib/mcp/mcp_tools.dart) — toolregistratie en schema’s
- [../lib/mcp/local_ipc.dart](../lib/mcp/local_ipc.dart) — localhost IPC-bridge tussen desktop-app en MCP-server

### lib/models

Dit is het lokale persistentiemodel:

- [../lib/models/account.dart](../lib/models/account.dart) — account, token set, profielrelaties en account-populatie
- [../lib/models/settings.dart](../lib/models/settings.dart) — persistente app-configuratie

### lib/screens

Dit is de gebruikersinterface. De belangrijkste domeinen zijn:

- activities
- ai
- assignments
- calendar
- grades
- introduction
- messages
- settings
- studiewijzers
- summary

De app gebruikt een destination-based navigatiestructuur, waarbij schermklassen worden geselecteerd op basis van rechten en profielstatus.

### lib/utils

Ondersteunende utils omvatten:

- [../lib/utils/account_manager.dart](../lib/utils/account_manager.dart) — actief profielbeheer
- [../lib/utils/app_platform.dart](../lib/utils/app_platform.dart) — mockable platformchecks
- [../lib/utils/app_info.dart](../lib/utils/app_info.dart) — app metadata
- [../lib/utils/account_migration.dart](../lib/utils/account_migration.dart) — migratiehelpers
- [../lib/utils/extensions.dart](../lib/utils/extensions.dart) — gedeelde helpers

### lib/widgets

Gedeelde UI-building blocks zoals layout, decoratie en animaties staan hier.

## Native platformmappen

### Android

- [../android/app](../android/app) — Android-appconfiguratie en Kotlin-klassen
- [../android/wear](../android/wear) — Wear OS companion app

### iOS en macOS

- [../ios](../ios) — app-bundle, share extension en AppDelegate-integratie
- [../darwin](../darwin) — widget- en live-activityhelpers voor Apple-platforms
- [../macos](../macos) — macOS app-wrapper en widget-/entitlements-config

### Desktop

- [../linux](../linux) — Linux entrypoint en GTK desktop-configuratie
- [../windows](../windows) — Windows URL-protocolregistratie en desktop setup

### watchOS

- [../watchOS](../watchOS) — watchOS app en view modellaag

## Tests en assets

- [../test](../test) — widget-tests en golden screenshot-tests
- [../assets](../assets) — afbeeldingen, Isar native libraries en statische app-assets
- [../packages/flutter_advanced_drawer](../packages/flutter_advanced_drawer) — lokale vendored package dependency

## Belangrijke runtime-bestanden

- [../lib/main.dart](../lib/main.dart)
- [../lib/core/routes.dart](../lib/core/routes.dart)
- [../lib/core/isar.dart](../lib/core/isar.dart)
- [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart)
- [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart)
- [../lib/models/settings.dart](../lib/models/settings.dart)
- [../lib/models/account.dart](../lib/models/account.dart)

## Risico’s en beperkingen

- Het project bevat gegenereerde bestanden en native platform glue die synchroon moeten blijven met Flutter-updates en platform-SDK’s.
- Mismatch tussen Dart packages en native plugins kan specifieke platforms sneller breken dan bij een puur Flutter-project.
- Platformspecifieke code moet apart worden gevalideerd voor Android, iOS/macOS en desktop targets.
