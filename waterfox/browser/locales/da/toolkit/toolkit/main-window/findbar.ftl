# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Find den næste forekomst
findbar-previous =
    .tooltiptext = Find den forrige forekomst

findbar-find-button-close =
    .tooltiptext = Luk søgebjælke

findbar-highlight-all2 =
    .label = fremhæv alle
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Fremhæv alle forekomster

findbar-case-sensitive =
    .label = Forskel på store og små bogstaver
    .accesskey = o
    .tooltiptext = Søg med forskel på store og små bogstaver

findbar-match-diacritics =
    .label = Diakritiske tegn
    .accesskey = k
    .tooltiptext = Skeln mellem bogstaver med og uden accenttegn (når du fx søger efter "allé", bliver "alle" ikke fremhævet)

findbar-entire-word =
    .label = Hele ord
    .accesskey = e
    .tooltiptext = Søg kun efter hele ord

findbar-not-found = Der blev ikke fundet noget

findbar-wrapped-to-top = Bunden af siden blev nået, fortsatte fra toppen.
findbar-wrapped-to-bottom = Toppen af siden blev nået, fortsatte fra bunden.

findbar-normal-find =
    .placeholder = Find på siden
findbar-fast-find =
    .placeholder = Hurtig søgning
findbar-fast-find-links =
    .placeholder = Hurtig søgning (kun links)

findbar-case-sensitive-status =
    .value = (Versalfølsom)
findbar-match-diacritics-status =
    .value = (Diakritiske tegn)
findbar-entire-word-status =
    .value = (Kun hele ord)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } af { $total } forekomst
           *[other] { $current } af { $total } forekomster
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Mere end { $limit } forekomst
           *[other] Mere end { $limit } forekomster
        }
