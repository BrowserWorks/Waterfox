# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Position
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Laddar:
videocontrols-volume-control =
    .aria-label = Volym
videocontrols-closed-caption-button =
    .aria-label = Undertexter
videocontrols-play-button =
    .aria-label = Spela upp
videocontrols-pause-button =
    .aria-label = Pausa
videocontrols-mute-button =
    .aria-label = Ljud av
videocontrols-unmute-button =
    .aria-label = Ljud på
videocontrols-enterfullscreen-button =
    .aria-label = Helskärm
videocontrols-exitfullscreen-button =
    .aria-label = Avsluta helskärm
videocontrols-casting-button-label =
    .aria-label = Skicka till skärm
videocontrols-closed-caption-off =
    .offlabel = Av
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Bild-i-bild
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Titta med bild-i-bild
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Titta på video i förgrunden medan du gör andra saker med { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Lyft ut den här videon
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Fler skärmar är roligare. Spela upp den här videon i bild-i-bild medan du surfar.
videocontrols-error-aborted = Laddning av video stoppad.
videocontrols-error-network = Avspelning av videon avbröts på grund av nätverksfel.
videocontrols-error-decode = Video kan inte spelas eftersom filen är skadad.
videocontrols-error-src-not-supported = Videoformat eller MIME-typ stöds inte.
videocontrols-error-no-source = Hittade ingen video med ett format eller en MIME-typ som stöds.
videocontrols-error-generic = Avspelning av videon avbröts på grund av ett okänt fel.
videocontrols-status-picture-in-picture = Den här videon spelas upp i läget Bild-i-bild.
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
