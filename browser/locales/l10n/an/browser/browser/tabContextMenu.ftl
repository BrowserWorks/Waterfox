# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Tornar a cargar a pestanya
    .accesskey = g
select-all-tabs =
    .label = Triar totas las pestanyas
    .accesskey = T
duplicate-tab =
    .label = Duplicar la pestanya
    .accesskey = D
duplicate-tabs =
    .label = Duplicar pestanyas
    .accesskey = D
close-tabs-to-the-end =
    .label = Zarrar as pestanyas d'a dreita
    .accesskey = a
close-other-tabs =
    .label = Zarrar as atras pestanyas
    .accesskey = Z
reload-tabs =
    .label = Recargar pestanyas
    .accesskey = R
pin-tab =
    .label = Clavar a pestanya
    .accesskey = C
unpin-tab =
    .label = Desclavar a pestanya
    .accesskey = D
pin-selected-tabs =
    .label = Clavar pestanyas
    .accesskey = C
unpin-selected-tabs =
    .label = Desclavar las pestanyas
    .accesskey = s
bookmark-selected-tabs =
    .label = Anyadir las pestanyas a marcapachinas…
    .accesskey = m
bookmark-tab =
    .label = Anyadir la pestanya a los marcapachinas
    .accesskey = m
reopen-in-container =
    .label = Reubrir en o contenedor
    .accesskey = e
move-to-start =
    .label = Ir ta l'inicio
    .accesskey = i
move-to-end =
    .label = Ir ta la fin
    .accesskey = f
move-to-new-window =
    .label = Mover ta una finestra nueva
    .accesskey = v
tab-context-close-multiple-tabs =
    .label = Zarrar multiples pestanyas
    .accesskey = m

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Desfer la tancadura
            [one] Desfer la tancadura d'a pestanya
           *[other] Desfer la tancadura d'as pestanyas
        }
    .accesskey = D
close-tab =
    .label = Zarrar a pestaña
    .accesskey = t
close-tabs =
    .label = Zarrar las pestanyas
    .accesskey = Z
move-tabs =
    .label = Mover pestanyas
    .accesskey = v
move-tab =
    .label = Mover la pestanya
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Zarrar la pestanya
            [one] Zarrar la pestanya
           *[other] Zarrar las pestanyas
        }
    .accesskey = Z
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Mover pestanya
            [one] Mover la pestanya
           *[other] Mover las pestanyas
        }
    .accesskey = v
