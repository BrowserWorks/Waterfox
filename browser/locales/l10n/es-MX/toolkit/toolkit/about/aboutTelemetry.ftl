# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Origen de los datos de ping:
about-telemetry-show-current-data = Datos actuales
about-telemetry-show-archived-ping-data = Datos archivados de ping
about-telemetry-show-subsession-data = Mostrar datos de subsesión
about-telemetry-choose-ping = Elegir ping:
about-telemetry-archive-ping-type = Tipo de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hoy
about-telemetry-option-group-yesterday = Ayer
about-telemetry-option-group-older = Más antiguo
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datos de Telemetry
about-telemetry-current-store = Almacenamiento actual:
about-telemetry-more-information = ¿Buscas más información?
about-telemetry-firefox-data-doc = La <a data-l10n-name="data-doc-link">documentación de datos de Waterfox</a> contiene guías sobre cómo trabajar con tus herramientas de datos.
about-telemetry-telemetry-client-doc = La <a data-l10n-name="client-doc-link">documentación de cliente de Waterfox Telemetry</a> incluye definiciones para conceptos, documentación de API y referencias de datos.
about-telemetry-telemetry-dashboard = Los <a data-l10n-name="dashboard-link">tableros de Telemetry</a> te permiten visualizar los datos que Waterfox recibe a través de Telemetry.
about-telemetry-telemetry-probe-dictionary = El <a data-l10n-name="probe-dictionary-link">diccionario de sondeos</a> proporciona detalles y descripciones de los sondeos recopilados por Telemetry.
about-telemetry-show-in-Waterfox-json-viewer = Abrir en el visor de JSON
about-telemetry-home-section = Inicio
about-telemetry-general-data-section =   Datos generales
about-telemetry-environment-data-section = Entorno de Datos
about-telemetry-session-info-section = Información de la sesión
about-telemetry-scalar-section =  Escalares
about-telemetry-keyed-scalar-section = Escalares con llave
about-telemetry-histograms-section = Histogramas
about-telemetry-keyed-histogram-section =   Histogramas claves
about-telemetry-events-section = Eventos
about-telemetry-simple-measurements-section = Medidas simples
about-telemetry-slow-sql-section = Sentencias SQL lentas
about-telemetry-addon-details-section = Detalles del complemento
about-telemetry-captured-stacks-section = Pilas capturadas
about-telemetry-late-writes-section = Escrituras demoradas
about-telemetry-raw-payload-section = Contenido sin procesar
about-telemetry-raw = JSON sin procesar
about-telemetry-full-sql-warning = NOTA: la depuración SQL lenta está activada. Pueden mostrarse cadenas completas de SQL pero no se enviarán a Telemetry.
about-telemetry-fetch-stack-symbols = Obtener nombres de función para pilas
about-telemetry-hide-stack-symbols = Mostrar datos de pila en bruto
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
        [enabled] habilitado
       *[disabled] deshabilitado
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } muestra, promedio = { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } muestras, promedio = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = Esta página muestra la información de rendimiento, hardware, uso y personalizaciones recopilada por Telemetry. Esta información se envía a { $telemetryServerOwner } para ayudar a mejorar { -brand-full-name }.
about-telemetry-settings-explanation = La telemetría está recolectando { about-telemetry-data-type } y la carga está <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Cada pieza de información se agregará a “<a data-l10n-name="ping-link">pings</a>”. Estás buscando por el ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Cada parte de información se envía agrupada en "<a data-l10n-name="ping-link">pings</a>". Estás viendo los datos actuales.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Buscar en { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Buscar en todas las secciones
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultados para “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ¡Lo sentimos! No hay resultados en { $sectionName } para “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ¡Lo sentimos! No se encontraron resultados en ninguna sección para “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ¡Lo sentimos! No hay datos disponibles en este momento en “{ $sectionName }”
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
about-telemetry-captured-stacks-title = { $stackKey } (cantidad de capturas: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Escritura demorada #{ $lateWriteCount }
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Mapa de memoria:
about-telemetry-error-fetching-symbols = Ha sucedido un error al recuperar los símbolos. Compruebe que está conectado a Internet y vuelva a intentarlo.
about-telemetry-time-stamp-header = timestamp
about-telemetry-category-header = categoría
about-telemetry-method-header = método
about-telemetry-object-header = objeto
about-telemetry-extra-header = extra
about-telemetry-origin-section = Telemetría de origen
about-telemetry-origin-origin = origen
about-telemetry-origin-count = recuento
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">La Telemetría de origen de Waterfox</a> codifica los datos antes de enviarlos para que { $telemetryServerOwner } pueda contar las cosas, pero no sepa cual fue el { -brand-product-name } que contributó a ese conteo. (<a data-l10n-name="prio-blog-link">Saber más</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Proceso de { $process }
