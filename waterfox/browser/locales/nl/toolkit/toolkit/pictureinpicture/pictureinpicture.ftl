# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Picture-in-picture

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
    .aria-label = Pauzeren
    .tooltip = Pauzeren (spatiebalk)
pictureinpicture-play-btn =
    .aria-label = Afspelen
    .tooltip = Afspelen (spatiebalk)

pictureinpicture-mute-btn =
    .aria-label = Dempen
    .tooltip = Dempen ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Dempen opheffen
    .tooltip = Dempen opheffen ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Terugsturen naar tabblad
    .tooltip = Terug naar tabblad

pictureinpicture-close-btn =
    .aria-label = Sluiten
    .tooltip = Sluiten ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Ondertitels
    .tooltip = Ondertitels

pictureinpicture-fullscreen-btn2 =
    .aria-label = Volledig scherm
    .tooltip = Volledig scherm (dubbelklik of { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Volledig scherm verlaten
    .tooltip = Volledig scherm verlaten (dubbelklik of { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Terug
    .tooltip = Terug (←)

pictureinpicture-seekforward-btn =
    .aria-label = Vooruit
    .tooltip = Vooruit (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Ondertitelingsinstellingen

pictureinpicture-subtitles-label = Ondertitels

pictureinpicture-font-size-label = Lettergrootte

pictureinpicture-font-size-small = Klein

pictureinpicture-font-size-medium = Normaal

pictureinpicture-font-size-large = Groot
