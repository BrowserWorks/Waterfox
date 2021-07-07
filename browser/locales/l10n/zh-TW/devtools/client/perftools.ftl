# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Profiler 設定
perftools-intro-description = 記錄過程將在新分頁開啟 profiler.firefox.com。所有資料都儲存在您的本機上，但您可以決定是否要上傳分享。

## All of the headings for the various sections.

perftools-heading-settings = 完整設定
perftools-heading-buffer = 緩衝區設定
perftools-heading-features = 功能
perftools-heading-features-default = 功能（預設推薦開啟）
perftools-heading-features-disabled = 已停用的功能
perftools-heading-features-experimental = 實驗中
perftools-heading-threads = 執行緒
perftools-heading-local-build = 本機編譯版本

##

perftools-description-intro = 記錄過程將在新分頁開啟 <a>profiler.firefox.com</a>。所有資料都儲存在您的本機上，但您可以決定是否要上傳分享。
perftools-description-local-build = 若您使用這台電腦上自行編譯的版本進行測量，請將編譯出的目的碼路徑（objdir）放到下方清單，以用於查詢除錯符號資訊。

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = 取樣間隔:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = 緩衝區大小:
perftools-custom-threads-label = 依照名稱新增自訂執行緒:
perftools-devtools-interval-label = 間隔:
perftools-devtools-threads-label = 執行緒:
perftools-devtools-settings-label = 設定

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    開啟隱私瀏覽視窗後，將停用 Profiler。
    請關閉所有隱私瀏覽視窗，即可重新啟用 profiler
perftools-status-recording-stopped-by-another-tool = 已被其他工具停止記錄。
perftools-status-restart-required = 必須重新啟動瀏覽器才能啟用此功能。

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = 正在停止記錄
perftools-request-to-get-profile-and-stop-profiler = 正在捕捉效能記錄

##

perftools-button-start-recording = 開始記錄
perftools-button-capture-recording = 正在捕捉記錄
perftools-button-cancel-recording = 取消記錄
perftools-button-save-settings = 儲存設定並返回
perftools-button-restart = 重新啟動
perftools-button-add-directory = 新增目錄
perftools-button-remove-directory = 移除選擇項目
perftools-button-edit-settings = 編輯設定值…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = 父程序與內容程序等主要處理程序
perftools-thread-compositor =
    .title = 將頁面中各種已繪製好的元素合成在一起
perftools-thread-dom-worker =
    .title = 此執行緒用來處理 web worker 與 service worker
perftools-thread-renderer =
    .title = 開啟 WebRender 時，用來執行 OpenGL 呼叫的執行緒
perftools-thread-render-backend =
    .title = WebRender 的 RenderBackend 執行緒
perftools-thread-paint-worker =
    .title = 開啟非主執行緒繪製（off-main-thread painting）時，進行繪製的執行緒
perftools-thread-style-thread =
    .title = 樣式計算會拆分於多個執行緒中進行
pref-thread-stream-trans =
    .title = 網路資料流傳輸
perftools-thread-socket-thread =
    .title = 若網路相關程式進行任何 blocking socket 呼叫時，將發生於此執行緒
perftools-thread-img-decoder =
    .title = 圖片解碼執行緒
perftools-thread-dns-resolver =
    .title = DNS 解析會發生在此執行緒
perftools-thread-js-helper =
    .title = JS 引擎的背景工作，例如非主執行緒編譯（off-main-thread compile）

##

perftools-record-all-registered-threads = 忽略上面選擇的項目，記錄所有註冊的執行緒
perftools-tools-threads-input-label =
    .title = 下列執行緒名稱是要在 Profiler 當中測量效能的清單（用逗號分隔）。名稱必須與要列入測量的執行緒名稱部分符合，是否有空白視為不同。

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

-profiler-brand-name = Firefox Profiler
perftools-onboarding-message = <b>全新</b>: 現在起，已將 { -profiler-brand-name } 整合進開發者工具。了解這個全新強大工具的<a>更多資訊</a>。
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = （短時間內您還是可以透過<a>{ options-context-advanced-settings }</a>使用原本的效能面板）
perftools-onboarding-close-button =
    .aria-label = 關閉功能介紹訊息
