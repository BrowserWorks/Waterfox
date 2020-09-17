# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Färger
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Text och bakgrund

text-color-label =
    .value = Text:
    .accesskey = t

background-color-label =
    .value = Bakgrund:
    .accesskey = b

use-system-colors =
    .label = Använd systemets färger
    .accesskey = s

colors-link-legend = Länkfärger

link-color-label =
    .value = Obesökta länkar:
    .accesskey = o

visited-link-color-label =
    .value = Besökta länkar:
    .accesskey = b

underline-link-checkbox =
    .label = Understrukna länkar
    .accesskey = u

override-color-label =
    .value = Överskrid färgerna som specificeras av innehållet med inställningarna ovan:
    .accesskey = v

override-color-always =
    .label = Alltid

override-color-auto =
    .label = Endast med teman med hög kontrast

override-color-never =
    .label = Aldrig
