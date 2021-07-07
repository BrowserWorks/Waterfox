# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = 了解更多
onboarding-button-label-get-started = 開始使用

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = 歡迎使用 { -brand-short-name }
onboarding-welcome-body = 瀏覽器安裝完成。<br/>了解 { -brand-product-name } 的其他功能。
onboarding-welcome-learn-more = 了解更多好處。
onboarding-welcome-modal-get-body = 瀏覽器安裝完成。<br/>了解 { -brand-product-name } 的其他功能。
onboarding-welcome-modal-supercharge-body = 加強對您的隱私保護。
onboarding-welcome-modal-privacy-body = 瀏覽器安裝完成。現在讓我們加入更多隱私保護。
onboarding-welcome-modal-family-learn-more = 了解 { -brand-product-name } 的系列產品。
onboarding-welcome-form-header = 從這裡開始
onboarding-join-form-body = 在此輸入您的電子郵件信箱，即可開始使用。
onboarding-join-form-email =
    .placeholder = 輸入電子郵件信箱
onboarding-join-form-email-error = 請輸入有效的電子郵件信箱
onboarding-join-form-legal = 繼續使用，代表您同意我們的<a data-l10n-name="terms">使用條款</a>及<a data-l10n-name="privacy">隱私權公告</a>。
onboarding-join-form-continue = 繼續
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = 已經有帳號了嗎？
# Text for link to submit the sign in form
onboarding-join-form-signin = 登入
onboarding-start-browsing-button-label = 開始瀏覽
onboarding-cards-dismiss =
    .title = 隱藏
    .aria-label = 隱藏

## Welcome full page string

onboarding-fullpage-welcome-subheader = 讓我們探索還能做哪些事。
onboarding-fullpage-form-email =
    .placeholder = 您的電子郵件地址…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name } 隨身帶著走
onboarding-sync-welcome-content = 在您的各種裝置上同步書籤、瀏覽紀錄、登入資訊及其他設定。
onboarding-sync-welcome-learn-more-link = 了解 Firefox Accounts 的更多資訊
onboarding-sync-form-input =
    .placeholder = 電子郵件
onboarding-sync-form-continue-button = 繼續
onboarding-sync-form-skip-login-button = 跳過這步

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = 輸入您的電子郵件地址
onboarding-sync-form-sub-header = 繼續前往 { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = 使用各種尊重您隱私的小工具，更快達成任務。
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = 我們作的任何事情，都符合我們對個人資料隱私的承諾: 能少拿就少拿、確保資料安全、絕不偷偷來。
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = 在任何使用 { -brand-product-name } 的地方同步書籤、密碼、上網紀錄與更多資料。
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = 在您的個人資料出現在資料外洩事件時獲得通知。
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = 以安全又可隨身攜帶的方式，管理您的網站密碼。

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = 保護您不受追蹤
onboarding-tracking-protection-text2 = { -brand-short-name } 可幫助防止網站在線上追蹤，讓廣告更難追著你。
onboarding-tracking-protection-button2 = 原理是什麼
onboarding-data-sync-title = 把設定隨身帶著走
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = 在任何使用 { -brand-product-name } 的地方同步書籤、密碼等資料。
onboarding-data-sync-button2 = 登入 { -sync-brand-short-name }
onboarding-firefox-monitor-title = 小心資料外洩！
onboarding-firefox-monitor-text2 = { -monitor-brand-name } 會監控您的 E-Mail 是否出現在資料外洩事故中，並且在有新事故時通知您。
onboarding-firefox-monitor-button = 訂閱帳號資料外洩警報
onboarding-browse-privately-title = 私密上網
onboarding-browse-privately-text = 隱私瀏覽模式會自動清除您的搜尋與上網紀錄，讓這台電腦的其他使用者無法得知您的上網紀錄。
onboarding-browse-privately-button = 開啟隱私視窗
onboarding-firefox-send-title = 以私密的方式分享檔案
onboarding-firefox-send-text2 = 上傳您的檔案到 { -send-brand-name }，即可透過點對點加密與會自動失效的鏈結來進行分享。
onboarding-firefox-send-button = 試用 { -send-brand-name }
onboarding-mobile-phone-title = 取得手機版的 { -brand-product-name }
onboarding-mobile-phone-text = 下載 { -brand-product-name } for iOS 或 Android，即可在您的不同裝置間同步資料。
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = 下載行動瀏覽器
onboarding-send-tabs-title = 即時發送分頁給自己
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = 輕鬆地在您的各個裝置間分享網頁，不需要複製網址或離開瀏覽器。
onboarding-send-tabs-button = 開始使用 Send Tabs
onboarding-pocket-anywhere-title = 隨處閱讀隨處聽
onboarding-pocket-anywhere-text2 = 可使用 { -pocket-brand-name } 將您最愛的文章儲存下來，這樣就可以在有空的時候閱讀、聆聽或觀賞，就算離線也沒問題。
onboarding-pocket-anywhere-button = 試用 { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = 建立並儲存強密碼
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } 可直接在網頁表單中建立強密碼，並且儲存在同一個地方，方便使用。
onboarding-lockwise-strong-passwords-button = 管理您的登入資訊
onboarding-facebook-container-title = 為 Facebook 設定邊界
onboarding-facebook-container-text2 = { -facebook-container-brand-name } 可將您的 Facebook 身分隔絕於其他網站之外，使其更難在網路上追蹤您。
onboarding-facebook-container-button = 安裝擴充套件
onboarding-import-browser-settings-title = 匯入您的書籤、密碼與更多資料
onboarding-import-browser-settings-text = 別猶豫—馬上把您的 Chrome 網站資料與設定匯入進來。
onboarding-import-browser-settings-button = 匯入 Chrome 資料
onboarding-personal-data-promise-title = 從設計就保護隱私
onboarding-personal-data-promise-text = { -brand-product-name } 尊重您的資料，能少拿就少拿、盡力保護，並且明確說明我們會如何使用。
onboarding-personal-data-promise-button = 閱讀我們的承諾

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = 恭喜，您已經安裝好 { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = 現在來安裝 <icon></icon><b>{ $addon-name }</b> 吧。
return-to-amo-extension-button = 安裝擴充套件
return-to-amo-get-started-button = { -brand-short-name } 使用入門
onboarding-not-now-button-label = 現在不要

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = 恭喜，您已經安裝好 { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = 現在來安裝 <img data-l10n-name="icon"/><b>{ $addon-name }</b> 吧。
return-to-amo-add-extension-label = 安裝擴充套件

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = 歡迎使用 <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = 由非營利組織全力相挺，又快又安全，還更有隱私保障的瀏覽器。
onboarding-multistage-welcome-primary-button-label = 開始設定
onboarding-multistage-welcome-secondary-button-label = 登入
onboarding-multistage-welcome-secondary-button-text = 已經有帳號了？
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = 將 { -brand-short-name } 設為您的<span data-l10n-name="zap">預設瀏覽器</span>
onboarding-multistage-set-default-subtitle = 隨時上網都有最快速度、安全與隱私保護。
onboarding-multistage-set-default-primary-button-label = 設為預設瀏覽器
onboarding-multistage-set-default-secondary-button-label = 現在不要
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = 滑鼠輕鬆點擊幾下，即可開始使用 <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-pin-default-subtitle = 每次上網時，都能保持快速、安全又有隱私的瀏覽體驗。
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = 開啟設定畫面後，在「網頁瀏覽器」下選擇 { -brand-short-name }
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = 將把 { -brand-short-name } 釘選到工作列並開啟設定畫面
onboarding-multistage-pin-default-primary-button-label = 將 { -brand-short-name } 設為我的預設瀏覽器
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = 匯入您的密碼、書籤與<span data-l10n-name="zap">更多資料</span>
onboarding-multistage-import-subtitle = 從其他瀏覽器過來使用？很簡單就能把所有東西都帶來 { -brand-short-name }。
onboarding-multistage-import-primary-button-label = 開始匯入
onboarding-multistage-import-secondary-button-label = 現在不要
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = 在此裝置找到下列網站。除非您決定要匯入網站資料，否則 { -brand-short-name } 並不會儲存或同步另一套瀏覽器上的資料。
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = 開始使用: 第 { $current } 畫面，全部共 { $total } 畫面
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = 挑選一種<span data-l10n-name="zap">風格</span>
onboarding-multistage-theme-subtitle = 使用佈景主題，讓 { -brand-short-name } 有您的風格
onboarding-multistage-theme-primary-button-label2 = 完成
onboarding-multistage-theme-secondary-button-label = 現在不要
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = 自動
onboarding-multistage-theme-label-light = 亮色
onboarding-multistage-theme-label-dark = 暗色
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = 根據作業系統設定來顯示按鈕、選單、視窗的外觀。
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = 根據作業系統設定來顯示按鈕、選單、視窗的外觀。
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = 使用亮色按鈕、選單、視窗樣式。
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = 使用亮色按鈕、選單、視窗樣式。
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = 使用暗色按鈕、選單、視窗樣式。
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = 使用暗色按鈕、選單、視窗樣式。
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = 使用色彩繽紛的按鈕、選單、視窗樣式。
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = 使用色彩繽紛的按鈕、選單、視窗樣式。

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Firefox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = 一切從這裡開始
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — 家具設計師、Firefox 粉絲
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = 關閉動畫

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] 將 { -brand-short-name } 保留在您的 Dock，方便快速使用
       *[other] 將 { -brand-short-name } 釘選到您的工作列，方便快速使用
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] 保留在 Dock
       *[other] 釘選到工作列
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = 開始使用
mr1-onboarding-welcome-header = 歡迎使用 { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = 將 { -brand-short-name } 設為我的主要瀏覽器
    .title = 將 { -brand-short-name } 設為預設瀏覽器，並釘選到工作列
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = 將 { -brand-short-name } 設為我的預設瀏覽器
mr1-onboarding-set-default-secondary-button-label = 暫時不要
mr1-onboarding-sign-in-button-label = 登入

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = 將 { -brand-short-name } 設為您的預設瀏覽器
mr1-onboarding-default-subtitle = 開啟速度、安全性、隱私權的自動保護。
mr1-onboarding-default-primary-button-label = 設為預設瀏覽器

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = 隨身攜帶
mr1-onboarding-import-subtitle =
    匯入您的密碼、書籤<br/>
    與更多資料。
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = 從 { $previous } 匯入
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = 從先前使用的瀏覽器匯入
mr1-onboarding-import-secondary-button-label = 現在不要
mr1-onboarding-theme-header = 有您的風格
mr1-onboarding-theme-subtitle = 使用佈景主題，讓 { -brand-short-name } 有您的風格
mr1-onboarding-theme-primary-button-label = 儲存佈景主題
mr1-onboarding-theme-secondary-button-label = 現在不要
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = 系統佈景主題
mr1-onboarding-theme-label-light = 亮色
mr1-onboarding-theme-label-dark = 暗色
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        依照作業系統的佈景主題設定來顯示
        按鈕、選單、視窗的外觀。
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        依照作業系統的佈景主題設定來顯示
        按鈕、選單、視窗的外觀。
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title = 使用亮色按鈕、選單、視窗佈景主題。
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description = 使用亮色按鈕、選單、視窗佈景主題。
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title = 使用暗色按鈕、選單、視窗佈景主題。
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description = 使用暗色按鈕、選單、視窗佈景主題。
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title = 使用色彩繽紛的按鈕、選單、視窗佈景主題。
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description = 使用色彩繽紛的按鈕、選單、視窗佈景主題。
