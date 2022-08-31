# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = ใช้ผู้ให้บริการ
    .accesskey = ช

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (ค่าเริ่มต้น)
    .tooltiptext = ใช้ URL เริ่มต้นสำหรับแปลงที่อยู่ DNS ผ่าน HTTPS

connection-dns-over-https-url-custom =
    .label = กำหนดเอง
    .accesskey = ก
    .tooltiptext = ป้อน URL ที่คุณต้องการสำหรับแปลงที่อยู่ DNS ผ่าน HTTPS

connection-dns-over-https-custom-label = กำหนดเอง

connection-dialog-window =
    .title = การตั้งค่าการเชื่อมต่อ
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = กำหนดค่าพร็อกซีเพื่อเข้าถึงอินเทอร์เน็ต

proxy-type-no =
    .label = ไม่มีพร็อกซี
    .accesskey = ม

proxy-type-wpad =
    .label = ตรวจหาการตั้งค่าพร็อกซีอัตโนมัติสำหรับเครือข่ายนี้
    .accesskey = ต

proxy-type-system =
    .label = ใช้การตั้งค่าพร็อกซีของระบบ
    .accesskey = ช

proxy-type-manual =
    .label = การกำหนดค่าพร็อกซีด้วยตนเอง:
    .accesskey = ก

proxy-http-label =
    .value = พร็อกซี HTTP:
    .accesskey = h

http-port-label =
    .value = พอร์ต:
    .accesskey = พ

proxy-http-sharing =
    .label = ใช้พร็อกซีนี้สำหรับ HTTPS ด้วย
    .accesskey = ก

proxy-https-label =
    .value = พร็อกซี HTTPS:
    .accesskey = S

ssl-port-label =
    .value = พอร์ต:
    .accesskey = อ

proxy-socks-label =
    .value = โฮสต์ SOCKS:
    .accesskey = c

socks-port-label =
    .value = พอร์ต:
    .accesskey = ร

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL กำหนดค่าพร็อกซีอัตโนมัติ:
    .accesskey = ห

proxy-reload-label =
    .label = โหลดใหม่
    .accesskey = โ

no-proxy-label =
    .value = ไม่มีพร็อกซีสำหรับ:
    .accesskey = ไ

no-proxy-example = ตัวอย่าง: .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = ไม่ต้องถามสำหรับการรับรองความถูกต้องหากรหัสผ่านถูกบันทึกไว้
    .accesskey = ถ
    .tooltiptext = ตัวเลือกนี้จะรับรองความถูกต้องของคุณไปยังพร็อกซีโดยอัตโนมัติเมื่อคุณได้บันทึกหนังสือรับรองไว้ คุณจะได้รับการแจ้งหากการรับรองความถูกต้องล้มเหลว

proxy-remote-dns =
    .label = DNS แบบพร็อกซีเมื่อใช้ SOCKS v5
    .accesskey = d

proxy-enable-doh =
    .label = เปิดใช้งาน DNS ผ่าน HTTPS
    .accesskey = ป
