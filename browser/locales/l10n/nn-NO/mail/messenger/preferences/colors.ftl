# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Fargar
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Tekst og bakgrunn

text-color-label =
    .value = Tekst:
    .accesskey = t

background-color-label =
    .value = Bakgrunn:
    .accesskey = B

use-system-colors =
    .label = Bruk systemfargar
    .accesskey = s

colors-link-legend = Lenkefarger

link-color-label =
    .value = Ubesøkte lenker:
    .accesskey = U

visited-link-color-label =
    .value = Besøkte lenker:
    .accesskey = s

underline-link-checkbox =
    .label = Understrek lenker
    .accesskey = U

override-color-label =
    .value = Overstyr fargane spesifiserte av innhaldet med vala mine ovanfor:
    .accesskey = O

override-color-always =
    .label = Alltid

override-color-auto =
    .label = Berre ved bruk av høgkontrast-tema

override-color-never =
    .label = Aldri
