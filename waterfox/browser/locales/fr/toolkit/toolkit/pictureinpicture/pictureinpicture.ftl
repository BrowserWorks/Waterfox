# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Incrustation vidéo

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
    .aria-label = Pause
    .tooltip = Pause (barre d’espace)
pictureinpicture-play-btn =
    .aria-label = Lecture
    .tooltip = Lecture (barre d’espace)

pictureinpicture-mute-btn =
    .aria-label = Couper le son
    .tooltip = Couper le son ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Réactiver le son
    .tooltip = Réactiver le son ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Renvoyer dans l’onglet
    .tooltip = Retour dans l’onglet

pictureinpicture-close-btn =
    .aria-label = Fermer
    .tooltip = Fermer ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Sous-titres
    .tooltip = Sous-titres

pictureinpicture-fullscreen-btn2 =
    .aria-label = Plein écran
    .tooltip = Plein écran (double clic ou { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = Quitter le mode plein écran
    .tooltip = Quitter le mode plein écran (double clic ou { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Retour en arrière
    .tooltip = Retour en arrière (←)

pictureinpicture-seekforward-btn =
    .aria-label = Avancer
    .tooltip = Avancer (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = Paramètres des sous-titres

pictureinpicture-subtitles-label = Sous-titres

pictureinpicture-font-size-label = Taille de police

pictureinpicture-font-size-small = Petite

pictureinpicture-font-size-medium = Moyenne

pictureinpicture-font-size-large = Grande
