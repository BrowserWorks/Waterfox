# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping datakilde:
about-telemetry-show-current-data = Nuværende data
about-telemetry-show-archived-ping-data = Arkiverede ping-data
about-telemetry-show-subsession-data = Vis data fra undersession
about-telemetry-choose-ping = Vælg ping:
about-telemetry-archive-ping-type = Ping-type
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = I dag
about-telemetry-option-group-yesterday = I går
about-telemetry-option-group-older = Ældre
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetry-data
about-telemetry-current-store = Nuværende lager: 
about-telemetry-more-information = Leder du efter mere information?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Waterfox Data Documentation</a> indeholder guider om, hvordan du kan arbejde med vores dataværktøjer
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Waterfox Telemetry client documentation</a> indeholder definitioner af koncepter, API-dokumentation og data-referencer.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetry dashboards</a> giver dig mulighed for at visualisere de data, Waterfox modtager via Telemetry.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> viser detaljer og beskrivelser for data indsamlet af Telemetry.
about-telemetry-show-in-Waterfox-json-viewer = Åbn i JSON-vieweren
about-telemetry-home-section = Start
about-telemetry-general-data-section = Generelle data
about-telemetry-environment-data-section = Miljø-data
about-telemetry-session-info-section = Sessionsoplysninger
about-telemetry-scalar-section = Skalarer
about-telemetry-keyed-scalar-section = Indtastede skalarer
about-telemetry-histograms-section = Histogrammer
about-telemetry-keyed-histogram-section = Indtastede histogrammer
about-telemetry-events-section = Begivenheder
about-telemetry-simple-measurements-section = Simple målinger
about-telemetry-slow-sql-section = Langsomme SQL-statements
about-telemetry-addon-details-section = Detaljer for tilføjelser
about-telemetry-captured-stacks-section = Stakke
about-telemetry-late-writes-section = Sene skrivninger
about-telemetry-raw-payload-section = Råt payload
about-telemetry-raw = Rå JSON
about-telemetry-full-sql-warning = Bemærk: Langsom SQL-debugging er aktiveret. Hele SQL-strenge vil måske være vist nedenfor, men de bliver ikke sendt til Telemetry.
about-telemetry-fetch-stack-symbols = Hent navne for funktioner for stakke
about-telemetry-hide-stack-symbols = Vis rå data fra stakke
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] release-data
       *[prerelease] pre-release-data
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] aktiveret
       *[disabled] deaktiveret
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats = 
    { $sampleCount ->
        [one] { $sampleCount } prøve, gennemsnit = { $prettyAverage }, sum = { $sum }
       *[other] { $sampleCount } prøver, gennemsnit = { $prettyAverage }, sum = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = Denne side viser Telemetrys indsamlede data om ydelse, hardware, brug og tilpasninger. De indsamlede data sendes til { $telemetryServerOwner } for at hjælpe med at forbedre { -brand-full-name }.
about-telemetry-settings-explanation = Telemetry indsamler { about-telemetry-data-type } og upload er <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = De enkelte informationer sendes samlet i "<a data-l10n-name="ping-link">pings</a>". Du kigger på pinget { $name }, { $timestamp }.
about-telemetry-data-details-current = De enkelte informationer sendes samlet i "<a data-l10n-name="ping-link">pings</a>". Du kigger på de nuværende data.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Søg i { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Søg i alle sektioner
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Søgeresultater for "{ $searchTerms }"
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Der er ingen forekomster af "{ $currentSearchText }" i { $sectionName }
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Der er ingen forekomster af "{ $searchTerms }" i nogen sektioner
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Der er ingen tilgængelige data i "{ $sectionName }"
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = nuværende data
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = alle
# button label to copy the histogram
about-telemetry-histogram-copy = Kopier
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Langsomme SQL-statements i hovedtråden
about-telemetry-slow-sql-other = Langsomme SQL-statements i hjælpertråde
about-telemetry-slow-sql-hits = Antal
about-telemetry-slow-sql-average = Gennemsnitlig tid (ms)
about-telemetry-slow-sql-statement = Statement
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID for tilføjelse
about-telemetry-addon-table-details = Detaljer
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider }-oplysninger
about-telemetry-keys-header = Egenskab
about-telemetry-names-header = Navn
about-telemetry-values-header = Værdi
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (antal fanget: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Sen skrivning: #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Memory-map:
about-telemetry-error-fetching-symbols = Der opstod en fejl ved hentning af symboler. Undersøg, om du er forbundet til internettet og prøv igen.
about-telemetry-time-stamp-header = tidsstempel
about-telemetry-category-header = kategori
about-telemetry-method-header = metode
about-telemetry-object-header = objekt
about-telemetry-extra-header = ekstra
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = origin
about-telemetry-origin-count = antal
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Waterfox Origin Telemetry</a> koder data, før de bliver sendt. Det betyder, at { $telemetryServerOwner } kan tælle ting, men ikke vide, om en given installation af { -brand-product-name } bidrog til det samlede antal. <a data-l10n-name="prio-blog-link">Læs mere</a>
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process }-proces
