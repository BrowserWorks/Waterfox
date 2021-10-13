# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Barvy
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Text a pozadí

text-color-label =
    .value = Text:
    .accesskey = T

background-color-label =
    .value = Pozadí:
    .accesskey = P

use-system-colors =
    .label = Použít systémové barvy
    .accesskey = s

colors-link-legend = Barvy odkazů

link-color-label =
    .value = Nenavštívené odkazy:
    .accesskey = N

visited-link-color-label =
    .value = Navštívené odkazy:
    .accesskey = o

underline-link-checkbox =
    .label = Podtrhávat odkazy
    .accesskey = d

override-color-label =
    .value = Použít mnou nastavené barvy místo definovaných obsahem:
    .accesskey = m

override-color-always =
    .label = Vždy

override-color-auto =
    .label = Pouze pro vzhledy s vysokým kontrastem

override-color-never =
    .label = Nikdy
