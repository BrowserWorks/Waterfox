# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Orixe dos datos de ping:
about-telemetry-show-current-data = Datos actuais
about-telemetry-show-archived-ping-data = Datos arquivados de ping
about-telemetry-show-subsession-data = Amosar datos de subsesión
about-telemetry-choose-ping = Escolla ping:
about-telemetry-archive-ping-type = Tipo de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hoxe
about-telemetry-option-group-yesterday = Onte
about-telemetry-option-group-older = Máis antigo
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datos telemétricos
about-telemetry-current-store = Almacén actual:
about-telemetry-more-information = Busca máis información?
about-telemetry-firefox-data-doc = A <a data-l10n-name="data-doc-link">documentación dos datos de Firefox</a> contén guías sobre como traballar coas nosas ferramentas de datos.
about-telemetry-telemetry-client-doc = A <a data-l10n-name="client-doc-link">documentación do cliente de telemetría de Firefox</a> inclúe definicións de conceptos, documentación da API e referencias de datos.
about-telemetry-telemetry-dashboard = Os <a data-l10n-name="dashboard-link">taboleiros de telemetría</a> permítenlle visualizar os datos que Mozilla recibe a través da telemetría.
about-telemetry-telemetry-probe-dictionary = O <a data-l10n-name="probe-dictionary-link">dicionario de proba</a> fornece información e descricións de mostras recollidas por telemetría.
about-telemetry-show-in-Firefox-json-viewer = Abrir no visor JSON
about-telemetry-home-section = Inicio
about-telemetry-general-data-section = Datos xerais
about-telemetry-environment-data-section = Datos do entorno
about-telemetry-session-info-section = Información da sesión
about-telemetry-scalar-section = Escalares
about-telemetry-keyed-scalar-section = Escalares con lendas
about-telemetry-histograms-section = Histogramas
about-telemetry-keyed-histogram-section = Histogramas con lendas
about-telemetry-events-section = Eventos
about-telemetry-simple-measurements-section = Medidas simples
about-telemetry-slow-sql-section = Sentenzas SQL lentas
about-telemetry-addon-details-section = Detalles do complemento
about-telemetry-captured-stacks-section = Pilas capturadas
about-telemetry-late-writes-section = Escritura atrasada
about-telemetry-raw-payload-section = Contido sen procesar
about-telemetry-raw = JSOn sen procesar
about-telemetry-full-sql-warning = NOTA: A depuración SQL lenta está activada. Poden amosarse cadeas completas de SQL pero non se enviarán a telemetría.
about-telemetry-fetch-stack-symbols = Obter os nomes das funcións para as pilas
about-telemetry-hide-stack-symbols = Amosar os datos da pila sen procesalos
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] datos da versión
       *[prerelease] datos da versión preliminar
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] activada
       *[disabled] desactivada
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } mostra, media = { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } mostras, media = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Esta páxina amosa a información sobre o rendemento, o hardware, o uso e as personalizacións recollidas por telemetría. Esta información envíase a { $telemetryServerOwner } para mellorar o { -brand-full-name }.
about-telemetry-settings-explanation = A telemetría está recollendo { about-telemetry-data-type } e a transmisión está <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Cada anaco de información envíase empaquetado en «<a data-l10n-name="ping-link">pings</a>». Vostede está mirando o ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Cada anaco de información envíase empaquetado en «<a data-l10n-name="ping-link">pings</a>». Vostede está mirando os datos actuais.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Atopar en { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Atopar en todas as seccións
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultados para «{ $searchTerms }»
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Desculpe! Sorry! Non hai resultados en { $sectionName } para «{ $currentSearchText }»
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Desculpe! Non hai resultados para «{ $searchTerms }» en ningunha sección
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Desculpe! Neste momento ningún dato dispoñíbel en «{ $sectionName }»
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = datos actuais
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = todo
# button label to copy the histogram
about-telemetry-histogram-copy = Copiar
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Sentenzas SQL lentas no fío principal
about-telemetry-slow-sql-other = Sentenzas SQL lentas en fíos auxiliares
about-telemetry-slow-sql-hits = Contador
about-telemetry-slow-sql-average = Tempo medio (ms)
about-telemetry-slow-sql-statement = Sentenza
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID do complemento
about-telemetry-addon-table-details = Detalles
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Fornecedor { $addonProvider }
about-telemetry-keys-header = Propiedade
about-telemetry-names-header = Nome
about-telemetry-values-header = Valor
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (Número de capturas: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = #{ $lateWriteCount } escrituras atrasadas
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Mapa de memoria:
about-telemetry-error-fetching-symbols = Produciuse un erro ao recuperar os símbolos. Comprobe que está conectado á Internet e tente de novo.
about-telemetry-time-stamp-header = marca temporal
about-telemetry-category-header = categoría
about-telemetry-method-header = método
about-telemetry-object-header = obxecto
about-telemetry-extra-header = extra
about-telemetry-origin-section = Telemetría de orixe
about-telemetry-origin-origin = orixe
about-telemetry-origin-count = conta
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Telemetría de orixe de Firefox</a> codifica os datos antes de que se envíen para que { $telemetryServerOwner } poida contar cousas, pero non sabe se hai ou non algún { -brand-product-name } contribuíu a ese reconto. (<a data-l10n-name="prio-blog-link"> máis información </a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = proceso { $process }
