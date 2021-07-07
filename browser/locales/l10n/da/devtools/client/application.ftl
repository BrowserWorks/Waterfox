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
serviceworker-list-header = Service-workers
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Åbn <a>about:debugging</a> for at se service-workers fra andre domæner
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Afregistrer
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Debug
    .title = Kun kørende service-workers kan debugges
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Debug
    .title = Kan kun debugge service-workers, hvis multi-e10s er deaktiveret
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Start
    .title = Kan kun starte service-workers, hvis multi-e10s er deaktiveret
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Inspicer
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Start
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Opdateret <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Kilde
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Status

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Kører
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Stoppet
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Du skal registrere en service-worker for at kunne inspicere den her. <a>Læs mere</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Hvis den nuværende side burde have en service-worker, kan du prøve at:
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Kigge efter fejl i konsollen. <a>Åbn konsollen</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Gennemgå  registreringen for din service-worker og kig efter undtagelser. <a>Åbn debugger</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Inspicere service-workers fra andre domæner. <a>Åbn about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Ingen service-workers fundet
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Læs mere
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Hvis den nuværende side burde have en service-worker, så kan du lede efter fejl i <a>konsollen</a> og gå igennem registrering af din service-worker i <span>Debugger</span>.
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Vis service-workers fra andre domæner
# Header for the Manifest page when we have an actual manifest
manifest-view-header = App-manifest
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Du skal tilføje et app-manifest for at kunne inspicere det her. <a>Læs mere</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Intet web app-manifest blev fundet
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Lær, hvordan du tilføjer et manifest
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Fejl og advarsler
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitet
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Præsentation
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Ikoner
# Text displayed while we are loading the manifest file
manifest-loading = Indlæser manifest…
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest indlæst.
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Der opstod en fejl under indlæsning af manifestet:
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Der opstod en fejl i udviklerværktøjerne i Firefox
# Text displayed when the page has no manifest available
manifest-non-existing = Der blev ikke fundet noget manifest at inspicere.
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifestet er indlejret i en data-URL.
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Formål: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ikon
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Ikon med størrelserne: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Uspecificeret størrelse for ikon
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifest-ikon
    .title = Manifest
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service-workers
    .alt = Service-workers-ikon
    .title = Service-workers
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Advarsels-ikon
    .title = Advarsel
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Fejl-ikon
    .title = Fejl
