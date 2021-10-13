# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Colori
    .style =
        { PLATFORM() ->
            [macos] width: 45em !important
           *[other] width: 44em !important
        }

colors-dialog-legend = Testo e sfondo

text-color-label =
    .value = Testo:
    .accesskey = T

background-color-label =
    .value = Sfondo:
    .accesskey = S

use-system-colors =
    .label = Utilizza colori personalizzati
    .accesskey = U

colors-link-legend = Colori dei link

link-color-label =
    .value = Link non visitati:
    .accesskey = l

visited-link-color-label =
    .value = Link visitati:
    .accesskey = V

underline-link-checkbox =
    .label = Sottolinea i link
    .accesskey = o

override-color-label =
    .value = Sostituisci i colori specificati nella pagina con quelli selezionati:
    .accesskey = n

override-color-always =
    .label = Sempre

override-color-auto =
    .label = Solo con temi a contrasto elevato

override-color-never =
    .label = Mai
