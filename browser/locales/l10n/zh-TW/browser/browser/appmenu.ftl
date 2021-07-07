# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = 正在下載 { -brand-shorter-name } 更新
    .label-update-available = 已推出更新 — 立即下載
    .label-update-manual = 已推出更新 — 立即下載
    .label-update-unsupported = 無法更新 — 系統不相容
    .label-update-restart = 已推出更新 — 立即重新啟動
appmenuitem-protection-dashboard-title = 保護資訊儀錶板
appmenuitem-customize-mode =
    .label = 自訂…

## Zoom Controls

appmenuitem-new-tab =
    .label = 開新分頁
appmenuitem-new-window =
    .label = 開新視窗
appmenuitem-new-private-window =
    .label = 開新隱私視窗
appmenuitem-passwords =
    .label = 密碼
appmenuitem-addons-and-themes =
    .label = 附加元件與佈景主題
appmenuitem-find-in-page =
    .label = 在頁面中搜尋…
appmenuitem-more-tools =
    .label = 更多工具
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

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = 立刻同步
appmenu-remote-tabs-sign-into-sync =
    .label = 登入進行同步…
appmenu-remote-tabs-turn-on-sync =
    .label = 開啟同步…
appmenuitem-fxa-toolbar-sync-now2 = 立刻同步
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
appmenu-fxa-show-more-tabs = 顯示更多分頁
appmenuitem-save-page =
    .label = 另存新檔…

## What's New panel in App menu.

whatsnew-panel-header = 有什麼新鮮事
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = 有新功能推出時通知我
    .accesskey = f

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = 揭露更多資訊
profiler-popup-description-title =
    .value = 紀錄、分析、分享
profiler-popup-description = 與您的團隊分享效能測量資訊，一同解決效能問題。
profiler-popup-learn-more = 了解更多
profiler-popup-settings =
    .value = 設定
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = 編輯設定值…
profiler-popup-disabled = Profiler 目前已停用，可能是因為開啟了隱私瀏覽視窗。
profiler-popup-recording-screen = 記錄中…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = 自訂
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
appmenu-help-feedback-page =
    .label = 送出意見回饋…
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
appmenu-taskmanager =
    .label = 工作管理員
appmenu-developer-tools-subheader = 瀏覽器工具
appmenu-developer-tools-extensions =
    .label = 開發者專用的擴充套件
