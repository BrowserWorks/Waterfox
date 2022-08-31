# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = ข้อยกเว้น
    .style = width: 45em

permissions-close-key =
    .key = w

permissions-address = ที่อยู่เว็บไซต์
    .accesskey = ท

permissions-block =
    .label = ปิดกั้น
    .accesskey = ป

permissions-session =
    .label = อนุญาตในวาระ
    .accesskey = น

permissions-allow =
    .label = อนุญาต
    .accesskey = อ

permissions-button-off =
    .label = ปิด
    .accesskey = O

permissions-button-off-temporarily =
    .label = ปิดชั่วคราว
    .accesskey = T

permissions-site-name =
    .label = เว็บไซต์

permissions-status =
    .label = สถานะ

permissions-remove =
    .label = เอาเว็บไซต์ออก
    .accesskey = อ

permissions-remove-all =
    .label = เอาเว็บไซต์ทั้งหมดออก
    .accesskey = ว

permission-dialog =
    .buttonlabelaccept = บันทึกการเปลี่ยนแปลง
    .buttonaccesskeyaccept = บ

permissions-autoplay-menu = ค่าเริ่มต้นสำหรับเว็บไซต์ทั้งหมด:

permissions-searchbox =
    .placeholder = ค้นหาเว็บไซต์

permissions-capabilities-autoplay-allow =
    .label = อนุญาตเสียงและวิดีโอ
permissions-capabilities-autoplay-block =
    .label = ปิดกั้นเสียง
permissions-capabilities-autoplay-blockall =
    .label = ปิดกั้นเสียงและวิดีโอ

permissions-capabilities-allow =
    .label = อนุญาต
permissions-capabilities-block =
    .label = ปิดกั้น
permissions-capabilities-prompt =
    .label = ถามเสมอ

permissions-capabilities-listitem-allow =
    .value = อนุญาต
permissions-capabilities-listitem-block =
    .value = ปิดกั้น
permissions-capabilities-listitem-allow-session =
    .value = อนุญาตในวาระ

permissions-capabilities-listitem-off =
    .value = ปิด
permissions-capabilities-listitem-off-temporarily =
    .value = ปิดชั่วคราว

## Invalid Hostname Dialog

permissions-invalid-uri-title = ชื่อโฮสต์ที่ป้อนไม่ถูกต้อง
permissions-invalid-uri-label = โปรดป้อนชื่อโฮสต์ที่ถูกต้อง

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = ข้อยกเว้นสำหรับการป้องกันการติดตามที่มากขึ้น
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = คุณได้ปิดการป้องกันของเว็บไซต์เหล่านี้

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = ข้อยกเว้น - คุกกี้และข้อมูลไซต์
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = คุณสามารถระบุเว็บไซต์ที่อนุญาตหรือไม่อนุญาตให้ใช้คุกกี้และข้อมูลไซต์เสมอ พิมพ์ที่อยู่ของไซต์ที่คุณต้องการจัดการแล้วคลิก ปิดกั้น, อนุญาตในวาระ หรืออนุญาต

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = ข้อยกเว้น - โหมด HTTPS-Only
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = คุณสามารถปิดโหมด HTTPS-Only สำหรับแต่ละเว็บไซต์ได้ { -brand-short-name } จะไม่พยายามอัปเกรดการเชื่อมต่อเป็น HTTPS แบบปลอดภัยสำหรับไซต์เหล่านั้น ข้อยกเว้นจะไม่นำไปใช้กับหน้าต่างส่วนตัว

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = เว็บไซต์ที่อนุญาต - ป๊อปอัป
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = คุณสามารถระบุเว็บไซต์ที่อนุญาตให้เปิดหน้าต่างป๊อปอัป พิมพ์ที่อยู่ของไซต์ที่คุณต้องการอนุญาตแล้วคลิก อนุญาต

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = ข้อยกเว้น - การเข้าสู่ระบบที่บันทึกไว้
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = การเข้าสู่ระบบสำหรับเว็บไซต์ต่อไปนี้จะไม่ถูกบันทึก

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = เว็บไซต์ที่อนุญาต - การติดตั้งส่วนเสริม
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = คุณสามารถระบุเว็บไซต์ที่อนุญาตให้ติดตั้งส่วนเสริม พิมพ์ที่อยู่ของไซต์ที่คุณต้องการอนุญาตแล้วคลิก อนุญาต

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = การตั้งค่า - การเล่นอัตโนมัติ
    .style = { permissions-window.style }
permissions-site-autoplay-desc = คุณสามารถจัดการเว็บไซต์ที่ไม่ทำงานตามการตั้งค่าเล่นอัตโนมัติเริ่มต้นที่นี่

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = การตั้งค่า - สิทธิอนุญาตการแจ้งเตือน
    .style = { permissions-window.style }
permissions-site-notification-desc = เว็บไซต์ดังต่อไปนี้ได้ขอส่งการแจ้งเตือนให้คุณ คุณสามารถระบุเว็บไซต์ที่อนุญาตให้ส่งการแจ้งเตือนให้คุณ คุณยังสามารถปิดกั้นคำขอใหม่ที่ขออนุญาตการแจ้งเตือน
permissions-site-notification-disable-label =
    .label = ปิดกั้นคำขอใหม่ที่ขออนุญาตการแจ้งเตือน
permissions-site-notification-disable-desc = นี่จะป้องกันไม่ให้เว็บไซต์ใด ๆ ที่ไม่ได้ระบุไว้ด้านบนขออนุญาตเพื่อส่งการแจ้งเตือน การปิดกั้นการแจ้งเตือนอาจทำให้คุณลักษณะบางอย่างของเว็บไซต์ไม่สมบูรณ์

## Site Permissions - Location

permissions-site-location-window =
    .title = การตั้งค่า - สิทธิอนุญาตตำแหน่งที่ตั้ง
    .style = { permissions-window.style }
permissions-site-location-desc = เว็บไซต์ดังต่อไปนี้ได้ขอเข้าถึงตำแหน่งที่ตั้งของคุณ คุณสามารถระบุเว็บไซต์ที่อนุญาตให้เข้าถึงตำแหน่งที่ตั้งของคุณ คุณยังสามารถปิดกั้นคำขอใหม่ที่ขอเข้าถึงตำแหน่งที่ตั้งของคุณ
permissions-site-location-disable-label =
    .label = ปิดกั้นคำขอใหม่ที่ขอเข้าถึงตำแหน่งที่ตั้งของคุณ
permissions-site-location-disable-desc = นี่จะป้องกันไม่ให้เว็บไซต์ใด ๆ ที่ไม่ได้ระบุไว้ด้านบนขออนุญาตเพื่อเข้าถึงตำแหน่งที่ตั้งของคุณ การปิดกั้นการเข้าถึงตำแหน่งที่ตั้งของคุณอาจทำให้คุณลักษณะบางอย่างของเว็บไซต์ไม่สมบูรณ์

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = การตั้งค่า - สิทธิอนุญาตความจริงเสมือน
    .style = { permissions-window.style }
permissions-site-xr-desc = เว็บไซต์ดังต่อไปนี้ได้ขอเข้าถึงอุปกรณ์ความจริงเสมือนของคุณ คุณสามารถระบุเว็บไซต์ที่อนุญาตให้เข้าถึงอุปกรณ์ความจริงเสมือนของคุณ คุณยังสามารถปิดกั้นคำขอใหม่ที่ขอเข้าถึงอุปกรณ์ความจริงเสมือนของคุณ
permissions-site-xr-disable-label =
    .label = ปิดกั้นคำขอใหม่ที่ขอเข้าถึงอุปกรณ์ความจริงเสมือนของคุณ
permissions-site-xr-disable-desc = นี่จะป้องกันเว็บไซต์ใด ๆ ที่ไม่ได้ระบุไว้ด้านบนจากการขออนุญาตเพื่อเข้าถึงอุปกรณ์ความจริงเสมือนของคุณ การปิดกั้นการเข้าถึงอุปกรณ์ความจริงเสมือนของคุณอาจทำให้คุณลักษณะบางอย่างของเว็บไซต์ไม่สมบูรณ์

## Site Permissions - Camera

permissions-site-camera-window =
    .title = การตั้งค่า - สิทธิอนุญาตกล้อง
    .style = { permissions-window.style }
permissions-site-camera-desc = เว็บไซต์ดังต่อไปนี้ได้ขอเข้าถึงกล้องของคุณ คุณสามารถระบุเว็บไซต์ที่อนุญาตให้เข้าถึงกล้องของคุณ คุณยังสามารถปิดกั้นคำขอใหม่ที่ขอเข้าถึงกล้องของคุณ
permissions-site-camera-disable-label =
    .label = ปิดกั้นคำขอใหม่ที่ขอเข้าถึงกล้องของคุณ
permissions-site-camera-disable-desc = นี่จะป้องกันไม่ให้เว็บไซต์ใด ๆ ที่ไม่ได้ระบุไว้ด้านบนขออนุญาตเพื่อเข้าถึงกล้องของคุณ การปิดกั้นการเข้าถึงกล้องของคุณอาจทำให้คุณลักษณะบางอย่างของเว็บไซต์ไม่สมบูรณ์

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = การตั้งค่า - สิทธิอนุญาตไมโครโฟน
    .style = { permissions-window.style }
permissions-site-microphone-desc = เว็บไซต์ดังต่อไปนี้ได้ขอเข้าถึงไมโครโฟนของคุณ คุณสามารถระบุเว็บไซต์ที่อนุญาตให้เข้าถึงไมโครโฟนของคุณ คุณยังสามารถปิดกั้นคำขอใหม่ที่ขอเข้าถึงไมโครโฟนของคุณ
permissions-site-microphone-disable-label =
    .label = ปิดกั้นคำขอใหม่ที่ขอเข้าถึงไมโครโฟนของคุณ
permissions-site-microphone-disable-desc = นี่จะป้องกันไม่ให้เว็บไซต์ใด ๆ ที่ไม่ได้ระบุไว้ด้านบนขออนุญาตเพื่อเข้าถึงไมโครโฟนของคุณ การปิดกั้นการเข้าถึงไมโครโฟนของคุณอาจทำให้คุณลักษณะบางอย่างของเว็บไซต์ไม่สมบูรณ์
