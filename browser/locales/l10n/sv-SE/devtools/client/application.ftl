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
serviceworker-list-aboutdebugging = Öppna <a>about:debugging</a> för Service Workers från andra domäner

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Avregistrera

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Felsök
    .title = Enbart service workers som kör kan felsökas

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Felsök
    .title = Du kan endast felsöka Service Workers om multi e10s är inaktiverad

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Starta
    .title = Du kan endast starta Service Workers om multi e10s är inaktiverad

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Inspektera

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Starta

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Uppdaterad <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Källa

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Status

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Körs

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Stoppad

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Du behöver registrera en Service Worker för att inspektera den här. <a>Lär dig mer</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Om den nuvarande sidan ska ha en service worker, här är några saker du kan prova

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Kolla efter fel i konsolen. <a>Öppna konsolen</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Stega igenom dina registrerade Service Worker och titta efter undantag. <a>Öppna felsökaren</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Inspektera Service Workers från andra domäner. <a>Öppna about:debugging</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Inga service workers hittades

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Läs mer

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Om den aktuella sidan har en service worker, så kan du leta efter fel i <a>konsolen</a> eller stega dig igenom din service worker registrering i <span>felsökaren</span>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Visa service workers från andra domäner

# Header for the Manifest page when we have an actual manifest
manifest-view-header = App manifest

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Du måste lägga till en webbapp-manifest för att inspektera den här. <a>Läs mer</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Inget webbapp manifest upptäckt

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Lär dig hur du lägger till ett manifest

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Fel och varningar

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitet

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Orientering

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Ikoner

# Text displayed while we are loading the manifest file
manifest-loading = Laddar manifest...

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest laddat.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Det uppstod ett fel när man laddade manifestet:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Fel i Firefox DevTools

# Text displayed when the page has no manifest available
manifest-non-existing = Inget manifest hittades för att inspektera.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifestet är inbäddat i en data-URL.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Syfte: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ikon

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Ikon med storlekar: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Ospecificerad storleksikon

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifest-ikon
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workers
    .alt = Service Workers-ikon
    .title = Service Workers

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Varningsikon
    .title = Varning

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Felikon
    .title = Fel

