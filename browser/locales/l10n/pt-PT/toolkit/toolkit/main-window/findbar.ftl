# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Localizar a ocorrência seguinte da frase
findbar-previous =
    .tooltiptext = Localizar ocorrência anterior da frase

findbar-find-button-close =
    .tooltiptext = Fechar barra de localização

findbar-highlight-all2 =
    .label = Destacar tudo
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = Destacar todas as ocorrências de uma frase

findbar-case-sensitive =
    .label = Diferenciar maiúsculas de minúsculas
    .accesskey = c
    .tooltiptext = Pesquisar diferenciando maiúsculas/minúsculas

findbar-match-diacritics =
    .label = Corresponder diacríticos
    .accesskey = i
    .tooltiptext = Distinguir entre as letras acentuadas e as suas letras base (por exemplo, quando pesquisa por "currículo", "currículo" não será correspondido)

findbar-entire-word =
    .label = Palavras completas
    .accesskey = P
    .tooltiptext = Pesquisar apenas palavras completas
