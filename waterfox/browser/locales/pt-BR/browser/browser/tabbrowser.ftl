# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Nova aba
tabbrowser-empty-private-tab-title = Nova aba privativa

tabbrowser-menuitem-close-tab =
    .label = Fechar aba
tabbrowser-menuitem-close =
    .label = Fechar

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } - { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] Fechar aba
           *[other] Fechar { $tabCount } abas
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Silenciar aba ({ $shortcut })
           *[other] Silenciar { $tabCount } abas ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Ativar som da aba ({ $shortcut })
           *[other] Ativar som das { $tabCount } abas ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Silenciar aba
           *[other] Silenciar { $tabCount } abas
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Ativar som da aba
           *[other] Ativar som das { $tabCount } abas
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Reproduzir som da aba
           *[other] Reproduzir som das { $tabCount } abas
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Fechar { $tabCount } abas?
tabbrowser-confirm-close-tabs-button = Fechar abas
tabbrowser-confirm-close-tabs-checkbox = Confirmar antes de fechar várias abas

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title =
    { $windowCount ->
       *[other] Fechar { $windowCount } janelas?
    }
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Fechar e sair
       *[other] Fechar e sair
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Fechar a janela e sair do { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Sair do { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Confirmar antes de sair com { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Confirmar abertura
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Serão abertas { $tabCount } abas. O { -brand-short-name } pode ficar lento durante o carregamento dessas páginas. Tem certeza que quer continuar?
    }
tabbrowser-confirm-open-multiple-tabs-button = Abrir abas
tabbrowser-confirm-open-multiple-tabs-checkbox = Avisar que o carregamento de várias abas pode deixar o { -brand-short-name } lento

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Navegação com cursor do teclado
tabbrowser-confirm-caretbrowsing-message = A tecla F7 ativa ou desativa a navegação com cursor do teclado. Este recurso coloca um cursor móvel em páginas web, permitindo selecionar texto usando o teclado. Quer ativar a navegação com cursor do teclado?
tabbrowser-confirm-caretbrowsing-checkbox = Não mostrar mais este aviso.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Permitir que notificações como esta de { $domain } levem você para a aba de origem

tabbrowser-customizemode-tab-title = Personalizar o { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Silenciar aba
    .accesskey = S
tabbrowser-context-unmute-tab =
    .label = Ativar som da aba
    .accesskey = s
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Silenciar abas
    .accesskey = s
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Ativar som de abas
    .accesskey = s

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Reproduzindo áudio

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Listar as { $tabCount } abas

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Silenciar aba
tabbrowser-manager-unmute-tab =
    .tooltiptext = Ativar som da aba
tabbrowser-manager-close-tab =
    .tooltiptext = Fechar aba
