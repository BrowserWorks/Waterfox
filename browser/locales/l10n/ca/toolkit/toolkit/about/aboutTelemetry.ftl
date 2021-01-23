# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Font de dades de ping:
about-telemetry-show-current-data = Dades actuals
about-telemetry-show-archived-ping-data = Dades de ping arxivades
about-telemetry-show-subsession-data = Mostra dades de la subsessió
about-telemetry-choose-ping = Trieu el ping:
about-telemetry-archive-ping-type = Tipus de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Avui
about-telemetry-option-group-yesterday = Ahir
about-telemetry-option-group-older = Més antic
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Dades de telemesura
about-telemetry-more-information = Voleu més informació?
about-telemetry-home-section = Inici
about-telemetry-general-data-section =   Dades generals
about-telemetry-environment-data-section = Dades de l'entorn
about-telemetry-session-info-section = Informació de la sessió
about-telemetry-scalar-section = Escalars
about-telemetry-keyed-scalar-section = Escalars amb clau
about-telemetry-histograms-section = Histogrames
about-telemetry-keyed-histogram-section =   Histogrames amb clau
about-telemetry-events-section = Esdeveniments
about-telemetry-simple-measurements-section = Mesures senzilles
about-telemetry-slow-sql-section = Sentències SQL lentes
about-telemetry-addon-details-section = Detalls del complement
about-telemetry-captured-stacks-section = Piles capturades
about-telemetry-late-writes-section = Escriptures tardanes
about-telemetry-raw = JSON sense processar
about-telemetry-full-sql-warning = NOTA: la depuració de SQL lenta està habilitada. Es poden mostrar les cadenes SQL completes a sota però no s'enviaran per a la telemesura.
about-telemetry-fetch-stack-symbols = Obtén els noms de les funcions per a les piles
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Aquesta pàgina conté la informació del rendiment, ús i personalitzacions recopilada per a la telemesura. Aquesta informació s'envia a { $telemetryServerOwner } per ajudar a millorar { -brand-full-name }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Cerca a { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Cerca en totes les seccions
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultats de «{ $searchTerms }»
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = dades actuals
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = tot
# button label to copy the histogram
about-telemetry-histogram-copy = Copia
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Sentències SQL lentes en el fil principal
about-telemetry-slow-sql-other = Sentències SQL lentes en fils auxiliars
about-telemetry-slow-sql-hits = Encerts
about-telemetry-slow-sql-average = Temps mitjà (ms)
about-telemetry-slow-sql-statement = Sentència
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID del complement
about-telemetry-addon-table-details = Detalls
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Proveïdor { $addonProvider }
about-telemetry-keys-header = Propietat
about-telemetry-names-header = Nom
about-telemetry-values-header = Valor
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Escriptura tardana #{ $lateWriteCount }
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Mapa de memòria:
about-telemetry-error-fetching-symbols = S'ha produït un error mentre es recollien els símbols. Comproveu que esteu connectat a Internet i torneu-ho a provar.
about-telemetry-time-stamp-header = marca horària
about-telemetry-category-header = categoria
about-telemetry-method-header = mètode
about-telemetry-object-header = objecte
about-telemetry-extra-header = extra
about-telemetry-origin-origin = origen
about-telemetry-origin-count = recompte
