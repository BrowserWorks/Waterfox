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
serviceworker-list-header = Servicio Laborantes

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Aperir<a>re:depuration</a> pro Laborantes de servicio ex altere dominios

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = De-registrar

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Depurar
    .title = D

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Debug
    .title = Debug pro "service workers" es disponibile solmente si "multi e10s" es disactivate

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Initiar
    .title = Es possibile initiar "service workers" solmente si "multi e10s" es disactivate

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Inspectar

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Initiar

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Actualisate <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Fonte

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Stato

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = In execution

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Stoppate

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Tu debe registrar un Laborante de servicio pro lo inspectar ci. <a>Saper plus</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Si le pagina actual debe haber un Laborante de servicio, ecce alcun cosas que tu debe probar

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Cercar errores in le consola. <a>Aperir le consola</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Naviga inter le registrationes de to Laborantes de servicio e cerca le exceptiones. <a>Aperir le Depurator</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Inspectar le Laborantes de servicio ex altere dominios. <a>Aperir re:depuration</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Nulle obreros de servicio trovate

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Saper plus

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Si le actual pagina deberea haber un obrero de servicio, tu pote dar un reguardo pro errores in le <a>Consola</a> o analysar tu registration de obreros de servicio in le <span>Depurator</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Vider obreros de servicio de altere dominios

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifesto del app

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Tu debe adder un Manifesto de app web pro lo inspectar ci. <a>Saper plus</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Nulle file manifesto de app web trovate

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Saper como adder un manifesto

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Errores e avisos

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitate

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Presentation

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Icones

# Text displayed while we are loading the manifest file
manifest-loading = Cargante le manifesto…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifesto cargate

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Il habeva un error a cargar le manifesto:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Error de Firefox DevTools

# Text displayed when the page has no manifest available
manifest-non-existing = Nulle manifestos a inspectar trovate.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Le manifesto es integrate in un URL de datos.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Proposito: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Icone

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Icone con dimensiones: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Icone dimension non-specificate

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifesto
    .alt = Icone manifesto
    .title = Manifesto

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Obreros de servicio
    .alt = Icone de obreros de servicio
    .title = Obreros de servicio

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Icone de aviso
    .title = Aviso

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Icone de error
    .title = Error

