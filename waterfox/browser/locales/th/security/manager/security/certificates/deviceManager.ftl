# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = ตัวจัดการอุปกรณ์
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = โมดูลและอุปกรณ์ความปลอดภัย

devmgr-header-details =
    .label = รายละเอียด

devmgr-header-value =
    .label = ค่า

devmgr-button-login =
    .label = เข้าสู่ระบบ
    .accesskey = ข

devmgr-button-logout =
    .label = ออกจากระบบ
    .accesskey = อ

devmgr-button-changepw =
    .label = เปลี่ยนรหัสผ่าน
    .accesskey = ป

devmgr-button-load =
    .label = โหลด
    .accesskey = ห

devmgr-button-unload =
    .label = เลิกโหลด
    .accesskey = ล

devmgr-button-enable-fips =
    .label = เปิดใช้งาน FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = ปิดใช้งาน FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = โหลดไดรเวอร์อุปกรณ์ PKCS#11

load-device-info = ใส่ข้อมูลโมดูลที่ต้องการ

load-device-modname =
    .value = ชื่อโมดูล
    .accesskey = ช

load-device-modname-default =
    .value = สร้างโมดูล PKCS#11

load-device-filename =
    .value = ชื่อไฟล์โมดูล
    .accesskey = อ

load-device-browse =
    .label = เรียกดู…
    .accesskey = ร

## Token Manager

devinfo-status =
    .label = สถานะ

devinfo-status-disabled =
    .label = ปิดใช้งานอยู่

devinfo-status-not-present =
    .label = ไม่ระบุ

devinfo-status-uninitialized =
    .label = ไม่ได้เตรียมใช้งาน

devinfo-status-not-logged-in =
    .label = ไม่ได้เข้าสู่ระบบ

devinfo-status-logged-in =
    .label = เข้าสู่ระบบแล้ว

devinfo-status-ready =
    .label = พร้อม

devinfo-desc =
    .label = คำอธิบาย

devinfo-man-id =
    .label = ผู้ผลิต

devinfo-hwversion =
    .label = รุ่น HW
devinfo-fwversion =
    .label = รุ่น FW

devinfo-modname =
    .label = โมดูล

devinfo-modpath =
    .label = เส้นทาง

login-failed = ไม่สามารถเข้าสู่ระบบ

devinfo-label =
    .label = ป้ายชื่อ

devinfo-serialnum =
    .label = หมายเลขอนุกรม

fips-nonempty-primary-password-required = โหมด FIPS ต้องการให้คุณตั้งรหัสผ่านหลักสำหรับอุปกรณ์ความปลอดภัยแต่ละเครื่อง โปรดตั้งรหัสผ่านก่อนลองเปิดใช้งานโหมด FIPS
unable-to-toggle-fips = ไม่สามารถเปลี่ยนโหมด FIPS ให้เข้ากับอุปกรณ์รักษาความปลอดภัย แนะนำให้คุณออกและเริ่มโปรแกรมใหม่
load-pk11-module-file-picker-title = เลือกไดรเวอร์อุปกรณ์ PKCS#11 ที่จะโหลด

# Load Module Dialog
load-module-help-empty-module-name =
    .value = ชื่อโมดูลต้องไม่ว่างเปล่า

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ ถูกสงวนไว้และไม่สามารถนำมาใช้เป็นชื่อโมดูลได้

add-module-failure = ไม่สามารถเพิ่มโมดูล
del-module-warning = คุณแน่ใจหรือไม่ว่าต้องการลบโมดูลความปลอดภัยนี้?
del-module-error = ไม่สามารถลบโมดูล
