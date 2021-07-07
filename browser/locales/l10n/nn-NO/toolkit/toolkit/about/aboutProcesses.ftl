# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Prosesshandterar
# The Actions column
about-processes-column-action =
    .title = Handlingar

## Tooltips

about-processes-shutdown-process =
    .title = Stopp faner og avslutt prosessen
about-processes-shutdown-tab =
    .title = Lat att fane

## Column headers

about-processes-column-name = Namn
about-processes-column-memory-resident = Minne
about-processes-column-cpu-total = Prosessor

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (prosess { $pid })
about-processes-web-process-name = Nett (prosess { $pid }, delt)
about-processes-web-isolated-process-name = Nett (prosess { $pid }, for { $origin })
about-processes-web-large-allocation = Nett (prosess { $pid }, stor, for { $origin })
about-processes-with-coop-coep-process-name = Nett (prosess { $pid }, kryss-opphav isolert) for { $origin }
about-processes-file-process-name = Filer (prosess { $pid })
about-processes-extension-process-name = Utvidingar (prosess { $pid })
about-processes-privilegedabout-process-name = Om (prosess { $pid })
about-processes-plugin-process-name = Programtillegg (prosess { $pid })
about-processes-privilegedmozilla-process-name = Nett (prosess { $pid }) for { -vendor-short-name }-nettstadar
about-processes-gmp-plugin-process-name = Gecko Media-programtillegg (process { $pid })
about-processes-gpu-process-name = GPU (prosess { $pid })
about-processes-vr-process-name = VR (process { $pid })
about-processes-rdd-process-name = Datadekodar (prosess { $pid })
about-processes-socket-process-name = Nettverk (prosess { $pid })
about-processes-remote-sandbox-broker-process-name = Remote Sandbox Broker (prosess { $pid })
about-processes-fork-server-process-name = Forkserver (prosess { $pid })
about-processes-preallocated-process-name = Førehandstildelt (prosess { $pid })
about-processes-unknown-process-name = Anna ({ $type }, prosess { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Prosess { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Delt nettprosess ({ $pid })
about-processes-file-process = Filer ({ $pid })
about-processes-extension-process = Utviding ({ $pid })
about-processes-privilegedabout-process = «Om»-sidene ({ $pid })
about-processes-plugin-process = Programtillegg ({ $pid })
about-processes-privilegedmozilla-process = { -vendor-short-name }-nettstadar ({ $pid })
about-processes-gmp-plugin-process = Gecko media-programtillegg ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = Datadekodar ({ $pid })
about-processes-socket-process = Nettverk ({ $pid })
about-processes-remote-sandbox-broker-process = Remote Sandbox Broker ({ $pid })
about-processes-fork-server-process = Forkserver ({ $pid })
about-processes-preallocated-process = Førehandstildelt ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Anna: { $type }({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, stor)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, cross-origin isolert)
about-processes-web-isolated-process-private = { $origin } — Privat ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — Privat({ $pid }, stor)
about-processes-with-coop-coep-process-private = { $origin } — Privat ({ $pid }, cross-origin isolert)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = Trådar ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = Tråd { $tid }: { $name }
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
        [one] { $active } aktiv tråd av totalt { $number }: { $list }
       *[other] { $active } aktive trådar av totalt { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
        [one] { $number } inaktiv tråd
       *[other] { $number } inaktive trådar
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = Tråd-ID: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Fane: { $name }
about-processes-preloaded-tab = Førehandslasta ny fane
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Underramme: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Underrammer ({ $number }): { $shortUrl }

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
    .title = Total prosessortid: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (måling)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = inaktiv ({ NUMBER($total, maximumFractionDigits: 2) } { $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = inaktiv
    .title = Total prosessortid: { NUMBER($total, maximumFractionDigits: 2) } { $unit }

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
    .title = Utvikling: { $deltaSign } { NUMBER($delta, maximumFractionDigits: 0) } { $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = s
duration-unit-m = m
duration-unit-h = t
duration-unit-d = d

## Memory units

memory-unit-B = B
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
