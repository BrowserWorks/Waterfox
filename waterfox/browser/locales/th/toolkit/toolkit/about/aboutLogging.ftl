# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = เกี่ยวกับการบันทึก
about-logging-page-title = ตัวจัดการการบันทึก
about-logging-current-log-file = ไฟล์ปูมปัจจุบัน:
about-logging-new-log-file = ไฟล์ปูมใหม่:
about-logging-currently-enabled-log-modules = โมดูลบันทึกที่เปิดใช้งานในขณะนี้:
about-logging-log-tutorial = ดู<a data-l10n-name="logging">การบันทึกปูม HTTP</a>สำหรับคำแนะนำเกี่ยวกับวิธีการใช้เครื่องมือนี้
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = เปิดไดเรกทอรี
about-logging-set-log-file = ตั้งไฟล์ปูม
about-logging-set-log-modules = ตั้งโมดูลบันทึก
about-logging-start-logging = เริ่มการบันทึก
about-logging-stop-logging = หยุดการบันทึก
about-logging-buttons-disabled = การบันทึกถูกกำหนดค่าผ่านตัวแปรสภาพแวดล้อม การกำหนดค่าแบบไดนามิกไม่พร้อมใช้งาน
about-logging-some-elements-disabled = การบันทึกถูกกำหนดค่าผ่าน URL ตัวเลือกการกำหนดค่าบางอย่างไม่สามารถใช้งานได้
about-logging-info = ข้อมูล:
about-logging-log-modules-selection = การเลือกโมดูลบันทึก
about-logging-new-log-modules = โมดูลบันทึกใหม่:
about-logging-logging-output-selection = ผลลัพธ์การบันทึก
about-logging-logging-to-file = การบันทึกลงไฟล์
about-logging-logging-to-profiler = การบันทึกลง { -profiler-brand-name }
about-logging-no-log-modules = ไม่มี
about-logging-no-log-file = ไม่มี
about-logging-logging-preset-selector-text = ค่าที่ตั้งไว้ล่วงหน้าของการบันทึก:
about-logging-with-profiler-stacks-checkbox = เปิดใช้งานการตามรอยสแต็กสำหรับข้อความในปูม

## Logging presets

about-logging-preset-networking-label = ระบบเครือข่าย
about-logging-preset-networking-description = โมดูลบันทึกสำหรับวินิจฉัยปัญหาระบบเครือข่าย
about-logging-preset-networking-cookie-label = คุกกี้
about-logging-preset-networking-cookie-description = โมดูลบันทึกสำหรับวินิจฉัยปัญหาคุกกี้
about-logging-preset-networking-websocket-label = WebSockets
about-logging-preset-networking-websocket-description = โมดูลบันทึกสำหรับวินิจฉัยปัญหา WebSocket
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = โมดูลบันทึกสำหรับวินิจฉัยปัญหา HTTP/3 และ QUIC
about-logging-preset-media-playback-label = การเล่นสื่อ
about-logging-preset-media-playback-description = โมดูลบันทึกสำหรับวินิจฉัยปัญหาการเล่นสื่อ (ไม่ใช่ปัญหาการประชุมทางวิดีโอ)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = โมดูลบันทึกสำหรับวินิจฉัยการเรียก WebRTC
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = โมดูลบันทึกสำหรับวินิจฉัยปัญหา WebGPU
about-logging-preset-custom-label = กำหนดเอง
about-logging-preset-custom-description = โมดูลบันทึกที่เลือกด้วยตนเอง
# Error handling
about-logging-error = ข้อผิดพลาด:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = ค่า “{ $v }“ ไม่ถูกต้องสำหรับคีย์ “{ $k }“
about-logging-unknown-logging-preset = ไม่รู้จักค่าที่ตั้งไว้ล่วงหน้าของการบันทึก “{ $v }“
about-logging-unknown-profiler-preset = ไม่รู้จักค่าที่ตั้งไว้ล่วงหน้าของตัวสร้างโปรไฟล์ “{ $v }“
about-logging-unknown-option = ไม่รู้จักตัวเลือก about:logging “{ $k }“
about-logging-configuration-url-ignored = เพิกเฉย URL การกำหนดค่าแล้ว
about-logging-file-and-profiler-override = ไม่สามารถบังคับให้ส่งออกไฟล์และแทนที่ตัวเลือกตัวสร้างโปรไฟล์พร้อมกันได้
about-logging-configured-via-url = ตัวเลือกที่กำหนดค่าผ่าน URL
