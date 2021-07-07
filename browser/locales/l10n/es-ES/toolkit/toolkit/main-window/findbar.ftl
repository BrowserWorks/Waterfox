# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Encontrar la siguiente aparición de la frase
findbar-previous =
    .tooltiptext = Encontrar la anterior aparición de la frase

findbar-find-button-close =
    .tooltiptext = Cerrar barra de búsqueda

findbar-highlight-all2 =
    .label = Resaltar todo
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Resaltar todas las ocurrencias de la frase

findbar-case-sensitive =
    .label = Coincidencia de mayúsculas/minúsculas
    .accesskey = C
    .tooltiptext = Buscar distinguiendo mayús./minús.

findbar-match-diacritics =
    .label = Coincidir diacríticos
    .accesskey = o
    .tooltiptext = Distingue entre letras con acentos y sus letras base (por ejemplo, al buscar por "como", "cómo" no coincidirá  y por lo tanto no aparecerá)

findbar-entire-word =
    .label = Palabras completas
    .accesskey = P
    .tooltiptext = Buscar palabras completas únicamente
