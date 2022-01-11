# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Header for the list of Service Workers displayed in the application panel for the current page.
serviceworker-list-header = Service-Worker

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Service-Worker von anderen Domains sind über <a>about:debugging</a> verfügbar

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Abmelden

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Debuggen
    .title = Nur laufende Service-Worker können debuggt werden

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Untersuchen
    .title = Service-Worker können nur untersucht werden, wenn nicht mehr als ein 1 Prozess für Webinhalte existiert (kein multi-e10s).

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Starten
    .title = Service-Worker können nur untersucht werden, wenn nicht mehr als ein 1 Prozess für Webinhalte existiert (kein multi-e10s).

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Untersuchen

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Starten

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Aktualisiert <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Quelle

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Status

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Wird ausgeführt

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Angehalten

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Es muss ein Service-Worker angemeldet sein, um ihn hier zu untersuchen. <a>Weitere Informationen</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Falls die derzeitige Seite Service-Worker besitzen sollte, können Sie Folgendes versuchen:

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Überprüfen Sie die Konsole auf Fehler. <a>Konsole öffnen</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Gehen Sie die Service-Worker-Anmeldung durch und suchen Sie nach Ausnahmen. <a>Debugger öffnen</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Untersuchen Sie Service-Worker von anderen Domains. <a>about:debugging öffnen</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Keine Service-Worker gefunden

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Weitere Informationen

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Wenn die aktuelle Seite einen Service-Worker besitzen sollte, könnten Sie in der <a>Konsole</a> nach Fehlern suchen oder die Registrierung Ihres Service-Workers schrittweise im <span>Debugger</span> durchlaufen.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Service-Worker von anderen Domains ansehen

# Header for the Manifest page when we have an actual manifest
manifest-view-header = App-Manifest

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Sie müssen ein Web-App-Manifest hinzufügen, um es hier zu untersuchen. <a>Weitere Informationen</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Kein Web-App-Manifest erkannt

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Erfahren Sie, wie Sie ein Manifest hinzufügen

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Fehler und Warnungen

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identität

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Darstellung

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Symbole

# Text displayed while we are loading the manifest file
manifest-loading = Manifest wird geladen…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest geladen

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Beim Laden des Manifests trat ein Fehler auf:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox DevTools-Fehler

# Text displayed when the page has no manifest available
manifest-non-existing = Kein Manifest zum Untersuchen gefunden

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Das Manifest ist in eine Daten-URL eingebettet.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Zweck: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Symbol:

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Symbol mit Abmessungen: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Symbol ohne angegebene Abgemessungen

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifest-Symbol
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service-Worker
    .alt = Symbol für Service-Worker
    .title = Service-Worker

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Warnsymbol
    .title = Warnung

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Fehlersymbol
    .title = Fehler

