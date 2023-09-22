# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Trova l’occorrenza successiva del testo da cercare
findbar-previous =
    .tooltiptext = Trova l’occorrenza precedente del testo da cercare

findbar-find-button-close =
    .tooltiptext = Chiudi la barra di ricerca

findbar-highlight-all2 =
    .label = Evidenzia
    .accesskey = n
    .tooltiptext = Evidenzia tutte le occorrenze del testo cercato

findbar-case-sensitive =
    .label = Maiuscole/minuscole
    .accesskey = M
    .tooltiptext = Distingui tra maiuscole e minuscole nella ricerca

findbar-match-diacritics =
    .label = Segni diacritici
    .accesskey = S
    .tooltiptext = Distingui le lettere accentate dai corrispondenti caratteri di base. Ad esempio: se si cerca “caffe”, “caffè” non verrà incluso nei risultati.

findbar-entire-word =
    .label = Parole intere
    .accesskey = P
    .tooltiptext = Cerca solo parole intere

findbar-not-found = Testo non trovato

findbar-wrapped-to-top = Fine della pagina raggiunta; si continua dall’inizio
findbar-wrapped-to-bottom = Inizio della pagina raggiunto; si continua dalla fine

findbar-normal-find =
    .placeholder = Trova nella pagina
findbar-fast-find =
    .placeholder = Ricerca rapida
findbar-fast-find-links =
    .placeholder = Ricerca rapida (solo link)

findbar-case-sensitive-status =
    .value = (Maiuscole/minuscole)
findbar-match-diacritics-status =
    .value = (Segni diacritici)
findbar-entire-word-status =
    .value = (Solo parole intere)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] Corrispondenza { $current } di { $total }
           *[other] Corrispondenza { $current } di { $total }
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Più di { $limit } corrispondenza
           *[other] Più di { $limit } corrispondenze
        }
