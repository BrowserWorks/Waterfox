# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Cores
    .style =
        { PLATFORM() ->
            [macos] width: 47em !important
           *[other] width: 45em !important
        }

colors-dialog-legend = Texto e fondo

text-color-label =
    .value = Texto:
    .accesskey = T

background-color-label =
    .value = Fondo:
    .accesskey = F

use-system-colors =
    .label = Usar as cores do sistema
    .accesskey = s

colors-link-legend = Cores das ligazóns

link-color-label =
    .value = Ligazóns non visitadas:
    .accesskey = L

visited-link-color-label =
    .value = Ligazóns visitadas:
    .accesskey = v

underline-link-checkbox =
    .label = Subliñar as ligazóns
    .accesskey = u

override-color-label =
    .value = Substituír as cores especificadas polo contido coas seleccionadas anteriormente:
    .accesskey = o

override-color-always =
    .label = Sempre

override-color-auto =
    .label = Só con temas de alto contraste

override-color-never =
    .label = Nunca
