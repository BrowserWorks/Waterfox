# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
       *[other] 過去一週中，{ -brand-short-name } 封鎖了 { $count } 組追蹤器
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
       *[other] 自 { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }起，封鎖了 <b>{ $count }</b> 組追蹤器
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } 會繼續在隱私瀏覽視窗當中封鎖追蹤器，但不會對封鎖的項目留下紀錄。
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = { -brand-short-name } 本週封鎖的追蹤器

protection-report-webpage-title = 保護資訊儀錶板
protection-report-page-content-title = 保護資訊儀錶板
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = 當您上網時，{ -brand-short-name } 可在背景保護您的隱私。以下是這些保護的個人摘要，以及能夠用來保護線上安全性的各種工具。
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = 當您上網時，{ -brand-short-name } 可在背景保護您的隱私。以下是這些保護的個人摘要，以及能夠用來保護線上安全性的各種工具。

protection-report-settings-link = 管理您的隱私權與安全性設定

etp-card-title-always = 加強型追蹤保護: 總是開啟
etp-card-title-custom-not-blocking = 加強型追蹤保護: 關閉
etp-card-content-description = { -brand-short-name } 會自動封鎖讓大企業在網路上偷偷跟蹤您的程式。
protection-report-etp-card-content-custom-not-blocking = 目前已關閉所有保護。請調整 { -brand-short-name } 保護設定，決定要封鎖哪些類型的追蹤器。
protection-report-manage-protections = 管理設定

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = 今天

# This string is used to describe the graph for screenreader users.
graph-legend-description = 在這一週當中封鎖的各類型追蹤器的總數圖表

social-tab-title = 社交媒體追蹤器
social-tab-contant = 社群網站會在其他網站放置追蹤器，以追蹤您除了在社群網站分享的東西之外，還在網路上做了或看了什麼，更加了解您的一舉一動。<a data-l10n-name="learn-more-link">了解更多</a>

cookie-tab-title = 跨網站追蹤 Cookie
cookie-tab-content = 一些第三方廣告商或分析公司，會設定這些 Cookie 在不同網站間跟蹤您，收集您的上網紀錄。封鎖這些跨網站 Cookie 可減少在網路上跟蹤您的廣告。<a data-l10n-name="learn-more-link">了解更多</a>

tracker-tab-title = 追蹤用內容
tracker-tab-description = 網站中可能會有包含追蹤碼的外部廣告、影片或其他內容。封鎖追蹤內容可以讓網站更快載入，但某些按鈕、表單、登入欄位可能無法正常運作。<a data-l10n-name="learn-more-link">了解更多</a>

fingerprinter-tab-title = 數位指紋追蹤程式
fingerprinter-tab-content = 數位指紋追蹤程式會針對您的瀏覽器、電腦設定來建立您的獨特輪廓，並在不同網站間追蹤您。<a data-l10n-name="learn-more-link">了解更多</a>

cryptominer-tab-title = 加密貨幣採礦程式
cryptominer-tab-content = 加密貨幣採礦程式會使用您電腦的運算能力來對數位貨幣「採礦」，消耗您的電腦電力、拖慢系統效能、增加電費支出。<a data-l10n-name="learn-more-link">了解更多</a>

protections-close-button2 =
    .aria-label = 關閉
    .title = 關閉
  
mobile-app-title = 在更多裝置上也能封鎖廣告追蹤器
mobile-app-card-content = 使用內建廣告追蹤保護的行動瀏覽器
mobile-app-links = { -brand-product-name } 瀏覽器 <a data-l10n-name="android-mobile-inline-link">Android</a> 版與 <a data-l10n-name="ios-mobile-inline-link">iOS</a> 版

lockwise-title = 不再忘記密碼
lockwise-title-logged-in2 = 密碼管理
lockwise-header-content = { -lockwise-brand-name } 會安全地在您的瀏覽器中儲存密碼。
lockwise-header-content-logged-in = 安全地儲存密碼，並同步到您的所有裝置中。
protection-report-save-passwords-button = 儲存密碼
    .title = 將密碼儲存到 { -lockwise-brand-short-name }
protection-report-manage-passwords-button = 管理密碼
    .title = 用 { -lockwise-brand-short-name } 管理密碼
lockwise-mobile-app-title = 密碼隨身帶著走
lockwise-no-logins-card-content = 在任何裝置上使用儲存到 { -brand-short-name } 的密碼。
lockwise-app-links = <a data-l10n-name="lockwise-android-inline-link">Android</a> 與 <a data-l10n-name="lockwise-ios-inline-link">iOS</a> 版的 { -lockwise-brand-name }

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
       *[other] 有 { $count } 組密碼可能在資料外洩事件中洩漏。
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
       *[other] 您的 { $count } 組密碼都已經安全地儲存下來。
    }
lockwise-how-it-works-link = 原理是什麼

turn-on-sync = 開啟 { -sync-brand-short-name }…
    .title = 前往同步偏好設定

monitor-title = 檢查是否發生資料外洩事件
monitor-link = 原理是什麼
monitor-header-content-no-account = 使用 { -monitor-brand-name } 檢查您是否處於已知的資料外洩事件之中，並在有新事件發生時收到通知。
monitor-header-content-signed-in = 若您的資訊出現在已知的資料外洩事件中，{ -monitor-brand-name } 將警告您。
monitor-sign-up-link = 訂閱資料外洩警報
    .title = 到 { -monitor-brand-name } 訂閱資料外洩警報
auto-scan = 今天自動掃描過

monitor-emails-tooltip =
    .title = 到 { -monitor-brand-short-name } 檢視進行監控的電子郵件信箱
monitor-breaches-tooltip =
    .title = 到 { -monitor-brand-short-name } 檢視已知的資料外洩事件
monitor-passwords-tooltip =
    .title = 到 { -monitor-brand-short-name } 檢視已遭洩露的密碼

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
       *[other] 組監控中的電子郵件信箱地址
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
       *[other] 場資料外洩事件，流出了您的個資
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
       *[other] 標示為已解決的資料外洩事件數
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
       *[other] 所有事件中洩漏出的密碼組數
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
       *[other] 尚未處理的事件中，洩漏出的密碼組數
    }

monitor-no-breaches-title = 好消息！
monitor-no-breaches-description = 還沒有遇到已知的資料外洩事件。有新事件發生時我們會通知您。
monitor-view-report-link = 檢視報告
    .title = 到 { -monitor-brand-short-name } 處理資料外洩事件
monitor-breaches-unresolved-title = 處理遇到的資料外洩事件
monitor-breaches-unresolved-description = 確認事件詳細資訊並採取行動保護自己的資料後，就可以將事件標示為「已處理」。
monitor-manage-breaches-link = 管理資料外洩事件
    .title = 到 { -monitor-brand-short-name } 管理資料外洩事件
monitor-breaches-resolved-title = 真棒！所有已知的資料外洩事件都處理完了。
monitor-breaches-resolved-description = 若您的信箱出現在新的資料外洩事件，我們會通知您。

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] 已處理 { $numBreachesResolved } 場事件，共 { $numBreaches } 場
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = 完成 { $percentageResolved }%

monitor-partial-breaches-motivation-title-start = 好的開始！
monitor-partial-breaches-motivation-title-middle = 繼續保持！
monitor-partial-breaches-motivation-title-end = 快完成了，繼續保持！
monitor-partial-breaches-motivation-description = 到 { -monitor-brand-short-name } 處理其他的資料外洩事件。
monitor-resolve-breaches-link = 處理資料外洩事件
    .title = 到 { -monitor-brand-short-name } 處理資料外洩事件

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = 社交媒體追蹤器
    .aria-label =
        { $count ->
           *[other] { $count } 組社交媒體追蹤器（{ $percentage }%）
        }
bar-tooltip-cookie =
    .title = 跨網站追蹤 Cookie
    .aria-label =
        { $count ->
           *[other] { $count } 組跨網站追蹤 Cookie（{ $percentage }%）
        }
bar-tooltip-tracker =
    .title = 追蹤用內容
    .aria-label =
        { $count ->
           *[other] { $count } 組追蹤用內容（{ $percentage }%）
        }
bar-tooltip-fingerprinter =
    .title = 數位指紋追蹤程式
    .aria-label =
        { $count ->
           *[other] { $count } 組數位指紋追蹤程式（{ $percentage }%）
        }
bar-tooltip-cryptominer =
    .title = 加密貨幣採礦程式
    .aria-label =
        { $count ->
           *[other] { $count } 組加密貨幣採礦程式（{ $percentage }%）
        }
