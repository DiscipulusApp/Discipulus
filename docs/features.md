# Functies

## Overzicht

Discipulus is geen eenmalige Magister-client met één functie. De app bevat een breed dashboard met veel samenhangende schermmodules in [../lib/screens](../lib/screens), waarbij gegevens komen uit de Magister-API en de lokale Isar-store.

## Kernfuncties

### Rooster en agenda

De app toont het schoolrooster als een kalender-ervaring. In de route registry wordt de kalender behandeld als een eerste-klasse bestemming, en de app bevat custom logica voor:

- gecombineerde double periods
- lege ruimtes tussen lessen
- weergave van statusen
- annuleringen en infotypes
- dagnavigatie en statistieken

De relevante implementatie staat verspreid over:

- [../lib/core/routes.dart](../lib/core/routes.dart)
- [../lib/screens/calendar](../lib/screens/calendar)
- [../lib/api/models/calendar.dart](../lib/api/models/calendar.dart)

### Cijfers en gemiddelden

Cijfers zijn een eerste-klasse datamodellering met uitgebreide berekeningen van vakgemiddelden en statistieken. De app bevat:

- recente cijfers
- vakgebonden gemiddelden
- cijfercalculators en statistieken
- filteren op vak / datum
- grafieken en badges

Dit draait via de cijfermodellen en grade-helpers onder:

- [../lib/api/models/grades.dart](../lib/api/models/grades.dart)
- [../lib/screens/grades](../lib/screens/grades)
- [../lib/screens/grades/grade_extensions.dart](../lib/screens/grades/grade_extensions.dart)

### Berichten en bijlagen

Het berichtensysteem maakt het mogelijk om:

- inboxberichten te lezen en sorteren
- te filteren op ongelezen
- details te openen
- bijlagen te bekijken en te beantwoorden
- attachments lokaal op te slaan voor offline gebruik

De code zit onder:

- [../lib/screens/messages](../lib/screens/messages)
- [../lib/api/routes/messages.dart](../lib/api/routes/messages.dart)
- [../lib/api/models/messages.dart](../lib/api/models/messages.dart)

### Opdrachten en leermiddelen

De app toont opdrachten en leermiddelen in aparte schermen. De destination list bevat secties voor Opdrachten en Leermiddelen, en de app ondersteunt detailweergaven voor taken en onderwijsresources.

Belangrijke bestanden:

- [../lib/screens/assignments](../lib/screens/assignments)
- [../lib/screens/leermiddelen.dart](../lib/screens/leermiddelen.dart)
- [../lib/api/models/assignments.dart](../lib/api/models/assignments.dart)
- [../lib/api/models/leermiddelen.dart](../lib/api/models/leermiddelen.dart)

### Studiewijzers en externe bronnen

De app ondersteunt studiewijzers en externe bronnen, inclusief filter- en zoekgedrag in de betreffende schermmodules. Dit is bewust gescheiden als een eigen inhoudsgebied in plaats van een generieke bestandsbrowser.

Belangrijke bestanden:

- [../lib/screens/studiewijzers](../lib/screens/studiewijzers)
- [../lib/screens/bronnen](../lib/screens/bronnen)
- [../lib/api/models/studiewijzers.dart](../lib/api/models/studiewijzers.dart)

### Activiteiten en absenties

De app bevat schermen voor activiteiten en absenties. Dit is zichtbaar in de destinations en in de schema-lijst in [../lib/core/isar.dart](../lib/core/isar.dart).

Belangrijke bestanden:

- [../lib/screens/activities](../lib/screens/activities)
- [../lib/screens/calendar/absences.dart](../lib/screens/calendar/absences.dart)
- [../lib/api/models/activities.dart](../lib/api/models/activities.dart)

### Instellingen en AI

Het instellingenmenu bevat configuratie voor:

- helderheid en Material You-thema
- meldingsvoorkeuren
- live activities en reminders
- AI-providerconfiguratie (OpenAI-compatibel of lokale AI)

De AI-integratie staat in [../lib/screens/ai](../lib/screens/ai) en [../lib/screens/ai/ai_service.dart](../lib/screens/ai/ai_service.dart). De app schakelt lokale AI automatisch in als er een compatibele lokale model beschikbaar is.

## Native integraties en platformgedrag

De app bevat meerdere functies die verder gaan dan een standaard schermset:

- native meldingen en reminder-scheduling
- Apple Handoff en widget-routing
- home widgets voor rooster
- Watch-connectiviteit voor rooster en cijfers
- live lesson activity cards op ondersteunde apparaten
- lokale desktop IPC voor MCP-tools
- custom URL schemes voor Magister-login en deep links

Deze zijn beschreven in [integrations.md](integrations.md). Het gaat niet om puur visuele features, maar om daadwerkelijke runtimegedrag van de app.

## Offline en local-first gedrag

De app is expliciet ontworpen om snel te werken en offline bruikbaar te zijn. Het local-first model is zichtbaar in de Isar-cache en in de manier waarop snapshot-refreshes lokaal worden gedaan. Dit is een van de kernvoorzieningen die in de hoofd-README expliciet wordt benoemd.

## Risico’s en beperkingen

- Meldingsgedrag is in de hoofd-README benoemd als niet volledig optimaal door beperkingen in de Magister-API.
- Sommige features zijn afhankelijk van platformspecifieke services en vereisen daarom device-specifieke tests.
- De app gebruikt native code en app groups voor widget- en handofffeatures, wat onderhouds- en complexiteitskosten verhoogt.

## Referenties

- [../README.md](../README.md)
- [../lib/core/routes.dart](../lib/core/routes.dart)
- [../lib/screens](../lib/screens)
- [../lib/core/notifications.dart](../lib/core/notifications.dart)
- [../lib/core/watch_service.dart](../lib/core/watch_service.dart)
- [../lib/screens/ai/ai_service.dart](../lib/screens/ai/ai_service.dart)
