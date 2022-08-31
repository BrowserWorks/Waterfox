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
serviceworker-list-header = Service Worker

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = 開啟 <a>about:debugging</a> 檢測來自其他網域的 Service Worker

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = 取消註冊

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = 除錯
    .title = 僅能對運作中的 service worker 進行除錯

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = 檢測

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = 開始

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = 更新於 <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = 執行中

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = 停止

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = 找不到 service worker

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = 了解更多

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = 若目前頁面中應該要有 service worker，可以到<a>主控台</a>看看有沒有錯誤訊息，或是到<span>除錯器</span>確認 service worker 的註冊狀態。

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = 檢視來自其他網域的 service worker

# Header for the Manifest page when we have an actual manifest
manifest-view-header = 應用程式 Manifest

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = 未偵測到網頁應用程式的安裝資訊檔

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = 了解如何加入安裝資訊檔

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = 錯誤與警告

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = 身份識別

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = 展現資料

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = 圖示

# Text displayed while we are loading the manifest file
manifest-loading = 正在載入 manifest…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = 已載入 manifest。

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = 載入 manifest 時發生錯誤:

# Text displayed as an error when there has been a Waterfox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Waterfox 開發者工具發生錯誤

# Text displayed when the page has no manifest available
manifest-non-existing = 找不到可以檢測的 manifest。

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Manifest 嵌入於 Data URL 中。

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = 目的: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = 圖示

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = 下列大小的圖示: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = 未指定大小的圖示

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifest
    .alt = Manifest 圖示
    .title = Manifest

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Worker
    .alt = Service Worker 圖示
    .title = Service Worker

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = 警告圖示
    .title = 警告

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = 錯誤圖示
    .title = 錯誤

