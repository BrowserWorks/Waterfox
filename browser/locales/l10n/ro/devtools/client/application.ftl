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
serviceworker-list-header = Scripturi Service Worker
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Deschide <a>about:debugging</a> pentru scripturile Service Worker de pe alte domenii
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Dezînregistrează
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Depanează
    .title = Numai scripturile service worker în curs de rulare pot fi depanate
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Depanare
    .title = Poți depana service workeri numai dacă multi e10s este dezactivat
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Start
    .title = Poți porni service workeri numai dacă multi e10s este dezactivat
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Inspectează
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Pornește
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Actualizat <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Sursa
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Stare

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = În execuție
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Oprit
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Trebuie să înregistrezi un Service Worker pentru a-l inspecta aici. <a>Află mai multe</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Dacă pagina actuală ar trebui să aibă un service worker, iată câteva lucruri pe care le poți încerca
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Caută erori în consolă. <a>Deschide consola</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Execută pas cu pas înregistrarea scripturilor Service Worker și caută excepții. <a>Deschide depanatorul</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Inspectează scripturile Service Worker de pe alte domenii. <a>Deschide about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Nu a fost găsit niciun script service worker
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Află mai multe
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Dacă pagina curentă ar trebui să aibă un script service worker, poți căuta erori în <a>Consolă</a>sau poți parcurge înregistrarea scriptului service worker în <span>Depanator</span>.
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Afișează scripturi service worker din alte domenii
# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifestul aplicației
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Trebuie să adaugi un manifest de aplicație web pentru a-l inspecta aici. <a>Află mai multe</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Nu a fost depistat niciun manifest de aplicație web
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Află cum poți adăuga un manifest
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Erori și avertismente
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitate
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Prezentare
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Pictograme
# Text displayed while we are loading the manifest file
manifest-loading = Se încarcă manifestul...
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest încărcat.
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = A apărut o eroare la încărcarea manifestului:
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Eroare Firefox DevTools
# Text displayed when the page has no manifest available
manifest-non-existing = Nu s-a găsit niciun manifest de inspectat.
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifestul este înglobat într-un URL de date.
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Scop: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Pictogramă
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Pictogramă cu mărimi: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Pictogramă de mărime nespecificată
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Pictogramă manifest
    .title = Manifest
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Scripturi Service Worker
    .alt = Pictogramă scripturi Service Worker
    .title = Scripturi Service Worker
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Pictogramă de avertizare
    .title = Avertisment
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Pictogramă de eroare
    .title = Eroare
