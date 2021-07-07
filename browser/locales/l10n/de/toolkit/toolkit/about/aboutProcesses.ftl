# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Prozessverwaltung
# The Actions column
about-processes-column-action =
    .title = Aktionen

## Tooltips

about-processes-shutdown-process =
    .title = Tabs entladen und Prozess beenden
about-processes-shutdown-tab =
    .title = Tab schließen

## Column headers

about-processes-column-name = Name
about-processes-column-memory-resident = Speicher
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (Prozess { $pid })
about-processes-web-process-name = Web (Prozess { $pid }, geteilt)
about-processes-web-isolated-process-name = Web (Prozess { $pid }) für { $origin }
about-processes-web-large-allocation = Web (Prozess { $pid }, groß) für { $origin }
about-processes-with-coop-coep-process-name = Web (Prozess { $pid }, quellübergreifend isoliert) für { $origin }
about-processes-file-process-name = Dateien (Prozess { $pid })
about-processes-extension-process-name = Erweiterungen (Prozess { $pid })
about-processes-privilegedabout-process-name = Über (Prozess { $pid })
about-processes-plugin-process-name = Plugins (Prozess { $pid })
about-processes-privilegedmozilla-process-name = Web (Prozess { $pid }) für { -vendor-short-name }-Websites
about-processes-gmp-plugin-process-name = Gecko-Medien-Plugins (Prozess { $pid })
about-processes-gpu-process-name = GPU (Prozess { $pid })
about-processes-vr-process-name = VR (Prozess { $pid })
about-processes-rdd-process-name = Datendekoder (Prozess { $pid })
about-processes-socket-process-name = Netzwerk (Prozess { $pid })
about-processes-remote-sandbox-broker-process-name = Externer Sandbox-Broker (Prozess { $pid })
about-processes-fork-server-process-name = Fork-Server (Prozess { $pid })
about-processes-preallocated-process-name = Voralloziert (Prozess { $pid })
about-processes-unknown-process-name = Andere ({ $type }, Prozess { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Prozess { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Geteilter Web-Prozess ({ $pid })
about-processes-file-process = Dateien ({ $pid })
about-processes-extension-process = Erweiterungen ({ $pid })
about-processes-privilegedabout-process = "about:"-Seiten ({ $pid })
about-processes-plugin-process = Plugins ({ $pid })
about-processes-privilegedmozilla-process = { -vendor-short-name }-Websites ({ $pid })
about-processes-gmp-plugin-process = Gecko-Medien-Plugins ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = Datendekoder ({ $pid })
about-processes-socket-process = Netzwerk ({ $pid })
about-processes-remote-sandbox-broker-process = Externer Sandbox-Broker ({ $pid })
about-processes-fork-server-process = Fork-Server ({ $pid })
about-processes-preallocated-process = Voralloziert ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Andere: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, groß)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, quellübergreifend isoliert)
about-processes-web-isolated-process-private = { $origin } – Privat ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } – Privat ({ $pid }, groß)
about-processes-with-coop-coep-process-private = { $origin } – Privat ({ $pid }, quellübergreifend isoliert)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = Threads ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = Thread { $tid }: { $name }
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
        [one] { $active } aktiver Thread von { $number }: { $list }
       *[other] { $active } aktive Threads von { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
        [one] { $number } inaktiver Thread
       *[other] { $number } inaktive Threads
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = Thread-ID: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Tab: { $name }
about-processes-preloaded-tab = Vorgeladener neuer Tab
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Subframe: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Subframes ({ $number }): { $shortUrl }

## Displaying CPU (percentage and total)
## Variables:
##    $percent (Number) The percentage of CPU used by the process or thread.
##                      Always > 0, generally <= 200.
##    $total (Number) The amount of time used by the process or thread since
##                    its start.
##    $unit (String) The unit in which to display $total. See the definitions
##                   of `duration-unit-*`.

# Common case.
about-processes-cpu-user-and-kernel = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") } ({ NUMBER($total, maximumFractionDigits: 0) } { $unit })
# Common case.
about-processes-cpu = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") }
    .title = Gesamte CPU-Zeit: { NUMBER($total, maximumFractionDigits: 0) } { $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (wird gemessen)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = untätig ({ NUMBER($total, maximumFractionDigits: 2) } { $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = untätig
    .title = Gesamte CPU-Zeit: { NUMBER($total, maximumFractionDigits: 2) } { $unit }

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
about-processes-total-memory-size = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit } ({ $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) } { $deltaUnit })
# Common case.
about-processes-total-memory-size-changed = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit }
    .title = Änderung: { $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) } { $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = s
duration-unit-m = min
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
