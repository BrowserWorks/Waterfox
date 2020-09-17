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
serviceworker-list-header = Ծառայության աշխատողներ

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Բացել <a>մասին․վրիպազերծում</a> այլ տիրույթներից ծառայության աշխատողների համար։

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Ապագրանցված

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Վրիպազերծել
    .title = Միայն աշխատեցվող ծառայության աշխատողները կարող են լինել վրիպազերծված

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Վրիպազերծել
    .title = Կարող է վրիպազերծել միայն ծառայության աշխատողներին, եթե multi e 10s-ը անջատված է։

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Մեկնարկ
    .title = Կարող է մեկնարկել միայն ծառայության աշխատողներին, եթե multi e10s-ը անջատված է։

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Թարմացված <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Աղբյուր

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Աշխատավիճակ

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Աշխատեցում

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Կանգնեցված

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Այստեղ ստուգելու համար Դուք պետք է գրանցեք ծառայության աշխատողին։ <a>Իմանալ ավելին</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Եթե ընթացիկ էջը պետք է ունենա ծառայության աշխատող, այստեղ կան որոշ բաներ, որոնք Դուք կարող եք փորձել

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Որոնել սխալներ վահանակում։ <a>Բացել վահանակը</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Քայլ արեք ձեր ծառայության աշխատողի գրանցման մեջ և փնտրեք բացառություններ։<a>֊ը Բացեց կարգաբերիչը</a>։

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Ստուգել ծառայության աշխատողներին այլ տիրույթներից։ <a>Բացել վրիպազերծման մասին</a>

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifest հավելված

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Այստեղ ստուգելու համար դուք պետք է ավելացնեք Manifest վեբ հավելվածը։ <a>Իմանալ ավելին</a>

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Սխալներ և Զգուշացումներ

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Նույնություն

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Ներկայացում

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Պատկերներ

# Text displayed while we are loading the manifest file
manifest-loading = Manifest-ի բեռնում․․․

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest-ը բեռնված է։

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Սխալ՝ manifest-ը բեռնելիս․

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox DevTools սխալ

# Text displayed when the page has no manifest available
manifest-non-existing = Ստուգլու համար manifest չի հայտնաբերվել։

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = URL-ի տվյալներում manifest-ը ներկառուցված է։

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Նպատակը՝<code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Մանրանկար

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Պատկերակ չափերով․{ $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Չստացված չափի պատկերակ

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifest-ի պատկերակ
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Ծառայության աշխատողներ
    .alt = Ծառայության աշխատողների պատկերակ
    .title = Ծառայության աշխատողներ

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Զգուշացման պատկերակ
    .title = Զգուշացում

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Սխալ պատկերակ
    .title = Սխալ

