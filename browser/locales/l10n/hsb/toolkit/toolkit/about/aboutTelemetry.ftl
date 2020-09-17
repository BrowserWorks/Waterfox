# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Žórło pingdatow:
about-telemetry-show-current-data = Aktualne daty
about-telemetry-show-archived-ping-data = Archiwowane pingdaty
about-telemetry-show-subsession-data = Daty podposedźenja pokazać
about-telemetry-choose-ping = Ping wubrać:
about-telemetry-archive-ping-type = Ping-typ
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Dźensa
about-telemetry-option-group-yesterday = Wčera
about-telemetry-option-group-older = Starši
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetrijne daty
about-telemetry-current-store = Aktualny wobchod:
about-telemetry-more-information = Pytaće dalše informacije?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Datowa dokumentacija Firefox</a> nawody wo dźěłanju z našimi datowymi nastrojemi wobsahuje.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Klientowa dokumentacija za telemetriju Firefox</a> definicije za koncepty, API-dokumentaciju a datowe referency wobsahuje.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetrijowy přehlad</a> wam zmóžnja, daty wizualizować, kotrež Mozilla přez telemetriju dóstawa.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> staja podrobnosće a wopisanja za proby k dispoziciji, kotrež su so z telemetriju nahromadźili.
about-telemetry-show-in-Firefox-json-viewer = W JSON-wobhladowaku wočinić
about-telemetry-home-section = Startowa strona
about-telemetry-general-data-section = Powšitkowne daty
about-telemetry-environment-data-section = Wokolinowe daty
about-telemetry-session-info-section = Posedźenske informacije
about-telemetry-scalar-section = Skalary
about-telemetry-keyed-scalar-section = Skalary z klučom
about-telemetry-histograms-section = Histogramy
about-telemetry-keyed-histogram-section = Kodowane histogramy
about-telemetry-events-section = Podawki
about-telemetry-simple-measurements-section = Jednore měrjenja
about-telemetry-slow-sql-section = Pomałe SQL-přikazy
about-telemetry-addon-details-section = Podrobnosće přidatka
about-telemetry-captured-stacks-section = Natočene štaple
about-telemetry-late-writes-section = Pózdnje pisanske procesy
about-telemetry-raw-payload-section = Hrube wužiwanske daty
about-telemetry-raw = Hruby JSON
about-telemetry-full-sql-warning = KEDŹBU: Pytanje za zmylkami za pomałe SQL-přikazy je zmóžnjene. Dospołne znamješkowe rjećazki SQL hodźa so deleka zwobraznić, ale njebudu so do telemetrije přenošować.
about-telemetry-fetch-stack-symbols = Funkciske mjena za staple wotwołać
about-telemetry-hide-stack-symbols = Hrube staplowe daty pokazać
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] daty wozjewjenja
       *[prerelease] daty předwozjewjenja
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] zmóžnjene
       *[disabled] znjemóžnjene
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } přikład, přerězk = { $prettyAverage }, suma = { $sum }
        [two] { $sampleCount } přikładaj, přerězk = { $prettyAverage }, suma = { $sum }
        [few] { $sampleCount } přikłady, přerězk = { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } přikładow, přerězk = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Tuta strona pokazuje informacije wo wukonje, hardware, wužiću a přiměrjenjach zběrane přez telemetriju. Tute informacije budu so do { $telemetryServerOwner } słać, zo bychu pomhali, { -brand-full-name } polěpšić.
about-telemetry-settings-explanation = Telemetrija { about-telemetry-data-type } zběra a <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> so nahrawaja.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Kóžda informacija so w pakeće do “<a data-l10n-name="ping-link">pingi</a>” sćele. Hladaće na ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Kóžda informacija so w „<a data-l10n-name="ping-link">pingach</a>“ zapakowana sćele. Hladaće na aktualne daty.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = W { $selectedTitle } pytać
about-telemetry-filter-all-placeholder =
    .placeholder = We wšěch wotrězkach pytać
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Wuslědki za “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Bohužel žane wuslědki w { $sectionName } za “{ $currentSearchText }“ njejsu
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Bohužel we wšěch wotrězkach žane wuslědki za “{ $searchTerms }” njejsu
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Bohužel tuchwilu žane daty w “{ $sectionName }” k dispoziciji njejsu
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = aktualne daty
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = wšě
# button label to copy the histogram
about-telemetry-histogram-copy = Kopěrować
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Pomałe SQL-přikazy na hłownej nitce
about-telemetry-slow-sql-other = Pomałe SQL-přikazy na pomocnikowych nitkach
about-telemetry-slow-sql-hits = Trjechery
about-telemetry-slow-sql-average = Přerězny čas (ms)
about-telemetry-slow-sql-statement = Přikaz
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID přidatka
about-telemetry-addon-table-details = Podrobnosće
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Poskićowar { $addonProvider }
about-telemetry-keys-header = Kajkosć
about-telemetry-names-header = Mjeno
about-telemetry-values-header = Hódnota
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (ličba zapřijimanjow: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Pózdni pisanski proces #{ $lateWriteCount }
about-telemetry-stack-title = Stapl:
about-telemetry-memory-map-title = Wužiwanje składa:
about-telemetry-error-fetching-symbols = Při wołanju symbolow je zmylk wustupił. Skontrolujće, hač sće z internetom zwjazany a spytajće hišće raz.
about-telemetry-time-stamp-header = časowy kołk
about-telemetry-category-header = kategorija
about-telemetry-method-header = metoda
about-telemetry-object-header = objekt
about-telemetry-extra-header = wosebity
about-telemetry-origin-section = Telemetrija Origin
about-telemetry-origin-origin = pochad
about-telemetry-origin-count = ličba
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Telemetrija Origin Firefox</a> daty zaklučuje, prjedy hač so pósćelu, zo by { $telemetryServerOwner } móhł wěcy ličić, ale njewě, hač daty { -brand-product-name } je k ličbje přinošował. (<a data-l10n-name="prio-blog-link">dalše informacije</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Proces { $process }
