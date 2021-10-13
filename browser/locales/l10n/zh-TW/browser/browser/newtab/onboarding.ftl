# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = 歡迎使用 { -brand-short-name }
onboarding-start-browsing-button-label = 開始瀏覽
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

## Multistage onboarding strings (about:welcome pages)

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
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = 一切從這裡開始
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — 家具設計師、Waterfox 粉絲
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = 關閉動畫

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] 將 { -brand-short-name } 保留在您的 Dock，方便快速使用
       *[other] 將 { -brand-short-name } 釘選到您的工作列，方便快速使用
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] 保留在 Dock
       *[other] 釘選到工作列
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = 開始使用
mr1-onboarding-welcome-header = 歡迎使用 { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = 將 { -brand-short-name } 設為我的主要瀏覽器
    .title = 將 { -brand-short-name } 設為預設瀏覽器，並釘選到工作列
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = 將 { -brand-short-name } 設為我的預設瀏覽器
mr1-onboarding-set-default-secondary-button-label = 暫時不要
mr1-onboarding-sign-in-button-label = 登入

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = 將 { -brand-short-name } 設為您的預設瀏覽器
mr1-onboarding-default-subtitle = 開啟速度、安全性、隱私權的自動保護。
mr1-onboarding-default-primary-button-label = 設為預設瀏覽器

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = 資料隨身攜帶
mr1-onboarding-import-subtitle =
    匯入您的密碼、書籤<br/>
    與更多資料。
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = 從 { $previous } 匯入
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = 從先前使用的瀏覽器匯入
mr1-onboarding-import-secondary-button-label = 現在不要
mr2-onboarding-colorway-header = 美麗生活
mr2-onboarding-colorway-subtitle = 活力滿點的新配色，限時提供。
mr2-onboarding-colorway-primary-button-label = 儲存配色
mr2-onboarding-colorway-secondary-button-label = 現在不要
mr2-onboarding-colorway-label-soft = 軟色調
mr2-onboarding-colorway-label-balanced = 均衡色調
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = 濃烈色調
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = 自動
# This string will be used for Default theme
mr2-onboarding-theme-label-default = 預設
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
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = 使用這套配色。
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = 使用這套配色。
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = 探索 { $colorwayName } 的配色。
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = 探索 { $colorwayName } 的配色。
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = 探索預設佈景主題。
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = 探索預設佈景主題。

## Strings for Thank You page

mr2-onboarding-thank-you-header = 感謝您選用
mr2-onboarding-thank-you-text = { -brand-short-name } 是一套由非營利組織所打造的獨立瀏覽器。由我們一起讓網路環境更安全、更健康、也更有隱私。
mr2-onboarding-start-browsing-button-label = 開始上網
