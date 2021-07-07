# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Nova aba
    .accesskey = N
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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Fechar abas à esquerda
    .accesskey = e
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
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
tab-context-open-in-new-container-tab =
    .label = Abrir em nova aba contêiner
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
tab-context-share-url =
    .label = Compartilhar
    .accesskey = h
tab-context-share-more =
    .label = Mais…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Reabrir aba fechada
           *[other] Reabrir abas fechadas
        }
    .accesskey = h
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Fechar aba
            [one] Fechar aba
           *[other] Fechar abas
        }
    .accesskey = F
tab-context-close-n-tabs =
    .label =
        { $tabCount ->
            [1] Fechar aba
           *[other] Fechar { $tabCount } abas
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

tab-context-send-tabs-to-device =
    .label =
        { $tabCount ->
            [one] Enviar aba para dispositivo
           *[other] Enviar { $tabCount } abas para dispositivo
        }
    .accesskey = n
