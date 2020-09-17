# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Mammenn roadennoù ping :
about-telemetry-show-archived-ping-data = Roadennoù ping diellet
about-telemetry-show-subsession-data = Diskouez ar roadennoù iz-estez
about-telemetry-choose-ping = Dibabit ar ping :
about-telemetry-archive-ping-type = Rizh ar ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Hiziv
about-telemetry-option-group-yesterday = Derc'h
about-telemetry-option-group-older = Koshoc'h
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Roadennoù Telemetry
about-telemetry-more-information = O klask muioc'h a ditouroù?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Teuliadur roadennoù Firefox</a> a ginnig sturlevrioù evit kompren penaos implij hor ostilhoù roadennoù.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Teuliadur arval pellventerezh Firefox</a> a enkorf despizadurioù evit meizadoù, teuliadurioù API ha daveennoù roadennoù.
about-telemetry-telemetry-dashboard = Gant an <a data-l10n-name="dashboard-link">daolenn bellventerezh</a> e c'hallit gwelet ar roadennoù resevet gant Mozilla dre ar pellventerezh.
about-telemetry-telemetry-probe-dictionary = Ar <a data-l10n-name="probe-dictionary-link">geriadur standilhonoù</a> a ro munudoù ha deskrivadurioù evit ar standilhonoù dastumet gant Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Digeriñ er gweler JSON
about-telemetry-home-section = Degemer
about-telemetry-general-data-section = Roadennoù hollek
about-telemetry-environment-data-section = Roadennoù endro
about-telemetry-session-info-section = Titouroù an estez
about-telemetry-scalar-section = Skeuliadoù
about-telemetry-keyed-scalar-section = Skeuliadelloù alc'hwez
about-telemetry-histograms-section = Tellunioù
about-telemetry-keyed-histogram-section = Tellunioù gant alc'hwezioù
about-telemetry-events-section = Darvoudoù
about-telemetry-simple-measurements-section = Muzulioù eeun
about-telemetry-slow-sql-section = Azgoulennoù SQL gorrek
about-telemetry-addon-details-section = Munudoù an askouezh
about-telemetry-captured-stacks-section = Bernioù euvret
about-telemetry-late-writes-section = Skrivadurioù diwezhat
about-telemetry-raw-payload-section = Karg diaoz
about-telemetry-raw = JSON diaoz
about-telemetry-full-sql-warning = NOTENN : Gweredekaet eo diveugañ an azgoulennoù SQL gorrek. Azgoulennoù SQL klok a c'hell bezañ diskouezet amañ dindan met ne vint ket kaset da Delemetry.
about-telemetry-fetch-stack-symbols = Atoriñ an anvioù arc'hwel evit an tornioù
about-telemetry-hide-stack-symbols = Diskouez ar roadennoù tornioù diaoz
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] roadennoù an ermaeziadenn stabil
       *[prerelease] roadennoù ar rakermaeziadenn
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] gweredekaet
       *[disabled] diweredekaet
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } standilhon, keidenn = { $prettyAverage }, sammad = { $sum }
        [two] { $sampleCount } standilhon, keidenn = { $prettyAverage }, sammad = { $sum }
        [few] { $sampleCount } standilhon, keidenn = { $prettyAverage }, sammad = { $sum }
        [many] { $sampleCount } a standilhonoù, keidenn = { $prettyAverage }, sammad = { $sum }
       *[other] { $sampleCount } standilhon, keidenn = { $prettyAverage }, sammad = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ar bajenn-mañ a ziskouez ar roadennoù a-fet digonusted, periant, arver ha personelaat dastumet gant Telemetry. Kaset eo an titouroù-mañ da { $telemetryServerOwner } evit skoazellañ gwellaat { -brand-full-name }.
about-telemetry-settings-explanation = Ar pellventerezh a zo o tastum { about-telemetry-data-type } ha <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> eo ar pellgas.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Kement titour a zo paket ha kaset e “<a data-l10n-name="ping-link">pingoù</a>”. Emaoc'h o sellout ouzh ar ping { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Klask e { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Klask en holl gevrennoù
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Disoc'hoù evit “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Digarezit! N'eus disoc'h ebet e { $sectionName } evit “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Digarezit! N'eus disoc'h ebet evit “{ $searchTerms }” e kevrenn ebet
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Digarezit! N'eus roadenn ebet hegerz e “{ $sectionName }”
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = pep tra
# button label to copy the histogram
about-telemetry-histogram-copy = Eilañ
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Azgoulennoù SQL gorrek e-barzh an neudenn bennañ
about-telemetry-slow-sql-other = Azgoulennoù SQL gorrek e-barzh an neudennoù a eil renk
about-telemetry-slow-sql-hits = Konter
about-telemetry-slow-sql-average = Padelezh keitat (ms)
about-telemetry-slow-sql-statement = Azgoulenn
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Naoudi an askouezh
about-telemetry-addon-table-details = Munudoù
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Pourchaser evit { $addonProvider }
about-telemetry-keys-header = Perzh
about-telemetry-names-header = Anv
about-telemetry-values-header = Gwerzh
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (niver a dapadennoù: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Skrivadur diwezhat #{ $lateWriteCount }
about-telemetry-stack-title = Torn :
about-telemetry-memory-map-title = Kartenn ar vemor:
about-telemetry-error-fetching-symbols = Degouezhet ez eus bet ur fazi e-pad atoriñ an arouezioù. Gwiriit ez oc'h kennasket ouzh ar genrouedad ha klaskit en-dro.
about-telemetry-time-stamp-header = Merk-amzer
about-telemetry-category-header = rummad
about-telemetry-method-header = hentenn
about-telemetry-object-header = ergorenn
about-telemetry-extra-header = ouzhpenn
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = orin
about-telemetry-origin-count = niver
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> a enboneg ar roadennoù a-raok kas anezho evit ma c'hallfe { $telemetryServerOwner } kontañ an traoù met n'hallfe ket gouzout m'eo enkorfet { -brand-product-name } en niver hollek. (<a data-l10n-name="prio-blog-link">Gouzout hiroc'h</a>)
