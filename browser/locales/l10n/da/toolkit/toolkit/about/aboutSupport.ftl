# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Teknisk information
page-subtitle =
    Denne side indeholder teknisk information som måske kan være brugbar når du forsøger 
    at løse et problem. Hvis du leder efter svar på ofte spurgte spørgsmål om { -brand-short-name }, 
    kan du besøge vores <a data-l10n-name="support-link">supportwebsted</a>
crashes-title = Fejlrapporter
crashes-id = Rapport-ID
crashes-send-date = Sendt
crashes-all-reports = Alle fejlrapporter
crashes-no-config = Dette program er ikke konfigureret til at vise fejlrapporter.
extensions-title = Udvidelser
extensions-name = Navn
extensions-enabled = Aktiveret
extensions-version = Version
extensions-id = ID
support-addons-title = Tilføjelser
support-addons-name = Navn
support-addons-type = Type
support-addons-enabled = Aktiveret
support-addons-version = Version
support-addons-id = ID
security-software-title = Sikkerheds-software
security-software-type = Type
security-software-name = Navn
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = { -brand-short-name }-funktioner
features-name = Navn
features-version = Version
features-id = ID
processes-title = Fjern-processer
processes-type = Type
processes-count = Antal
app-basics-title = Programinfo
app-basics-name = Navn
app-basics-version = Version
app-basics-build-id = Build-ID
app-basics-distribution-id = Distributions-ID
app-basics-update-channel = Opdateringskanal
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Opdateringsmappe
       *[other] Opdateringsmappe
    }
app-basics-update-history = Opdateringshistorik
app-basics-show-update-history = Vis opdateringshistorik
# Represents the path to the binary used to start the application.
app-basics-binary = Programfil
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profilmappe
       *[other] Profilmappe
    }
app-basics-enabled-plugins = Aktive plugins
app-basics-build-config = Byggekonfiguration
app-basics-user-agent = User Agent
app-basics-os = Styresystem
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Rosetta Translated
app-basics-memory-use = Hukommelsesforbrug
app-basics-performance = Ydelse
app-basics-service-workers = Registrerede Service Workers
app-basics-profiles = Profiler
app-basics-launcher-process-status = Launcher Process
app-basics-multi-process-support = Multiproces-vinduer
app-basics-fission-support = Fission-vinduer
app-basics-remote-processes-count = Fjern-processer
app-basics-enterprise-policies = Virksomheds-politikker
app-basics-location-service-key-google = Google Location Service-nøgle
app-basics-safebrowsing-key-google = Google Safebrowsing-nøgle
app-basics-key-mozilla = Mozilla Location Service-nøgle
app-basics-safe-mode = Fejlsikret tilstand
show-dir-label =
    { PLATFORM() ->
        [macos] Vis i Finder
        [windows] Åbn mappe
       *[other] Åbn mappe
    }
environment-variables-title = Miljøvariabler
environment-variables-name = Navn
environment-variables-value = Værdi
experimental-features-title = Eksperimentelle funktioner
experimental-features-name = Navn
experimental-features-value = Værdi
modified-key-prefs-title = Vigtige ændrede indstillinger
modified-prefs-name = Navn
modified-prefs-value = Værdi
user-js-title = Indstillinger i user.js
user-js-description = Din profilmappe indeholder filen <a data-l10n-name="user-js-link">user.js</a>, som indeholder indstillinger, der ikke er oprettet af { -brand-short-name }.
locked-key-prefs-title = Vigtige låste indstillinger
locked-prefs-name = Navn
locked-prefs-value = Værdi
graphics-title = Grafik
graphics-features-title = Funktioner
graphics-diagnostics-title = Diagnostik
graphics-failure-log-title = Fejl-log
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Beslutnings-log
graphics-crash-guards-title = Funktioner deaktiveret af Crash guard
graphics-workarounds-title = Løsninger
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protokol for vinduer
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Skrivebordsmiljø
place-database-title = Databasen Places
place-database-integrity = Integritet
place-database-verify-integrity = Bekræft integritet
a11y-title = Tilgængelighed
a11y-activated = Aktiveret
a11y-force-disabled = Slå tilgængelighed fra
a11y-handler-used = Tilgængelig håndtering anvendt
a11y-instantiator = Tilgængelighed-instantiator
library-version-title = Biblioteksversioner
copy-text-to-clipboard-label = Kopier tekst til udklipsholderen
copy-raw-data-to-clipboard-label = Kopier rå data til udklipsholderen
sandbox-title = Sandbox
sandbox-sys-call-log-title = Afviste systemkald
sandbox-sys-call-index = #
sandbox-sys-call-age = Sekunder siden
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Procestype
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumenter
safe-mode-title = Prøv fejlsikret tilstand
restart-in-safe-mode-label = Genstart med tilføjelser deaktiveret…
troubleshoot-mode-title = Diagnosticer problemer
restart-in-troubleshoot-mode-label = Fejlsøgnings-tilstand…
clear-startup-cache-title = Prøv at rydde opstarts-cachen
clear-startup-cache-label = Ryd opstarts-cachen…
startup-cache-dialog-title = Ryd opstarts-cachen
startup-cache-dialog-body = Genstart { -brand-short-name } for at rydde opstarts-cachen. Dette ændrer hverken dine indstillinger eller fjerner tilføjelser, du har installeret i { -brand-short-name }.
startup-cache-dialog-title2 = Genstart { -brand-short-name } for at rydde opstarts-cachen?
startup-cache-dialog-body2 = Dette vil ikke ændre dine indstillinger eller fjerne dine udvidelser.
restart-button-label = Genstart

## Media titles

audio-backend = Audio-backend
max-audio-channels = Max antal kanaler
sample-rate = Foretrukken sample-rate
roundtrip-latency = Roundtrip-latens (standardafvigelse)
media-title = Medieindhold
media-output-devices-title = Output-enheder
media-input-devices-title = Input-enheder
media-device-name = Navn
media-device-group = Gruppe
media-device-vendor = Producent
media-device-state = Tilstand
media-device-preferred = Foretrukken
media-device-format = Format
media-device-channels = Kanaler
media-device-rate = Rate
media-device-latency = Latenstid
media-capabilities-title = Media-evner
# List all the entries of the database.
media-capabilities-enumerate = Vis database-poster

##

intl-title = Tilpasning til andre sprog og lande
intl-app-title = Indstillinger for applikation
intl-locales-requested = Forespurgte sprog
intl-locales-available = Tilgængelige sprog
intl-locales-supported = App-sprog
intl-locales-default = Standard-sprog
intl-os-title = Operativsystem
intl-os-prefs-system-locales = System-sprog
intl-regional-prefs = Regionale indstillinger

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Remote debugging (Chromium-protokol)
remote-debugging-accepting-connections = Accepterer forbindelser
remote-debugging-url = URL

##

support-third-party-modules-title = Tredjeparts-moduler
support-third-party-modules-module = Modulfil
support-third-party-modules-version = Filversion
support-third-party-modules-vendor = Information om leverandør
support-third-party-modules-occurrence = Forekomster
support-third-party-modules-process = Proces-type og -ID
support-third-party-modules-thread = Tråd
support-third-party-modules-base = Imagebase-adresse
support-third-party-modules-uptime = Oppetid for proces (ms)
support-third-party-modules-duration = Indlæsningstid (ms)
support-third-party-modules-status = Status
support-third-party-modules-status-loaded = Indlæst
support-third-party-modules-status-blocked = Blokeret
support-third-party-modules-status-redirected = Omdirigeret
support-third-party-modules-empty = Ingen tredjeparts-moduler blev indlæst.
support-third-party-modules-no-value = (Ingen værdi)
support-third-party-modules-button-open =
    .title = Åbn filplacering…
support-third-party-modules-expand =
    .title = Vis detaljeret information
support-third-party-modules-collapse =
    .title = Skjul detaljeret information
support-third-party-modules-unsigned-icon =
    .title = Dette modul er ikke signeret
support-third-party-modules-folder-icon =
    .title = Åbn filplacering…
support-third-party-modules-down-icon =
    .title = Vis detaljeret information
support-third-party-modules-up-icon =
    .title = Skjul detaljeret information
# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Fejlrapporter for det seneste døgn
       *[other] Fejlrapporter for de seneste { $days } døgn
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } minut siden
       *[other] { $minutes } minutter siden
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } time siden
       *[other] { $hours } timer siden
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } dag siden
       *[other] { $days } dage siden
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Alle fejlrapporter (inklusive { $reports } afventende fejl i den angivne tidsramme)
       *[other] Alle fejlrapporter (inklusive { $reports } afventende fejl i den angivne tidsramme)
    }
raw-data-copied = Rå data blev kopieret til udklipsholderen
text-copied = Tekst blev kopieret til udklipsholderen

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Ikke understøttet i denne grafik-driver-version.
blocked-gfx-card = Ikke understøttet i denne grafik-driver-version grundet uløste driver-forhold.
blocked-os-version = Ikke understøttet i denne version af dit operativsystem.
blocked-mismatched-version = Ikke understøttet af driveren til dit grafikkort på grund af en uoverensstemmelse mellem registret og DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Ikke understøttet i denne grafik-driver-version. Prøv at opgradere din grafik-driver til version { $driverVersion } eller nyere.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType parametre
compositing = Komposition
hardware-h264 = H264-afkodning i hardware
main-thread-no-omtc = main thread, ingen OMTC
yes = Ja
no = Nej
unknown = Ukendt
virtual-monitor-disp = Virtual Monitor Display

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Fundet
missing = Mangler
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Beskrivelse
gpu-vendor-id = Producent-ID
gpu-device-id = Enheds-ID
gpu-subsys-id = Subsys-ID
gpu-drivers = Drivere
gpu-ram = RAM
gpu-driver-vendor = Driver-producent
gpu-driver-version = Driver-version
gpu-driver-date = Driver-dato
gpu-active = Aktiv
webgl1-wsiinfo = WebGL 1 Driver WSI-info
webgl1-renderer = WebGL 1 Driver-rendering
webgl1-version = WebGL 1 Driver-version
webgl1-driver-extensions = WebGL 1 Driver-udvidelser
webgl1-extensions = WebGL 1-udvidelser
webgl2-wsiinfo = WebGL 2 Driver WSI-info
webgl2-renderer = WebGL2-rendering
webgl2-version = WebGL 2 Driver-version
webgl2-driver-extensions = WebGL 2 Driver-udvidelser
webgl2-extensions = WebGL 2-udvidelser
blocklisted-bug = Blokeret på grund af kendte problemer
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bug { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Blokeret på grund af kendte problemer: <a data-l10n-name="bug-link">bug { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Blokeret; fejlkode { $failureCode }
d3d11layers-crash-guard = D3D11-kompositoren
d3d11video-crash-guard = D3D11-videodekoder
d3d9video-crash-guard = D3D9-videodekoder
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX-videodekoder
reset-on-next-restart = Nulstil ved næste genstart
gpu-process-kill-button = Afslut GPU-process
gpu-device-reset = Device Reset
gpu-device-reset-button = Trigger Device Reset
uses-tiling = Anvender tiling
content-uses-tiling = Anvender tiling (indhold)
off-main-thread-paint-enabled = Rasteriser sider i særskilt proces
off-main-thread-paint-worker-count = Antal workers til rastering af sider i særskilt proces
target-frame-rate = Mål for framerate
min-lib-versions = Forventet minimumsversion
loaded-lib-versions = Version i brug
has-seccomp-bpf = Seccomp-BPF (filtrering af systemkald)
has-seccomp-tsync = Seccomp tråd-synkronisering
has-user-namespaces = Navneområder
has-privileged-user-namespaces = Navneområder for priviligerede processer
can-sandbox-content = Sandboxning indholdsprocesser
can-sandbox-media = Sandboxning af medie-plugin
content-sandbox-level = Content Process Sandbox Level
effective-content-sandbox-level = Effective Content Process Sandbox Level
sandbox-proc-type-content = indhold
sandbox-proc-type-file = fil-indhold
sandbox-proc-type-media-plugin = medie-plugin
sandbox-proc-type-data-decoder = data-decoder
startup-cache-title = Opstarts-cache
startup-cache-disk-cache-path = Sti til disk-cache
startup-cache-ignore-disk-cache = Ignorer disk-cache
startup-cache-found-disk-cache-on-init = Fandt disk-cache på Init
startup-cache-wrote-to-disk-cache = Skrev til disk-cache
launcher-process-status-0 = Aktiveret
launcher-process-status-1 = Deaktiveret på grund af en fejl
launcher-process-status-2 = Deaktiveret
launcher-process-status-unknown = Ukendt status
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Aktiveret af bruger
multi-process-status-1 = Aktiveret som standard
multi-process-status-2 = Deaktiveret
multi-process-status-4 = Deaktiveret af tilgængelighedsværktøjer
multi-process-status-6 = Deaktiveret på grund af ikke-understøttet indsætning af tekst
multi-process-status-7 = Deaktiveret af tilføjelser
multi-process-status-8 = Gennemtving deaktivering
multi-process-status-unknown = Ukendt status
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Deaktiveret af et eksperiment
fission-status-experiment-treatment = Aktiveret af et eksperiment
fission-status-disabled-by-e10s-env = Deaktiveret af miljøet
fission-status-enabled-by-env = Aktiveret af miljøet
fission-status-disabled-by-safe-mode = Deaktiveret af fejlsikker tilstand
fission-status-enabled-by-default = Aktiveret som standard
fission-status-disabled-by-default = Deaktiveret som standard
fission-status-enabled-by-user-pref = Aktiveret af bruger
fission-status-disabled-by-user-pref = Deaktiveret af bruger
fission-status-disabled-by-e10s-other = E10s deaktiveret
async-pan-zoom = Asynkron panorering/zoom
apz-none = ingen
wheel-enabled = input fra rullehjul
touch-enabled = input fra trykfølsom skærm
drag-enabled = træk i rullebjælke
keyboard-enabled = tastatur
autoscroll-enabled = autoscroll
zooming-enabled = smooth pinch-zoom

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = asynkront input fra rullehjul er deaktiveret på grund af en ikke understøttet indstilling: { $preferenceKey }
touch-warning = asynkront input fra trykfølsom skærm er deaktiveret på grund af en ikke understøttet indstilling: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inaktiv
policies-active = Aktiv
policies-error = Fejl

## Printing section

support-printing-title = Udskrivning
support-printing-troubleshoot = Fejlsøgning
support-printing-clear-settings-button = Ryd gemte indstillinger for udskrivning
support-printing-modified-settings = Ændrede indstillinger for udskrivning
support-printing-prefs-name = Navn
support-printing-prefs-value = Værdi

## Normandy sections

support-remote-experiments-title = Fjern-eksperimenter
support-remote-experiments-name = Navn
support-remote-experiments-branch = Eksperimental-gren
support-remote-experiments-see-about-studies = Få mere information på siden <a data-l10n-name="support-about-studies-link">about:studies</a>. Hér kan du fx læse om at slå specifikke eksperimenter fra eller om, hvordan du beder { -brand-short-name } om ikke at køre denne slags eksperimenter i fremtiden.
support-remote-features-title = Fjern-funktioner
support-remote-features-name = Navn
support-remote-features-status = Status
