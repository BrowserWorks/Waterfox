# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Spalvos
    .style =
        { PLATFORM() ->
            [macos] width: 45em !important
           *[other] width: 42em !important
        }

colors-dialog-legend = Tekstas ir fonas

text-color-label =
    .value = Tekstas:
    .accesskey = T

background-color-label =
    .value = Fonas:
    .accesskey = F

use-system-colors =
    .label = Spalvas imti iš operacinės sistemos
    .accesskey = o

colors-link-legend = Saitų spalvos

link-color-label =
    .value = nelankytų:
    .accesskey = n

visited-link-color-label =
    .value = aplankytų:
    .accesskey = a

underline-link-checkbox =
    .label = Saitus pabraukti
    .accesskey = b

override-color-label =
    .value = Pakeisti puslapio siūlomas spalvas mano pasirinktomis:
    .accesskey = P

override-color-always =
    .label = visada

override-color-auto =
    .label = Tik naudojant kontrastingus grafinius apvalkalus

override-color-never =
    .label = niekada
