# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Wczytywanie:
videocontrols-volume-control =
    .aria-label = Głośność
videocontrols-closed-caption-button =
    .aria-label = Napisy

videocontrols-play-button =
    .aria-label = Odtwórz
videocontrols-pause-button =
    .aria-label = Wstrzymaj
videocontrols-mute-button =
    .aria-label = Wycisz
videocontrols-unmute-button =
    .aria-label = Włącz dźwięk
videocontrols-enterfullscreen-button =
    .aria-label = Tryb pełnoekranowy
videocontrols-exitfullscreen-button =
    .aria-label = Opuść tryb pełnoekranowy
videocontrols-casting-button-label =
    .aria-label = Wyślij na inne urządzenie
videocontrols-closed-caption-off =
    .offlabel = Wyłączone

# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Obraz w obrazie

# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Wyciągnij to wideo

videocontrols-picture-in-picture-explainer3 = Więcej ekranów to więcej zabawy. Oglądaj ten film, robiąc coś innego.

videocontrols-error-aborted = Wczytywanie wideo przerwane.
videocontrols-error-network = Odtwarzanie wideo przerwane z powodu błędu sieci.
videocontrols-error-decode = Nie można odtworzyć wideo, ponieważ plik jest uszkodzony.
videocontrols-error-src-not-supported = Nieobsługiwany format wideo lub typ MIME.
videocontrols-error-no-source = Nie odnaleziono wideo w obsługiwanym formacie i typie MIME.
videocontrols-error-generic = Odtwarzanie wideo przerwane z powodu nieznanego błędu.
videocontrols-status-picture-in-picture = To wideo jest odtwarzane w trybie „Obraz w obrazie”.

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
    .aria-label = Pozycja
    .aria-valuetext = { $position } / { $duration }
