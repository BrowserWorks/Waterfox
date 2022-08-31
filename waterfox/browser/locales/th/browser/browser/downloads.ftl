# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = การดาวน์โหลด
downloads-panel =
    .aria-label = การดาวน์โหลด

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em

downloads-cmd-pause =
    .label = หยุดชั่วคราว
    .accesskey = ห
downloads-cmd-resume =
    .label = ทำต่อ
    .accesskey = ท
downloads-cmd-cancel =
    .tooltiptext = ยกเลิก
downloads-cmd-cancel-panel =
    .aria-label = ยกเลิก

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] แสดงในโฟลเดอร์
           *[other] แสดงในโฟลเดอร์
        }
    .accesskey = ฟ

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = เปิดในตัวดูของระบบ
    .accesskey = ต
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = เปิดใน { $handler }
    .accesskey = I

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = เปิดในตัวดูของระบบเสมอ
    .accesskey = ส
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = เปิดใน { $handler } เสมอ
    .accesskey = w

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = เปิดไฟล์ที่คล้ายกันเสมอ
    .accesskey = ส

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] แสดงในโฟลเดอร์
           *[other] แสดงในโฟลเดอร์
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] แสดงในโฟลเดอร์
           *[other] แสดงในโฟลเดอร์
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] แสดงในโฟลเดอร์
           *[other] แสดงในโฟลเดอร์
        }

downloads-cmd-show-downloads =
    .label = แสดงโฟลเดอร์การดาวน์โหลด
downloads-cmd-retry =
    .tooltiptext = ลองใหม่
downloads-cmd-retry-panel =
    .aria-label = ลองใหม่
downloads-cmd-go-to-download-page =
    .label = ไปยังหน้าดาวน์โหลด
    .accesskey = ป
downloads-cmd-copy-download-link =
    .label = คัดลอกลิงก์ดาวน์โหลด
    .accesskey = ล
downloads-cmd-remove-from-history =
    .label = เอาออกจากประวัติ
    .accesskey = อ
downloads-cmd-clear-list =
    .label = ล้างแผงแสดงตัวอย่าง
    .accesskey = ง
downloads-cmd-clear-downloads =
    .label = ล้างการดาวน์โหลด
    .accesskey = ด
downloads-cmd-delete-file =
    .label = ลบ
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = อนุญาตการดาวน์โหลด
    .accesskey = ต

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = เอาไฟล์ออก

downloads-cmd-remove-file-panel =
    .aria-label = เอาไฟล์ออก

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = เอาไฟล์ออกหรืออนุญาตการดาวน์โหลด

downloads-cmd-choose-unblock-panel =
    .aria-label = เอาไฟล์ออกหรืออนุญาตการดาวน์โหลด

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = เปิดหรือเอาไฟล์ออก

downloads-cmd-choose-open-panel =
    .aria-label = เปิดหรือเอาไฟล์ออก

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = แสดงข้อมูลเพิ่มเติม

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = เปิดไฟล์

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = จะเปิดในอีก { $hours } ชั่วโมง { $minutes } นาที…
downloading-file-opens-in-minutes = จะเปิดในอีก { $minutes } นาที…
downloading-file-opens-in-minutes-and-seconds = จะเปิดในอีก { $minutes } นาที { $seconds } วินาที…
downloading-file-opens-in-seconds = จะเปิดในอีก { $seconds } วินาที…
downloading-file-opens-in-some-time = จะเปิดเมื่อเสร็จสมบูรณ์แล้ว…
downloading-file-click-to-open =
    .value = เปิดเมื่อเสร็จสมบูรณ์แล้ว

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = ลองดาวน์โหลดใหม่

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ยกเลิกการดาวน์โหลด

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = แสดงการดาวน์โหลดทั้งหมด
    .accesskey = ส

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = รายละเอียดการดาวน์โหลด

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] ไฟล์ไม่ได้ดาวน์โหลด
       *[other] { $num } ไฟล์ไม่ได้ดาวน์โหลด
    }
downloads-blocked-from-url = การดาวน์โหลดถูกปิดกั้นจาก { $url }
downloads-blocked-download-detailed-info = { $url } พยายามดาวน์โหลดไฟล์หลายไฟล์โดยอัตโนมัติ ไซต์อาจเสียหายหรือพยายามจัดเก็บสแปมไฟล์ในอุปกรณ์ของคุณ

##

downloads-clear-downloads-button =
    .label = ล้างการดาวน์โหลด
    .tooltiptext = ล้างการดาวน์โหลดที่เสร็จสมบูรณ์ ถูกยกเลิก และล้มเหลว

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = ไม่มีการดาวน์โหลด

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = ไม่มีการดาวน์โหลดในวาระนี้

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
       *[other] อีก { $count } ไฟล์กำลังดาวน์โหลดอยู่
    }
