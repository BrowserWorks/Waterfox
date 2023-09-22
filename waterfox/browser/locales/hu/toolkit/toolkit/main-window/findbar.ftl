# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = A kifejezés következő előfordulásának keresése
findbar-previous =
    .tooltiptext = A kifejezés előző előfordulásának keresése

findbar-find-button-close =
    .tooltiptext = Keresősáv bezárása

findbar-highlight-all2 =
    .label = Összes kiemelése
    .accesskey =
        { PLATFORM() ->
            [macos] k
           *[other] k
        }
    .tooltiptext = A kifejezés összes előfordulásának kiemelése

findbar-case-sensitive =
    .label = Kis- és nagybetűk
    .accesskey = i
    .tooltiptext = Keresés kis- és nagybetűk megkülönböztetésével

findbar-match-diacritics =
    .label = Diakritikus jelek
    .accesskey = i
    .tooltiptext = Az ékezetes és alap betűk megkülönböztetés (például ha arra keres, hogy „sas”, akkor a „sás” nem fog egyezni)

findbar-entire-word =
    .label = Egész szavak
    .accesskey = v
    .tooltiptext = Csak egész szavak keresése

findbar-not-found = A kifejezés nem található

findbar-wrapped-to-top = Az oldal vége elérve, folytatás az elejétől
findbar-wrapped-to-bottom = Az oldal eleje elérve, folytatás a végétől

findbar-normal-find =
    .placeholder = Keresés az oldalon
findbar-fast-find =
    .placeholder = Gyorskeresés
findbar-fast-find-links =
    .placeholder = Gyorskeresés (csak hivatkozások)

findbar-case-sensitive-status =
    .value = (Kis- és nagybetűk megkülönböztetése)
findbar-match-diacritics-status =
    .value = (Diakritikus jelek)
findbar-entire-word-status =
    .value = (Csak teljes szavak)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } / { $total } találat
           *[other] { $current } / { $total } találat
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Több mint { $limit } találat
           *[other] Több mint { $limit } találat
        }
