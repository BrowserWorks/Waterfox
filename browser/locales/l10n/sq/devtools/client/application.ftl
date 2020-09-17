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
serviceworker-list-aboutdebugging = Hapni <a>about:debugging</a> për Service Workers nga përkatësi të tjera

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Çregjistroje

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Diagnostikoje
    .title = Mund të diagnostikohen vetëm service workers në punë e sipër

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Diagnostikoje
    .title = Mund të diagnostikohen service workers vetëm nëse multi e10s është e çaktivizuar

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Fillo
    .title = Mund të nisen service workers vetëm nëse multi e10s është e çaktivizuar

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Shqyrtoje

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Nise

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Përditësuar më <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Burim

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Gjendje

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Në xhirim

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = I ndalur

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Që ta shqyrtoni këtu, lypset që një Service Worker ta regjistroni. <a>Mësoni më tepër</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Nëse faqja e tanishme duhet të ketë një service worker, ja disa gjëra që mund të provoni

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Shihni për gabime te Konsola. <a>Hapeni Konsolën</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Kaloni nëpër hapat e regjistrimit të Service Worker-it tuaj dhe shihni për përjashtime. <a>Hapni Diagnostikuesin</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Shqyrtoni Workers nga përkatësi të tjera. <a>Hapni about:debugging</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = S’u gjetën service workers

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Mësoni më tepër

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Nëse faqja e tanishme duhet të ketë një service worker, mund të shihni për gabime te <a>Konsola</a> ose të kaloni nëpër regjistrimin e service worker-it tuaj te <span>Diagnostikuesi</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Shihni service workers prej përkatësish të tjera

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifest Aplikacioni

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Lypset të shtoni një Manifest aplikacioni web që të këqyret këtu. <a>Mësoni më tepër</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = S’u pikas manifest aplikacioni web

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Mësoni si të shtoni një manifest

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Gabime dhe Sinjalizime

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitet

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Paraqitje

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Ikona

# Text displayed while we are loading the manifest file
manifest-loading = Po ngarkohet manifest…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifesti u ngarkua.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Pati një gabim gjatë ngarkimit të manifestit:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Gabim Firefox DevTools

# Text displayed when the page has no manifest available
manifest-non-existing = S’u gjet manifest për ta inspektuar.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifesti është trupëzuar në URL të Dhënash.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Qëllim: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ikonë

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Ikonë me madhësi: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Ikonë me madhësi të papërcaktuar

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Ikonë Manifesti
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workers
    .alt = Ikonë Service Workers
    .title = Service Workers

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Ikonë sinjalizimi
    .title = Sinjalizim

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Ikonë gabimi
    .title = Gabim

