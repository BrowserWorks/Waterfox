# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Position
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Chargement :
videocontrols-volume-control =
    .aria-label = Volume
videocontrols-closed-caption-button =
    .aria-label = Sous-titres
videocontrols-play-button =
    .aria-label = Lecture
videocontrols-pause-button =
    .aria-label = Pause
videocontrols-mute-button =
    .aria-label = Muet
videocontrols-unmute-button =
    .aria-label = Audible
videocontrols-enterfullscreen-button =
    .aria-label = Plein écran
videocontrols-exitfullscreen-button =
    .aria-label = Sortie du mode plein écran
videocontrols-casting-button-label =
    .aria-label = Diffuser sur l’écran
videocontrols-closed-caption-off =
    .offlabel = Désactivés
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Incrustation vidéo
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Regarder en mode incrustation
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Gardez un œil sur des vidéos au premier plan tout en faisant autre chose dans { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Extraire cette vidéo de la page
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Plus il y a d’écrans, mieux c’est ? Regardez cette vidéo en mode incrustation tout en navigant.
videocontrols-error-aborted = Chargement de la vidéo arrêté.
videocontrols-error-network = La lecture de la vidéo a été interrompue à cause d’une erreur de réseau.
videocontrols-error-decode = La vidéo ne peut être visionnée car le fichier est corrompu.
videocontrols-error-src-not-supported = Le format vidéo ou le type MIME n’est pas géré.
videocontrols-error-no-source = Aucune vidéo dont le format ou le type MIME est géré n’a été trouvée.
videocontrols-error-generic = La lecture de la vidéo a été interrompue à cause d’une erreur inconnue.
videocontrols-status-picture-in-picture = Cette vidéo est en cours de lecture en mode incrustation.
# This message shows the current position and total video duration
#
# Variables:
#   $position (String): The current media position
#   $duration (String): The total video duration
#
# For example, when at the 5 minute mark in a 6 hour long video,
# $position would be "5:00" and $duration would be "6:00:00", result
# string would be "5:00 / 6:00:00". Note that $duration is not always
# available. For example, when at the 5 minute mark in an unknown
# duration video, $position would be "5:00" and the string which is
# surrounded by <span> would be deleted, result string would be "5:00".
videocontrols-position-and-duration-labels = { $position }<span data-l10n-name="position-duration-format"> / { $duration }</span>
