# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = 新分頁
tabbrowser-empty-private-tab-title = 開新隱私分頁

tabbrowser-menuitem-close-tab =
    .label = 關閉分頁
tabbrowser-menuitem-close =
    .label = 關閉

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } — { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label = 關閉 { $tabCount } 個分頁

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label = 將 { $tabCount } 個分頁靜音（{ $shortcut }）
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label = 取消靜音 { $tabCount } 個分頁（{ $shortcut }）
tabbrowser-mute-tab-audio-background-tooltip =
    .label = 將 { $tabCount } 個分頁靜音
tabbrowser-unmute-tab-audio-background-tooltip =
    .label = 取消靜音 { $tabCount } 個分頁
tabbrowser-unblock-tab-audio-tooltip =
    .label = 播放 { $tabCount } 個分頁的音效

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = 要關閉 { $tabCount } 個分頁嗎？
tabbrowser-confirm-close-tabs-button = 關閉分頁
tabbrowser-confirm-close-tabs-checkbox = 關閉多個分頁前跟我確認

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = 要關閉 { $windowCount } 個視窗嗎？
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] 關閉並結束
       *[other] 關閉並離開
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = 要關閉視窗並離開 { -brand-short-name } 嗎？
tabbrowser-confirm-close-tabs-with-key-button = 離開 { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = 按下 { $quitKey } 離開前跟我確認

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = 開啟確認
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] 您正要開啟 { $tabCount } 個分頁，會使 { -brand-short-name } 於載入頁面時變得很慢。您確定要繼續嗎？
    }
tabbrowser-confirm-open-multiple-tabs-button = 開啟分頁
tabbrowser-confirm-open-multiple-tabs-checkbox = 開啟多個分頁使 { -brand-short-name } 變慢時警告

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = 鍵盤瀏覽
tabbrowser-confirm-caretbrowsing-message = 按 F7 鍵可切換「鍵盤瀏覽」功能開關。此功能會在網頁上顯示游標，讓您只用鍵盤就能選取文字或瀏覽網頁。確定要開啟「鍵盤瀏覽」功能嗎？
tabbrowser-confirm-caretbrowsing-checkbox = 下次不要再顯示此對話方塊。

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = 允許來自 { $domain } 的這一類通知，將您帶到該網站分頁

tabbrowser-customizemode-tab-title = 自訂 { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = 分頁靜音
    .accesskey = M
tabbrowser-context-unmute-tab =
    .label = 取消分頁靜音
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = 分頁靜音
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = 取消分頁靜音
    .accesskey = m

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = 播放聲音

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = 列出全部 { $tabCount } 個分頁

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = 分頁靜音
tabbrowser-manager-unmute-tab =
    .tooltiptext = 取消分頁靜音
tabbrowser-manager-close-tab =
    .tooltiptext = 關閉分頁
