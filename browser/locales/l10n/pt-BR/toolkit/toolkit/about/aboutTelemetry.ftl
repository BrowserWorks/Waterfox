# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Fonte de dados do ping:
about-telemetry-show-current-data = Dados atuais
about-telemetry-show-archived-ping-data = Dados de ping arquivados
about-telemetry-show-subsession-data = Mostrar dados da subseção
about-telemetry-choose-ping = Escolha o ping:
about-telemetry-archive-ping-type = Tipo de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hoje
about-telemetry-option-group-yesterday = Ontem
about-telemetry-option-group-older = Mais Antigo
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Dados de Telemetria
about-telemetry-current-store = Armazenamento atual:
about-telemetry-more-information = Procurando mais informações?
about-telemetry-firefox-data-doc = A <a data-l10n-name="data-doc-link">Documentação de dados do Firefox</a> contém guias sobre como trabalhar com nossas ferramentas de dados.
about-telemetry-telemetry-client-doc = A <a data-l10n-name="client-doc-link">documentação do cliente de telemetria do Firefox</a> inclui definições de conceitos, documentação da API e referências de dados.
about-telemetry-telemetry-dashboard = Os <a data-l10n-name="dashboard-link">painéis de Telemetria</a> permitem visualizar os dados que a Mozilla recebe via Telemetria.
about-telemetry-telemetry-probe-dictionary = O <a data-l10n-name="probe-dictionary-link">Dicionário de Sondagens</a> fornece detalhes e descrições das sondagens coletadas pela Telemetria.
about-telemetry-show-in-Firefox-json-viewer = Abrir no visualizador de JSON
about-telemetry-home-section = Início
about-telemetry-general-data-section = Dados gerais
about-telemetry-environment-data-section = Dados do ambiente
about-telemetry-session-info-section = Informações da sessão
about-telemetry-scalar-section = Escalares
about-telemetry-keyed-scalar-section = Escalares nomeados
about-telemetry-histograms-section = Histogramas
about-telemetry-keyed-histogram-section = Histogramas nomeados
about-telemetry-events-section = Eventos
about-telemetry-simple-measurements-section = Medições simples
about-telemetry-slow-sql-section = Instruções SQL lentas
about-telemetry-addon-details-section = Detalhes de extensões
about-telemetry-captured-stacks-section = Pilhas capturadas
about-telemetry-late-writes-section = Escritas atrasadas
about-telemetry-raw-payload-section = Conteúdo bruto
about-telemetry-raw = JSON bruto
about-telemetry-full-sql-warning = NOTA: está ativada a depuração de SQL lento. Strings SQL completas podem ser exibidas abaixo, mas não serão enviadas para telemetria.
about-telemetry-fetch-stack-symbols = Coletar nomes de funções para pilhas
about-telemetry-hide-stack-symbols = Exibir dados brutos da pilha
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] informações de lançamento
       *[prerelease] informações de pré-lançamento
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] ativado
       *[disabled] desativado
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } amostra, média = { $prettyAverage }, soma = { $sum }
       *[other] { $sampleCount } amostras, média = { $prettyAverage }, soma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Esta página mostra as informações de desempenho, hardware, uso e personalização coletadas pela Telemetria. Essas informações são enviadas para a { $telemetryServerOwner } para ajudar a melhorar o { -brand-full-name }.
about-telemetry-settings-explanation = A telemetria está coletando { about-telemetry-data-type } e o envio está <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Cada pedaço de informação é enviado empacotado dentro de “<a data-l10n-name="ping-link">pings</a>”. Você está vendo o ping { $name } de { $timestamp }.
about-telemetry-data-details-current = Cada pedaço de informação é enviado empacotado dentro de “<a data-l10n-name="ping-link">pings</a>“. Você está vendo os dados atuais.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Procurar em { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Procurar em todas as seções
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultados para “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Desculpe! Não há resultados em { $sectionName } para “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Desculpe! Não há resultados em nenhuma seção para “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Desculpe! No momento não há nenhum dado disponível em “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = dados atuais
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = todos
# button label to copy the histogram
about-telemetry-histogram-copy = Copiar
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Instruções SQL lentas na thread principal
about-telemetry-slow-sql-other = Instruções SQL lentas em threads auxiliares
about-telemetry-slow-sql-hits = Ocorrências
about-telemetry-slow-sql-average = Tempo médio (ms)
about-telemetry-slow-sql-statement = Instrução
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID da extensão
about-telemetry-addon-table-details = Detalhes
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Fornecedor do { $addonProvider }
about-telemetry-keys-header = Propriedade
about-telemetry-names-header = Nome
about-telemetry-values-header = Valor
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (contagem de captura:: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Escrita atrasada #{ $lateWriteCount }
about-telemetry-stack-title = Pilha:
about-telemetry-memory-map-title = Mapa da memória:
about-telemetry-error-fetching-symbols = Ocorreu um erro ao carregar símbolos. Verifique se você está conectado à internet e tente novamente.
about-telemetry-time-stamp-header = timestamp
about-telemetry-category-header = categoria
about-telemetry-method-header = método
about-telemetry-object-header = objeto
about-telemetry-extra-header = extra
about-telemetry-origin-section = Telemetria de origem
about-telemetry-origin-origin = origem
about-telemetry-origin-count = contagem
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = A <a data-l10n-name="origin-doc-link">Telemetria de origem do Firefox</a> codifica os dados antes de ser enviados, assim o { $telemetryServerOwner } pode contar coisas, mas não saber se algum { -brand-product-name } indicado contribuiu ou não para a contagem (<a data-l10n-name="prio-blog-link">saiba mais</a>).
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Processo { $process }
