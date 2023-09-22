# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Najde další výskyt hledaného textu
findbar-previous =
    .tooltiptext = Najde předchozí výskyt hledaného textu

findbar-find-button-close =
    .tooltiptext = Zavře lištu hledání

findbar-highlight-all2 =
    .label = Zvýraznit vše
    .accesskey =
        { PLATFORM() ->
            [macos] Z
           *[other] a
        }
    .tooltiptext = Zvýrazní všechny výskyty hledaného textu

findbar-case-sensitive =
    .label = Rozlišovat velikost
    .accesskey = R
    .tooltiptext = Zohlední se velikost písmen

findbar-match-diacritics =
    .label = Rozlišovat diakritiku
    .accesskey = i
    .tooltiptext = Zohlední rozdíl mezi písmeny s a bez háčků a čárek (např. při hledání slova „být“ nebude nalezeno slovo „byt“)

findbar-entire-word =
    .label = Celá slova
    .accesskey = C
    .tooltiptext = Najde pouze celá slova

findbar-not-found = Hledaný text nenalezen

findbar-wrapped-to-top = Dosažen konec stránky, pokračuje se od začátku
findbar-wrapped-to-bottom = Dosažen začátek stránky, pokračuje se od konce

findbar-normal-find =
    .placeholder = Najít na stránce
findbar-fast-find =
    .placeholder = Rychlé hledání
findbar-fast-find-links =
    .placeholder = Rychlé hledání (pouze odkazy)

findbar-case-sensitive-status =
    .value = (Rozlišovat velikost písmen)
findbar-match-diacritics-status =
    .value = (Rozlišovat diakritiku)
findbar-entire-word-status =
    .value = (Pouze celá slova)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current }. z { $total } výskytu
            [few] { $current }. z { $total } výskytů
           *[other] { $current }. z { $total } výskytů
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Více než { $limit } výskyt
            [few] Více než { $limit } výskyty
           *[other] Více než { $limit } výskytů
        }
