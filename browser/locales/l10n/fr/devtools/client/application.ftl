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
serviceworker-list-header = Service workers

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Ouvrez <a>about:debugging</a> pour afficher les service workers des autres domaines

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Désinscrire

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Déboguer
    .title = Seuls les service workers en cours d’exécution peuvent être débogués

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Débogage
    .title = Peut déboguer les service workers seulement si multi e10s est désactivé

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Démarrer
    .title = Peut lancer les service workers seulement si multi e10s est désactivé

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Inspecter

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Démarrer

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Actualisation : <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Source

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = État

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = En cours d’exécution

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Arrêté

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Vous devez inscrire un service worker afin de pouvoir l’inspecter ici. <a>En savoir plus</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Si la page actuelle devrait contenir un service worker, voici ce que vous pouvez essayer

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Rechercher les erreurs dans la console. <a>Ouvrir la console</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Parcourir le registre des inscriptions de service workers à la recherche d’exceptions. <a>Ouvrir le débogueur</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Inspecter les service workers des autres domaines. <a>Ouvrir about:debugging</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Aucun service worker trouvé

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = En savoir plus

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Si la page actuelle est supposée inclure un service worker, vous pouvez rechercher des erreurs dans la <a>console</a> ou parcourir pas-à-pas l’inscription de votre service worker dans le <span>débogueur</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Afficher les service workers d’autres domaines

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifeste d’application

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Vous devez ajouter un manifeste d’application web pour l’inspecter ici. <a>En savoir plus</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Aucun manifeste d’application web détecté

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Découvrir comment ajouter un manifeste

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Erreurs et avertissements

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identité

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Présentation

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Icônes

# Text displayed while we are loading the manifest file
manifest-loading = Chargement du manifeste…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifeste chargé.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Une erreur s’est produite lors du chargement du manifeste :

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Erreur des outils de développement de Firefox

# Text displayed when the page has no manifest available
manifest-non-existing = Aucun manifeste trouvé à inspecter.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Le manifeste est intégré dans une URL data.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = But : <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Icône

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Icône avec tailles : { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Icône de taille non spécifiée

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifeste
    .alt = Icône de manifeste
    .title = Manifeste

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service workers
    .alt = Icône de service workers
    .title = Service workers

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Icône d’avertissement
    .title = Avertissement

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Icône d’erreur
    .title = Erreur

