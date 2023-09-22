# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Kép a képben

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
    .aria-label = Szüneteltetés
    .tooltip = Szüneteltetés (szóköz)
pictureinpicture-play-btn =
    .aria-label = Lejátszás
    .tooltip = Lejátszás (szóköz)

pictureinpicture-mute-btn =
    .aria-label = Némítás
    .tooltip = Némítás ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Némítás feloldása
    .tooltip = Némítás feloldása ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Visszaküldés a lapra
    .tooltip = Vissza a lapra

pictureinpicture-close-btn =
    .aria-label = Bezárás
    .tooltip = Bezárás ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Feliratok
    .tooltip = Feliratok

pictureinpicture-fullscreen-btn2 =
    .aria-label = Teljes képernyő
    .tooltip = Teljes képernyő (dupla kattintás vagy { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Kilépés a teljes képernyős módból
    .tooltip = Kilépés a teljes képernyős módból (dupla kattintás vagy { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Vissza
    .tooltip = Vissza (←)

pictureinpicture-seekforward-btn =
    .aria-label = Előre
    .tooltip = Előre (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Feliratbeállítások

pictureinpicture-subtitles-label = Feliratok

pictureinpicture-font-size-label = Betűméret

pictureinpicture-font-size-small = Kicsi

pictureinpicture-font-size-medium = Közepes

pictureinpicture-font-size-large = Nagy
