# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = จัดการคุกกี้และข้อมูลไซต์
site-data-settings-description = เว็บไซต์ดังต่อไปนี้จัดเก็บคุกกี้และข้อมูลไซต์ไว้ในคอมพิวเตอร์ของคุณ { -brand-short-name } เก็บข้อมูลจากเว็บไซต์ที่ใช้ที่เก็บข้อมูลถาวรจนกว่าคุณจะลบออก และลบข้อมูลจากเว็บไซต์ที่ใช้ที่เก็บข้อมูลไม่ถาวรออกเมื่อต้องการพื้นที่
site-data-search-textbox =
    .placeholder = ค้นหาเว็บไซต์
    .accesskey = ค
site-data-column-host =
    .label = ไซต์
site-data-column-cookies =
    .label = คุกกี้
site-data-column-storage =
    .label = ที่เก็บข้อมูล
site-data-column-last-used =
    .label = วันที่ใช้ครั้งล่าสุด
# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (ไฟล์ในเครื่อง)
site-data-remove-selected =
    .label = เอาที่เลือกออก
    .accesskey = อ
site-data-settings-dialog =
    .buttonlabelaccept = บันทึกการเปลี่ยนแปลง
    .buttonaccesskeyaccept = บ
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (ถาวร)
site-data-remove-all =
    .label = เอาทั้งหมดออก
    .accesskey = ท
site-data-remove-shown =
    .label = เอาที่แสดงทั้งหมดออก
    .accesskey = ท

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = เอาออก
site-data-removing-header = การเอาคุกกี้และข้อมูลไซต์ออก
site-data-removing-desc = การเอาคุกกี้และข้อมูลไซต์ออกอาจนำคุณออกจากระบบของเว็บไซต์ คุณแน่ใจหรือไม่ว่าต้องการทำการเปลี่ยนแปลง?
# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = การเอาคุกกี้และข้อมูลไซต์ออกอาจนำคุณออกจากระบบเว็บไซต์ต่าง ๆ คุณแน่ใจหรือไม่ว่าต้องการเอาคุกกี้และข้อมูลไซต์สำหรับ <strong>{ $baseDomain }</strong> ออก?
site-data-removing-table = คุกกี้และข้อมูลไซต์สำหรับเว็บไซต์ดังต่อไปนี้จะถูกเอาออก
