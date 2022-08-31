# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Posisi
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Memuat:
videocontrols-volume-control =
    .aria-label = Volume
videocontrols-closed-caption-button =
    .aria-label = Takarir Tertutup
videocontrols-play-button =
    .aria-label = Mainkan
videocontrols-pause-button =
    .aria-label = Tunda
videocontrols-mute-button =
    .aria-label = Senyap
videocontrols-unmute-button =
    .aria-label = Keraskan
videocontrols-enterfullscreen-button =
    .aria-label = Layar Penuh
videocontrols-exitfullscreen-button =
    .aria-label = Keluar dari Layar Penuh
videocontrols-casting-button-label =
    .aria-label = Proyeksikan ke Layar
videocontrols-closed-caption-off =
    .offlabel = Mati
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Gambar-dalam-gambar
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Tonton dalam format Gambar-dalam-Gambar
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Putar video di latar depan saat Anda melakukan hal lain di { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Munculkan video ini
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Lebih banyak layar lebih menyenangkan. Putar video ini dalam Gambar-dalam-Gambar saat menjelajah.
videocontrols-error-aborted = Pemuatan video dihentikan.
videocontrols-error-network = Pemutaran video dibatalkan karena ada galat jaringan.
videocontrols-error-decode = Video tidak dapat diputar karena berkasnya rusak.
videocontrols-error-src-not-supported = Format atau jenis MIME video tidak dudukung.
videocontrols-error-no-source = Tidak ditemukan video dalam format atau jenis MIME yang didukung.
videocontrols-error-generic = Pemutaran video dibatalkan karena galat tidak dikenal.
videocontrols-status-picture-in-picture = Video ini diputar dalam mode Gambar-dalam-Gambar.
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
