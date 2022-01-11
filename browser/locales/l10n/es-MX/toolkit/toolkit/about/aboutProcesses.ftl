# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-processes-title = Administrador de procesos
# The Actions column
about-processes-column-action =
    .title = Acciones

## Tooltips

about-processes-shutdown-process =
    .title = Descargar pestañas y matar el proceso
about-processes-shutdown-tab =
    .title = Cerrar pestaña

## Column headers

about-processes-column-name = Nombre
about-processes-column-memory-resident = Memoria
about-processes-column-cpu-total = CPU

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.
##    $type (String) The raw type for this process. Used for unknown processes.

about-processes-browser-process-name = { -brand-short-name } (proceso { $pid })
about-processes-web-process-name = Web (proceso { $pid }, compartido)
about-processes-web-isolated-process-name = Web (proceso { $pid }) para { $origin }
about-processes-web-large-allocation = Web (proceso { $pid }, grande) para { $origin }
about-processes-with-coop-coep-process-name = Web (proceso { $pid }, origen cruzado aislado) para { $origin }
about-processes-file-process-name = Archivos (proceso { $pid })
about-processes-extension-process-name = Extensiones (proceso { $pid })
about-processes-privilegedabout-process-name = Acerca de (proceso { $pid } )
about-processes-plugin-process-name = Plugins (proceso { $pid })
about-processes-privilegedmozilla-process-name = Web (proceso { $pid }) para sitios { -vendor-short-name }
about-processes-gmp-plugin-process-name = Plugins de medios de Gecko (proceso { $pid })
about-processes-gpu-process-name = GPU (proceso { $pid })
about-processes-vr-process-name = Realidad Virtual (proceso { $pid })
about-processes-rdd-process-name = Decodificador de datos (proceso { $pid })
about-processes-socket-process-name = Red (proceso { $pid })
about-processes-remote-sandbox-broker-process-name = Remote Sandbox Broker (proceso { $pid })
about-processes-fork-server-process-name = Fork Server (proceso { $pid })
about-processes-preallocated-process-name = Preasignado (proceso { $pid })
about-processes-unknown-process-name = Otro ({ $type }, proceso { $pid })
# Process
# Variables:
#   $name (String) The name assigned to the process.
#   $pid (String) The process id of this process, assigned by the OS.
about-processes-process-name = Proceso{ $pid }: { $name }

## Process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.

about-processes-browser-process = { -brand-short-name } ({ $pid })
about-processes-web-process = Proceso Web Compartido ({ $pid })
about-processes-file-process = Archivos ({ $pid })
about-processes-extension-process = Extensiones ({ $pid })
about-processes-privilegedabout-process = Páginas "about:" ({ $pid })
about-processes-plugin-process = Complementos ({ $pid })
about-processes-privilegedmozilla-process = Sitios { -vendor-short-name } ({ $pid })
about-processes-gmp-plugin-process = Complementos de medios Gecko ({ $pid })
about-processes-gpu-process = GPU ({ $pid })
about-processes-vr-process = VR ({ $pid })
about-processes-rdd-process = Decodificador de datos ({ $pid })
about-processes-socket-process = Red ({ $pid })
about-processes-remote-sandbox-broker-process = Agente de Espacio Aislado Remoto ({ $pid })
about-processes-fork-server-process = Servidor de bifurcación ({ $pid })
about-processes-preallocated-process = Preasignado ({ $pid })
# Unknown process names
# Variables:
#    $pid (String) The process id of this process, assigned by the OS.
#    $type (String) The raw type for this process.
about-processes-unknown-process = Otro: { $type } ({ $pid })

## Isolated process names
## Variables:
##    $pid (String) The process id of this process, assigned by the OS.
##    $origin (String) The domain name for this process.

about-processes-web-isolated-process = { $origin } ({ $pid })
about-processes-web-large-allocation-process = { $origin } ({ $pid }, grande)
about-processes-with-coop-coep-process = { $origin } ({ $pid }, origen cruzado aislado)
about-processes-web-isolated-process-private = { $origin } — Privado ({ $pid })
about-processes-web-large-allocation-process-private = { $origin } — Privado ({ $pid }, grande)
about-processes-with-coop-coep-process-private = { $origin } — Privado ({ $pid }, origen cruzado aislado)

## Details within processes

# Single-line summary of threads
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
about-processes-thread-summary = Hilos ({ $number })
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name = Hilo { $tid }: { $name }
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
        [one] { $active } hilo activo de { $number }: { $list }
       *[other] { $active } hilos activos de { $number }: { $list }
    }
# Single-line summary of threads (idle process)
# Variables:
#    $number (Number) The number of threads in the process. Typically larger
#                     than 30. We don't expect to ever have processes with less
#                     than 5 threads.
#                     The process is idle so all threads are inactive.
about-processes-inactive-threads =
    { $number ->
        [one] { $number } hilo inactivo
       *[other] { $number } hilos inactivos
    }
# Thread details
# Variables:
#   $name (String) The name assigned to the thread.
#   $tid (String) The thread id of this thread, assigned by the OS.
about-processes-thread-name-and-id = { $name }
    .title = Id del hilo: { $tid }
# Tab
# Variables:
#   $name (String) The name of the tab (typically the title of the page, might be the url while the page is loading).
about-processes-tab-name = Pestaña: { $name }
about-processes-preloaded-tab = Pestaña nueva precargada
# Single subframe
# Variables:
#   $url (String) The full url of this subframe.
about-processes-frame-name-one = Submarco: { $url }
# Group of subframes
# Variables:
#   $number (Number) The number of subframes in this group. Always ≥ 1.
#   $shortUrl (String) The shared prefix for the subframes in the group.
about-processes-frame-name-many = Submarcos ({ $number }): { $shortUrl }

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
    .title = Tiempo total de CPU: { NUMBER($total, maximumFractionDigits: 0) }{ $unit }
# Special case: data is not available yet.
about-processes-cpu-user-and-kernel-not-ready = (medición)
# Special case: process or thread is currently idle.
about-processes-cpu-user-and-kernel-idle = inactivo ({ NUMBER($total, maximumFractionDigits: 2) }{ $unit })
# Special case: process or thread is currently idle.
about-processes-cpu-idle = inactivo
    .title = Tiempo total de CPU: { NUMBER($total, maximumFractionDigits: 2) }{ $unit }

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
    .title = Evolución: { $deltaSign }{ NUMBER($delta, maximumFractionDigits: 0) }{ $deltaUnit }
# Special case: no change.
about-processes-total-memory-size-no-change = { NUMBER($total, maximumFractionDigits: 0) }{ $totalUnit }

## Duration units

duration-unit-ns = ns
duration-unit-us = µs
duration-unit-ms = ms
duration-unit-s = S
duration-unit-m = m
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
