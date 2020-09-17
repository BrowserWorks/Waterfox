# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Fonte de datos de ping:
about-telemetry-show-archived-ping-data = Datos archivaos de ping
about-telemetry-show-subsession-data = Amosar datos de sosesión
about-telemetry-choose-ping = Escoyer ping:
about-telemetry-archive-ping-type = Triba de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Güei
about-telemetry-option-group-yesterday = Ayerí
about-telemetry-option-group-older = Vieyo
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datos de Telemetry
about-telemetry-more-information = ¿Guetes más información?
about-telemetry-firefox-data-doc = La <a data-l10n-name="data-doc-link">documentación de datos de Firefox</a> contién guíes tocante a cómo funcionen les nueses ferramientes de datos.
about-telemetry-telemetry-client-doc = La <a data-l10n-name="client-doc-link">documentación de datos de Firefox</a> inclúi definiciones pa conceutos, documentación API y referencies de datos.
about-telemetry-telemetry-dashboard = El <a data-l10n-name="dashboard-link">cuadru de mandos de Telemetry</a> permítete visualizar los datos que recibe Mozilla per Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Abrir nel visor JSON
about-telemetry-home-section = Aniciu
about-telemetry-general-data-section = Datos xenerales
about-telemetry-environment-data-section = Datos d'entornu
about-telemetry-session-info-section = Información de sesión
about-telemetry-scalar-section = Escalares
about-telemetry-keyed-scalar-section = Escalares con llave
about-telemetry-histograms-section = Histogrames
about-telemetry-keyed-histogram-section = Historigrames con llave
about-telemetry-events-section = Eventos
about-telemetry-simple-measurements-section = Midíes simples
about-telemetry-slow-sql-section = Sentencies SQL lentes
about-telemetry-addon-details-section = Detalles del complementu
about-telemetry-captured-stacks-section = Piles capturaes
about-telemetry-late-writes-section = Escritures apostalgaes
about-telemetry-raw-payload-section = Payload en bruto
about-telemetry-raw = JSON en bruto
about-telemetry-full-sql-warning = NOTA: la depuración SQL lenta ta activada. Podríen amosase cadenes completes de SQL pero nun van unviase a Telemetry.
about-telemetry-fetch-stack-symbols = Dir en cata de nomes de función pa piles
about-telemetry-hide-stack-symbols = Amosar datos en bruto de piles
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] datos de llanzamientu
       *[prerelease] datos de pre-llanzamientu
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] activóse
       *[disabled] desactivóse
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Esta páxina amuesa la información tocante al rindimientu, hardware, usu y personalizaciones recoyida por Telemetry. Esta información únviase a { $telemetryServerOwner } p'ayudar a ameyorar { -brand-full-name }.
about-telemetry-settings-explanation = Telemetry ta recoyendo { about-telemetry-data-type } y la xuba ta <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Cada cachu d'información únviase integráu en «<a data-l10n-name="ping-link">pings</a>». Tas viendo'l ping de { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Alcontrar en { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Alcontrar en toles seiciones
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultaos pa «{ $searchTerms }»
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ¡Perdona! Nun hai resultaos en { $sectionName } pa «{ $currentSearchText }»
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ¡Perdona! Nun hai resultaos en denguna seición pa { $searchTerms }
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ¡Perdona! Anguaño nun hai datos disponibles en «{ $sectionName }»
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = too
# button label to copy the histogram
about-telemetry-histogram-copy = Copiar
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Sentencies SQL lentes nel filu principal
about-telemetry-slow-sql-other = Sentencies SQL lentes nos filos auxiliares
about-telemetry-slow-sql-hits = Aciertos
about-telemetry-slow-sql-average = Tiempu mediu (ms)
about-telemetry-slow-sql-statement = Sentencia
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID del complementu
about-telemetry-addon-table-details = Detalles
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Fornidor { $addonProvider }
about-telemetry-keys-header = Propiedá
about-telemetry-names-header = Nome
about-telemetry-values-header = Valor
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (cantidá de captures: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Escritura apostalgada #{ $lateWriteCount }
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Mapa de memoria:
about-telemetry-error-fetching-symbols = Hebo un fallu mentanto se diba en cata de los símbolos. Comprueba que teas coneutáu a internet y volvi tentalo.
about-telemetry-time-stamp-header = data y hora
about-telemetry-category-header = estaya
about-telemetry-method-header = métodu
about-telemetry-object-header = oxetu
about-telemetry-extra-header = estra
