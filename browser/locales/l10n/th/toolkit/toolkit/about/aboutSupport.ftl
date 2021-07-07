# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = ข้อมูลการแก้ไขปัญหา
page-subtitle = หน้านี้มีข้อมูลทางเทคนิคที่อาจเป็นประโยชน์เมื่อคุณกำลังพยายามแก้ไขปัญหา หากคุณกำลังมองหาคำตอบสำหรับคำถามที่พบบ่อยเกี่ยวกับ { -brand-short-name } ตรวจสอบ <a data-l10n-name="support-link">เว็บไซต์สนับสนุน</a> ของเรา
crashes-title = รายงานข้อขัดข้อง
crashes-id = ID รายงาน
crashes-send-date = ส่งข้อมูลแล้ว
crashes-all-reports = รายงานข้อขัดข้องทั้งหมด
crashes-no-config = แอปพลิเคชันนี้ไม่ได้ถูกกำหนดค่าให้แสดงผลรายงานข้อข้อง
extensions-title = ส่วนขยาย
extensions-name = ชื่อ
extensions-enabled = เปิดใช้งานอยู่
extensions-version = รุ่น
extensions-id = ID
support-addons-title = ส่วนเสริม
support-addons-name = ชื่อ
support-addons-type = ชนิด
support-addons-enabled = ถูกเปิดใช้งาน
support-addons-version = รุ่น
support-addons-id = ID
security-software-title = ซอฟต์แวร์ความปลอดภัย
security-software-type = ชนิด
security-software-name = ชื่อ
security-software-antivirus = ป้องกันไวรัส
security-software-antispyware = ป้องกันสปายแวร์
security-software-firewall = ไฟร์วอลล์
features-title = คุณลักษณะของ { -brand-short-name }
features-name = ชื่อ
features-version = รุ่น
features-id = ID
processes-title = โปรเซสระยะไกล
processes-type = ชนิด
processes-count = ครั้ง
app-basics-title = พื้นฐานแอปพลิเคชัน
app-basics-name = ชื่อ
app-basics-version = รุ่น
app-basics-build-id = Build ID
app-basics-distribution-id = ID การแจกจ่าย
app-basics-update-channel = ช่องทางการอัปเดต
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] อัปเดตไดเรกทอรี
       *[other] อัปเดตโฟลเดอร์
    }
app-basics-update-history = ประวัติการอัปเดต
app-basics-show-update-history = แสดงประวัติการอัปเดต
# Represents the path to the binary used to start the application.
app-basics-binary = ไบนารีแอปพลิเคชัน
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] ไดเรกทอรีโปรไฟล์
       *[other] โฟลเดอร์โปรไฟล์
    }
app-basics-enabled-plugins = ปลั๊กอินที่เปิดใช้งาน
app-basics-build-config = การกำหนดค่าการสร้าง
app-basics-user-agent = ตัวแทนผู้ใช้
app-basics-os = ระบบปฏิบัติการ
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = แปลด้วย Rosetta
app-basics-memory-use = หน่วยความจำที่ใช้
app-basics-performance = ประสิทธิภาพ
app-basics-service-workers = ตัวทำงานบริการที่ลงทะเบียน
app-basics-profiles = โปรไฟล์
app-basics-launcher-process-status = โปรเซสของตัวเรียกใช้
app-basics-multi-process-support = หน้าต่างแบบหลายโปรเซส
app-basics-fission-support = หน้าต่าง Fission
app-basics-remote-processes-count = โปรเซสระยะไกล
app-basics-enterprise-policies = นโยบายองค์กร
app-basics-location-service-key-google = คีย์ Google Location Service
app-basics-safebrowsing-key-google = คีย์ Google Safebrowsing
app-basics-key-mozilla = คีย์ Mozilla Location Service
app-basics-safe-mode = โหมดปลอดภัย
show-dir-label =
    { PLATFORM() ->
        [macos] แสดงใน Finder
        [windows] เปิดโฟลเดอร์
       *[other] เปิดไดเรกทอรี
    }
environment-variables-title = ตัวแปรสภาพแวดล้อม
environment-variables-name = ชื่อ
environment-variables-value = ค่า
experimental-features-title = คุณลักษณะทดลอง
experimental-features-name = ชื่อ
experimental-features-value = ค่า
modified-key-prefs-title = ค่ากำหนดสำคัญที่ถูกเปลี่ยนแปลง
modified-prefs-name = ชื่อ
modified-prefs-value = ค่า
user-js-title = ค่ากำหนด user.js
user-js-description = โฟลเดอร์โปรไฟล์ของคุณมี <a data-l10n-name="user-js-link">ไฟล์ user.js</a> ซึ่งมีค่ากำหนดที่ไม่ได้ถูกสร้างโดย { -brand-short-name }
locked-key-prefs-title = ค่ากำหนดสำคัญที่ถูกล็อค
locked-prefs-name = ชื่อ
locked-prefs-value = ค่า
graphics-title = กราฟิก
graphics-features-title = คุณลักษณะ
graphics-diagnostics-title = การวินิจฉัย
graphics-failure-log-title = รายการบันทึกความล้มเหลว
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = รายการบันทึกการตัดสินใจ
graphics-crash-guards-title = คุณสมบัติที่ถูกปิดใช้งานโดย Crash Guard
graphics-workarounds-title = วิธีการแก้ไข
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = โปรโตคอลหน้าต่าง
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = สภาพแวดล้อมเดสก์ท็อป
place-database-title = ฐานข้อมูลสถานที่
place-database-integrity = ความสมบูรณ์
place-database-verify-integrity = ยืนยันความสมบูรณ์
a11y-title = การช่วยการเข้าถึง
a11y-activated = เปิดใช้งานแล้ว
a11y-force-disabled = ป้องกันการช่วยการเข้าถึง
a11y-handler-used = ใช้ตัวจัดการที่เข้าถึงได้
a11y-instantiator = ตัวสร้างอินสแตนซ์การช่วยการเข้าถึง
library-version-title = รุ่น Library
copy-text-to-clipboard-label = คัดลอกข้อความไปยังคลิปบอร์ด
copy-raw-data-to-clipboard-label = คัดลอกข้อมูลดิบไปยังคลิปบอร์ด
sandbox-title = กระบะทราย
sandbox-sys-call-log-title = ปฏิเสธการเรียกของระบบ
sandbox-sys-call-index = #
sandbox-sys-call-age = วินาทีที่แล้ว
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = ชนิดโปรเซส
sandbox-sys-call-number = การเรียกของระบบ
sandbox-sys-call-args = อาร์กิวเมนต์
safe-mode-title = ลองใช้โหมดปลอดภัย
restart-in-safe-mode-label = เริ่มการทำงานใหม่พร้อมปิดใช้งานส่วนเสริม…
troubleshoot-mode-title = วินิจฉัยปัญหา
restart-in-troubleshoot-mode-label = โหมดแก้ไขปัญหา…
clear-startup-cache-title = ลองล้างแคชเมื่อเริ่มการทำงาน
clear-startup-cache-label = ล้างแคชเมื่อเริ่มการทำงาน…
startup-cache-dialog-title = ล้างแคชเมื่อเริ่มการทำงาน
startup-cache-dialog-body = เริ่มการทำงาน { -brand-short-name } ใหม่เพื่อล้างแคชเมื่อเริ่มการทำงาน การดำเนินการนี้จะไม่เปลี่ยนแปลงการตั้งค่าของคุณหรือเอาส่วนขยายต่าง ๆ ที่คุณเพิ่มใน { -brand-short-name } ออก
startup-cache-dialog-title2 = ต้องการเริ่มการทำงาน { -brand-short-name } ใหม่เพื่อล้างแคชการเริ่มการทำงานหรือไม่
startup-cache-dialog-body2 = การดำเนินการนี้จะไม่เปลี่ยนการตั้งค่าของคุณหรือเอาส่วนขยายของคุณออก
restart-button-label = เริ่มการทำงานใหม่

## Media titles

audio-backend = แบ็กเอนด์เสียง
max-audio-channels = จำนวนแชนเนลสูงสุด
sample-rate = อัตราการสุ่มตัวอย่างที่ต้องการ
roundtrip-latency = เวลาหน่วงในการเดินทางแบบเป็นรอบ (ค่าเบี่ยงเบนมาตรฐาน)
media-title = สื่อ
media-output-devices-title = อุปกรณ์ส่งออก
media-input-devices-title = อุปกรณ์รับข้อมูล
media-device-name = ชื่อ
media-device-group = กลุ่ม
media-device-vendor = ผู้จำหน่าย
media-device-state = สถานะ
media-device-preferred = ที่ต้องการ
media-device-format = รูปแบบ
media-device-channels = ช่อง
media-device-rate = อัตรา
media-device-latency = เวลาแฝง
media-capabilities-title = ความสามารถของสื่อ
# List all the entries of the database.
media-capabilities-enumerate = แจงนับฐานข้อมูล

##

intl-title = การทำให้เป็นสากลและการแปลเป็นภาษาท้องถิ่น
intl-app-title = การตั้งค่าแอปพลิเคชัน
intl-locales-requested = ภาษาที่ขอ
intl-locales-available = ภาษาที่มี
intl-locales-supported = ภาษาของแอป
intl-locales-default = ภาษาเริ่มต้น
intl-os-title = ระบบปฏิบัติการ
intl-os-prefs-system-locales = ภาษาของระบบ
intl-regional-prefs = ค่ากำหนดภูมิภาค

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = การดีบั๊กระยะไกล (โปรโตคอล Chromium)
remote-debugging-accepting-connections = การยอมรับการเชื่อมต่อ
remote-debugging-url = URL

##

support-third-party-modules-title = โมดูลบุคคลที่สาม
support-third-party-modules-module = ไฟล์โมดูล
support-third-party-modules-version = รุ่นไฟล์
support-third-party-modules-vendor = ข้อมูลผู้จำหน่าย
support-third-party-modules-occurrence = จำนวนเหตุการณ์
support-third-party-modules-process = ชนิดและ ID โปรเซส
support-third-party-modules-thread = เธรด
support-third-party-modules-base = ที่อยู่ Imagebase
support-third-party-modules-uptime = ระยะเวลาทำงานของกระบวนการ (ms)
support-third-party-modules-duration = ระยะเวลาในการโหลด (ms)
support-third-party-modules-status = สถานะ
support-third-party-modules-status-loaded = โหลดแล้ว
support-third-party-modules-status-blocked = ถูกปิดกั้น
support-third-party-modules-status-redirected = ถูกเปลี่ยนเส้นทาง
support-third-party-modules-empty = ไม่ได้โหลดโมดูลบุคคลที่สามใด
support-third-party-modules-no-value = (ไม่มีค่า)
support-third-party-modules-button-open =
    .title = เปิดตำแหน่งที่ตั้งไฟล์…
support-third-party-modules-expand =
    .title = แสดงข้อมูลโดยละเอียด
support-third-party-modules-collapse =
    .title = ยุบข้อมูลโดยละเอียด
support-third-party-modules-unsigned-icon =
    .title = โมดูลนี้ไม่มีการลงลายเซ็น
support-third-party-modules-folder-icon =
    .title = เปิดตำแหน่งที่ตั้งไฟล์…
support-third-party-modules-down-icon =
    .title = แสดงข้อมูลโดยละเอียด
support-third-party-modules-up-icon =
    .title = ยุบข้อมูลโดยละเอียด
# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days = รายงานข้อขัดข้องของ { $days } วันที่ผ่านมา
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes = { $minutes } นาทีที่แล้ว
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours = { $hours } ชั่วโมงที่แล้ว
# Variables
# $days (integer) - Number of days since crash
crashes-time-days = { $days } วันที่แล้ว
# Variables
# $reports (integer) - Number of pending reports
pending-reports = รายงานข้อขัดข้องทั้งหมด (รวม { $reports } ข้อขัดข้องที่ยังไม่ได้รายงานในช่วงเวลาที่กำหนด)
raw-data-copied = คัดลอกข้อมูลดิบไปยังคลิปบอร์ดแล้ว
text-copied = คัดลอกข้อความไปยังคลิปบอร์ดแล้ว

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = ถูกปิดกั้นจากรุ่นไดรเวอร์กราฟิกของคุณ
blocked-gfx-card = ถูกปิดกั้นจากการ์ดกราฟิกของคุณเนื่องจากปัญหาไดรเวอร์ที่ยังไม่ได้รับการแก้ไข
blocked-os-version = ถูกปิดกั้นจากรุ่นระบบปฏิบัติการของคุณ
blocked-mismatched-version = ถูกปิดกั้นจากรุ่นไดรเวอร์กราฟิกของคุณไม่ตรงกันระหว่าง registry และ DLL
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = ถูกปิดกั้นจากรุ่นไดรเวอร์กราฟิกของคุณ ลองปรับปรุงไดรเวอร์กราฟิกของคุณเป็นรุ่น { $driverVersion } หรือใหม่กว่า
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = พารามิเตอร์ ClearType
compositing = การจัดองค์ประกอบ
hardware-h264 = การถอดรหัสฮาร์ดแวร์ H264
main-thread-no-omtc = เธรดหลัก ไม่มี OMTC
yes = ใช่
no = ไม่
unknown = ไม่ทราบ
virtual-monitor-disp = จอแสดงผลเสมือนจริง

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = พบ
missing = หายไป
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = คำอธิบาย
gpu-vendor-id = ID ผู้จำหน่าย
gpu-device-id = ID อุปกรณ์
gpu-subsys-id = Subsys ID
gpu-drivers = ไดรเวอร์
gpu-ram = RAM
gpu-driver-vendor = ผู้จำหน่ายไดรเวอร์
gpu-driver-version = รุ่นไดรเวอร์
gpu-driver-date = วันที่ไดรเวอร์
gpu-active = ใช้งานอยู่
webgl1-wsiinfo = ข้อมูลไดรเวอร์ WebGL 1
webgl1-renderer = ตัวเรนเดอร์ไดรเวอร์ WebGL 1
webgl1-version = รุ่นไดรเวอร์ WebGL 1
webgl1-driver-extensions = ส่วนขยายไดรเวอร์ WebGL 1
webgl1-extensions = ส่วนขยาย WebGL 1
webgl2-wsiinfo = ข้อมูลไดรเวอร์ WebGL 2
webgl2-renderer = ตัวเรนเดอร์ไดรเวอร์ WebGL 2
webgl2-version = รุ่นไดรเวอร์ WebGL 2
webgl2-driver-extensions = ส่วนขยายไดรเวอร์ WebGL 2
webgl2-extensions = ส่วนขยาย WebGL 2
blocklisted-bug = ถูกเพิ่มในรายการปิดกั้นเนื่องจากปัญหาที่ทราบ
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = ข้อบกพร่อง { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = ถูกเพิ่มในรายการปิดกั้นเนื่องจากมีปัญหาที่ทราบสาเหตุ: <a data-l10n-name="bug-link">bug { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = ถูกเพิ่มในรายการปิดกั้นแล้ว; รหัสความล้มเหลว { $failureCode }
d3d11layers-crash-guard = คอมโพสิเตอร์ D3D11
d3d11video-crash-guard = ตัวถอดรหัสวิดีโอ D3D11
d3d9video-crash-guard = ตัวถอดรหัสวิดีโอ D3D9
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = ตัวถอดรหัสวิดีโอ WMF VPX
reset-on-next-restart = กลับค่าเดิมเมื่อเริ่มการทำงานใหม่ในครั้งถัดไป
gpu-process-kill-button = สิ้นสุดโปรเซส GPU
gpu-device-reset = การกลับค่าเดิมของอุปกรณ์
gpu-device-reset-button = ทริกเกอร์การกลับค่าเดิมของอุปกรณ์
uses-tiling = ใช้ Tiling
content-uses-tiling = ใช้ Tiling (เนื้อหา)
off-main-thread-paint-enabled = เปิดใช้งาน Off Main Thread Painting แล้ว
off-main-thread-paint-worker-count = จำนวนตัวทำงาน Off Main Thread Painting
target-frame-rate = อัตราเฟรมเป้าหมาย
min-lib-versions = รุ่นต่ำสุดที่ใช้ได้
loaded-lib-versions = รุ่นที่ใช้อยู่
has-seccomp-bpf = Seccomp-BPF (System Call Filtering)
has-seccomp-tsync = Seccomp Thread Synchronization
has-user-namespaces = เนมสเปซผู้ใช้
has-privileged-user-namespaces = เนมสเปซผู้ใช้สำหรับโปรเซสที่ได้รับสิทธิ์
can-sandbox-content = Content Process Sandboxing
can-sandbox-media = Media Plugin Sandboxing
content-sandbox-level = ระดับ Sandbox ของโปรเซสเนื้อหา
effective-content-sandbox-level = ระดับ Sandbox ของโปรเซสเนื้อหาที่มีประสิทธิภาพ
sandbox-proc-type-content = เนื้อหา
sandbox-proc-type-file = เนื้อหาไฟล์
sandbox-proc-type-media-plugin = ปลั๊กอินสื่อ
sandbox-proc-type-data-decoder = ตัวถอดรหัสข้อมูล
startup-cache-title = แคชเมื่อเริ่มการทำงาน
startup-cache-disk-cache-path = เส้นทางแคชดิสก์
startup-cache-ignore-disk-cache = ละเว้นแคชดิสก์
startup-cache-found-disk-cache-on-init = แคชดิสก์ที่พบเมื่อเตรียมใช้งาน
startup-cache-wrote-to-disk-cache = ที่เขียนลงในแคชดิสก์
launcher-process-status-0 = เปิดใช้งานอยู่
launcher-process-status-1 = ถูกปิดใช้งานเนื่องจากความล้มเหลว
launcher-process-status-2 = ถูกปิดใช้งานโดยการบังคับ
launcher-process-status-unknown = ไม่ทราบสถานะ
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = เปิดใช้งานอยู่โดยผู้ใช้
multi-process-status-1 = เปิดใช้งานอยู่โดยค่าเริ่มต้น
multi-process-status-2 = ปิดใช้งานอยู่
multi-process-status-4 = ถูกปิดใช้งานโดยเครื่องมือการช่วยการเข้าถึง
multi-process-status-6 = ถูกปิดใช้งานโดยการรับค่าข้อความที่ไม่รองรับ
multi-process-status-7 = ถูกปิดใช้งานโดยส่วนเสริม
multi-process-status-8 = ถูกปิดใช้งานโดยการบังคับ
multi-process-status-unknown = ไม่ทราบสถานะ
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = ถูกปิดใช้งานโดยการทดสอบ
fission-status-experiment-treatment = ถูกเปิดใช้งานโดยการทดสอบ
fission-status-disabled-by-e10s-env = ถูกปิดใช้งานโดยสภาพแวดล้อม
fission-status-enabled-by-env = ถูกเปิดใช้งานโดยสภาพแวดล้อม
fission-status-disabled-by-safe-mode = ถูกปิดใช้งานโดยโหมดปลอดภัย
fission-status-enabled-by-default = ถูกเปิดใช้งานตามค่าเริ่มต้น
fission-status-disabled-by-default = ถูกปิดใช้งานตามค่าเริ่มต้น
fission-status-enabled-by-user-pref = ถูกเปิดใช้งานโดยผู้ใช้
fission-status-disabled-by-user-pref = ถูกปิดใช้งานโดยผู้ใช้
fission-status-disabled-by-e10s-other = ปิดใช้งาน E10s แล้ว
async-pan-zoom = การเลื่อน/ซูมแบบอะซิงโครนัส
apz-none = ไม่มี
wheel-enabled = เปิดใช้งานการป้อนข้อมูลด้วยล้อแล้ว
touch-enabled = เปิดใช้งานการป้อนข้อมูลด้วยการสัมผัสแล้ว
drag-enabled = เปิดใช้งานการลากแถบเลื่อนแล้ว
keyboard-enabled = เปิดใช้งานแป้นพิมพ์แล้ว
autoscroll-enabled = เปิดใช้งานการเลื่อนอัตโนมัติแล้ว
zooming-enabled = เปิดใช้งานการซูมโดยการหุบ/กางนิ้วแบบราบรื่นแล้ว

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = การป้อนข้อมูลด้วยล้อแบบอะซิงโครนัสถูกปิดใช้งานเนื่องจากค่ากำหนดที่ไม่รองรับ: { $preferenceKey }
touch-warning = การป้อนข้อมูลด้วยการสัมผัสแบบอะซิงโครนัสถูกปิดใช้งานเนื่องจากค่ากำหนดที่ไม่รองรับ: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = ไม่มีการใช้งานอยู่
policies-active = ใช้งานอยู่
policies-error = ข้อผิดพลาด

## Printing section

support-printing-title = การพิมพ์
support-printing-troubleshoot = การแก้ไขปัญหา
support-printing-clear-settings-button = ล้างการตั้งค่าการพิมพ์ที่บันทึกไว้
support-printing-modified-settings = การตั้งค่าการพิมพ์ที่ถูกเปลี่ยนแปลง
support-printing-prefs-name = ชื่อ
support-printing-prefs-value = ค่า

## Normandy sections

support-remote-experiments-title = คุณลักษณะทดลองระยะไกล
support-remote-experiments-name = ชื่อ
support-remote-experiments-branch = สาขาการทดลอง
support-remote-experiments-see-about-studies = ดูที่ <a data-l10n-name="support-about-studies-link">about:studies</a> สำหรับข้อมูลเพิ่มเติม รวมถึงวิธีการปิดใช้งานคุณลักษณะทดลองแต่ละอย่าง หรือปิดใช้งานไม่ให้ { -brand-short-name } เรียกใช้คุณลักษณะทดสอบชนิดนี้อีกในอนาคต
support-remote-features-title = คุณลักษณะระยะไกล
support-remote-features-name = ชื่อ
support-remote-features-status = สถานะ
