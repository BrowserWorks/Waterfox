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
serviceworker-list-header = Mga Service Worker
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Buksan ang <a>about:debugging</a> para sa Service Workers galing sa ibang mga domain
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Unregister
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = i-Debug
    .title = Tanging mga tumatakbong service worker lang ang maaaring ma-debug
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = i-Debug
    .title = Maaari lamang makapag-debug ng mga service worker kung naka-disable ang multi e10s
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Simulan
    .title = Maaari lamang makapagsimula ng mga service worker kung naka-disable ang multi e10s
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = i-Inspect
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Simulan
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Na-update <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Pinagmulan
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Status

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Tumatakbo
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Itinigil
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Kailangan mong mag-register ng Service Worker para ma-inspect ito rito. <a>Alamin</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Kapag nangailangan ang current page ng service worker, ito ang ilan sa mga bagay na maaari mong subukan
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Maghanap ng mga error sa Console. <a>Buksan ang Console</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Mag-step through sa iyong mga Service Worker registration at maghanap ng mga exception. <a>Buksan ang Debugger</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Mag-inspect ng mga Service Worker sa ibang mga domain. <a>Buksan ang about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Walang natagpuang mga service worker
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Alamin
# Header for the Manifest page when we have an actual manifest
manifest-view-header = App Manifest
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Kailangan mong magdagdag ng web app Manifest para ma-inspect ito rito. <a>Alamin</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Walang natagpuang web app manifest
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Alamin kung paano magdagdag ng manifest
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Mga Error at Warning
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identity
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Presentation
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Mga icon
# Text displayed while we are loading the manifest file
manifest-loading = Niloload ang manifest...
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Naiload na ang manifest.
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Nagkaroon ng problema habang niloload ang manifest.
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = May Mali sa Firefox DevTools
# Text displayed when the page has no manifest available
manifest-non-existing = Walang manifest na pwedeng suriin.
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Ang manifest ay naka-embed sa Data URL.
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Layunin: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Icon
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Icon with sizes: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Di-nabanggit na size icon
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifest Icon
    .title = Manifest
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Mga Service Worker
    .alt = Icon ng Service Worker
    .title = Mga Service Worker
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Warning icon
    .title = Warning
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Error icon
    .title = Error
