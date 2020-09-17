# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Színek
    .style =
        { PLATFORM() ->
            [macos] width: 55em !important
           *[other] width: 55em !important
        }

colors-dialog-legend = Szöveg és háttér

text-color-label =
    .value = Szöveg:
    .accesskey = S

background-color-label =
    .value = Háttér:
    .accesskey = H

use-system-colors =
    .label = Rendszerszínek használata
    .accesskey = R

colors-link-legend = Hivatkozás színei

link-color-label =
    .value = Nem látogatott hivatkozások:
    .accesskey = v

visited-link-color-label =
    .value = Látogatott hivatkozások:
    .accesskey = L

underline-link-checkbox =
    .label = Hivatkozások aláhúzása
    .accesskey = a

override-color-label =
    .value = A tartalom által megadott színek felülbírálása a fenti választásaimmal:
    .accesskey = t

override-color-always =
    .label = Mindig

override-color-auto =
    .label = Csak nagy kontrasztú témáknál

override-color-never =
    .label = Soha
