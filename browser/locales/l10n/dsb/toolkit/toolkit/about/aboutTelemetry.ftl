# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Žrědło pingdatow:
about-telemetry-show-current-data = Aktualne daty
about-telemetry-show-archived-ping-data = Archiwěrowane pingdaty
about-telemetry-show-subsession-data = Daty pódpósejźenja pokazaś
about-telemetry-choose-ping = Ping wubraś:
about-telemetry-archive-ping-type = Ping-typ
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Źinsa
about-telemetry-option-group-yesterday = Cora
about-telemetry-option-group-older = Staršy
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetrijne daty
about-telemetry-current-store = Aktualny wobchod:
about-telemetry-more-information = Pytaśo dalšne informacije?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Datowa dokumentacija Firefox</a> rozpokazanja wó źěłanju z našymi datowymi rědami wopśimujo.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Klientowa dokumentacija za telemetriju Firefox</a> definicije za koncepty, API-dokumentaciju a datowe reference wopśimujo.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetrijowy pśeglěd</a> wam zmóžnja, daty wizualizěrowaś, kótarež Mozilla pśez telemetriju dostawa.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> staja drobnostki a wopisanja za proby k dispoziciji, kótarež su se nagromaźili z telemetriju.
about-telemetry-show-in-Firefox-json-viewer = W JSON-wobglědowaku wócyniś
about-telemetry-home-section = Startowy bok
about-telemetry-general-data-section = Powšykne daty
about-telemetry-environment-data-section = Wokolinowe daty
about-telemetry-session-info-section = Pósejźeńske informacije
about-telemetry-scalar-section = Skalary
about-telemetry-keyed-scalar-section = Skalary z klucom
about-telemetry-histograms-section = Histogramy
about-telemetry-keyed-histogram-section = Skoděrowane histogramy
about-telemetry-events-section = Tšojenja
about-telemetry-simple-measurements-section = Jadnore měrjenja
about-telemetry-slow-sql-section = Pómałe SQL-pśikaze
about-telemetry-addon-details-section = Drobnostki dodanka
about-telemetry-captured-stacks-section = Zwěsćone štapjele
about-telemetry-late-writes-section = Pózne pisańske procese
about-telemetry-raw-payload-section = Gropne wužywańske daty
about-telemetry-raw = Gropny JSON
about-telemetry-full-sql-warning = GLĚDAJŚO: Pytanje za zmólkami za pómałe SQL-pśikaze jo zmóžnjone. Dopołne znamuškowe rjeśazki SQL daju se dołojce zwobrazniś, ale njebudu se do telemetrije pśenosowaś.
about-telemetry-fetch-stack-symbols = Funkciske mjenja za štapjele wótwołaś
about-telemetry-hide-stack-symbols = Gropne štapjelowe daty pokazaś
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] daty wózjawjenja
       *[prerelease] daty pśedwózjawjenja
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] zmóžnjone
       *[disabled] znjemóžnjone
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } pśikład, pśerězk = { $prettyAverage }, suma = { $sum }
        [two] { $sampleCount } pśikłada, pśerězk = { $prettyAverage }, suma = { $sum }
        [few] { $sampleCount } pśikłady, pśerězk = { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } pśikładow, pśerězk = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Toś ten bok pokazujo informacije wó wugbaśu, hardware, wužyśu a pśiměrjenjach zběrane pśez telemetriju. Toś te informacije budu se do { $telemetryServerOwner } słaś, ab pomagali, { -brand-full-name } pólěpšyś.
about-telemetry-settings-explanation = Telemetrija { about-telemetry-data-type } zběra a <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> se nagrawaju.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Kužda informacija se w pakeśe do “<a data-l10n-name="ping-link">pingi</a>” sćelo. Glědaśo na ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Kužda informacija se w „<a data-l10n-name="ping-link">pingach</a>“ zapakowana sćelo. Glědaśo na aktualne daty.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = W { $selectedTitle } pytaś
about-telemetry-filter-all-placeholder =
    .placeholder = We wšych wótrězkach pytaś
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Wuslědki za “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Bóžko w { $sectionName } za “{ $currentSearchText }” žedne wuslědki njejsu
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Bóžko we wšych wótrězkach žedne wuslědki za “{ $searchTerms }” njejsu
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Bóžko tuchylu žedne daty w “{ $sectionName }” k dispoziciji njejsu
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = aktualne daty
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = wše
# button label to copy the histogram
about-telemetry-histogram-copy = Kopěrowaś
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Pómałe SQL-pśikaze na głownej nitce
about-telemetry-slow-sql-other = Pómałe SQL-pśikaze na pomogaŕskich nitkach
about-telemetry-slow-sql-hits = Trjefarje
about-telemetry-slow-sql-average = Pśerězny cas (ms)
about-telemetry-slow-sql-statement = Pśikaz
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID dodanka
about-telemetry-addon-table-details = Drobnostki
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Póbitowaŕ { $addonProvider }
about-telemetry-keys-header = Kakosć
about-telemetry-names-header = Mě
about-telemetry-values-header = Gódnota
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (licba zregistrěrowanjow: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Pózny pisański proces #{ $lateWriteCount }
about-telemetry-stack-title = Štapjel:
about-telemetry-memory-map-title = Wužywanje składowaka:
about-telemetry-error-fetching-symbols = Pśi wołanju symbolow jo zmólka nastała. Skontrolěrujśo, lěc sćo z internetom zwězany a wopytajśo hyšći raz.
about-telemetry-time-stamp-header = casowy kołk
about-telemetry-category-header = kategorija
about-telemetry-method-header = metoda
about-telemetry-object-header = objekt
about-telemetry-extra-header = wósebny
about-telemetry-origin-section = Telemetrija Origin
about-telemetry-origin-origin = póchad
about-telemetry-origin-count = licba
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Telemetrija Origin Firefox</a> daty koděrujo, nježli až se pósćelu, aby { $telemetryServerOwner } mógał wěcy licyś, ale njewě, lěc daty { -brand-product-name } jo k licbje pśinosował. (<a data-l10n-name="prio-blog-link">dalšne informacije</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Proces { $process }
