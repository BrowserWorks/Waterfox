# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = 子母畫面

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
    .aria-label = 暫停
    .tooltip = 暫停（空白鍵）
pictureinpicture-play-btn =
    .aria-label = 播放
    .tooltip = 播放（空白鍵）

pictureinpicture-mute-btn =
    .aria-label = 靜音
    .tooltip = 靜音（{ $shortcut }）
pictureinpicture-unmute-btn =
    .aria-label = 取消靜音
    .tooltip = 取消靜音（{ $shortcut }）

pictureinpicture-unpip-btn =
    .aria-label = 送回分頁
    .tooltip = 送回分頁

pictureinpicture-close-btn =
    .aria-label = 關閉
    .tooltip = 關閉（{ $shortcut }）

pictureinpicture-subtitles-btn =
    .aria-label = 字幕
    .tooltip = 字幕

pictureinpicture-fullscreen-btn2 =
    .aria-label = 進入全螢幕模式
    .tooltip = 進入全螢幕模式（滑鼠點兩下或 { $shortcut }）

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = 離開全螢幕模式
    .tooltip = 離開全螢幕模式（滑鼠點兩下或 { $shortcut }）

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = 倒帶
    .tooltip = 倒帶（←）

pictureinpicture-seekforward-btn =
    .aria-label = 快轉
    .tooltip = 快轉（→）

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = 字幕設定

pictureinpicture-subtitles-label = 字幕

pictureinpicture-font-size-label = 字型大小

pictureinpicture-font-size-small = 小

pictureinpicture-font-size-medium = 中

pictureinpicture-font-size-large = 大
