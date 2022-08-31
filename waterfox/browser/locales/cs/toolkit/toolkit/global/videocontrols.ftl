# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Umístění
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Načítání:
videocontrols-volume-control =
    .aria-label = Hlasitost
videocontrols-closed-caption-button =
    .aria-label = Skryté titulky
videocontrols-play-button =
    .aria-label = Přehrát
videocontrols-pause-button =
    .aria-label = Pozastavit
videocontrols-mute-button =
    .aria-label = Vypnout zvuk
videocontrols-unmute-button =
    .aria-label = Zapnout zvuk
videocontrols-enterfullscreen-button =
    .aria-label = Celá obrazovka
videocontrols-exitfullscreen-button =
    .aria-label = Ukončit režim celé obrazovky
videocontrols-casting-button-label =
    .aria-label = Přehrát na obrazovce
videocontrols-closed-caption-off =
    .offlabel = Vypnuto
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Obraz v obraze
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Sledovat jako obraz v obraze
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer =
    { -brand-short-name.gender ->
        [masculine] Přehrávejte videa v popředí a zároveň dělejte ve { -brand-short-name(case: "loc") } klidně i něco jiného
        [feminine] Přehrávejte videa v popředí a zároveň dělejte v { -brand-short-name(case: "loc") } klidně i něco jiného
        [neuter] Přehrávejte videa v popředí a zároveň dělejte v { -brand-short-name(case: "loc") } klidně i něco jiného
       *[other] Přehrávejte videa v popředí a zároveň dělejte v aplikaci { -brand-short-name } klidně i něco jiného
    }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Zobrazit video v samostatném okně
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Více obrazovek, více zábavy. Sledujte toto video během prohlížení dalších stránek.
videocontrols-error-aborted = Nahrávání videa zastaveno.
videocontrols-error-network = Přehrávání videa selhalo z důvodu chyby sítě.
videocontrols-error-decode = Video nelze přehrát, protože soubor je poškozen.
videocontrols-error-src-not-supported = Formát nebo typ MIME videa není podporovaný.
videocontrols-error-no-source = Nebylo nalezeno žádné video s podporovaným formátem a typem MIME.
videocontrols-error-generic = Přehrávání videa selhalo z důvodu neznámé chyby.
videocontrols-status-picture-in-picture = Toto video se přehrává jako obraz v obraze.
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
