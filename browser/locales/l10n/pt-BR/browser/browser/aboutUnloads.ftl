# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Descarregamento de abas
about-unloads-intro-1 = O { -brand-short-name } tem um recurso que descarrega abas automaticamente para evitar que o aplicativo trave devido a memória insuficiente quando a memória disponível no sistema estiver baixa. A próxima aba a ser descarregada é escolhida com base em vários atributos. Esta página mostra como o { -brand-short-name } prioriza abas e qual aba é descarregada quando o descarregamento de abas é acionado.
about-unloads-intro-2 = As abas existentes são exibidas na tabela abaixo na mesma ordem usada pelo { -brand-short-name } para escolher a próxima aba a ser descarregada. Os IDs de processos são exibidos em <strong>negrito</strong> quando são encarregados pelo quadro principal da aba e em <em>itálico</em> quando o processo é compartilhado por várias abas. Você pode acionar manualmente o descarregamento de abas clicando no botão <em>Descarregar</em> abaixo.
about-unloads-intro = O { -brand-short-name } tem um recurso que descarrega abas automaticamente para evitar que o aplicativo trave devido a memória insuficiente quando a memória disponível no sistema estiver baixa. A próxima aba a ser descarregada é escolhida com base em vários atributos. Esta página mostra como o { -brand-short-name } prioriza abas e qual aba é descarregada quando o descarregamento de abas é acionado. Você pode acionar manualmente o descarregamento de abas clicando abaixo no botão <em>Descarregar</em>.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = Consulte <a data-l10n-name="doc-link">Descarregamento de abas</a> para saber mais sobre o recurso e esta página.
about-unloads-last-updated = Última atualização: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Descarregar
    .title = Descarregar aba com maior prioridade
about-unloads-no-unloadable-tab = Não há abas a ser descarregadas.
about-unloads-column-priority = Prioridade
about-unloads-column-host = Servidor
about-unloads-column-last-accessed = Último acesso
about-unloads-column-weight = Índice principal
    .title = As abas são ordenadas primeiro por este valor, derivado de alguns atributos especiais como estar reproduzindo som, WebRTC, etc.
about-unloads-column-sortweight = Índice secundário
    .title = Se estiver disponível, as abas agrupadas pelo mesmo índice principal são ordenadas por este valor. O valor deriva do uso de memória e do número de processos da aba.
about-unloads-column-memory = Memória
    .title = Uso estimado de memória da aba
about-unloads-column-processes = IDs de processos
    .title = IDs dos processos encarregados pelo conteúdo da aba
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
