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

colors-dialog-legend = Texto e fundo

text-color-label =
    .value = Texto:
    .accesskey = t

background-color-label =
    .value = Fundo:
    .accesskey = d

use-system-colors =
    .label = Utilizar cores do sistema
    .accesskey = s

colors-link-legend = Cores das ligações

link-color-label =
    .value = Ligações não visitadas:
    .accesskey = L

visited-link-color-label =
    .value = Ligações visitadas:
    .accesskey = v

underline-link-checkbox =
    .label = Ligações sublinhadas
    .accesskey = u

override-color-label =
    .value = Sobrepor as cores especificadas pelo conteúdo com as minhas seleções acima:
    .accesskey = a

override-color-always =
    .label = Sempre

override-color-auto =
    .label = Apenas para temas de alto contraste

override-color-never =
    .label = Nunca
