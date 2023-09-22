# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = 画中画

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
    .aria-label = 暂停
    .tooltip = 暂停（空格键）
pictureinpicture-play-btn =
    .aria-label = 播放
    .tooltip = 播放（空格键）

pictureinpicture-mute-btn =
    .aria-label = 静音
    .tooltip = 静音（{ $shortcut }）
pictureinpicture-unmute-btn =
    .aria-label = 取消静音
    .tooltip = 取消静音（{ $shortcut }）

pictureinpicture-unpip-btn =
    .aria-label = 切回标签页
    .tooltip = 切回标签页

pictureinpicture-close-btn =
    .aria-label = 关闭
    .tooltip = 关闭（{ $shortcut }）

pictureinpicture-subtitles-btn =
    .aria-label = 字幕
    .tooltip = 字幕

pictureinpicture-fullscreen-btn2 =
    .aria-label = 全屏
    .tooltip = 全屏（双击或按 { $shortcut } 键）

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = 退出全屏
    .tooltip = 退出全屏（双击或按 { $shortcut } 键）

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = 快退
    .tooltip = 快退（←）

pictureinpicture-seekforward-btn =
    .aria-label = 快进
    .tooltip = 快进（→）

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = 字幕设置

pictureinpicture-subtitles-label = 字幕

pictureinpicture-font-size-label = 字号

pictureinpicture-font-size-small = 小

pictureinpicture-font-size-medium = 中

pictureinpicture-font-size-large = 大
