# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping datu avots:
about-telemetry-show-archived-ping-data = Arhivētie ping dati
about-telemetry-show-subsession-data = Rādīt apakšsesiju datus
about-telemetry-choose-ping = Izvēlieties ping:
about-telemetry-archive-ping-type = Pinga tips
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Šodien
about-telemetry-option-group-yesterday = Vakar
about-telemetry-option-group-older = Vecāks
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetrijas dati
about-telemetry-more-information = Meklējat papildu informāciju?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox datu dokumentācijā</a> ir norādes par to kā strādāt ar mūsu datu rīkiem.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox telemetrijas klienta dokumentācijā</a> ir konceptu definīcijas, API dokumentācija un datu atsauces.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetrijas paneļi</a> ļauj vizualizēt Mozilla saņemtos telemetrijas datus.
about-telemetry-show-in-Firefox-json-viewer = Atvērt ar JSON pārlūku
about-telemetry-home-section = Sākums
about-telemetry-general-data-section = Vispārējie dati
about-telemetry-environment-data-section = Vides dati
about-telemetry-session-info-section = Sistēmas informācija
about-telemetry-scalar-section = Skalāri
about-telemetry-keyed-scalar-section = Apkopotie skalārie
about-telemetry-histograms-section = Histogrammas
about-telemetry-keyed-histogram-section = Atzīmētās histogrammas
about-telemetry-events-section = Notikumi
about-telemetry-simple-measurements-section = Vienkārši mērījumi
about-telemetry-slow-sql-section = Lēnie SQL vaicājumi
about-telemetry-addon-details-section = Papildinājumu informācija
about-telemetry-captured-stacks-section = Notverti steki
about-telemetry-late-writes-section = Vēlie rakstījumi
about-telemetry-raw-payload-section = Neapstrādātie dati
about-telemetry-raw = Neapstrādāts JSON
about-telemetry-full-sql-warning = Piezīme: Ir aktivizēta lēno SQL vaicājumu uzskaite. Pilnu SQL vaicājumu sarakstu var attēlot zemāk, taču tie netiks nosūtīti Telemetrijas sistēmai.
about-telemetry-fetch-stack-symbols = Iegūt funkciju nosaukumus kopām
about-telemetry-hide-stack-symbols = Rādīt neapstrādātus steka datus
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] laidiena dati
       *[prerelease] pirms laidiena dati
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] aktivēta
       *[disabled] deaktivēta
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Šī lapa attēlo veiktspējas un funkciju izmantojuma statistiku, kas apkopota ar Telemetry moduļa palīdzību. Šī informācija tiek anonīmi nosūtīta { $telemetryServerOwner }, lai palīdzētu uzlabot { -brand-full-name }.
about-telemetry-settings-explanation = Telemetrija vāc { about-telemetry-data-type } un augšupielāde ir <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Katra informācijas vienība ir iepakota “<a data-l10n-name="ping-link">pings</a>”. Jūs skatāties uz { $name } { $timestamp } pingu.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Meklēt { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Meklēt visās sadaļās
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” meklēšanas rezultāti
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Diemžēl meklējot “{ $currentSearchText }” iekš { $sectionName } nekas netika atrasts
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Diemžēl meklējot “{ $searchTerms }” visās sadaļās nekas netika atrasts
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Diemžēl šobrīd sadaļā “{ $sectionName }” dati nav pieejami
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = visi
# button label to copy the histogram
about-telemetry-histogram-copy = Kopēt
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Lēnie SQL vaicājumi galvenajā pavedienā
about-telemetry-slow-sql-other = Lēnie SQL vaicājumi papildus pavedienos
about-telemetry-slow-sql-hits = Skaits
about-telemetry-slow-sql-average = Vid. laiks (ms)
about-telemetry-slow-sql-statement = Vaicājums
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Papildinājuma ID
about-telemetry-addon-table-details = Informācija
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } piegādātājs
about-telemetry-keys-header = Parametrs
about-telemetry-names-header = Nosaukums
about-telemetry-values-header = Vērtība
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (tvērumu skaits: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Vēlie rakstījumi #{ $lateWriteCount }
about-telemetry-stack-title = Izsaukumu kopa:
about-telemetry-memory-map-title = Atmiņas karte:
about-telemetry-error-fetching-symbols = Iegūstot simbolus notikusi kļūda. Pārliecinieties, ka jūsu interneta savienojums darbojas korekti un mēģiniet vēlreiz.
about-telemetry-time-stamp-header = laika zīmogs
about-telemetry-category-header = kategorija
about-telemetry-method-header = metode
about-telemetry-object-header = objekts
about-telemetry-extra-header = papildu
