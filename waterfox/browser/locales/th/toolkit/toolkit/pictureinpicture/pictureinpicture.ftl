# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = ภาพที่เล่นควบคู่

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
    .aria-label = หยุดชั่วคราว
    .tooltip = หยุดชั่วคราว (Spacebar)
pictureinpicture-play-btn =
    .aria-label = เล่น
    .tooltip = เล่น (Spacebar)

pictureinpicture-mute-btn =
    .aria-label = ปิดเสียง
    .tooltip = ปิดเสียง ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = เลิกปิดเสียง
    .tooltip = เลิกปิดเสียง ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = ส่งกลับไปที่แท็บ
    .tooltip = กลับไปที่แท็บ

pictureinpicture-close-btn =
    .aria-label = ปิด
    .tooltip = ปิด ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = คำบรรยาย
    .tooltip = คำบรรยาย

pictureinpicture-fullscreen-btn2 =
    .aria-label = เต็มหน้าจอ
    .tooltip = เต็มหน้าจอ (คลิกสองครั้งหรือ { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = ออกจากภาพเต็มหน้าจอ
    .tooltip = ออกจากภาพเต็มหน้าจอ (คลิกสองครั้งหรือ { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = ย้อนหลัง
    .tooltip = ย้อนหลัง (←)

pictureinpicture-seekforward-btn =
    .aria-label = เดินหน้า
    .tooltip = เดินหน้า (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = การตั้งค่าคำบรรยาย

pictureinpicture-subtitles-label = คำบรรยาย

pictureinpicture-font-size-label = ขนาดแบบอักษร

pictureinpicture-font-size-small = เล็ก

pictureinpicture-font-size-medium = ปานกลาง

pictureinpicture-font-size-large = ใหญ่
