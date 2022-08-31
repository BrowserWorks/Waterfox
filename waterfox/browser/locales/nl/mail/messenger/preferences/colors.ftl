# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Kleuren
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 46em !important
        }

colors-dialog-legend = Tekst en achtergrond

text-color-label =
    .value = Tekst:
    .accesskey = T

background-color-label =
    .value = Achtergrond:
    .accesskey = a

use-system-colors =
    .label = Systeemkleuren gebruiken
    .accesskey = S

colors-link-legend = Koppelingskleuren

link-color-label =
    .value = Niet-bezochte koppelingen:
    .accesskey = N

visited-link-color-label =
    .value = Bezochte koppelingen:
    .accesskey = B

underline-link-checkbox =
    .label = Koppelingen onderstrepen
    .accesskey = K

override-color-label =
    .value = De door de inhoud opgegeven kleuren overschrijven met mijn selecties hierboven:
    .accesskey = D

override-color-always =
    .label = Altijd

override-color-auto =
    .label = Alleen bij thema’s met hoog contrast

override-color-never =
    .label = Nooit
