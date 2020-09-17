# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Trobar a siguient aparición d'a frase
findbar-previous =
    .tooltiptext = Trobar l'anterior aparición d'a frase

findbar-find-button-close =
    .tooltiptext = Zarrar a barra de busca

findbar-highlight-all2 =
    .label = Resaltar-lo tot
    .accesskey =
        { PLATFORM() ->
            [macos] a
           *[other] a
        }
    .tooltiptext = Resaltar totas las ocurrencias d'a frase

findbar-case-sensitive =
    .label = Coincidir mayusclas
    .accesskey = C
    .tooltiptext = Mirar distinguindo entre mayusclas y minusclas

findbar-match-diacritics =
    .label = Respectar los accentos y diacriticos
    .accesskey = i
    .tooltiptext = Distinguir entre letras accentuadas y las suyas letras base (per eixemplo, quan se mira "aragonés", no se trobará "aragones")

findbar-entire-word =
    .label = Parolas completas
    .accesskey = P
    .tooltiptext = Mirar nomás parolas completas
