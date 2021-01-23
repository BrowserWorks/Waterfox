# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Torna a carregar la pestanya
    .accesskey = r
select-all-tabs =
    .label = Selecciona totes les pestanyes
    .accesskey = t
duplicate-tab =
    .label = Duplica la pestanya
    .accesskey = D
duplicate-tabs =
    .label = Duplica les pestanyes
    .accesskey = D
close-tabs-to-the-end =
    .label = Tanca les pestanyes de la dreta
    .accesskey = d
close-other-tabs =
    .label = Tanca les altres pestanyes
    .accesskey = l
reload-tabs =
    .label = Torna a carregar les pestanyes
    .accesskey = r
pin-tab =
    .label = Fixa la pestanya
    .accesskey = p
unpin-tab =
    .label = No fixis la pestanya
    .accesskey = f
pin-selected-tabs =
    .label = Fixa les pestanyes
    .accesskey = F
unpin-selected-tabs =
    .label = No fixis les pestanyes
    .accesskey = f
bookmark-selected-tabs =
    .label = Afig les pestanyes a les adreces d'interés…
    .accesskey = A
bookmark-tab =
    .label = Afig la pestanya a les adreces d'interés
    .accesskey = A
reopen-in-container =
    .label = Torna a obrir en un contenidor
    .accesskey = e
move-to-start =
    .label = Mou al principi
    .accesskey = p
move-to-end =
    .label = Mou al final
    .accesskey = f
move-to-new-window =
    .label = Mou a una finestra nova
    .accesskey = v
tab-context-close-multiple-tabs =
    .label = Tanca diverses pestanyes
    .accesskey = a

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Desfés el tancament de la pestanya
           *[other] Desfés el tancament de les pestanyes
        }
    .accesskey = f
close-tab =
    .label = Tanca la pestanya
    .accesskey = c
close-tabs =
    .label = Tanca les pestanyes
    .accesskey = c
move-tabs =
    .label = Mou les pestanyes
    .accesskey = u
move-tab =
    .label = Mou la pestanya
    .accesskey = u
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Tanca la pestanya
           *[other] Tanca les pestanyes
        }
    .accesskey = c
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Mou la pestanya
           *[other] Mou les pestanyes
        }
    .accesskey = M
