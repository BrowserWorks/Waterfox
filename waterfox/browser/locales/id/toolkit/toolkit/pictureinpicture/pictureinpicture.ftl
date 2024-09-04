# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = Gambar-dalam-Gambar

## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.
##
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

pictureinpicture-pause-btn =
    .aria-label = Tunda
    .tooltip = Tunda (Spacebar)
pictureinpicture-play-btn =
    .aria-label = Mainkan
    .tooltip = Mainkan (Spacebar)

pictureinpicture-mute-btn =
    .aria-label = Senyap
    .tooltip = Senyap ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = Suarakan
    .tooltip = Suarakan ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = Kirim kembali ke tab
    .tooltip = Kembali ke tab

pictureinpicture-close-btn =
    .aria-label = Tutup
    .tooltip = Tutup ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = Subtitel
    .tooltip = Subtitel

##

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = Mundur
    .tooltip = Mundur (←)

pictureinpicture-seekforward-btn =
    .aria-label = Maju
    .tooltip = Maju (→)

##

pictureinpicture-subtitles-label = Subtitel

pictureinpicture-font-size-label = Ukuran fon

pictureinpicture-font-size-small = Kecil

pictureinpicture-font-size-medium = Sedang

pictureinpicture-font-size-large = Besar
