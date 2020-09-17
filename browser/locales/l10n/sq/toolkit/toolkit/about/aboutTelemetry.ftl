# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Burim të dhënash ping-u:
about-telemetry-show-current-data = Të dhëna të tanishme
about-telemetry-show-archived-ping-data = Të dhëna ping-u të arkivuara
about-telemetry-show-subsession-data = Shfaqni të dhëna nënsesioni
about-telemetry-choose-ping = Zgjidhni ping:
about-telemetry-archive-ping-type = Lloj Ping-u
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Sot
about-telemetry-option-group-yesterday = Dje
about-telemetry-option-group-older = Më të vjetër
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Të dhëna Telemetry-e
about-telemetry-current-store = Depo e Tanishme:
about-telemetry-more-information = Po kërkoni për më tepër informacion?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Dokumentimi i të Dhënave të Firefox-it</a> përmban udhërrëfyes se si të punohet me mjetet tona për të dhënat.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Dokumentimi i klientit të Firefox Telemetry-së</a> përfshin përkufizime për koncepte, dokumentim të API-t dhe referenca të dhënash.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Pultet e Telemetry-së</a> ju lejojnë të vizualizoni të dhënat që Mozilla merr përmes Telemetry-së.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Fjalori i Mostrave</a> furnizon hollësi dhe përshkrime të mostrave të grumbulluara nga Telemetry-a.
about-telemetry-show-in-Firefox-json-viewer = Hape në parësin JSON
about-telemetry-home-section = Kreu
about-telemetry-general-data-section = Të dhëna të Përgjithshme
about-telemetry-environment-data-section = Të dhëna Mjedisi
about-telemetry-session-info-section = Të dhëna Sesioni
about-telemetry-scalar-section = Skalarë
about-telemetry-keyed-scalar-section = Skalarë Me Fjalëkyçe
about-telemetry-histograms-section = Histograme
about-telemetry-keyed-histogram-section = Histograme Me Kyç
about-telemetry-events-section = Akte
about-telemetry-simple-measurements-section = Matje të Thjeshta
about-telemetry-slow-sql-section = Deklarime SQL të Ngadalta
about-telemetry-addon-details-section = Hollësi Shtese
about-telemetry-captured-stacks-section = Stack-e të Ndjekur
about-telemetry-late-writes-section = Shkrime të Vonshme
about-telemetry-raw-payload-section = Ngarkesë e Papërpunuar
about-telemetry-raw = JSON të papërpunuar
about-telemetry-full-sql-warning = SHËNIM: Diagnostikimi i Ngadalësisë në SQL është i aktivizuar. Vargjet e plota SQL mund të shfaqen më poshtë, por ato nuk do t'i parashtrohen Telemetry-së.
about-telemetry-fetch-stack-symbols = Sill emra funksionesh për stack-e
about-telemetry-hide-stack-symbols = Shfaq të dhëna të papërpunuara stack-u
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] të dhëna hedhjeje në qarkullim
       *[prerelease] të dhëna hedhjeje paraprake në qarkullim
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] i aktivizuar
       *[disabled] i çaktivizuar
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } kampion, mesatare = { $prettyAverage }, sum = { $sum }
       *[other] { $sampleCount } kampionë, mesatare = { $prettyAverage }, sum = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Në këtë faqe shfaqen të dhënat e grumbulluara nga Telemetry-a rreth funksionimit, hardware-it, përdorimit dhe përshtatjeve. Këto të dhëna i parashtrohen { $telemetryServerOwner }-it për të ndihmuar në përmirësimin e { -brand-full-name }.
about-telemetry-settings-explanation = Telemetry-a po grumbullon { about-telemetry-data-type } dhe ngarkimi është <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Çdo pjesë të dhënash dërgohet e paketuar në “<a data-l10n-name="ping-link">ping-e</a>”. Po shihni ping-un { $name }, { $timestamp }.
about-telemetry-data-details-current = Çdo element informacioni dërgohet i paketuar në “<a data-l10n-name="ping-link">pingje</a>“.Po shihni të dhënat e tanishme.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Gjeni në { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Gjeni në krejt seksionet
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Përfundime për “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Na ndjeni! S’ka përfundime në { $sectionName } për “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Na ndjeni! S’ka përfundime në ndonjë seksion për “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Na ndjeni! S’ka të dhëna të passhme në “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = të dhëna të tanishme
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = krejt
# button label to copy the histogram
about-telemetry-histogram-copy = Kopjoje
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Deklarime SQL të Ngadalta në Rrjedhën Kryesore
about-telemetry-slow-sql-other = Deklarime SQL të Ngadalta në Rrjedhat Ndihmëse
about-telemetry-slow-sql-hits = Vizita
about-telemetry-slow-sql-average = Kohë Mesatare (ms)
about-telemetry-slow-sql-statement = Deklarim
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID Shtese
about-telemetry-addon-table-details = Hollësi
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Ofrues i { $addonProvider }
about-telemetry-keys-header = Veti
about-telemetry-names-header = Emër
about-telemetry-values-header = Vlerë
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (numër hasjesh: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Shkrim i Vonshëm #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Hartë kujtese:
about-telemetry-error-fetching-symbols = Ndodhi një gabim gjatë prurjes së simboleve. Kontrolloni nëse jeni a jo të lidhur në Internet dhe riprovoni.
about-telemetry-time-stamp-header = vulë kohore
about-telemetry-category-header = kategori
about-telemetry-method-header = metodë
about-telemetry-object-header = objekt
about-telemetry-extra-header = ekstra
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = origjinë
about-telemetry-origin-count = numër
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> i fshehtëzon të dhënat përpara se të dërgohen, në mënyrë që { $telemetryServerOwner } të mund të numërojë gjëra, por pa ditur nëse çfarëdo { -brand-product-name } i dhënë kontribuoi apo jo në atë numër. (<a data-l10n-name="prio-blog-link">mësoni më tepër</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Proces { $process }
