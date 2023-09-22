# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Novo separador
tabbrowser-empty-private-tab-title = Novo separador privado
tabbrowser-menuitem-close-tab =
    .label = Fechar separador
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
            [one] Fechar separador
           *[other] Fechar { $tabCount } separadores
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Silenciar som do separador ({ $shortcut })
           *[other] Silenciar som dos { $tabCount } separadores ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Repor som do separador ({ $shortcut })
           *[other] Repor som dos { $tabCount } separadores ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Silenciar som do separador
           *[other] Silenciar som dos { $tabCount } separadores
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Repor som do separador
           *[other] Repor som dos { $tabCount } separadores
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Reproduzir separador
           *[other] Reproduzir { $tabCount } separadores
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Fechar { $tabCount } separadores?
tabbrowser-confirm-close-tabs-button = Fechar separadores
tabbrowser-confirm-close-tabs-checkbox = Confirmar antes de fechar múltiplos separadores

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Fechar { $windowCount } janelas?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Fechar e sair
       *[other] Fechar e sair
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Fechar janela e sair do { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Sair de { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Confirmar antes de sair com { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Confirmar abertura
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Vai abrir { $tabCount } separadores. Isto pode tornar o { -brand-short-name } lento enquanto as páginas carregam. Tem a certeza que pretende continuar?
    }
tabbrowser-confirm-open-multiple-tabs-button = Abrir separadores
tabbrowser-confirm-open-multiple-tabs-checkbox = Avisar-me quando abrir múltiplos separadores poderá tornar o { -brand-short-name } lento

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Navegação por cursor
tabbrowser-confirm-caretbrowsing-message = A tecla F7 ativa ou desativa a navegação por cursor. Esta característica coloca um cursor móvel nas páginas da Internet, permitindo-lhe selecionar texto com o teclado. Quer ativar a navegação por cursor?
tabbrowser-confirm-caretbrowsing-checkbox = Não voltar a mostrar esta janela.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Permitir que notificações como esta de { $domain } o encaminhei para o respetivo separador
tabbrowser-customizemode-tab-title = Personalizar o { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Silenciar som do separador
    .accesskey = m
tabbrowser-context-unmute-tab =
    .label = Repor som do separador
    .accesskey = m
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Silenciar som dos separadores
    .accesskey = m
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Repor som dos separadores
    .accesskey = m
# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = A reproduzir áudio

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Mostrar os { $tabCount } separadores

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Silenciar separador
tabbrowser-manager-unmute-tab =
    .tooltiptext = Ativar separador
tabbrowser-manager-close-tab =
    .tooltiptext = Fechar separador
