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

perftools-status-private-browsing-notice =
    Der Profiler wird deaktivert, sobald der private Modus aktiviert ist.
    Schließen Sie alle privaten Fenster, um den Profiler wieder zu aktivieren.
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

##

perftools-record-all-registered-threads = Thread-Auswahl ignorieren und alle registrierten Threads aufnehmen
perftools-tools-threads-input-label =
    .title = Diese Thread-Namen sind durch Kommas getrennte Listen, mit denen das Profiling der Threads im Profiler aktiviert wird. Der Name muss nur teilweise mit dem einzuschließenden Thread-Namen übereinstimmen. Leerraum wird beachtet.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

perftools-onboarding-message = <b>Neu</b>: { -profiler-brand-name } ist jetzt in die Entwicklerwerkzeuge integriert. <a>Erfahren Sie mehr</a> über dieses leistungsstarke neue Werkzeug.
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (Für eine begrenzte Zeit können Sie über <a>{ options-context-advanced-settings }</a> auf die ursprüngliche Ansicht für Leistungsanalyse zugreifen.)
perftools-onboarding-close-button =
    .aria-label = Diese Änderungsmitteilung schließen

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Web-Entwickler
perftools-presets-web-developer-description = Empfohlene Voreinstellung für das Debuggen der meisten Web-Apps mit geringem Overhead.
perftools-presets-firefox-platform-label = Waterfox-Plattform
perftools-presets-firefox-platform-description = Empfohlene Voreinstellung für das interne Debugging der Waterfox-Plattform.
perftools-presets-firefox-front-end-label = Waterfox-Frontend
perftools-presets-firefox-front-end-description = Empfohlene Voreinstellung für das interne Debugging des Waterfox-Frontend.
perftools-presets-firefox-graphics-label = Waterfox-Grafik
perftools-presets-firefox-graphics-description = Empfohlene Voreinstellung für das Untersuchen der Grafikleistung von Waterfox.
perftools-presets-media-label = Medien
perftools-presets-media-description = Empfohlene Voreinstellung zur Diagnose von Audio- und Videoproblemen.
perftools-presets-custom-label = Benutzerdefiniert

##

