# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = 新标签页
tabbrowser-empty-private-tab-title = 新建隐私标签页

tabbrowser-menuitem-close-tab =
    .label = 关闭标签页
tabbrowser-menuitem-close =
    .label = 关闭

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } — { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label = 关闭 { $tabCount } 个标签页

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label = 静音 { $tabCount } 个标签页 ({ $shortcut })
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label = 取消静音 { $tabCount } 个标签页 ({ $shortcut })
tabbrowser-mute-tab-audio-background-tooltip =
    .label = 静音 { $tabCount } 个标签页
tabbrowser-unmute-tab-audio-background-tooltip =
    .label = 取消静音 { $tabCount } 个标签页
tabbrowser-unblock-tab-audio-tooltip =
    .label = 播放 { $tabCount } 个标签页

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = 要关闭 { $tabCount } 个标签页吗？
tabbrowser-confirm-close-tabs-button = 关闭标签页
tabbrowser-confirm-close-tabs-checkbox = 关闭多个标签页时向您确认

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = 要关闭 { $windowCount } 个窗口吗？
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] 关闭并退出
       *[other] 关闭并退出
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = 要关闭窗口并退出 { -brand-short-name } 吗？
tabbrowser-confirm-close-tabs-with-key-button = 退出 { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = 按 { $quitKey } 退出时向您确认

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = 确认打开
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] 您将要打开 { $tabCount } 个标签页。一并加载太多页面可能会减慢 { -brand-short-name } 的运行。您确定要一并打开吗？
    }
tabbrowser-confirm-open-multiple-tabs-button = 打开标签页
tabbrowser-confirm-open-multiple-tabs-checkbox = 打开多个标签页可能致使 { -brand-short-name } 缓慢前提醒我

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = 光标浏览
tabbrowser-confirm-caretbrowsing-message = 按 F7 来启用或禁用光标浏览。此功能将在网页中放置一个可移动的光标，以便您能使用键盘选择文本。您想要启用光标浏览吗？
tabbrowser-confirm-caretbrowsing-checkbox = 不再显示此对话框。

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = 允许来自 { $domain } 的此类通知，将您带往该网站标签页

tabbrowser-customizemode-tab-title = 定制 { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = 静音标签页
    .accesskey = M
tabbrowser-context-unmute-tab =
    .label = 取消静音标签页
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = 静音标签页
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = 取消静音标签页
    .accesskey = m

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = 音频播放中

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = 列出全部 { $tabCount } 个标签页

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = 静音标签页
tabbrowser-manager-unmute-tab =
    .tooltiptext = 取消静音标签页
tabbrowser-manager-close-tab =
    .tooltiptext = 关闭标签页
