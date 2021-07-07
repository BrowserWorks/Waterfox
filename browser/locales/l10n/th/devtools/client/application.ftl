# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Header for the list of Service Workers displayed in the application panel for the current page.
serviceworker-list-header = ตัวทำงานบริการ
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = เปิด <a>about:debugging</a> สำหรับตัวทำงานบริการจากโดเมนอื่น ๆ
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = เลิกลงทะเบียน
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = ดีบั๊ก
    .title = สามารถดีบั๊กได้เฉพาะเวิร์กเกอร์บริการที่ทำงานอยู่เท่านั้น
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = ดีบั๊ก
    .title = สามารถดีบั๊กตัวทำงานบริการได้หาก multi e10s ถูกปิดใช้งานอยู่เท่านั้น
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = เริ่ม
    .title = สามารถเริ่มตัวทำงานบริการได้หาก multi e10s ถูกปิดใช้งานอยู่เท่านั้น
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = ตรวจสอบ
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = เริ่ม
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = อัปเดตเมื่อ <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = แหล่งที่มา
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = สถานะ

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = กำลังทำงาน
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = หยุดอยู่
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = คุณต้องลงทะเบียนเวิร์กเกอร์บริการเพื่อตรวจสอบที่นี่ <a>เรียนรู้เพิ่มเติม</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = ถ้าหน้าปัจจุบันควรมีเวิร์กเกอร์บริการ ต่อไปนี้คือบางสิ่งที่คุณสามารถลองทำได้
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = มองหาข้อผิดพลาดในคอนโซล <a>เปิดคอนโซล</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = ลงทะเบียนเวิร์กเกอร์บริการของคุณตามขั้นตอนที่กำหนดและมองหาข้อยกเว้น <a>เปิดตัวดีบั๊ก</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = ตรวจสอบเวิร์กเกอร์บริการจากโดเมนอื่น <a>เปิด about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = ไม่พบตัวทำงานบริการ
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = เรียนรู้เพิ่มเติม
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = หากหน้าปัจจุบันควรมีตัวทำงานบริการ คุณสามารถมองหาข้อผิดพลาดใน<a>คอนโซล</a>หรือลงทะเบียนตัวทำงานบริการของคุณใน<span>ตัวดีบั๊ก</span>ได้
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = ดูตัวทำงานบริการจากโดเมนอื่น
# Header for the Manifest page when we have an actual manifest
manifest-view-header = ไฟล์กำกับของแอป
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = คุณต้องเพิ่มไฟล์กำกับของแอปพลิเคชันเว็บเพื่อตรวจสอบที่นี่ <a>เรียนรู้เพิ่มเติม</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = ตรวจไม่พบไฟล์กำกับเว็บแอป
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = เรียนรู้วิธีเพิ่มไฟล์กำกับ
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = ข้อผิดพลาดและคำเตือน
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = ข้อมูลประจำตัว
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = งานนำเสนอ
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = ไอคอน
# Text displayed while we are loading the manifest file
manifest-loading = กำลังโหลดไฟล์กำกับ…
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = โหลดไฟล์กำกับแล้ว
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = มีข้อผิดพลาดขณะโหลดไฟล์กำกับ:
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = ข้อผิดพลาด Firefox DevTools
# Text displayed when the page has no manifest available
manifest-non-existing = ไม่พบไฟล์กำกับที่จะตรวจสอบ
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = ไฟล์กำกับถูกฝังอยู่ใน URL ข้อมูล
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = จุดประสงค์: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = ไอคอน
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = ไอคอนที่มีขนาด: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = ไอคอนขนาดที่ไม่ระบุ
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = ไฟล์กำกับ
    .alt = ไอคอนไฟล์กำกับ
    .title = ไฟล์กำกับ
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = ตัวทำงานบริการ
    .alt = ไอคอนตัวทำงานบริการ
    .title = ตัวทำงานบริการ
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = ไอคอนคำเตือน
    .title = คำเตือน
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = ไอคอนข้อผิดพลาด
    .title = ข้อผิดพลาด
