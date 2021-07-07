# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Origen de los datos de ping:
about-telemetry-show-current-data = Datos actuales
about-telemetry-show-archived-ping-data = Datos archivados de ping
about-telemetry-show-subsession-data = Mostrar datos de subsesión
about-telemetry-choose-ping = Elija ping:
about-telemetry-archive-ping-type = Tipo de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hoy
about-telemetry-option-group-yesterday = Ayer
about-telemetry-option-group-older = Más antiguo
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datos de Telemetry
about-telemetry-current-store = Almacenamiento actual:
about-telemetry-more-information = ¿Busca más información?
about-telemetry-firefox-data-doc = La <a data-l10n-name="data-doc-link">Documentación de datos de Firefox</a> contiene guías sobre cómo trabajar con nuestras herramientas de datos.
about-telemetry-telemetry-client-doc = La <a data-l10n-name="client-doc-link">documentación del cliente Telemetry de Firefox</a> incluye definiciones de conceptos, documentación de la API y referencias de datos.
about-telemetry-telemetry-dashboard = Los <a data-l10n-name="dashboard-link">paneles de Telemetry</a> le permiten visualizar los datos que Mozilla recibe a través de Telemetry.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> proporciona detalles y descripciones de las muestras recogidas por Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Abrir en el visor JSON
about-telemetry-home-section = Inicio
about-telemetry-general-data-section = Datos generales
about-telemetry-environment-data-section = Datos del entorno
about-telemetry-session-info-section = Información de sesión
about-telemetry-scalar-section = Escalares
about-telemetry-keyed-scalar-section = Escalares con nombre
about-telemetry-histograms-section = Histogramas
about-telemetry-keyed-histogram-section = Histogramas con leyendas
about-telemetry-events-section = Eventos
about-telemetry-simple-measurements-section = Medidas simples
about-telemetry-slow-sql-section = Sentencias SQL lentas
about-telemetry-addon-details-section = Detalles del complemento
about-telemetry-captured-stacks-section = Pilas capturadas
about-telemetry-late-writes-section = Escrituras demoradas
about-telemetry-raw-payload-section = Contenido sin procesar
about-telemetry-raw = JSON sin procesar
about-telemetry-full-sql-warning = NOTA: la depuración SQL lenta está activada. Pueden mostrarse cadenas completas de SQL debajo, pero no se enviarán a Telemetry.
about-telemetry-fetch-stack-symbols = Recuperar nombres de funciones para las pilas
about-telemetry-hide-stack-symbols = Mostrar datos de la pila sin procesarlos
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] datos de la versión
       *[prerelease] datos de la versión preliminar
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] habilitada
       *[disabled] deshabilitada
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } muestra, media = { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } muestras, media = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Esta página muestra la información de rendimiento, hardware, uso y personalizaciones recopilada por Telemetry. Esta información se envía a { $telemetryServerOwner } para ayudar a mejorar { -brand-full-name }.
about-telemetry-settings-explanation = Telemetry está recopilando { about-telemetry-data-type } y la subida está <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Cada parte de información se envía empaquetada en "<a data-l10n-name="ping-link">pings</a>". Está viendo el ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Cada parte de información se envía agrupada en "<a data-l10n-name="ping-link">pings</a>". Está viendo los datos actuales.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Encontrar en { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Buscar en todas las secciones
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultados para "{ $searchTerms }"
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ¡Lo sentimos! No hay resultados en { $sectionName } de "{ $currentSearchText }"
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ¡Lo sentimos! No hay resultados para "{ $searchTerms }" en ningun sección
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ¡Lo sentimos! En este momento no hay datos disponibles en "{ $sectionName }"
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = datos actuales
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = todo
# button label to copy the histogram
about-telemetry-histogram-copy = Copiar
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Sentencias SQL lentas en el hilo principal
about-telemetry-slow-sql-other = Sentencias SQL lentas en hilos auxiliares
about-telemetry-slow-sql-hits = Aciertos
about-telemetry-slow-sql-average = Tiempo medio (ms)
about-telemetry-slow-sql-statement = Sentencia
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID del complemento
about-telemetry-addon-table-details = Detalles
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Proveedor { $addonProvider }
about-telemetry-keys-header = Propiedad
about-telemetry-names-header = Nombre
about-telemetry-values-header = Valor
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (contador de capturas: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Escritura demorada #{ $lateWriteCount }
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Mapa de memoria:
about-telemetry-error-fetching-symbols = Ha sucedido un error al recuperar los símbolos. Compruebe que está conectado a Internet y vuelva a intentarlo.
about-telemetry-time-stamp-header = fecha y hora
about-telemetry-category-header = categoría
about-telemetry-method-header = método
about-telemetry-object-header = objeto
about-telemetry-extra-header = extra
about-telemetry-origin-section = Telemetry de origen
about-telemetry-origin-origin = origen
about-telemetry-origin-count = número
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry </a> codifica los datos antes de enviarlos para que { $telemetryServerOwner } pueda contarlos, pero no sepa si algún { -brand-product-name } en concreto contribuyó a ese conteo. (<a data-l10n-name="prio-blog-link">Saber más</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } proceso
