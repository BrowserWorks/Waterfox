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
    .tooltip = Pausar (barra espaciadora)
pictureinpicture-play-btn =
    .aria-label = Reproducir
    .tooltip = Reproducir (barra espaciadora)

pictureinpicture-mute-btn =
    .aria-label = Silenciar
    .tooltip = Silenciar ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Restaurar sonido
    .tooltip = Restaurar sonido ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Enviar de vuelta a la pestaña
    .tooltip = Vuelta a la pestaña

pictureinpicture-close-btn =
    .aria-label = Cerrar
    .tooltip = Cerrar ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Subtítulos
    .tooltip = Subtítulos

pictureinpicture-fullscreen-btn2 =
    .aria-label = Pantalla completa
    .tooltip = Pantalla completa (doble clic o { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Salir de pantalla completa
    .tooltip = Salir de pantalla completa (doble clic o { $shortcut })

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
    .aria-label = Avanzar
    .tooltip = Avanzar (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Ajustes de subtítulos

pictureinpicture-subtitles-label = Subtítulos

pictureinpicture-font-size-label = Tamaño de letra

pictureinpicture-font-size-small = Pequeño

pictureinpicture-font-size-medium = Medio

pictureinpicture-font-size-large = Grande
