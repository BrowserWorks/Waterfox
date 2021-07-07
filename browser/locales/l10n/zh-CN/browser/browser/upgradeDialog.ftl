# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = 邂逅全新的 { -brand-short-name }
upgrade-dialog-new-subtitle = 重新设计，只为让您的浏览更轻快
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = 只需点击几下，即可开始使用 <span data-l10n-name="zap">{ -brand-short-name }</span>
upgrade-dialog-new-item-menu-title = 更精简的工具栏和菜单
upgrade-dialog-new-item-menu-description = 依优先级简化重排，操作更便捷。
upgrade-dialog-new-item-tabs-title = 现代化的标签页设计
upgrade-dialog-new-item-tabs-description = 信息整齐容纳，视觉焦点突出，亦可灵活移动。
upgrade-dialog-new-item-icons-title = 新图标和更清晰直观的消息提示
upgrade-dialog-new-item-icons-description = 助您快速上手，轻松使用。
upgrade-dialog-new-primary-primary-button = 将 { -brand-short-name } 设为我的主浏览器
    .title = 将 { -brand-short-name } 设为默认浏览器，并固定到任务栏
upgrade-dialog-new-primary-default-button = 将 { -brand-short-name } 设为我的默认浏览器
upgrade-dialog-new-primary-pin-button = 将 { -brand-short-name } 固定到我的任务栏
upgrade-dialog-new-primary-pin-alt-button = 固定到任务栏
upgrade-dialog-new-primary-theme-button = 选择主题
upgrade-dialog-new-secondary-button = 暂时不要
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = 好，知道了！

## Pin Firefox screen
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
upgrade-dialog-default-title = 要将 { -brand-short-name } 设为您的默认浏览器吗？
upgrade-dialog-default-subtitle = 每一次浏览，都有最快速度、安全与隐私保护。
upgrade-dialog-default-primary-button = 设为默认浏览器
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = 将 { -brand-short-name } 设为您的默认浏览器
upgrade-dialog-default-subtitle-2 = 自动获得快速、安全、私密的浏览体验。
upgrade-dialog-default-primary-button-2 = 设为默认浏览器
upgrade-dialog-default-secondary-button = 暂时不要

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    换上新主题
    整装再出发
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 =
    换上新主题
    整装再出发
upgrade-dialog-theme-system = 系统主题
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
