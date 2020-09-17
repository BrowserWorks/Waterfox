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
serviceworker-list-header = Service Workers

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = <a>about:debugging</a> za service workers wot druhich domenow wočinić

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Registrowanje skónčić

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Za zmylkami pytać
    .title = Jenož běžne service workers dadźa so za zmylkami přepytać

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Za zmylkami pytać
    .title = Móže jenož service workers za zmylkami přepytować, jeli multiprocesowy e10s je znjemóžnjeny

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Startować
    .title = Móže jenož service workers startować, jeli multiporcesowy e10s je znjemóžnjeny

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Přepytować

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Start

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time> zaktualizowany

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Žórło

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Status

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Běžace

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Zastajeny

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Dyrbiće service worker registrować, zo byšće jón tu přepytował. <a>Dalše informacije</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Jeli aktualna strona ma service worker, móžeće tole spytać

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = W konsoli za zmylkami pytać. <a>Konsolu wočinić</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Přehladujće swoju registrowanje service worker a pytajće za wuwzaćemi. <a>Pytanje za zmylkami wočinić</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Přepytujće service workers wot druhich domenow. <a>about:debugging wočinić</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Žadyn service worker namakany.

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Dalše informacije

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Hdy by aktualna strona service worker měła, móhł wy w <a>konsoli</a> za zmylkami pytać abo registraciju swojeho service worker w <span>pytanju za zmylkami</span> přeběžeć.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Service worker z druhich domenow pokazać

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifest nałoženja

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Dyrbiće manifest webnałoženja přidać, zo byšće jón tu přepruwował. <a>Dalše informacije</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Žadyn manifest webnałoženja namakany

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Zhońće, kak móžeće manifest přidać

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Zmylki a warnowanja

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identita

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Prezentacija

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Symbole

# Text displayed while we are loading the manifest file
manifest-loading = Manifest so čita…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest je so začitał.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Při čitanju manifesta je zmylk nastał.

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Zmylk wuwiwarskch nastrojow Firefox

# Text displayed when the page has no manifest available
manifest-non-existing = Žadyn manifest namakany.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifest je zasadźeny w DATA URL.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Zaměr: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Symbol

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Symbole z wulkosćemi: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Symbol z njepodatej wulkosću

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifestowy symbol
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workers
    .alt = Symbol Service Workers
    .title = Service Workers

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Warnowanski symbol
    .title = Warnowanje

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Zmylkowy symbol
    .title = Zmylk

