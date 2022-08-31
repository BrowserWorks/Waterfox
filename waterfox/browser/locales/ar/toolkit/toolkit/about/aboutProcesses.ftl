# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = مدير العمليات

# The Actions column
about-processes-column-action =
    .title = الإجراءات

## Tooltips

about-processes-shutdown-process =
    .title = ألغِ تحميل الألسنة واقتل العملية
about-processes-shutdown-tab =
    .title = أغلِق اللسان

## Column headers

about-processes-column-name = الاسم
about-processes-column-memory-resident = الذاكرة
about-processes-column-cpu-total = المعالج

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

## Details within processes


## Displaying CPU (percentage and total)
## Variables:
##    $percent (Number) The percentage of CPU used by the process or thread.
##                      Always > 0, generally <= 200.
##    $total (Number) The amount of time used by the process or thread since
##                    its start.
##    $unit (String) The unit in which to display $total. See the definitions
##                   of `duration-unit-*`.

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


## Duration units

duration-unit-s = ثا
duration-unit-m = دق
duration-unit-h = سا
duration-unit-d = يوم

## Memory units

memory-unit-B = بايت
memory-unit-KB = ك.بايت
memory-unit-MB = م.بايت
memory-unit-GB = ج.بايت
memory-unit-TB = ت.بايت
