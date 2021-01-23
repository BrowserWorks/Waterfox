# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Izvor ping podataka:
about-telemetry-show-current-data = Trenutni podaci
about-telemetry-show-archived-ping-data = Arhivirani ping podaci
about-telemetry-show-subsession-data = Prikaži podatke podsesije
about-telemetry-choose-ping = Izaberi ping:
about-telemetry-archive-ping-type = Vrsta pinga
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Danas
about-telemetry-option-group-yesterday = Jučer
about-telemetry-option-group-older = Starije
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetrijski podaci
about-telemetry-current-store = Trenutna trgovina:
about-telemetry-more-information = Tražite više informacija?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> sadrži vodiče kako koristiti naše podatkovne alate.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetry client documentation</a> uključuje definicije koncepata, API dokumentaciju i podatkovne reference.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetry dashboard-i</a> vam omogućavaju da vizualizirate podatke koje Mozilla prima putem Telemetrije.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link"> Rječnik sonde </a> pruža detalje i opise za sonde koje je prikupio Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Otvori u JSON pregledniku
about-telemetry-home-section = Početna
about-telemetry-general-data-section = Opći podaci
about-telemetry-environment-data-section = Podaci okruženja
about-telemetry-session-info-section = Informacije o sesiji
about-telemetry-scalar-section = Skalari
about-telemetry-keyed-scalar-section = Keyed skalari
about-telemetry-histograms-section = Histogrami
about-telemetry-keyed-histogram-section = Histogrami s ključem
about-telemetry-events-section = Događaji
about-telemetry-simple-measurements-section = Jednostavna mjerenja
about-telemetry-slow-sql-section = Spori SQL iskazi
about-telemetry-addon-details-section = Detalji add-ona
about-telemetry-captured-stacks-section = Uhvaćeni stackovi
about-telemetry-late-writes-section = Kasni zapisi
about-telemetry-raw-payload-section = Sirovi podaci
about-telemetry-raw = Sirovi JSON
about-telemetry-full-sql-warning = NAPOMENA: Debuggiranje sporog SQL-a je omogućeno. Puni SQL stringovi mogu biti prikazani ispod ali neće biti poslani Telemetry-u.
about-telemetry-fetch-stack-symbols = Dobavi nazive funkcija za stack-ove
about-telemetry-hide-stack-symbols = Prikaži sirove stack podatke
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] podaci puštanja
       *[prerelease] podaci prije puštanja
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] omogućeno
       *[disabled] onemogućeno
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } uzorak, prosjek = { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } uzorci, prosjek = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ova stranica prikazuje informacije o performansama, hardveru, upotrebi i prilagođavanjima koje je prikupio Telemetrija. Ove informacije su poslate { $telemetryServerOwner }-i kako bi unaprijedila { -brand-full-name }.
about-telemetry-settings-explanation = Telemetrija prikuplja { about-telemetry-data-type } i slanje je podešeno na <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Svaki dio informacije je poslan u paketu “<a data-l10n-name="ping-link">pingova</a>”. Vi gledate u { $name }, { $timestamp } ping.
about-telemetry-data-details-current = Svaki dio informacije je poslan u paketu “<a data-l10n-name="ping-link">pingova</a>“. Vi gledate u trenutne podatke.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Pronađi u { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Pronađi u svim sekcijama
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Rezultati za “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Žao nam je! Nema rezultata za “{ $currentSearchText }” u { $sectionName }
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Žao nam je! Nema rezultata za “{ $searchTerms }” ni u jednoj sekciji
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Žao nam je! Trenutno nema podataka dostupnih u “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = trenutni podaci
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = svi
# button label to copy the histogram
about-telemetry-histogram-copy = Kopiraj
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Spori SQL iskazi na glavnoj niti
about-telemetry-slow-sql-other = Spori SQL iskazi na pomoćnim nitima
about-telemetry-slow-sql-hits = Pogodaka
about-telemetry-slow-sql-average = Prosječno vrijeme (ms)
about-telemetry-slow-sql-statement = Iskaz
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID add-ona
about-telemetry-addon-table-details = Detalji
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } provajder
about-telemetry-keys-header = Osobina
about-telemetry-names-header = Naziv
about-telemetry-values-header = Vrijednost
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (broj hvatanja: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Kasni zapis #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Memorijska mapa:
about-telemetry-error-fetching-symbols = Desila se greška pri dobavljanju simbola. Provjerite da li ste povezani na internet i pokušajte ponovo.
about-telemetry-time-stamp-header = vremenska oznaka
about-telemetry-category-header = kategorija
about-telemetry-method-header = metoda
about-telemetry-object-header = objekat
about-telemetry-extra-header = ekstra
about-telemetry-origin-section = Porijeklo Telemetry
about-telemetry-origin-origin = porijeklo
about-telemetry-origin-count = broj
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> kodira podatke prije slanja tako da { $telemetryServerOwner } može brojati stvari, ali ne zna da li neki { -brand-product-name } doprinosi tom broju. (<a data-l10n-name="prio-blog-link">saznajte više</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } proces
