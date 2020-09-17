# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Värit
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Tekstin ja taustan asetukset

text-color-label =
    .value = Teksti:
    .accesskey = T

background-color-label =
    .value = Tausta:
    .accesskey = u

use-system-colors =
    .label = Käytä järjestelmän värejä
    .accesskey = K

colors-link-legend = Linkkien värit

link-color-label =
    .value = Avaamattomat linkit:
    .accesskey = m

visited-link-color-label =
    .value = Avatut linkit:
    .accesskey = v

underline-link-checkbox =
    .label = Alleviivaa linkit
    .accesskey = A

override-color-label =
    .value = Korvaa sivun määrittelemät värit yllä olevilla valinnoilla:
    .accesskey = o

override-color-always =
    .label = Aina

override-color-auto =
    .label = Vain korkean kontrastin teemojen kanssa

override-color-never =
    .label = Ei koskaan
