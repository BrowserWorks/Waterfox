# This Source Code Form is subject to the terms of the BrowserWorks Public
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
findbar-not-found = Não encontrado
findbar-wrapped-to-top = Atingido o fim da página, continuando do início
findbar-wrapped-to-bottom = Atingido o início da página, continuando do fim
findbar-normal-find =
    .placeholder = Procurar na página
findbar-fast-find =
    .placeholder = Procura rápida
findbar-fast-find-links =
    .placeholder = Procura rápida (só links)
findbar-case-sensitive-status =
    .value = (diferencia maiúsculas/minúsculas)
findbar-match-diacritics-status =
    .value = (considera acentuação)
findbar-entire-word-status =
    .value = (só palavras inteiras)
# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] Ocorrência { $current } de { $total }
           *[other] Ocorrência { $current } de { $total }
        }
# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Mais de { $limit } ocorrência
           *[other] Mais de { $limit } ocorrências
        }
