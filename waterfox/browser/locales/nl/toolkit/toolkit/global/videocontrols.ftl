# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Positie
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Laden:
videocontrols-volume-control =
    .aria-label = Volume
videocontrols-closed-caption-button =
    .aria-label = Ondertitels
videocontrols-play-button =
    .aria-label = Afspelen
videocontrols-pause-button =
    .aria-label = Pauzeren
videocontrols-mute-button =
    .aria-label = Dempen
videocontrols-unmute-button =
    .aria-label = Dempen opheffen
videocontrols-enterfullscreen-button =
    .aria-label = Volledig scherm
videocontrols-exitfullscreen-button =
    .aria-label = Volledig scherm verlaten
videocontrols-casting-button-label =
    .aria-label = Casten naar scherm
videocontrols-closed-caption-off =
    .offlabel = Uit
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Picture-in-picture
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Picture-in-picture bekijken
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Video’s op de voorgrond afspelen terwijl u andere dingen in { -brand-short-name } doet
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Deze video naar voren halen
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Meer schermen is leuker. Speel deze video af in Picture-in-picture terwijl u navigeert.
videocontrols-error-aborted = Video laden gestopt.
videocontrols-error-network = Video afspelen afgebroken vanwege een netwerkfout.
videocontrols-error-decode = Video kan niet worden afgespeeld, omdat het bestand is beschadigd.
videocontrols-error-src-not-supported = Video-indeling of MIME-type wordt niet ondersteund.
videocontrols-error-no-source = Geen video met ondersteunde indeling en MIME-type gevonden.
videocontrols-error-generic = Video afspelen afgebroken vanwege een onbekende fout.
videocontrols-status-picture-in-picture = Deze video wordt in Picture-in-picture-modus afgespeeld.
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
