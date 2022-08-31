# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = ตัวจัดการใบรับรอง

certmgr-tab-mine =
    .label = ใบรับรองของคุณ

certmgr-tab-remembered =
    .label = การตัดสินใจการรับรองความถูกต้อง

certmgr-tab-people =
    .label = ผู้คน

certmgr-tab-servers =
    .label = เซิร์ฟเวอร์

certmgr-tab-ca =
    .label = หน่วยงาน

certmgr-mine = คุณมีใบรับรองจากองค์กรเหล่านี้ที่ระบุตัวตนคุณ
certmgr-remembered = ใบรับรองเหล่านี้ถูกใช้เพื่อระบุตัวตนของคุณต่อเว็บไซต์
certmgr-people = คุณมีใบรับรองในไฟล์ที่ระบุผู้คนเหล่านี้
certmgr-server = รายการเหล่านี้ระบุข้อผิดพลาดของใบรับรองเซิร์ฟเวอร์
certmgr-ca = คุณมีใบรับรองในไฟล์ที่ระบุผู้ออกใบรับรองเหล่านี้

certmgr-edit-ca-cert =
    .title = แก้ไขการตั้งค่าความน่าเชื่อถือของใบรับรอง CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = แก้ไขการตั้งค่าความน่าเชื่อถือ :

certmgr-edit-cert-trust-ssl =
    .label = ใบรับรองนี้สามารถระบุเว็บไซต์

certmgr-edit-cert-trust-email =
    .label = ใบรับรองนี้สามารถระบุผู้ใช้จดหมาย

certmgr-delete-cert =
    .title = ลบใบรับรอง
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = โฮสต์

certmgr-cert-name =
    .label = ชื่อใบรับรอง

certmgr-cert-server =
    .label = เซิร์ฟเวอร์

certmgr-override-lifetime =
    .label = อายุการใช้งาน

certmgr-token-name =
    .label = อุปกรณ์ความปลอดภัย

certmgr-begins-label =
    .label = เริ่มเมื่อ

certmgr-expires-label =
    .label = หมดอายุเมื่อ

certmgr-email =
    .label = ที่อยู่อีเมล

certmgr-serial =
    .label = หมายเลขอนุกรม

certmgr-view =
    .label = ดู…
    .accesskey = ด

certmgr-edit =
    .label = แก้ไขการเชื่อถือ…
    .accesskey = ก

certmgr-export =
    .label = ส่งออก…
    .accesskey = ส

certmgr-delete =
    .label = ลบ…
    .accesskey = ล

certmgr-delete-builtin =
    .label = ลบหรือเลิกเชื่อถือ…
    .accesskey = ถ

certmgr-backup =
    .label = สำรองข้อมูล…
    .accesskey = ร

certmgr-backup-all =
    .label = สำรองข้อมูลทั้งหมด…
    .accesskey = อ

certmgr-restore =
    .label = นำเข้า…
    .accesskey = น

certmgr-add-exception =
    .label = เพิ่มข้อยกเว้น…
    .accesskey = ย

exception-mgr =
    .title = เพิ่มข้อยกเว้นความปลอดภัย

exception-mgr-extra-button =
    .label = ยืนยันข้อยกเว้นความปลอดภัย
    .accesskey = ย

exception-mgr-supplemental-warning = ธนาคาร, ห้างร้าน และเว็บไซต์สาธารณะที่ถูกกฎหมายจะไม่ให้คุณทำเช่นนี้

exception-mgr-cert-location-url =
    .value = ตำแหน่งที่ตั้ง:

exception-mgr-cert-location-download =
    .label = รับใบรับรอง
    .accesskey = ร

exception-mgr-cert-status-view-cert =
    .label = ดู…
    .accesskey = ด

exception-mgr-permanent =
    .label = จัดเก็บข้อยกเว้นนี้อย่างถาวร
    .accesskey = ถ

pk11-bad-password = รหัสผ่านที่ป้อนไม่ถูกต้อง
pkcs12-decode-err = ไม่สามารถถอดรหัสไฟล์ได้ อาจเป็นไปได้ว่าไฟล์ไม่อยู่ในรูปแบบ PKCS #12 เสียหาย หรือรหัสผ่านที่คุณกรอกนั้นไม่ถูกต้อง
pkcs12-unknown-err-restore = ไม่ทราบสาเหตุที่ไม่สามารถเรียกคืนไฟล์ PKCS #12 ได้
pkcs12-unknown-err-backup = ไม่ทราบสาเหตุที่ไม่สามารถสร้างไฟล์สำรองข้อมูลของ PKCS #12 ได้
pkcs12-unknown-err = ไม่ทราบสาเหตุที่การกระทำ PKCS #12 ล้มเหลว
pkcs12-info-no-smartcard-backup = ไม่สามารถสำรองใบรับรองจากอุปกรณ์รักษาความปลอดภัยเช่นสมาร์ตการ์ดได้
pkcs12-dup-data = มีใบรับรองและกุญแจส่วนตัวอยู่แล้วในอุปกรณ์รักษาความปลอดภัย

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = ชื่อไฟล์ที่จะสำรองข้อมูล
file-browse-pkcs12-spec = ไฟล์ PKCS12
choose-p12-restore-file-dialog = ไฟล์ใบรับรองที่จะนำเข้า

## Import certificate(s) file dialog

file-browse-certificate-spec = ไฟล์ใบรับรอง
import-ca-certs-prompt = เลือกไฟล์ที่มีใบรับรอง CA เพื่อนำเข้า
import-email-cert-prompt = เลือกไฟล์ที่มีใบรับรองอีเมลของใครบางคนเพื่อนำเข้า

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = ใบรับรอง "{ $certName }" เป็น Certificate Authority

## For Deleting Certificates

delete-user-cert-title =
    .title = ลบใบรับรองของคุณ
delete-user-cert-confirm = คุณแน่ใจหรือไม่ว่าต้องการลบใบรับรองเหล่านี้?
delete-user-cert-impact = ถ้าคุณลบใบรับรองใด ๆ ของคุณ คุณจะไม่สามารถระบุตัวคุณเองได้อีกต่อไป


delete-ssl-override-title =
    .title = ลบข้อยกเว้นใบรับรองของเซิร์ฟเวอร์
delete-ssl-override-confirm = คุณแน่ใจหรือไม่ว่าต้องการลบข้อยกเว้นเซิร์ฟเวอร์นี้?
delete-ssl-override-impact = ถ้าคุณลบข้อยกเว้นเซิร์ฟเวอร์นี้ นั่นเป็นการเปิดใช้การรักษาความปลอดภัยตามปกติกับเซิร์ฟเวอร์นี้ และเซิร์ฟเวอร์นี้ต้องการใบรับรองที่ถูกต้องเพื่อให้ใช้งานได้

delete-ca-cert-title =
    .title = ลบหรือเลิกเชื่อถือใบรับรอง CA
delete-ca-cert-confirm = คุณได้ขอลบใบรับรอง CA เหล่านี้ สำหรับใบรับรองในตัวการเชื่อถือทั้งหมดจะถูกเอาออก ซึ่งมีผลเดียวกัน คุณแน่ใจหรือไม่ว่าต้องการลบหรือเลิกเชื่อถือ?
delete-ca-cert-impact = หากคุณลบหรือเลิกเชื่อถือใบรับรองของผู้ออกใบรับรอง (CA) แอปพลิเคชันนี้จะไม่เชื่อถือใบรับรองใด ๆ ที่ออกโดย CA นั้นอีกต่อไป


delete-email-cert-title =
    .title = ลบใบรับรองอีเมล
delete-email-cert-confirm = คุณต้องการลบใบรับรองอีเมลของบุคคลเหล่านี้หรือไม่?
delete-email-cert-impact = หากคุณลบใบรับรองอีเมลของบุคคล คุณจะไม่สามารถส่งอีเมลที่เข้ารหัสให้กับบุคคลนั้นได้อีกต่อไป

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = ใบรับรองที่มีหมายเลขซีเรียล: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = ไม่ต้องส่งใบรับรองไคลเอ็นต์ใด ๆ

# Used when no cert is stored for an override
no-cert-stored-for-override = (ไม่ได้เก็บไว้)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (ไม่พร้อมใช้งาน)

## Used to show whether an override is temporary or permanent

permanent-override = ถาวร
temporary-override = ชั่วคราว

## Add Security Exception dialog

add-exception-branded-warning = คุณกำลังก้าวล่วงวิธีการที่ { -brand-short-name } จะทำการระบุตัวตนเว็บไซต์นี้
add-exception-invalid-header = ไซต์นี้พยายามจะระบุตัวเองด้วยข้อมูลที่ไม่ถูกต้อง
add-exception-domain-mismatch-short = เว็บไซต์ผิด
add-exception-domain-mismatch-long = ใบรับรองเป็นของไซต์อื่น ซึ่งอาจหมายความว่ามีคนพยายามเลียนแบบไซต์นี้
add-exception-expired-short = ข้อมูลล้าสมัย
add-exception-expired-long = ใบรับรองไม่ถูกต้องในขณะนี้ อาจถูกขโมยหรือสูญหาย และอาจถูกนำไปใช้โดยบางคนเพื่อปลอมแปลงไซต์นี้
add-exception-unverified-or-bad-signature-short = ไม่ทราบข้อมูลประจำตัว
add-exception-unverified-or-bad-signature-long = ใบรับรองไม่น่าเชื่อถือ เพราะไม่ได้รับการตรวจสอบจากองค์กรรับรองที่เป็นที่รู้จักโดยใช้ลายเซ็นที่ปลอดภัย
add-exception-valid-short = ใบรับรองถูกต้อง
add-exception-valid-long = เว็บไซต์นี้มีการระบุตัวตนที่ถูกต้อง คุณไม่จำเป็นต้องทำการเพิ่มข้อยกเว้น
add-exception-checking-short = กำลังตรวจสอบข้อมูล
add-exception-checking-long = กำลังพยายามระบุไซต์นี้…
add-exception-no-cert-short = ไม่มีข้อมูล
add-exception-no-cert-long = ไม่สามารถรับสถานะการระบุตัวตนสำหรับไซต์นี้

## Certificate export "Save as" and error dialogs

save-cert-as = บันทึกใบรับรองเป็นไฟล์
cert-format-base64 = ใบรับรอง X.509 (PEM)
cert-format-base64-chain = ใบรับรอง X.509 พร้อม chian (PEM)
cert-format-der = ใบรับรอง X.509 (DER)
cert-format-pkcs7 = ใบรับรอง X.509 (PKCS#7)
cert-format-pkcs7-chain = ใบรับรอง X.509 พร้อม chain (PKCS#7)
write-file-failure = ข้อผิดพลาดไฟล์
