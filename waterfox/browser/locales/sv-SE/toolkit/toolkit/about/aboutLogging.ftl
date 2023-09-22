# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = Om loggning
about-logging-page-title = Hantera loggar
about-logging-current-log-file = Aktuell loggfil:
about-logging-new-log-file = Ny loggfil:
about-logging-currently-enabled-log-modules = För närvarande aktiverade loggmoduler:
about-logging-log-tutorial = Se <a data-l10n-name="logging">HTTP-loggning</a> för instruktioner om hur du använder detta verktyg.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = Öppna katalog
about-logging-set-log-file = Ange loggfil
about-logging-set-log-modules = Ange loggmoduler
about-logging-start-logging = Starta loggning
about-logging-stop-logging = Stoppa loggning
about-logging-buttons-disabled = Loggning konfigurerad via miljövariabler, dynamisk konfiguration inte tillgänglig.
about-logging-some-elements-disabled = Loggning konfigurerad via URL, vissa konfigurationsalternativ är inte tillgängliga
about-logging-info = Info:
about-logging-log-modules-selection = Val av loggmodul
about-logging-new-log-modules = Nya loggmoduler:
about-logging-logging-output-selection = Utdata för loggar
about-logging-logging-to-file = Loggar till en fil
about-logging-logging-to-profiler = Loggar till { -profiler-brand-name }
about-logging-no-log-modules = Ingen
about-logging-no-log-file = Ingen
about-logging-logging-preset-selector-text = Förinställning för loggar:
about-logging-with-profiler-stacks-checkbox = Aktivera stackspårningar för loggmeddelanden

## Logging presets

about-logging-preset-networking-label = Nätverk
about-logging-preset-networking-description = Logga moduler för att diagnostisera nätverksproblem
about-logging-preset-networking-cookie-label = Kakor
about-logging-preset-networking-cookie-description = Logga moduler för att diagnostisera kakproblem
about-logging-preset-networking-websocket-label = WebSockets
about-logging-preset-networking-websocket-description = Logga moduler för att diagnostisera WebSocket-problem
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = Logga moduler för att diagnostisera HTTP/3- och QUIC-problem
about-logging-preset-media-playback-label = Uppspelning av media
about-logging-preset-media-playback-description = Logga moduler för att diagnostisera uppspelningsproblem av media (inte videokonferensproblem)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = Logga moduler för att diagnostisera WebRTC-anrop
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = Logga moduler för att diagnostisera WebGPU-problem
about-logging-preset-gfx-label = Grafik
about-logging-preset-gfx-description = Logga moduler för att diagnostisera grafikproblem
about-logging-preset-custom-label = Anpassad
about-logging-preset-custom-description = Loggmoduler manuellt valda
# Error handling
about-logging-error = Fel:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = Ogiltigt värde "{ $v }" för nyckeln "{ $k }"
about-logging-unknown-logging-preset = Okänd förinställning av logg "{ $v }"
about-logging-unknown-profiler-preset = Okänd förinställning av profilering "{ $v }"
about-logging-unknown-option = Okänt alternativ för about:logging "{ $k }"
about-logging-configuration-url-ignored = Konfigurations-URL ignoreras
about-logging-file-and-profiler-override = Det går inte att tvinga fram filutmatning och åsidosätta profileringsalternativ samtidigt
about-logging-configured-via-url = Alternativ konfigurerat via URL
