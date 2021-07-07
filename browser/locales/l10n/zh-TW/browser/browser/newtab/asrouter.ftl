# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = 推薦擴充套件
cfr-doorhanger-feature-heading = 推薦功能
cfr-doorhanger-pintab-heading = 試試看: 釘選分頁

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = 為什麼我會看到這個？
cfr-doorhanger-extension-cancel-button = 現在不要
    .accesskey = N
cfr-doorhanger-extension-ok-button = 立刻新增
    .accesskey = A
cfr-doorhanger-pintab-ok-button = 釘選此分頁
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = 管理建議設定
    .accesskey = M
cfr-doorhanger-extension-never-show-recommendation = 不要告訴我這個建議
    .accesskey = S
cfr-doorhanger-extension-learn-more-link = 了解更多
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = 由 { $name } 開發
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = 推薦
cfr-doorhanger-extension-notification2 = 推薦
    .tooltiptext = 推薦擴充套件
    .a11y-announcement = 有推薦的擴充套件可以使用
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = 推薦
    .tooltiptext = 推薦功能
    .a11y-announcement = 有推薦的功能可以使用

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } 顆星
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } 使用者
    }
cfr-doorhanger-pintab-description = 快速開啟您最常使用的網站，就算是重新啟動後也將網站直接開啟於分頁中。

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = 對想要釘選的分頁<b>點擊滑鼠右鍵</b>。
cfr-doorhanger-pintab-step2 = 選擇<b>釘選分頁</b>。
cfr-doorhanger-pintab-step3 = 若網站有更新，會在釘選分頁上出現藍色點點。
cfr-doorhanger-pintab-animation-pause = 暫停
cfr-doorhanger-pintab-animation-resume = 恢復

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = 將您的書籤同步帶著走。
cfr-doorhanger-bookmark-fxa-body = 找到好網站了！接下來也把這筆書籤同步進手機吧。試試使用 { -fxaccount-brand-name }。
cfr-doorhanger-bookmark-fxa-link-text = 立即同步書籤…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = 關閉按鈕
    .title = 關閉

## Protections panel

cfr-protections-panel-header = 上網不被追蹤
cfr-protections-panel-body = 保留自己的資料。{ -brand-short-name } 不讓常見的追蹤器記錄您的上網行為。
cfr-protections-panel-link-text = 了解更多

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = 新功能:
cfr-whatsnew-button =
    .label = 有什麼新鮮事
    .tooltiptext = 有什麼新鮮事
cfr-whatsnew-panel-header = 有什麼新鮮事
cfr-whatsnew-release-notes-link-text = 閱讀發行公告
cfr-whatsnew-fx70-title = { -brand-short-name } 現在起為了您的隱私權更加努力
cfr-whatsnew-fx70-body = 最新版本當中加強了追蹤保護功能，也讓您更簡單就能針對各個網站產生安全的密碼。
cfr-whatsnew-tracking-protect-title = 保護自己，不被追蹤
cfr-whatsnew-tracking-protect-body = { -brand-short-name } 會封鎖許多在不同網站間追蹤您的常見社交型及跨網站追蹤器。
cfr-whatsnew-tracking-protect-link-text = 檢視您的追蹤報告
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
       *[other] 封鎖追蹤器
    }
cfr-whatsnew-tracking-blocked-subtitle = 自 { DATETIME($earliestDate, month: "long", year: "numeric") } 起
cfr-whatsnew-tracking-blocked-link-text = 檢視報告
cfr-whatsnew-lockwise-backup-title = 備份您的密碼
cfr-whatsnew-lockwise-backup-body = 可以為任何需要登入的網站產生安全密碼。
cfr-whatsnew-lockwise-backup-link-text = 開啟備份
cfr-whatsnew-lockwise-take-title = 密碼隨身帶著走
cfr-whatsnew-lockwise-take-body = { -lockwise-brand-short-name } 的行動 App 可讓您在任何地方安全地讀取備份下來的密碼。
cfr-whatsnew-lockwise-take-link-text = 下載 App

## Search Bar

cfr-whatsnew-searchbar-title = 使用網址列，打得更少，找得更多
cfr-whatsnew-searchbar-body-topsites = 現在只要選擇網址列，就會顯示包含熱門網站連結的方框。

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = 放大鏡圖示

## Picture-in-Picture

cfr-whatsnew-pip-header = 一邊上網一邊觀看影片
cfr-whatsnew-pip-body = 使用子母畫面功能將影片放到浮動視窗，邊看影片邊瀏覽其它分頁。
cfr-whatsnew-pip-cta = 了解更多

## Permission Prompt

cfr-whatsnew-permission-prompt-header = 減少討人厭的彈出視窗
cfr-whatsnew-permission-prompt-body = 現在起，{ -brand-shorter-name } 會自動封鎖網站詢問您是否可以傳送彈出訊息的請求。
cfr-whatsnew-permission-prompt-cta = 了解更多

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
       *[other] 封鎖數位指紋追蹤程式
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } 會封鎖許多偷偷收集裝置資訊與操作行為，以針對您建立廣告資料的數位指紋追蹤程式。
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = 數位指紋追蹤程式
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } 會封鎖偷偷收集裝置資訊與操作行為，以針對您建立廣告資料的數位指紋追蹤程式。

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = 在手機上使用此書籤
cfr-doorhanger-sync-bookmarks-body = 將您的書籤、密碼、瀏覽紀錄等資料，同步到登入 { -brand-product-name } 的所有裝置。
cfr-doorhanger-sync-bookmarks-ok-button = 開啟 { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = 不再搞丟密碼
cfr-doorhanger-sync-logins-body = 安全地儲存密碼，並同步到您的所有裝置中。
cfr-doorhanger-sync-logins-ok-button = 開啟 { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = 在通勤的時候閱讀這篇文章
cfr-doorhanger-send-tab-recipe-header = 把這個食譜帶進廚房
cfr-doorhanger-send-tab-body = Send Tab 可讓您很簡單就將連結分享到手機，或是任何登入 { -brand-product-name } 的裝置。
cfr-doorhanger-send-tab-ok-button = 試試分頁傳送功能
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = 安全地分享這份 PDF
cfr-doorhanger-firefox-send-body = 使用端對端加密，以及會在使用完之後自動消失的鏈結，來確保您敏感性文件的安全。
cfr-doorhanger-firefox-send-ok-button = 試用 { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = 請參考保護內容
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = 關閉
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = 不要再顯示類似的訊息
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } 防止社群網站在此追蹤您
cfr-doorhanger-socialtracking-description = 您的隱私相當重要。{ -brand-short-name } 現在起會封鎖常見的社交媒體追蹤器，限制這些網站收集您的線上活動。
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } 封鎖了此頁面上的數位指紋追蹤程式
cfr-doorhanger-fingerprinters-description = 您的隱私相當重要。{ -brand-short-name } 現在起會封鎖數位指紋追蹤程式，不讓這些程式為了追蹤您而收集可識別出所使用裝置的相關資訊。
cfr-doorhanger-cryptominers-heading = { -brand-short-name } 封鎖了此頁面上的加密貨幣採礦程式
cfr-doorhanger-cryptominers-description = 您的隱私相當重要。{ -brand-short-name } 現在起會封鎖加密貨幣採礦程式，不讓這些程式使用您的電腦運算能力來對數位貨幣「採礦」。

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] 從 { $date } 起，{ -brand-short-name } 已封鎖超過 <b>{ $blockedCount }</b> 組追蹤器！
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] 自 { DATETIME($date, month: "long", year: "numeric") } 起，{ -brand-short-name } 已封鎖超過 <b>{ $blockedCount }</b> 組追蹤器！
    }
cfr-doorhanger-milestone-ok-button = 檢視全部
    .accesskey = S

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = 輕鬆產生安全的密碼
cfr-whatsnew-lockwise-body = 要幫每個帳號都想到獨特而安全的密碼並不簡單。註冊帳號時，只要點擊密碼欄位，{ -brand-shorter-name } 就可以自動為您產生安全的密碼。
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } 圖示

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = 當發現密碼不安全時收到警報通知
cfr-whatsnew-passwords-body = 駭客知道人們會重複使用相同密碼。若您在多個網站重複使用同一組密碼，當任一個網站發生資料外洩時，就會收到 { -lockwise-brand-short-name } 的警報，提醒您要更改這些網站的密碼。
cfr-whatsnew-passwords-icon-alt = 不安全的密碼鑰匙圖示

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = 從子母畫面放大成全螢幕
cfr-whatsnew-pip-fullscreen-body = 當您將影片縮到子母畫面中播放時，只要雙擊該視窗就能用全螢幕播放。
cfr-whatsnew-pip-fullscreen-icon-alt = 子母畫面圖示

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = 關閉
    .accesskey = C

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = 保護項目，一目了然
cfr-whatsnew-protections-body = 保護資訊儀錶板當中包含了資料外洩事件與密碼管理的相關摘要報告。現在起您可以追蹤已經處理過幾場資料外洩事件，並且看看是否還有已遭外洩的密碼。
cfr-whatsnew-protections-cta-link = 檢視保護資訊儀錶板
cfr-whatsnew-protections-icon-alt = 盾牌圖示

## Better PDF message

cfr-whatsnew-better-pdf-header = 更好的 PDF 閱讀體驗
cfr-whatsnew-better-pdf-body = 現在可以直接在 { -brand-short-name } 直接開啟 PDF 文件，更輕鬆完成工作。

## DOH Message

cfr-doorhanger-doh-body = 您的隱私權相當重要。現在起，{ -brand-short-name } 會在您上網時，盡可能透過夥伴所提供的服務安全地進行 DNS 查詢，以保護您的隱私。
cfr-doorhanger-doh-header = 更安全、加密的 DNS 查詢
cfr-doorhanger-doh-primary-button-2 = 好的
    .accesskey = O
cfr-doorhanger-doh-secondary-button = 停用
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = 您的隱私權相當重要。{ -brand-short-name } 現在起會將您開啟的各個網站分別隔離於沙盒中，讓駭客更難偷到您的密碼、信用卡號、或其他敏感資訊。
cfr-doorhanger-fission-header = 網站隔離
cfr-doorhanger-fission-primary-button = 好，知道了
    .accesskey = O
cfr-doorhanger-fission-secondary-button = 了解更多
    .accesskey = L

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = 自動保護，不受隱蔽的手法追蹤
cfr-whatsnew-clear-cookies-body = 有些網站會將您重新導向到偷偷設定 Cookie 進行追蹤的網站。{ -brand-short-name } 現在起，會自動清除這些 Cookie 讓您不被追蹤。
cfr-whatsnew-clear-cookies-image-alt = 封鎖 Cookie 的插圖

## What's new: Media controls message

cfr-whatsnew-media-keys-header = 更多媒體控制元件
cfr-whatsnew-media-keys-body = 使用鍵盤或耳機直接播放或暫停播放影音內容，讓您更簡單就能從另一個分頁、另一套軟體，甚至是在電腦鎖定時就控制媒體播放。您也可以使用「上一首」或「下一首」按鍵直接切換曲目。
cfr-whatsnew-media-keys-button = 了解要怎麼做

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = 在網址列搜尋捷徑
cfr-whatsnew-search-shortcuts-body = 現在起，當您在網址列輸入搜尋引擎名稱或特定網址時，將於搜尋建議的下方顯示藍色捷徑。選擇該捷徑即可直接從網址列完成搜尋。

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = 防止有害的超級 Cookie 追蹤
cfr-whatsnew-supercookies-body = 某些網站會偷偷將「超級 Cookie」插入到瀏覽器，在網路上到處跟著您，就算清理掉一般 Cookie 後也無法清除。{ -brand-short-name } 現在起會針對超級 Cookie 加強保護，不讓它們被用來追蹤您的線上活動。

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = 書籤功能更完善
cfr-whatsnew-bookmarking-body = 很簡單就能追蹤您最愛的網站。{ -brand-short-name } 現在起會記住您儲存書籤的偏好位置、在新分頁預設顯示書籤工具列，並且讓您透過工具列中的資料夾快速開啟其他書籤。

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = 全面保護您不受跨網站 Cookie 追蹤
cfr-whatsnew-cross-site-tracking-body = 現在起，您可以選擇開啟更強大的保護功能，保護您不被 Cookie 追蹤。{ -brand-short-name } 可分別隔離您在不同網站上的行為與資料，讓資料不會在網站間流傳。

## Full Video Support CFR message

cfr-doorhanger-video-support-body = 此網站上的影片可能無法於這個版本的 { -brand-short-name } 正常播放。若需完整支援影片播放，請更新 { -brand-short-name }。
cfr-doorhanger-video-support-header = 更新 { -brand-short-name } 來播放影片
cfr-doorhanger-video-support-primary-button = 立即更新
    .accesskey = U
