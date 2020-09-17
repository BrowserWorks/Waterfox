# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Fonto de datumoj de «ping»:
about-telemetry-show-current-data = Nunaj datumoj
about-telemetry-show-archived-ping-data = Arkĥivo de datumoj de «ping»
about-telemetry-show-subsession-data = Montri datumojn de subseancoj
about-telemetry-choose-ping = Elekti «ping»:
about-telemetry-archive-ping-type = Tipo de «ping»
about-telemetry-archive-ping-header = «Ping»
about-telemetry-option-group-today = Hodiaŭ
about-telemetry-option-group-yesterday = Hieraŭ
about-telemetry-option-group-older = Antaŭe
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datumoj de telemezuro
about-telemetry-current-store = Nuna konservejo:
about-telemetry-more-information = Ĉu vi serĉas pli da informo?
about-telemetry-firefox-data-doc = La <a data-l10n-name="data-doc-link">dokumentaro pri datumoj de Firefox</a> enhavas gvidilojn pri la maniero labori per niaj datumaj iloj.
about-telemetry-telemetry-client-doc = La <a data-l10n-name="client-doc-link">dokumentaro pri klientoj de Telemezuro de Firefox</a> enhavas difinojn por konceptoj, dokumentaron de API kaj datumaj referencoj.
about-telemetry-telemetry-dashboard = La <a data-l10n-name="dashboard-link">paneloj de Telemezuro</a> permesas al vi vidi la datumojn, kiujn Mozilla ricevas pere de Telemezuro.
about-telemetry-telemetry-probe-dictionary = La <a data-l10n-name="probe-dictionary-link">sonda vortaro</a> provizas detalojn kaj priskribojn de la sondiloj uzataj de Telemezuro.
about-telemetry-show-in-Firefox-json-viewer = Malfermi per la vidigilo de JSON
about-telemetry-home-section = Komenco
about-telemetry-general-data-section = Ĝeneralaj datumoj
about-telemetry-environment-data-section = Datumoj de ĉirkaŭaĵo
about-telemetry-session-info-section = Informo pri seanco
about-telemetry-scalar-section = Skalaroj
about-telemetry-keyed-scalar-section = Skalaroj kun ŝlosilo
about-telemetry-histograms-section = Grafikaĵoj
about-telemetry-keyed-histogram-section = Indeksitaj histogramoj
about-telemetry-events-section = Eventoj
about-telemetry-simple-measurements-section = Simplaj mezuroj
about-telemetry-slow-sql-section = Montri instrukciojn de SQL
about-telemetry-addon-details-section = Detaloj de aldonaĵo
about-telemetry-captured-stacks-section = Kaptitaj stakoj
about-telemetry-late-writes-section = Malfruaj skriboj
about-telemetry-raw-payload-section = Kruda utilŝarĝo
about-telemetry-raw = Kruda JSON
about-telemetry-full-sql-warning = NOTE: Slow SQL debugging is enabled. Full SQL strings may be displayed below but they will not be submitted to Telemetry.
about-telemetry-fetch-stack-symbols = Sendi nomojn de funkcioj por stakoj
about-telemetry-hide-stack-symbols = Montri krudajn datumojn de stako
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] datumojn de stabila versio
       *[prerelease] datumojn de antaŭstabila versio
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] ŝaltita
       *[disabled] malŝaltita
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } specimeno, mezumo = { $prettyAverage }, sumo = { $sum }
       *[other] { $sampleCount } specimenoj, mezumo = { $prettyAverage }, sumo = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Tiu ĉi paĝo montras informon pri efikeco, aparataro, uzado kaj personaj agordoj kolektitaj de Telemetry. Tiu ĉi informo estos sendita al { $telemetryServerOwner } por helpi plibonigi { -brand-full-name }.
about-telemetry-settings-explanation = Telemezuro kolektas nun { about-telemetry-data-type } kaj la alŝuto estas <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Ĉiu informpeco estas sendita en pako ene de “<a data-l10n-name="ping-link">ping-oj</a>”. Vi nun vidas la ping { $name }, { $timestamp }.
about-telemetry-data-details-current = La informoj estas senditaj en pakedoj, kiuj nomiĝas “<a data-l10n-name="ping-link">pings</a>“. Vi vidas la nunajn datumojn.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Serĉi en { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Serĉi en ĉiuj sekcioj
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Rezultoj por “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Bedaŭrinde ne estis rezultoj por “{ $currentSearchText }” en { $sectionName }
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Bedaŭrinde ne estis rezultoj por “{ $searchTerms }” en iu ajn sekcio
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Bedaŭrinde nuntempe ne estas datumoj disponeblaj en “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = nunaj datumoj
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = ĉiuj
# button label to copy the histogram
about-telemetry-histogram-copy = Kopii
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Malrapidaj instrukcioj de SQL en la ĉefa fadeno
about-telemetry-slow-sql-other = Malrapidaj instrukcioj de SQL en helpaj fadenoj
about-telemetry-slow-sql-hits = Trafoj
about-telemetry-slow-sql-average = Meznombra tempo (ms)
about-telemetry-slow-sql-statement = Instrukcio
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Identigilo de aldonaĵo
about-telemetry-addon-table-details = Detaloj
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Provizanto de { $addonProvider }
about-telemetry-keys-header = Atributo
about-telemetry-names-header = Nomo
about-telemetry-values-header = Valoro
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (nombro de kaptoj: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Malfruaj skriboj #{ $lateWriteCount }
about-telemetry-stack-title = Stako:
about-telemetry-memory-map-title = Mapo de memoro:
about-telemetry-error-fetching-symbols = Eraro okazis dum la akirado de simboloj. Kontrolu ĉu vi estas konektita al la Interreto kaj klopodu denove.
about-telemetry-time-stamp-header = tempindiko
about-telemetry-category-header = kategorio
about-telemetry-method-header = metodo
about-telemetry-object-header = objekto
about-telemetry-extra-header = cetero
about-telemetry-origin-section = Telemezuro origina
about-telemetry-origin-origin = origino
about-telemetry-origin-count = nombro
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> kodigas la datumojn antaŭ ol sendi ilin, tiel ke { $telemetryServerOwner } povas kalkuli ilin, sed ne scii ĉu iu { -brand-product-name } kontribuis al tiu kalkulo. (<a data-l10n-name="prio-blog-link">pli da informo</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } procezo
