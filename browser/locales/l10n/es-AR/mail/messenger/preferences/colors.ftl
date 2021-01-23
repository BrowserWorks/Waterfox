# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Colores
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Texto y fondo

text-color-label =
    .value = Texto:
    .accesskey = t

background-color-label =
    .value = Fondo:
    .accesskey = F

use-system-colors =
    .label = Usar colores del sistema
    .accesskey = s

colors-link-legend = Color de enlaces

link-color-label =
    .value = Enlaces no visitados:
    .accesskey = l

visited-link-color-label =
    .value = Enlaces visitados:
    .accesskey = v

underline-link-checkbox =
    .label = Enlaces subrayados
    .accesskey = u

override-color-label =
    .value = Anular los colores especificados por el contenido con mis selecciones:
    .accesskey = o

override-color-always =
    .label = Siempre

override-color-auto =
    .label = Solamente con temas de alto contraste

override-color-never =
    .label = Nunca
