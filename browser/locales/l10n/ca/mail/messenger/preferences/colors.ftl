# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Colors
    .style =
        { PLATFORM() ->
            [macos] width: 51em !important
           *[other] width: 48em !important
        }

colors-dialog-legend = Text i fons

text-color-label =
    .value = Text:
    .accesskey = T

background-color-label =
    .value = Fons:
    .accesskey = F

use-system-colors =
    .label = Utilitza els colors del sistema
    .accesskey = U

colors-link-legend = Colors dels enllaços

link-color-label =
    .value = Enllaços no visitats:
    .accesskey = l

visited-link-color-label =
    .value = Enllaços visitats:
    .accesskey = v

underline-link-checkbox =
    .label = Subratlla els enllaços
    .accesskey = S

override-color-label =
    .value = Sobreescriu els colors especificats pel contingut per la meva selecció:
    .accesskey = o

override-color-always =
    .label = Sempre

override-color-auto =
    .label = Només amb temes de contrast alt

override-color-never =
    .label = Mai
