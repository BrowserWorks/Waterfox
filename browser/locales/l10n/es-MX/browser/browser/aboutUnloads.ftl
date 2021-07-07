# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Descarga de pestañas
about-unloads-last-updated = Última actualización: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Descargar
    .title = Descargar la pestaña con la mayor prioridad
about-unloads-no-unloadable-tab = No hay pestañas para descargar.
about-unloads-column-priority = Prioridad
about-unloads-column-host = Servidor
about-unloads-column-last-accessed = Último acceso
about-unloads-column-weight = Peso Base
    .title = Las pestañas primero se ordenan por este valor, que se deriva de algunos atributos especiales como reproducir un sonido, WebRTC, etc.
about-unloads-column-memory = Memoria
    .title = Estimación de memoria usada por las pestañas
about-unloads-column-processes = IDs de procesos
    .title = IDs de los procesos que alojan el contenido de las pestañas
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
