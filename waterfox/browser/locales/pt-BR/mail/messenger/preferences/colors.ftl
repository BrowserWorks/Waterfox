# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Cores
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Cores padrão

text-color-label =
    .value = Texto:
    .accesskey = T

background-color-label =
    .value = Fundo:
    .accesskey = F

use-system-colors =
    .label = Usar cores do sistema
    .accesskey = a

colors-link-legend = Aparência padrão dos links

link-color-label =
    .value = Não visitados:
    .accesskey = N

visited-link-color-label =
    .value = Visitados:
    .accesskey = V

underline-link-checkbox =
    .label = Sublinhar
    .accesskey = S

override-color-label =
    .value = Substituir as cores que o conteúdo especifica pelas escolhas acima:
    .accesskey = S

override-color-always =
    .label = Sempre

override-color-auto =
    .label = Somente com temas de alto contraste

override-color-never =
    .label = Nunca
