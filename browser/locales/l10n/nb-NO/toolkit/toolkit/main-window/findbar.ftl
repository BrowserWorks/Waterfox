# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Søker etter den neste forekomsten av teksten
findbar-previous =
    .tooltiptext = Søker etter den forrige forekomsten av teksten

findbar-find-button-close =
    .tooltiptext = Lukk søkelinje

findbar-highlight-all2 =
    .label = Marker alt
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Marker alle forekomster av teksten

findbar-case-sensitive =
    .label = Skill mellom store/små bokstaver
    .accesskey = k
    .tooltiptext = Skill mellom store/små bokstaver i søket

findbar-match-diacritics =
    .label = Samsvar diakritiske tegn
    .accesskey = i
    .tooltiptext = Skille mellom aksentbokstaver og deres grunnleggende bokstaver (for eksempel når du søker etter «alle», vil ikke «allé» samsvares)

findbar-entire-word =
    .label = Hele ord
    .accesskey = H
    .tooltiptext = Søk bare etter hele ord
