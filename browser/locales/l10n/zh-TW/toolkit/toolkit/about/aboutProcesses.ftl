# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = 處理程序管理員
# The Actions column
about-processes-column-action =
    .title = 動作

## Tooltips

about-processes-shutdown-process =
    .title = 解除載入分頁並結束處理程序
about-processes-shutdown-tab =
    .title = 關閉分頁

## Column headers

about-processes-column-name = 名稱
about-processes-column-memory-resident = 記憶體
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name }（程序 { $pid }）
about-processes-web-process-name = 網頁（程序 { $pid }，共用）
about-processes-web-isolated-process-name = 網頁（程序 { $pid }）針對 { $origin }
about-processes-web-large-allocation = 網頁（程序 { $pid }，大型）針對 { $origin }
about-processes-with-coop-coep-process-name = 網頁（程序 { $pid }，隔離跨來源）針對 { $origin }
about-processes-file-process-name = 檔案（程序 { $pid }）
about-processes-extension-process-name = 擴充套件（程序 { $pid }）
about-processes-privilegedabout-process-name = 關於（程序 { $pid }）
about-processes-plugin-process-name = 外掛程式（程序 { $pid }）
about-processes-privilegedmozilla-process-name = 網頁（程序 { $pid }）針對 { -vendor-short-name } 網站
about-processes-gmp-plugin-process-name = Gecko 媒體外掛程式（程序 { $pid }）
about-processes-gpu-process-name = GPU（程序 { $pid }）
about-processes-vr-process-name = VR（程序 { $pid }）
about-processes-rdd-process-name = 資料解碼器（程序 { $pid }）
about-processes-socket-process-name = 網路（程序 { $pid }）
about-processes-remote-sandbox-broker-process-name = 遠端沙盒溝通工具（程序 { $pid }）
about-processes-fork-server-process-name = Fork 伺服器（程序 { $pid }）
about-processes-preallocated-process-name = 預先分配（程序 { $pid }）
about-processes-unknown-process-name = 其他（{ $type }，程序 { $pid }）
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = 處理程序 { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name }（{ $pid }）
about-processes-web-process = 共享的網頁處理程序（{ $pid }）
about-processes-file-process = 檔案（{ $pid }）
about-processes-extension-process = 擴充套件（{ $pid }）
about-processes-privilegedabout-process = about: 頁面（{ $pid }）
about-processes-plugin-process = 外掛程式（{ $pid }）
about-processes-privilegedmozilla-process = { -vendor-short-name } 網站（{ $pid }）
about-processes-gmp-plugin-process = Gecko 媒體外掛程式（{ $pid }）
about-processes-gpu-process = GPU（{ $pid }）
about-processes-vr-process = VR（{ $pid }）
about-processes-rdd-process = 資料解碼器（{ $pid }）
about-processes-socket-process = 網路（{ $pid }）
about-processes-remote-sandbox-broker-process = 遠端沙盒溝通工具（{ $pid }）
about-processes-fork-server-process = Fork 伺服器（{ $pid }）
about-processes-preallocated-process = 預先分配（{ $pid }）
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = 其他: { $type }（{ $pid }）

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin }（{ $pid }）
about-processes-web-large-allocation-process = { $origin }（{ $pid }，大型）
about-processes-with-coop-coep-process = { $origin }（{ $pid }，隔離跨來源）
about-processes-web-isolated-process-private = { $origin } — 隱私（{ $pid }）
about-processes-web-large-allocation-process-private = { $origin } — 隱私（{ $pid }，大型）
about-processes-with-coop-coep-process-private = { $origin } — 隱私（{ $pid }，隔離跨來源）

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = 執行緒（{ $number }）
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = 執行緒 { $tid }: { $name }
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
       *[other] { $active } 個忙碌的執行緒，共 { $number } 個: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
       *[other] { $number } 個閒置的執行緒
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = 執行緒 ID: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = 分頁: { $name }
about-processes-preloaded-tab = 預先載入的新分頁
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = 子畫框: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = 子畫框（{ $number }）: { $shortUrl }

## Displaying CPU (percentage and total)
## Variables:
##    $percent (Number) The percentage of CPU used by the process or thread.
##                      Always > 0, generally <= 200.
##    $total (Number) The amount of time used by the process or thread since
##                    its start.
##    $unit (String) The unit in which to display $total. See the definitions
##                   of `duration-unit-*`.

# Common case.
about-processes-cpu-user-and-kernel = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") }（{ NUMBER($total, maximumFractionDigits: 0) }{ $unit }）
# Common case.
about-processes-cpu = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") }
    .title = 總 CPU 時間: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = （測量中）
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = 閒置（{ NUMBER($total, maximumFractionDigits: 2) }{ $unit }）
# Special case: process or thread is currently idle.
about-processes-cpu-idle = 閒置
    .title = 總 CPU 時間: { NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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
about-processes-total-memory-size = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }（{ $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) }{ $deltaUnit }）
# Common case.
about-processes-total-memory-size-changed = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }
    .title = 變化: { $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) }{ $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = 秒
duration-unit-m = 分
duration-unit-h = 時
duration-unit-d = 天

## Memory units

memory-unit-B = B
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
