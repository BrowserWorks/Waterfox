# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Podatkovni vir pinga:
about-telemetry-show-current-data = Trenutni podatki
about-telemetry-show-archived-ping-data = Arhivirani podatki pinga
about-telemetry-show-subsession-data = Prikaži podatke podseje
about-telemetry-choose-ping = Izberite ping:
about-telemetry-archive-ping-type = Vrsta pinga
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Danes
about-telemetry-option-group-yesterday = Včeraj
about-telemetry-option-group-older = Starejše
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetrija
about-telemetry-current-store = Trenutna shramba:
about-telemetry-more-information = Iščete več informacij?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Dokumentacija o Firefoxovih podatkih</a> vsebuje vodnike o tem, kako uporabljati naša podatkovna orodja.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Dokumentacija o Firefoxovem odjemalcu za telemetrijo</a> vsebuje definicije konceptov, dokumentacijo API in sklice podatkov.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Pregledne plošče telemetrije</a> omogočajo predstavitev podatkov, ki jih Mozilla prejme preko telemetrije.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Slovar sond</a> vsebuje podrobnosti in opise sond, ki jih zbira telemetrija.
about-telemetry-show-in-Firefox-json-viewer = Odpri v pregledovalniku JSON
about-telemetry-home-section = Domov
about-telemetry-general-data-section = Splošni podatki
about-telemetry-environment-data-section = Podatki o okolju
about-telemetry-session-info-section = Podatki o seji
about-telemetry-scalar-section = Skalarji
about-telemetry-keyed-scalar-section = Skalarji s ključi
about-telemetry-histograms-section = Histogrami
about-telemetry-keyed-histogram-section = Histogrami s ključi
about-telemetry-events-section = Dogodki
about-telemetry-simple-measurements-section = Enostavne meritve
about-telemetry-slow-sql-section = Počasni stavki SQL
about-telemetry-addon-details-section = Podrobnosti dodatkov
about-telemetry-captured-stacks-section = Zajeti skladi
about-telemetry-late-writes-section = Poznejša pisanja
about-telemetry-raw-payload-section = Neobdelana koristna vsebina
about-telemetry-raw = Neobdelan JSON
about-telemetry-full-sql-warning = Opomba: Vključeno je razhroščevanje počasnega SQL. Spodaj se lahko pojavijo celotni nizi SQL, vendar ne bodo poslani telemetriji.
about-telemetry-fetch-stack-symbols = Zbiraj imena funkcij za sklade
about-telemetry-hide-stack-symbols = Prikaži neobdelane podatke sklada
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] podatke ob izdaji
       *[prerelease] predizdajne podatke
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] omogočeno
       *[disabled] onemogočeno
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } vzorec, povprečno = { $prettyAverage }, skupno = { $sum }
        [two] { $sampleCount } vzorca, povprečno = { $prettyAverage }, skupno = { $sum }
        [few] { $sampleCount } vzorci, povprečno = { $prettyAverage }, skupno = { $sum }
       *[other] { $sampleCount } vzorcev, povprečno = { $prettyAverage }, skupno = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ta stran prikazuje podatke o učinkovitosti in uporabi funkcij, ki jih zbira telemetrija. Podatki se anonimno pošiljajo organizaciji { $telemetryServerOwner }, da bi lahko izboljšala { -brand-full-name }.
about-telemetry-settings-explanation = Telemetrija zbira { about-telemetry-data-type } in nalaganje je <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Vsak podatek je poslan skupaj s “<a data-l10n-name="ping-link">pingi</a>”. Prikazan je ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Vsak podatek je poslan skupaj s “<a data-l10n-name="ping-link">pingi</a>”. Prikazani so trenutni podatki.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Najdi v { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Najdi v vseh odsekih
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Rezultati za "{ $searchTerms }"
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Oprostite! V { $sectionName } ni zadetkov za “{ $currentSearchText }”.
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Oprostite! V nobenem odseku ni zadetkov za “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Oprostite! V “{ $sectionName }” trenutno ni podatkov.
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = trenutni podatki
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = vse
# button label to copy the histogram
about-telemetry-histogram-copy = Kopiraj
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Počasni stavki SQL glavne niti
about-telemetry-slow-sql-other = Počasni stavki SQL pomožnih niti
about-telemetry-slow-sql-hits = Zadetki
about-telemetry-slow-sql-average = Povp. čas (ms)
about-telemetry-slow-sql-statement = Stavek
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID dodatka
about-telemetry-addon-table-details = Podrobnosti
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Ponudnik { $addonProvider }
about-telemetry-keys-header = Lastnost
about-telemetry-names-header = Ime
about-telemetry-values-header = Vrednost
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (število zajemov: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Poznejše pisanje #{ $lateWriteCount }
about-telemetry-stack-title = Sklad:
about-telemetry-memory-map-title = Pomnilniški razpored:
about-telemetry-error-fetching-symbols = Med zbiranjem simbolov je prišlo do napake. Preverite povezavo z internetom in poskusite znova.
about-telemetry-time-stamp-header = časovni žig
about-telemetry-category-header = kategorija
about-telemetry-method-header = metoda
about-telemetry-object-header = predmet
about-telemetry-extra-header = dodatno
about-telemetry-origin-section = Telemetrija izvora
about-telemetry-origin-origin = izvor
about-telemetry-origin-count = število
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefoxova telemetrija izvora</a> šifrira podatke pred pošiljanjem, tako da { $telemetryServerOwner } lahko šteje, ne more pa vedeti, ali je kateri { -brand-product-name } prispeval k številu. (<a data-l10n-name="prio-blog-link">več o tem</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Proces { $process }
