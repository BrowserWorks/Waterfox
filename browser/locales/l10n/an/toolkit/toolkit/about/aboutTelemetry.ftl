# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Fuent de datos de ping:
about-telemetry-show-current-data = Datos actuals
about-telemetry-show-archived-ping-data = Datos de ping archivaus
about-telemetry-show-subsession-data = Amostrar datos d'a subsession
about-telemetry-choose-ping = Trigar ping:
about-telemetry-archive-ping-type = Tipo de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hue
about-telemetry-option-group-yesterday = Ahiere
about-telemetry-option-group-older = Mas antigo
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datos de telemetría
about-telemetry-current-store = Almagazenamiento actual:
about-telemetry-more-information = Yes buscando mas información?
about-telemetry-firefox-data-doc = La <a data-l10n-name="data-doc-link">Documentación de Datos de Firefox</a> contién guidas sobre cómo treballar con as nuestras ferramientas de datos.
about-telemetry-telemetry-client-doc = La <a data-l10n-name="client-doc-link">Documentación d'o client de telemetría de Firefox</a> contién la definición d'os diferents conceptos, la documentación de l'API y referencias d'os datos.
about-telemetry-telemetry-dashboard = Las <a data-l10n-name="dashboard-link">Taulas de telemetría</a> te permiten visualizar los datos recibius por Mozilla gracias a la telemetría.
about-telemetry-telemetry-probe-dictionary = Lo <a data-l10n-name="probe-dictionary-link">diccionario de prebas</a> da detalles y descripcions para las prebas recollidas por telemetría.
about-telemetry-show-in-Firefox-json-viewer = Ubrir lo visor de JSON
about-telemetry-home-section = Inicio
about-telemetry-general-data-section =   Datos chenerals
about-telemetry-environment-data-section = Datos d'o entorno
about-telemetry-session-info-section = Información d'a sesión
about-telemetry-scalar-section = Escalars
about-telemetry-keyed-scalar-section = Escalars con clau
about-telemetry-histograms-section = Histogramas
about-telemetry-keyed-histogram-section =   Datos chenerals
about-telemetry-events-section = Eventos
about-telemetry-simple-measurements-section = Midas simples
about-telemetry-slow-sql-section = Consultas SQL lentas
about-telemetry-addon-details-section = Detalles d'o complemento
about-telemetry-captured-stacks-section = Pilas capturadas
about-telemetry-late-writes-section = Escrituras rezagadas
about-telemetry-raw-payload-section = Carga bruta
about-telemetry-raw = JSON crudo
about-telemetry-full-sql-warning = AVISO: A depuración de consultas SQL lentas ye activada. Talment as cadenas SQL completas se amuestren abaixo, pero no se ninviarán ta Telemetría.
about-telemetry-fetch-stack-symbols = Pillar los nombres d'as funcions d'as pilas
about-telemetry-hide-stack-symbols = Amostrar datos crudos d'a pila
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] datos de lanzamiento
       *[prerelease] datos de prelanzamiento
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] activau
       *[disabled] desactivau
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } muestra, media =  { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } muestras, media = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ista pachina amuestra información sobre o rendimiento, hardware, uso y personalizacions replegadas por Telemetry. Ista información se ninvia ta { $telemetryServerOwner } ta aduyar a amillorar o { -brand-full-name }.
about-telemetry-settings-explanation = Telemetría ye replegando { about-telemetry-data-type } y la puyada ye <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Cada información se ninvia empaquetada en “<a data-l10n-name="ping-link">pings</a>”. Yes veyendo lo ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Cada información se ninvia empaquetada en “<a data-l10n-name="ping-link">pings</a>”. Yes veyendo los datos actuals.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Trobar en { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Trobar en totas las seccions
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultaus de “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = No i hai garra resultau pa “{ $currentSearchText }” en { $sectionName }
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = No i hai garra resultau en“{ $searchTerms }” en garra sección
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = No i hai garra dato disponible en “{ $sectionName }” actualment
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = Datos actuals
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = totz
# button label to copy the histogram
about-telemetry-histogram-copy = Copiar
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Consultas SQL lentas en o filo principal
about-telemetry-slow-sql-other = Consultas SQL lentas en os filos d'aduya
about-telemetry-slow-sql-hits = Coincidencias
about-telemetry-slow-sql-average = Tiempo meyo (ms)
about-telemetry-slow-sql-statement = Consulta
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID d'o complemento
about-telemetry-addon-table-details = Detalles
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Editor { $addonProvider }
about-telemetry-keys-header = Propiedat
about-telemetry-names-header = Nombre
about-telemetry-values-header = Valura
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (conto de capturas: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Escritura rezagada nº{ $lateWriteCount }
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Mapa de memoria:
about-telemetry-error-fetching-symbols = Ha ocurriu una error en recullir os simbolos. Comprebe que ye connectau a internet y prebe-lo de nuevas.
about-telemetry-time-stamp-header = marca de tiempo
about-telemetry-category-header = categoría
about-telemetry-method-header = metodo
about-telemetry-object-header = obchecto
about-telemetry-extra-header = extra
about-telemetry-origin-section = Orichen d'a telemetría
about-telemetry-origin-origin = orichen
about-telemetry-origin-count = contar
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">La telemetria de Firefox Origin</a> codifica los datos antes de ninviar-los pa que { $telemetryServerOwner } pueda contar cosas, pero no sepa si un { -brand-product-name } determinau ha contribuyiu a ixa cuenta. (<a data-l10n-name="prio-blog-link">saber-ne mas</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Proceso { $process }
