# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = มาตรวัดคุณภาพรหัสผ่าน

## Change Password dialog

change-password-window =
    .title = เปลี่ยนรหัสผ่านหลัก
change-device-password-window =
    .title = เปลี่ยนรหัสผ่าน
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = อุปกรณ์ความปลอดภัย: { $tokenName }
change-password-old = รหัสผ่านปัจจุบัน:
change-password-new = รหัสผ่านใหม่:
change-password-reenter = รหัสผ่านใหม่ (อีกครั้ง):

## Reset Password dialog

reset-password-window =
    .title = ล้างรหัสผ่านหลัก
    .style = width: 40em
pippki-failed-pw-change = ไม่สามารถเปลี่ยนรหัสผ่านได้
pippki-incorrect-pw = คุณใส่รหัสผ่านปัจจุบันไม่ถูกต้อง โปรดลองอีกครั้ง
pippki-pw-change-ok = เปลี่ยนรหัสผ่านสำเร็จแล้ว
pippki-pw-empty-warning = รหัสผ่านที่บันทึกไว้และคีย์ส่วนตัวของคุณจะไม่ได้รับการปกป้อง
pippki-pw-erased-ok = คุณได้ลบรหัสผ่านของคุณแล้ว { pippki-pw-empty-warning }
pippki-pw-not-wanted = คำเตือน! คุณได้ตัดสินใจไม่ใช้รหัสผ่าน { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = ขณะนี้คุณอยู่ในโหมด FIPS ซึ่ง FIPS จำเป็นต้องมีรหัสผ่านที่ไม่ว่างเปล่า

## Reset Primary Password dialog

reset-primary-password-window =
    .title = ตั้งรหัสผ่านหลักใหม่
    .style = width: 40em
reset-password-button-label =
    .label = ตั้งค่าใหม่
reset-password-text = หากคุณตั้งรหัสผ่านหลักของคุณใหม่ รหัสผ่านเว็บและอีเมล, ข้อมูลแบบฟอร์ม, ใบรับรองส่วนบุคคล และกุญแจส่วนตัวทั้งหมดที่คุณจัดเก็บจะถูกลืม คุณแน่ใจหรือไม่ว่าต้องการตั้งรหัสผ่านหลักของคุณใหม่?
reset-primary-password-text = หากคุณตั้งรหัสผ่านหลักของคุณใหม่ รหัสผ่านเว็บและอีเมล, ใบรับรองส่วนบุคคล, และกุญแจส่วนตัวทั้งหมดที่คุณจัดเก็บจะถูกลืม คุณแน่ใจหรือไม่ว่าต้องการตั้งรหัสผ่านหลักของคุณใหม่?
pippki-reset-password-confirmation-title = ตั้งรหัสผ่านหลักใหม่
pippki-reset-password-confirmation-message = รหัสผ่านหลักของคุณถูกตั้งใหม่แล้ว

## Downloading cert dialog

download-cert-window =
    .title = กำลังดาวน์โหลดใบรับรอง
    .style = width: 46em
download-cert-message = คุณได้รับคำขอให้เชื่อถือผู้ออกใบรับรอง (CA) ใหม่
download-cert-trust-ssl =
    .label = เชื่อถือ CA นี้เพื่อระบุเว็บไซต์
download-cert-trust-email =
    .label = เชื่อถือ CA นี้เพื่อระบุผู้ใช้อีเมล
download-cert-message-desc = ก่อนที่จะเชื่อมั่น CA แห่งนี้ไม่ว่าเพื่อวัตถุประสงค์ใดก็ตาม คุณควรตรวจสอบใบรับรองตลอดจนนโยบายและขั้นตอนการรับรองของ CA แห่งนั้นเสียก่อน (ถ้ามี)
download-cert-view-cert =
    .label = ดู
download-cert-view-text = ตรวจสอบใบรับรอง CA

## Client Authorization Ask dialog

client-auth-window =
    .title = คำขออัตลักษณ์ผู้ใช้
client-auth-site-description = ไซต์นี้ได้ขอให้คุณระบุตัวคุณเองด้วยใบรับรอง:
client-auth-choose-cert = เลือกใบรับรองเพื่อระบุตัวตน:
client-auth-cert-details = รายละเอียดของใบรับรองที่เลือก:

## Set password (p12) dialog

set-password-window =
    .title = เลือกรหัสผ่านสำรองใบรับรอง :
set-password-message = รหัสผ่านสำรองใบรับรองที่กำลังจะตั้งนี้จะช่วยปกป้องไฟล์ข้อมูลสำรองที่คุณกำลังจะสร้างขึ้น  คุณจำเป็นต้องตั้งรหัสผ่านนี้ก่อนที่จะดำเนินการสำรองข้อมูลต่อ
set-password-backup-pw =
    .value = รหัสผ่านสำรองใบรับรอง :
set-password-repeat-backup-pw =
    .value = รหัสผ่านสำรองใบรับรอง (อีกครั้ง) :
set-password-reminder = สำคัญมาก : หากคุณลืมรหัสผ่านสำรองใบรับรอง คุณจะไม่สามารถเรียกคืนข้อมูลที่สำรองไว้ได้อีกต่อไป ควรบันทึกรหัสผ่านนี้ไว้ในที่ปลอดภัย

## Protected Auth dialog

protected-auth-window =
    .title = การพิสูจน์ว่าโทเค็นที่ปกป้องไว้เป็นของจริง
protected-auth-msg = โปรดพิสูจน์ว่าโทเค็นเป็นของจริง วิธีพิสูจน์จะขึ้นกับชนิดของโทเค็น
protected-auth-token = โทเค็น:
