# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Colores
    .style =
        { PLATFORM() ->
            [macos] width: 47em !important
           *[other] width: 45em !important
        }

colors-dialog-legend = Texto y fondo

text-color-label =
    .value = Texto:
    .accesskey = T

background-color-label =
    .value = Fondo:
    .accesskey = F

use-system-colors =
    .label = Usar los colores del sistema
    .accesskey = U

colors-link-legend = Color de los enlaces

link-color-label =
    .value = Enlaces sin visitar:
    .accesskey = E

visited-link-color-label =
    .value = Enlaces visitados:
    .accesskey = a

underline-link-checkbox =
    .label = Subrayar enlaces
    .accesskey = S

override-color-label =
    .value = Reemplazar los colores especificados por el contenido con mis selecciones de arriba:
    .accesskey = R

override-color-always =
    .label = Siempre

override-color-auto =
    .label = Solo con temas de alto contraste

override-color-never =
    .label = Nunca
