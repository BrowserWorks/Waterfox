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
serviceworker-list-header = Service Workers

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Buka <a>about:debugging</a> untuk Service Workers dari domain lainnya

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Batalkan Pendaftaran

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Debug
    .title = Hanya service workers yang berjalan dapat didebug

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Inspeksi

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Mulai

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Diperbarui <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Berjalan

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Dihentikan

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = TIdak ada service worker ditemukan

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Pelajari lebih lanjut

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Jika halaman saat ini harusnya berisi sebuah service worker, Anda dapat melihat kesalahannya di <a>Konsol</a> atau melihat langkah-langkah pendaftaran service worker di <span>Debugger</span>.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Lihat service worker dari domain lain

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Manifes Aplikasi

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Tidak ada manifes aplikasi web yang terdeteksi

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Pelajari cara menambahkan manifest

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Galat dan Peringatan

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Identitas

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Presentasi

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Ikon

# Text displayed while we are loading the manifest file
manifest-loading = Memuat manifes…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifes dimuat.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Terjadi kesalahan dalam memuat manifest.

# Text displayed as an error when there has been a Waterfox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Kesalahan Waterfox DevTools

# Text displayed when the page has no manifest available
manifest-non-existing = Tidak ditemukan manifest untuk diperiksa.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifest tersemat dalam Data URL.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Tujuan: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Ikon

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Ikon dengan ukuran: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Ikon dengan ukuran tidak ditentukan

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Ikon manifest
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Worker
    .alt = Ikon Service Worker
    .title = Service Worker

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Ikon peringatan
    .title = Peringatan

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Ikon kesalahan
    .title = Kesalahan

