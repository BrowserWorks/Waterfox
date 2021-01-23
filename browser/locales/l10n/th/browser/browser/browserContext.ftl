# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] ดึงลงเพื่อแสดงประวัติ
           *[other] คลิกขวาหรือดึงลงเพื่อแสดงประวัติ
        }

## Back

main-context-menu-back =
    .tooltiptext = ย้อนกลับไปหนึ่งหน้า
    .aria-label = ย้อนกลับ
    .accesskey = ย

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = เดินหน้าไปหนึ่งหน้า
    .aria-label = เดินหน้า
    .accesskey = ด

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = โหลดใหม่
    .accesskey = ห

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = หยุด
    .accesskey = ห

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = บันทึกหน้าเป็น…
    .accesskey = ห

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = เพิ่มที่คั่นหน้าสำหรับหน้านี้
    .accesskey = พ
    .tooltiptext = เพิ่มที่คั่นหน้าสำหรับหน้านี้

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = เพิ่มที่คั่นหน้าสำหรับหน้านี้
    .accesskey = พ
    .tooltiptext = เพิ่มที่คั่นหน้าสำหรับหน้านี้ ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = แก้ไขที่คั่นหน้านี้
    .accesskey = พ
    .tooltiptext = แก้ไขที่คั่นหน้านี้

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = แก้ไขที่คั่นหน้านี้
    .accesskey = พ
    .tooltiptext = แก้ไขที่คั่นหน้านี้ ({ $shortcut })

main-context-menu-open-link =
    .label = เปิดลิงก์
    .accesskey = ป

main-context-menu-open-link-new-tab =
    .label = เปิดลิงก์ในแท็บใหม่
    .accesskey = ท

main-context-menu-open-link-container-tab =
    .label = เปิดลิงก์ในแท็บแยกข้อมูลใหม่
    .accesskey = ย

main-context-menu-open-link-new-window =
    .label = เปิดลิงก์ในหน้าต่างใหม่
    .accesskey = ห

main-context-menu-open-link-new-private-window =
    .label = เปิดลิงก์ในหน้าต่างส่วนตัวใหม่
    .accesskey = ส

main-context-menu-bookmark-this-link =
    .label = เพิ่มที่คั่นหน้าสำหรับลิงก์นี้
    .accesskey = ล

main-context-menu-save-link =
    .label = บันทึกลิงก์เป็น…
    .accesskey = น

main-context-menu-save-link-to-pocket =
    .label = บันทึกลิงก์ไปยัง { -pocket-brand-name }
    .accesskey = น

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = คัดลอกที่อยู่อีเมล
    .accesskey = ท

main-context-menu-copy-link =
    .label = คัดลอกตำแหน่งที่ตั้งลิงก์
    .accesskey = ด

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = เล่น
    .accesskey = ล

main-context-menu-media-pause =
    .label = หยุดชั่วคราว
    .accesskey = ห

##

main-context-menu-media-mute =
    .label = ปิดเสียง
    .accesskey = ส

main-context-menu-media-unmute =
    .label = เลิกปิดเสียง
    .accesskey = ส

main-context-menu-media-play-speed =
    .label = ความเร็วในการเล่น
    .accesskey = ร

main-context-menu-media-play-speed-slow =
    .label = ช้า (0.5×)
    .accesskey = ช

main-context-menu-media-play-speed-normal =
    .label = ปกติ
    .accesskey = ป

main-context-menu-media-play-speed-fast =
    .label = เร็ว (1.25×)
    .accesskey = ร

main-context-menu-media-play-speed-faster =
    .label = เร็วขึ้น (1.5×)
    .accesskey = ข

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = เร็วมาก (2×)
    .accesskey = ม

main-context-menu-media-loop =
    .label = วนรอบ
    .accesskey = ว

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = แสดงปุ่มควบคุม
    .accesskey = ค

main-context-menu-media-hide-controls =
    .label = ซ่อนปุ่มควบคุม
    .accesskey = ค

##

main-context-menu-media-video-fullscreen =
    .label = เต็มหน้าจอ
    .accesskey = จ

main-context-menu-media-video-leave-fullscreen =
    .label = ออกจากภาพเต็มหน้าจอ
    .accesskey = อ

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = ภาพที่เล่นควบคู่
    .accesskey = ภ

main-context-menu-image-reload =
    .label = โหลดภาพใหม่
    .accesskey = ห

main-context-menu-image-view =
    .label = ดูภาพ
    .accesskey = ด

main-context-menu-video-view =
    .label = ดูวิดีโอ
    .accesskey = ด

main-context-menu-image-copy =
    .label = คัดลอกภาพ
    .accesskey = ค

main-context-menu-image-copy-location =
    .label = คัดลอกตำแหน่งที่ตั้งภาพ
    .accesskey = ง

main-context-menu-video-copy-location =
    .label = คัดลอกตำแหน่งที่ตั้งวิดีโอ
    .accesskey = ง

main-context-menu-audio-copy-location =
    .label = คัดลอกตำแหน่งที่ตั้งเสียง
    .accesskey = ง

main-context-menu-image-save-as =
    .label = บันทึกภาพเป็น…
    .accesskey = บ

main-context-menu-image-email =
    .label = ส่งอีเมลภาพ…
    .accesskey = ม

main-context-menu-image-set-as-background =
    .label = ตั้งเป็นพื้นหลังเดสก์ท็อป…
    .accesskey = ต

main-context-menu-image-info =
    .label = ดูข้อมูลภาพ
    .accesskey = ข

main-context-menu-image-desc =
    .label = ดูคำอธิบาย
    .accesskey = ย

main-context-menu-video-save-as =
    .label = บันทึกวิดีโอเป็น…
    .accesskey = น

main-context-menu-audio-save-as =
    .label = บันทึกเสียงเป็น…
    .accesskey = บ

main-context-menu-video-image-save-as =
    .label = บันทึกสแนปช็อตเป็น…
    .accesskey = บ

main-context-menu-video-email =
    .label = ส่งอีเมลวิดีโอ…
    .accesskey = ม

main-context-menu-audio-email =
    .label = ส่งอีเมลเสียง…
    .accesskey = ม

main-context-menu-plugin-play =
    .label = เปิดใช้งานปลั๊กอินนี้
    .accesskey = ป

main-context-menu-plugin-hide =
    .label = ซ่อนปลั๊กอินนี้
    .accesskey = อ

main-context-menu-save-to-pocket =
    .label = บันทึกหน้าไปยัง { -pocket-brand-name }
    .accesskey = บ

main-context-menu-send-to-device =
    .label = ส่งหน้าไปยังอุปกรณ์
    .accesskey = ส

main-context-menu-view-background-image =
    .label = ดูภาพพื้นหลัง
    .accesskey = ภ

main-context-menu-generate-new-password =
    .label = ใช้รหัสผ่านที่ถูกสร้างขึ้นมา ...
    .accesskey = G

main-context-menu-keyword =
    .label = เพิ่มคำสำคัญสำหรับการค้นหานี้…
    .accesskey = พ

main-context-menu-link-send-to-device =
    .label = ส่งลิงก์ไปยังอุปกรณ์
    .accesskey = ส

main-context-menu-frame =
    .label = กรอบนี้
    .accesskey = ก

main-context-menu-frame-show-this =
    .label = แสดงเฉพาะกรอบนี้
    .accesskey = ส

main-context-menu-frame-open-tab =
    .label = เปิดกรอบในแท็บใหม่
    .accesskey = ท

main-context-menu-frame-open-window =
    .label = เปิดกรอบในหน้าต่างใหม่
    .accesskey = ห

main-context-menu-frame-reload =
    .label = โหลดกรอบใหม่
    .accesskey = ล

main-context-menu-frame-bookmark =
    .label = เพิ่มที่คั่นหน้าสำหรับกรอบนี้
    .accesskey = ม

main-context-menu-frame-save-as =
    .label = บันทึกกรอบเป็น…
    .accesskey = ก

main-context-menu-frame-print =
    .label = พิมพ์กรอบ…
    .accesskey = พ

main-context-menu-frame-view-source =
    .label = ดูต้นฉบับกรอบ
    .accesskey = ด

main-context-menu-frame-view-info =
    .label = ดูข้อมูลกรอบ
    .accesskey = ข

main-context-menu-view-selection-source =
    .label = ดูต้นฉบับส่วนที่เลือก
    .accesskey = ต

main-context-menu-view-page-source =
    .label = ดูต้นฉบับหน้า
    .accesskey = ด

main-context-menu-view-page-info =
    .label = ดูข้อมูลหน้า
    .accesskey = ข

main-context-menu-bidi-switch-text =
    .label = สลับทิศทางข้อความ
    .accesskey = ล

main-context-menu-bidi-switch-page =
    .label = สลับทิศทางหน้ากระดาษ
    .accesskey = ส

main-context-menu-inspect-element =
    .label = ตรวจสอบองค์ประกอบ
    .accesskey = อ

main-context-menu-inspect-a11y-properties =
    .label = ตรวจสอบคุณสมบัติการช่วยการเข้าถึง

main-context-menu-eme-learn-more =
    .label = เรียนรู้เพิ่มเติมเกี่ยวกับ DRM…
    .accesskey = ร

