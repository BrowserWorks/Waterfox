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
serviceworker-list-aboutdebugging = Dobrir <a>about:debugging</a>  pels Service Workers d’autres domenis

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Levar

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Desbugatge
    .title = Solament los servicis lançats pòt passar al debugatge

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Desbugatge
    .title = Òm pòt pas desbugagr los service worker se multi e10s es desactivat

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Començar
    .title = Òm pòt pas qu’aviar los service worker se multi e10s es desactivat

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Examinar

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Aviar

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Actualizacion <time>{ DATETIME($date, day: "numeric", month: "long", year: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Font

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Estat

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = A s’executar

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Arrestat

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Vos cal inscriure un Service Worker per examinar aquò aquí. <a>Ne saber mai</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Se la pagina actuala deu conténer un service worker, vaquí çò que podètz ensajar

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Recercar las error dins la consòla. <a>Dobrir la consòla</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Percórrer lo registre de las inscripcions service workers a la recèrca d’excepcions. <a>Dobrir lo deugador</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Examinar los service workers dels autres domenis. <a>Dobrir about:debugging</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Cap de service workers pas trobat

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Ne saber mai

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Se la pagina actuala deuriá aver un service worker, podètz cercar las error dins la  <a>Consòla</a> o percórrer pas a pas l’inscripcion de vòstre service worker dins lo <span>Desbugador</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Veire los service workers d’autres domenis

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifest d’aplicacion

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Vos cal apondre un manifèst d’aplicacion web per l’examinar aquí. <a>Ne saber mai</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Cap de manifèst d’aplicacion pas trobat

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Aprendre a apondre un fichièr de manifèst

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Errors e avises

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitat

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Presentacion

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Icònas

# Text displayed while we are loading the manifest file
manifest-loading = Cargament del manifèst…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifèst cargat.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = S’es producha una error en cargant lo manifèst :

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Error de las aisinas de desvolopament de Firefox

# Text displayed when the page has no manifest available
manifest-non-existing = Cap de manifèst pas trobat a inspectar.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Lo manifèst es integrat dins una URL data.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Tòca : <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Icòna

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Icòna amb talhas : { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Icòna sens talha especificada

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifèst
    .alt = Icòna del manifèst
    .title = Manifèst

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workers
    .alt = Icòna dels Service Workers
    .title = Service Workers

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Icòna d’avís
    .title = Avís

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Icòna d’error
    .title = Error

