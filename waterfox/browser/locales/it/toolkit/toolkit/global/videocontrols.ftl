# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Posizione
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Caricamento:
videocontrols-volume-control =
    .aria-label = Volume
videocontrols-closed-caption-button =
    .aria-label = Sottotitoli

videocontrols-play-button =
    .aria-label = Riproduci
videocontrols-pause-button =
    .aria-label = Pausa
videocontrols-mute-button =
    .aria-label = Disattiva audio
videocontrols-unmute-button =
    .aria-label = Attiva audio
videocontrols-enterfullscreen-button =
    .aria-label = Schermo intero
videocontrols-exitfullscreen-button =
    .aria-label = Esci da schermo intero
videocontrols-casting-button-label =
    .aria-label = Trasmetti a schermo
videocontrols-closed-caption-off =
    .offlabel = Disattivati

# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Picture-in-Picture

# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Guarda con Picture-in-Picture
videocontrols-picture-in-picture-toggle-label2 = Sgancia questo video

# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Riproduci i video in primo piano mentre fai altre cose in { -brand-short-name }
videocontrols-picture-in-picture-explainer2 = Più sono gli schermi, maggiore è il divertimento. Riproduci questo video in Picture-in-Picture mentre navighi.

videocontrols-error-aborted = Il caricamento del video è stato interrotto.
videocontrols-error-network = La riproduzione del video è stata annullata a causa di un errore di rete.
videocontrols-error-decode = Il video non può essere riprodotto in quanto il file è danneggiato.
videocontrols-error-src-not-supported = Formato video o MIME type non supportato.
videocontrols-error-no-source = Non è stato trovato alcun video con formato o MIME type supportati.
videocontrols-error-generic = La riproduzione del video è stata annullata a causa di un errore sconosciuto.
videocontrols-status-picture-in-picture = Questo video è riprodotto in modalità Picture-in-Picture.

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
