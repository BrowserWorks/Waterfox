# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Farby
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 39em !important
        }

colors-dialog-legend = Text a pozadie

text-color-label =
    .value = Text:
    .accesskey = T

background-color-label =
    .value = Pozadie:
    .accesskey = z

use-system-colors =
    .label = Použiť systémové farby
    .accesskey = s

colors-link-legend = Farby odkazov

link-color-label =
    .value = Nenavštívené odkazy:
    .accesskey = e

visited-link-color-label =
    .value = Navštívené odkazy:
    .accesskey = v

underline-link-checkbox =
    .label = Podčiarkovať odkazy
    .accesskey = d

override-color-label =
    .value = Použiť mnou definované farby namiesto tých, ktoré sú definované v obsahu:
    .accesskey = o

override-color-always =
    .label = Vždy

override-color-auto =
    .label = Len pre témy s vysokým kontrastom

override-color-never =
    .label = Nikdy
