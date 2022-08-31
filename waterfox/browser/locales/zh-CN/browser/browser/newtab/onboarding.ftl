# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = 欢迎使用 { -brand-short-name }
onboarding-start-browsing-button-label = 开始上网冲浪
onboarding-not-now-button-label = 暂时不要

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = 恭喜，您已经安装好 { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = 现在来安装 <img data-l10n-name="icon"/><b>{ $addon-name }</b> 吧。
return-to-amo-add-extension-label = 添加扩展
return-to-amo-add-theme-label = 安装主题

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = 开始使用：第 { $current }屏，共 { $total } 屏

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = 进度：步骤 { $current } / { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = 星星之火 正将燎原
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = 索拉娅·奥索里奥（Soraya Osorio）— 家具设计师、Waterfox 粉丝
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = 关闭动画

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] 在您的程序坞中保留 { -brand-short-name }，方便访问
       *[other] 将 { -brand-short-name } 固定到您的任务栏，方便访问
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] 在程序坞中保留
       *[other] 固定到任务栏
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = 开始使用
mr1-onboarding-welcome-header = 欢迎使用 { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = 将 { -brand-short-name } 设为我的主浏览器
    .title = 将 { -brand-short-name } 设为默认浏览器，并固定到任务栏
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = 将 { -brand-short-name } 设为我的默认浏览器
mr1-onboarding-set-default-secondary-button-label = 暂时不要
mr1-onboarding-sign-in-button-label = 登录

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = 将 { -brand-short-name } 设为您的默认浏览器
mr1-onboarding-default-subtitle = 自动获得快速、安全、私密的浏览体验。
mr1-onboarding-default-primary-button-label = 设为默认浏览器

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = 快速迁移
mr1-onboarding-import-subtitle = 导入您的密码、书签等数据。
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = 从 { $previous } 导入
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = 从先前所用浏览器导入
mr1-onboarding-import-secondary-button-label = 暂时不要
mr2-onboarding-colorway-header = 多彩生活
mr2-onboarding-colorway-subtitle = 元气满满的新配色，限时提供。
mr2-onboarding-colorway-primary-button-label = 保存配色
mr2-onboarding-colorway-secondary-button-label = 暂时不要
mr2-onboarding-colorway-label-soft = 柔和
mr2-onboarding-colorway-label-balanced = 平衡
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = 浓烈
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = 自动
# This string will be used for Default theme
mr2-onboarding-theme-label-default = 默认
mr1-onboarding-theme-header = 我有我的范儿
mr1-onboarding-theme-subtitle = 换上主题，让 { -brand-short-name } 有您的个性。
mr1-onboarding-theme-primary-button-label = 保存主题
mr1-onboarding-theme-secondary-button-label = 暂时不要
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = 系统主题
mr1-onboarding-theme-label-light = 明亮
mr1-onboarding-theme-label-dark = 深邃
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = 染山霞
onboarding-theme-primary-button-label = 完成

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title = 跟随系统主题配色显示按钮、菜单和窗口
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description = 跟随系统主题配色显示按钮、菜单和窗口
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title = 为按钮、菜单和窗口使用明亮配色主题。
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description = 为按钮、菜单和窗口使用明亮配色主题。
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title = 为按钮、菜单和窗口使用深邃配色主题。
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description = 为按钮、菜单和窗口使用深邃配色主题。
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title = 为按钮、菜单和窗口使用活力多彩配色主题。
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description = 为按钮、菜单和窗口使用活力多彩配色主题。
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = 使用此配色。
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = 使用此配色。
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = 探索 { $colorwayName } 配色。
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = 探索 { $colorwayName } 配色。
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = 探索默认主题。
# Selector description for default themes
mr2-onboarding-default-theme-label = 探索默认主题。

## Strings for Thank You page

mr2-onboarding-thank-you-header = 感谢您选用
mr2-onboarding-thank-you-text = { -brand-short-name } 是一款由非营利组织支持的独立浏览器。我们共同努力，让网络环境更安全、更健康、也更有隐私。
mr2-onboarding-start-browsing-button-label = 开始上网冲浪

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

onboarding-live-language-header = 选择您的语言
mr2022-onboarding-live-language-text = { -brand-short-name } 也懂您的语言
onboarding-live-language-button-label-downloading = 正在下载“{ $negotiatedLanguage }”语言包…
onboarding-live-language-waiting-button = 正在获取可用语言列表…
onboarding-live-language-installing = 正在安装“{ $negotiatedLanguage }”语言包…
mr2022-onboarding-live-language-switch-to = 切换为“{ $negotiatedLanguage }”
mr2022-onboarding-live-language-continue-in = 继续使用“{ $appLanguage }”
onboarding-live-language-secondary-cancel-download = 取消
onboarding-live-language-skip-button-label = 跳过

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    百版之约
    万分<span data-l10n-name="zap">感谢</span>
fx100-thank-you-subtitle = 第 100 个版本如约而至。感谢您支持我们建设更好、更健康的互联网。
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] 在程序坞中保留 { -brand-short-name }
       *[other] 将 { -brand-short-name } 固定到任务栏
    }
fx100-upgrade-thanks-header = 百版之约，万分感谢
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = { -brand-short-name } 的第 100 个版本如约而至。感谢<em>您</em> 支持我们建设更好、更健康的互联网。
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = 这是我们的第 100 个版本！一路相伴，感谢有您。{ -brand-short-name } 诚挚邀您共赴下个百版之约。
mr2022-onboarding-secondary-skip-button-label = 跳过此步骤

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = 探索精彩互联网
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] 在程序坞中保留 { -brand-short-name }
       *[other] 将 { -brand-short-name } 固定到任务栏
    }

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = 感谢您对 { -brand-product-name } 的青睐

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = 要将 { -brand-short-name } 设为您的默认浏览器吗？
mr2022-onboarding-set-default-primary-button-label = 将 { -brand-short-name } 设为默认浏览器

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

mr2022-onboarding-get-started-primary-button-label = 几秒钟就能完成设置

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = 快速设置
mr2022-onboarding-import-primary-button-label-no-attribution = 从先前所用浏览器导入

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = 选择能激发你灵感的颜色
mr2022-onboarding-colorway-subtitle = 凡人之声，文化之根
mr2022-onboarding-colorway-primary-button-label = 设置配色
mr2022-onboarding-existing-colorway-checkbox-label = 将“{ -firefox-home-brand-name }”设为您的多彩主页
mr2022-onboarding-colorway-label-default = 默认
mr2022-onboarding-colorway-tooltip-default =
    .title = 默认
mr2022-onboarding-colorway-description-default = <b>使用我当前的 { -brand-short-name } 颜色。</b>
mr2022-onboarding-colorway-label-playmaker = 实力派
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = 实力派
mr2022-onboarding-colorway-description-playmaker = <b>您是实力派。</b>您是做事成功的关键，并乐于帮助周围的人一同提升。
mr2022-onboarding-colorway-label-expressionist = 表现派
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = 表现派
mr2022-onboarding-colorway-description-expressionist = <b>您是表现派。</b>您以不同的方式看待世界，并善用创作引起他人的情感共鸣。
mr2022-onboarding-colorway-label-visionary = 远见派
mr2022-onboarding-colorway-tooltip-visionary =
    .title = 远见派
mr2022-onboarding-colorway-description-visionary = <b>您是远见派。</b>您不满足于现状，并带领大家畅想更美好的未来。
mr2022-onboarding-colorway-label-activist = 行动派
mr2022-onboarding-colorway-tooltip-activist =
    .title = 行动派
mr2022-onboarding-colorway-description-activist = <b>您是行动派。</b>您让世界变得更美好，并引导他人相信亦应如此。
mr2022-onboarding-colorway-label-dreamer = 理想派
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = 理想派
mr2022-onboarding-colorway-description-dreamer = <b>您是理想派。</b>您相信命运偏爱大胆的人，并激励他人勇敢做自己。
mr2022-onboarding-colorway-label-innovator = 创新派
mr2022-onboarding-colorway-tooltip-innovator =
    .title = 创新派
mr2022-onboarding-colorway-description-innovator = <b>您是创新派。</b>您善于捕捉各处机会，并正向影响身边所有人。

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-cta-text = 扫码下载移动版 { -brand-product-name } 或<a data-l10n-name="download-label">向自己发送下载链接。</a>
mr2022-onboarding-no-mobile-download-cta-text = 扫码下载移动版 { -brand-product-name }。

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = 一键进入隐私浏览模式
mr2022-upgrade-onboarding-pin-private-window-subtitle = 不保存任何 Cookie 和历史记录，隐私浏览不留痕迹。
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] 将 { -brand-short-name } 隐私浏览窗口固定到我的任务栏
       *[other] 在您的程序坞中保留 { -brand-short-name } 隐私浏览窗口
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = 尊重您的隐私是我们不变的承诺
mr2022-onboarding-privacy-segmentation-button-primary-label = 使用 { -brand-product-name } 推荐
mr2022-onboarding-privacy-segmentation-button-secondary-label = 显示详细信息

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-primary-button-label = 了解新版变化
mr2022-onboarding-gratitude-secondary-button-label = 开始浏览
