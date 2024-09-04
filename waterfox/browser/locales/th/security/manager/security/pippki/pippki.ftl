# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = มาตรวัดคุณภาพรหัสผ่าน

## Change Password dialog

change-device-password-window =
    .title = เปลี่ยนรหัสผ่าน
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = อุปกรณ์ความปลอดภัย: { $tokenName }
change-password-old = รหัสผ่านปัจจุบัน:
change-password-new = รหัสผ่านใหม่:
change-password-reenter = รหัสผ่านใหม่ (อีกครั้ง):
pippki-failed-pw-change = ไม่สามารถเปลี่ยนรหัสผ่านได้
pippki-incorrect-pw = คุณใส่รหัสผ่านปัจจุบันไม่ถูกต้อง โปรดลองอีกครั้ง
pippki-pw-change-ok = เปลี่ยนรหัสผ่านสำเร็จแล้ว
pippki-pw-empty-warning = รหัสผ่านที่บันทึกไว้และคีย์ส่วนตัวของคุณจะไม่ได้รับการปกป้อง
pippki-pw-erased-ok = คุณได้ลบรหัสผ่านของคุณแล้ว { pippki-pw-empty-warning }
pippki-pw-not-wanted = คำเตือน! คุณได้ตัดสินใจไม่ใช้รหัสผ่าน { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = ขณะนี้คุณอยู่ในโหมด FIPS ซึ่ง FIPS จำเป็นต้องมีรหัสผ่านที่ไม่ว่างเปล่า

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = ตั้งรหัสผ่านหลักใหม่
    .style = min-width: 40em
reset-password-button-label =
    .label = ตั้งค่าใหม่
reset-primary-password-text = หากคุณตั้งรหัสผ่านหลักของคุณใหม่ รหัสผ่านเว็บและอีเมล, ใบรับรองส่วนบุคคล, และกุญแจส่วนตัวทั้งหมดที่คุณจัดเก็บจะถูกลืม คุณแน่ใจหรือไม่ว่าต้องการตั้งรหัสผ่านหลักของคุณใหม่?
pippki-reset-password-confirmation-title = ตั้งรหัสผ่านหลักใหม่
pippki-reset-password-confirmation-message = รหัสผ่านหลักของคุณถูกตั้งใหม่แล้ว

## Downloading cert dialog

download-cert-window2 =
    .title = กำลังดาวน์โหลดใบรับรอง
    .style = min-width: 46em
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


## Client Authentication Ask dialog

client-auth-window =
    .title = คำขออัตลักษณ์ผู้ใช้
client-auth-site-description = ไซต์นี้ได้ขอให้คุณระบุตัวคุณเองด้วยใบรับรอง:
client-auth-choose-cert = เลือกใบรับรองเพื่อระบุตัวตน:
client-auth-send-no-certificate =
    .label = อย่าส่งใบรับรอง
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = “{ $hostname }” ได้ขอให้คุณระบุตัวตนของคุณเองด้วยใบรับรอง:
client-auth-cert-details = รายละเอียดของใบรับรองที่เลือก:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = ออกให้: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = หมายเลขอนุกรม: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = มีผลตั้งแต่ { $notBefore } ถึง { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = การใช้กุญแจ: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = ที่อยู่อีเมล: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = ออกโดย: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = จัดเก็บไว้ใน: { $storedOn }
client-auth-cert-remember-box =
    .label = จดจำการตัดสินใจนี้

## Set password (p12) dialog

set-password-window =
    .title = เลือกรหัสผ่านสำรองใบรับรอง :
set-password-message = รหัสผ่านสำรองใบรับรองที่กำลังจะตั้งนี้จะช่วยปกป้องไฟล์ข้อมูลสำรองที่คุณกำลังจะสร้างขึ้น  คุณจำเป็นต้องตั้งรหัสผ่านนี้ก่อนที่จะดำเนินการสำรองข้อมูลต่อ
set-password-backup-pw =
    .value = รหัสผ่านสำรองใบรับรอง :
set-password-repeat-backup-pw =
    .value = รหัสผ่านสำรองใบรับรอง (อีกครั้ง) :
set-password-reminder = สำคัญมาก : หากคุณลืมรหัสผ่านสำรองใบรับรอง คุณจะไม่สามารถเรียกคืนข้อมูลที่สำรองไว้ได้อีกต่อไป ควรบันทึกรหัสผ่านนี้ไว้ในที่ปลอดภัย

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = โปรดยืนยันตัวตนกับโทเค็น “{ $tokenName }” วิธีดำเนินการดังกล่าวขึ้นอยู่กับโทเค็น (เช่น การใช้เครื่องอ่านลายนิ้วมือ หรือการป้อนรหัสด้วยแป้นตัวเลข)
