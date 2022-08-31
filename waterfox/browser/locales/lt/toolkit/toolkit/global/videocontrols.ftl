# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Padėtis
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Įkeliama:
videocontrols-volume-control =
    .aria-label = Garsas
videocontrols-closed-caption-button =
    .aria-label = Titrai

videocontrols-play-button =
    .aria-label = Groti
videocontrols-pause-button =
    .aria-label = Pristabdyti
videocontrols-mute-button =
    .aria-label = Išjungti garsą
videocontrols-unmute-button =
    .aria-label = Įjungti garsą
videocontrols-enterfullscreen-button =
    .aria-label = Visas ekranas
videocontrols-exitfullscreen-button =
    .aria-label = Normalioji veiksena
videocontrols-casting-button-label =
    .aria-label = Nukreipti į ekraną
videocontrols-closed-caption-off =
    .offlabel = Išjungta

# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Vaizdas-vaizde

# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Žiūrėti per vaizdą-vaizde

# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Grokite vaizdo įrašus virš visko, kai darote kažką kito su „{ -brand-short-name }“

videocontrols-error-aborted = Vaizdo įkėlimas sustabdytas.
videocontrols-error-network = Vaizdo atkūrimas nutrauktas dėl tinklo klaidos.
videocontrols-error-decode = Vaizdo leisti neįmanoma, nes failas sugadintas.
videocontrols-error-src-not-supported = Vaizdo formatas arba MIME tipas nepalaikomas.
videocontrols-error-no-source = Nerastas palaikomo formato ir MIME tipo vaizdas.
videocontrols-error-generic = Vaizdo atkūrimas nutrauktas dėl nežinomos klaidos.
videocontrols-status-picture-in-picture = Šis vaizdo įrašas groja vaizdas-vaizde veiksenoje.

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
