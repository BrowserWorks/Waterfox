# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Suspensão de separadores
about-unloads-intro-1 =
    O { -brand-short-name } tem uma nova funcionalidade que suspende separadores automaticamente 
    para impedir que a aplicação falhe devido à indisponibilidade de memória 
    quando existe pouca memória disponível. O próximo separador a ser suspenso 
    é escolhido com base em múltiplos atributos. Esta página mostra como 
    o { -brand-short-name } prioriza separadores e que separador será suspenso
    quando a suspensão de separadores for ativada.
about-unloads-intro-2 =
    Os separadores existentes são apresentados na tabela abaixo pela mesma ordem utilizada pelo 
    { -brand-short-name } para escolher o próximo separador a suspender. Os identificadores de processo são 
    destacados a <strong>negrito</strong> quando suportam a moldura principal do separador 
    e a <em>itálico</em> quando o processo é partilhado entre diferentes separadores. 
    Pode despoletar a suspensão de separadores de forma manual clicando no botão 
    <em>Suspender</em> abaixo.
about-unloads-intro =
    O { -brand-short-name } tem uma nova funcionalidade que suspende separadores automaticamente 
    para impedir que a aplicação falhe devido à indisponibilidade de memória 
    quando existe pouca memória disponível. O próximo separador a ser suspenso 
    é selecionado com base em múltiplos atributos. Esta página mostra como 
    o { -brand-short-name } prioriza separadores e que separador será suspenso
    quando a suspensão de separadores for ativada. Pode despoletar a suspensão 
    de separadores manualmente ativando o botão <em>Suspender</em> abaixo.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Consulte <a data-l10n-name="doc-link">Suspensão de separadores</a> para saber mais sobre
    a funcionalidade e esta página.
about-unloads-last-updated = Última atualização: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Suspender
    .title = Suspender o separador com a máxima prioridade
about-unloads-no-unloadable-tab = Não existem separadores suspensos.
about-unloads-column-priority = Prioridade
about-unloads-column-host = Hospedeiro
about-unloads-column-last-accessed = Último acesso
about-unloads-column-weight = Peso base
    .title = Os separadores são ordenados com base neste valor que deriva a partir de alguns atributos especiais como a reprodução de som, WebRTC, entre outros.
about-unloads-column-sortweight = Peso secundário
    .title = Se disponível, os separadores são ordenados com base neste valor depois de ordenados pelo peso base. O valor deriva da utilização de memória do separador e do número de processos.
about-unloads-column-memory = Memória
    .title = Estimativa de utilização de memória do separador
about-unloads-column-processes = Identificadores do processo
    .title = Identificadores dos processos que disponibilizam os conteúdos do separador
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
