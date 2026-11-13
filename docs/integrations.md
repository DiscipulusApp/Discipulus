# Integraties

## Overzicht

Discipulus is niet alleen een UI-app. Het werkt samen met meerdere externe systemen op een native, platformbewuste manier. Het project gebruikt Magister als primaire databron, en bouwt daarbovenop platformservices voor meldingen, widgets, app-links, AI en apparaat-specifieke appflows.

## Magister-integratie

De kern van de integratie zit in de aangepaste client:

- [../lib/api/magister_api_dart.dart](../lib/api/magister_api_dart.dart)
- [../lib/api/authentication.dart](../lib/api/authentication.dart)
- [../lib/api/routes](../lib/api/routes)
- [../lib/api/models](../lib/api/models)

Deze laag wrapt de Magister-API met:

- OAuth- en token-refresh-logica
- `TokenSet` persistence
- rate-limit handling en retryflows
- endpoint-specifieke routewrappers
- automatische sessieherstel bij verlopen tokens

De app slaat de resultaten vervolgens lokaal op in Isar, zodat de UI snel en offline-friendly blijft.

## App links en deep links

De app registreert expliciet aangepaste URL schemes en deep-link gedrag:

- Android manifest registreert `m6loapp` en `discipulus` URI schemes
- iOS en macOS Info.plist entries registreren dezelfde aangepaste schemes
- Windows registreert URL-protocols voor `m6loapp` en `discipulus`

Dit wordt gebruikt voor Magister-login callbacks en app-specifieke acties, vooral rond OAuth en navigatie.

## Meldingen en herinneringen

De meldingssetup staat in [../lib/core/notifications.dart](../lib/core/notifications.dart). Deze configureert platform-notification channels voor:

- kalender
- cijfers
- berichten
- herinneringen
- absenties

Het gebruikt `flutter_local_notifications`, `android_alarm_manager_plus` en scheduling metadata voor Android en platform-specifieke initialisatie op iOS/macOS. De achtergrondrefresh in [../lib/core/background_tasks.dart](../lib/core/background_tasks.dart) koppelt deze meldingen aan account-refreshoperaties.

### Bekende beperking

De hoofd-README noemt expliciet dat pushmeldingen nog niet optimaal werken door beperkingen in de Magister-API. De app gebruikt achtergrondrefresh en scheduling-logica, maar het repo claimt geen volledig push- of server-driven meldingssysteem.

## Widgets en app-group data

De app gebruikt een gedeelde app group identifier over Apple-platforms:

- `group.DUGUWCFH8P.dev.harrydekat.discipulus`

Deze wordt samen met `home_widget` gebruikt om native widgets bij te werken. De app schrijft evenementdata en kleurmetadata voor widget-rendering vanuit [../lib/core/background_tasks.dart](../lib/core/background_tasks.dart), en de Apple widget code staat onder [../darwin](../darwin).

## Handoff en app continuity

Apple Handoff wordt geregistreerd in de app-startup flow en afgehandeld in [../lib/core/handoff.dart](../lib/core/handoff.dart). Deze code vertaalt `NSUserActivity` payloads en stuurt de gebruiker naar het juiste scherm op basis van een opgeslagen profiel en schermtype.

Voorbeelden zijn:

- kalender-eventdetails
- cijfervakscherm
- berichtdetails
- studiewijzerdetails
- opdrachtdetails
- activiteitsdetails

Dit is een echte continuity-feature, geen placeholder.

## Watch-connectiviteit

De watch-service in [../lib/core/watch_service.dart](../lib/core/watch_service.dart) synchroniseert rooster- en cijferdata met de companion watch app. Het behandelt:

- watch setup requests
- kalender sync payloads
- cijfer sync payloads
- schakelen van kalenderitems via de watch
- app-context updates naar de watch

De Android-watch app zit onder [../android/wear](../android/wear), en de watchOS app onder [../watchOS](../watchOS).

## AI en lokale modelondersteuning

De AI-laag is geïmplementeerd in [../lib/screens/ai](../lib/screens/ai) en [../lib/screens/ai/ai_service.dart](../lib/screens/ai/ai_service.dart). Ze ondersteunt:

- `AIProvider.none`
- `AIProvider.systemLocalAI`
- `AIProvider.openAI`

De app kan lokale AI automatisch inschakelen als er een compatibel lokaal model wordt gedetecteerd. Het settings-object in [../lib/models/settings.dart](../lib/models/settings.dart) slaat de providerconfiguratie op.

## Delen en content import

Het Android-manifest en iOS-appinfo registreren share handlers en file-sharing support. De app kan inkomende gedeelde data accepteren, en het repo bevat ook file/security en clipboard-integraties met packages zoals:

- `share_handler`
- `share_plus`
- `super_clipboard`
- `file_picker`

Dit maakt Discipulus nuttig als bestemming voor gedeelde media, bestanden en content.

## Desktop-integraties

De desktopplatforms zijn niet zomaar generieke Flutter-shells. Ze bevatten:

- een lokale IPC loopback-server op poort `3377` in [../lib/mcp/local_ipc.dart](../lib/mcp/local_ipc.dart)
- een headless MCP-servermodus gestart met `--mcp`
- custom URI-registratie op Windows en webview support op desktop
- Linux GTK en desktop app-configuratie in [../linux](../linux)

## Risico’s en beperkingen

- Veel integraties zijn afhankelijk van native platform entitlements en app groups.
- Sommige platformfeatures zijn alleen geldig op specifieke besturingssystemen.
- Variatie in de Magister-API betekent dat datafetching en meldingsgedrag inconsistent kunnen zijn per school en accounttype.
- Platformintegraties verhogen de setup- en onderhoudsbelasting voor bijdragers.

## Referenties

- [../lib/core/notifications.dart](../lib/core/notifications.dart)
- [../lib/core/background_tasks.dart](../lib/core/background_tasks.dart)
- [../lib/core/watch_service.dart](../lib/core/watch_service.dart)
- [../lib/core/handoff.dart](../lib/core/handoff.dart)
- [../lib/screens/ai/ai_service.dart](../lib/screens/ai/ai_service.dart)
- [../lib/mcp/local_ipc.dart](../lib/mcp/local_ipc.dart)
- [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart)
