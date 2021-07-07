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
serviceworker-list-header = Service Worker
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = 打开 <a>about:debugging</a> 检查其他域名的 Service Worker
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = 取消注册
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = 调试
    .title = 仅在运行 Service Workers 时可被调试
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = 调试
    .title = 只能在禁用多进程模式的情况下调试 Service Worker
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = 启动
    .title = 只能在禁用多进程模式的情况下启动 Service Worker
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = 检查
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = 开始
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = 更新于 <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = 来源
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = 状态

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = 正在运行
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = 已停止
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = 检查先注册一个 Service Worker 才可在此检查。<a>详细了解</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = 如果当前页面中应有 Service Worker，您可以尝试：
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = 在控制台中排查错误。<a>打开控制台</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = 逐步注册您的 Service Worker，检查是否有异常发生。<a>打开调试器</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = 检查其他域名的 Service Worker。<a>打开 about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = 没有找到 Service Worker
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = 详细了解
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = 若当前页面上本应有 Service Worker，请在<a>控制台</a>中查找错误，或在<span>调试器</span>中按步骤注册 Service Worker。
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = 检查来自其他域名的 Service Worker
# Header for the Manifest page when we have an actual manifest
manifest-view-header = 应用清单文件
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = 先添加一个 Web 应用清单文件才可在此查看。<a>详细了解</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = 未检测到 Web 应用清单文件
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = 了解如何添加“清单文件”
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = 错误和警告
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = 标识
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = 呈现
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = 图标
# Text displayed while we are loading the manifest file
manifest-loading = 正在载入清单文件…
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = 清单文件加载完毕。
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = 载入清单文件时发生错误：
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox 开发者工具出错
# Text displayed when the page has no manifest available
manifest-non-existing = 未找到要检查的清单文件。
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = 清单文件嵌入在数据 URL 中。
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = 目的：<code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = 图标
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = 图标尺寸：{ $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = 未指定图标大小
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = 清单文件
    .alt = 清单文件图标
    .title = 清单文件
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Worker
    .alt = Service Worker 图标
    .title = Service Worker
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = 警告图标
    .title = 警告
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = 错误图标
    .title = 错误
