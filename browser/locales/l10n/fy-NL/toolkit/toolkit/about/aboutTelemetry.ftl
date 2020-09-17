# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping-gegevensboarne:
about-telemetry-show-current-data = Aktuele gegevens
about-telemetry-show-archived-ping-data = Argivearre ping-gegevens
about-telemetry-show-subsession-data = Subsesjegegevens toane
about-telemetry-choose-ping = Ping kieze:
about-telemetry-archive-ping-type = Pingtype
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hjoed
about-telemetry-option-group-yesterday = Juster
about-telemetry-option-group-older = Alder
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetry-gegevens
about-telemetry-current-store = Aktuele winkel:
about-telemetry-more-information = Sykje jo mear ynformaasje?
about-telemetry-firefox-data-doc = De <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> befettet hantliedingen oer it wurkjen mei ús gegevensark.
about-telemetry-telemetry-client-doc = De <a data-l10n-name="client-doc-link">Firefox Telemetry-clientdokumintaasje</a> befettet definysjes foar konsepten, API-dokumintaasje en gegevensferwizingen.
about-telemetry-telemetry-dashboard = Mei de <a data-l10n-name="dashboard-link">Telemetry-dashboerds</a> kinne jo de gegevens fisualisearje dy't Mozilla fia Telemetry ûntfangt.
about-telemetry-telemetry-probe-dictionary = De <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> biedt details en beskriuwingen foar de probes dy't troch Telemetry sammele wurde.
about-telemetry-show-in-Firefox-json-viewer = Iepenje yn de JSON-viewer
about-telemetry-home-section = Startside
about-telemetry-general-data-section = Algemiene gegevens
about-telemetry-environment-data-section = Omjouwingsgegevens
about-telemetry-session-info-section = Sesjeynformaasje
about-telemetry-scalar-section = Skalars
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = Histogrammen
about-telemetry-keyed-histogram-section = Kaaihistogrammen
about-telemetry-events-section = Eveneminten
about-telemetry-simple-measurements-section = Ienfâldige mjittingen
about-telemetry-slow-sql-section = Stadige SQL-ynstruksjes
about-telemetry-addon-details-section = Add-on-details
about-telemetry-captured-stacks-section = Opnommen stacks
about-telemetry-late-writes-section = Lêste add-ons
about-telemetry-raw-payload-section = Net bewurke nettolading
about-telemetry-raw = Net bewurke JSON
about-telemetry-full-sql-warning = NOTE: Stadige SQL-debugging is ynskeakele. Folsleine SQL-strings kinne hjirûnder toand wurde, mar se sille net ferstjoerd wurde nei Telemetry.
about-telemetry-fetch-stack-symbols = Krij funksjenammen foar stacks
about-telemetry-hide-stack-symbols = Toan rûge stackgegevens
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] útjeftegegevens
       *[prerelease] pre-útjeftegegevens
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] ynskeakele
       *[disabled] útskeakele
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } foarbyld, gemiddelde = { $prettyAverage }, som = { $sum }
       *[other] { $sampleCount } foarbylden, gemiddelde = { $prettyAverage }, som = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Dizze side toant de ynformaasje oer prestaasje, hardware, gebrûk en oanpassingen sammele troch Telemetry. Dizze ynformaasje wurdt ferstjoerd nei { $telemetryServerOwner } om { -brand-full-name } te ferbetterjen.
about-telemetry-settings-explanation = Telemetry sammelet { about-telemetry-data-type } en oplaad is <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Elk stikje gegevens wurdt bondele yn ‘<a data-l10n-name="ping-link">pings</a>’ ferstjoerd. Jo sjogge nei de ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Elk stikje ynformaasje wurdt bondele ferstjoerd yn ‘<a data-l10n-name="ping-link">pings</a>’. Jo sjogge nei de aktuele gegevens.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Fyn yn { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Sykje yn alle seksjes
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultaten foar ‘{ $searchTerms }’
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Sorry! Der binne gjin resultaten yn { $sectionName } foar ‘{ $currentSearchText }’
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Sorry! Der binne gjin resultaten yn watfoar seksje foar ‘{ $searchTerms }’
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Sorry! Der binne op dit stuit gjin gegevens beskikber yn ‘{ $sectionName }’
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = aktuele gegevens
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = alle
# button label to copy the histogram
about-telemetry-histogram-copy = Kopiearje
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Stadige SQL-ynstruksjes op haadthread
about-telemetry-slow-sql-other = Stadige SQL-ynstruksjes op helpthreads
about-telemetry-slow-sql-hits = Hits
about-telemetry-slow-sql-average = Gem. tiid (ms)
about-telemetry-slow-sql-statement = Ynstruksje
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Add-on-ID
about-telemetry-addon-table-details = Details
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider }-Provider
about-telemetry-keys-header = Eigenskip
about-telemetry-names-header = Namme
about-telemetry-values-header = Wearde
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (opnimteller: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Lette skriuwaksje #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Unthâldtawizing:
about-telemetry-error-fetching-symbols = Der is in flater bard by it opheljen fan symboalen. Kontrolearje oft jo ferbûn binne mei it ynternet en probearje it opnij.
about-telemetry-time-stamp-header = tiidsoantsjutting
about-telemetry-category-header = kategory
about-telemetry-method-header = metoade
about-telemetry-object-header = objekt
about-telemetry-extra-header = ekstra
about-telemetry-origin-section = Origin-telemetry
about-telemetry-origin-origin = oarsprong
about-telemetry-origin-count = oantal
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Origin-telemetry yn Firefox</a> kodearret gegevens eardat se ferstjoerd wurde, sadat { $telemetryServerOwner } dingen telle kin, mar net witte kin of in bepaalde { -brand-product-name } wol of net oan dat oantal bydroegen hat. (<a data-l10n-name="prio-blog-link">mear ynfo</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process }-proses
