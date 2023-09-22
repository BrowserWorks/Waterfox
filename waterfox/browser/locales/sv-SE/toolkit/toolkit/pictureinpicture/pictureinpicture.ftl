# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Bild-i-bild

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
    .tooltip = Pausa (mellanslag)
pictureinpicture-play-btn =
    .aria-label = Spela
    .tooltip = Spela (mellanslag)

pictureinpicture-mute-btn =
    .aria-label = Ljud av
    .tooltip = Ljud av ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Ljud på
    .tooltip = Ljud på ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Skicka tillbaka till flik
    .tooltip = Tillbaka till flik

pictureinpicture-close-btn =
    .aria-label = Stäng
    .tooltip = Stäng ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Undertexter
    .tooltip = Undertexter

pictureinpicture-fullscreen-btn2 =
    .aria-label = Helskärm
    .tooltip = Helskärm (dubbelklicka eller { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Avsluta helskärm
    .tooltip = Avsluta helskärm (dubbelklicka eller { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Bakåt
    .tooltip = Bakåt (←)

pictureinpicture-seekforward-btn =
    .aria-label = Framåt
    .tooltip = Framåt (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Undertextinställningar

pictureinpicture-subtitles-label = Undertexter

pictureinpicture-font-size-label = Textstorlek

pictureinpicture-font-size-small = Liten

pictureinpicture-font-size-medium = Mellan

pictureinpicture-font-size-large = Stor
