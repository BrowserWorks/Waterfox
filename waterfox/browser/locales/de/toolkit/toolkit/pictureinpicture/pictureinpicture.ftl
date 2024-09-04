# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Bild-im-Bild

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
    .aria-label = Anhalten
    .tooltip = Anhalten (Leertaste)
pictureinpicture-play-btn =
    .aria-label = Abspielen
    .tooltip = Abspielen (Leertaste)

pictureinpicture-mute-btn =
    .aria-label = Ton aus
    .tooltip = Ton aus ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Ton an
    .tooltip = Ton an ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Einfügen in ursprünglichen Tab
    .tooltip = In ursprünglichen Tab

pictureinpicture-close-btn =
    .aria-label = Schließen
    .tooltip = Schließen ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Untertitel
    .tooltip = Untertitel

pictureinpicture-fullscreen-btn2 =
    .aria-label = Vollbild
    .tooltip = Vollbild (Doppelklick oder { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Vollbild beenden
    .tooltip = Vollbild beenden (Doppelklick oder { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Zurück
    .tooltip = Zurück (←)

pictureinpicture-seekforward-btn =
    .aria-label = Vor
    .tooltip = Vor (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Untertitel-Einstellungen

pictureinpicture-subtitles-label = Untertitel

pictureinpicture-font-size-label = Schriftgröße

pictureinpicture-font-size-small = Klein

pictureinpicture-font-size-medium = Mittel

pictureinpicture-font-size-large = Groß
