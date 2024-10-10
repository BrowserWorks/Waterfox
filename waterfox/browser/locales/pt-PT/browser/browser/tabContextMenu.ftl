# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Novo separador
    .accesskey = v
reload-tab =
    .label = Recarregar separador
    .accesskey = R
select-all-tabs =
    .label = Selecionar todos os separadores
    .accesskey = S
tab-context-play-tab =
    .label = Reproduzir separador
    .accesskey = e
tab-context-play-tabs =
    .label = Reproduzir separadores
    .accesskey = z
duplicate-tab =
    .label = Duplicar separador
    .accesskey = D
duplicate-tabs =
    .label = Duplicar separadores
    .accesskey = D
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Fechar separadores à esquerda
    .accesskey = e
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
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
tab-context-bookmark-tab =
    .label = Adicionar separador aos marcadores…
    .accesskey = B
tab-context-open-in-new-container-tab =
    .label = Abrir num novo separador contentor
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
tab-context-share-url =
    .label = Partilhar
    .accesskey = h

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Reabrir separador fechado
            [one] Reabrir separador fechado
           *[other] Reabrir separadores fechados
        }
    .accesskey = o
tab-context-close-n-tabs =
    .label =
        { $tabCount ->
            [1] Fechar separador
            [one] Fechar { $tabCount } separadores
           *[other] Fechar { $tabCount } separadores
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

tab-context-send-tabs-to-device =
    .label =
        { $tabCount ->
            [one] Enviar separador para dispositivo
           *[other] Enviar { $tabCount } separadores para dispositivo
        }
    .accesskey = n
