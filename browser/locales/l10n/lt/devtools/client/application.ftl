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
serviceworker-list-header = Aptarnavimo scenarijai
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Atverkite <a>about:debugging</a>, norėdami pamatyti aptarnavimo scenarijus iš kitų domenų
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Išregistruoti
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Derinti
    .title = Derinami gali būti tik vykstantys aptarnavimo scenarijai
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Derinti
    .title = Aptarnavimo scenarijus galima derinti tik tada, kai yra išjungta „multi e10s“
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Paleisti
    .title = Aptarnavimo scenarijus galima paleisti tik tada, kai yra išjungta „multi e10s“
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Tirti
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Pradėti
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Atnaujinta <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Išteklius
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Būsena

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Vykdomas
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Sustabdytas
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Norėdami čia tirti aptarnavimo scenarijų, turite jį užregistruoti. <a>Sužinoti daugiau</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Jei esamas tinklalapis turėtų aptarnavimo scenarijų, štai keletas dalykų, kuriuos galite pabandyti
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Paieškokite klaidų pulte. <a>Atverti pultą</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Pažingsniuokite per savo aptarnavimo scenarijaus registraciją ir paieškokite išimčių. <a>Atverti derintuvę</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Tirkite aptarnavimo scenarijus iš kitų domenų. <a>Atverti about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Nerasta aptarnavimo scenarijų
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Sužinoti daugiau
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Jei dabartiniame tinklalapyje turėtų būtų aptarnavimo scenarijus, galite paieškoti klaidų <a>pulte</a>, arba pereiti per aptarnavimo scenarijaus registraciją <span>derintuvėje</span>.
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Peržiūrėti aptarnavimo scenarijus iš kitų domenų
# Header for the Manifest page when we have an actual manifest
manifest-view-header = Programos manifestas
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Norėdami čia tirti internetinės programos manifestą, turite jį pridėti. <a>Sužinoti daugiau</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Neaptiktas joks internetinės programos manifestas
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Sužinokite, kaip pridėti manifestą
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Klaidos ir įspėjimai
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Tapatumo duomenys
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Pateiktis
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Piktogramos
# Text displayed while we are loading the manifest file
manifest-loading = Įkeliamas manifestas…
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifestas įkeltas.
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Įkeliant manifestą įvyko klaida:
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = „Firefox“ kūrėjų priemonių klaida
# Text displayed when the page has no manifest available
manifest-non-existing = Nerastas joks manifestas.
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifestas yra įterptas į Data URL.
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Paskirtis: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Piktograma
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Piktograma su dydžiais: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Nenurodyto dydžio piktograma
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifestas
    .alt = Manifesto piktograma
    .title = Manifestas
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Aptarnavimo scenarijai
    .alt = Aptarnavimo scenarijų piktograma
    .title = Aptarnavimo scenarijai
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Įspėjimo piktograma
    .title = Įspėjimas
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Klaidos piktograma
    .title = Klaida
