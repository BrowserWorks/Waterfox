# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Position
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Indlæser:
videocontrols-volume-control =
    .aria-label = Lydstyrke
videocontrols-closed-caption-button =
    .aria-label = Undertekster

videocontrols-play-button =
    .aria-label = Afspil
videocontrols-pause-button =
    .aria-label = Pause
videocontrols-mute-button =
    .aria-label = Slå lyd fra
videocontrols-unmute-button =
    .aria-label = Slå lyd til
videocontrols-enterfullscreen-button =
    .aria-label = Fuld skærm
videocontrols-exitfullscreen-button =
    .aria-label = Afslut fuld skærm
videocontrols-casting-button-label =
    .aria-label = Cast til skærm
videocontrols-closed-caption-off =
    .offlabel = Slået fra

# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Billede-i-billede

# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Se billede-i-billede

# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Afspil videoer i forgrunden, mens du gør andre ting i { -brand-short-name }

videocontrols-error-aborted = Indlæsning af video stoppet.
videocontrols-error-network = Afspilning af video stoppet på grund af en netværksfejl.
videocontrols-error-decode = Videoen kan ikke afspilles fordi filen er ødelagt.
videocontrols-error-src-not-supported = Videoformat eller MIME-type understøttes ikke.
videocontrols-error-no-source = Ingen videokilde med understøttet MIME-type fundet.
videocontrols-error-generic = Afspilning af video  stoppet på grund af ukendt fejl.
videocontrols-status-picture-in-picture = Denne video afspilles i tilstanden billede-i-billede.

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
