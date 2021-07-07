# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = ปิด
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] ตัวเลือก
           *[other] ค่ากำหนด
        }
category-list =
    .aria-label = หมวดหมู่
pane-general-title = ทั่วไป
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = การเขียน
category-compose =
    .tooltiptext = การเขียน
pane-privacy-title = ความเป็นส่วนตัวและความปลอดภัย
category-privacy =
    .tooltiptext = ความเป็นส่วนตัวและความปลอดภัย
pane-chat-title = แชท
category-chat =
    .tooltiptext = แชท
pane-calendar-title = ปฏิทิน
category-calendar =
    .tooltiptext = ปฏิทิน
general-language-and-appearance-header = ภาษาและลักษณะที่ปรากฏ
general-incoming-mail-header = จดหมายขาเข้า
general-files-and-attachment-header = ไฟล์และสิ่งที่แนบมา
general-tags-header = ป้ายกำกับ
general-reading-and-display-header = การอ่านและการแสดงผล
general-updates-header = การอัปเดต
general-network-and-diskspace-header = เครือข่ายและพื้นที่ดิสก์
general-indexing-label = การจัดทำดัชนี
composition-category-header = การเขียนข้อความ
composition-attachments-header = สิ่งที่แนบมา
composition-spelling-title = การสะกดคำ
compose-html-style-title = ลักษณะ HTML
composition-addressing-header = การกำหนดที่อยู่
privacy-main-header = ความเป็นส่วนตัว
privacy-passwords-header = รหัสผ่าน
privacy-junk-header = ขยะ
collection-header = การเก็บรวบรวมและใช้ข้อมูล { -brand-short-name }
collection-description = เรามุ่งมั่นที่จะให้ทางเลือกกับคุณและเก็บรวบรวมเฉพาะสิ่งที่เราจำเป็นต้องจัดหาและปรับปรุง { -brand-short-name } สำหรับทุกคน เราร้องขอการอนุญาตก่อนที่จะรับข้อมูลส่วนบุคคลเสมอ
collection-privacy-notice = ประกาศความเป็นส่วนตัว
collection-health-report-telemetry-disabled = คุณจะไม่อนุญาตให้ { -vendor-short-name } เก็บข้อมูลทางเทคนิคและการโต้ตอบอีกต่อไป ข้อมูลที่ผ่านมาทั้งหมดจะถูกลบภายใน 30 วัน
collection-health-report-telemetry-disabled-link = เรียนรู้เพิ่มเติม
collection-health-report =
    .label = อนุญาตให้ { -brand-short-name } ส่งข้อมูลทางเทคนิคและการโต้ตอบไปยัง { -vendor-short-name }
    .accesskey = ญ
collection-health-report-link = เรียนรู้เพิ่มเติม
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = การรายงานข้อมูลถูกปิดใช้งานสำหรับการกำหนดค่าการสร้างนี้
collection-backlogged-crash-reports =
    .label = อนุญาตให้ { -brand-short-name } ส่งรายงานข้อขัดข้องที่ค้างอยู่ในนามของคุณ
    .accesskey = ข
collection-backlogged-crash-reports-link = เรียนรู้เพิ่มเติม
privacy-security-header = ความปลอดภัย
privacy-scam-detection-title = การตรวจจับการหลอกลวง
privacy-anti-virus-title = การป้องกันไวรัส
privacy-certificates-title = ใบรับรอง
chat-pane-header = แชท
chat-status-title = สถานะ
chat-notifications-title = การแจ้งเตือน
chat-pane-styling-header = การกำหนดลักษณะ
choose-messenger-language-description = เลือกภาษาที่ใช้แสดงเมนู, ข้อความ และการแจ้งเตือนจาก { -brand-short-name }
manage-messenger-languages-button =
    .label = ตั้งทางเลือก…
    .accesskey = ต
confirm-messenger-language-change-description = เริ่มการทำงาน { -brand-short-name } ใหม่เพื่อใช้การเปลี่ยนแปลงเหล่านี้
confirm-messenger-language-change-button = นำไปใช้แล้วเริ่มการทำงานใหม่
update-setting-write-failure-title = เกิดข้อผิดพลาดในการบันทึกค่ากำหนดการอัปเดต
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } พบข้อผิดพลาดและไม่ได้บันทึกการเปลี่ยนแปลงนี้ โปรดทราบว่าการตั้งค่าค่ากำหนดการอัปเดตนี้จำเป็นต้องได้รับสิทธิอนุญาตให้เขียนไปยังไฟล์ด้านล่าง คุณหรือผู้ดูแลระบบอาจสามารถแก้ไขข้อผิดพลาดได้ด้วยการมอบสิทธิ์ให้กับกลุ่มผู้ใช้เพื่อให้สามารถควบคุมไฟล์นี้ได้อย่างเต็มที่
    
    ไม่สามารถเขียนไปยังไฟล์: { $path }
update-in-progress-title = กำลังปรับปรุง
update-in-progress-message = คุณต้องการให้ { -brand-short-name } ดำเนินการต่อกับการอัปเดตนี้หรือไม่?
update-in-progress-ok-button = &ละทิ้ง
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &ดำเนินการต่อ
account-button = การตั้งค่าบัญชี
addons-button = ส่วนขยายและชุดตกแต่ง

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = หากต้องการสร้างรหัสผ่านหลัก ให้ป้อนข้อมูลประจำตัวการเข้าสู่ระบบ Windows ของคุณ ซึ่งจะช่วยปกป้องความปลอดภัยให้กับบัญชีต่าง ๆ ของคุณ
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = สร้างรหัสผ่านหลัก
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = หากต้องการสร้างรหัสผ่านหลัก ให้ป้อนข้อมูลประจำตัวการเข้าสู่ระบบ Windows ของคุณ ซึ่งจะช่วยปกป้องความปลอดภัยให้กับบัญชีต่าง ๆ ของคุณ
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = สร้างรหัสผ่านหลัก
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = หน้าเริ่มต้นของ { -brand-short-name }
start-page-label =
    .label = เมื่อ { -brand-short-name } เริ่มทำงานแล้ว ให้แสดงหน้าเริ่มต้นในพื้นที่ข้อความ
    .accesskey = ม
location-label =
    .value = ตำแหน่งที่ตั้ง:
    .accesskey = ต
restore-default-label =
    .label = เรียกคืนค่าเริ่มต้น
    .accesskey = ร
default-search-engine = เครื่องมือค้นหาเริ่มต้น
add-search-engine =
    .label = เพิ่มจากไฟล์
    .accesskey = พ
remove-search-engine =
    .label = เอาออก
    .accesskey = อ
minimize-to-tray-label =
    .label = เมื่อย่อ { -brand-short-name } ให้เล็กสุดแล้ว ให้ย้ายไปที่ถาด
    .accesskey = ย
new-message-arrival = เมื่อมีข้อความใหม่มาถึง:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] เล่นไฟล์เสียงดังต่อไปนี้:
           *[other] เล่นเสียง
        }
    .accesskey =
        { PLATFORM() ->
            [macos] น
           *[other] น
        }
mail-play-button =
    .label = เล่น
    .accesskey = ล
change-dock-icon = เปลี่ยนการตั้งค่าสำหรับไอคอนแอป
app-icon-options =
    .label = ตัวเลือกไอคอนแอป…
    .accesskey = ไ
notification-settings = สามารถปิดใช้งานเสียงการแจ้งเตือนและ่าเริ่มต้นได้บนบานหน้าต่างการแจ้งเตือนในค่ากำหนดระบบ
animated-alert-label =
    .label = แสดงการแจ้งเตือน
    .accesskey = แ
customize-alert-label =
    .label = ปรับแต่ง…
    .accesskey = ป
tray-icon-label =
    .label = แสดงไอคอนถาด
    .accesskey = ถ
mail-system-sound-label =
    .label = เสียงระบบเริ่มต้นสำหรับจดหมายใหม่
    .accesskey = ส
mail-custom-sound-label =
    .label = ใช้ไฟล์เสียงดังต่อไปนี้
    .accesskey = ช
mail-browse-sound-button =
    .label = เรียกดู…
    .accesskey = เ
enable-gloda-search-label =
    .label = เปิดใช้งานการค้นหาส่วนกลางและตัวทำดัชนี
    .accesskey = ป
datetime-formatting-legend = การจัดรูปแบบวันที่และเวลา
language-selector-legend = ภาษา
allow-hw-accel =
    .label = ใช้การเร่งความเร็วด้วยฮาร์ดแวร์เมื่อพร้อมใช้งาน
    .accesskey = ช
store-type-label =
    .value = ชนิดการเก็บข้อความสำหรับบัญชีใหม่:
    .accesskey = น
mbox-store-label =
    .label = ไฟล์ต่อโฟลเดอร์ (mbox)
maildir-store-label =
    .label = ไฟล์ต่อข้อความ (maildir)
scrolling-legend = การเลื่อน
autoscroll-label =
    .label = ใช้การเลื่อนอัตโนมัติ
    .accesskey = ช
smooth-scrolling-label =
    .label = ใช้การเลื่อนแบบลื่นไหล
    .accesskey = ก
system-integration-legend = การผนวกรวมระบบ
always-check-default =
    .label = ตรวจสอบเสมอว่า { -brand-short-name } เป็นไคลเอนต์จดหมายเริ่มต้นหรือไม่เมื่อเริ่มต้น
    .accesskey = ต
check-default-button =
    .label = ตรวจสอบตอนนี้…
    .accesskey = ต
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }
search-integration-label =
    .label = อนุญาตให้ { search-engine-name } ค้นหาข้อความ
    .accesskey = อ
config-editor-button =
    .label = ตัวแก้ไขการกำหนดค่า…
    .accesskey = ว
return-receipts-description = กำหนดวิธีที่ { -brand-short-name } จัดการการแจ้งเตือนการเปิดอ่าน
return-receipts-button =
    .label = การแจ้งเตือนการเปิดอ่าน…
    .accesskey = ก
update-app-legend = การอัปเดต { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = รุ่น { $version }
allow-description = อนุญาตให้ { -brand-short-name }
automatic-updates-label =
    .label = ติดตั้งการอัปเดตโดยอัตโนมัติ (แนะนำ: ช่วยเพิ่มความปลอดภัย)
    .accesskey = ต
check-updates-label =
    .label = ตรวจสอบการอัปเดต แต่ให้ฉันเลือกว่าจะติดตั้งหรือไม่
    .accesskey = ร
update-history-button =
    .label = แสดงประวัติการอัปเดต
    .accesskey = ส
use-service =
    .label = ใช้บริการเบื้องหลังเพื่อติดตั้งการอัปเดต
    .accesskey = ช
cross-user-udpate-warning = การตั้งค่านี้จะนำไปใช้กับบัญชี Windows ทั้งหมดและโปรไฟล์ { -brand-short-name } ที่ใช้ { -brand-short-name } รุ่นที่ติดตั้งนี้
networking-legend = การเชื่อมต่อ
proxy-config-description = กำหนดค่าวิธีที่ { -brand-short-name } เชื่อมต่อกับอินเทอร์เน็ต
network-settings-button =
    .label = การตั้งค่า…
    .accesskey = ก
offline-legend = ออฟไลน์
offline-settings = กำหนดค่าการตั้งค่าออฟไลน์
offline-settings-button =
    .label = ออฟไลน์…
    .accesskey = อ
diskspace-legend = เนื้อที่ดิสก์
offline-compact-folder =
    .label = กระชับโฟลเดอร์ทั้งหมดเมื่อสามารถประหยัดได้มากกว่า
    .accesskey = ก
compact-folder-size =
    .value = MB ของขนาดรวม

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = ใช้ถึง
    .accesskey = ช
use-cache-after = MB ของพื้นที่สำหรับแคช

##

smart-cache-label =
    .label = เขียนทับการจัดการแคชอัตโนมัติ
    .accesskey = ข
clear-cache-button =
    .label = ล้างตอนนี้
    .accesskey = ล
fonts-legend = แบบอักษรและสี
default-font-label =
    .value = แบบอักษรเริ่มต้น:
    .accesskey = บ
default-size-label =
    .value = ขนาด:
    .accesskey = ข
font-options-button =
    .label = ขั้นสูง…
    .accesskey = น
color-options-button =
    .label = สี…
    .accesskey = ส
display-width-legend = ข้อความตัวอักษรธรรมดา
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = แสดงไอคอนสื่ออารมณ์เป็นกราฟิก
    .accesskey = แ
display-text-label = เมื่อแสดงข้อความตัวอักษรธรรมดาที่ถูกอ้างอิง:
style-label =
    .value = ลักษณะ:
    .accesskey = ล
regular-style-item =
    .label = ธรรมดา
bold-style-item =
    .label = ตัวหนา
italic-style-item =
    .label = ตัวเอียง
bold-italic-style-item =
    .label = ตัวเอียงหนา
size-label =
    .value = ขนาด:
    .accesskey = ข
regular-size-item =
    .label = ธรรมดา
bigger-size-item =
    .label = ใหญ่
smaller-size-item =
    .label = เล็กลง
quoted-text-color =
    .label = สี:
    .accesskey = ส
search-input =
    .placeholder = ค้นหา
type-column-label =
    .label = ชนิดเนื้อหา
    .accesskey = ช
action-column-label =
    .label = การกระทำ
    .accesskey = ก
save-to-label =
    .label = บันทึกไฟล์ไปยัง
    .accesskey = บ
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] เลือก…
           *[other] เรียกดู…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ล
           *[other] ร
        }
always-ask-label =
    .label = ถามฉันเสมอว่าจะบันทึกไฟล์ที่ไหน
    .accesskey = ถ
display-tags-text = สามารถใช้แท็กเพื่อจัดหมวดหมู่และลำดับความสำคัญของข้อความของคุณได้
new-tag-button =
    .label = ใหม่…
    .accesskey = ม
edit-tag-button =
    .label = แก้ไข…
    .accesskey = ก
delete-tag-button =
    .label = ลบ
    .accesskey = ล
auto-mark-as-read =
    .label = ทำเครื่องหมายข้อความว่าอ่านแล้วโดยอัตโนมัติ
    .accesskey = ท
mark-read-no-delay =
    .label = ทันทีที่แสดง
    .accesskey = แ

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = หลังจากแสดงไปแล้ว
    .accesskey = ล
seconds-label = วินาที

##

open-msg-label =
    .value = เปิดข้อความใน:
open-msg-tab =
    .label = แท็บใหม่
    .accesskey = บ
open-msg-window =
    .label = หน้าต่างข้อความใหม่
    .accesskey = ห
open-msg-ex-window =
    .label = หน้าต่างข้อความที่มีอยู่
    .accesskey = น
close-move-delete =
    .label = ปิดหน้าต่าง/แท็บข้อความเมื่อย้ายหรือลบ
    .accesskey = ป
display-name-label =
    .value = ชื่อที่แสดง:
condensed-addresses-label =
    .label = แสดงเฉพาะชื่อที่แสดงสำหรับผู้คนในสมุดรายชื่อของฉัน
    .accesskey = ส

## Compose Tab

forward-label =
    .value = ส่งต่อข้อความ:
    .accesskey = ส
inline-label =
    .label = แบบอินไลน์
as-attachment-label =
    .label = เป็นไฟล์แนบ
extension-label =
    .label = เติมนามสกุลให้กับชื่อไฟล์
    .accesskey = ต

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = บันทึกอัตโนมัติทุก ๆ
    .accesskey = บ
auto-save-end = นาที

##

warn-on-send-accel-key =
    .label = ยืนยันเมื่อใช้แป้นพิมพ์ลัดเพื่อส่งข้อความ
    .accesskey = ย
spellcheck-label =
    .label = ตรวจสอบการสะกดคำก่อนส่ง
    .accesskey = ต
spellcheck-inline-label =
    .label = เปิดใช้งานการตรวจสอบการสะกดคำเมื่อคุณพิมพ์
    .accesskey = ป
language-popup-label =
    .value = ภาษา:
    .accesskey = ภ
download-dictionaries-link = ดาวน์โหลดพจนานุกรมเพิ่มเติม
font-label =
    .value = แบบอักษร:
    .accesskey = บ
font-size-label =
    .value = ขนาด:
    .accesskey = ข
default-colors-label =
    .label = ใช้สีเริ่มต้นของตัวอ่าน
    .accesskey = ช
font-color-label =
    .value = สีข้อความ:
    .accesskey = อ
bg-color-label =
    .value = สีพื้นหลัง:
    .accesskey = พ
restore-html-label =
    .label = เรียกคืนค่าเริ่มต้น
    .accesskey = ร
default-format-label =
    .label = ใช้รูปแบบย่อหน้าแทนข้อความเนื้อความโดยค่าเริ่มต้น
    .accesskey = ช
format-description = กำหนดค่าลักษณะการทำงานของรูปแบบข้อความ
send-options-label =
    .label = ตัวเลือกการส่ง…
    .accesskey = ว
autocomplete-description = เมื่อกำหนดที่อยู่ของข้อความ ให้มองหารายการที่ตรงกันใน:
ab-label =
    .label = สมุดรายชื่อในเครื่อง
    .accesskey = ส
directories-label =
    .label = เซิร์ฟเวอร์ไดเรกทอรี:
    .accesskey = เ
directories-none-label =
    .none = ไม่มี
edit-directories-label =
    .label = แก้ไขไดเรกทอรี…
    .accesskey = ก
email-picker-label =
    .label = เพิ่มที่อยู่อีเมลขาออกไปยังตำแหน่งนี้โดยอัตโนมัติ:
    .accesskey = ม
default-directory-label =
    .value = ไดเรกทอรีเริ่มต้นในหน้าต่างสมุดรายชื่อ:
    .accesskey = ไ
default-last-label =
    .none = ไดเรกทอรีที่ใช้ล่าสุด
attachment-label =
    .label = ตรวจสอบไฟล์แนบที่หายไป
    .accesskey = ต
attachment-options-label =
    .label = คำสำคัญ…
    .accesskey = ค
enable-cloud-share =
    .label = เสนอให้แบ่งปันไฟล์ที่มีขนาดใหญ่กว่า
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = เพิ่ม…
    .accesskey = พ
    .defaultlabel = เพิ่ม…
remove-cloud-account =
    .label = เอาออก
    .accesskey = อ
find-cloud-providers =
    .value = ค้นหาผู้ให้บริการเพิ่มเติม…
cloud-account-description = เพิ่มบริการที่เก็บข้อมูล Filelink ใหม่

## Privacy Tab

mail-content = เนื้อหาจดหมาย
remote-content-label =
    .label = อนุญาตเนื้อหาระยะไกลในข้อความ
    .accesskey = อ
exceptions-button =
    .label = ข้อยกเว้น…
    .accesskey = เ
remote-content-info =
    .value = เรียนรู้เพิ่มเติมเกี่ยวกับปัญหาความเป็นส่วนตัวของเนื้อหาระยะไกล
web-content = เนื้อหาเว็บ
history-label =
    .label = จดจำเว็บไซต์และลิงก์ที่ฉันเคยเยี่ยมชม
    .accesskey = จ
cookies-label =
    .label = ยอมรับคุกกี้จากไซต์
    .accesskey = ย
third-party-label =
    .value = ยอมรับคุกกี้จากบุคคลที่สาม:
    .accesskey = ม
third-party-always =
    .label = เสมอ
third-party-never =
    .label = ไม่เลย
third-party-visited =
    .label = จากที่เยี่ยมชม
keep-label =
    .value = เก็บจนกระทั่ง:
    .accesskey = ก
keep-expire =
    .label = คุกกี้หมดอายุ
keep-close =
    .label = ฉันปิด { -brand-short-name }
keep-ask =
    .label = ถามฉันทุกครั้ง
cookies-button =
    .label = แสดงคุกกี้…
    .accesskey = ส
do-not-track-label =
    .label = ส่งสัญญาณ “ไม่ติดตาม” ให้กับเว็บไซต์ว่าคุณไม่ต้องการถูกติดตาม
    .accesskey = ง
learn-button =
    .label = เรียนรู้เพิ่มเติม
passwords-description = { -brand-short-name } สามารถจดจำรหัสผ่านสำหรับบัญชีทั้งหมดของคุณ
passwords-button =
    .label = รหัสผ่านที่บันทึกไว้…
    .accesskey = ร
master-password-description = รหัสผ่านหลักจะปกป้องรหัสผ่านทั้งหมดของคุณ แต่คุณต้องป้อนเพียงวาระละหนึ่งครั้งเท่านั้น
master-password-label =
    .label = ใช้รหัสผ่านหลัก
    .accesskey = ช
master-password-button =
    .label = เปลี่ยนรหัสผ่านหลัก…
    .accesskey = เ
primary-password-description = รหัสผ่านหลักจะปกป้องรหัสผ่านทั้งหมดของคุณ แต่คุณต้องป้อนเพียงวาระละหนึ่งครั้งเท่านั้น
primary-password-label =
    .label = ใช้รหัสผ่านหลัก
    .accesskey = ช
primary-password-button =
    .label = เปลี่ยนรหัสผ่านหลัก…
    .accesskey = ป
forms-primary-pw-fips-title = คุณกำลังอยู่ในโหมด FIPS ซึ่ง FIPS จำเป็นต้องมีรหัสผ่านหลักที่ไม่ว่างเปล่า
forms-master-pw-fips-desc = การเปลี่ยนรหัสผ่านล้มเหลว
junk-description = ตั้งค่าการตั้งค่าจดหมายขยะเริ่มต้นของคุณ สามารถกำหนดค่าการตั้งค่าจดหมายขยะเฉพาะบัญชีได้ในการตั้งค่าบัญชี
junk-label =
    .label = เมื่อฉันทำเครื่องหมายข้อความว่าเป็นขยะ:
    .accesskey = ม
junk-move-label =
    .label = ย้ายไปไว้ในโฟลเดอร์ "ขยะ" ของบัญชี
    .accesskey = ย
junk-delete-label =
    .label = ลบออก
    .accesskey = ล
junk-read-label =
    .label = ทำเครื่องหมายข้อความที่ถูกพิจารณาว่าเป็นขยะว่าอ่านแล้ว
    .accesskey = ท
junk-log-label =
    .label = เปิดใช้งานการบันทึกตัวกรองขยะแบบปรับเปลี่ยนได้
    .accesskey = ป
junk-log-button =
    .label = แสดงรายการบันทึก
    .accesskey = ส
reset-junk-button =
    .label = ตั้งค่าข้อมูลการสอนใหม่
    .accesskey = ต
phishing-description = { -brand-short-name } สามารถวิเคราะห์ข้อความสำหรับการหลอกลวงอีเมลที่น่าสงสัยโดยมองหาเทคนิคทั่วไปที่ใช้หลอกลวงคุณ
phishing-label =
    .label = บอกฉันหากข้อความที่ฉันกำลังอ่านเป็นการหลอกลวงอีเมลที่น่าสงสัย
    .accesskey = บ
antivirus-description = { -brand-short-name } สามารถทำให้ซอฟต์แวร์ป้องกันไวรัสวิเคราะห์ข้อความจดหมายขาเข้าสำหรับไวรัสก่อนที่จะถูกเก็บไว้ในเครื่องได้ง่ายขึ้น
antivirus-label =
    .label = อนุญาตให้ไคลเอ็นต์โปรแกรมป้องกันไวรัสกักกันข้อความขาเข้าแต่ละข้อความ
    .accesskey = อ
certificate-description = เมื่อเซิร์ฟเวอร์ขอใบรับรองส่วนบุคคลของฉัน:
certificate-auto =
    .label = เลือกมาหนึ่งโดยอัตโนมัติ
    .accesskey = ล
certificate-ask =
    .label = ถามฉันทุกครั้ง
    .accesskey = ถ
ocsp-label =
    .label = สืบค้นเซิร์ฟเวอร์ตอบกลับ OCSP เพื่อยืนยันความถูกต้องของใบรับรองปัจจุบัน
    .accesskey = ส
certificate-button =
    .label = จัดการใบรับรอง…
    .accesskey = จ
security-devices-button =
    .label = อุปกรณ์ความปลอดภัย…
    .accesskey = อ

## Chat Tab

startup-label =
    .value = เมื่อ { -brand-short-name } เริ่ม:
    .accesskey = ม
offline-label =
    .label = คงสถานะออฟไลน์ของบัญชีแชทของฉัน
auto-connect-label =
    .label = เชื่อมต่อบัญชีแชทของฉันโดยอัตโนมัติ

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = แจ้งให้ผู้ติดต่อของฉันทราบว่าฉันไม่ได้ใช้งานหลังจาก
    .accesskey = จ
idle-time-label = นาทีที่ไม่มีความเคลื่อนไหว

##

away-message-label =
    .label = และตั้งค่าสถานะของฉันว่าไม่อยู่ด้วยข้อความสถานะนี้:
    .accesskey = ล
send-typing-label =
    .label = ส่งการแจ้งเตือนการพิมพ์ในการสนทนา
    .accesskey = ส
notification-label = เมื่อมีข้อความส่งมาถึงคุณโดยตรงแล้ว:
show-notification-label =
    .label = แสดงการแจ้งเตือน:
    .accesskey = แ
notification-all =
    .label = พร้อมชื่อผู้ส่งและตัวอย่างข้อความ
notification-name =
    .label = พร้อมชื่อผู้ส่งเท่านั้น
notification-empty =
    .label = โดยไม่มีข้อมูลใด ๆ
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] ทำให้ไอคอน Dock เคลื่อนไหว
           *[other] กะพริบรายการแถบงาน
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ท
           *[other] ก
        }
chat-play-sound-label =
    .label = เล่นเสียง
    .accesskey = เ
chat-play-button =
    .label = เล่น
    .accesskey = น
chat-system-sound-label =
    .label = เสียงระบบเริ่มต้นสำหรับจดหมายใหม่
    .accesskey = ย
chat-custom-sound-label =
    .label = ใช้ไฟล์เสียงดังต่อไปนี้
    .accesskey = ช
chat-browse-sound-button =
    .label = เรียกดู…
    .accesskey = ร
theme-label =
    .value = ชุดตกแต่ง:
    .accesskey = ด
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = ฟองอากาศ
style-dark =
    .label = มืด
style-paper =
    .label = แผ่นกระดาษ
style-simple =
    .label = ธรรมดา
preview-label = ตัวอย่าง:
no-preview-label = ไม่มีตัวอย่างที่ใช้งานได้
no-preview-description = ชุดตกแต่งนี้ไม่ถูกต้องหรือไม่สามารถใช้งานได้ในขณะนี้ (ปิดใช้งานส่วนเสริม, โหมดปลอดภัย, …)
chat-variant-label =
    .value = รูปแบบอื่น:
    .accesskey = ป
chat-header-label =
    .label = แสดงส่วนหัว
    .accesskey = ง
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] ค้นหาในตัวเลือก
           *[other] ค้นหาในค่ากำหนด
        }

## Preferences UI Search Results

search-results-header = ผลการค้นหา
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] ขออภัย! ไม่มีผลลัพธ์สำหรับ “<span data-l10n-name="query"></span>” ในตัวเลือก
       *[other] ขออภัย! ไม่มีผลลัพธ์สำหรับ “<span data-l10n-name="query"></span>” ในค่ากำหนด
    }
search-results-help-link = ต้องการความช่วยเหลือ? เยี่ยมชม <a data-l10n-name="url">การสนับสนุนของ { -brand-short-name }</a>
