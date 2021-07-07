# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping 資料來源:
about-telemetry-show-current-data = 目前的資料
about-telemetry-show-archived-ping-data = 已封存的 ping 資料
about-telemetry-show-subsession-data = 顯示 subsession 資料
about-telemetry-choose-ping = 選擇 ping:
about-telemetry-archive-ping-type = Ping 類型
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = 今天
about-telemetry-option-group-yesterday = 昨天
about-telemetry-option-group-older = 較舊
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetry 資料
about-telemetry-current-store = 目前的儲存區:
about-telemetry-more-information = 想了解更多嗎？
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> 當中描述了我們使用資料工具的方式。
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetry 客戶端文件</a>當中包含資料收集概念、API 文件以及資料格式的參考資料。
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetry 儀錶板</a>讓您可將 Mozilla 透過 Telemetry 收集到的資料以視覺化的方式呈現。
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> 當中提供 Telemetry 所收集的探測資料的詳細資訊與說明。
about-telemetry-show-in-Firefox-json-viewer = 用 JSON 檢視器開啟
about-telemetry-home-section = 首頁
about-telemetry-general-data-section = 一般資料
about-telemetry-environment-data-section = 環境資料
about-telemetry-session-info-section = 使用階段資訊
about-telemetry-scalar-section = Scalars
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = 柱狀圖
about-telemetry-keyed-histogram-section = 分類柱狀圖
about-telemetry-events-section = 事件
about-telemetry-simple-measurements-section = 簡易測量
about-telemetry-slow-sql-section = 慢速的 SQL 陳述句
about-telemetry-addon-details-section = 附加元件詳情
about-telemetry-captured-stacks-section = 捕捉到的堆疊
about-telemetry-late-writes-section = 慢速寫入
about-telemetry-raw-payload-section = 原始酬載
about-telemetry-raw = 原始 JSON
about-telemetry-full-sql-warning = 註: 已開啟慢速 SQL 除錯。將在下面顯示完整 SQL 字串，但不會送出到 Telemetry。
about-telemetry-fetch-stack-symbols = 取得堆疊的函數名稱
about-telemetry-hide-stack-symbols = 顯示原始堆疊資料
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] 正式版資料
       *[prerelease] 預先發行版資料
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] 開啟
       *[disabled] 關閉
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
       *[other] { $sampleCount } 個樣本、平均 = { $prettyAverage }、加總 = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = 此頁面顯示 Telemetry 所收集到效能、硬體設定、使用程度、以及自訂選項的相關資訊。此資訊將會傳送到 { $telemetryServerOwner } 以幫助改善 { -brand-full-name }。
about-telemetry-settings-explanation = Telemetry 正在收集{ about-telemetry-data-type }，已<a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>上傳。
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = 每組資訊將集合在「<a data-l10n-name="ping-link">pings</a>」送出，您正在看的是 { $name }, { $timestamp } ping。
about-telemetry-data-details-current = 每組資訊將集合在「<a data-l10n-name="ping-link">pings</a>」送出，您正在看的是目前的資料。
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = 在 { $selectedTitle } 中尋找
about-telemetry-filter-all-placeholder =
    .placeholder = 在所有段落中尋找
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = 「{ $searchTerms }」的搜尋結果
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = 抱歉！{ $sectionName } 當中沒有「{ $currentSearchText }」的結果
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = 抱歉！所有段落中都沒有「{ $searchTerms }」的搜尋結果。
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = 抱歉！目前沒有「{ $sectionName }」的資料。
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = 目前的資料
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = 全部
# button label to copy the histogram
about-telemetry-histogram-copy = 複製
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = 主要執行緒上的慢速 SQL 陳述式
about-telemetry-slow-sql-other = Helper 執行緒中的慢速 SQL 陳述句
about-telemetry-slow-sql-hits = 數量
about-telemetry-slow-sql-average = 平均時間 (ms)
about-telemetry-slow-sql-statement = 陳述句
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = 附加元件 ID
about-telemetry-addon-table-details = 詳細資訊
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } 提供者
about-telemetry-keys-header = 屬性
about-telemetry-names-header = 名稱
about-telemetry-values-header = 值
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey }（捕捉到的數量: { $capturedStacksCount }）
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = 慢速寫入 #{ $lateWriteCount }
about-telemetry-stack-title = 堆疊:
about-telemetry-memory-map-title = 記憶體地圖:
about-telemetry-error-fetching-symbols = 取回符號時發生錯誤。請確定您已連線到網路並再試一次。
about-telemetry-time-stamp-header = 時間戳記
about-telemetry-category-header = 分類
about-telemetry-method-header = 方法
about-telemetry-object-header = 物件
about-telemetry-extra-header = 更多
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = 來源
about-telemetry-origin-count = 數量
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> 會在送出資料前為資料編碼，這樣 { $telemetryServerOwner } 才可以計數，但不知道是由哪一套 { -brand-product-name } 所送出的資料。（<a data-l10n-name="prio-blog-link">了解更多資訊</a>）
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } 處理程序
