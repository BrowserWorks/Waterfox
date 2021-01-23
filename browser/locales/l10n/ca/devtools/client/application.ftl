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
serviceworker-list-header = Processos de treball de servei

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Suprimeix el registre

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Font

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Estat

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = S'està executant

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Aturat

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Errors i avisos

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitat

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Presentació

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Icones

# Text displayed while we are loading the manifest file
manifest-loading = S'està carregant el manifest…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = S'ha carregat el manifest.

# Text displayed when there has been an error while trying to load the manifest
manifest-loaded-error = S'ha produït un error en carregar el manifest:

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Icona de manifest
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Processos de treball de servei
    .alt = Icona de processos de treball de servei
    .title = Processos de treball de servei

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Icona d'avís
    .title = Avís

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Icona d’error
    .title = Error

