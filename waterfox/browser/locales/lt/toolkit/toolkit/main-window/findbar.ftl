# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Ieškoti tolesnio frazės egzemplioriaus
findbar-previous =
    .tooltiptext = Ieškoti ankstesnio frazės egzemplioriaus

findbar-find-button-close =
    .tooltiptext = Užverti paieškos lauką

findbar-highlight-all2 =
    .label = Viską paryškinti
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Paryškinti visus radinius

findbar-case-sensitive =
    .label = Skirti raidžių registrą
    .accesskey = k
    .tooltiptext = Ieškoti, skiriant didžiąsias ir mažąsias raides

findbar-match-diacritics =
    .label = Skirti diakritinius ženklus
    .accesskey = i
    .tooltiptext = Atskirti akcentuotas raides ir jų bazines raides (pvz., ieškant „resume“ nebus randama „résumé“)

findbar-entire-word =
    .label = Ištisi žodžiai
    .accesskey = I
    .tooltiptext = Ieškoti tik ištisų žodžių

findbar-not-found = Ieškomos frazės nepavyko rasti

findbar-wrapped-to-top = Pasiekus puslapio pabaigą, paieška pratęsta nuo pradžios
findbar-wrapped-to-bottom = Pasiekus puslapio pradžią, paieška pratęsta nuo pabaigos

findbar-normal-find =
    .placeholder = Paieška tinklalapyje
findbar-fast-find =
    .placeholder = Sparčioji paieška
findbar-fast-find-links =
    .placeholder = Sparčioji paieška (tik saituose)

findbar-case-sensitive-status =
    .value = (Skiriant didž. ir maž. raides)
findbar-match-diacritics-status =
    .value = (Skiriant diakritinius ženklus)
findbar-entire-word-status =
    .value = (Tik ištisi žodžiai)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } iš { $total } atitikmens
            [few] { $current } iš { $total } atitikmenų
           *[other] { $current } iš { $total } atitikmenų
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Daugiau kaip { $limit } atitikmuo
            [few] Daugiau kaip { $limit } atitikmenys
           *[other] Daugiau kaip { $limit } atitikmenų
        }
