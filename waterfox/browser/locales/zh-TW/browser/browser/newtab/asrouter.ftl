# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = 推薦擴充套件
cfr-doorhanger-feature-heading = 推薦功能

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = 為什麼我會看到這個？
cfr-doorhanger-extension-cancel-button = 現在不要
    .accesskey = N
cfr-doorhanger-extension-ok-button = 立刻新增
    .accesskey = A
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

## Waterfox Accounts Message

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
cfr-whatsnew-release-notes-link-text = 閱讀發行公告

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] 自 { DATETIME($date, month: "long", year: "numeric") } 起，{ -brand-short-name } 已封鎖超過 <b>{ $blockedCount }</b> 組追蹤器！
    }
cfr-doorhanger-milestone-ok-button = 檢視全部
    .accesskey = S
cfr-doorhanger-milestone-close-button = 關閉
    .accesskey = C

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

## Full Video Support CFR message

cfr-doorhanger-video-support-body = 此網站上的影片可能無法於這個版本的 { -brand-short-name } 正常播放。若需完整支援影片播放，請更新 { -brand-short-name }。
cfr-doorhanger-video-support-header = 更新 { -brand-short-name } 來播放影片
cfr-doorhanger-video-support-primary-button = 立即更新
    .accesskey = U

## Spotlight modal shared strings

spotlight-learn-more-collapsed = 了解更多
    .title = 展開即可了解此功能的更多資訊
spotlight-learn-more-expanded = 了解更多
    .title = 關閉

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = 看來您正使用的是公共 Wi-Fi
spotlight-public-wifi-vpn-body = VPN 可幫助您在公共場所（例如機場、咖啡廳等）上網時，隱藏您的實際所在位置與上網行為紀錄，請考慮使用。
spotlight-public-wifi-vpn-primary-button = 使用 { -mozilla-vpn-brand-name } 保持隱私
    .accesskey = S
spotlight-public-wifi-vpn-link = 現在不要
    .accesskey = N

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header = 試用我們有史以來最強大的隱私保護功能
spotlight-total-cookie-protection-body = 「全方位 Cookie 保護」功能可防止追蹤器透過 Cookie 在網路上追蹤您。
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } 會將 Cookie 包圍起來，讓它們僅能在您所在的網站使用，這樣追蹤器就無法用它們來追蹤您。透過搶先試用，您可以協助我們最佳化這個功能，持續為每個人打造更好的網路環境。
spotlight-total-cookie-protection-primary-button = 開啟「全方位 Cookie 保護」功能
spotlight-total-cookie-protection-secondary-button = 現在不要
cfr-total-cookie-protection-header = 感謝您的協助，讓 { -brand-short-name } 比以往更安全、更能保護隱私
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = 「全方位 Cookie 保護」功能是我們迄今最強大的隱私權保護功能，也是對所有 { -brand-short-name } 使用者都預設開啟的選項。若沒有像您這樣的早期使用者協助使用測試，我們就無法推出此功能。所以非常感謝您協助我們一起打造一套更好、更能保護隱私的網路環境。

## Emotive Continuous Onboarding

spotlight-better-internet-header = 更好的網路環境，從您開始
spotlight-better-internet-body = 當您使用 { -brand-short-name } 就代表您對更好、更開放、任何人都可以使用的網路環境投下贊成票。
spotlight-peace-mind-header = 讓我們保護您
spotlight-peace-mind-body = 每個月，{ -brand-short-name } 平均能幫每位使用者封鎖超過 3,000 組追蹤器。為什麼要封鎖？這是因為沒有任何東西（尤其是像追蹤器這樣影響隱私權的東西）應該擋在您跟一個好的網路環境之間。
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] 固定在 Dock
       *[other] 釘選到工作列
    }
spotlight-pin-secondary-button = 現在不要
