# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = การตั้งค่า Profiler
perftools-intro-description =
    การอัดบันทึกจะเปิด profiler.firefox.com ในแท็บใหม่ ข้อมูลทั้งหมดจะถูกเก็บ
    ในเครื่อง แต่คุณสามารถเลือกที่จะอัปโหลดเพื่อแบ่งปันได้

## All of the headings for the various sections.

perftools-heading-settings = การตั้งค่าแบบเต็ม
perftools-heading-buffer = การตั้งค่าบัฟเฟอร์
perftools-heading-features = คุณลักษณะ
perftools-heading-features-default = คุณสมบัติ (แนะนำโดยค่าเริ่มต้น)
perftools-heading-features-disabled = คุณสมบัติที่ปิดใช้งาน
perftools-heading-features-experimental = การทดลอง
perftools-heading-threads = เธรด
perftools-heading-threads-jvm = เธรด JVM
perftools-heading-local-build = บิลด์ภายในเครื่อง

##

perftools-description-intro =
    การอัดบันทึกจะเปิด <a>profiler.firefox.com</a> ในแท็บใหม่ ข้อมูลทั้งหมดจะถูกเก็บ
    ในเครื่อง แต่คุณสามารถเลือกที่จะอัปโหลดเพื่อแบ่งปันได้
perftools-description-local-build =
    หากคุณกำลังสร้างโปรไฟล์ให้กับบิลด์ที่คุณคอมไพล์ด้วยตัวเอง บนเครื่องนี้
    โปรดเพิ่ม objdir ของบิลด์ของคุณลงในรายการด้านล่างเพื่อให้สามารถ
    นำมาใช้ในการค้นหาข้อมูลสัญลักษณ์ได้

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = ช่วงการสุ่มตัวอย่าง:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } มิลลิวินาที

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = ขนาดบัฟเฟอร์:

perftools-custom-threads-label = เพิ่มหัวข้อที่กำหนดเองตามชื่อ:

perftools-devtools-interval-label = ช่วงเวลา:
perftools-devtools-threads-label = เธรด:
perftools-devtools-settings-label = การตั้งค่า

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-recording-stopped-by-another-tool = การบันทึกถูกหยุดโดยเครื่องมืออื่น
perftools-status-restart-required = ต้องเริ่มการทำงานเบราว์เซอร์ใหม่เพื่อเปิดใช้งานคุณลักษณะนี้

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = กำลังหยุดการบันทึก
perftools-request-to-get-profile-and-stop-profiler = กำลังจับโปรไฟล์

##

perftools-button-start-recording = เริ่มการบันทึก
perftools-button-capture-recording = จับการอัดบันทึก
perftools-button-cancel-recording = ยกเลิกการบันทึก
perftools-button-save-settings = บันทึกการตั้งค่าและย้อนกลับ
perftools-button-restart = เริ่มการทำงานใหม่
perftools-button-add-directory = เพิ่มไดเร็กทอรี
perftools-button-remove-directory = เอาที่เลือกออก
perftools-button-edit-settings = แก้ไขการตั้งค่า…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = โปรเซสหลักสำหรับทั้งโปรเซสแม่และโปรเซสเนื้อหา
perftools-thread-compositor =
    .title = รวมองค์ประกอบที่ถูกระบายสีต่าง ๆ บนหน้านี้เข้าด้วยกัน
perftools-thread-dom-worker =
    .title = เธรดนี้จัดการทั้ง Web Worker และ Service Worker
perftools-thread-renderer =
    .title = เมื่อเปิดใช้งาน WebRender แล้ว เธรดที่ดำเนินการเรียก OpenGL
perftools-thread-render-backend =
    .title = เธรด RenderBackend ของ WebRender
perftools-thread-timer =
    .title = ตัวจับเวลาการจัดการเธรด (setTimeout, setInterval, nsITimer)
perftools-thread-style-thread =
    .title = การคำนวณรูปแบบจะแบ่งออกเป็นหลายเธรด
pref-thread-stream-trans =
    .title = การขนส่งกระแสเครือข่าย
perftools-thread-socket-thread =
    .title = เธรดที่รหัสการเชื่อมต่อเครือข่ายเรียกใช้การเรียกซ็อกเก็ตการปิดกั้นใด ๆ
perftools-thread-img-decoder =
    .title = เธรดการถอดรหัสรูปภาพ
perftools-thread-dns-resolver =
    .title = การแก้ปัญหา DNS เกิดขึ้นในเธรดนี้
perftools-thread-task-controller =
    .title = เธรดในเธรดพูล TaskController
perftools-thread-jvm-gecko =
    .title = เธรดหลักของ Gecko JVM
perftools-thread-jvm-nimbus =
    .title = เธรดหลักสำหรับ Nimbus experiments SDK
perftools-thread-jvm-default-dispatcher =
    .title = ตัวจ่ายงานเริ่มต้นสำหรับไลบรารี coroutines ของ Kotlin
perftools-thread-jvm-glean =
    .title = เธรดหลักสำหรับ Glean telemetry SDK
perftools-thread-jvm-arch-disk-io =
    .title = ตัวจ่ายงาน IO สำหรับไลบรารี coroutines ของ Kotlin
perftools-thread-jvm-pool =
    .title = เธรดที่สร้างขึ้นในพูลเธรดที่ไม่มีชื่อ

##

perftools-record-all-registered-threads = ข้ามการเลือกด้านบนและบันทึกเธรดที่ลงทะเบียนทั้งหมด

perftools-tools-threads-input-label =
    .title = ชื่อเธรดเหล่านี้เป็นรายการที่คั่นด้วยจุลภาคที่ใช้ในการเปิดใช้งานการสร้างโปรไฟล์ของเธรดในตัวสร้างโปรไฟล์ ชื่อจะต้องตรงกับชื่อเธรดที่จะรวมเพียงบางส่วนเท่านั้น โดยจะมีการเทียบช่องว่างด้วย

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## devtools.performance.new-panel-onboarding preference is true.

perftools-onboarding-message = <b>ใหม่</b>: { -profiler-brand-name } ถูกรวมเข้ากับเครื่องมือสำหรับนักพัฒนาแล้ว <a>เรียนรู้เพิ่มเติม</a>เกี่ยวกับเครื่องมือใหม่อันทรงพลังนี้

perftools-onboarding-close-button =
    .aria-label = ปิดข้อความออนบอร์ด

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/shared/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = นักพัฒนาเว็บ
perftools-presets-web-developer-description = ค่าที่ตั้งล่วงหน้าที่แนะนำสำหรับการดีบั๊กเว็บแอปส่วนใหญ่ โดยมีโอเวอร์เฮดต่ำ

perftools-presets-firefox-label = { -brand-shorter-name }
perftools-presets-firefox-description = ค่าที่ตั้งล่วงหน้าที่แนะนำสำหรับการรวบรวมประวัติ { -brand-shorter-name }

perftools-presets-graphics-label = กราฟิก
perftools-presets-graphics-description = ค่าที่ตั้งล่วงหน้าสำหรับการตรวจสอบบั๊กเกี่ยวกับกราฟิกใน { -brand-shorter-name }

perftools-presets-media-label = สื่อ
perftools-presets-media-description2 = ค่าที่ตั้งล่วงหน้าสำหรับการตรวจสอบบั๊กเกี่ยวกับเสียงและวิดีโอใน { -brand-shorter-name }

perftools-presets-networking-label = ระบบเครือข่าย
perftools-presets-networking-description = ค่าที่ตั้งล่วงหน้าสำหรับการตรวจสอบบั๊กเกี่ยวกับระบบเครือข่ายใน { -brand-shorter-name }

# "Power" is used in the sense of energy (electricity used by the computer).
perftools-presets-power-label = พลังงาน
perftools-presets-power-description = ค่าที่ตั้งล่วงหน้าสำหรับการตรวจสอบบั๊กเกี่ยวกับการใช้พลังงานใน { -brand-shorter-name } โดยมีโอเวอร์เฮดต่ำ

perftools-presets-custom-label = กำหนดเอง

##

