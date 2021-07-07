# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping datakälla:
about-telemetry-show-current-data = Aktuell data
about-telemetry-show-archived-ping-data = Arkiverad ping-data
about-telemetry-show-subsession-data = Visa undersessionsdata
about-telemetry-choose-ping = Välj ping:
about-telemetry-archive-ping-type = Ping-typ
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Idag
about-telemetry-option-group-yesterday = Igår
about-telemetry-option-group-older = Äldre
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetridata
about-telemetry-current-store = Aktuell lagringsplats:
about-telemetry-more-information = Letar du efter mer information?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox datadokumentation</a> innehåller guider om hur du arbetar med våra datainställningar.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetry klientdokumentation</a> innehåller definitioner för begrepp, API-dokumentation och datareferenser.
about-telemetry-telemetry-dashboard = Med <a data-l10n-name="dashboard-link">Telemetry översikter</a> kan du visualisera de data som Mozilla tar emot via telemetri.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> innehåller detaljer och beskrivningar för de sonder som samlats in av Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Öppna i JSON-visaren
about-telemetry-home-section = Hem
about-telemetry-general-data-section = Allmän data
about-telemetry-environment-data-section = Miljödata
about-telemetry-session-info-section = Sessionsinformation
about-telemetry-scalar-section = Skalärer
about-telemetry-keyed-scalar-section = Nyckelbaserade skalärer
about-telemetry-histograms-section = Histogram
about-telemetry-keyed-histogram-section = Nyckelhistogram
about-telemetry-events-section = Händelser
about-telemetry-simple-measurements-section = Enkla mätningar
about-telemetry-slow-sql-section = Långsamma SQL-satser
about-telemetry-addon-details-section = Tilläggsdetaljer
about-telemetry-captured-stacks-section = Fångade stackar
about-telemetry-late-writes-section = Sena skrivningar
about-telemetry-raw-payload-section = Rå nyttolast
about-telemetry-raw = Rå JSON
about-telemetry-full-sql-warning = OBS: Långsam SQL-felsökning är aktiverad. Fullständiga SQL-strängar kan visas nedan men de kommer inte att skickas in av Telemetri.
about-telemetry-fetch-stack-symbols = Hämta funktionsnamn för stackar
about-telemetry-hide-stack-symbols = Visa rå stackdata
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] release data
       *[prerelease] pre-release-data
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] aktiverad
       *[disabled] inaktiverad
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } prov, medel = { $prettyAverage }, summa = { $sum }
       *[other] { $sampleCount } prover, medel = { $prettyAverage }, summa = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Den här sidan visar information om prestanda, hårdvara, användning och anpassningar insamlad av telemetri. Den här informationen skickas till { $telemetryServerOwner } för att hjälpa till att förbättra { -brand-full-name }.
about-telemetry-settings-explanation = Telemetri samlar in { about-telemetry-data-type } och uppladdning är <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Varje del av information skickas sammanslagen i “<a data-l10n-name="ping-link">pings</a>”. Du tittar på ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Varje del av information skickas sammanslagen i “<a data-l10n-name="ping-link">pings</a>“. Du tittar på aktuell data.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Sök i { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Sök i alla sektioner
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultat för “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Förlåt! Det finns inga resultat i { $sectionName } för “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Förlåt! Det finns inga resultat i någon sektion för “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Förlåt! Det finns för närvarande inga data tillgängliga i “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = aktuell data
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = allt
# button label to copy the histogram
about-telemetry-histogram-copy = Kopiera
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Långsamma SQL-satser på Main-tråden
about-telemetry-slow-sql-other = Långsamma SQL-satser på Helper-trådar
about-telemetry-slow-sql-hits = Träffar
about-telemetry-slow-sql-average = Genomsnitt (ms)
about-telemetry-slow-sql-statement = Sats
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Tillägg-ID
about-telemetry-addon-table-details = Detaljer
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider }-leverantör
about-telemetry-keys-header = Egenskap
about-telemetry-names-header = Namn
about-telemetry-values-header = Värde
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (antal fångade: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Sen skrivning #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Minneskarta:
about-telemetry-error-fetching-symbols = Ett fel uppstod vid hämtning av symboler. Kontrollera att du är ansluten till internet och försök igen.
about-telemetry-time-stamp-header = tidsstämpel
about-telemetry-category-header = kategori
about-telemetry-method-header = metod
about-telemetry-object-header = objekt
about-telemetry-extra-header = extra
about-telemetry-origin-section = Origin-telemetri
about-telemetry-origin-origin = ursprung
about-telemetry-origin-count = antal
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox origin-telemetri</a> kodar data innan den skickas så att { $telemetryServerOwner } kan räkna saker, men vet inte om någon given { -brand-product-name } bidrog till det antalet. (<a data-l10n-name="prio-blog-link">läs mer</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Process { $process }
