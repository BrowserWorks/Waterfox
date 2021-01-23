# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Recarregar aba
    .accesskey = R
select-all-tabs =
    .label = Selecionar todas as abas
    .accesskey = t
duplicate-tab =
    .label = Duplicar aba
    .accesskey = D
duplicate-tabs =
    .label = Duplicar abas
    .accesskey = D
close-tabs-to-the-end =
    .label = Fechar abas à direita
    .accesskey = i
close-other-tabs =
    .label = Fechar as outras abas
    .accesskey = o
reload-tabs =
    .label = Recarregar abas
    .accesskey = R
pin-tab =
    .label = Fixar aba
    .accesskey = x
unpin-tab =
    .label = Desafixar aba
    .accesskey = x
pin-selected-tabs =
    .label = Fixar abas
    .accesskey = F
unpin-selected-tabs =
    .label = Desafixar abas
    .accesskey = b
bookmark-selected-tabs =
    .label = Adicionar abas aos favoritos…
    .accesskey = f
bookmark-tab =
    .label = Adicionar aba aos favoritos
    .accesskey = A
reopen-in-container =
    .label = Reabrir em um contêiner
    .accesskey = e
move-to-start =
    .label = Mover para o início
    .accesskey = i
move-to-end =
    .label = Mover para o final
    .accesskey = f
move-to-new-window =
    .label = Mover para uma nova janela
    .accesskey = v
tab-context-close-multiple-tabs =
    .label = Fechar várias abas
    .accesskey = v

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Reabrir aba
            [one] Reabrir aba
           *[other] Reabrir abas
        }
    .accesskey = b
close-tab =
    .label = Fechar aba
    .accesskey = F
close-tabs =
    .label = Fechar abas
    .accesskey = h
move-tabs =
    .label = Mover abas
    .accesskey = v
move-tab =
    .label = Mover aba
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Fechar aba
            [one] Fechar aba
           *[other] Fechar abas
        }
    .accesskey = F
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Mover aba
            [one] Mover aba
           *[other] Mover abas
        }
    .accesskey = v
