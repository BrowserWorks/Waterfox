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
serviceworker-list-header = Mba’apohára oporopytyvõva

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Embojuruja <a>about:debugging</a> Service Workers peg̃uarã ha ambue mba’etépe avei

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Eipe’a mboheraguapy

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Mopotĩ
    .title = Mba’apohára oporopytyvõva añoite ikatu oñemopotĩ

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Mopotĩ
    .title = Ndaikatúi emopotĩ service workers ha’eñóramo multi e10s

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Ñepyrũ
    .title = Ndaikatúi emopitĩ service workers ha'eñóramo multi e10s

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Ma’ẽag̃ui

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Eñepyrũ

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Hekopyahupyre <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Teñoiha

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Tekotee

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Hembiapohína

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Pytapyre

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Eikotevẽ emboheraguapy Service Worker ehechajey hag̃ua ko’ápe. <a>Kuaave</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Ko kuatiarogue ag̃agua oguerekótarõ service worker, ko’ápe oĩ heta mba’e ikatúva ejapo

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Eheka jejavy mba’e’okarupápe. <a>Embojuruja mba’e’okarupa</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Ehecha service worker mboheraguapy jeguata ha eheka ykepeguápe. <a>Embojuruja mopotĩha</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Ehechajey umi service workers ambue mba’éva. <a>Embojuruja about:debugging</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Ndaipóri mba’apohára ogaygua

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Kuaave

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Pe kuatiarogue ag̃agua oguerekokuaa service worker, ohekakuaa jejavy <a>Consola</a>-pe térã oho service worker mboherapyre <span>Mopotĩha</span>-pe.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Ehecha mba’apohára ogaygua ambue mba’éva

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Je’epyre rembipuru’i

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Embojuaju ñanduti rembipuru’i Je’epyre ehechajey hag̃ua ko’ápe. <a>Maranduve</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Ndaipóri je’epyre ñanduti rembipuru’igua

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Mba’éicha embojuajúta je’epyre

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Jejavy ha kyhyjerã

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Teratee

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Jehechauka

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Ta’ãngachu’i

# Text displayed while we are loading the manifest file
manifest-loading = Je’epyre ñemyanyhẽ…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Je’epyre ñemyanyhẽpyre.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Ojavy ehupikuévo pe je’epyre:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox DevTools jejavy

# Text displayed when the page has no manifest available
manifest-non-existing = Ndojejuhúi je’epyre ojehechajey hag̃ua.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Pe je’epyre ojuaju mba’ekuaarã URL rehe.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Japose: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ta’ãngachu’i

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Ta’ãngachu’i tuichakue ndive: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Ta’ãngachu’i tuichakue oje’e’ỹva

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Je’epyre
    .alt = Je’epyre ra’ãnga
    .title = Je’epyre

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Mba’apohára mba’epytyvõrãguáva
    .alt = Mba’apohára mba’epytyvõrãguáva ra’ãnga
    .title = Mba’apohára mba’epytyvõrãguáva

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Ta’ãngachu’i kyhyjerã
    .title = Kyhyjerã

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Ta’ãngachu’i javygua
    .title = Javy

