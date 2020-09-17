# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Andmete allikas:
about-telemetry-show-current-data = Praegused andmed
about-telemetry-show-archived-ping-data = Arhiveeritud andmed
about-telemetry-show-subsession-data = Kuvatakse alamseansside andmeid
about-telemetry-choose-ping = Vali ping:
about-telemetry-archive-ping-type = Pingu tüüp
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Täna
about-telemetry-option-group-yesterday = Eile
about-telemetry-option-group-older = Vanem
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemeetriaandmed
about-telemetry-current-store = Current Store:
about-telemetry-more-information = Soovid näha rohkem teavet?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefoxi andmete dokumentatsioon</a> sisaldab juhendeid selle kohta, kuidas meie andmetööriistu kasutada.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefoxi telemeetriaandmete kliendidokumentatsioon</a> sisaldab definitsioone mõistete, API dokumentatsiooni ja andmespetsifikatsioonide kohta.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemeetria koondpaneelid</a> võimaldavad sul visualiseerida neid andmeid, mida Mozilla telemeetria kaudu vastu võtab.
about-telemetry-telemetry-probe-dictionary = The <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> provides details and descriptions for the probes collected by Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Ava JSONi vaatajas
about-telemetry-home-section = Avaleht
about-telemetry-general-data-section = Üldandmed
about-telemetry-environment-data-section = Keskkonna andmed
about-telemetry-session-info-section = Seansi teave
about-telemetry-scalar-section = Skalaarid
about-telemetry-keyed-scalar-section = Võtmepõhised skalaarid
about-telemetry-histograms-section = Histogrammid
about-telemetry-keyed-histogram-section = Võtmepõhised histogrammid
about-telemetry-events-section = Sündmused
about-telemetry-simple-measurements-section = Lihtsad mõõdistused
about-telemetry-slow-sql-section = Aeglased SQL-päringud
about-telemetry-addon-details-section = Lisade üksikasjad
about-telemetry-captured-stacks-section = Captured Stacks
about-telemetry-late-writes-section = Hilised kirjutamised
about-telemetry-raw-payload-section = Eeltöötlemata last
about-telemetry-raw = algse JSONina
about-telemetry-full-sql-warning = MÄRKUS: Aeglase SQLi debugimine on lubatud. Allpool võidakse kuvada täielikke SQL-päringuid, aga neid ei saadeta telemeetria kaudu edasi.
about-telemetry-fetch-stack-symbols = Fetch function names for stacks
about-telemetry-hide-stack-symbols = Show raw stack data
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] stabiilse väljalaske andmeid
       *[prerelease] eelväljalaske andmeid
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] lubatud
       *[disabled] keelatud
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } sample, average = { $prettyAverage }, sum = { $sum }
       *[other] { $sampleCount } samples, average = { $prettyAverage }, sum = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = See leht näitab Telemetry kogutud jõudluse, riistvara, funktsionaalsuse kasutamise ja kohandamiste andmeid. See teave saadetakse { $telemetryServerOwner }le, et aidata kaasa { -brand-full-name }i edasiarendamisele.
about-telemetry-settings-explanation = Telemetry kogub { about-telemetry-data-type } ja üleslaadimine on <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Iga killuke informatsiooni on saadetud pakituna “<a data-l10n-name="ping-link">pingude</a>” sisse. Sa oled vaatamas { $name }, { $timestamp } pingu.
about-telemetry-data-details-current = Iga killuke informatsiooni on saadetud pakituna “<a data-l10n-name="ping-link">pingude</a>“ sisse. Sa oled vaatamas praeguseid andmeid.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Otsi sektsioonist { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Otsi kõigist sektsioonidest
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Tulemused otsingule “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Vabandust! Sektsioonist { $sectionName } ei leitud tulemusi otsingule “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Vabandust! Ühestki sektsioonist ei leitud tulemusi otsingule “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Vabandust! Sektsioonis “{ $sectionName }” pole praegu andmeid
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = praegused andmed
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = kõik
# button label to copy the histogram
about-telemetry-histogram-copy = Kopeeri
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Aeglased SQL-päringud peamises lõimes
about-telemetry-slow-sql-other = Aeglased SQL-päringud abistavates lõimedes
about-telemetry-slow-sql-hits = Tabamusi
about-telemetry-slow-sql-average = Keskmine aeg (ms)
about-telemetry-slow-sql-statement = Päring
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Lisa ID
about-telemetry-addon-table-details = Üksikasjad
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } Provider
about-telemetry-keys-header = Omadus
about-telemetry-names-header = Nimi
about-telemetry-values-header = Väärtus
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (capture count: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Hiljutine kirjutamine #{ $lateWriteCount }
about-telemetry-stack-title = Pinu:
about-telemetry-memory-map-title = Mälujaotus:
about-telemetry-error-fetching-symbols = Sümbolite hankimisel esines viga. Kontrolli, et oled ühendatud internetiga, ja proovi uuesti.
about-telemetry-time-stamp-header = ajatempel
about-telemetry-category-header = kategooria
about-telemetry-method-header = meetod
about-telemetry-object-header = objekt
about-telemetry-extra-header = lisapäis
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = origin
about-telemetry-origin-count = count
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> encodes data before it is sent so that { $telemetryServerOwner } can count things, but not know whether or not any given { -brand-product-name } contributed to that count. (<a data-l10n-name="prio-blog-link">learn more</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } process
