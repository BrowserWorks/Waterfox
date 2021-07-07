# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = ดำเนินการต่อด้วยความระมัดระวัง
about-config-intro-warning-text = การเปลี่ยนแปลงค่ากำหนดขั้นสูงอาจส่งผลต่อประสิทธิภาพหรือความปลอดภัยของ { -brand-short-name } ได้
about-config-intro-warning-checkbox = เตือนเมื่อฉันพยายามเข้าถึงการตั้งค่าเหล่านี้
about-config-intro-warning-button = ยอมรับความเสี่ยงและดำเนินการต่อ

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = การเปลี่ยนแปลงค่ากำหนดเหล่านี้อาจส่งผลต่อประสิทธิภาพหรือความปลอดภัยของ { -brand-short-name } ได้
about-config-page-title = ค่ากำหนดขั้นสูง
about-config-search-input1 =
    .placeholder = ค้นหาชื่อค่ากำหนด
about-config-show-all = แสดงทั้งหมด
about-config-show-only-modified = แสดงเฉพาะค่ากำหนดที่ถูกเปลี่ยนแปลง
about-config-pref-add-button =
    .title = เพิ่ม
about-config-pref-toggle-button =
    .title = เปิด/ปิด
about-config-pref-edit-button =
    .title = แก้ไข
about-config-pref-save-button =
    .title = บันทึก
about-config-pref-reset-button =
    .title = กลับค่าเดิม
about-config-pref-delete-button =
    .title = ลบ

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = ค่าตรรกะ
about-config-pref-add-type-number = ตัวเลข
about-config-pref-add-type-string = สตริง

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (ค่าเริ่มต้น)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (กำหนดเอง)
