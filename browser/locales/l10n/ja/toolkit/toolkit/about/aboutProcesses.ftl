# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = プロセスマネージャー

# The Actions column
about-processes-column-action =
    .title = 操作

## Tooltips

about-processes-shutdown-process =
    .title = タブを閉じプロセスを終了する
about-processes-shutdown-tab =
    .title = タブを閉じる

## Column headers

about-processes-column-name = プロセス名
about-processes-column-memory-resident = メモリー
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (プロセス { $pid })
about-processes-web-process-name = ウェブ (プロセス { $pid }、共有)
about-processes-web-isolated-process-name = { $origin } のウェブ (プロセス { $pid })
about-processes-web-large-allocation = { $origin } のウェブ (プロセス { $pid }、大きい)
about-processes-with-coop-coep-process-name = { $origin } のウェブ (プロセス { $pid }、クロスオリジン隔離)
about-processes-file-process-name = ファイル (プロセス { $pid })
about-processes-extension-process-name = 拡張機能 (プロセス { $pid })
about-processes-privilegedabout-process-name = About (プロセス { $pid })
about-processes-plugin-process-name = プラグイン (プロセス { $pid })
about-processes-privilegedmozilla-process-name = { -vendor-short-name } サイトのウェブ (プロセス { $pid })
about-processes-gmp-plugin-process-name = Gecko メディアプラグイン (プロセス { $pid })
about-processes-gpu-process-name = GPU (プロセス { $pid })
about-processes-vr-process-name = VR (プロセス { $pid })
about-processes-rdd-process-name = データデコーダー (プロセス { $pid })
about-processes-socket-process-name = ネットワーク (プロセス { $pid })
about-processes-remote-sandbox-broker-process-name = リモートサンドボックスブローカー (プロセス { $pid })
about-processes-fork-server-process-name = フォークサーバー (プロセス { $pid })
about-processes-preallocated-process-name = 事前割り当て (プロセス { $pid })
about-processes-unknown-process-name = その他 ({ $type }、プロセス { $pid })


# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = プロセス { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = 共有ウェブプロセス ({ $pid })
about-processes-file-process = ファイル ({ $pid })
about-processes-extension-process = 拡張機能 ({ $pid })
about-processes-privilegedabout-process = About ページ ({ $pid })
about-processes-plugin-process = プラグイン ({ $pid })
about-processes-privilegedmozilla-process = { -vendor-short-name } サイト ({ $pid })
about-processes-gmp-plugin-process = Gecko メディアプラグイン ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = データデコーダー ({ $pid })
about-processes-socket-process = ネットワーク ({ $pid })
about-processes-remote-sandbox-broker-process = リモートサンドボックスブローカー ({ $pid })
about-processes-fork-server-process = フォークサーバー ({ $pid })
about-processes-preallocated-process = 事前割り当て ({ $pid })

# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = その他: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, 大きい)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, クロスオリジン隔離)
about-processes-web-isolated-process-private = { $origin } — プライベート ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — プライベート ({ $pid }, 大きい)
about-processes-with-coop-coep-process-private = { $origin } — プライベート ({ $pid }, クロスオリジン隔離)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = スレッド ({ $number })

# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = スレッド { $tid }: { $name }

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
about-processes-active-threads = { $active ->
     [one] 実行中のスレッド数 { $active } / { $number }: { $list }
    *[other] 実行中のスレッド数 { $active } / { $number }: { $list }
}

# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads = { $number ->
     [one] 待機中のスレッド数 { $number }
    *[other] 待機中のスレッド数 { $number }
}

# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = スレッド ID: { $tid }

# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = タブ: { $name }
about-processes-preloaded-tab = 事前に読み込まれた新しいタブ

# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = サブフレーム: { $url }

# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = サブフレーム ({ $number }): { $shortUrl }

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
    .title = 合計 CPU 時間: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }

# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (計測中)

# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = 待機 ({ NUMBER($total, maximumFractionDigits: 2) }{ $unit })

# Special case: process or thread is currently idle.
about-processes-cpu-idle = 待機
    .title = 合計 CPU 時間: { NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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
about-processes-total-memory-size = { NUMBER($total, maximumFractionDigits:0) }{ $totalUnit } ({ $deltaSign }{ NUMBER($delta, maximumFractionDigits:0) }{ $deltaUnit })

# Common case.
about-processes-total-memory-size-changed = { NUMBER($total, maximumFractionDigits:0) }{ $totalUnit }
   .title = 増減: { $deltaSign }{ NUMBER($delta, maximumFractionDigits:0) }{ $deltaUnit }

# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits:0) }{ $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = 秒
duration-unit-m = 分
duration-unit-h = 時間
duration-unit-d = 日

## Memory units

memory-unit-B = B
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
