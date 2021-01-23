# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = ข้อมูลการเข้าสู่ระบบและรหัสผ่าน

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = นำรหัสผ่านของคุณไปทุกที่
login-app-promo-subtitle = รับแอป { -lockwise-brand-name } ฟรี
login-app-promo-android =
    .alt = รับบน Google Play
login-app-promo-apple =
    .alt = ดาวน์โหลดบน App Store

login-filter =
    .placeholder = ค้นหาข้อมูลการเข้าสู่ระบบ

create-login-button = สร้างการเข้าสู่ระบบใหม่

fxaccounts-sign-in-text = รับรหัสผ่านของคุณบนอุปกรณ์อื่น ๆ ของคุณ
fxaccounts-sign-in-button = ลงชื่อเข้า { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = จัดการบัญชี

## The ⋯ menu that is in the top corner of the page

menu =
    .title = เปิดเมนู
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = นำเข้าจากเบราว์เซอร์อื่น…
about-logins-menu-menuitem-import-from-a-file = นำเข้าจากไฟล์…
about-logins-menu-menuitem-export-logins = ส่งออกข้อมูลการเข้าสู่ระบบ ...
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] ตัวเลือก
       *[other] ค่ากำหนด
    }
about-logins-menu-menuitem-help = ช่วยเหลือ
menu-menuitem-android-app = { -lockwise-brand-short-name } สำหรับ Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } สำหรับ iPhone และ iPad

## Login List

login-list =
    .aria-label = ข้อมูลการเข้าสู่ระบบที่ตรงกับคำค้น
login-list-count =
    { $count ->
       *[other] { $count } ข้อมูลการเข้าสู่ระบบ
    }
login-list-sort-label-text = เรียงลำดับตาม:
login-list-name-option = ชื่อตามตัวอักษร
login-list-name-reverse-option = ชื่อ (Z-A)
about-logins-login-list-alerts-option = การแจ้งเตือน
login-list-last-changed-option = วันที่เปลี่ยนแปลงล่าสุด
login-list-last-used-option = วันที่ใช้ครั้งล่าสุด
login-list-intro-title = ไม่พบข้อมูลการเข้าสู่ระบบ
login-list-intro-description = เมื่อคุณบันทึกรหัสผ่านใน { -brand-product-name } รหัสผ่านจะปรากฏขึ้นที่นี่
about-logins-login-list-empty-search-title = ไม่พบข้อมูลการเข้าสู่ระบบ
about-logins-login-list-empty-search-description = ไม่มีผลลัพธ์ที่ตรงกับการค้นหาของคุณ
login-list-item-title-new-login = การเข้าสู่ระบบใหม่
login-list-item-subtitle-new-login = ป้อนข้อมูลรับรองการเข้าสู่ระบบของคุณ
login-list-item-subtitle-missing-username = (ไม่มีชื่อผู้ใช้)
about-logins-list-item-breach-icon =
    .title = เว็บไซต์ที่มีการรั่วไหล
about-logins-list-item-vulnerable-password-icon =
    .title = รหัสผ่านที่อ่อนแอ

## Introduction screen

login-intro-heading = กำลังมองหาข้อมูลการเข้าสู่ระบบที่บันทึกไว้ของคุณหรือไม่? ตั้งค่า { -sync-brand-short-name }

about-logins-login-intro-heading-logged-out = กำลังมองหาข้อมูลการเข้าสู่ระบบที่บันทึกไว้ของคุณหรือไม่? ตั้งค่า { -sync-brand-short-name } หรือนำเข้า
about-logins-login-intro-heading-logged-in = ไม่พบข้อมูลการเข้าสู่ระบบที่ซิงค์
login-intro-description = หากคุณบันทึกข้อมูลการเข้าสู่ระบบของคุณไว้ที่ { -brand-product-name } บนอุปกรณ์อื่น ๆ คุณสามารถนำมาใช้บนอุปกรณ์นี้ได้ด้วยวิธีนี้:
login-intro-instruction-fxa = สร้างหรือลงชื่อเข้าใช้ { -fxaccount-brand-name } ของคุณบนอุปกรณ์ที่บันทึกข้อมูลการเข้าสู่ระบบของคุณ
login-intro-instruction-fxa-settings = ตรวจสอบให้แน่ใจว่าคุณได้เลือกกล่องกาเครื่องหมายข้อมูลการเข้าสู่ระบบในการตั้งค่า { -sync-brand-short-name }
about-logins-intro-instruction-help = เยี่ยมชม<a data-l10n-name="help-link">ฝ่ายสนับสนุน { -lockwise-brand-short-name }</a> สำหรับวิธีใช้เพิ่มเติม
about-logins-intro-import = หากข้อมูลการเข้าสู่ระบบของคุณถูกบันทึกไว้ในเบราว์เซอร์อื่น คุณสามารถ<a data-l10n-name="import-link">นำเข้าข้อมูลเหล่านี้ใน { -lockwise-brand-short-name }</a> ได้

about-logins-intro-import2 = หากข้อมูลการเข้าสู่ระบบของคุณถูกบันทึกไว้ภายนอก { -brand-product-name } คุณสามารถ<a data-l10n-name="import-browser-link">นำเข้าจากเบราว์เซอร์อื่น</a>หรือ<a data-l10n-name="import-file-link">จากไฟล์</a>ได้

## Login

login-item-new-login-title = สร้างข้อมูลการเข้าสู่ระบบใหม่
login-item-edit-button = แก้ไข
about-logins-login-item-remove-button = ลบ
login-item-origin-label = ที่อยู่เว็บไซต์
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = ชื่อผู้ใช้
about-logins-login-item-username =
    .placeholder = (ไม่มีชื่อผู้ใช้)
login-item-copy-username-button-text = คัดลอก
login-item-copied-username-button-text = คัดลอกแล้ว!
login-item-password-label = รหัสผ่าน
login-item-password-reveal-checkbox =
    .aria-label = แสดงรหัสผ่าน
login-item-copy-password-button-text = คัดลอก
login-item-copied-password-button-text = คัดลอกแล้ว!
login-item-save-changes-button = บันทึกการเปลี่ยนแปลง
login-item-save-new-button = บันทึก
login-item-cancel-button = ยกเลิก
login-item-time-changed = วันที่เปลี่ยนแปลงล่าสุด: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = วันที่สร้าง: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = วันที่ใช้ครั้งล่าสุด: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = หากต้องการแก้ไขข้อมูลการเข้าสู่ระบบของคุณ ให้ป้อนข้อมูลประจำตัวการเข้าสู่ระบบ Windows ของคุณ ซึ่งจะช่วยปกป้องความปลอดภัยให้กับบัญชีต่าง ๆ ของคุณ
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = แก้ไขข้อมูลการเข้าสู่ระบบที่บันทึกไว้

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = หากต้องการดูรหัสผ่านของคุณ ให้ป้อนข้อมูลประจำตัวการเข้าสู่ระบบ Windows ของคุณ ซึ่งจะช่วยปกป้องความปลอดภัยให้กับบัญชีต่าง ๆ ของคุณ
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = เผยรหัสผ่านที่บันทึกไว้

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = หากต้องการคัดลอกรหัสผ่านของคุณ ให้ป้อนข้อมูลประจำตัวการเข้าสู่ระบบ Windows ของคุณ ซึ่งจะช่วยปกป้องความปลอดภัยให้กับบัญชีต่าง ๆ ของคุณ
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = คัดลอกรหัสผ่านที่บันทึกไว้

## Master Password notification

master-password-notification-message = โปรดป้อนรหัสผ่านหลักของคุณเพื่อดูข้อมูลการเข้าสู่ระบบและรหัสผ่านที่บันทึกไว้

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = หากต้องการส่งออกข้อมูลการเข้าสู่ระบบของคุณ ให้ป้อนข้อมูลประจำตัวการเข้าสู่ระบบ Windows ของคุณ ซึ่งจะช่วยปกป้องความปลอดภัยให้กับบัญชีต่าง ๆ ของคุณ
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = ส่งออกข้อมูลการเข้าสู่ระบบและรหัสผ่านที่บันทึกไว้

## Primary Password notification

about-logins-primary-password-notification-message = โปรดป้อนรหัสผ่านหลักของคุณเพื่อดูข้อมูลการเข้าสู่ระบบและรหัสผ่านที่บันทึกไว้
master-password-reload-button =
    .label = เข้าสู่ระบบ
    .accesskey = ข

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] ต้องการข้อมูลการเข้าสู่ระบบของคุณทุกที่ที่คุณใช้ { -brand-product-name } หรือไม่? ไปที่ตัวเลือก { -sync-brand-short-name } ของคุณแล้วเลือกกล่องกาเครื่องหมาย ข้อมูลการเข้าสู่ระบบ
       *[other] ต้องการข้อมูลการเข้าสู่ระบบของคุณทุกที่ที่คุณใช้ { -brand-product-name } หรือไม่? ไปที่ค่ากำหนด { -sync-brand-short-name } ของคุณแล้วเลือกกล่องกาเครื่องหมาย ข้อมูลการเข้าสู่ระบบ
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] เยี่ยมชมตัวเลือก { -sync-brand-short-name }
           *[other] เยี่ยมชมค่ากำหนด { -sync-brand-short-name }
        }
    .accesskey = ย
about-logins-enable-password-sync-dont-ask-again-button =
    .label = ไม่ต้องถามฉันอีก
    .accesskey = ม

## Dialogs

confirmation-dialog-cancel-button = ยกเลิก
confirmation-dialog-dismiss-button =
    .title = ยกเลิก

about-logins-confirm-remove-dialog-title = ลบการเข้าสู่ระบบนี้?
confirm-delete-dialog-message = การกระทำนี้ไม่สามารถเลิกทำได้
about-logins-confirm-remove-dialog-confirm-button = ลบ

about-logins-confirm-export-dialog-title = ส่งออกข้อมูลการเข้าสู่ระบบและรหัสผ่าน
about-logins-confirm-export-dialog-message = รหัสผ่านของคุณจะถูกบันทึกเป็นข้อความที่อ่านได้ (เช่น BadP@ssw0rd) ดังนั้นใครก็ตามที่สามารถเปิดไฟล์ที่ส่งออกได้จะสามารถดูได้
about-logins-confirm-export-dialog-confirm-button = ส่งออก…

confirm-discard-changes-dialog-title = ละทิ้งการเปลี่ยนแปลงที่ยังไม่ได้บันทึก?
confirm-discard-changes-dialog-message = การเปลี่ยนแปลงที่ยังไม่ได้บันทึกทั้งหมดจะสูญหาย
confirm-discard-changes-dialog-confirm-button = ละทิ้ง

## Breach Alert notification

about-logins-breach-alert-title = การรั่วไหลของเว็บไซต์
breach-alert-text = รหัสผ่านถูกรั่วไหลหรือถูกขโมยจากเว็บไซต์นี้ตั้งแต่คุณอัปเดตรายละเอียดการเข้าสู่ระบบครั้งล่าสุด เปลี่ยนรหัสผ่านของคุณเพื่อปกป้องบัญชีของคุณ
about-logins-breach-alert-date = การรั่วไหลนี้เกิดขึ้นเมื่อ { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = ไปยัง { $hostname }
about-logins-breach-alert-learn-more-link = เรียนรู้เพิ่มเติม

## Vulnerable Password notification

about-logins-vulnerable-alert-title = รหัสผ่านที่อ่อนแอ
about-logins-vulnerable-alert-text2 = รหัสผ่านนี้ถูกใช้ในบัญชีอื่นที่เป็นไปได้ว่ามีการรั่วไหลของข้อมูล การใช้ข้อมูลประจำตัวซ้ำจะทำให้บัญชีทั้งหมดของคุณมีความเสี่ยง โปรดเปลี่ยนรหัสผ่านนี้
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = ไปยัง { $hostname }
about-logins-vulnerable-alert-learn-more-link = เรียนรู้เพิ่มเติม

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = มีรายการสำหรับ { $loginTitle } พร้อมชื่อผู้ใช้นั้นแล้ว <a data-l10n-name="duplicate-link">ต้องการไปยังรายการที่มีอยู่หรือไม่?</a>

# This is a generic error message.
about-logins-error-message-default = เกิดข้อผิดพลาดขณะพยายามบันทึกรหัสผ่านนี้


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = ส่งออกไฟล์ข้อมูลการเข้าสู่ระบบ
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = ส่งออก
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] ไฟล์ CSV
       *[other] ไฟล์ CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = นำเข้าไฟล์ข้อมูลการเข้าสู่ระบบ
about-logins-import-file-picker-import-button = นำเข้า
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] เอกสาร CSV
       *[other] ไฟล์ CSV
    }
