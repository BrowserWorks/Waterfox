# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = ตัวจัดการกระบวนการ
# The Actions column
about-processes-column-action =
    .title = การกระทำ

## Tooltips

about-processes-shutdown-process =
    .title = เลิกโหลดแท็บและหยุดการทำงานของกระบวนการ
about-processes-shutdown-tab =
    .title = ปิดแท็บ

## Column headers

about-processes-column-name = ชื่อ
about-processes-column-memory-resident = หน่วยความจำ
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (กระบวนการ { $pid })
about-processes-web-process-name = เว็บ (กระบวนการ { $pid }, ใช้ร่วมกัน)
about-processes-web-isolated-process-name = เว็บ (กระบวนการ { $pid }) สำหรับ { $origin }
about-processes-web-large-allocation = เว็บ (กระบวนการ { $pid }, ขนาดใหญ่) สำหรับ { $origin }
about-processes-with-coop-coep-process-name = เว็บ (กระบวนการ { $pid }, แยกแบบข้ามที่มา) สำหรับ { $origin }
about-processes-file-process-name = ไฟล์ (กระบวนการ { $pid })
about-processes-extension-process-name = ส่วนขยาย (กระบวนการ { $pid })
about-processes-privilegedabout-process-name = เกี่ยวกับ (กระบวนการ { $pid })
about-processes-plugin-process-name = ปลั๊กอิน (กระบวนการ { $pid })
about-processes-privilegedmozilla-process-name = เว็บ (กระบวนการ { $pid }) สำหรับไซต์ { -vendor-short-name }
about-processes-gmp-plugin-process-name = ปลั๊กอินสื่อของ Gecko (กระบวนการ { $pid })
about-processes-gpu-process-name = GPU (กระบวนการ { $pid })
about-processes-vr-process-name = VR (กระบวนการ { $pid })
about-processes-rdd-process-name = ตัวถอดรหัสข้อมูล (กระบวนการ { $pid })
about-processes-socket-process-name = เครือข่าย (กระบวนการ { $pid })
about-processes-remote-sandbox-broker-process-name = ตัวกลาง Sandbox ระยะไกล (กระบวนการ { $pid })
about-processes-fork-server-process-name = เซิร์ฟเวอร์ Fork (กระบวนการ { $pid })
about-processes-preallocated-process-name = จัดสรรล่วงหน้า (กระบวนการ { $pid })
about-processes-unknown-process-name = อื่นๆ ({ $type }, กระบวนการ { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = กระบวนการ { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name }{ $pid }
about-processes-web-process = กระบวนการเว็บที่ใช้ร่วมกัน ({ $pid })
about-processes-file-process = ไฟล์ ({ $pid })
about-processes-extension-process = ส่วนขยาย ({ $pid })
about-processes-privilegedabout-process = หน้าเกี่ยวกับ ({ $pid })
about-processes-plugin-process = ปลั๊กอิน ({ $pid })
about-processes-privilegedmozilla-process = ไซต์ { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = ปลั๊กอินสื่อของ Gecko ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = ตัวถอดรหัสข้อมูล ({ $pid })
about-processes-socket-process = เครือข่าย ({ $pid })
about-processes-remote-sandbox-broker-process = ตัวกลาง Sandbox ระยะไกล ({ $pid })
about-processes-fork-server-process = ฟอร์คเซิร์ฟเวอร์ ({ $pid })
about-processes-preallocated-process = จัดสรรล่วงหน้า ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = อื่น ๆ : { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, ขนาดใหญ่)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, ถูกแยก cross-origin)
about-processes-web-isolated-process-private = { $origin } — ส่วนตัว ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — ส่วนตัว ({ $pid }, ขนาดใหญ่)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = เธรด ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = เธรด { $tid }: { $name }
# Single-line summary of threads (non-idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#    $active (Number) The number of active threads in the process.
#                     The value will be greater than 0 and will never be
#                     greater than $number.
#    $list (String) Comma separated list of active threads.
#                   Can be an empty string if the process is idle.
about-processes-active-threads =
    { $active ->
       *[other] { $active } เธรดที่ใช้งานอยู่จาก { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
       *[other] { $number } เธรดที่ไม่ได้ใช้งาน
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = เธรด id: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = แท็บ: { $name }
about-processes-preloaded-tab = แท็บใหม่ที่โหลดไว้ล่วงหน้า
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = เฟรมย่อย: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = เฟรมย่อย ({ $number }): { $shortUrl }

## Displaying CPU (percentage and total)
## Variables:
##    $percent (Number) The percentage of CPU used by the process or thread.
##                      Always > 0, generally <= 200.
##    $total (Number) The amount of time used by the process or thread since
##                    its start.
##    $unit (String) The unit in which to display $total. See the definitions
##                   of `duration-unit-*`.

# Common case.
about-processes-cpu-user-and-kernel = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") } ({ NUMBER($total, maximumFractionDigits: 0) }{ $unit })
# Common case.
about-processes-cpu = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") }
    .title = เวลาของ CPU ทั้งหมด: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (กำลังวัด)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = ไม่ได้ใช้งาน ({ NUMBER($total, maximumFractionDigits: 2) }{ $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = ไม่ได้ใช้งาน
    .title = เวลาที่ใช้งาน CPU ทั้งหมด: { NUMBER($total, maximumFractionDigits: 2) } { $unit }

## Displaying Memory (total and delta)
## Variables:
##    $total (Number) The amount of memory currently used by the process.
##    $totalUnit (String) The unit in which to display $total. See the definitions
##                        of `memory-unit-*`.
##    $delta (Number) The absolute value of the amount of memory added recently.
##    $deltaSign (String) Either "+" if the amount of memory has increased
##                        or "-" if it has decreased.
##    $deltaUnit (String) The unit in which to display $delta. See the definitions
##                        of `memory-unit-*`.

# Common case.
about-processes-total-memory-size = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit } ({ $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) }{ $deltaUnit })
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = วินาที
duration-unit-m = นาที
duration-unit-h = ชม.
duration-unit-d = วัน

## Memory units

memory-unit-B = B
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
