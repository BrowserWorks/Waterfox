# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Buscar la siguiente aparición de la frase
findbar-previous =
    .tooltiptext = Buscar la aparición anterior de la frase

findbar-find-button-close =
    .tooltiptext = Cerrar Barra de Búsqueda

findbar-highlight-all2 =
    .label = Destacar todo
    .accesskey =
        { PLATFORM() ->
            [macos] s
           *[other] a
        }
    .tooltiptext = Destacar todas las ocurrencias de la frase

findbar-case-sensitive =
    .label = Coincidir mayúsculas/minúsculas
    .accesskey = C
    .tooltiptext = Buscar con sensibilidad por las mayúsculas

findbar-match-diacritics =
    .label = Coincidir diacríticos
    .accesskey = o
    .tooltiptext = Distingue entre letras con acentos y sus letras base (por ejemplo, al buscar por "como", "cómo" no coincidirá  y por lo tanto no aparecerá)

findbar-entire-word =
    .label = Palabras completas
    .accesskey = b
    .tooltiptext = Buscar solo palabras completas
