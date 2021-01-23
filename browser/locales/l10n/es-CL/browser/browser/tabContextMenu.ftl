# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Recargar pestaña
    .accesskey = r
select-all-tabs =
    .label = Seleccionar todas las pestañas
    .accesskey = S
duplicate-tab =
    .label = Duplicar pestaña
    .accesskey = D
duplicate-tabs =
    .label = Duplicar pestañas
    .accesskey = D
close-tabs-to-the-end =
    .label = Cerrar pestañas a la derecha
    .accesskey = i
close-other-tabs =
    .label = Cerrar las otras pestañas
    .accesskey = o
reload-tabs =
    .label = Recargar pestañas
    .accesskey = R
pin-tab =
    .label = Fijar pestaña
    .accesskey = P
unpin-tab =
    .label = Soltar pestaña
    .accesskey = b
pin-selected-tabs =
    .label = Fijar pestañas
    .accesskey = P
unpin-selected-tabs =
    .label = Soltar pestañas
    .accesskey = b
bookmark-selected-tabs =
    .label = Guardar pestañas en marcadores…
    .accesskey = k
bookmark-tab =
    .label = Marcar pestaña
    .accesskey = B
reopen-in-container =
    .label = Reabrir en contenedor
    .accesskey = e
move-to-start =
    .label = Mover al inicio
    .accesskey = S
move-to-end =
    .label = Mover al final
    .accesskey = E
move-to-new-window =
    .label = Mover a una nueva ventana
    .accesskey = v
tab-context-close-multiple-tabs =
    .label = Cerrar múltiples pestañas
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Deshacer cierre de pestañas
            [one] Deshacer cierre de pestaña
           *[other] Deshacer cierre de pestañas
        }
    .accesskey = U
close-tab =
    .label = Cerrar pestaña
    .accesskey = c
close-tabs =
    .label = Cerrar pestañas
    .accesskey = S
move-tabs =
    .label = Mover pestañas
    .accesskey = v
move-tab =
    .label = Mover pestaña
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Cerrar pestaña
            [one] Cerrar pestaña
           *[other] Cerrar pestañas
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Mover pestaña
            [one] Mover pestaña
           *[other] Mover pestañas
        }
    .accesskey = v
