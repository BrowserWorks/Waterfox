# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = 除錯 - 設定

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = 除錯 - Runtime / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = 這個 { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = 設定

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = 已啟用 USB

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = 已停用 USB

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = 已連線
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = 已中斷連線

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = 未發現裝置

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = 連線

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = 連線中…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = 連線失敗

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = 仍然等待連線中，請到目標瀏覽器確認訊息

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = 連線逾時

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = 已連線

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = 正在等待瀏覽器連線…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = 未連結

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName }（{ $deviceName }）
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = 除錯器技術支援

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = 輔助說明圖示

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = 重新整理裝置

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = 設定

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = 設定要用哪種方式來從遠端對您的裝置除錯。

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = 於這個版本的 { -brand-shorter-name } 使用 <a>{ about-debugging-this-firefox-runtime-name }</a> 來對擴充套件與 Service Worker 除錯。

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = 連線到裝置

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = 開啟此功能後，將會下載並安裝必需的 Android USB 除錯元件到 { -brand-shorter-name }。

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = 啟用 USB 裝置

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = 停用 USB 裝置

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = 更新中…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = 已啟用
about-debugging-setup-usb-status-disabled = 已停用
about-debugging-setup-usb-status-updating = 更新中…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = 於您的 Android 裝置開啟「開發者選單」。

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = 於「開發者選單」開啟「USB 除錯」。

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = 於 Android 裝置上的 Firefox 開啟「USB 除錯」。

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = 將 Android 裝置連線到您的電腦。

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = 連線到 USB 裝置時發生問題？<a>疑難排解</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = 網路位置

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = 透過網路連線到裝置時發生問題？<a>疑難排解</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = 新增

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = 尚未新增任何網路位置。

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = 主機

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = 移除

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = 主機「{ $host-value }」無效。預期的格式是「hostname:portnumber」。

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = 主機「{ $host-value }」已經註冊

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = 暫用擴充套件
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = 擴充套件
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = 分頁
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service Worker
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = 共享 Workers
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = 其他 Workers
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Processes

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = 檢測效能

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = 您瀏覽器的設定與 Service Worker 不相容。<a>了解更多資訊</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = 連結的瀏覽器使用的是舊版（{ $runtimeVersion }）。目前支援的最小版本為（{ $minVersion }）。不支援這種設定，可能會造成開發者工具發生錯誤，請更新連線的瀏覽器。<a>點此進行疑難排解</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = 此版本的 Firefox 無法對 Firefox for Android 68 版進行除錯。我們建議您在手機上安裝 Firefox for Android Nightly 來進行測試。<a>更多詳情</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = 連結的瀏覽器（版本 { $runtimeVersion }、buildID { $runtimeID }）比您的 { -brand-shorter-name }（{ $localVersion }、buildID { $localID }） 還新。這是不支援的設定，可能會造成開發者工具發生錯誤，請更新 Firefox。<a>點此進行疑難排解</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name }（{ $version }）

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = 中斷連線

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = 開啟連線提示

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = 關閉連線提示

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = 效能檢測器

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = 展開 / 摺疊

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = 沒有任何東西。

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = 檢測

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = 載入暫用附加元件…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = 安裝暫用附加元件時發生錯誤。

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = 重新載入

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = 移除

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = 請選擇 manifest.json 檔案或 .xpi/.zip 封存檔

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = 此 WebExtension 使用暫用 ID。<a>了解更多資訊</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = 安裝資訊檔網址

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = 內部 UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = 位置

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = 擴充套件 ID

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = 推送
    .disabledTitle = 多程序的 { -brand-shorter-name } 目前暫時無法使用 Service Worker push

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = 開始
    .disabledTitle = 多程序的 { -brand-shorter-name } 目前暫時無法使用 Service Worker start

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = 取消註冊

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = 正在聆聽 fetch 事件

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = 沒有在聆聽 fetch 事件

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = 執行中

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = 停止

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = 註冊中

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Scope

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = 推送服務

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = 多程序的 { -brand-shorter-name } 目前暫時無法使用 Service Worker 檢測

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = 還沒有完全載入分頁內容，無法檢測

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = 主要 Process

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = 目標瀏覽器的主要 Process

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = 多處理程序工具箱

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = 目標瀏覽器的主要與內容處理程序

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = 關閉訊息

# Label text used for the error details of message component.
about-debugging-message-details-label-error = 錯誤詳細資訊

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = 警告詳細資訊

# Label text used for default state of details of message component.
about-debugging-message-details-label = 詳細資訊
