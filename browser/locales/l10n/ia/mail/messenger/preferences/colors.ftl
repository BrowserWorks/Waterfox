# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Colores
    .style =
        { PLATFORM() ->
            [macos] width: 45em !important
           *[other] width: 44em !important
        }

colors-dialog-legend = Texto e fundo

text-color-label =
    .value = Texto:
    .accesskey = T

background-color-label =
    .value = Fundo:
    .accesskey = F

use-system-colors =
    .label = Usar le colores del systema
    .accesskey = s

colors-link-legend = Colores de ligamines

link-color-label =
    .value = Ligamines non visitate:
    .accesskey = L

visited-link-color-label =
    .value = Ligamines visitate:
    .accesskey = V

underline-link-checkbox =
    .label = Sublinear ligamines
    .accesskey = S

override-color-label =
    .value = Substituer le colores specificate per le contento con mi selectiones supra:
    .accesskey = S

override-color-always =
    .label = Sempre

override-color-auto =
    .label = Solmente con themas de alte contrasto

override-color-never =
    .label = Nunquam
