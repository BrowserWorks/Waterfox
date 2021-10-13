# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = 邂逅全新的 { -brand-short-name }
upgrade-dialog-new-subtitle = 重新设计，只为让您的浏览更轻快
upgrade-dialog-new-item-menu-title = 更精简的工具栏和菜单
upgrade-dialog-new-item-menu-description = 依优先级简化重排，操作更便捷。
upgrade-dialog-new-item-tabs-title = 现代化的标签页设计
upgrade-dialog-new-item-tabs-description = 信息整齐容纳，视觉焦点突出，亦可灵活移动。
upgrade-dialog-new-item-icons-title = 新图标和更清晰直观的消息提示
upgrade-dialog-new-item-icons-description = 助您快速上手，轻松使用。
upgrade-dialog-new-primary-default-button = 将 { -brand-short-name } 设为我的默认浏览器
upgrade-dialog-new-primary-theme-button = 选择主题
upgrade-dialog-new-secondary-button = 暂时不要
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = 好，知道了！

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] 在您的程序坞中保留 { -brand-short-name }
       *[other] 将 { -brand-short-name } 固定到您的任务栏
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] 方便随时访问全新体验的 { -brand-short-name }。
       *[other] 方便随时访问全新体验的 { -brand-short-name }。
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] 在程序坞中保留
       *[other] 固定到任务栏
    }
upgrade-dialog-pin-secondary-button = 暂时不要

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = 将 { -brand-short-name } 设为您的默认浏览器
upgrade-dialog-default-subtitle-2 = 自动获得快速、安全、私密的浏览体验。
upgrade-dialog-default-primary-button-2 = 设为默认浏览器
upgrade-dialog-default-secondary-button = 暂时不要

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 =
    换上新主题
    整装再出发
upgrade-dialog-theme-system = 系统主题
    .title = 跟随系统主题配色显示按钮、菜单和窗口

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = 多彩生活
upgrade-dialog-start-subtitle = 元气满满的新配色，限时提供。
upgrade-dialog-start-primary-button = 探索配色
upgrade-dialog-start-secondary-button = 暂时不要

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = 挑选您的配色
upgrade-dialog-colorway-home-checkbox = 切换为使用主题背景的 Waterfox 主页
upgrade-dialog-colorway-primary-button = 保存配色
upgrade-dialog-colorway-secondary-button = 暂不更换主题
upgrade-dialog-colorway-theme-tooltip =
    .title = 探索默认主题
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = 探索 { $colorwayName } 配色
upgrade-dialog-colorway-default-theme = 默认
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = 自动
    .title = 跟随系统主题配色显示按钮、菜单和窗口
upgrade-dialog-theme-light = 明亮
    .title = 为按钮、菜单和窗口使用明亮配色主题
upgrade-dialog-theme-dark = 深邃
    .title = 为按钮、菜单和窗口使用深邃配色主题
upgrade-dialog-theme-alpenglow = 染山霞
    .title = 为按钮、菜单和窗口使用活力多彩配色主题
upgrade-dialog-theme-keep = 保留原设置
    .title = 使用您更新 { -brand-short-name } 前安装的主题
upgrade-dialog-theme-primary-button = 保存主题
upgrade-dialog-theme-secondary-button = 暂时不要
upgrade-dialog-colorway-variation-soft = 柔和
    .title = 使用此配色
upgrade-dialog-colorway-variation-balanced = 平衡
    .title = 使用此配色
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = 浓烈
    .title = 使用此配色

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = 感谢您选用
upgrade-dialog-thankyou-subtitle = { -brand-short-name } 是一款由非营利组织支持的独立浏览器。我们共同努力，让网络环境更安全、更健康、也更有隐私。
upgrade-dialog-thankyou-primary-button = 开始上网冲浪
