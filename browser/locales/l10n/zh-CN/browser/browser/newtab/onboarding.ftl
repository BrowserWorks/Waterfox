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

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = 欢迎使用 <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = 快速、安全、私密的浏览器，由非营利组织全力支持。
onboarding-multistage-welcome-primary-button-label = 开始设置
onboarding-multistage-welcome-secondary-button-label = 登录
onboarding-multistage-welcome-secondary-button-text = 已有账户？
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = 将 { -brand-short-name } 设为<span data-l10n-name="zap">默认浏览器</span>
onboarding-multistage-set-default-subtitle = 每一次浏览，都有最快速度、安全与隐私保护。
onboarding-multistage-set-default-primary-button-label = 设为默认
onboarding-multistage-set-default-secondary-button-label = 暂时不要
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = 只需点击几下，即可开始使用 <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-pin-default-subtitle = 时刻拥有快速、安全又私密的上网体验。
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = 设置打开后，在“Web 浏览器”一栏中选择 { -brand-short-name }
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = 这会将 { -brand-short-name } 固定到任务栏并打开设置
onboarding-multistage-pin-default-primary-button-label = 将 { -brand-short-name } 设为我的主浏览器
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = 导入您的密码、书签和<span data-l10n-name="zap">更多数据</span>
onboarding-multistage-import-subtitle = 从其他浏览器来？很简单就能把所有东西带来 { -brand-short-name }。
onboarding-multistage-import-primary-button-label = 开始导入
onboarding-multistage-import-secondary-button-label = 暂时不要
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = 在此设备找到上面列出的网站。除非您选择导入，否则 { -brand-short-name } 不会保存或同步另一浏览器的数据。

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = 开始使用：第 { $current }屏，共 { $total } 屏
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = 选择<span data-l10n-name="zap">外观</span>
onboarding-multistage-theme-subtitle = 换上主题，让 { -brand-short-name } 有您的个性。
onboarding-multistage-theme-primary-button-label2 = 完成
onboarding-multistage-theme-secondary-button-label = 暂时不要
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = 自动
onboarding-multistage-theme-label-light = 明亮
onboarding-multistage-theme-label-dark = 深邃
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox 染山霞
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
    .title = 遵循操作系统的按钮、菜单、窗口外观。
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = 遵循操作系统的按钮、菜单、窗口外观。
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = 使用亮色按钮、菜单、窗口外观。
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = 使用亮色按钮、菜单、窗口外观。
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = 使用暗色按钮、菜单、窗口外观。
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = 使用暗色按钮、菜单、窗口外观。
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = 使用多彩按钮、菜单、窗口外观。
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = 使用多彩按钮、菜单、窗口外观。

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

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
mr2-onboarding-colorway-description =
    .aria-description = 探索 { $colorwayName } 配色。
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = 探索默认主题。
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = 探索默认主题。

## Strings for Thank You page

mr2-onboarding-thank-you-header = 感谢您选用
mr2-onboarding-thank-you-text = { -brand-short-name } 是一款由非营利组织支持的独立浏览器。我们共同努力，让网络环境更安全、更健康、也更有隐私。
mr2-onboarding-start-browsing-button-label = 开始上网冲浪
