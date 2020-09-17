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
serviceworker-list-header = Ameẓlu Workers

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Ldi <a>about:debugging</a> i umeẓlu Workers seg tɣula-nniḍen

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Ffeɣ seg ujerred

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Tamseɣtayt
    .title = Ala aselkem n umezlu workers i yezmren ad yettwaseɣti

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Tamseɣtayt
    .title = Izmer kan ad yesseɣti imeẓla workers ma yella multi e10s yensa

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Bdu
    .title = Izmer kan ad yessenker imeẓla workers ma yella multi e10s yensa

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Sweḍ

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Bdu

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Yettwalqem <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Aɣbalu

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Addad

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Aselkem

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Yeḥbes

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Yessef ad tjerrdeḍ ar umeẓlu worker akken ad yettwasleḍ dagi. <a> Issin ugar </a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Ma yella asebter amiran yessefk ad yesɛu ameẓlu worker, haten-aya kra n tɣawsiwin i tzemred ad tɛerḍeḍ

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Wali tuccḍiwin di tdiwent. <a> Qqen ar tdiwent</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Ddu ar ujerred n umeẓlu worker sakin nadi tisuraf. <a> Qqen ar temseɣtayt</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Sweḍ ameẓlu workers seg tiɣula-nniden. <a> Ldi about:debugging</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Ulac inmahalen n umeẓlu yettwafen

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Issin ugar

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Ma yella asebter amiran ilaq ad yesεu anmahal n umeẓlu, tzemreḍ ad tqellbeḍ tuccḍiwin deg <a>tdiwent</a> neɣ ddu d usekles n unmahal-inek·inem n umeẓlu deg <span>umseɣti</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Sken inmahalen n umeẓlu n tiɣula-nniḍen

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Ameskan n usnas

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Ilaq ad ternuḍ ameskan n usnas web akken ad yettwasweḍ dagi: <a>Issin ugar</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Ulac ameskan n usnas web yettwafen

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Issin amek ara ternuḍ ameskan

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Tuccḍiwin akked Ilɣa

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Tamagit

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Asissen

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Tigniyin

# Text displayed while we are loading the manifest file
manifest-loading = Asal n umeskan…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Ameskan yuli-d.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Teḍra-d tuccḍa deg usali n umeskan:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Tuccḍa n Firefox DevTools

# Text displayed when the page has no manifest available
manifest-non-existing = Ulac ameskan yettwafen i uswaḍ.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Ameskan yesleɣ deg yisefka n tensa URL.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Iswi: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Tignit

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Tignit s teɣzi: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Teɣzi n tignit ur tettwassen ara

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Ameskan
    .alt = Tignit n umeskan
    .title = Ameskan

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Ameẓlu Workers
    .alt = Tignit n umeẓlu Workers
    .title = Ameẓlu Workers

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Tginit n ulɣu
    .title = Alɣu

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Tignit n tuccḍa
    .title = Tuccḍa

