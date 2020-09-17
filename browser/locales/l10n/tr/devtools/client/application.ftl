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
serviceworker-list-header = Service Worker’lar

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Diğer alan adlarına ait Service Worker’lar için <a>about:debugging</a>’i açın

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Kaydı sil

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Hata ayıkla
    .title = Yalnızca çalışan service worker’larda hata ayıklanabilir

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Hata ayıkla
    .title = Service worker'larda hata ayıklamak için çoklu e10s'in devre dışı olması gerekir

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Başlat
    .title = Service worker'lar yalnızca çoklu e10s devre dışıysa başlatılabilir

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Denetle

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Başlat

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Güncelleme: <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Kaynak

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Durum

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Çalışıyor

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Durduruldu

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Burada denetlemek istediğiniz Service Worker’ı önce kaydetmelisiniz. <a>Daha fazla bilgi alın</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Geçerli sayfada bir service worker olması gerekiyorsa aşağıdakileri deneyebilirsiniz

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Konsoldaki hatalara bakın. <a>Konsolu aç</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Service Worker kaydınızı adım adım denetleyerek aykırılıkları arayın. <a>Hata ayıklayıcıyı aç</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Diğer alan adlarındaki Service Worker’ları denetleyin. <a>about:debugging’i aç</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Hiç service worker bulunamadı

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Daha fazla bilgi al

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Bu sayfada bir service worker olması gerekiyorsa <a>konsoldaki</a> hatalara bakabilir veya <span>hata ayıklayıcı</span> ile service worker kaydınızı denetleyebilirsiniz.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Diğer alan adlarındaki service worker'ları görüntüle

# Header for the Manifest page when we have an actual manifest
manifest-view-header = Uygulama manifest’i

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Burada denetlemek için bir web uygulaması manifest'i eklemelisiniz. <a>Daha fazla bilgi alın</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Hiç web uygulaması manifest'i bulunamadı

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Manifest eklemeyi öğrenin

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Hatalar ve Uyarılar

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Kimlik

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Sunum

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Simgeler

# Text displayed while we are loading the manifest file
manifest-loading = Manifest yükleniyor…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Manifest yüklendi.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Manifest yüklenirken bir hata oluştu:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox Geliştirici Araçları hatası

# Text displayed when the page has no manifest available
manifest-non-existing = İncelenecek bir manifest bulunamadı.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifest bir Data URL'sine gömülü.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Amaç: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Simge

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Simge boyutları: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Belirtilmemiş simge boyutu

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifest simgesi
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Worker’lar
    .alt = Service Worker’lar simgesi
    .title = Service Worker’lar

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Uyarı simgesi
    .title = Uyarı

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Hata simgesi
    .title = Hata

