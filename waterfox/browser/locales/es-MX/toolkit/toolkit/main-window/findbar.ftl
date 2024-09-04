# This Source Code Form is subject to the terms of the BrowserWorks Public
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

findbar-not-found = No se encontró la frase

findbar-wrapped-to-top = Final de la página, se continúa desde el inicio
findbar-wrapped-to-bottom = Inicio de la página, se continúa desde el final

findbar-normal-find =
    .placeholder = Buscar en la página
findbar-fast-find =
    .placeholder = Búsqueda rápida
findbar-fast-find-links =
    .placeholder = Búsqueda rápida (enlaces)

findbar-case-sensitive-status =
    .value = (Sensible a mayúsculas)
findbar-match-diacritics-status =
    .value = (Coincidencia de diacrícitos)
findbar-entire-word-status =
    .value = (Solo palabras completas)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } de { $total } coincidencia
           *[other] { $current } de { $total } coincidencias
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Más de { $limit } coincidencia
           *[other] Más de { $limit } coincidencias
        }
