# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Värvid
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Tekst ja taust

text-color-label =
    .value = Tekst:
    .accesskey = t

background-color-label =
    .value = Taust:
    .accesskey = a

use-system-colors =
    .label = Kasutatakse süsteemseid värve
    .accesskey = K

colors-link-legend = Linkide värvid

link-color-label =
    .value = Külastamata lingid:
    .accesskey = m

visited-link-color-label =
    .value = Külastatud lingid:
    .accesskey = u

underline-link-checkbox =
    .label = Allajoonitud lingid
    .accesskey = l

override-color-label =
    .value = Ülalolevaid määranguid kasutatakse sisu värvide asemel:
    .accesskey = l

override-color-always =
    .label = alati

override-color-auto =
    .label = ainult koos suure kontrastiga teemadega

override-color-never =
    .label = mitte kunagi
