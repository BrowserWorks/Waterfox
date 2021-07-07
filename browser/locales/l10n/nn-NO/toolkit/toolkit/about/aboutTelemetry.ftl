# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Pingdata-kjelde
about-telemetry-show-current-data = Gjeldande data
about-telemetry-show-archived-ping-data = Arkiverte ping-data
about-telemetry-show-subsession-data = Vis underøkt-data
about-telemetry-choose-ping = Vel ping:
about-telemetry-archive-ping-type = Ping-type
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = I dag
about-telemetry-option-group-yesterday = I går
about-telemetry-option-group-older = Eldre
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetri-data
about-telemetry-current-store = Gjeldande lagringsplass:
about-telemetry-more-information = Ser du etter mer informasjon?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Waterfox Data Documentation</a> inneheld rettleiingar om korleis du jobbar med dataverktøa våre.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Waterfox Telemetry-klientdokumentasjonen</a> inneheld definisjonar for konsept, API-dokumentasjon og datareferansar.
about-telemetry-telemetry-dashboard = Med <a data-l10n-name="dashboard-link">Telemetry-panelet</a> kan du visualisere dataa Waterfox får via Telementry.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> gjev detaljar og skildringar for sondar som vert samla inn av Telemetry.
about-telemetry-show-in-Waterfox-json-viewer = Opne i JSON-visar
about-telemetry-home-section = Heim
about-telemetry-general-data-section = Generelle data
about-telemetry-environment-data-section = Miljødata
about-telemetry-session-info-section = Øktinformasjon
about-telemetry-scalar-section = Skalarar
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = Histogram
about-telemetry-keyed-histogram-section = Histogram etter nyklar
about-telemetry-events-section = Hendingar
about-telemetry-simple-measurements-section = Enkle målingar
about-telemetry-slow-sql-section = Trege SQL-uttrykk
about-telemetry-addon-details-section = Tilleggsdetaljar
about-telemetry-captured-stacks-section = Fanga stakkar
about-telemetry-late-writes-section = Sein skriving
about-telemetry-raw-payload-section = Rå nyttelast
about-telemetry-raw = Rå JSON
about-telemetry-full-sql-warning = MERK: Treg SQL-feilsøking er påslått. Fullstendige SQL-uttrykk kan visast nedanfor, men dei vert ikkje sendt inn til Telemetry.
about-telemetry-fetch-stack-symbols = Hent funksjonsnamn for stablar
about-telemetry-hide-stack-symbols = Vis rå stackdata
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] utgjevingsdata
       *[prerelease] før-utgjevingsdata
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] slått på
       *[disabled] slått av
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } utval, gjennomsnitt = { $prettyAverage }, sum = { $sum }
       *[other] { $sampleCount } utval, gjennomsnitt = { $prettyAverage }, sum = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = Denne sida viser info om yting, maskinvare, bruksmønster og utvidingar som er innsamla av Telemetri. Denne infoen vert sendt til { $telemetryServerOwner } for å hjelpe til med å forbetre { -brand-full-name }.
about-telemetry-settings-explanation = Telemetri samlar inn { about-telemetry-data-type } og opplastinga er <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Kvar informasjonsdel vert sendt i ein pakke til “<a data-l10n-name="ping-link">ping</a>”. Du ser på ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Kvar informasjonsdel blir sendt i ein pakke til «<a data-l10n-name="ping-link">pings</a>». Du ser på gjeldande data.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Søk i { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Søk i alle seksjonar
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultat for “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Beklagar! Det er ingen resultat i { $sectionName } for «{ $currentSearchText }»
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Det finnes ingen resultat i nokon seksjon for «{ $searchTerms }»
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Det finst ingen data tilgjengelege i «{ $sectionName }»
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = gjeldande data
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = alt
# button label to copy the histogram
about-telemetry-histogram-copy = Kopier
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Trege SQL-uttrykk på hovudtråden
about-telemetry-slow-sql-other = Trege SQL-uttrykk på hjelpetrådar
about-telemetry-slow-sql-hits = Treff
about-telemetry-slow-sql-average = Gjsn. tid (ms)
about-telemetry-slow-sql-statement = Uttrykk
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Tilleggs-ID
about-telemetry-addon-table-details = Detaljar
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider }-tilbydar
about-telemetry-keys-header = Eigenskap
about-telemetry-names-header = Namn
about-telemetry-values-header = Verdi
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (tal på fanga: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Sein skriving #{ $lateWriteCount }
about-telemetry-stack-title = Stakk:
about-telemetry-memory-map-title = Minnekart:
about-telemetry-error-fetching-symbols = Ein feil oppstod ved henting av symbol. Kontroller at du er tilkopla Internett, og prøv igjen.
about-telemetry-time-stamp-header = tidsstempel
about-telemetry-category-header = kategori
about-telemetry-method-header = metode
about-telemetry-object-header = objekt
about-telemetry-extra-header = ekstra
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = opphav
about-telemetry-origin-count = mengde
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Waterfox origin-telemetri</a> kodar data før dei vert sende. Det tyder at { $telemetryServerOwner } kan telje ting, men ikkje vite om ein bestemt installasjon av { -brand-product-name } bidrog til den samla mengda. (<a data-l10n-name="prio-blog-link">les meir</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process }-prosess
