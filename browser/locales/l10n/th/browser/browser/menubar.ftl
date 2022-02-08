# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = ค่ากำหนด
menu-application-services =
    .label = บริการ
menu-application-hide-this =
    .label = ซ่อน { -brand-shorter-name }
menu-application-hide-other =
    .label = ซ่อนอื่น ๆ
menu-application-show-all =
    .label = แสดงทั้งหมด
menu-application-touch-bar =
    .label = ปรับแต่งแถบสัมผัส…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] ออก
           *[other] ออก
        }
    .accesskey =
        { PLATFORM() ->
            [windows] อ
           *[other] อ
        }
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = ออกจาก { -brand-shorter-name }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = ออกจาก { -brand-shorter-name }
menu-about =
    .label = เกี่ยวกับ { -brand-shorter-name }
    .accesskey = ก

## File Menu

menu-file =
    .label = ไฟล์
    .accesskey = ฟ
menu-file-new-tab =
    .label = แท็บใหม่
    .accesskey = ท
menu-file-new-container-tab =
    .label = แท็บแยกข้อมูลใหม่
    .accesskey = ย
menu-file-new-window =
    .label = หน้าต่างใหม่
    .accesskey = ห
menu-file-new-private-window =
    .label = หน้าต่างส่วนตัวใหม่
    .accesskey = ส
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = เปิดตำแหน่งที่ตั้ง…
menu-file-open-file =
    .label = เปิดไฟล์…
    .accesskey = ป
menu-file-close =
    .label = ปิด
    .accesskey = ป
menu-file-close-window =
    .label = ปิดหน้าต่าง
    .accesskey = ป
menu-file-save-page =
    .label = บันทึกหน้าเป็น…
    .accesskey = น
menu-file-email-link =
    .label = ส่งอีเมลลิงก์…
    .accesskey = ล
menu-file-print-setup =
    .label = ตั้งค่าหน้ากระดาษ…
    .accesskey = ร
menu-file-print-preview =
    .label = ตัวอย่างก่อนพิมพ์
    .accesskey = ต
menu-file-print =
    .label = พิมพ์…
    .accesskey = พ
menu-file-import-from-another-browser =
    .label = นำเข้าจากเบราว์เซอร์อื่น…
    .accesskey = น
menu-file-go-offline =
    .label = ทำงานออฟไลน์
    .accesskey = ฟ

## Edit Menu

menu-edit =
    .label = แก้ไข
    .accesskey = ก
menu-edit-find-on =
    .label = ค้นหาในหน้านี้…
    .accesskey = ค
menu-edit-find-in-page =
    .label = ค้นหาในหน้า…
    .accesskey = ค
menu-edit-find-again =
    .label = ค้นหาอีกครั้ง
    .accesskey = น
menu-edit-bidi-switch-text-direction =
    .label = สลับทิศทางข้อความ
    .accesskey = ล

## View Menu

menu-view =
    .label = มุมมอง
    .accesskey = ม
menu-view-toolbars-menu =
    .label = แถบเครื่องมือ
    .accesskey = ถ
menu-view-customize-toolbar =
    .label = ปรับแต่ง…
    .accesskey = ป
menu-view-customize-toolbar2 =
    .label = ปรับแต่งแถบเครื่องมือ…
    .accesskey = ป
menu-view-sidebar =
    .label = แถบข้าง
    .accesskey = บ
menu-view-bookmarks =
    .label = ที่คั่นหน้า
menu-view-history-button =
    .label = ประวัติ
menu-view-synced-tabs-sidebar =
    .label = แท็บที่ซิงค์
menu-view-full-zoom =
    .label = ซูม
    .accesskey = ม
menu-view-full-zoom-enlarge =
    .label = ซูมเข้า
    .accesskey = ม
menu-view-full-zoom-reduce =
    .label = ซูมออก
    .accesskey = อ
menu-view-full-zoom-actual-size =
    .label = ขนาดจริง
    .accesskey = ข
menu-view-full-zoom-toggle =
    .label = ซูมข้อความเท่านั้น
    .accesskey = ข
menu-view-page-style-menu =
    .label = ลักษณะหน้า
    .accesskey = ล
menu-view-page-style-no-style =
    .label = ไม่มีลักษณะ
    .accesskey = ม
menu-view-page-basic-style =
    .label = ลักษณะหน้าพื้นฐาน
    .accesskey = ล
menu-view-charset =
    .label = รหัสอักขระ
    .accesskey = ร

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = เข้าสู่ภาพเต็มหน้าจอ
    .accesskey = จ
menu-view-exit-full-screen =
    .label = ออกจากภาพเต็มหน้าจอ
    .accesskey = จ
menu-view-full-screen =
    .label = เต็มหน้าจอ
    .accesskey = จ

##

menu-view-show-all-tabs =
    .label = แสดงแท็บทั้งหมด
    .accesskey = ส
menu-view-bidi-switch-page-direction =
    .label = สลับทิศทางหน้ากระดาษ
    .accesskey = ส

## History Menu

menu-history =
    .label = ประวัติ
    .accesskey = ป
menu-history-show-all-history =
    .label = แสดงประวัติทั้งหมด
menu-history-clear-recent-history =
    .label = ล้างประวัติล่าสุด…
menu-history-synced-tabs =
    .label = แท็บที่ซิงค์
menu-history-restore-last-session =
    .label = เรียกคืนวาระก่อนหน้า
menu-history-hidden-tabs =
    .label = แท็บที่ซ่อนอยู่
menu-history-undo-menu =
    .label = แท็บที่ปิดล่าสุด
menu-history-undo-window-menu =
    .label = หน้าต่างที่ปิดล่าสุด
menu-history-reopen-all-tabs = เปิดแท็บทั้งหมดใหม่
menu-history-reopen-all-windows = เปิดหน้าต่างทั้งหมดใหม่

## Bookmarks Menu

menu-bookmarks-menu =
    .label = ที่คั่นหน้า
    .accesskey = ท
menu-bookmarks-show-all =
    .label = แสดงที่คั่นหน้าทั้งหมด
menu-bookmark-this-page =
    .label = เพิ่มที่คั่นหน้าสำหรับหน้านี้
menu-bookmark-current-tab =
    .label = เพิ่มที่คั่นหน้าแท็บปัจจุบัน
menu-bookmark-edit =
    .label = แก้ไขที่คั่นหน้านี้
menu-bookmarks-all-tabs =
    .label = เพิ่มที่คั่นหน้าสำหรับแท็บทั้งหมด…
menu-bookmarks-toolbar =
    .label = แถบเครื่องมือที่คั่นหน้า
menu-bookmarks-other =
    .label = ที่คั่นหน้าอื่น ๆ
menu-bookmarks-mobile =
    .label = ที่คั่นหน้าในมือถือ

## Tools Menu

menu-tools =
    .label = เครื่องมือ
    .accesskey = ค
menu-tools-downloads =
    .label = การดาวน์โหลด
    .accesskey = ด
menu-tools-addons =
    .label = ส่วนเสริม
    .accesskey = ส
menu-tools-fxa-sign-in =
    .label = ลงชื่อเข้า { -brand-product-name }…
    .accesskey = g
menu-tools-addons-and-themes =
    .label = ส่วนเสริมและชุดตกแต่ง
    .accesskey = ส
menu-tools-fxa-sign-in2 =
    .label = ลงชื่อเข้า
    .accesskey = ล
menu-tools-turn-on-sync =
    .label = เปิด { -sync-brand-short-name }…
    .accesskey = n
menu-tools-turn-on-sync2 =
    .label = เปิด Sync…
    .accesskey = เ
menu-tools-sync-now =
    .label = ซิงค์ตอนนี้
    .accesskey = ง
menu-tools-fxa-re-auth =
    .label = เชื่อมต่อกับ { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = นักพัฒนาเว็บ
    .accesskey = พ
menu-tools-browser-tools =
    .label = เครื่องมือสำหรับเบราว์เซอร์
    .accesskey = บ
menu-tools-task-manager =
    .label = ตัวจัดการงาน
    .accesskey = ต
menu-tools-page-source =
    .label = ต้นฉบับหน้า
    .accesskey = ต
menu-tools-page-info =
    .label = ข้อมูลหน้า
    .accesskey = ข
menu-settings =
    .label = การตั้งค่า
    .accesskey =
        { PLATFORM() ->
            [windows] ก
           *[other] า
        }
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] ตัวเลือก
           *[other] ค่ากำหนด
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ต
           *[other] ด
        }
menu-tools-layout-debugger =
    .label = ตัวดีบั๊กเค้าโครง
    .accesskey = ต

## Window Menu

menu-window-menu =
    .label = หน้าต่าง
menu-window-bring-all-to-front =
    .label = นำทั้งหมดมาข้างหน้า

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = ช่วยเหลือ
    .accesskey = ช
menu-help-product =
    .label = ความช่วยเหลือของ { -brand-shorter-name }
    .accesskey = ช
menu-help-show-tour =
    .label = เที่ยวชม { -brand-shorter-name }
    .accesskey = ท
menu-help-import-from-another-browser =
    .label = นำเข้าจากเบราว์เซอร์อื่น…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = แป้นพิมพ์ลัด
    .accesskey = ล
menu-get-help =
    .label = รับความช่วยเหลือ
    .accesskey = ช
menu-help-troubleshooting-info =
    .label = ข้อมูลการแก้ไขปัญหา
    .accesskey = ป
menu-help-taskmanager =
    .label = ตัวจัดการงาน
menu-help-more-troubleshooting-info =
    .label = ข้อมูลการแก้ไขปัญหาเพิ่มเติม
    .accesskey = ข
menu-help-report-site-issue =
    .label = รายงานปัญหาไซต์…
menu-help-feedback-page =
    .label = ส่งข้อคิดเห็น…
    .accesskey = ส
menu-help-safe-mode-without-addons =
    .label = เริ่มการทำงานใหม่พร้อมปิดใช้งานส่วนเสริม…
    .accesskey = ร
menu-help-safe-mode-with-addons =
    .label = เริ่มการทำงานใหม่พร้อมเปิดใช้งานส่วนเสริม
    .accesskey = ร
menu-help-enter-troubleshoot-mode2 =
    .label = โหมดแก้ไขปัญหา…
    .accesskey = ห
menu-help-exit-troubleshoot-mode =
    .label = ปิดโหมดแก้ไขปัญหา
    .accesskey = ด
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = รายงานไซต์หลอกลวง…
    .accesskey = ห
menu-help-not-deceptive =
    .label = นี่ไม่ใช่ไซต์หลอกลวง…
    .accesskey = ห
