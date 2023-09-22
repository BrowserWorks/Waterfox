# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Hitta nästa förekomst av frasen
findbar-previous =
    .tooltiptext = Hitta föregående förekomst av frasen

findbar-find-button-close =
    .tooltiptext = Stäng sökfältet

findbar-highlight-all2 =
    .label = Markera alla
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Markera alla förekomster av frasen

findbar-case-sensitive =
    .label = Matcha VERSALER/gemener
    .accesskey = c
    .tooltiptext = Sök skiftlägeskänsligt

findbar-match-diacritics =
    .label = Matcha diakritiska tecken
    .accesskey = k
    .tooltiptext = Skillnaden mellan accentbokstäver och deras basbokstäver (till exempel när du söker efter "ide", kommer inte "idé" att matchas)

findbar-entire-word =
    .label = Hela ord
    .accesskey = H
    .tooltiptext = Sök endast hela ord

findbar-not-found = Frasen hittades inte

findbar-wrapped-to-top = Kommit till slutet på sidan, börjat om
findbar-wrapped-to-bottom = Kommit till början på sidan, börjat om

findbar-normal-find =
    .placeholder = Sök på sidan
findbar-fast-find =
    .placeholder = Snabbsök
findbar-fast-find-links =
    .placeholder = Snabbsök (endast länkar)

findbar-case-sensitive-status =
    .value = (Skiftlägeskänslig)
findbar-match-diacritics-status =
    .value = (Matchande diakritik)
findbar-entire-word-status =
    .value = (Endast hela ord)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } matchning av { $total }
           *[other] { $current } matchning av { $total }
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Mer än { $limit } matchning
           *[other] Mer än { $limit } matchningar
        }
