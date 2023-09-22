# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = Over logging
about-logging-page-title = Loggingbeheerder
about-logging-current-log-file = Huidige logbestand:
about-logging-new-log-file = Nieuw logboekbestand:
about-logging-currently-enabled-log-modules = Momenteel ingeschakelde logboekmodules:
about-logging-log-tutorial =
    Zie <a data-l10n-name="logging">HTTP logging</a>
    voor instructies over het gebruik van dit hulpmiddel.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = Map openen
about-logging-set-log-file = Logbestand instellen
about-logging-set-log-modules = Logmodules instellen
about-logging-start-logging = Registratie starten
about-logging-stop-logging = Registratie stoppen
about-logging-buttons-disabled = Logging geconfigureerd via omgevingsvariabelen, dynamische configuratie niet beschikbaar.
about-logging-some-elements-disabled = Logging geconfigureerd via URL, sommige configuratie-opties zijn niet beschikbaar
about-logging-info = Info:
about-logging-log-modules-selection = Logboekmoduleselectie
about-logging-new-log-modules = Nieuwe logboekmodules:
about-logging-logging-output-selection = Logginguitvoer
about-logging-logging-to-file = Logging naar een bestand
about-logging-logging-to-profiler = Logging naar de { -profiler-brand-name }
about-logging-no-log-modules = Geen
about-logging-no-log-file = Geen
about-logging-logging-preset-selector-text = Voorinstelling logging:
about-logging-with-profiler-stacks-checkbox = Stacktraces voor logboekberichten inschakelen

## Logging presets

about-logging-preset-networking-label = Netwerk
about-logging-preset-networking-description = Logboekmodules om netwerkproblemen te diagnosticeren
about-logging-preset-networking-cookie-label = Cookies
about-logging-preset-networking-cookie-description = Logboekmodules om cookieproblemen te diagnosticeren
about-logging-preset-networking-websocket-label = WebSockets
about-logging-preset-networking-websocket-description = Logboekmodules om WebSocketproblemen te diagnosticeren
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = Logboekmodules om HTTP/3- en QUIC-problemen te diagnosticeren
about-logging-preset-media-playback-label = Media afspelen
about-logging-preset-media-playback-description = Logboekmodules om problemen met het afspelen van media te diagnosticeren (geen problemen met videoconferenties)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = Logboekmodules om WebRTC-aanroepen te diagnosticeren
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = Logboekmodules om WebGPU te diagnosticeren
about-logging-preset-gfx-label = Grafisch
about-logging-preset-gfx-description = Logboekmodules om grafische problemen te diagnosticeren
about-logging-preset-custom-label = Aangepast
about-logging-preset-custom-description = Logboekmodules handmatig geselecteerd
# Error handling
about-logging-error = Fout:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = Ongeldige waarde ‘{ $v }’ voor sleutel ‘{ $k }’
about-logging-unknown-logging-preset = Onbekende voorinstelling logging ‘{ $v }’
about-logging-unknown-profiler-preset = Onbekende voorinstelling voor profiler ‘{ $v }’
about-logging-unknown-option = Onbekende about:logging-optie ‘{ $k }’
about-logging-configuration-url-ignored = Configuratie-URL genegeerd
about-logging-file-and-profiler-override = Kan niet tegelijkertijd bestandsuitvoer forceren en profileropties overschrijven
about-logging-configured-via-url = Optie geconfigureerd via URL
