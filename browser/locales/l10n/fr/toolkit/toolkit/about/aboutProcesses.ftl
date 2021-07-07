# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Gestionnaire de processus
# The Actions column
about-processes-column-action =
    .title = Actions

## Tooltips

about-processes-shutdown-process =
    .title = Décharger les onglets et tuer le processus
about-processes-shutdown-tab =
    .title = Fermer l’onglet

## Column headers

about-processes-column-name = Nom
about-processes-column-memory-resident = Mémoire
about-processes-column-cpu-total = Processeur

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (processus { $pid })
about-processes-web-process-name = Web (processus { $pid }, partagé)
about-processes-web-isolated-process-name = Web (processus { $pid }) pour { $origin }
about-processes-web-large-allocation = Web (processus { $pid }, grand) pour { $origin }
about-processes-with-coop-coep-process-name = Web (processus { $pid }, multiorigine isolé) pour { $origin }
about-processes-file-process-name = Fichiers (processus { $pid })
about-processes-extension-process-name = Extensions (processus { $pid })
about-processes-privilegedabout-process-name = À propos (processus { $pid })
about-processes-plugin-process-name = Plugins (processus { $pid })
about-processes-privilegedmozilla-process-name = Web (processus { $pid }) pour les sites de { -vendor-short-name })
about-processes-gmp-plugin-process-name = Plugins multimédia Gecko (processus { $pid })
about-processes-gpu-process-name = GPU (processus { $pid })
about-processes-vr-process-name = Réalité virtuelle (processus { $pid })
about-processes-rdd-process-name = Décodeur de données (processus { $pid })
about-processes-socket-process-name = Réseau (processus { $pid })
about-processes-remote-sandbox-broker-process-name = Broker du bac à sable distant (processus { $pid })
about-processes-fork-server-process-name = Copie du serveur (processus { $pid })
about-processes-preallocated-process-name = Préalloué (processus { $pid })
about-processes-unknown-process-name = Autre ({ $type }, processus { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Processus { $pid } : { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Processus web partagé ({ $pid })
about-processes-file-process = Fichiers { $pid })
about-processes-extension-process = Extensions ({ $pid })
about-processes-privilegedabout-process = Pages « about: » ({ $pid })
about-processes-plugin-process = Plugins ({ $pid })
about-processes-privilegedmozilla-process = Sites { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = Plugins multimédia Gecko ({ $pid })
about-processes-gpu-process = Processeur graphique ({ $pid })
about-processes-vr-process = Réalité virtuelle ({ $pid })
about-processes-rdd-process = Décodeur de données ({ $pid })
about-processes-socket-process = Réseau ({ $pid })
about-processes-remote-sandbox-broker-process = Broker du bac à sable distant ({ $pid })
about-processes-fork-server-process = Copie du serveur ({ $pid })
about-processes-preallocated-process = Préalloué ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Autre : { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, grande allocation)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, processus multiorigine isolé)
about-processes-web-isolated-process-private = { $origin } — Privé ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — Privé ({ $pid }, grande allocation)
about-processes-with-coop-coep-process-private = { $origin } — Privé ({ $pid }, processus multiorigine isolé)

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
about-processes-thread-name = Thread { $tid } : { $name }
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
        [one] { $active } thread actif sur { $number } : { $list }
       *[other] { $active } threads actifs sur { $number } : { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
        [one] { $number } thread inactif
       *[other] { $number } threads inactifs
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = Identifiant du thread : { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Onglet : { $name }
about-processes-preloaded-tab = Nouvel onglet préchargé
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Iframe imbriqué : { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Iframes imbriqués ({ $number }) : { $shortUrl }

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
    .title = Temps total de CPU : { NUMBER($total, maximumFractionDigits: 0) } { $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (mesure en cours)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = inactif ({ NUMBER($total, maximumFractionDigits: 2) } { $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = inactif
    .title = Temps total de CPU : { NUMBER($total, maximumFractionDigits: 2) } { $unit }

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
    .title = Évolution : { $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) } { $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) } { $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = s
duration-unit-m = m
duration-unit-h = h
duration-unit-d = j

## Memory units

memory-unit-B = o
memory-unit-KB = Ko
memory-unit-MB = Mo
memory-unit-GB = Go
memory-unit-TB = To
memory-unit-PB = Po
memory-unit-EB = Eo
