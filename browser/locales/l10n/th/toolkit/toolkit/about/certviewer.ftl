# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = ใบรับรอง

## Error messages

certificate-viewer-error-message = เราไม่พบข้อมูลใบรับรองหรือใบรับรองเสียหาย โปรดลองอีกครั้ง
certificate-viewer-error-title = มีบางอย่างผิดพลาด

## Certificate information labels

certificate-viewer-algorithm = อัลกอริทึม
certificate-viewer-certificate-authority = ผู้ออกใบรับรอง
certificate-viewer-cipher-suite = ชุดการเข้ารหัส
certificate-viewer-common-name = ชื่อทั่วไป
certificate-viewer-email-address = ที่อยู่อีเมล
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = ใบรับรองสำหรับ { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = ประเทศที่จดทะเบียน
certificate-viewer-country = ประเทศ
certificate-viewer-curve = เส้นโค้ง
certificate-viewer-distribution-point = จุดแจกจ่าย
certificate-viewer-dns-name = ชื่อ DNS
certificate-viewer-ip-address = ที่อยู่ IP
certificate-viewer-other-name = ชื่ออื่น
certificate-viewer-exponent = เลขชี้กำลัง
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = กลุ่มการแลกเปลี่ยนคีย์
certificate-viewer-key-id = ID คีย์
certificate-viewer-key-size = ขนาดคีย์
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = สถานที่ที่ก่อตั้ง
certificate-viewer-locality = สถานที่
certificate-viewer-location = ตำแหน่งที่ตั้ง
certificate-viewer-logid = ID รายการบันทึก
certificate-viewer-method = วิธีการ
certificate-viewer-modulus = โมดูลัส
certificate-viewer-name = ชื่อ
certificate-viewer-not-after = ก่อน
certificate-viewer-not-before = หลัง
certificate-viewer-organization = องค์กร
certificate-viewer-organizational-unit = หน่วยงาน
certificate-viewer-policy = นโยบาย
certificate-viewer-protocol = โปรโตคอล
certificate-viewer-public-value = ค่าสาธารณะ
certificate-viewer-purposes = จุดประสงค์
certificate-viewer-qualifier = ตัวบ่งคุณลักษณะ
certificate-viewer-qualifiers = ตัวบ่งคุณลักษณะ
certificate-viewer-required = จำเป็น
certificate-viewer-unsupported = &lt;ไม่รองรับ&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = รัฐ/จังหวัดที่จดทะเบียน
certificate-viewer-state-province = รัฐ/จังหวัด
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = หมายเลขอนุกรม
certificate-viewer-signature-algorithm = อัลกอริธึมลายเซ็น
certificate-viewer-signature-scheme = แบบแผนลายเซ็น
certificate-viewer-timestamp = การประทับเวลา
certificate-viewer-value = ค่า
certificate-viewer-version = รุ่น
certificate-viewer-business-category = หมวดหมู่ธุรกิจ
certificate-viewer-subject-name = ชื่อหัวเรื่อง
certificate-viewer-issuer-name = ชื่อผู้ออก
certificate-viewer-validity = ความถูกต้อง
certificate-viewer-subject-alt-names = ชื่อหัวเรื่องแสดงแทน
certificate-viewer-public-key-info = ข้อมูลคีย์สาธารณะ
certificate-viewer-miscellaneous = เบ็ดเตล็ด
certificate-viewer-fingerprints = ลายนิ้วมือ
certificate-viewer-basic-constraints = ข้อจำกัดพื้นฐาน
certificate-viewer-key-usages = การใช้คีย์
certificate-viewer-extended-key-usages = การใช้คีย์แบบขยาย
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = ID คีย์หัวเรื่อง
certificate-viewer-authority-key-id = ID คีย์ของผู้อนุมัติ
certificate-viewer-authority-info-aia = ข้อมูลผู้อนุมัติ (AIA)
certificate-viewer-certificate-policies = นโยบายใบรับรอง
certificate-viewer-embedded-scts = SCT ที่ฝัง
certificate-viewer-crl-endpoints = ปลายทาง CRL

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = ดาวน์โหลด
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] ใช่
       *[false] ไม่
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = ส่วนขยายนี้ถูกทำเครื่องหมายว่าสำคัญ ซึ่งหมายความว่าไคลเอนต์จะต้องปฏิเสธใบรับรองหากพวกเขาไม่เข้าใจดีพอ
certificate-viewer-export = ส่งออก
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (ไม่ทราบ)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = ใบรับรองของคุณ
certificate-viewer-tab-people = ผู้คน
certificate-viewer-tab-servers = เซิร์ฟเวอร์
certificate-viewer-tab-ca = หน่วยงาน
certificate-viewer-tab-unkonwn = ไม่ทราบ
