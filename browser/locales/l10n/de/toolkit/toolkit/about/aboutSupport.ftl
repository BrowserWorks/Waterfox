# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informationen zur Fehlerbehebung
page-subtitle =
    Diese Seite enthält technische Informationen, die nützlich sein könnten,
    wenn Sie versuchen, ein Problem zu lösen. Wenn Sie nach Antworten auf häufig
    gestellte Fragen zu { -brand-short-name } suchen, besuchen Sie bitte unsere  <a data-l10n-name="support-link">Hilfeseite</a>.

crashes-title = Absturzberichte
crashes-id = Meldungs-ID
crashes-send-date = Gesendet
crashes-all-reports = Alle Absturzberichte
crashes-no-config = Diese Anwendung wurde nicht für die Anzeige von Absturzberichten konfiguriert.
support-addons-title = Add-ons
support-addons-name = Name
support-addons-type = Typ
support-addons-enabled = Aktiviert
support-addons-version = Version
support-addons-id = ID
security-software-title = Sicherheitssoftware
security-software-type = Typ
security-software-name = Name
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = { -brand-short-name }-Funktionen
features-name = Name
features-version = Version
features-id = ID
processes-title = Externe Prozesse
processes-type = Typ
processes-count = Anzahl
app-basics-title = Allgemeine Informationen
app-basics-name = Name
app-basics-version = Version
app-basics-build-id = Build-ID
app-basics-distribution-id = Distributions-ID
app-basics-update-channel = Update-Kanal
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Update-Verzeichnis
       *[other] Update-Ordner
    }
app-basics-update-history = Update-Chronik
app-basics-show-update-history = Update-Chronik anzeigen
# Represents the path to the binary used to start the application.
app-basics-binary = Anwendungsprogrammdatei
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profilverzeichnis
       *[other] Profilordner
    }
app-basics-enabled-plugins = Aktivierte Plugins
app-basics-build-config = Build-Konfiguration
app-basics-user-agent = User-Agent
app-basics-os = Betriebssystem
app-basics-os-theme = Betriebssystem-Theme
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Rosetta-übersetzt
app-basics-memory-use = Speicherverwendung
app-basics-performance = Leistung
app-basics-service-workers = Angemeldete Service-Worker
app-basics-third-party = Module von Drittanbietern
app-basics-profiles = Profile
app-basics-launcher-process-status = Starter-Prozess
app-basics-multi-process-support = Fenster mit mehreren Prozessen
app-basics-fission-support = Fission-Fenster
app-basics-remote-processes-count = Externe Prozesse
app-basics-enterprise-policies = Unternehmensrichtlinien
app-basics-location-service-key-google = Google-Location-Service-Schlüssel
app-basics-safebrowsing-key-google = Google-Safebrowsing-Schlüssel
app-basics-key-mozilla = Waterfox-Location-Service-Schlüssel
app-basics-safe-mode = Abgesicherter Modus
show-dir-label =
    { PLATFORM() ->
        [macos] Im Finder anzeigen
        [windows] Ordner öffnen
       *[other] Ordner öffnen
    }
environment-variables-title = Umgebungsvariablen
environment-variables-name = Name
environment-variables-value = Wert
experimental-features-title = Experimentelle Funktionen
experimental-features-name = Name
experimental-features-value = Wert
modified-key-prefs-title = Wichtige modifizierte Einstellungen
modified-prefs-name = Name
modified-prefs-value = Wert
user-js-title = user.js-Einstellungen
user-js-description = Der Profilordner besitzt eine <a data-l10n-name="user-js-link">user.js-Datei</a>, welche Einstellungen enthält, die nicht von { -brand-short-name } erstellt wurden.
locked-key-prefs-title = Wichtige nicht veränderbare Einstellungen
locked-prefs-name = Name
locked-prefs-value = Wert
graphics-title = Grafik
graphics-features-title = Allgemeine Merkmale
graphics-diagnostics-title = Weitere Informationen
graphics-failure-log-title = Fehlerprotokoll
graphics-gpu1-title = GPU 1
graphics-gpu2-title = GPU 2
graphics-decision-log-title = Entscheidungsprotokoll
graphics-crash-guards-title = Absturzverhinderer hat Funktionen deaktiviert
graphics-workarounds-title = Lösungen
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Window-Protokoll
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Desktop-Umgebung
place-database-title = Chronik- und Lesezeichendatenbank
place-database-integrity = Integrität
place-database-verify-integrity = Integrität überprüfen
a11y-title = Barrierefreiheit
a11y-activated = Aktiviert
a11y-force-disabled = Barrierefreiheit verhindern
a11y-handler-used = Accessible Handler verwendet
a11y-instantiator = Dienst für Barrierefreiheit aufgerufen durch
library-version-title = Bibliotheken-Versionen
copy-text-to-clipboard-label = Text in die Zwischenablage kopieren
copy-raw-data-to-clipboard-label = Rohdaten in die Zwischenablage kopieren
sandbox-title = Isolierte Umgebungen
sandbox-sys-call-log-title = Abgewiesene Systemaufrufe
sandbox-sys-call-index = #
sandbox-sys-call-age = Vor … Sekunden
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Prozesstyp
sandbox-sys-call-number = Systemaufruf
sandbox-sys-call-args = Parameter
troubleshoot-mode-title = Probleme analysieren
restart-in-troubleshoot-mode-label = Fehlerbehebungsmodus…
clear-startup-cache-title = Versuchen Sie, den Start-Cache zu löschen
clear-startup-cache-label = Start-Cache löschen…
startup-cache-dialog-title2 = { -brand-short-name } neu starten, um den Start-Cache zu löschen?
startup-cache-dialog-body2 = Dadurch werden keine Einstellungen geändert oder Erweiterungen entfernt.
restart-button-label = Neu starten

## Media titles

audio-backend = Audio-Backend
max-audio-channels = Max. Kanäle
sample-rate = Bevorzugte Sample-Rate
roundtrip-latency = Roundtrip-Latenz (Standardabweichung)
media-title = Medien
media-output-devices-title = Ausgabegeräte
media-input-devices-title = Eingabegeräte
media-device-name = Name
media-device-group = Gruppe
media-device-vendor = Hersteller
media-device-state = Status
media-device-preferred = Bevorzugt
media-device-format = Format
media-device-channels = Kanäle
media-device-rate = Rate
media-device-latency = Latenz
media-capabilities-title = Leistungsmerkmale für Medien (Media Capabilities)
# List all the entries of the database.
media-capabilities-enumerate = Datenbankeinträge auflisten

##

intl-title = Internationalisierung & Lokalisierung
intl-app-title = Anwendungseinstellungen
intl-locales-requested = Angeforderte Sprachen
intl-locales-available = Verfügbare Sprachen
intl-locales-supported = Anwendungssprachen
intl-locales-default = Standardsprache
intl-os-title = Betriebssystem
intl-os-prefs-system-locales = Sprachen des Betriebssystems
intl-regional-prefs = Region-Einstellungen

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Externes Debugging (Chromium-Protokoll)
remote-debugging-accepting-connections = Verbindungen werden akzeptiert
remote-debugging-url = Adresse

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Absturzberichte des letzten Tages
       *[other] Absturzberichte der letzten { $days } Tage
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] vor { $minutes } Minute
       *[other] vor { $minutes } Minuten
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] vor { $hours } Stunde
       *[other] vor { $hours } Stunden
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] vor { $days } Tag
       *[other] vor { $days } Tagen
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Alle Absturzberichte (einschließlich { $reports } nicht abgesendeter Absturzbericht in dieser Zeitspanne)
       *[other] Alle Absturzberichte (einschließlich { $reports } nicht abgesendeter Absturzberichte in dieser Zeitspanne)
    }

raw-data-copied = Rohdaten in die Zwischenablage kopiert
text-copied = Text in die Zwischenablage kopiert

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Wurde auf Grund Ihrer Grafiktreiberversion blockiert.
blocked-gfx-card = Wurde auf Grund Ihrer Grafikkarte blockiert, da ungelöste Treiberprobleme bestehen.
blocked-os-version = Wurde auf Grund Ihrer Betriebssystemversion blockiert.
blocked-mismatched-version = Wurde auf Grund unterschiedlicher Grafiktreiberversionen in der Registrierung und der DLL-Datei blockiert.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Wurde auf Grund Ihrer Grafiktreiberversion blockiert. Versuchen Sie, Ihren Grafiktreiber auf mindestens Version { $driverVersion } zu aktualisieren.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType-Parameter

compositing = Compositing
hardware-h264 = H264-Dekodierung durch Hardware
main-thread-no-omtc = Haupt-Thread, kein OMTC
yes = Ja
no = Nein
unknown = Unbekannt
virtual-monitor-disp = Virtueller Bildschirm

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Gefunden
missing = Fehlt

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Beschreibung
gpu-vendor-id = Herstellerkennung
gpu-device-id = Gerätekennung
gpu-subsys-id = Subsys-ID
gpu-drivers = Treiber
gpu-ram = RAM
gpu-driver-vendor = Treiber-Hersteller
gpu-driver-version = Treiber-Version
gpu-driver-date = Treiber-Datum
gpu-active = Aktiv
webgl1-wsiinfo = WebGL-1-Treiber: WSI Info
webgl1-renderer = WebGL-1-Treiber: Renderer
webgl1-version = WebGL-1-Treiber: Version
webgl1-driver-extensions = WebGL-1-Treiber: Erweiterungen
webgl1-extensions = WebGL-1-Erweiterungen
webgl2-wsiinfo = WebGL-2-Treiber: WSI Info
webgl2-renderer = WebGL-2-Treiber: Renderer
webgl2-version = WebGL-2-Treiber: Version
webgl2-driver-extensions = WebGL-2-Treiber: Erweiterungen
webgl2-extensions = WebGL-2-Erweiterungen

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Aufgrund bekannter Probleme blockiert: <a data-l10n-name="bug-link">Bug { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Blockiert; Fehlercode { $failureCode }

d3d11layers-crash-guard = D3D11-Compositor
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF-VPX-Videodekoder

reset-on-next-restart = Bei nächstem Neustart zurücksetzen
gpu-process-kill-button = GPU-Prozess beenden
gpu-device-reset = Gerät zurücksetzen
gpu-device-reset-button = Gerät zurücksetzen
uses-tiling = Verwendet Kacheln
content-uses-tiling = Verwendent Kacheln für Inhalt
off-main-thread-paint-enabled = Zeichnen auf Nebenthread aktiviert
off-main-thread-paint-worker-count = Anzahl Worker für Zeichnen auf Nebenthread
target-frame-rate = Anvisierte Bildwiederholfrequenz (Framerate)

min-lib-versions = Minimal vorausgesetzte Version
loaded-lib-versions = Verwendete Version

has-seccomp-bpf = Seccomp-BPF (Filtern von Systemaufrufen)
has-seccomp-tsync = Seccomp-Thread-Synchronisierung
has-user-namespaces = User-Namespaces
has-privileged-user-namespaces = User-Namespaces für privilegierte Prozesse
can-sandbox-content = Inhaltsprozesse in isolierter Umgebung
can-sandbox-media = Medienplugins in isolierter Umgebung
content-sandbox-level = Ebene der isolierten Umgebung des Inhaltsprozesses
effective-content-sandbox-level = Effektive Ebene der isolierten Umgebung
content-win32k-lockdown-state = Status der Win32k-Sperre für den Inhaltsprozess
sandbox-proc-type-content = Inhalt
sandbox-proc-type-file = Dateiinhalt
sandbox-proc-type-media-plugin = Medienplugin
sandbox-proc-type-data-decoder = Datendekoder

startup-cache-title = Start-Cache
startup-cache-disk-cache-path = Festplatten-Cache-Ordner
startup-cache-ignore-disk-cache = Festplatten-Cache ignorieren
startup-cache-found-disk-cache-on-init = Festplatten-Cache bei Initialisierung erkannt
startup-cache-wrote-to-disk-cache = In Festplatten-Cache geschrieben

launcher-process-status-0 = Aktiviert
launcher-process-status-1 = Deaktiviert nach Fehler
launcher-process-status-2 = Deaktivierung erzwungen
launcher-process-status-unknown = Unbekannter Status

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Durch Experiment deaktiviert
fission-status-experiment-treatment = Durch Experiment aktiviert
fission-status-disabled-by-e10s-env = Durch Umgebung deaktiviert
fission-status-enabled-by-env = Durch Umgebung aktiviert
fission-status-disabled-by-safe-mode = Durch Abgesicherten Modus deaktiviert
fission-status-enabled-by-default = Standardmäßig aktiviert
fission-status-disabled-by-default = Standardmäßig deaktiviert
fission-status-enabled-by-user-pref = Vom Benutzer aktiviert
fission-status-disabled-by-user-pref = Vom Benutzer deaktiviert
fission-status-disabled-by-e10s-other = E10s deaktiviert
fission-status-enabled-by-rollout = Aktiviert durch stufenweise Einführung

async-pan-zoom = Asynchrones Wischen und Zoomen
apz-none = nichts
wheel-enabled = Mausrad-Eingabe aktiviert
touch-enabled = Berührungs-Eingabe aktiviert
drag-enabled = Ziehen der Bildlaufleiste aktiviert
keyboard-enabled = Tastatur aktiviert
autoscroll-enabled = automatischer Bildlauf aktiviert
zooming-enabled = sanftes Zoomen durch Antippen aktiviert

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = Asynchone Mausrad-Eingabe deaktiviert auf Grund nicht unterstützter Einstellung: { $preferenceKey }
touch-warning = Asynchrone Berührungs-Eingabe deaktiviert auf Grund nicht unterstützter Einstellung: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inaktiv
policies-active = Aktiv
policies-error = Fehler

## Printing section

support-printing-title = Drucken
support-printing-troubleshoot = Fehlerbehebung
support-printing-clear-settings-button = Gespeicherte Druckeinstellungen löschen
support-printing-modified-settings = Angepasste Druckeinstellungen
support-printing-prefs-name = Name
support-printing-prefs-value = Wert

## Normandy sections

support-remote-experiments-title = Externe Experimente
support-remote-experiments-name = Name
support-remote-experiments-branch = Experiment-Zweig
support-remote-experiments-see-about-studies = Weitere Informationen erhalten Sie unter <a data-l10n-name="support-about-studies-link">about:studies</a> einschließlich der Möglichkeit, einzelne Experimente zu deaktivieren oder { -brand-short-name } daran zu hindern, diese Art von Experiment in Zukunft durchzuführen.

support-remote-features-title = Externe Funktionen
support-remote-features-name = Name
support-remote-features-status = Status
