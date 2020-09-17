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
serviceworker-list-aboutdebugging = Iepenje <a>about:debugging</a> foar Service Workers fan oare domeinen
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Registraasje opheffe
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Debugge
    .title = Debugging is allinnich mooglik by aktive service workers
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Debugge
    .title = Service workers kinne allinnich debugd wurde as multi e10s útskeakele is
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Starte
    .title = Service workers kinne allinnich starte wurde as multi e10s útskeakele is.
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Ynspektearje
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Starte
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Bywurke: <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Boarne
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Steat

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Aktyf
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Stoppe
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Jo moatte in Service Worker registrearje om dizze hjir te ynspektearjen. <a>Mear ynfo</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = As de aktuele side in Service Worker hawwe moat, kinne jo it folgjende probearje
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Sykje nei flaters yn de Console. <a>De Console iepenje</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Stap tooch jo registraasje fan de Service Worker en sykje nei útsûnderingen. <a>De Debugger iepenje</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Ynspektearje Service Workers fan oare domeinen. <a>about:debugging iepenje</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Gjin service workers fûn
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Mear ynfo
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = As de aktuele side in service worker hawwe moatte soe, kinne jo flaters sykje yn de <a>Console</a> of de registraasje fan jo service workers trochrinne yn de <span>Debugger</span>.
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Service workers út oare domeinen besjen
# Header for the Manifest page when we have an actual manifest
manifest-view-header = App-manifest
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Jo moatte in webapp-manifest tafoegje om dit hjir te ynspektearjen. <a>Mear ynfo</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Gjin webapp-manifest detektearre
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Lear hoe't jo in manifest tafoegje
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Flaters en warskôgingen
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identiteit
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Presintaasje
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Piktogrammen
# Text displayed while we are loading the manifest file
manifest-loading = Manifest lade…
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest laden.
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Der is in flater bard by it laden fan it manifest:
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox Devtools-flater
# Text displayed when the page has no manifest available
manifest-non-existing = Gjin manifest fûn om te ynspektearjen.
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = It manifest is ynbed yn in gegevens-URL.
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Doel: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Piktogram
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Piktogram mei ôfmjittingen: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Piktogram fan net-spesifisearre ôfmjitting
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Piktogram Manifest
    .title = Manifest
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workers
    .alt = Piktogram Service Workers
    .title = Service Workers
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Warskôgingspiktogram
    .title = Warskôging
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Flaterpiktogram
    .title = Flater
