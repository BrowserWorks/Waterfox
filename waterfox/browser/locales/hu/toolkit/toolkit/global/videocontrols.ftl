# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Betöltés:
videocontrols-volume-control =
    .aria-label = Hangerő
videocontrols-closed-caption-button =
    .aria-label = Feliratok

videocontrols-play-button =
    .aria-label = Lejátszás
videocontrols-pause-button =
    .aria-label = Szünet
videocontrols-mute-button =
    .aria-label = Némítás
videocontrols-unmute-button =
    .aria-label = Hang be
videocontrols-enterfullscreen-button =
    .aria-label = Teljes képernyős üzemmód
videocontrols-exitfullscreen-button =
    .aria-label = Kilépés a teljes képernyős módból
videocontrols-casting-button-label =
    .aria-label = Képernyőre vetítés
videocontrols-closed-caption-off =
    .offlabel = Ki

# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Kép a képben

# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Videó kipattintása

videocontrols-picture-in-picture-explainer3 = Több képernyő, több szórakozás. Játssza le ezt a videót, miközben mást csinál.

videocontrols-error-aborted = A videó betöltése leállt.
videocontrols-error-network = A videólejátszás leállt hálózati hiba miatt.
videocontrols-error-decode = A videót nem lehet lejátszani, mert a fájl sérült.
videocontrols-error-src-not-supported = A videó formátuma vagy MIME-típusa nem támogatott.
videocontrols-error-no-source = Nincs támogatott formátumú vagy MIME-típusú videó.
videocontrols-error-generic = A videólejátszás leállt ismeretlen hiba miatt.
videocontrols-status-picture-in-picture = Ez a videó kép a képben módban van lejátszva.

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

# This is a plain text version of the videocontrols-position-and-duration-labels
# string, used by screenreaders.
#
# Variables:
#   $position (String): The current media position
#   $duration (String): The total video duration
videocontrols-scrubber-position-and-duration =
    .aria-label = Pozíció
    .aria-valuetext = { $position } / { $duration }
