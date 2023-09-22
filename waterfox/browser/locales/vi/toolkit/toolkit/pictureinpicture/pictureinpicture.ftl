# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Hình trong hình

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
    .aria-label = Tạm dừng
    .tooltip = Tạm dừng (Phím cách)
pictureinpicture-play-btn =
    .aria-label = Phát
    .tooltip = Phát (Phím cách)

pictureinpicture-mute-btn =
    .aria-label = Tắt tiếng
    .tooltip = Tắt tiếng ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Bật tiếng
    .tooltip = Bật tiếng ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Quay trở lại thẻ
    .tooltip = Quay lại thẻ

pictureinpicture-close-btn =
    .aria-label = Đóng
    .tooltip = Đóng ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Phụ đề
    .tooltip = Phụ đề

pictureinpicture-fullscreen-btn2 =
    .aria-label = Toàn màn hình
    .tooltip = Toàn màn hình (nhấp đúp chuột hoặc { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Thoát toàn màn hình
    .tooltip = Thoát toàn màn hình (nhấp đúp chuột hoặc { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Quay lại
    .tooltip = Quay lại (←)

pictureinpicture-seekforward-btn =
    .aria-label = Tiến
    .tooltip = Tiến (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Cài đặt phụ đề

pictureinpicture-subtitles-label = Phụ đề

pictureinpicture-font-size-label = Cỡ chữ

pictureinpicture-font-size-small = Nhỏ

pictureinpicture-font-size-medium = Trung bình

pictureinpicture-font-size-large = Lớn
