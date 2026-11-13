# MCP-server

## Overzicht

Het repository bevat een ingebouwde Model Context Protocol (MCP)-server. Dit is één van de onderscheidende kenmerken van het project: de app kan relevante Magister-data en acties blootleggen aan externe AI-tools en desktopclients, terwijl de app zelf nog steeds draait als de hoofdapp.

De server wordt gestart wanneer de app wordt gelanceerd met het `--mcp`-vlag in [../lib/main.dart](../lib/main.dart). De hoofdimplementatie zit in [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart).

## Runtimegedrag

De server gebruikt de `mcp_dart` package om een server over stdio te exposen. De workflow is:

1. app start in MCP-modus via `--mcp`
2. `runMcpServer()` wordt aangeroepen
3. `DiscipulusMcpServer` bouwt de server en registreert tools
4. tool-uitvoering either:
   - gebruikt de live lokale IPC-bridge als de GUI-app al draait, of
   - valt terug op directe Isar-toegang in een headless omgeving

Deze logica staat in [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart).

## Lokale IPC-bridge

De app bevat ook een lichte lokale HTTP-server in [../lib/mcp/local_ipc.dart](../lib/mcp/local_ipc.dart).

Deze luistert op `127.0.0.1:3377` en exposeert:

- `/status` — health en profielmetadata
- `/tool` — voert een specifieke Discipulus-tool uit

Dit laat de MCP-server requests routeren naar een al draaiende Discipulus-instantie in plaats van een aparte achtergrondprocess te eisen voor alle state.

## Tool registry

De tool registry is geregistreerd in [../lib/mcp/mcp_tools.dart](../lib/mcp/mcp_tools.dart). Het exposeert een grote set sterk getypte tools rond veelgebruikte gebruikersgegevens, waaronder rooster- en kalenderoperaties, cijfers, opdrachten, berichten, studiewijzers, profielinformatie en navigatie.

Voorbeelden uit de code zijn:

- `discipulus_get_schedule`
- `discipulus_get_event_detail`
- `discipulus_get_grades`
- `discipulus_get_subject_averages`
- `discipulus_get_assignments`
- `discipulus_get_messages`
- `discipulus_get_message_detail`
- `discipulus_navigate_to_screen`
- `discipulus_edit_event`
- `discipulus_compose_message`
- `discipulus_download_file`

De exacte tool-lijst is groter dan de voorbeelden hierboven; de implementatie is de bron van waarheid.

## Service-laag achter de tools

De werkelijke uitvoerlogica zit gecentraliseerd in [../lib/mcp/mcp_service.dart](../lib/mcp/mcp_service.dart). Deze controleert de actieve profielstatus en roept de bestaande domeinlogica aan voor:

- rooster- en eventfetches
- berichtdetail ophalen
- cijferdata ophalen
- vakgemiddelden
- navigatie naar UI-schermen
- file-download acties
- profielswitching

Dit is belangrijk omdat de MCP-server is ontworpen om dezelfde datamodellen en toegangspatronen te hergebruiken als de app, in plaats van een tweede parallelle backend te bouwen.

## Data- en authenticatiemodel

De MCP-server is expliciet profielbewust. Hij vereist een actief Magister-account en profiel voordat data wordt blootgegeven. Als er geen profiel beschikbaar is, geeft de server een duidelijke foutmelding terug dat de gebruiker eerst in moet loggen bij Discipulus.

Dit wordt afgehandeld in de server-error path in [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart) en in de service layer in [../lib/mcp/mcp_service.dart](../lib/mcp/mcp_service.dart).

## Gebruikvoorbeeld

De hoofd-README bevat een voorbeeld van een macOS-configuratie, vergelijkbaar met:

```json
{
  "mcpServers": {
    "discipulus": {
      "command": "/Applications/Discipulus.app/Contents/MacOS/discipulus",
      "args": ["--mcp"]
    }
  }
}
```

Dit bevestigt de bedoelde integratie met externe AI-clients zoals Claude Desktop of Cursor.

## Risico’s en beperkingen

- De MCP-interface is gekoppeld aan de lokale state en het actieve profiel van de app; het is geen standalone remote service.
- Externe tools kunnen alleen werken wanneer de app een actieve geldige sessie en beschikbaar profiel heeft.
- De server gebruikt dezelfde onderliggende Magister-datastroom als de app, dus API-beperkingen en rechten gelden ook hier.

## Referenties

- [../lib/mcp/mcp_server.dart](../lib/mcp/mcp_server.dart)
- [../lib/mcp/local_ipc.dart](../lib/mcp/local_ipc.dart)
- [../lib/mcp/mcp_service.dart](../lib/mcp/mcp_service.dart)
- [../lib/mcp/mcp_tools.dart](../lib/mcp/mcp_tools.dart)
- [../README.md](../README.md)
