# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = ส่วนขยายที่แนะนำ
cfr-doorhanger-feature-heading = คุณลักษณะที่แนะนำ

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ทำไมฉันจึงเห็นสิ่งนี้

cfr-doorhanger-extension-cancel-button = ไม่ใช่ตอนนี้
    .accesskey = ม

cfr-doorhanger-extension-ok-button = เพิ่มตอนนี้
    .accesskey = พ

cfr-doorhanger-extension-manage-settings-button = จัดการการตั้งค่าคำแนะนำ
    .accesskey = จ

cfr-doorhanger-extension-never-show-recommendation = ไม่ต้องแสดงคำแนะนำนี้ให้ฉัน
    .accesskey = ส

cfr-doorhanger-extension-learn-more-link = เรียนรู้เพิ่มเติม

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = โดย { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = คำแนะนำ
cfr-doorhanger-extension-notification2 = แนะนำ
    .tooltiptext = ส่วนขยายที่แนะนำ
    .a11y-announcement = ส่วนขยายแนะนำที่มีอยู่

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = แนะนำ
    .tooltiptext = คุณลักษณะที่แนะนำ
    .a11y-announcement = คุณลักษณะแนะนำที่มีอยู่

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } ดาว
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } ผู้ใช้
    }

## These messages are steps on how to use the feature and are shown together.

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = ซิงค์ที่คั่นหน้าของคุณได้ทุกที่
cfr-doorhanger-bookmark-fxa-body = เยี่ยมมาก! ตอนนี้อย่าออกไปโดยไม่มีที่คั่นหน้านี้บนอุปกรณ์มือถือของคุณ เริ่มต้นกับ { -fxaccount-brand-name }
cfr-doorhanger-bookmark-fxa-link-text = ซิงค์ที่คั่นหน้าของคุณตอนนี้…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = ปุ่มปิด
    .title = ปิด

## Protections panel

cfr-protections-panel-header = เรียกดูโดยไม่ต้องมีใครมาติดตาม
cfr-protections-panel-body = เก็บข้อมูลของคุณไว้กับตัวคุณเอง { -brand-short-name } ปกป้องคุณจากตัวติดตามที่พบบ่อยที่สุดซึ่งติดตามสิ่งที่คุณทำทางออนไลน์
cfr-protections-panel-link-text = เรียนรู้เพิ่มเติม

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = คุณสมบัติใหม่:

cfr-whatsnew-button =
    .label = มีอะไรใหม่
    .tooltiptext = มีอะไรใหม่

cfr-whatsnew-release-notes-link-text = อ่านบันทึกประจำรุ่น

## Search Bar

## Picture-in-Picture

## Permission Prompt

## Fingerprinter Counter

## Bookmark Sync

## Login Sync

## Send Tab

## Waterfox Send

## Social Tracking Protection

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } ได้ปิดกั้นตัวติดตามมากกว่า <b>{ $blockedCount }</b> ตัวตั้งแต่ { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = ดูทั้งหมด
    .accesskey = ด

## What’s New Panel Content for Waterfox 76


## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

cfr-doorhanger-milestone-close-button = ปิด
    .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = ความเป็นส่วนตัวของคุณสำคัญ ตอนนี้ { -brand-short-name } จะกำหนดเส้นทางคำขอ DNS ของคุณให้กับบริการพาร์ทเนอร์อย่างปลอดภัยเมื่อใดก็ตามที่เป็นไปได้เพื่อปกป้องคุณในขณะที่คุณเรียกดู
cfr-doorhanger-doh-header = การค้นหา DNS ที่เข้ารหัสและปลอดภัยยิ่งขึ้น
cfr-doorhanger-doh-primary-button-2 = ตกลง
    .accesskey = ต
cfr-doorhanger-doh-secondary-button = ปิดใช้งาน
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = ความเป็นส่วนตัวของคุณสำคัญ ขณะนี้ { -brand-short-name } จะแยกหรือแซนด์บ็อกซ์เว็บไซต์ออกจากกัน เพื่อให้แฮกเกอร์ขโมยรหัสผ่าน หมายเลขบัตรเครดิต และข้อมูลที่ละเอียดอ่อนอื่น ๆ ได้ยากขึ้น
cfr-doorhanger-fission-header = การแยกไซต์
cfr-doorhanger-fission-primary-button = ตกลง เข้าใจแล้ว
    .accesskey = O
cfr-doorhanger-fission-secondary-button = เรียนรู้เพิ่มเติม
    .accesskey = L

## Full Video Support CFR message

cfr-doorhanger-video-support-body = วิดีโอบนไซต์นี้อาจเล่นไม่ถูกต้องใน { -brand-short-name } เวอร์ชันนี้ สำหรับการสนับสนุนวิดีโอเต็มรูปแบบ อัปเดต { -brand-short-name } ทันที
cfr-doorhanger-video-support-header = อัปเดต { -brand-short-name } เพื่อเล่นวิดีโอ
cfr-doorhanger-video-support-primary-button = อัปเดตตอนนี้
    .accesskey = U

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-link = ไม่ใช่ตอนนี้
    .accesskey = N
