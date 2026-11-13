# Architectuur

## Overzicht

De architectuur is opgebouwd als een gelaagde Flutter-app met een duidelijke afhankelijkheid van lokale opslag en native platformplugins. In grote lijnen doet het systeem het volgende:

1. de app start en initialiseert Isar en platformservices
2. de gebruiker logt in bij Magister via OAuth-achtige flow
3. account-, profiel-, rooster-, cijfer- en berichtgegevens worden lokaal gecacht
4. schermen renderen vanuit deze cache en doen periodiek live refreshes
5. dezelfde data wordt gebruikt voor meldingen, widgets, Watch-connectiviteit en de ingebouwde MCP-server

## Opstarten van de runtime

De levenscyclus begint in [../lib/main.dart](../lib/main.dart). Dit bestand doet de initiële platform-setup:

- parseert `--mcp` om de headless MCP-server te starten
- initialiseert Flutter bindings en app-niveau services
- opent de Isar-database via [../lib/core/isar.dart](../lib/core/isar.dart)
- initialiseert tijdzones en locale-data
- registreert achtergrondrefresh, meldingen, watch-sync en live activities waar relevant
- registreert app-links, share-handlers en lifecycle observers
- bouwt de hoofd-`MaterialApp` met theming en het juiste startscherm

Het startscherm wordt gekozen op basis van het bestaan van een profiel. Als er nog geen profiel bestaat, toont de app de onboarding; anders wordt het actieve profiel geladen en de ingestelde startpagina uit [../lib/core/routes.dart](../lib/core/routes.dart).

## Gelaagde opbouw

### 1. Applicatie-shell en navigatie

De shell draait om `MainApp` en de destination-list in [../lib/core/routes.dart](../lib/core/routes.dart).

De destination-registry bepaalt:

- hoofdcategorieën zoals Kalender, Cijfers, Berichten, Studiewijzers, Opdrachten, etc.
- subviews per functie
- menu-balk logic voor macOS
- sneltoetsen voor navigatie

Zo heeft de app één consistente navigatiemodel in plaats van losse screen-by-screen routes.

### 2. Account- en profielmodel

Accounts en profielen worden beschreven in [../lib/models/account.dart](../lib/models/account.dart) en [../lib/models/settings.dart](../lib/models/settings.dart).

Belangrijke concepten:

- `DiscipulusAccount`: een Magister-account met tokens, endpoint, rechten en profielen
- `Profile`: een persoonspecifiek contextobject voor schooljaren, rooster, berichten en cijfers
- `Settings`: persistente voorkeuren voor thema, AI, meldingen, widgetgedrag en profielstatus

De Isar-schemas voor deze modellen staan in [../lib/core/isar.dart](../lib/core/isar.dart).

### 3. Magister-API-laag

De HTTP-laag staat in [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart). Daarin wordt Dio wrapped met:

- token ophalen en refresh
- automatische retry bij verlopen sessies
- rate-limit handling
- OAuth-token refresh via `TokenSet`
- per-account Dio-instances om collisions te voorkomen tussen profielen of scholen

De app splitst domein-specifieke endpoints verder op in route-classes in [../lib/api/routes](../lib/api/routes) en datamodellen in [../lib/api/models](../lib/api/models).

### 4. UI-featuremodules

De UI zit onder [../lib/screens](../lib/screens). Die is georganiseerd per functionaliteit:

- kalender
- cijfers
- berichten
- opdrachten
- studiewijzers / leermiddelen
- activiteiten
- instellingen
- AI-chat
- samenvatting/home

De meeste schermen halen gegevens uit de lokale Isar-store en sommige modules triggeren direct een refresh vanuit de Magister-route-laag.

### 5. Lokale data en persistentie

Persistentie is een belangrijke architectuurkeuze in dit project. In plaats van een eigen backend gebruikt de app Isar voor lokale caching. Dat is relevant voor:

- offline gebruik
- snelle opstart
- herhaald filteren en berekenen
- synchronisatie van state tussen widgets en platformfuncties

De schema-lijst staat in [../lib/core/isar.dart](../lib/core/isar.dart). Voor Linux valt het gebruik van een fallback-directory in de huidige werkmap of app-support directory.

## Dataflow

### Inloggen en account-bootstrap

De flow begint met Magister-authenticatie. De login-proces wordt aangestuurd door de schermen in [../lib/screens/introduction](../lib/screens/introduction), terwijl de echte auth- en tokenlogica zit in:

- [../lib/api/authentication.dart](../lib/api/authentication.dart)
- [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart)
- [../lib/models/account.dart](../lib/models/account.dart)

Een geldige Magister-`TokenSet` wordt opgeslagen op het account en daarna worden rechten en profielinformatie opgehaald via de Magister-API.

### Refresh-cyclus

Achtergrondrefresh is geïmplementeerd in [../lib/core/background_tasks.dart](../lib/core/background_tasks.dart) en bijbehorende bestanden. De app controleert periodiek of een refresh nodig is en trigger vervolgens:

- bericht-refreshes
- cijferchecks
- kalender-/absentie-refreshes
- reminder-generatie
- widget-updates
- live activity updates

Zo lijkt de app actueel te zijn, ook als de app niet op de voorgrond staat.

### Platform-integratieflow

Zodra gegevens in de lokale model-laag staan, worden ze door meerdere platformfeatures hergebruikt:

- Watch-connectiviteit stuurt rooster- en cijferinformatie
- Home Widgets tonen aankomende lessen
- meldingen laten gebruikers weten over cijfers, berichten, herinneringen of absenties
- Handoff verplaatst gebruikers naar het juiste scherm op een ander Apple-apparaat
- de MCP-server exposeert dezelfde data naar externe AI-clients

## Service- en utilitylaag

Het project bevat een brede service- en utilitylaag:

- [../lib/core/notifications.dart](../lib/core/notifications.dart) — native meldingen en acties
- [../lib/core/watch_service.dart](../lib/core/watch_service.dart) — Watch-sync en app-context updates
- [../lib/core/handoff.dart](../lib/core/handoff.dart) — Apple Handoff route-restoration
- [../lib/core/live_activity_service.dart](../lib/core/live_activity_service.dart) — live lesson activity updates
- [../lib/utils/account_manager.dart](../lib/utils/account_manager.dart) — actief profiel en accountbeheer
- [../lib/utils/app_platform.dart](../lib/utils/app_platform.dart) — platformdetectie, testvriendelijk gemaakt
- [../lib/utils/app_info.dart](../lib/utils/app_info.dart) — package metadata en versies

## Platformspecifiek gedrag

De startup logica registreert expliciet platformservices per besturingssysteem:

- Android: alarm manager, watch-sync, live activities, meldingen
- iOS/macOS: app groups, Home Widgets, Handoff, meldingen, live activities
- Linux/Windows/macOS: lokale IPC-server voor MCP en desktop-integratie

Dit is een cross-platform app, maar geen volledig uniforme runtime; native integraties worden waar nodig gebruikt.

## Risico’s en beperkingen

- Het project hangt af van een externe Magister-API, waardoor expiratie, rechten en rate limits continu moeten worden verwerkt.
- Het gedrag van meldingen is in de hoofd-README expliciet benoemd als beperkt door API-tekorten van Magister.
- De architectuur vertrouwt sterk op lokale cache-correctheid en periodieke refresh, omdat de app ontworpen is om snel en offline te werken.
- Omdat native widget- en app-groupcode aanwezig is, verschillen build- en signingvereisten per platform.

## Referenties

- [../lib/main.dart](../lib/main.dart)
- [../lib/core/routes.dart](../lib/core/routes.dart)
- [../lib/core/isar.dart](../lib/core/isar.dart)
- [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart)
- [../lib/models/account.dart](../lib/models/account.dart)
- [../lib/models/settings.dart](../lib/models/settings.dart)
