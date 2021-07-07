# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Менеджер процессов
# The Actions column
about-processes-column-action =
    .title = Действия

## Tooltips

about-processes-shutdown-process =
    .title = Выгрузить вкладки и убить процесс
about-processes-shutdown-tab =
    .title = Закрыть вкладку

## Column headers

about-processes-column-name = Имя
about-processes-column-memory-resident = Память
about-processes-column-cpu-total = ЦП

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (процесс { $pid })
about-processes-web-process-name = Веб (процесс { $pid }, общий)
about-processes-web-isolated-process-name = Веб (процесс { $pid }) для { $origin }
about-processes-web-large-allocation = Веб (процесс { $pid }, большой) для { $origin }
about-processes-with-coop-coep-process-name = Веб (процесс { $pid }, изолирован от посторонних источников) для { $origin }
about-processes-file-process-name = Файлы (процесс { $pid })
about-processes-extension-process-name = Расширения (процесс { $pid })
about-processes-privilegedabout-process-name = Страницы About (процесс { $pid })
about-processes-plugin-process-name = Плагины (процесс { $pid })
about-processes-privilegedmozilla-process-name = Веб (процесс { $pid }) для сайтов { -vendor-short-name }
about-processes-gmp-plugin-process-name = Медиаплагины Gecko (процесс { $pid })
about-processes-gpu-process-name = Графический процессор (процесс { $pid })
about-processes-vr-process-name = VR (процесс { $pid })
about-processes-rdd-process-name = Декодер данных (процесс { $pid })
about-processes-socket-process-name = Сеть (процесс { $pid })
about-processes-remote-sandbox-broker-process-name = Удаленный брокер песочницы (процесс { $pid })
about-processes-fork-server-process-name = Форк-сервер (процесс { $pid })
about-processes-preallocated-process-name = Предварительно выделено (процесс { $pid })
about-processes-unknown-process-name = Другое ({ $type }, процесс { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Процесс { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Общий веб-процесс ({ $pid })
about-processes-file-process = Файлы ({ $pid })
about-processes-extension-process = Расширения ({ $pid })
about-processes-privilegedabout-process = Страницы About ({ $pid })
about-processes-plugin-process = Плагины ({ $pid })
about-processes-privilegedmozilla-process = Сайты { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = Медиаплагины Gecko ({ $pid })
about-processes-gpu-process = Графический процессор ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = Декодер данных ({ $pid })
about-processes-socket-process = Сеть ({ $pid })
about-processes-remote-sandbox-broker-process = Удалённый брокер песочницы ({ $pid })
about-processes-fork-server-process = Форк-сервер ({ $pid })
about-processes-preallocated-process = Предварительно выделено ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Другое: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, большой)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, изолирован от посторонних источников)
about-processes-web-isolated-process-private = { $origin } — Приватный ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — Приватный ({ $pid }, большой)
about-processes-with-coop-coep-process-private = { $origin } — Приватный ({ $pid }, изолирован от посторонних источников)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = Потоки ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = Поток { $tid }: { $name }
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
        [one] { $active } активный поток из { $number }: { $list }
        [few] { $active } активных потока из { $number }: { $list }
       *[many] { $active } активных потоков из { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
        [one] { $number } неактивный поток
        [few] { $number } неактивных потока
       *[many] { $number } неактивных потоков
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = id потока: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Вкладка: { $name }
about-processes-preloaded-tab = Предзагруженная новая вкладка
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Подфрейм: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Подфреймы ({ $number }): { $shortUrl }

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
    .title = Всего процессорного времени: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (измерение)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = неактивен ({ NUMBER($total, maximumFractionDigits: 2) }{ $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = неактивен
    .title = Всего процессорного времени: { NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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
# Common case.
about-processes-total-memory-size-changed = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }
    .title = Выделено: { $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) }{ $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }

## Duration units

duration-unit-ns = нс
duration-unit-us = мкс
duration-unit-ms = мс
duration-unit-s = с
duration-unit-m = мин
duration-unit-h = ч
duration-unit-d = д

## Memory units

memory-unit-B = Б
memory-unit-KB = КБ
memory-unit-MB = МБ
memory-unit-GB = ГБ
memory-unit-TB = ТБ
memory-unit-PB = ПБ
memory-unit-EB = ЭБ
