# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Profiler-Einstellungen
perftools-intro-description =
    Aufnahmen öffnen profiler.firefox.com in einem neuen Tab. Alle Daten werden lokal 
    gespeichert, können aber zum Teilen hochgeladen werden.

## All of the headings for the various sections.

perftools-heading-settings = Komplette Einstellungen
perftools-heading-buffer = Puffer-Einstellungen
perftools-heading-features = Funktionen
perftools-heading-features-default = Funktionen (standardmäßig empfohlen)
perftools-heading-features-disabled = Deaktivierte Funktionen
perftools-heading-features-experimental = Experimentell
perftools-heading-threads = Threads
perftools-heading-threads-jvm = JVM-Threads
perftools-heading-local-build = Lokaler Build

##

perftools-description-intro = Aufnahmen öffnen <a>profiler.firefox.com</a> in einem neuen Tab. Alle Daten werden lokal gespeichert, können aber zum Teilen hochgeladen werden.
perftools-description-local-build =
    Wenn Sie einen auf diesem Computer selbst kompilierten Build untersuchen,
    fügen Sie bitte das objdir des Build zur folgenden Liste hinzu, sodass es
    genutzt werden kann, um Symbolinformationen nachzuschlagen.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Abtastintervall:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Puffergröße:
perftools-custom-threads-label = Benutzerdefinierte Threads nach Namen hinzufügen:
perftools-devtools-interval-label = Intervall:
perftools-devtools-threads-label = Threads:
perftools-devtools-settings-label = Einstellungen

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = Die Aufnahme wurde von einem anderen Werkzeug gestoppt.
perftools-status-restart-required = Der Browser muss neu gestartet werden, um diese Funktion zu aktivieren.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Aufnahme wird gestoppt
perftools-request-to-get-profile-and-stop-profiler = Profil wird gespeichert

##

perftools-button-start-recording = Aufnahme starten
perftools-button-capture-recording = Aufnahme speichern
perftools-button-cancel-recording = Aufnahme abbrechen
perftools-button-save-settings = Einstellungen speichern und zurückgehen
perftools-button-restart = Neu starten
perftools-button-add-directory = Ordner hinzufügen
perftools-button-remove-directory = Ausgewählten Ordner entfernen
perftools-button-edit-settings = Einstellungen bearbeiten…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Die Hauptprozesse sowohl für den übergeordneten Prozess als auch für die Inhaltsprozesse
perftools-thread-compositor =
    .title = Kombiniert verschiedene gezeichnete Elemente auf der Seite
perftools-thread-dom-worker =
    .title = Verantwortlich für Web-Worker und Service-Worker
perftools-thread-renderer =
    .title = Bei aktivem WebRender führt dieser Thread OpenGL aus.
perftools-thread-render-backend =
    .title = Der WebRender-RenderBackend-Thread
perftools-thread-paint-worker =
    .title = Wenn Zeichnen außerhalb des Hauptthreads aktiviert ist, wird mit diesem Thread gezeichnet.
perftools-thread-timer =
    .title = Die Thread-Handling-Timer (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = Stilberechnung ist auf mehrere Threads aufgeteilt
pref-thread-stream-trans =
    .title = Netzwerk-Stream-Transport
perftools-thread-socket-thread =
    .title = Der Thread, in dem der Netzwerkcode blockierende Socket-Aufrufe ausführt
perftools-thread-img-decoder =
    .title = Bilddekodierungsthreads
perftools-thread-dns-resolver =
    .title = DNS-Auflösung erfolgt in diesem Thread
perftools-thread-task-controller =
    .title = TaskController-Thread-Pool-Threads
perftools-thread-jvm-gecko =
    .title = Der Haupt-Gecko-JVM-Thread
perftools-thread-jvm-nimbus =
    .title = Die Haupt-Threads für das Nimbus Experiments SDK
perftools-thread-jvm-default-dispatcher =
    .title = Der Standard-Dispatcher für die Kotlin-Coroutinen-Bibliothek
perftools-thread-jvm-glean =
    .title = Die Haupt-Threads für das Glean-Telemetrie-SDK
perftools-thread-jvm-arch-disk-io =
    .title = Der IO-Dispatcher für die Kotlin-Coroutinen-Bibliothek
perftools-thread-jvm-pool =
    .title = Threads, die in einem unbenannten Thread-Pool erstellt wurden

##

perftools-record-all-registered-threads = Thread-Auswahl ignorieren und alle registrierten Threads aufnehmen
perftools-tools-threads-input-label =
    .title = Diese Thread-Namen sind durch Kommas getrennte Listen, mit denen das Profiling der Threads im Profiler aktiviert wird. Der Name muss nur teilweise mit dem einzuschließenden Thread-Namen übereinstimmen. Leerraum wird beachtet.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>Neu</b>: { -profiler-brand-name } ist jetzt in die Entwicklerwerkzeuge integriert. <a>Erfahren Sie mehr</a> über dieses leistungsstarke neue Werkzeug.
perftools-onboarding-close-button =
    .aria-label = Diese Änderungsmitteilung schließen

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Web-Entwickler
perftools-presets-web-developer-description = Empfohlene Voreinstellung für das Debuggen der meisten Web-Apps mit geringem Overhead.
perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description = Empfohlene Voreinstellung für die Leistungsanalyse von { -brand-shorter-name }.
perftools-presets-graphics-label = Grafik
perftools-presets-graphics-description = Voreinstellung zur Untersuchung von Grafikproblemen in { -brand-shorter-name }.
perftools-presets-media-label = Medien
perftools-presets-media-description2 = Voreinstellung für die Untersuchung von Audio- und Videoproblemen in { -brand-shorter-name }.
perftools-presets-networking-label = Netzwerkverbindungen
perftools-presets-networking-description = Voreinstellung für die Untersuchung von Problemen mit Netzwerkverbindungen in { -brand-shorter-name }.
# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = Leistung
perftools-presets-power-description = Voreinstellung für die Untersuchung von Problemen beim Energieverbrauch in { -brand-shorter-name }, mit geringem Overhead.
perftools-presets-custom-label = Benutzerdefiniert

##

