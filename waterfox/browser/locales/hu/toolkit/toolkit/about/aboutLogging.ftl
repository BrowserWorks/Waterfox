# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = A naplózásról
about-logging-page-title = Naplókezelő
about-logging-current-log-file = Jelenlegi naplófájl:
about-logging-new-log-file = Új naplófájl:
about-logging-currently-enabled-log-modules = Jelenleg engedélyezett naplómodulok:
about-logging-log-tutorial =
    Az eszköz használatáról lásd a
    <a data-l10n-name="logging">HTTP Logging</a> leírást.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = Könyvtár megnyitása
about-logging-set-log-file = Naplófájl beállítása
about-logging-set-log-modules = Naplómodulok beállítása
about-logging-start-logging = Naplózás elkezdése
about-logging-stop-logging = Naplózás leállítása
about-logging-buttons-disabled = A naplózás környezeti változókkal lett beállítva, a dinamikus konfiguráció nem érhető el.
about-logging-some-elements-disabled = A naplózás webcím alapján lett beállítva, néhány konfigurációs lehetőség nem érhető el
about-logging-info = Információ:
about-logging-log-modules-selection = Naplómodulok kiválasztása
about-logging-new-log-modules = Új naplómodulok:
about-logging-logging-output-selection = Naplózási kimenet
about-logging-logging-to-file = Naplózás fájlba
about-logging-logging-to-profiler = Naplózás a { -profiler-brand-name }be
about-logging-no-log-modules = Nincs
about-logging-no-log-file = Nincs
about-logging-logging-preset-selector-text = Naplózási előbeállítás:
about-logging-with-profiler-stacks-checkbox = Veremkiíratások engedélyezése a naplóüzeneteknél

## Logging presets

about-logging-preset-networking-label = Hálózat
about-logging-preset-networking-description = Naplómodulok a hálózati problémák diagnosztizálásához
about-logging-preset-networking-cookie-label = Sütik
about-logging-preset-networking-cookie-description = Naplómodulok a sütiproblémák diagnosztizálásához
about-logging-preset-networking-websocket-label = WebSocketek
about-logging-preset-networking-websocket-description = Naplómodulok a WebSocket problémák diagnosztizálásához
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = Naplómodulok a HTTP/3 és QUIC problémák diagnosztizálásához
about-logging-preset-media-playback-label = Médialejátszás
about-logging-preset-media-playback-description = Naplómodulok a médialejátszási (nem videókonferenciával kapcsolatos) problémák diagnosztizálásához
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = Naplómodulok a WebRTC hívások diagnosztizálásához
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = Naplómodulok a WebGPU problémák diagnosztizálásához
about-logging-preset-gfx-label = Grafika
about-logging-preset-gfx-description = Naplómodulok a grafikai problémák diagnosztizálásához
about-logging-preset-custom-label = Egyéni
about-logging-preset-custom-description = Kézzel kiválasztott naplómodulok
# Error handling
about-logging-error = Hiba:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = Érvénytelen „{ $v }“ érték a(z) „{ $k }“ kulcshoz
about-logging-unknown-logging-preset = Ismeretlen „{ $v }” naplózási előbeállítás
about-logging-unknown-profiler-preset = Ismeretlen „{ $v }” profil-előbeállítás
about-logging-unknown-option = Ismeretlen „{ $k }” about:logging kapcsoló
about-logging-configuration-url-ignored = Konfigurációs webcím figyelmen kívül hagyva
about-logging-file-and-profiler-override = Nem lehet egyszerre kényszeríteni a fájlkimenetet és felülbírálni a profilozó beállításait
about-logging-configured-via-url = Webcím alapján beállított kapcsoló
