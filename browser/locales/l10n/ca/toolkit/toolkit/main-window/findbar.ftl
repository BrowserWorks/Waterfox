# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Cerca la següent coincidència de l'expressió
findbar-previous =
    .tooltiptext = Cerca l'anterior coincidència de l'expressió

findbar-find-button-close =
    .tooltiptext = Tanca la barra de cerca

findbar-highlight-all2 =
    .label = Ressalta-ho tot
    .accesskey =
        { PLATFORM() ->
            [macos] a
           *[other] a
        }
    .tooltiptext = Ressalta totes les ocurrències de la frase

findbar-case-sensitive =
    .label = Distingeix entre majúscules i minúscules
    .accesskey = c
    .tooltiptext = Cerca distingint entre majúscules i minúscules

findbar-match-diacritics =
    .label = Respecta els diacrítics
    .accesskey = i
    .tooltiptext = Distingeix entre lletres accentuades i lletres no accentuades (per exemple, si cerqueu «os», no trobarà «ós»)

findbar-entire-word =
    .label = Paraules senceres
    .accesskey = P
    .tooltiptext = Cerca només paraules senceres
