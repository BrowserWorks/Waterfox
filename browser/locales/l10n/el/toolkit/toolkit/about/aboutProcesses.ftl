# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Διαχείριση διεργασιών
# The Actions column
about-processes-column-action =
    .title = Ενέργειες

## Tooltips

about-processes-shutdown-process =
    .title = "Ξεφόρτωμα" καρτελών και τερματισμός διεργασίας
about-processes-shutdown-tab =
    .title = Κλείσιμο καρτέλας

## Column headers

about-processes-column-name = Όνομα
about-processes-column-memory-resident = Μνήμη
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (διεργασία { $pid })
about-processes-web-process-name = Διαδίκτυο (διεργασία { $pid }, κοινό)
about-processes-web-isolated-process-name = Διαδίκτυο (διεργασία { $pid }) για { $origin }
about-processes-web-large-allocation = Διαδίκτυο (διεργασία { $pid }, μεγάλο) για { $origin }
about-processes-with-coop-coep-process-name = Διαδίκτυο (διεργασία { $pid }, απομονωμένο από προελεύσεις) για { $origin }
about-processes-file-process-name = Αρχεία (διεργασία { $pid })
about-processes-extension-process-name = Επεκτάσεις (διεργασία { $pid })
about-processes-privilegedabout-process-name = Πληροφορίες (διεργασία { $pid })
about-processes-plugin-process-name = Αρθρώματα (διεργασία { $pid })
about-processes-privilegedmozilla-process-name = Διαδίκτυο (διεργασία { $pid }) για ιστοσελίδες { -vendor-short-name }
about-processes-gmp-plugin-process-name = Αρθρώματα πολυμέσων Gecko (διεργασία { $pid })
about-processes-gpu-process-name = GPU (διεργασία { $pid })
about-processes-vr-process-name = VR (διεργασία { $pid })
about-processes-rdd-process-name = Αποκωδικοποιητής δεδομένων (διεργασία { $pid })
about-processes-socket-process-name = Δίκτυο (διεργασία { $pid })
about-processes-remote-sandbox-broker-process-name = Απομακρυσμένο Sandbox Broker (διεργασία { $pid })
about-processes-fork-server-process-name = Διακομιστής Fork (διεργασία { $pid })
about-processes-preallocated-process-name = Προκατανεμημένο (διεργασία { $pid })
about-processes-unknown-process-name = Άλλο ({ $type }, διεργασία { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Διεργασία { $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Κοινόχρηστη διεργασία ιστού ({ $pid })
about-processes-file-process = Αρχεία ({ $pid })
about-processes-extension-process = Επεκτάσεις ({ $pid })
about-processes-privilegedabout-process = Σελίδες "about:" ({ $pid })
about-processes-plugin-process = Αρθρώματα ({ $pid })
about-processes-privilegedmozilla-process = Σελίδες της { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = Αρθρώματα πολυμέσων Gecko ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = Αποκωδικοποιητής δεδομένων ({ $pid })
about-processes-socket-process = Δίκτυο ({ $pid })
about-processes-remote-sandbox-broker-process = Απομακρυσμένο Sandbox Broker ({ $pid })
about-processes-fork-server-process = Διακομιστής fork ({ $pid })
about-processes-preallocated-process = Προκατανεμημένο ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Άλλο: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, μεγάλο)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, απομονωμένο μεταξύ προελεύσεων)
about-processes-web-isolated-process-private = { $origin } — Ιδιωτικό ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — Ιδιωτικό ({ $pid }, μεγάλο)
about-processes-with-coop-coep-process-private = { $origin } — Ιδιωτικό ({ $pid }, απομονωμένο μεταξύ προελεύσεων)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = Νήματα ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = Νήμα { $tid }: { $name }
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
        [one] { $active } ενεργό νήμα από { $number }: { $list }
       *[other] { $active } ενεργά νήματα από { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
        [one] { $number } ανενεργό νήμα
       *[other] { $number } ανενεργά νήματα
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = ID νήματος: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Καρτέλα: { $name }
about-processes-preloaded-tab = Προφορτωμένη νέα καρτέλα
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Υποπλαίσιο: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Υποπλαίσια ({ $number }): { $shortUrl }

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
    .title = Συνολικός χρόνος CPU: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (μέτρηση)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = Αδρανές ({ NUMBER($total, maximumFractionDigits: 2) }{ $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = αδρανές
    .title = Συνολικός χρόνος CPU: { NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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
    .title = Εξέλιξη: { $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) }{ $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = δ
duration-unit-m = λ
duration-unit-h = ώ
duration-unit-d = η

## Memory units

memory-unit-B = B
memory-unit-KB = KB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
