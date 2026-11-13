# Testen

## Overzicht

Het repository bevat zowel standaard Flutter widget tests als visuele golden/screenshot tests. De testopzet is bewust gericht op UI-validatie en project-specifieke schermen, in plaats van een brede backend-test suite.

## Testbestanden

Het repository bevat:

- [../test/widget_test.dart](../test/widget_test.dart)
- [../test/screenshot_test.dart](../test/screenshot_test.dart)
- [../test/screenshot_utils.dart](../test/screenshot_utils.dart)

## Widget tests

Het simpele widget-testbestand is momenteel minimaal en functioneert feitelijk als placeholder:

- [../test/widget_test.dart](../test/widget_test.dart)

Op dit moment bevat het geen assertions of testlogica, waardoor de echte UI-validatie in het project vooral via de screenshot/golden pipeline gaat.

## Screenshot- en golden tests

De screenshot-suite in [../test/screenshot_test.dart](../test/screenshot_test.dart) is veel omvangrijker. Het maakt device-specifieke snapshots voor:

- welkomstscherm
- kalenderweergave
- cijferstatistieken
- rekenmachine scherm
- studiewijzerlijst
- activiteiten scherm
- berichtenscherm

De tests zetten platformmocks voor iOS en Android en gebruiken de `golden_screenshot` package om specifieke schermen te renderen voor validatie. Het bestand bevat een comment met de procedure voor het bijwerken van screenshots:

```bash
flutter test --update-goldens
```

Dit is de duidelijkste geautomatiseerde UI-validatie in het project.

## Opmerkingen over de testomgeving

De screenshot-omgeving gebruikt custom app setup helpers en mock platform flags via `AppPlatform.setMockPlatform(...)`. Dit is handig om platform-specifieke UI-code deterministisch te testen zonder echte hardware.

Het project initialiseert ook een screenshot-specifieke omgeving voordat de tests renderen. Dit staat in [../test/screenshot_utils.dart](../test/screenshot_utils.dart).

## Tests uitvoeren

Typische commando’s zijn:

```bash
flutter test
flutter test --update-goldens
```

## Gaps of beperkingen

- Er is geen grote API-/integratietest suite zichtbaar in de repository-structuur.
- Het widget-testbestand is praktisch leeg, dus bijdragers zouden voor nieuwe logica echte behavior tests moeten toevoegen.
- Golden tests zijn het beste voor visuele regressies, niet voor business-rule correctness op schaal.

## Best practices voor bijdragers

- Voeg tests toe voor logica die gebruikersdata of refreshgedrag wijzigt.
- Geef de voorkeur aan echt gedrag boven mock-only assertions.
- Gebruik de screenshot-suite voor UI-regressiechecks, vooral rond rooster- en cijfer schermen.
- Houd platform-specifieke UI-validatie gericht op het relevante device of mock platform.

## Referenties

- [../test/widget_test.dart](../test/widget_test.dart)
- [../test/screenshot_test.dart](../test/screenshot_test.dart)
- [../test/screenshot_utils.dart](../test/screenshot_utils.dart)
- [../lib/utils/app_platform.dart](../lib/utils/app_platform.dart)
