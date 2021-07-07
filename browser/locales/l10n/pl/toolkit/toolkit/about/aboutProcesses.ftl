# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Menedżer procesów
# The Actions column
about-processes-column-action =
    .title = Działania

## Tooltips

about-processes-shutdown-process =
    .title = Usuń karty z pamięci i zakończ proces
about-processes-shutdown-tab =
    .title = Zamknij kartę

## Column headers

about-processes-column-name = Nazwa
about-processes-column-memory-resident = Pamięć
about-processes-column-cpu-total = Procesor

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (proces { $pid })
about-processes-web-process-name = Strony (proces { $pid }, współdzielony)
about-processes-web-isolated-process-name = Strony (proces { $pid }) dla „{ $origin }”
about-processes-web-large-allocation = Strony (proces { $pid }, duży) dla „{ $origin }”
about-processes-with-coop-coep-process-name = Strony (proces { $pid }, wydzielone innego pochodzenia) dla „{ $origin }”
about-processes-file-process-name = Pliki (proces { $pid })
about-processes-extension-process-name = Rozszerzenia (proces { $pid })
about-processes-privilegedabout-process-name = Strony about: (proces { $pid })
about-processes-plugin-process-name = Wtyczki (proces { $pid })
about-processes-privilegedmozilla-process-name = Strony (proces { $pid }) dla witryn organizacji { -vendor-short-name }
about-processes-gmp-plugin-process-name = Wtyczki multimedialne Gecko (proces { $pid })
about-processes-gpu-process-name = Procesor graficzny (proces { $pid })
about-processes-vr-process-name = Rzeczywistość wirtualna (proces { $pid })
about-processes-rdd-process-name = Dekoder danych (proces { $pid })
about-processes-socket-process-name = Sieć (proces { $pid })
about-processes-remote-sandbox-broker-process-name = Broker zdalnej piaskownicy (proces { $pid })
about-processes-fork-server-process-name = Serwer rozdzielania (proces { $pid })
about-processes-preallocated-process-name = Wstępnie przydzielony (proces { $pid })
about-processes-unknown-process-name = Inny ({ $type }, proces { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Proces { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Współdzielony proces stron ({ $pid })
about-processes-file-process = Pliki ({ $pid })
about-processes-extension-process = Rozszerzenia ({ $pid })
about-processes-privilegedabout-process = Strony about: ({ $pid })
about-processes-plugin-process = Wtyczki ({ $pid })
about-processes-privilegedmozilla-process = Witryny organizacji { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = Wtyczki multimedialne Gecko ({ $pid })
about-processes-gpu-process = Procesor graficzny ({ $pid })
about-processes-vr-process = Rzeczywistość wirtualna ({ $pid })
about-processes-rdd-process = Dekoder danych ({ $pid })
about-processes-socket-process = Sieć ({ $pid })
about-processes-remote-sandbox-broker-process = Broker zdalnej piaskownicy ({ $pid })
about-processes-fork-server-process = Serwer rozdzielania ({ $pid })
about-processes-preallocated-process = Wstępnie przydzielony ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Inny: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, duży)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, wydzielony innego pochodzenia)
about-processes-web-isolated-process-private = { $origin } — prywatny ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — prywatny ({ $pid }, duży)
about-processes-with-coop-coep-process-private = { $origin } — prywatny ({ $pid }, wydzielony innego pochodzenia)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = Wątki ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = Wątek { $tid }: { $name }
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
        [one] { $active } aktywny wątek z { $number }: { $list }
        [few] { $active } aktywne wątki z { $number }: { $list }
       *[many] { $active } aktywnych wątków z { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
        [one] { $number } nieaktywny wątek
        [few] { $number } nieaktywne wątki
       *[many] { $number } nieaktywnych wątków
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = Identyfikator wątku: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Karta: { $name }
about-processes-preloaded-tab = Wstępnie wczytana nowa karta
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Ramka podrzędna: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Ramki podrzędne ({ $number }): { $shortUrl }

## Displaying CPU (percentage and total)
## Variables:
##    $percent (Number) The percentage of CPU used by the process or thread.
##                      Always > 0, generally <= 200.
##    $total (Number) The amount of time used by the process or thread since
##                    its start.
##    $unit (String) The unit in which to display $total. See the definitions
##                   of `duration-unit-*`.

# Common case.
about-processes-cpu-user-and-kernel = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") } ({ NUMBER($total, maximumFractionDigits: 0) } { $unit })
# Common case.
about-processes-cpu = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") }
    .title = Całkowity czas procesora: { NUMBER($total, maximumFractionDigits: 0) } { $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (trwa mierzenie)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = bezczynny ({ NUMBER($total, maximumFractionDigits: 2) } { $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = bezczynny
    .title = Całkowity czas procesora: { NUMBER($total, maximumFractionDigits: 2) } { $unit }

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
about-processes-total-memory-size = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit } ({ $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) } { $deltaUnit })
# Common case.
about-processes-total-memory-size-changed = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit }
    .title = Zmiana w czasie: { $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) } { $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = s
duration-unit-m = min
duration-unit-h = godz.
duration-unit-d = d

## Memory units

memory-unit-B = B
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
