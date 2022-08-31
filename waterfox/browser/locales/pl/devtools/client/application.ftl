# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Header for the list of Service Workers displayed in the application panel for the current page.
serviceworker-list-header = Wątki usługowe

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Otwórz stronę <a>about:debugging</a>, aby zobaczyć wątki usługowe z innych domen.

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Wyrejestruj

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Debuguj
    .title = Wyłącznie uruchomione wątki usługowe mogą być debugowane

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Zbadaj

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Uruchom

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Uaktualniono <time>{ DATETIME($date, month: "numeric", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Uruchomiony

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Zatrzymany

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Nie odnaleziono wątków usługowych

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Więcej informacji

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Jeśli bieżąca strona powinna mieć wątek usługowy, to można poszukać błędów w <a>konsoli</a> lub przejrzeć rejestrację wątku usługowego w <span>debugerze</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Zobacz wątki usługowe z innych domen

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifest aplikacji

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Nie wykryto manifestu aplikacji internetowej

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Jak dodać manifest

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Błędy i ostrzeżenia

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Tożsamość

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Prezentacja

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Ikony

# Text displayed while we are loading the manifest file
manifest-loading = Wczytywanie manifestu…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Wczytano manifest.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Wystąpił błąd podczas wczytywania manifestu:

# Text displayed as an error when there has been a Waterfox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Błąd narzędzi dla programistów

# Text displayed when the page has no manifest available
manifest-non-existing = Nie odnaleziono manifestu do zbadania.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifest jest osadzony w adresie URL typu „data:”.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Zastosowanie: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ikona

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Ikona o rozmiarach: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Ikona nieokreślonego rozmiaru

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Ikona manifestu
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Wątki usługowe
    .alt = Ikona wątków usługowych
    .title = Wątki usługowe

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Ikona ostrzeżenia
    .title = Ostrzeżenie

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Ikona błędu
    .title = Błąd

