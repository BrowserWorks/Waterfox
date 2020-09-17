# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Zdroj údajov pre ping:
about-telemetry-show-current-data = Aktuálne údaje
about-telemetry-show-archived-ping-data = Archivované údaje príkazu ping
about-telemetry-show-subsession-data = Zobraziť údaje sub-relácie
about-telemetry-choose-ping = Zvoľte ping:
about-telemetry-archive-ping-type = Typ pingu
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Dnes
about-telemetry-option-group-yesterday = Včera
about-telemetry-option-group-older = Staršie
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Údaje telemetrie
about-telemetry-more-information = Hľadáte viac informácií?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Dokumentácia údajov Firefoxu</a> obsahuje návody pre prácu s našimi nástrojmi.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Dokumentácia klienta telemetrie Firefoxu</a> obsahuje definície pojmov, dokumentáciu API a popisy údajov.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Nástenky telemetrie</a> vám umožňujú zobrazovať údaje, ktoré Mozilla získava z telemetrie.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Zoznam sond</a> poskytuje podrobnosti a popisy sond, ktoré telemetria zbiera.
about-telemetry-show-in-Firefox-json-viewer = Otvoriť v zobrazení JSON
about-telemetry-home-section = Domov
about-telemetry-general-data-section = Všeobecné údaje
about-telemetry-environment-data-section = Údaje prostredia
about-telemetry-session-info-section = Informácia o relácii
about-telemetry-scalar-section = Skaláre
about-telemetry-keyed-scalar-section = Kľúčové skaláre
about-telemetry-histograms-section = Histogramy
about-telemetry-keyed-histogram-section = Histogramy s kľúčom
about-telemetry-events-section = Udalosti
about-telemetry-simple-measurements-section = Jednoduché merania
about-telemetry-slow-sql-section = Pomalé výrazy SQL
about-telemetry-addon-details-section = Podrobnosti o doplnkoch
about-telemetry-captured-stacks-section = Zachytené zásobníky
about-telemetry-late-writes-section = Neskoré zápisy
about-telemetry-raw-payload-section = Raw obsah
about-telemetry-raw = Dáta JSON v nespracovanom tvare
about-telemetry-full-sql-warning = Poznámka: Je zapnuté ladenie pomalých výrazov SQL. Nižšie môžu byť zobrazené celé výrazy SQL, avšak tieto nebudú odosielané pomocou telemetrie.
about-telemetry-fetch-stack-symbols = Získať názvy funkcií pre zásobníky zlyhaní
about-telemetry-hide-stack-symbols = Zobraziť nespracované údaje zásobníka
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] informácie o vydaní
       *[prerelease] informácie pred vydaním
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] povolené
       *[disabled] zakázané
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Táto stránka zobrazuje údaje o výkonnosti a využívaní funkcií zozbierané pomocou telemetrie. Informácie sú anonymne odosielané spoločnosti { $telemetryServerOwner } s cieľom vylepšiť program { -brand-full-name }.
about-telemetry-settings-explanation = Telemetria zbiera { about-telemetry-data-type } a odosielanie je <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Všetky informácie sú odosielané ako súčasť “<a data-l10n-name="ping-link">pings</a>”. Teraz sa pozeráte na ping { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Hľadať v sekcii { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Hľadať vo všetkých sekciách
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Výsledky vyhľadávania pre „{ $searchTerms }“
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Mrzí nás to, no pre hľadaný výraz „{ $currentSearchText }“ sme v sekcii { $sectionName } nič nenašli
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Mrzí nás to, no pre hľadaný výraz „{ $searchTerms }“ sme v žiadnej sekcii nič nenašli
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Mrzí nás to, no v sekcii „{ $sectionName }“ nie sú dostupné žiadne údaje
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = súčasné údaje
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = všetko
# button label to copy the histogram
about-telemetry-histogram-copy = Kopírovať
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Pomalé výrazy SQL v hlavnom vlákne
about-telemetry-slow-sql-other = Pomalé výrazy SQL v pomocných vláknach
about-telemetry-slow-sql-hits = Počet
about-telemetry-slow-sql-average = Priem. čas (ms)
about-telemetry-slow-sql-statement = Výraz
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Identifikátor doplnku
about-telemetry-addon-table-details = Podrobnosti
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } Provider
about-telemetry-keys-header = Kľúč
about-telemetry-names-header = Názov
about-telemetry-values-header = Hodnota
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (počet zachytení: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Neskorý zápis #{ $lateWriteCount }
about-telemetry-stack-title = Zásobník:
about-telemetry-memory-map-title = Mapa pamäte:
about-telemetry-error-fetching-symbols = Pri získavaní symbolov sa vyskytla chyba. Uistite sa, že počítač je pripojený k sieti Internet a skúste to znova.
about-telemetry-time-stamp-header = časová známka
about-telemetry-category-header = kategória
about-telemetry-method-header = metóda
about-telemetry-object-header = objekt
about-telemetry-extra-header = extra
about-telemetry-origin-section = Origin telemetria
about-telemetry-origin-origin = origin
about-telemetry-origin-count = počet
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = typ procesu: { $process }
