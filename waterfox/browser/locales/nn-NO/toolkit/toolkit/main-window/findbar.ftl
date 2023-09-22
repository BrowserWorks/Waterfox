# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Finn neste førekomst av frasen
findbar-previous =
    .tooltiptext = Finn førre førekomst av frasen

findbar-find-button-close =
    .tooltiptext = Lat att søkjelinja

findbar-highlight-all2 =
    .label = Marker alle
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Marker alle førekomstar av frasen

findbar-case-sensitive =
    .label = Skil mellom store og små bokstavar
    .accesskey = k
    .tooltiptext = Skil mellom store og små bokstavar i søket

findbar-match-diacritics =
    .label = Samsvar diakritiske teikn
    .accesskey = i
    .tooltiptext = Skille mellom aksentbokstavar og deira grunnleggande bokstaver (til dømes når du søkjer etter «alle», vil ikkje «allé» samsvarast)

findbar-entire-word =
    .label = Heile ord
    .accesskey = H
    .tooltiptext = Søk berre etter heile ord

findbar-not-found = Fann ikkje frasen

findbar-wrapped-to-top = Nådde botnen av sida, held fram frå toppen
findbar-wrapped-to-bottom = Nådde toppen av sida, held fram frå botnen

findbar-normal-find =
    .placeholder = Søk på sida
findbar-fast-find =
    .placeholder = Snøggsøk
findbar-fast-find-links =
    .placeholder = Snøggsøk (berre lenkjer)

findbar-case-sensitive-status =
    .value = (Skil mellom store og små bokstavar)
findbar-match-diacritics-status =
    .value = (Samsvar diakritiske teikn)
findbar-entire-word-status =
    .value = (Berre heile ord)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } av { $total } treff
           *[other] { $current } av { $total } treff
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Meir enn { $limit } treff
           *[other] Meir enn { $limit } treff
        }
