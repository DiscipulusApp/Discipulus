# watchOS

## Overzicht

watchOS wordt behandeld als een companion surface in plaats van een apart product met een volledig onafhankelijk appmodel. Het repository bevat een watch app onder [../../watchOS](../../watchOS), en de iPhone/Flutter app stuurt rooster- en cijferdata naar de watch via de `watch_connectivity` package.

## Belangrijkste technologieën en dependencies

- `watch_connectivity`
- watchOS app bestanden onder het watch app target
- app group shared storage met de hoofdapp
- rooster- en cijfer sync logica in [../../lib/core/watch_service.dart](../../lib/core/watch_service.dart)

## Hoofdmapstructuur en verantwoordelijkheden

- [../../watchOS](../../watchOS) — watchOS app source en UI-bestanden
- [../../android/wear](../../android/wear) — Android Wear app source en model layer
- [../../lib/core/watch_service.dart](../../lib/core/watch_service.dart) — watch synchronisatie service

## Runtimegedrag

De watch-service coördineert:

- `get_schedule` en `get_grades` requests van de watch
- rooster- en cijfer payload updates
- aanpassen van kalenderitems via de watch
- app-context synchronisatie met de watch

De app initialiseert ook een startup sync voor watch activities en update de context wanneer de app opnieuw actief wordt.

## Platformgedrag

De watch app is sterk gekoppeld aan de lokale modelstate van de hoofdapp. Het vervangt niet de Magister API access layer; in plaats daarvan consumeert het data die al is geladen door de app of refresht het wanneer nodig.

## Build en run

Voor de iPhone/Flutter app:

```bash
flutter run -d ios
```

Vervolgens bouw je de watch app met het Apple Xcode target of de relevante watch app workflow in Xcode.

## Risico’s en beperkingen

- Companion app gedrag hangt af van pairing en connectivity tussen telefoon en watch.
- Watch-app features zijn niet onafhankelijk van de data lifecycle van de telefoonapp.
- Sommige watch features vereisen expliciete device tests op echt hardware.

## Referenties

- [../../lib/core/watch_service.dart](../../lib/core/watch_service.dart)
- [../../watchOS](../../watchOS)
- [../../android/wear](../../android/wear)
- [../../lib/models/settings.dart](../../lib/models/settings.dart)
