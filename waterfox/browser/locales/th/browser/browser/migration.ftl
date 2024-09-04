# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = ตัวช่วยนำเข้า

import-from =
    { PLATFORM() ->
        [windows] นำเข้าตัวเลือก, ที่คั่นหน้า, ประวัติ, รหัสผ่าน และข้อมูลอื่น ๆ จาก:
       *[other] นำเข้าการกำหนดลักษณะ, ที่คั่นหน้า, ประวัติ, รหัสผ่าน และข้อมูลอื่น ๆ จาก:
    }

import-from-bookmarks = นำเข้าที่คั่นหน้าจาก:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = ไม่นำเข้าสิ่งใด
    .accesskey = ม
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-opera =
    .label = Opera
    .accesskey = O
import-from-vivaldi =
    .label = Vivaldi
    .accesskey = V
import-from-brave =
    .label = Brave
    .accesskey = r
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3
import-from-opera-gx =
    .label = Opera GX
    .accesskey = G

no-migration-sources = ไม่พบโปรแกรมที่มีข้อมูลที่คั่นหน้า, ประวัติ หรือรหัสผ่าน

import-source-page-title = นำเข้าการตั้งค่าและข้อมูล
import-items-page-title = รายการที่จะนำเข้า

import-items-description = เลือกรายการที่จะนำเข้า:

import-permissions-page-title = โปรดมอบสิทธิอนุญาตแก่ { -brand-short-name }

# Do not translate "Safari" (the name of the browser on Apple devices)
import-safari-permissions-string = macOS ต้องการให้คุณอนุญาต { -brand-short-name } ให้เข้าถึงข้อมูลของ Safari อย่างชัดเจน กรุณาคลิก “ดำเนินการต่อ” จากนั้นเลือกโฟลเดอร์ “Safari“ ในกล่องโต้ตอบของ Finder ที่จะปรากฏขึ้น แล้วคลิก “เปิด”

import-migrating-page-title = กำลังนำเข้า…

import-migrating-description = รายการดังต่อไปนี้กำลังถูกนำเข้า…

import-select-profile-page-title = เลือกโปรไฟล์

import-select-profile-description = โปรไฟล์ดังต่อไปนี้พร้อมที่จะนำเข้า:

import-done-page-title = การนำเข้าเสร็จสมบูรณ์

import-done-description = นำเข้ารายการต่อไปนี้สำเร็จ:

import-close-source-browser = โปรดแน่ใจว่าเบราว์เซอร์ที่เลือกถูกปิดแล้วก่อนดำเนินการต่อ

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-chrome = Google Chrome

imported-safari-reading-list = รายการอ่าน (จาก Safari)
imported-edge-reading-list = รายการอ่าน (จาก Edge)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = คุกกี้
browser-data-cookies-label =
    .value = คุกกี้

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] ประวัติการเรียกดูและที่คั่นหน้า
           *[other] ประวัติการเรียกดู
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] ประวัติการเรียกดูและที่คั่นหน้า
           *[other] ประวัติการเรียกดู
        }

browser-data-formdata-checkbox =
    .label = ประวัติแบบฟอร์มที่บันทึกไว้
browser-data-formdata-label =
    .value = ประวัติแบบฟอร์มที่บันทึกไว้

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = การเข้าสู่ระบบและรหัสผ่านที่บันทึกไว้
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = การเข้าสู่ระบบและรหัสผ่านที่บันทึกไว้

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] รายการโปรด
            [edge] รายการโปรด
           *[other] ที่คั่นหน้า
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] รายการโปรด
            [edge] รายการโปรด
           *[other] ที่คั่นหน้า
        }

browser-data-otherdata-checkbox =
    .label = ข้อมูลอื่น ๆ
browser-data-otherdata-label =
    .label = ข้อมูลอื่น ๆ

browser-data-session-checkbox =
    .label = หน้าต่างและแท็บ
browser-data-session-label =
    .value = หน้าต่างและแท็บ

browser-data-payment-methods-checkbox =
    .label = วิธีการชำระเงิน
browser-data-payment-methods-label =
    .value = วิธีการชำระเงิน
