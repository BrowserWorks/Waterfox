# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Position
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Wird geladen:
videocontrols-volume-control =
    .aria-label = Lautstärke
videocontrols-closed-caption-button =
    .aria-label = Untertitel
videocontrols-play-button =
    .aria-label = Abspielen
videocontrols-pause-button =
    .aria-label = Anhalten
videocontrols-mute-button =
    .aria-label = Ton aus
videocontrols-unmute-button =
    .aria-label = Ton an
videocontrols-enterfullscreen-button =
    .aria-label = Vollbild
videocontrols-exitfullscreen-button =
    .aria-label = Vollbild-Modus verlassen
videocontrols-casting-button-label =
    .aria-label = An Bildschirm weiterleiten
videocontrols-closed-caption-off =
    .offlabel = Keine
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Bild-im-Bild (PiP)
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = In Bild-im-Bild ansehen
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Spielen Sie Videos im Vordergrund ab, während Sie anderweitig in { -brand-short-name } beschäftigt sind
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Dieses Video herausholen
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Mehr Bildschirme machen mehr Spaß. Dieses Video in Bild-im-Bild abspielen, während Sie surfen.
videocontrols-error-aborted = Laden des Videos gestoppt.
videocontrols-error-network = Abspielen des Videos wegen eines Netzwerkfehlers abgebrochen.
videocontrols-error-decode = Video kann nicht abgespielt werden, weil die Datei beschädigt ist.
videocontrols-error-src-not-supported = Video-Format oder MIME-Typ wird nicht unterstützt.
videocontrols-error-no-source = Kein Video mit unterstütztem Format und MIME-Typ gefunden.
videocontrols-error-generic = Abspielen des Videos wegen eines unbekannten Fehlers abgebrochen.
videocontrols-status-picture-in-picture = Dieses Video wird im Modus "Bild im Bild" (PiP) wiedergegeben.
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
