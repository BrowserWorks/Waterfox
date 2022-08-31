# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


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
return-to-amo-add-theme-label = 安裝佈景主題

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = 開始使用: 第 { $current } 畫面，全部共 { $total } 畫面

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = 進度：第 { $current } 步，共 { $total } 步
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
onboarding-theme-primary-button-label = 完成

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
mr2-onboarding-colorway-label = 探索 { $colorwayName } 的配色。
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = 探索預設佈景主題。
# Selector description for default themes
mr2-onboarding-default-theme-label = 探索預設佈景主題。

## Strings for Thank You page

mr2-onboarding-thank-you-header = 感謝您選用
mr2-onboarding-thank-you-text = { -brand-short-name } 是一套由非營利組織所打造的獨立瀏覽器。由我們一起讓網路環境更安全、更健康、也更有隱私。
mr2-onboarding-start-browsing-button-label = 開始上網

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = 選擇您的語言
mr2022-onboarding-live-language-text = { -brand-short-name } 會說您的語言
mr2022-language-mismatch-subtitle = 透過社群的努力，{ -brand-short-name } 已翻譯成超過 90 種語言版本。您的系統使用 { $systemLanguage }，而 { -brand-short-name } 則是 { $appLanguage } 版本。
onboarding-live-language-button-label-downloading = 正在下載 { $negotiatedLanguage } 的語言套件…
onboarding-live-language-waiting-button = 正在取得可用的語言清單…
onboarding-live-language-installing = 正在安裝 { $negotiatedLanguage } 的語言套件…
mr2022-onboarding-live-language-switch-to = 切換為 { $negotiatedLanguage } 版
mr2022-onboarding-live-language-continue-in = 以 { $appLanguage } 版繼續
onboarding-live-language-secondary-cancel-download = 取消
onboarding-live-language-skip-button-label = 略過

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    100 倍的
    感謝<span data-l10n-name="zap">您</span>
fx100-thank-you-subtitle = 這一版是我們的第 100 版！非常感謝您與我們一起打造更好、更健康的網路環境。
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] 將 { -brand-short-name } 保留在 Dock
       *[other] 將 { -brand-short-name } 釘選到工具列
    }
fx100-upgrade-thanks-header = 100 倍的感謝您
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = 這一版是 { -brand-short-name } 的第 100 版！非常感謝<em>您</em>與我們一起打造更好、更健康的網路環境。
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = 這一版是我們的第 100 版！非常感謝您參與我們的社群，只要點一下即可進入 { -brand-short-name } 的下一個 100 版旅程。
mr2022-onboarding-secondary-skip-button-label = 跳過這步

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = 探索驚人的網路世界
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = 只要輕鬆一點就可以從任何地方啟動 { -brand-short-name }。您每次這麼做的時候就是在選擇讓網路環境更加開放、獨立。
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] 將 { -brand-short-name } 保留在 Dock
       *[other] 將 { -brand-short-name } 釘選到工具列
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = 從非營利組織在背後開發的瀏覽器出發。我們會在您上網時捍衛您的隱私權。

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = 感謝您愛用 { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = 只要輕鬆一點就可以從任何地方啟動更健康的網路環境。最新推出的版本中，有我們認為您會喜歡的滿滿新鮮事。
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = 使用會在您上網時保護您隱私的瀏覽器。我們最新推出的更新，有我們認為您會喜歡的滿滿新鮮事。
mr2022-onboarding-existing-pin-checkbox-label = 也加入 { -brand-short-name } 隱私瀏覽模式

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = 要將 { -brand-short-name } 設為您的預設瀏覽器嗎？
mr2022-onboarding-set-default-primary-button-label = 將 { -brand-short-name } 設為預設瀏覽器
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = 使用由非營利組織在背後開發的瀏覽器。我們會在您上網時捍衛您的隱私權。

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = 最新版本是圍繞您打造的。讓您更簡單就可在網路中探索，我們希望您也會喜歡我們推出的滿滿功能。
mr2022-onboarding-get-started-primary-button-label = 幾秒鐘就能設定完成

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = 設定光速快
mr2022-onboarding-import-subtitle = 根據您的喜好來設定 { -brand-short-name }。可從您的舊瀏覽器匯入書籤、密碼與更多資料。
mr2022-onboarding-import-primary-button-label-no-attribution = 從先前使用的瀏覽器匯入

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = 選擇能激發您靈感的色彩
mr2022-onboarding-colorway-subtitle = 獨立的聲音將改變文化。
mr2022-onboarding-colorway-primary-button-label = 使用此配色
mr2022-onboarding-existing-colorway-checkbox-label = 將 { -firefox-home-brand-name } 設定為您色彩繽紛的首頁
mr2022-onboarding-colorway-label-default = 預設
mr2022-onboarding-colorway-tooltip-default =
    .title = 預設
mr2022-onboarding-colorway-description-default = <b>使用我目前的 { -brand-short-name } 色彩。</b>
mr2022-onboarding-colorway-label-playmaker = 控球後衛
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = 控球後衛
mr2022-onboarding-colorway-description-playmaker = <b>您是控球後衛。</b>您創造了勝利的機會，並且幫助您周圍的所有人，一同贏得競賽。
mr2022-onboarding-colorway-label-expressionist = 表現主義者
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = 表現主義者
mr2022-onboarding-colorway-description-expressionist = <b>您是表現主義者。</b>您用不同的方式看待世界，您的作品激發出他人的情感。
mr2022-onboarding-colorway-label-visionary = 遠見家
mr2022-onboarding-colorway-tooltip-visionary =
    .title = 遠見家
mr2022-onboarding-colorway-description-visionary = <b>您是遠見家。</b>您不滿意於現狀，讓所有人能夠一同想像出更好的未來。
mr2022-onboarding-colorway-label-activist = 社會運動家
mr2022-onboarding-colorway-tooltip-activist =
    .title = 社會運動家
mr2022-onboarding-colorway-description-activist = <b>您是社會運動家。</b>您讓世界變得更好，並讓他人也如此相信。
mr2022-onboarding-colorway-label-dreamer = 夢想家
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = 夢想家
mr2022-onboarding-colorway-description-dreamer = <b>您是夢想家。</b>您相信命運之神眷顧大膽的人，並且鼓勵大家勇敢表現。
mr2022-onboarding-colorway-label-innovator = 創造者
mr2022-onboarding-colorway-tooltip-innovator =
    .title = 創造者
mr2022-onboarding-colorway-description-innovator = <b>您是創造者。</b>您看到各處的機會，並且對周遭的所有人產生正面影響。

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = 在筆電與手機間往返跳轉
mr2022-onboarding-mobile-download-subtitle = 在一台裝置上取得分頁，並且在另一台裝置上從中斷的頁面繼續上網。另外還可以在您使用 { -brand-product-name } 的任何地方同步書籤、密碼等資料。
mr2022-onboarding-mobile-download-cta-text = 掃描 QR Code 即可下載 { -brand-product-name } 行動版，也可以<a data-l10n-name="download-label">傳送下載鏈結給自己。</a>
mr2022-onboarding-no-mobile-download-cta-text = 掃描這組 QR Code，下載 { -brand-product-name } 行動版。

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = 只要點一下，自動進入隱私瀏覽模式
mr2022-upgrade-onboarding-pin-private-window-subtitle = 不留下任何 Cookie 與瀏覽紀錄。隱私瀏覽不留痕跡。
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] 將 { -brand-short-name } 隱私瀏覽模式放置在 Dock
       *[other] 將 { -brand-short-name } 隱私瀏覽模式釘選到工作列
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = 我們始終尊重您的隱私權
mr2022-onboarding-privacy-segmentation-subtitle = 不論是搜尋建議或是更聰明的搜尋功能，我們會持續打造更好、更有個人風格的 { -brand-product-name }。
mr2022-onboarding-privacy-segmentation-text-cta = 當我們推出會使用您的資料來加強上網體驗的新功能時，您想收到什麼消息？
mr2022-onboarding-privacy-segmentation-button-primary-label = 使用 { -brand-product-name } 推薦設定
mr2022-onboarding-privacy-segmentation-button-secondary-label = 顯示詳細資訊

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = 您正在幫助我們打造更好的網路環境。
mr2022-onboarding-gratitude-subtitle = 感謝您使用由 Waterfox Limited 所支持開發的 { -brand-short-name }。透過您的支援，我們努力讓網路環境變得更好、更開放、更可被所有人使用。
mr2022-onboarding-gratitude-primary-button-label = 看看有什麼新鮮事
mr2022-onboarding-gratitude-secondary-button-label = 開始瀏覽
