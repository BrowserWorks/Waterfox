# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = 进程管理器
# The Actions column
about-processes-column-action =
    .title = 操作

## Tooltips

about-processes-shutdown-process =
    .title = 卸载标签页并结束进程
about-processes-shutdown-tab =
    .title = 关闭标签页
# Profiler icons
# Variables:
#    $duration (Number) The time in seconds during which the profiler will be running.
#                       The value will be an integer, typically less than 10.
about-processes-profile-process =
    .title =
        { $duration ->
           *[other] 分析此进程的所有线程 { $duration } 秒
        }

## Column headers

about-processes-column-name = 名称
about-processes-column-memory-resident = 内存
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name }（{ $pid }）
about-processes-web-process = 共享的 Web 进程（{ $pid }）
about-processes-file-process = 文件（{ $pid }）
about-processes-extension-process = 扩展（{ $pid }）
about-processes-privilegedabout-process = About 页面（{ $pid }）
about-processes-plugin-process = 插件（{ $pid }）
about-processes-privilegedmozilla-process = { -vendor-short-name } 网站（{ $pid }）
about-processes-gmp-plugin-process = Gecko 媒体插件（{ $pid }）
about-processes-gpu-process = GPU（{ $pid }）
about-processes-vr-process = VR（{ $pid }）
about-processes-rdd-process = 数据解码器（{ $pid }）
about-processes-socket-process = 网络（{ $pid }）
about-processes-remote-sandbox-broker-process = 远程沙箱中介（{ $pid }）
about-processes-fork-server-process = Fork 服务器（{ $pid }）
about-processes-preallocated-process = 预分配（{ $pid }）
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = 其他：{ $type }（{ $pid }）

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin }（{ $pid }）
about-processes-web-large-allocation-process = { $origin }（{ $pid }，大型）
about-processes-with-coop-coep-process = { $origin }（{ $pid }，隔离跨源）
about-processes-web-isolated-process-private = { $origin } — 私有（{ $pid }）
about-processes-web-large-allocation-process-private = { $origin } — 私有（{ $pid }，大型）
about-processes-with-coop-coep-process-private = { $origin } — 私有（{ $pid }，隔离跨源）

## Details within processes

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
       *[other] { $active } 个活动线程，共 { $number } 个：{ $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
       *[other] { $number } 个空闲线程
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = 线程 ID：{ $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = 标签页：{ $name }
about-processes-preloaded-tab = 预加载的新标签页
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = 子帧：{ $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = 子帧（{ $number }）：{ $shortUrl }

## Displaying CPU (percentage and total)
## Variables:
##    $percent (Number) The percentage of CPU used by the process or thread.
##                      Always > 0, generally <= 200.
##    $total (Number) The amount of time used by the process or thread since
##                    its start.
##    $unit (String) The unit in which to display $total. See the definitions
##                   of `duration-unit-*`.

# Common case.
about-processes-cpu = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") }
    .title = 总 CPU 时间：{ NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = （测量中）
# Special case: process or thread is currently idle.
about-processes-cpu-idle = 空闲
    .title = 总 CPU 时间：{ NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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
about-processes-total-memory-size-changed = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }
    .title = 变化：{ $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) }{ $deltaUnit }
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

memory-unit-B =  字节
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
