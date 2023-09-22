# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = 新しいタブ
tabbrowser-empty-private-tab-title = 新しいプライベートタブ
tabbrowser-menuitem-close-tab =
    .label = タブを閉じる
tabbrowser-menuitem-close =
    .label = 閉じる
# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } — { $containerName }
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] タブを閉じます
           *[other] { $tabCount } 個のタブを閉じます
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] タブをミュートします ({ $shortcut })
           *[other] { $tabCount } 個のタブをミュートします ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] タブのミュートを解除します ({ $shortcut })
           *[other] { $tabCount } 個のタブのミュートを解除します ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] タブをミュートします
           *[other] { $tabCount } 個のタブをミュートします
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] タブのミュートを解除します
           *[other] { $tabCount } 個のタブのミュートを解除します
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] タブの音声を再生します
           *[other] { $tabCount } 個のタブの音声を再生します
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title =
    { $tabCount ->
       *[other] { $tabCount } 個のタブを閉じますか？
    }
tabbrowser-confirm-close-tabs-button = タブを閉じる
tabbrowser-confirm-close-tabs-checkbox = 同時に複数のタブを閉じる前に確認する

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title =
    { $windowCount ->
       *[other] { $windowCount } 個のウィンドウを閉じますか？
    }
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] 閉じて終了
       *[other] 閉じて終了
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = ウィンドウを閉じて { -brand-short-name } を終了しますか？
tabbrowser-confirm-close-tabs-with-key-button = { -brand-short-name } を終了
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = { $quitKey } キーで終了する前に確認する

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = 確認
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] { $tabCount } 個のタブを開こうとしています。この操作を行うと、ページの読み込み中は { -brand-short-name } が遅くなる可能性があります。続行しますか？
    }
tabbrowser-confirm-open-multiple-tabs-button = タブを開く
tabbrowser-confirm-open-multiple-tabs-checkbox = 複数のタブを開くときに { -brand-short-name } が遅くなりそうなときは警告する

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = キャレットブラウジング
tabbrowser-confirm-caretbrowsing-message = F7 を押すとキャレットブラウジングのオンオフを切り替えられます。この機能はウェブページに移動可能なカーソルを配置して、キーボードでテキストを選択できるようにします。キャレットブラウジングをオンにしますか？
tabbrowser-confirm-caretbrowsing-checkbox = 次回からはこのダイアログを表示しない。

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = { $domain } から通知を許可し、そのタブへ移動する
tabbrowser-customizemode-tab-title = { -brand-short-name } をカスタマイズ

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = タブをミュート
    .accesskey = M
tabbrowser-context-unmute-tab =
    .label = タブのミュートを解除
    .accesskey = m
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = タブをミュート
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = タブのミュートを解除
    .accesskey = m
# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = 音声を再生します

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = すべて ({ $tabCount } ページ) のタブを一覧

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = タブをミュートにします
tabbrowser-manager-unmute-tab =
    .tooltiptext = タブのミュートを解除します
tabbrowser-manager-close-tab =
    .tooltiptext = タブを閉じます
