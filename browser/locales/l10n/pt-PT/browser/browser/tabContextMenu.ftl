# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Recarregar separador
    .accesskey = R
select-all-tabs =
    .label = Selecionar todos os separadores
    .accesskey = S
duplicate-tab =
    .label = Duplicar separador
    .accesskey = D
duplicate-tabs =
    .label = Duplicar separadores
    .accesskey = D
close-tabs-to-the-end =
    .label = Fechar separadores à direita
    .accesskey = i
close-other-tabs =
    .label = Fechar outros separadores
    .accesskey = o
reload-tabs =
    .label = Recarregar separadores
    .accesskey = R
pin-tab =
    .label = Fixar separador
    .accesskey = p
unpin-tab =
    .label = Desafixar separador
    .accesskey = p
pin-selected-tabs =
    .label = Fixar separadores
    .accesskey = p
unpin-selected-tabs =
    .label = Desafixar separadores
    .accesskey = p
bookmark-selected-tabs =
    .label = Adicionar separadores aos marcadores…
    .accesskey = m
bookmark-tab =
    .label = Adicionar separador aos marcadores
    .accesskey = m
reopen-in-container =
    .label = Reabrir no contentor
    .accesskey = e
move-to-start =
    .label = Mover para o início
    .accesskey = i
move-to-end =
    .label = Mover para o fim
    .accesskey = f
move-to-new-window =
    .label = Mover para nova janela
    .accesskey = j
tab-context-close-multiple-tabs =
    .label = Fechar múltiplos separadores
    .accesskey = m

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Reabrir separador fechado
            [one] Reabrir separador fechado
           *[other] Reabrir separadores fechados
        }
    .accesskey = b
close-tab =
    .label = Fechar separador
    .accesskey = c
close-tabs =
    .label = Fechar separadores
    .accesskey = s
move-tabs =
    .label = Mover separadores
    .accesskey = v
move-tab =
    .label = Mover separador
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Fechar separador
            [one] Fechar separador
           *[other] Fechar separadores
        }
    .accesskey = c
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Mover separador
            [one] Mover separador
           *[other] Mover separadores
        }
    .accesskey = v
