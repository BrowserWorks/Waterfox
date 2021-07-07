# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### These strings are used inside the about:debugging UI.

# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = デバッガー - セットアップ

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = デバッガー - ランタイム / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Waterfox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = この { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Waterfox
about-debugging-sidebar-this-firefox =
  .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
  .name = セットアップ

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB 有効

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB 無効

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = 接続済み
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = 未接続

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = デバイスが見つかりません

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = 接続

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = 接続中...

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = 接続失敗

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = 接続は保留中です。ターゲットとなるブラウザーのメッセージを確認してください

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = 接続タイムアウト

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Waterfox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Waterfox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = ブラウザーを待機しています...

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = 未接続

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
  .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
  .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = デバッグに関するサポート情報

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
  .alt = ヘルプアイコン

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = デバイスを再検索

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = セットアップ

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = リモートデバッグを行うデバイスの接続方式を設定します。

# Explanatory text in the Setup page about what the 'This Waterfox' page is for
about-debugging-setup-this-firefox2 = このバージョンの { -brand-shorter-name } で拡張機能と Service Worker をデバッグするには、<a>{ about-debugging-this-firefox-runtime-name }</a> を使用します。

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = デバイスを接続

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = 有効にすると Android USB デバッグに必要なコンポーネントをダウンロードして、{ -brand-shorter-name } に追加します。

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB デバイスを有効化

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB デバイスを無効化

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = 更新中...

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = 有効
about-debugging-setup-usb-status-disabled = 無効
about-debugging-setup-usb-status-updating = 更新中...

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Android 端末の開発者向けオプションを有効にします。

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Android 端末の開発者向けオプションで USB デバッグを有効にします。

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Android 端末上の Waterfox で USB デバッグを有効にします。

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Android 端末をコンピューターに接続します。

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = USB デバイスの接続に問題がありますか？ <a>トラブルシューティング</a>

# Network section of the Setup page
about-debugging-setup-network =
  .title = ネットワーク上の場所

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = ネットワーク上の場所の接続に問題がありますか？ <a>トラブルシューティング</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = 追加

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = ネットワーク上の場所はまだ追加されていません。

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = ホスト

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = 削除

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = “{ $host-value }” は不正なホスト名です。正しいフォーマットは “hostname:portnumber” です。

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = ホスト “{ $host-value }” は登録済みです。

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Waterfox" runtime).
about-debugging-runtime-temporary-extensions =
  .name = 一時的な拡張機能
# Title of the extensions category.
about-debugging-runtime-extensions =
  .name = 拡張機能
# Title of the tabs category.
about-debugging-runtime-tabs =
  .name = タブ
# Title of the service workers category.
about-debugging-runtime-service-workers =
  .name = Service Worker
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
  .name = Shared Worker
# Title of the other workers category.
about-debugging-runtime-other-workers =
  .name = 他の Worker
# Title of the processes category.
about-debugging-runtime-processes =
  .name = プロセス

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = パフォーマンスのプロファイル

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = このブラウザーの設定は Service Worker と互換性がありません。<a>詳細</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Waterfox instance (same format)
about-debugging-browser-version-too-old = 接続したブラウザーのバージョン ({ $runtimeVersion }) が古いです。サポートされている最低バージョンは ({ $minVersion }) です。この組み合わせはサポートされてないため、開発ツールでエラーが発生する可能性があります。接続ブラウザーを更新してください。<a>トラブルシューティング</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Waterfox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = このバージョンの Waterfox は Android 版 Waterfox (68) をデバッグできません。携帯電話でのテストには Android 版 Waterfox Nightly のインストールをお勧めします。<a>詳細</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Waterfox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = 接続したブラウザー ({ $runtimeVersion }, ビルド ID { $runtimeID }) が、実行中の { -brand-shorter-name } ({ $localVersion }, ビルド ID { $localID }) よりも新しいです。この組み合わせはサポートされてないため、開発ツールでエラーが発生する可能性があります。Waterfox を更新してください。<a>トラブルシューティング</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Waterfox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = 切断

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = 接続の確認を有効にする

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = 接続の確認を無効にする

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = プロファイラー

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = 折りたたむ / 展開

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = まだありません。

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = 調査

# Text of a button displayed in the "This Waterfox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = 一時的なアドオンを読み込む...

# Text displayed when trying to install a temporary extension in the "This Waterfox" page.
about-debugging-tmp-extension-install-error = 一時的なアドオンのインストール中にエラーがありました。

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = 再読み込み

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = 削除

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = manifest.json ファイルか .xpi/.zip ファイルを選択してください

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = この WebExtension は一時的な ID です。<a>詳細</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
  .label = マニフェスト URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
  .label = 内部 UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
  .label = 場所

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
  .label = 拡張機能 ID

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = プッシュ通知
  .disabledTitle = Service Worker プッシュ通知は、現在のマルチプロセス { -brand-shorter-name } では無効化されています。

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = 開始
  .disabledTitle = Service Worker の開始は、現在のマルチプロセス { -brand-shorter-name } では無効化されています。

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = 解除

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
  .label = Fetch
  .value = Fetch イベントを監視中

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
  .label = Fetch
  .value = Fetch イベントの監視を休止中

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = 実行中

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = 停止

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = 登録中

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
  .label = スコープ

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
  .label = Push サービス

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
  .title = Service Worker の調査は、現在のマルチプロセス { -brand-shorter-name } では無効化されています。

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
  .title = タブの読み込みが完了してないため調査できません。

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = メインプロセス

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = ターゲットブラウザーのメインプロセス

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = マルチプロセスツールボックス

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = ターゲットブラウザーのメインプロセスとコンテンツプロセス

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
  .alt = メッセージを閉じる

# Label text used for the error details of message component.
about-debugging-message-details-label-error = エラーの詳細

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = 警告の詳細

# Label text used for default state of details of message component.
about-debugging-message-details-label = 詳細
