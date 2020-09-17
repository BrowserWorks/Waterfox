# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Fonte de datos de ping:
about-telemetry-show-current-data = Datos actual
about-telemetry-show-archived-ping-data = Datos de ping archivate
about-telemetry-show-subsession-data = Monstrar le datos del sub-session
about-telemetry-choose-ping = Eliger le ping:
about-telemetry-archive-ping-type = Typo de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hodie
about-telemetry-option-group-yesterday = Heri
about-telemetry-option-group-older = Plus ancian
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datos de telemetria
about-telemetry-current-store = Archivo actual
about-telemetry-more-information = Cerca tu plus informationes?
about-telemetry-firefox-data-doc = Le <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> contine guidas re le uso de nostre instrumentos de dato.
about-telemetry-telemetry-client-doc = Le <a data-l10n-name="client-doc-link">Firefox Telemetry client documentation</a> include definitiones pro conceptos, documentation re le API e referentias de datos.
about-telemetry-telemetry-dashboard = Le <a data-l10n-name="dashboard-link">Telemetry dashboards</a> te permitte de visualisar le datos que Mozilla recipe via Telemetry.
about-telemetry-telemetry-probe-dictionary = Le <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> forni detalios e descriptiones pro le sondas colligite per Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Aperir in le visor JSON
about-telemetry-home-section = A casa
about-telemetry-general-data-section = Datos general
about-telemetry-environment-data-section = Datos ambiental
about-telemetry-session-info-section = Informationes de session
about-telemetry-scalar-section = Scalares
about-telemetry-keyed-scalar-section = Scalares con clave
about-telemetry-histograms-section = Histogrammas
about-telemetry-keyed-histogram-section = Histogrammas con clave
about-telemetry-events-section = Eventos
about-telemetry-simple-measurements-section = Mesuras simple
about-telemetry-slow-sql-section = Instructiones SQL lente
about-telemetry-addon-details-section = Detalios del additivo
about-telemetry-captured-stacks-section = Pilas capturate
about-telemetry-late-writes-section = Scripturas tarde
about-telemetry-raw-payload-section = Carga brute
about-telemetry-raw = JSON brute
about-telemetry-full-sql-warning = NOTA: Le depuration SQL lente es active. Tote le catenas de characteres SQL pote esser presentate ma illos non essera submittite a telemetria.
about-telemetry-fetch-stack-symbols = Recuperar le nomines de functiones pro le pilas
about-telemetry-hide-stack-symbols = Monstrar le datos brute del pila
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] datos publicate
       *[prerelease] datos preliminar
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] active
       *[disabled] inactive
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } specimen, media = { $prettyAverage }, total = { $sum }
       *[other] { $sampleCount } specimens, media = { $prettyAverage }, total = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Iste pagina monstra le information sur rendimento, hardware, uso e personalisationes colligite per telemetria. Iste information es submittite a { $telemetryServerOwner } pro adjutar a meliorar { -brand-full-name }.
about-telemetry-settings-explanation = Le telemetria collige { about-telemetry-data-type } e le invio es <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Cata pecia de information es inviate incorporate in “<a data-l10n-name="ping-link">pings</a>”. Tu reguarda al ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Tote le informationes es inviate in pacchettos appellate “<a data-l10n-name="ping-link">pings</a>“. Tu visualisa le datos actual.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Cercar in { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Cercar in tote le sectiones
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultatos pro “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Pardono! Il ha nulle resultato in { $sectionName } pro “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Pardono! Il ha nulle resultato in ulle sectiones pro “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Pardono! Il ha actualmente nulle datos disponibile in “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = datos actual
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = toto
# button label to copy the histogram
about-telemetry-histogram-copy = Copiar
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Instructiones SQL lente in le filo de execution principal
about-telemetry-slow-sql-other = Instructiones SQL lente in le filos de execution auxiliar
about-telemetry-slow-sql-hits = Correspondentias
about-telemetry-slow-sql-average = Tempore medie (ms)
about-telemetry-slow-sql-statement = Instruction
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID del additivo
about-telemetry-addon-table-details = Detalios
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Fornitor { $addonProvider }
about-telemetry-keys-header = Proprietate
about-telemetry-names-header = Nomine
about-telemetry-values-header = Valor
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (conto de captura: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Scriptura tarde #{ $lateWriteCount }
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Mappa de memoria:
about-telemetry-error-fetching-symbols = Un error ha occurrite durante le recuperation del symbolos. Verifica que tu es connectite a Internet e retenta.
about-telemetry-time-stamp-header = marca temporal
about-telemetry-category-header = Categoria
about-telemetry-method-header = methodo
about-telemetry-object-header = objecto
about-telemetry-extra-header = extra
about-telemetry-origin-section = Telemetria “Origin”
about-telemetry-origin-origin = origine
about-telemetry-origin-count = conto
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = Le <a data-l10n-name="origin-doc-link">Telemetria Origin de Firefox</a> codifica datos ante que illos es inviate, assi que { $telemetryServerOwner } pote contar le cosas, ma non sape si o non ulle date { -brand-product-name } collabora a ille conto. (<a data-l10n-name="prio-blog-link">saper plus</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Processo “{ $process }”
