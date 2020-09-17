# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Recargar lapela
    .accesskey = R
select-all-tabs =
    .label = Seleccionar todas as lapelas
    .accesskey = S
duplicate-tab =
    .label = Duplicar a lapela
    .accesskey = D
duplicate-tabs =
    .label = Duplicar lapelas
    .accesskey = D
close-tabs-to-the-end =
    .label = Pechar as lapelas á dereita
    .accesskey = i
close-other-tabs =
    .label = Pechar as outras lapelas
    .accesskey = o
reload-tabs =
    .label = Recargar lapelas
    .accesskey = R
pin-tab =
    .label = Fixar lapela
    .accesskey = p
unpin-tab =
    .label = Eliminar lapela fixa
    .accesskey = p
pin-selected-tabs =
    .label = Fixar lapelas
    .accesskey = F
unpin-selected-tabs =
    .label = Eliminar lapelas fixas
    .accesskey = p
bookmark-selected-tabs =
    .label = Marcar estas lapelas…
    .accesskey = l
bookmark-tab =
    .label = Marcar lapela
    .accesskey = l
reopen-in-container =
    .label = Volver a abrir nun contedor
    .accesskey = e
move-to-start =
    .label = Mover ao principio
    .accesskey = M
move-to-end =
    .label = Mover ao final
    .accesskey = e
move-to-new-window =
    .label = Mover a unha nova xanela
    .accesskey = x
tab-context-close-multiple-tabs =
    .label = Pechar varias lapelas
    .accesskey = v

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Desfacer pechar lapela
            [one] Desfacer pechar lapela
           *[other] Desfacer pechar lapelas
        }
    .accesskey = U
close-tab =
    .label = Pechar lapela
    .accesskey = c
close-tabs =
    .label = Pechar as lapelas
    .accesskey = s
move-tabs =
    .label = Mover lapelas
    .accesskey = v
move-tab =
    .label = Mover lapela
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Pechar a lapela
            [one] Pechar a lapelas
           *[other] Pechar as lapelas
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Mover lapela
            [one] Mover lapela
           *[other] Mover lapelas
        }
    .accesskey = v
