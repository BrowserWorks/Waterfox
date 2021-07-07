# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Gestione processi

# The Actions column
about-processes-column-action =
    .title = Azioni

## Tooltips

about-processes-shutdown-process =
    .title = Scarica le schede e termina il processo
about-processes-shutdown-tab =
    .title = Chiudi scheda

## Column headers

about-processes-column-name = Nome
about-processes-column-memory-resident = Memoria
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Processo web condiviso ({ $pid })
about-processes-file-process = File ({ $pid })
about-processes-extension-process = Estensioni ({ $pid })
about-processes-privilegedabout-process = Pagine about ({ $pid })
about-processes-plugin-process = Plugin ({ $pid })
about-processes-privilegedmozilla-process = Siti { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = Plugin multimediali Gecko ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = Decodificatore dati ({ $pid })
about-processes-socket-process = Rete ({ $pid })
about-processes-remote-sandbox-broker-process = Broker per sandbox remota ({ $pid })
about-processes-fork-server-process = Fork server ({ $pid })
about-processes-preallocated-process = Preallocato ({ $pid })

about-processes-unknown-process = Altro: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, grande)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, cross-origin isolato)
about-processes-web-isolated-process-private = { $origin } — Anonima ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — Anonima ({ $pid }, grande)
about-processes-with-coop-coep-process-private = { $origin } — Anonima ({ $pid }, cross-origin isolato)

## Details within processes

about-processes-active-threads = { $active ->
  [one] { $active } thread attivo su { $number }: { $list }
  *[other] { $active } thread attivi su { $number }: { $list }
}

about-processes-inactive-threads = { $number ->
   [one] { $number } thread non attivo
  *[other] { $number } thread non attivi
}

# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = ID thread: { $tid }

# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Scheda: { $name }
about-processes-preloaded-tab = Nuova scheda precaricata

# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Sottoframe: { $url }

# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Sottoframe ({ $number }): { $shortUrl }

## Displaying CPU (percentage and total)
## Variables:
##    $percent (Number) The percentage of CPU used by the process or thread.
##                      Always > 0, generally <= 200.
##    $total (Number) The amount of time used by the process or thread since
##                    its start.
##    $unit (String) The unit in which to display $total. See the definitions
##                   of `duration-unit-*`.

about-processes-cpu = { NUMBER($percent, maximumSignificantDigits: 2, style: "percent") }
    .title = Tempo CPU complessivo: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }

# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (misurazione in corso)

about-processes-cpu-idle = non attivo
    .title = Tempo CPU complessivo: { NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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

about-processes-total-memory-size-changed = { NUMBER($total, maximumFractionDigits:0) }{ $totalUnit }
   .title = Evoluzione: { $deltaSign }{ NUMBER($delta, maximumFractionDigits:0) }{ $deltaUnit }

# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits:0) }{ $totalUnit }

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
memory-unit-KB = kB
memory-unit-MB = MB
memory-unit-GB = GB
memory-unit-TB = TB
memory-unit-PB = PB
memory-unit-EB = EB
