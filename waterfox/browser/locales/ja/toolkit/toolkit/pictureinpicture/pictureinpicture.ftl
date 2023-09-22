# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = ピクチャーインピクチャー

## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.
##
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

pictureinpicture-pause-btn =
    .aria-label = 一時停止
    .tooltip = 一時停止 (スペースキー)
pictureinpicture-play-btn =
    .aria-label = 再生
    .tooltip = 再生 (スペースキー)
pictureinpicture-mute-btn =
    .aria-label = ミュート
    .tooltip = ミュート ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = ミュート解除
    .tooltip = ミュート解除 ({ $shortcut })
pictureinpicture-unpip-btn =
    .aria-label = タブに戻す
    .tooltip = タブに戻す
pictureinpicture-close-btn =
    .aria-label = 閉じる
    .tooltip = 閉じる ({ $shortcut })
pictureinpicture-subtitles-btn =
    .aria-label = 字幕
    .tooltip = 字幕
pictureinpicture-fullscreen-btn2 =
    .aria-label = 全画面表示
    .tooltip = 全画面表示モードを開始 (ダブルクリックまたは { $shortcut })
pictureinpicture-exit-fullscreen-btn2 =
  .aria-label = 全画面表示を終了
  .tooltip = 全画面表示モードを終了 (ダブルクリックまたは { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = 巻き戻し
    .tooltip = 巻き戻し (←)
pictureinpicture-seekforward-btn =
    .aria-label = 早送り
    .tooltip = 早送り (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = 字幕設定
pictureinpicture-subtitles-label = 字幕
pictureinpicture-font-size-label = フォントサイズ
pictureinpicture-font-size-small = 小
pictureinpicture-font-size-medium = 中
pictureinpicture-font-size-large = 大
