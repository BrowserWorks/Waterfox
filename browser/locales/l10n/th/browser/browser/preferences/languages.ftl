# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = การตั้งค่าภาษาของหน้าเว็บ
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = บางครั้งหน้าเว็บอาจนำเสนอมากกว่าหนึ่งภาษา เลือกภาษาสำหรับแสดงผลหน้าเว็บเหล่านี้ตามลำดับที่ต้องการ

languages-customize-spoof-english =
    .label = ขอหน้าเว็บภาษาอังกฤษเพื่อความเป็นส่วนตัวที่เพิ่มขึ้น

languages-customize-moveup =
    .label = ย้ายขึ้น
    .accesskey = ย

languages-customize-movedown =
    .label = ย้ายลง
    .accesskey = ล

languages-customize-remove =
    .label = เอาออก
    .accesskey = อ

languages-customize-select-language =
    .placeholder = เลือกภาษาที่จะเพิ่ม…

languages-customize-add =
    .label = เพิ่ม
    .accesskey = พ

# The pattern used to generate strings presented to the user in the
# locale selection list.
#
# Example:
#   Icelandic [is]
#   Spanish (Chile) [es-CL]
#
# Variables:
#   $locale (String) - A name of the locale (for example: "Icelandic", "Spanish (Chile)")
#   $code (String) - Locale code of the locale (for example: "is", "es-CL")
languages-code-format =
    .label = { $locale }  [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = การตั้งค่าภาษาของ { -brand-short-name }
    .style = width: 40em

browser-languages-description = { -brand-short-name } จะแสดงผลภาษาแรกเป็นค่าเริ่มต้นของคุณและจะแสดงผลภาษาอื่นแทนหากจำเป็นตามลำดับที่ปรากฏ

browser-languages-search = ค้นหาภาษาเพิ่มเติม…

browser-languages-searching =
    .label = กำลังค้นหาภาษา…

browser-languages-downloading =
    .label = กำลังดาวน์โหลด…

browser-languages-select-language =
    .label = เลือกภาษาที่จะเพิ่ม…
    .placeholder = เลือกภาษาที่จะเพิ่ม…

browser-languages-installed-label = ภาษาที่ติดตั้ง
browser-languages-available-label = ภาษาที่มี

browser-languages-error = { -brand-short-name } ไม่สามารถอัปเดตภาษาของคุณได้ในขณะนี้ ตรวจสอบว่าคุณเชื่อมต่อกับอินเทอร์เน็ตแล้วหรือลองอีกครั้ง
