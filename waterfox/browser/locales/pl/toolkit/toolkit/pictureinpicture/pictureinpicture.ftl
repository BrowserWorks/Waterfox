# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Obraz w obrazie

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
    .aria-label = Wstrzymaj
    .tooltip = Wstrzymaj (spacja)
pictureinpicture-play-btn =
    .aria-label = Odtwórz
    .tooltip = Odtwórz (spacja)

pictureinpicture-mute-btn =
    .aria-label = Wycisz
    .tooltip = Wycisz ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Włącz dźwięk
    .tooltip = Włącz dźwięk ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Wyłącz „Obraz w obrazie”
    .tooltip = Wyłącz „Obraz w obrazie”

pictureinpicture-close-btn =
    .aria-label = Zamknij
    .tooltip = Zamknij ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Napisy
    .tooltip = Napisy

pictureinpicture-fullscreen-btn2 =
    .aria-label = Pełny ekran
    .tooltip = Pełny ekran (podwójne kliknięcie lub { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Opuść tryb pełnoekranowy
    .tooltip = Opuść tryb pełnoekranowy (podwójne kliknięcie lub { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Przewiń do tyłu
    .tooltip = Przewiń do tyłu (←)

pictureinpicture-seekforward-btn =
    .aria-label = Przewiń do przodu
    .tooltip = Przewiń do przodu (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Ustawienia napisów

pictureinpicture-subtitles-label = Napisy

pictureinpicture-font-size-label = Rozmiar czcionki

pictureinpicture-font-size-small = Mały

pictureinpicture-font-size-medium = Średni

pictureinpicture-font-size-large = Duży
