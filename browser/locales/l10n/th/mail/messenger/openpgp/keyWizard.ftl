# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = เพิ่มคีย์ OpenPGP ส่วนตัวสำหรับ { $identity }

key-wizard-button =
    .buttonlabelaccept = ดำเนินการต่อ
    .buttonlabelhelp = กลับไป

key-wizard-warning = <b>หากคุณมีคีย์ส่วนตัว</b>สำหรับที่อยู่อีเมลนี้อยู่แล้ว คุณควรนำเข้า มิฉะนั้นคุณจะไม่สามารถเข้าถึงที่เก็บถาวรอีเมลที่เข้ารหัสของคุณ และไม่สามารถอ่านอีเมลที่เข้ารหัสขาเข้าจากผู้คนที่ยังใช้คีย์ที่มีอยู่ของคุณได้

key-wizard-learn-more = เรียนรู้เพิ่มเติม

radio-create-key =
    .label = สร้างคีย์ OpenPGP ใหม่
    .accesskey = ส

radio-import-key =
    .label = นำเข้าคีย์ OpenPGP ที่มีอยู่
    .accesskey = น

radio-gnupg-key =
    .label = ใช้คีย์ภายนอกของคุณผ่าน GnuPG (เช่น จากสมาร์ทการ์ด)
    .accesskey = ช

## Generate key section

openpgp-generate-key-title = สร้างคีย์ OpenPGP

openpgp-keygen-expiry-title = วันหมดอายุของคีย์

openpgp-keygen-expiry-description = กำหนดเวลาหมดอายุของคีย์ที่คุณสร้างขึ้นใหม่ คุณสามารถควบคุมวันเพื่อขยายเวลาได้ในภายหลังหากจำเป็น

radio-keygen-expiry =
    .label = คีย์จะหมดอายุใน
    .accesskey = ห

radio-keygen-no-expiry =
    .label = คีย์จะไม่หมดอายุ
    .accesskey = ม

openpgp-keygen-days-label =
    .label = วัน
openpgp-keygen-months-label =
    .label = เดือน
openpgp-keygen-years-label =
    .label = ปี

openpgp-keygen-advanced-title = การตั้งค่าขั้นสูง

openpgp-keygen-advanced-description = ควบคุมการตั้งค่าขั้นสูงของคีย์ OpenPGP ของคุณ

openpgp-keygen-keytype =
    .value = ชนิดคีย์:
    .accesskey = ช

openpgp-keygen-keysize =
    .value = ขนาดคีย์:
    .accesskey = ข

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (เส้นโค้งรูปไข่)

openpgp-keygen-button = สร้างคีย์

openpgp-keygen-progress-title = กำลังสร้างคีย์ OpenPGP ใหม่ของคุณ…

openpgp-keygen-import-progress-title = กำลังนำเข้าคีย์ OpenPGP ของคุณ…

openpgp-import-success = นำเข้าคีย์ OpenPGP สำเร็จแล้ว!

openpgp-import-success-title = ทำขั้นตอนการนำเข้าให้เสร็จสมบูรณ์

openpgp-import-success-description = ในการเริ่มใช้คีย์ OpenPGP ที่คุณนำเข้าสำหรับการเข้ารหัสอีเมล ให้ปิดกล่องโต้ตอบนี้และเข้าไปที่การตั้งค่าบัญชีของคุณเพื่อเลือกคีย์ดังกล่าว

openpgp-keygen-confirm =
    .label = ยืนยัน

openpgp-keygen-dismiss =
    .label = ยกเลิก

openpgp-keygen-cancel =
    .label = ยกเลิกกระบวนการ…

openpgp-keygen-import-complete =
    .label = ปิด
    .accesskey = ป

openpgp-keygen-missing-username = ไม่มีการระบุชื่อสำหรับบัญชีปัจจุบัน โปรดป้อนค่าในช่อง "ชื่อของคุณ" ในการตั้งค่าบัญชี
openpgp-keygen-long-expiry = คุณไม่สามารถสร้างคีย์ที่หมดอายุเกิน 100 ปีได้
openpgp-keygen-short-expiry = คีย์ของคุณต้องใช้ได้อย่างน้อยหนึ่งวัน

openpgp-keygen-ongoing = การสร้างคีย์กำลังดำเนินการอยู่แล้ว!

openpgp-keygen-error-core = ไม่สามารถเริ่มต้นบริการหลักของ OpenPGP ได้

openpgp-keygen-error-failed = การสร้างคีย์ OpenPGP ล้มเหลวโดยไม่คาดคิด

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = สร้างคีย์ OpenPGP สำเร็จแล้ว แต่ไม่สามารถขอรับการเพิกถอนสำหรับคีย์ { $key } ได้

openpgp-keygen-abort-title = ต้องการยกเลิกการสร้างคีย์หรือไม่?
openpgp-keygen-abort = การสร้างคีย์ OpenPGP กำลังดำเนินการอยู่ คุณแน่ใจหรือไม่ว่าต้องการยกเลิก?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = ต้องการสร้างคีย์สาธารณะและคีย์ลับสำหรับ { $identity } หรือไม่?

## Import Key section

openpgp-import-key-title = นำเข้าคีย์ OpenPGP ส่วนตัวที่มีอยู่

openpgp-import-key-legend = เลือกไฟล์ที่สำรองไว้ก่อนหน้านี้

openpgp-import-key-description = คุณสามารถนำเข้าคีย์ส่วนตัวที่สร้างขึ้นด้วยซอฟต์แวร์ OpenPGP อื่น ๆ ได้

openpgp-import-key-info = ซอฟต์แวร์อื่นอาจอธิบายคีย์ส่วนตัวโดยใช้คำอื่น เช่น คีย์ของคุณเอง คีย์ลับ คีย์ส่วนตัว หรือคู่คีย์

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
       *[other] Thunderbird พบ { $count } คีย์ที่สามารถนำเข้าได้
    }

openpgp-passphrase-prompt-title = ต้องการวลีรหัสผ่าน

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = โปรดป้อนวลีรหัสผ่านเพื่อปลดล็อกคีย์ต่อไปนี้: { $key }

openpgp-import-key-button =
    .label = เลือกไฟล์ที่จะนำเข้า…
    .accesskey = ล

import-key-file = นำเข้าไฟล์คีย์ OpenPGP

import-key-personal-checkbox =
    .label = ถือว่าคีย์นี้เป็นคีย์ส่วนตัว

gnupg-file = ไฟล์ GnuPG

import-error-file-size = <b>ผิดพลาด!</b> ไม่รองรับไฟล์ที่ใหญ่กว่า 5MB

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>ผิดพลาด!</b> การนำเข้าไฟล์ล้มเหลว { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>ผิดพลาด!</b> การนำเข้าคีย์ล้มเหลว { $error }

openpgp-import-identity-label = ข้อมูลประจำตัว

openpgp-import-fingerprint-label = ลายนิ้วมือ

openpgp-import-created-label = สร้างเมื่อ

openpgp-import-bits-label = บิต

openpgp-import-key-props =
    .label = คุณสมบัติคีย์
    .accesskey = ค

## External Key section

openpgp-external-key-title = คีย์ GnuPG ภายนอก

openpgp-external-key-description = กำหนดค่าคีย์ GnuPG ภายนอกโดยป้อนรหัสคีย์

openpgp-external-key-info = นอกจากนี้ คุณต้องใช้ตัวจัดการคีย์เพื่อนำเข้าและยอมรับคีย์สาธารณะที่เกี่ยวข้อง

openpgp-external-key-warning = <b>คุณสามารถกำหนดค่าคีย์ GnuPG ภายนอกได้เพียงคีย์เดียวเท่านั้น</b> รายการก่อนหน้าของคุณจะถูกแทนที่

openpgp-save-external-button = บันทึกรหัสคีย์

openpgp-external-key-label = รหัสคีย์ลับ:

openpgp-external-key-input =
    .placeholder = 123456789341298340
