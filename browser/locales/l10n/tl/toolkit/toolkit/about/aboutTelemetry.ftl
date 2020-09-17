# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = I-ping ang data source:
about-telemetry-show-current-data = Kasalukuyang data
about-telemetry-show-archived-ping-data = Naka-archive na ping data
about-telemetry-show-subsession-data = Ipakita ang subsession data
about-telemetry-choose-ping = Piliin ang ping:
about-telemetry-archive-ping-type = Klase ng Ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Ngayon
about-telemetry-option-group-yesterday = Kahapon
about-telemetry-option-group-older = Luma
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetry Data
about-telemetry-current-store = Kasalukuyang Store:
about-telemetry-more-information = Naghahanap ng karagdagang impormasyon?
about-telemetry-firefox-data-doc = Ang <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> ay naglalaman ng mga gabay tungkol sa kung paano gumagana ang aming mga kagamitan sa mga datos.
about-telemetry-telemetry-client-doc = Ang <a data-l10n-name="client-doc-link">Firefox Telemetry client documentation</a> ay naglalakip ng mga pagbigay-kahulugan para sa mga konsepto, mga dokumentasyon sa API at pinanggagalingan ng mga datos.
about-telemetry-telemetry-dashboard = Ang <a data-l10n-name="dashboard-link">Telemetry dashboards</a> ay nagbigay daan sa iyo na maipakita ang mga datos na matatanggap ng Mozilla sa pamamagitan ng Telemetry.
about-telemetry-telemetry-probe-dictionary = Ang <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> ay nagbibigay ng mga detalye at paglalarawan sa mga probe na kinolekta ng Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Buksan sa viewer ng JSON
about-telemetry-home-section = Home
about-telemetry-general-data-section = Pangkalahatang Impormasyon
about-telemetry-environment-data-section = Environment Data
about-telemetry-session-info-section = Impormasyon ng Session
about-telemetry-scalar-section = Scalars
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = Histograms
about-telemetry-keyed-histogram-section = Keyed Histograms
about-telemetry-events-section = Mga Kaganapan
about-telemetry-simple-measurements-section = Simpleng Mga Sukat
about-telemetry-slow-sql-section = Slow SQL Statements
about-telemetry-addon-details-section = Detalye ng Add-on
about-telemetry-captured-stacks-section = Captured Stacks
about-telemetry-late-writes-section = Huling Sulat
about-telemetry-raw-payload-section = Raw Payload
about-telemetry-raw = Raw JSON
about-telemetry-full-sql-warning = NOTE: Pinagana ang mabagal na debugging ng SQL. Maaaring ipakita ang mga string ng buong SQL sa ibaba ngunit hindi ito isusumite sa Telemetry.
about-telemetry-fetch-stack-symbols = Kunin ang mga pangalan ng function para sa mga stack
about-telemetry-hide-stack-symbols = Ipakita ang data ng raw stack
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] pinalabas na mga datos
       *[prerelease] bago-ipalabas na mga datos
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] pinagana
       *[disabled] hindi pinagana
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } sample, average = { $prettyAverage }, kabuuan = { $sum }
       *[other] { $sampleCount } sample, average = { $prettyAverage }, kabuuan = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ang pahinang ito ay nagpapakita ng impormasyon tungkol sa pagganap, hardware, paggamit at mga pagpapasadya na nakolekta sa pamamagitan Telemetry. Ang impormasyon na ito ay isinumite sa { $telemetryServerOwner } upang makatulong na mapabuti { -brand-full-name }.
about-telemetry-settings-explanation = Ang telemetry ay nangongolekta ng { about-telemetry-data-type } at ang upload ay si <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Bawat piraso ng impormasyon ay pinadala na nakabungkos sa “<a data-l10n-name="ping-link">pings</a>”. Ikaw ay nakatingin sa { $name }, { $timestamp } na ping.
about-telemetry-data-details-current = Bawat piraso ng impormasyon ay pinapadala nang naka-bundle sa mga “<a data-l10n-name="ping-link">ping</a>“. Tinitingnan mo ang kasalukuyang data.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Hanapin sa { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Hanapin sa lahat ng mga seksyon
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Mga resulta para sa “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Ipagpaumanhin! Walang mga resulta sa { $sectionName } para sa “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Ipagpaumanhin! Walang mga resulta sa kahit na anong seksyon para sa “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Ipagpaumanhin! Walang kasalukuyang mga datos na magagamit sa “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = kasalukuyang data
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = lahat
# button label to copy the histogram
about-telemetry-histogram-copy = Kopya
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Mahinang pahayag sa SQL Main Thread
about-telemetry-slow-sql-other = Mahinang SQL na pahayag sa Katulong na Threads
about-telemetry-slow-sql-hits = Hits
about-telemetry-slow-sql-average = Avg. Time (ms)
about-telemetry-slow-sql-statement = Pahayag
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Add-on ID
about-telemetry-addon-table-details = Mga detalye
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } Provider
about-telemetry-keys-header = Property
about-telemetry-names-header = Pangalan
about-telemetry-values-header = Halaga
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (capture count: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Huli na Sinulat ${ $lateWriteCount }
about-telemetry-stack-title = Stack
about-telemetry-memory-map-title = Memory map:
about-telemetry-error-fetching-symbols = May naganap na error habang kinukuha ang simbolo. Siguruhing konektado ka sa Internet at subukan uli.
about-telemetry-time-stamp-header = timestamp
about-telemetry-category-header = categorya
about-telemetry-method-header = paraan
about-telemetry-object-header = bagay
about-telemetry-extra-header = dagdag
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = pinanggalingan
about-telemetry-origin-count = bilang
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = Ang <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> ay nag-e-encode ng data bago ipadala para makapagbilang ang { $telemetryServerOwner }, pero hindi malalaman kung may kahit anong { -brand-product-name } na dumagdag sa bilang na iyon. (<a data-l10n-name="prio-blog-link">alamin</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } process
