# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Ir a la siguiente frase encontrada
findbar-previous =
    .tooltiptext = Ir a la anterior frase encontrada

findbar-find-button-close =
    .tooltiptext = Cerrar la barra de búsqueda

findbar-highlight-all2 =
    .label = Remarcar todo
    .accesskey =
        { PLATFORM() ->
            [macos] m
           *[other] a
        }
    .tooltiptext = Resaltar todas las apariciones de la frase

findbar-case-sensitive =
    .label = Sensible a mayúsculas
    .accesskey = m
    .tooltiptext = Buscar distinguiendo mayúsculas y minúsculas

findbar-match-diacritics =
    .label = Coincidir diacríticos
    .accesskey = o
    .tooltiptext = Distingue entre letras con acentos y sus letras base (por ejemplo, al buscar por "como", "cómo" no coincidirá  y por lo tanto no aparecerá)

findbar-entire-word =
    .label = Palabras completas
    .accesskey = P
    .tooltiptext = Buscar solo palabras completas
