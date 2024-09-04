# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Picture-in-Picture

## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.
##
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

pictureinpicture-pause-btn =
    .aria-label = Pausar
    .tooltip = Pausar (barra de espaço)
pictureinpicture-play-btn =
    .aria-label = Reproduzir
    .tooltip = Reproduzir (barra de espaço)

pictureinpicture-mute-btn =
    .aria-label = Silenciar
    .tooltip = Silenciar ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Ativar som
    .tooltip = Ativar som ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Enviar de volta à aba
    .tooltip = Voltar para a aba

pictureinpicture-close-btn =
    .aria-label = Fechar
    .tooltip = Fechar ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Legendas
    .tooltip = Legendas

pictureinpicture-fullscreen-btn2 =
    .aria-label = Tela inteira
    .tooltip = Tela inteira (duplo-clique ou { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Sair de tela inteira
    .tooltip = Sair de tela inteira (duplo-clique ou { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Voltar
    .tooltip = Voltar (←)

pictureinpicture-seekforward-btn =
    .aria-label = Avançar
    .tooltip = Avançar (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Configurações de legendas

pictureinpicture-subtitles-label = Subtítulos

pictureinpicture-font-size-label = Tamanho da fonte

pictureinpicture-font-size-small = Pequeno

pictureinpicture-font-size-medium = Médio

pictureinpicture-font-size-large = Grande
