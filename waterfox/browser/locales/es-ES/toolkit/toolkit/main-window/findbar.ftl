# This Source Code Form is subject to the terms of the BrowserWorks Public
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

findbar-not-found = No se encontró la frase

findbar-wrapped-to-top = Se alcanzó el final de la página, se continúa desde el principio
findbar-wrapped-to-bottom = Se alcanzó el principio de la página, se continúa desde el final

findbar-normal-find =
    .placeholder = Buscar en la página
findbar-fast-find =
    .placeholder = Búsqueda rápida
findbar-fast-find-links =
    .placeholder = Búsqueda rápida (sólo en enlaces)

findbar-case-sensitive-status =
    .value = (Sensible a mayúsculas)
findbar-match-diacritics-status =
    .value = (coincidencia de diacrícitos)
findbar-entire-word-status =
    .value = (solo palabras completas)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } de { $total } acierto
           *[other] { $current } de { $total } aciertos
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Más de { $limit } acierto
           *[other] Más de { $limit } aciertos
        }
