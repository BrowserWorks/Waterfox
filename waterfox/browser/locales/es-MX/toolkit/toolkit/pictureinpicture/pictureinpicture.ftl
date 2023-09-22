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
    .aria-label = Pausa
    .tooltip = Pausa (barra espaciadora)
pictureinpicture-play-btn =
    .aria-label = Reproducir
    .tooltip = Reproducir (barra espaciadora)

pictureinpicture-mute-btn =
    .aria-label = Silenciar
    .tooltip = Silenciar ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Activar sonido
    .tooltip = Activar sonido ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Enviar de vuelta a la pestaña
    .tooltip = Volver a la pestaña

pictureinpicture-close-btn =
    .aria-label = Cerrar
    .tooltip = Cerrar ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Subtítulos
    .tooltip = Subtítulos

##

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Ir atrás
    .tooltip = Ir atrás (←)

pictureinpicture-seekforward-btn =
    .aria-label = Ir adelante
    .tooltip = Ir adelante (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Configuración de subtítulos

pictureinpicture-subtitles-label = Subtítulos

pictureinpicture-font-size-label = Tamaño de fuente

pictureinpicture-font-size-small = Pequeño

pictureinpicture-font-size-medium = Mediano

pictureinpicture-font-size-large = Grande
