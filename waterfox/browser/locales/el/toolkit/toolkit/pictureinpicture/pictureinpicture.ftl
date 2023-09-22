# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Εικόνα εντός εικόνας

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
    .aria-label = Παύση
    .tooltip = Παύση (Spacebar)
pictureinpicture-play-btn =
    .aria-label = Αναπαραγωγή
    .tooltip = Αναπαραγωγή (Spacebar)

pictureinpicture-mute-btn =
    .aria-label = Σίγαση
    .tooltip = Σίγαση ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Άρση σίγασης
    .tooltip = Άρση σίγασης ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Αποστολή πίσω στην καρτέλα
    .tooltip = Πίσω στην καρτέλα

pictureinpicture-close-btn =
    .aria-label = Κλείσιμο
    .tooltip = Κλείσιμο ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Υπότιτλοι
    .tooltip = Υπότιτλοι

pictureinpicture-fullscreen-btn2 =
    .aria-label = Πλήρης οθόνη
    .tooltip = Πλήρης οθόνη (διπλό κλικ ή { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Έξοδος από πλήρη οθόνη
    .tooltip = Έξοδος από πλήρη οθόνη (διπλό κλικ ή { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Πίσω
    .tooltip = Πίσω (←)

pictureinpicture-seekforward-btn =
    .aria-label = Εμπρός
    .tooltip = Εμπρός (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Ρυθμίσεις υπότιτλων

pictureinpicture-subtitles-label = Υπότιτλοι

pictureinpicture-font-size-label = Μέγεθος γραμματοσειράς

pictureinpicture-font-size-small = Μικρό

pictureinpicture-font-size-medium = Μεσαίο

pictureinpicture-font-size-large = Μεγάλο
