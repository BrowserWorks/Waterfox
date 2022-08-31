# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = กำลังดาวน์โหลดการอัปเดต { -brand-shorter-name }
appmenuitem-banner-update-available =
    .label = มีการอัปเดต — ดาวน์โหลดทันที
appmenuitem-banner-update-manual =
    .label = มีการอัปเดต — ดาวน์โหลดทันที
appmenuitem-banner-update-unsupported =
    .label = ไม่สามารถอัปเดต — เข้ากันกับระบบไม่ได้
appmenuitem-banner-update-restart =
    .label = มีการอัปเดต — เริ่มใหม่ทันที
appmenuitem-new-tab =
    .label = แท็บใหม่
appmenuitem-new-window =
    .label = หน้าต่างใหม่
appmenuitem-new-private-window =
    .label = หน้าต่างส่วนตัวใหม่
appmenuitem-history =
    .label = ประวัติ
appmenuitem-downloads =
    .label = การดาวน์โหลด
appmenuitem-passwords =
    .label = รหัสผ่าน
appmenuitem-addons-and-themes =
    .label = ส่วนเสริมและชุดตกแต่ง
appmenuitem-print =
    .label = พิมพ์…
appmenuitem-find-in-page =
    .label = ค้นหาในหน้า…
appmenuitem-zoom =
    .value = ซูม
appmenuitem-more-tools =
    .label = เครื่องมือเพิ่มเติม
appmenuitem-help =
    .label = ช่วยเหลือ
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] ออก
           *[other] ออก
        }
appmenu-menu-button-closed2 =
    .tooltiptext = เปิดเมนูแอปพลิเคชัน
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = ปิดเมนูแอปพลิเคชัน
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = การตั้งค่า

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = ขยายเข้า
appmenuitem-zoom-reduce =
    .label = ขยายออก
appmenuitem-fullscreen =
    .label = เต็มหน้าจอ

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = ลงชื่อเข้า Sync…
appmenu-remote-tabs-turn-on-sync =
    .label = เปิด Sync…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = แสดงแท็บเพิ่มเติม
    .tooltiptext = แสดงแท็บเพิ่มเติมจากอุปกรณ์นี้
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = ไม่มีแท็บที่เปิดอยู่
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = เปิดการซิงค์แท็บเพื่อดูรายการแท็บจากอุปกรณ์อื่น ๆ ของคุณ
appmenu-remote-tabs-opensettings =
    .label = การตั้งค่า
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = ต้องการเห็นแท็บของคุณจากอุปกรณ์อื่น ๆ ที่นี่?
appmenu-remote-tabs-connectdevice =
    .label = เชื่อมต่ออุปกรณ์อื่น
appmenu-remote-tabs-welcome = ดูรายการแท็บจากอุปกรณ์อื่น ๆ ของคุณ
appmenu-remote-tabs-unverified = บัญชีของคุณจำเป็นต้องได้รับการยืนยัน
appmenuitem-fxa-toolbar-sync-now2 = ซิงค์ตอนนี้
appmenuitem-fxa-sign-in = ลงชื่อเข้า { -brand-product-name }
appmenuitem-fxa-manage-account = จัดการบัญชี
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = ซิงค์ล่าสุดเมื่อ { $time }
    .label = ซิงค์ล่าสุดเมื่อ { $time }
appmenu-fxa-sync-and-save-data2 = ซิงค์และบันทึกข้อมูล
appmenu-fxa-signed-in-label = ลงชื่อเข้า
appmenu-fxa-setup-sync =
    .label = เปิดการซิงค์…
appmenuitem-save-page =
    .label = บันทึกหน้าเป็น…

## What's New panel in App menu.

whatsnew-panel-header = มีอะไรใหม่
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = แจ้งเตือนเกี่ยวกับคุณลักษณะใหม่
    .accesskey = จ

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = ตัวสร้างโปรไฟล์
    .tooltiptext = บันทึกโปรไฟล์ประสิทธิภาพ
profiler-popup-button-recording =
    .label = ตัวสร้างโปรไฟล์
    .tooltiptext = ตัวสร้างโปรไฟล์กำลังอัดบันทึกโปรไฟล์
profiler-popup-button-capturing =
    .label = ตัวสร้างโปรไฟล์
    .tooltiptext = ตัวสร้างโปรไฟล์กำลังจับโปรไฟล์
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = แสดงข้อมูลเพิ่มเติม
profiler-popup-description-title =
    .value = บันทึก วิเคราะห์ แบ่งปัน
profiler-popup-description = ทำงานร่วมกันในปัญหาด้านประสิทธิภาพโดยการเผยแพร่โปรไฟล์เพื่อแบ่งปันกับทีมของคุณ
profiler-popup-learn-more-button =
    .label = เรียนรู้เพิ่มเติม
profiler-popup-settings =
    .value = การตั้งค่า
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = แก้ไขการตั้งค่า
profiler-popup-recording-screen = กำลังบันทึก…
profiler-popup-start-recording-button =
    .label = เริ่มการบันทึก
profiler-popup-discard-button =
    .label = ละทิ้ง
profiler-popup-capture-button =
    .label = จับ
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = ค่าที่ตั้งล่วงหน้าที่แนะนำสำหรับการดีบั๊กเว็บแอปส่วนใหญ่ โดยมีโอเวอร์เฮดต่ำ
profiler-popup-presets-web-developer-label =
    .label = นักพัฒนาเว็บ
profiler-popup-presets-firefox-description = ค่าที่ตั้งล่วงหน้าที่แนะนำสำหรับการรวบรวมประวัติ { -brand-shorter-name }
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = ค่าที่ตั้งล่วงหน้าสำหรับการตรวจสอบบั๊กเกี่ยวกับกราฟิกใน { -brand-shorter-name }
profiler-popup-presets-graphics-label =
    .label = กราฟิก
profiler-popup-presets-media-description2 = ค่าที่ตั้งล่วงหน้าสำหรับการตรวจสอบบั๊กเกี่ยวกับเสียงและวิดีโอใน { -brand-shorter-name }
profiler-popup-presets-media-label =
    .label = สื่อ
profiler-popup-presets-networking-description = ค่าที่ตั้งล่วงหน้าสำหรับการตรวจสอบบั๊กเกี่ยวกับระบบเครือข่ายใน { -brand-shorter-name }
profiler-popup-presets-networking-label =
    .label = ระบบเครือข่าย
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = พลังงาน
profiler-popup-presets-custom-label =
    .label = กำหนดเอง

## History panel

appmenu-manage-history =
    .label = จัดการประวัติ
appmenu-reopen-all-tabs = เปิดแท็บทั้งหมดใหม่
appmenu-reopen-all-windows = เปิดหน้าต่างทั้งหมดใหม่
appmenu-restore-session =
    .label = เรียกคืนวาระก่อนหน้า
appmenu-clear-history =
    .label = ล้างประวัติล่าสุด…
appmenu-recent-history-subheader = ประวัติล่าสุด
appmenu-recently-closed-tabs =
    .label = แท็บที่ปิดล่าสุด
appmenu-recently-closed-windows =
    .label = หน้าต่างที่ปิดล่าสุด

## Help panel

appmenu-help-header =
    .title = ความช่วยเหลือของ { -brand-shorter-name }
appmenu-about =
    .label = เกี่ยวกับ { -brand-shorter-name }
    .accesskey = ก
appmenu-get-help =
    .label = รับความช่วยเหลือ
    .accesskey = ช
appmenu-help-more-troubleshooting-info =
    .label = ข้อมูลการแก้ไขปัญหาเพิ่มเติม
    .accesskey = ข
appmenu-help-report-site-issue =
    .label = รายงานปัญหาไซต์…
appmenu-help-share-ideas =
    .label = แบ่งปันแนวคิดและคำติชม…
    .accesskey = บ

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = โหมดแก้ไขปัญหา…
    .accesskey = ห
appmenu-help-exit-troubleshoot-mode =
    .label = ปิดโหมดแก้ไขปัญหา
    .accesskey = ม

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = รายงานไซต์หลอกลวง…
    .accesskey = ห
appmenu-help-not-deceptive =
    .label = นี่ไม่ใช่ไซต์หลอกลวง…
    .accesskey = ห

## More Tools

appmenu-customizetoolbar =
    .label = ปรับแต่งแถบเครื่องมือ…
appmenu-developer-tools-subheader = เครื่องมือสำหรับเบราว์เซอร์
appmenu-developer-tools-extensions =
    .label = ส่วนขยายสำหรับนักพัฒนา
