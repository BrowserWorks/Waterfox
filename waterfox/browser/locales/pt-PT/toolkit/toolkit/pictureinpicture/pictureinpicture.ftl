# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Vídeo em janela flutuante

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
    .aria-label = Pausa
    .tooltip = Pausa (Barra de Espaço)
pictureinpicture-play-btn =
    .aria-label = Reproduzir
    .tooltip = Reproduzir (Barra de Espaço)

pictureinpicture-mute-btn =
    .aria-label = Silenciar
    .tooltip = Silenciar ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Repor som
    .tooltip = Repor som ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Enviar para o separador
    .tooltip = Para o separador

pictureinpicture-close-btn =
    .aria-label = Fechar
    .tooltip = Fechar ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Legendas
    .tooltip = Legendas

pictureinpicture-fullscreen-btn2 =
    .aria-label = Ecrã completo
    .tooltip = Ecrã completo (duplo clique ou { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Sair do ecrã completo
    .tooltip = Sair do ecrã completo (duplo clique ou { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Retroceder
    .tooltip = Retroceder (←)

pictureinpicture-seekforward-btn =
    .aria-label = Avançar
    .tooltip = Avançar (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Definições das legendas

pictureinpicture-subtitles-label = Legendas

pictureinpicture-font-size-label = Tamanho do tipo de letra

pictureinpicture-font-size-small = Pequeno

pictureinpicture-font-size-medium = Médio

pictureinpicture-font-size-large = Grande
