# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = 正在下載 { -brand-shorter-name } 更新
appmenuitem-banner-update-available =
    .label = 已推出更新 — 立即下載
appmenuitem-banner-update-manual =
    .label = 已推出更新 — 立即下載
appmenuitem-banner-update-unsupported =
    .label = 無法更新 — 系統不相容
appmenuitem-banner-update-restart =
    .label = 已推出更新 — 立即重新啟動
appmenuitem-new-tab =
    .label = 開新分頁
appmenuitem-new-window =
    .label = 開新視窗
appmenuitem-new-private-window =
    .label = 開新隱私視窗
appmenuitem-history =
    .label = 歷史
appmenuitem-downloads =
    .label = 下載項目
appmenuitem-passwords =
    .label = 密碼
appmenuitem-addons-and-themes =
    .label = 附加元件與佈景主題
appmenuitem-print =
    .label = 列印…
appmenuitem-find-in-page =
    .label = 在頁面中搜尋…
appmenuitem-zoom =
    .value = 縮放
appmenuitem-more-tools =
    .label = 更多工具
appmenuitem-help =
    .label = 說明
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] 離開
           *[other] 結束
        }
appmenu-menu-button-closed2 =
    .tooltiptext = 開啟應用程式選單
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = 關閉應用程式選單
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = 設定

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = 放大
appmenuitem-zoom-reduce =
    .label = 縮小
appmenuitem-fullscreen =
    .label = 全螢幕

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = 登入進行同步…
appmenu-remote-tabs-turn-on-sync =
    .label = 開啟同步…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = 顯示更多分頁
    .tooltiptext = 顯示來自此裝置的更多分頁
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = 無已開啟的分頁
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = 開啟分頁同步功能以檢視您其他裝置中的分頁清單。
appmenu-remote-tabs-opensettings =
    .label = 選項
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = 想在這裡看到您其他裝置上開啟的分頁嗎？
appmenu-remote-tabs-connectdevice =
    .label = 連結其他裝置
appmenu-remote-tabs-welcome = 檢視您其他裝置中的分頁清單。
appmenu-remote-tabs-unverified = 需要驗證您的帳號。
appmenuitem-fxa-toolbar-sync-now2 = 立刻同步
appmenuitem-fxa-sign-in = 登入 { -brand-product-name }
appmenuitem-fxa-manage-account = 管理帳號
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = 上次同步於 { $time }
    .label = 上次同步於 { $time }
appmenu-fxa-sync-and-save-data2 = 同步並儲存資料
appmenu-fxa-signed-in-label = 登入
appmenu-fxa-setup-sync =
    .label = 開啟同步…
appmenuitem-save-page =
    .label = 另存新檔…

## What's New panel in App menu.

whatsnew-panel-header = 有什麼新鮮事
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = 有新功能推出時通知我
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = 效能檢測器
    .tooltiptext = 紀錄效能檢測檔
profiler-popup-button-recording =
    .label = 效能檢測器
    .tooltiptext = 檢測器正在紀錄效能檢測檔
profiler-popup-button-capturing =
    .label = 效能檢測器
    .tooltiptext = 檢測器正在紀錄效能檢測檔
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = 揭露更多資訊
profiler-popup-description-title =
    .value = 紀錄、分析、分享
profiler-popup-description = 與您的團隊分享效能測量資訊，一同解決效能問題。
profiler-popup-learn-more-button =
    .label = 了解更多
profiler-popup-settings =
    .value = 設定
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = 編輯設定值…
profiler-popup-recording-screen = 記錄中…
profiler-popup-start-recording-button =
    .label = 開始記錄
profiler-popup-discard-button =
    .label = 捨棄
profiler-popup-capture-button =
    .label = 捕捉
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = 推薦於對大部分網頁應用程式除錯時使用，額外負荷較低。
profiler-popup-presets-web-developer-label =
    .label = 網頁開發者
profiler-popup-presets-firefox-description = 對 { -brand-shorter-name } 進行效能檢測的建議預設值。
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = 於 { -brand-shorter-name } 診斷圖形 Bug 時的預設值。
profiler-popup-presets-graphics-label =
    .label = 圖形
profiler-popup-presets-media-description2 = 於 { -brand-shorter-name } 診斷影音 Bug 時的預設值。
profiler-popup-presets-media-label =
    .label = 媒體
profiler-popup-presets-networking-description = 於 { -brand-shorter-name } 診斷網路連線 Bug 時的預設值。
profiler-popup-presets-networking-label =
    .label = 網路連線
profiler-popup-presets-power-description = 於 { -brand-shorter-name } 診斷耗電量時的預設值，額外負荷較低。
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = 電源
profiler-popup-presets-custom-label =
    .label = 自訂

## History panel

appmenu-manage-history =
    .label = 管理歷史
appmenu-reopen-all-tabs = 回復所有分頁
appmenu-reopen-all-windows = 回復所有視窗
appmenu-restore-session =
    .label = 回復先前的瀏覽狀態
appmenu-clear-history =
    .label = 清除最近的歷史記錄…
appmenu-recent-history-subheader = 最近紀錄
appmenu-recently-closed-tabs =
    .label = 最近關閉的分頁
appmenu-recently-closed-windows =
    .label = 最近關閉的視窗

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name } 說明
appmenu-about =
    .label = 關於 { -brand-shorter-name }
    .accesskey = A
appmenu-get-help =
    .label = 取得幫助
    .accesskey = H
appmenu-help-more-troubleshooting-info =
    .label = 更多疑難排解資訊
    .accesskey = T
appmenu-help-report-site-issue =
    .label = 回報網站問題…
appmenu-help-share-ideas =
    .label = 分享想法與意見回饋…
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = 疑難排解模式…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = 關閉疑難排解模式
    .accesskey = M

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = 回報詐騙網站…
    .accesskey = D
appmenu-help-not-deceptive =
    .label = 這不是詐騙網站…
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = 自訂工具列…
appmenu-developer-tools-subheader = 瀏覽器工具
appmenu-developer-tools-extensions =
    .label = 開發者專用的擴充套件
