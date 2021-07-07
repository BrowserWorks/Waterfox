# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Procurar a próxima ocorrência da busca
findbar-previous =
    .tooltiptext = Procurar a ocorrência anterior da busca

findbar-find-button-close =
    .tooltiptext = Fechar a barra de procura

findbar-highlight-all2 =
    .label = Destacar todas
    .accesskey =
        { PLATFORM() ->
            [macos] t
           *[other] t
        }
    .tooltiptext = Destacar na página todas as ocorrências da busca

findbar-case-sensitive =
    .label = Diferenciar maiúsculas/minúsculas
    .accesskey = m
    .tooltiptext = Procurar considerando diferenças entre maiúsculas e minúsculas

findbar-match-diacritics =
    .label = Considerar acentuação
    .accesskey = C
    .tooltiptext = Distinguir letras acentuadas de suas letras de base (por exemplo, ao procurar “Pará”, não serão consideradas as ocorrências de “para”)

findbar-entire-word =
    .label = Palavras inteiras
    .accesskey = P
    .tooltiptext = Só procurar palavras inteiras
