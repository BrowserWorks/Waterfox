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
serviceworker-list-header = Service Workerek

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Nyissa meg az <a>about:debugging</a> oldalt a más tartományokból származó Service Workerek megjelenítéséhez

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Regisztráció törlése

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Hibakeresés
    .title = Csak a futó service workerekben lehet hibát keresni

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Hibakeresés
    .title = A service workerekben csak akkor lehet hibát keresni, ha a többszálas e10s ki van kapcsolva

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Indítás
    .title = A service workerek csak akkor indíthatóak el, ha a többszálas e10s ki van kapcsolva

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Vizsgálat

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Indítás

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Frissítve: <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Forrás

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Állapot

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Fut

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Leállítva

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Regisztrálnia kell a Service Workert, hogy itt vizsgálhassa. <a>További tudnivalók</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Ha a jelenlegi oldalon lennie kellene egy service workernek, akkor itt van néhány dolog amit megpróbálhat

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Keressen hibát a konzolban. <a>Nyissa meg a konzolt</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Lépjen végig a Service Worker regisztráción, és keressen kivételeket. <a>Nyissa meg a hibakeresőt</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Vizsgálja meg a más tartományokból származó Service Workereket. <a>Nyissa meg az about:debugging oldalt</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Nem található service worker.

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = További tudnivalók

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Ha a jelenlegi oldalon kellene server workernek lennie, akkor keressen hibákat a <a>Konzolban</a> vagy lépkedjen végig a server worker regisztrációján a <span>Hibakeresőben</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Más domainről származó service workerek megtekintése

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Alkalmazás-jegyzékfájl

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Meg kell adnia egy webalkalmazás jegyzékfájlt, hogy itt vizsgálhassa. <a>További tudnivalók</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Nem található webalkalmazás-leíró

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Tudja meg, hogyan adjon hozzá leírófájlt

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Hibák és figyelmeztetések

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Felhasználó

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Megjelenítés

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Ikonok

# Text displayed while we are loading the manifest file
manifest-loading = Jegyzékfájl betöltése…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Jegyzékfájl betöltve.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Hiba történt a jegyzékfájl betöltésekor:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox fejlesztői eszközök hiba

# Text displayed when the page has no manifest available
manifest-non-existing = Nem található vizsgálható jegyzékfájl.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = A jegyzékfájl az adat URL-be van ágyazva.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Cél: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ikon

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Ilyen méretű ikon: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Meghatározatlan méretű ikon

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Jegyzékfájl
    .alt = Jegyzékfájl ikon
    .title = Jegyzékfájl

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workerek
    .alt = Service Workerek ikon
    .title = Service Workerek

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Figyelmeztetés ikon
    .title = Figyelmeztetés

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Hiba ikon
    .title = Hiba

