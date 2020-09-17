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
serviceworker-list-aboutdebugging = Abra <a>about:debugging</a> para Service Workers de otros domínios

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Desregistrar

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Depurar
    .title = Solo service workers en ejecución pueden ser depurados

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Depurar
    .title = Se pueden depurar los service workers solo si multi e10s está

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Inicio
    .title = Se pueden iniciar los service workers solo si multi e10s está deshabilitado

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Inspeccionar

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Iniciar

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Actualizado <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Fuente

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Estado

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Ejecutándose

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Detenido

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Se necesita registrar un service worker para inspeccionarlo acá. <a>Concer más</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Si la página actual debería tener un service worker, acá hay algunas cosas que podría probar

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Busque errores en la consola. <a>Abrir la consola</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Mire la registración del service worker paso a paso y busque excepciones. <a>Abrir el depurador</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Inspeccione service workers de otros dominios. <a>Abrir about:debugging</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = No se encontraron service workers

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Conocer más

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Si la página actual debe tener un service worker, puede buscar errores en la <a>Consola</a> o ir al registro de su service worker en el <span>Depurador</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Ver service workers de otros dominios

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifiesto de aplicación

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Tiene que agregar un Manifiesto de aplicación web para inspeccionarlo aquí. <a> Más información </a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = No se detectó ningún manifiesto de aplicación web

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Aprendé a agregar un manifiesto

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Errores y advertencias

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identidad

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Presentación

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Íconos

# Text displayed while we are loading the manifest file
manifest-loading = Cargando manifiesto...

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifiesto cargado.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Hubo un error al cargar el manifiesto:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Error de Firefox DevTools

# Text displayed when the page has no manifest available
manifest-non-existing = No se encontró ningún manifiesto para inspeccionar.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = El manifiesto está integrado en una URL de datos.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Propósito: <code> { $purpose } </code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ícono

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Icono con tamaños: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Icono de tamaño no especificado

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifiesto
    .alt = Ícono del Manifiesto
    .title = Manifiesto

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workers
    .alt = Ícono de Service Workers
    .title = Service Workers

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Icono de advertencia
    .title = Advertencia

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Icono de error
    .title = Error

