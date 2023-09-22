# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Obraz v obraze

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
    .aria-label = Pozastavit
    .tooltip = Pozastavit (mezerník)
pictureinpicture-play-btn =
    .aria-label = Přehrát
    .tooltip = Přehrát (mezerník)

pictureinpicture-mute-btn =
    .aria-label = Ztlumit
    .tooltip = Ztlumit ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Zapnout zvuk
    .tooltip = Zapnout zvuk ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Odeslat zpět do panelu
    .tooltip = Zpět do panelu

pictureinpicture-close-btn =
    .aria-label = Zavřít
    .tooltip = Zavřít ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Titulky
    .tooltip = Titulky

pictureinpicture-fullscreen-btn2 =
    .aria-label = Na celou obrazovku
    .tooltip = Na celou obrazovku (dvojklepnutí nebo { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Ukončit režim celé obrazovky
    .tooltip = Ukončit režim celé obrazovky (dvojklepnutí nebo { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Zpět
    .tooltip = Zpět (←)

pictureinpicture-seekforward-btn =
    .aria-label = Vpřed
    .tooltip = Vpřed (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Nastavení titulků

pictureinpicture-subtitles-label = Titulky

pictureinpicture-font-size-label = Velikost písma

pictureinpicture-font-size-small = Malé

pictureinpicture-font-size-medium = Střední

pictureinpicture-font-size-large = Velké
