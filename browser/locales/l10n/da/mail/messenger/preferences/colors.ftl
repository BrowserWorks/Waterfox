# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Farver
    .style =
        { PLATFORM() ->
            [macos] width: 47em !important
           *[other] width: 47em !important
        }

colors-dialog-legend = Tekst og baggrund

text-color-label =
    .value = Tekst:
    .accesskey = T

background-color-label =
    .value = Baggrund:
    .accesskey = B

use-system-colors =
    .label = Anvend systemfarver
    .accesskey = s

colors-link-legend = Linkfarver

link-color-label =
    .value = Ubesøgte links:
    .accesskey = U

visited-link-color-label =
    .value = Besøgte links:
    .accesskey = e

underline-link-checkbox =
    .label = Understreg links
    .accesskey = n

override-color-label =
    .value = Tilsidesæt de angivne farver i indholdet og brug i stedet mine valg ovenfor:
    .accesskey = i

override-color-always =
    .label = Altid

override-color-auto =
    .label = Kun ved temaer med høj kontrast

override-color-never =
    .label = Aldrig
