# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Sursa datelor de ping:
about-telemetry-show-current-data = Date actuale
about-telemetry-show-archived-ping-data = Date arhivate de ping
about-telemetry-show-subsession-data = Afișează datele despre subsesiune
about-telemetry-choose-ping = Alege ping:
about-telemetry-archive-ping-type = Tip de ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Astăzi
about-telemetry-option-group-yesterday = Ieri
about-telemetry-option-group-older = Mai vechi
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Date de telemetrie
about-telemetry-current-store = Magazin actual:
about-telemetry-more-information = Cauți mai multe informații?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Documentația de date Firefox</a> conține ghiduri despre cum să lucrezi cu uneltele noastre de date.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Documentația privind clientul de telemetrie Firefox</a> include definiții de concepte, documentație API și referințe de date.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Tabloul de bord pentru telemetrie</a> îți permite să vizualizezi datele pe care Mozilla le primește prin intermediul telemetriei.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Dicționarul de sonde</a> furnizează detalii și descrieri ale sondelor gestionate de telemetrie.
about-telemetry-show-in-Firefox-json-viewer = Deschide în vizualizatorul JSON
about-telemetry-home-section = Pagină de start
about-telemetry-general-data-section = Date generale
about-telemetry-environment-data-section = Date privind mediul
about-telemetry-session-info-section = Informații privind sesiunea
about-telemetry-scalar-section = Scalari
about-telemetry-keyed-scalar-section = Scalari cu cuvinte cheie
about-telemetry-histograms-section = Histograme
about-telemetry-keyed-histogram-section = Histograme de chei
about-telemetry-events-section = Evenimente
about-telemetry-simple-measurements-section = Măsurători simple
about-telemetry-slow-sql-section = Instrucțiuni SQL lente
about-telemetry-addon-details-section = Detalii privind suplimentele
about-telemetry-captured-stacks-section = Stive capturate
about-telemetry-late-writes-section = Scrieri întârziate
about-telemetry-raw-payload-section = Sarcină utilă brută
about-telemetry-raw = JSON brut
about-telemetry-full-sql-warning = NOTĂ: Depanarea SQL lentă este activată. Șirurile SQL complete ar putea fi afișate mai jos, însă acestea nu vor fi transmise către Telemetrie.
about-telemetry-fetch-stack-symbols = Obține numele funcțiilor pentru stive
about-telemetry-hide-stack-symbols = Afișează datele brute ale stivelor
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] date privind versiunea stabilă
       *[prerelease] date privind versiunea preliminară
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] activată
       *[disabled] dezactivată
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } mostră, media = { $prettyAverage }, suma = { $sum }
        [few] { $sampleCount } mostre, media = { $prettyAverage }, suma = { $sum }
       *[other] { $sampleCount } de mostre, media = { $prettyAverage }, suma = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Această pagină afișează informațiile colectate prin telemetrie despre performanță, hardware, utilizare și personalizări. Aceste informații sunt trimise la { $telemetryServerOwner } pentru a ajuta la îmbunătățirea { -brand-full-name }.
about-telemetry-settings-explanation = Telemetria colectează { about-telemetry-data-type } și încărcarea este <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Fiecare bucată de informație este trimisă ca fiind împachetată în „<a data-l10n-name="ping-link">pinguri</a>”. Acum te uiți la pingul { $name }, { $timestamp }.
about-telemetry-data-details-current = Fiecare informație este trimisă în pachete în „<a data-l10n-name="ping-link">pinguri</a>”. Acum vezi datele actuale.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Caută în { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Caută în toate secțiunile
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Rezultate pentru „{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Ne pare rău! Nu există rezultate în { $sectionName } pentru „{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Ne pare rău! Nu există rezultate în vreo secțiune pentru „{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Ne pare rău! În prezent nu sunt date disponibile în „{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = date actuale
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = toate
# button label to copy the histogram
about-telemetry-histogram-copy = Copiază
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Instrucțiuni SQL lente din firul principal
about-telemetry-slow-sql-other = Instrucțiuni SQL lente din firele asistente (helper threads)
about-telemetry-slow-sql-hits = Afișări
about-telemetry-slow-sql-average = Timp mediu (ms)
about-telemetry-slow-sql-statement = Instrucțiune
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID-ul suplimentului
about-telemetry-addon-table-details = Detalii
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Furnizor { $addonProvider }
about-telemetry-keys-header = Proprietate
about-telemetry-names-header = Nume
about-telemetry-values-header = Valoare
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (numărul capturărilor: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Scriere târzie #{ $lateWriteCount }
about-telemetry-stack-title = Stivă:
about-telemetry-memory-map-title = Harta memoriei:
about-telemetry-error-fetching-symbols = A apărut o eroare la preluarea simbolurilor. Verifică dacă ești conectat la internet și încearcă din nou.
about-telemetry-time-stamp-header = marcaj de timp
about-telemetry-category-header = categorie
about-telemetry-method-header = metodă
about-telemetry-object-header = obiect
about-telemetry-extra-header = extra
about-telemetry-origin-section = Telemetrie de origine
about-telemetry-origin-origin = origine
about-telemetry-origin-count = număr
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> codifică datele înainte de transmitere astfel încât { $telemetryServerOwner } poate număra, dar nu știe dacă orice { -brand-product-name } dat a contribuit sau nu la numărătoarea respectivă. (<a data-l10n-name="prio-blog-link">learn more</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Proces { $process }
