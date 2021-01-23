# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Farger
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
    .label = Bruk systemfarger
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
    .value = Overstyr fargene som oppgis av innholdet med valgene mine ovenfor:
    .accesskey = O

override-color-always =
    .label = Alltid

override-color-auto =
    .label = Bare ved bruk av høykontrast-temaer

override-color-never =
    .label = Aldri
