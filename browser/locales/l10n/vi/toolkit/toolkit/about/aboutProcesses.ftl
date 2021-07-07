# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Quản lý tiến trình
# The Actions column
about-processes-column-action =
    .title = Hành động

## Tooltips

about-processes-shutdown-process =
    .title = Đóng các thẻ và buộc dừng tiến trình
about-processes-shutdown-tab =
    .title = Đóng thẻ

## Column headers

about-processes-column-name = Tên
about-processes-column-memory-resident = Bộ nhớ
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (tiến trình { $pid })
about-processes-web-process-name = Web (tiến trình { $pid }, được chia sẻ)
about-processes-web-isolated-process-name = Web (tiến trình { $pid }) cho { $origin }
about-processes-web-large-allocation = Web (tiến trình { $pid }, lớn) cho { $origin }
about-processes-with-coop-coep-process-name = Web (tiến trình { $pid }, nhiều trang web riêng biệt) cho { $origin }
about-processes-file-process-name = Tập tin (tiến trình { $pid })
about-processes-extension-process-name = Tiện ích mở rộng (tiến trình { $pid })
about-processes-privilegedabout-process-name = About (tiến trình { $pid })
about-processes-plugin-process-name = Phần bổ trợ (tiến trình { $pid })
about-processes-privilegedmozilla-process-name = Web (tiến trình { $pid }) cho các trang web { -vendor-short-name }
about-processes-gmp-plugin-process-name = Gecko Media Plugins (tiến trình { $pid })
about-processes-gpu-process-name = GPU (tiến trình { $pid })
about-processes-vr-process-name = VR (tiến trình { $pid })
about-processes-rdd-process-name = Bộ giải mã dữ liệu (tiến trình { $pid })
about-processes-socket-process-name = Mạng (tiến trình { $pid })
about-processes-remote-sandbox-broker-process-name = Remote Sandbox Broker (tiến trình { $pid })
about-processes-fork-server-process-name = Máy chủ Fork (tiến trình { $pid })
about-processes-preallocated-process-name = Đã phân bổ trước (tiến trình { $pid })
about-processes-unknown-process-name = Khác ({ $type }, tiến trình { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Tiến trình { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Tiến trình web được chia sẻ ({ $pid })
about-processes-file-process = Tập tin ({ $pid })
about-processes-extension-process = Tiện ích mở rộng ({ $pid })
about-processes-privilegedabout-process = Trang about ({ $pid })
about-processes-plugin-process = Phần bổ trợ ({ $pid })
about-processes-privilegedmozilla-process = Trang web { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = Phần bổ trợ phương tiện Gecko ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = Bộ giải mã dữ liệu ({ $pid })
about-processes-socket-process = Mạng ({ $pid })
about-processes-fork-server-process = Máy chủ Fork ({ $pid })
about-processes-preallocated-process = Được tải trước ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Khác: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-isolated-process-private = { $origin } — Riêng tư ({ $pid })

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = Luồng ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = Luồng { $tid }: { $name }
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
       *[other] { $active } luồng hoạt động trong số { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
       *[other] { $number } luồng không hoạt động
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = ID luồng: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Thẻ: { $name }
about-processes-preloaded-tab = Thẻ mới được tải trước
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Khung phụ: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Khung phụ ({ $number }): { $shortUrl }

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
    .title = Tổng thời gian CPU: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (đang đo)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = rảnh ({ NUMBER($total, maximumFractionDigits: 2) }{ $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = Rảnh
    .title = Tổng thời gian CPU: { NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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
duration-unit-s = s
duration-unit-m = m
duration-unit-h = h
duration-unit-d = d

## Memory units

memory-unit-B = B
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
