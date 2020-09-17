# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping mba’ekuaarã reñoiha:
about-telemetry-show-current-data = Mba’ekuaarã ag̃agua
about-telemetry-show-archived-ping-data = Ping mba’ekuaarã ñongatupyre
about-telemetry-show-subsession-data = Tembiapo’ive mba’ekuaarã jehchauka
about-telemetry-choose-ping = Ping jeporavo:
about-telemetry-archive-ping-type = Ping Peteĩchagua
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Ko’árape
about-telemetry-option-group-yesterday = Kuehe
about-telemetry-option-group-older = Tuichave
about-telemetry-previous-ping = < <
about-telemetry-next-ping = > >
about-telemetry-page-title = Telemetría mba’ekuaarã
about-telemetry-current-store = Ñembyatyha ag̃agua:
about-telemetry-more-information = ¿Ehekavépa marandu?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox mba’ekuaarã kuatia</a> oreko guataha mba’éichapa emba’apóta mba’ekuaarã rembipurúre.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Telemetry Firefox mba’éva kuatiatee</a> ogueroike mba’e ñemyesakã, API kuatiatee ha mba’ekuaarã rehegua.
about-telemetry-telemetry-dashboard = Umi <a data-l10n-name="dashboard-link">Telemetry rechaha</a> ohechauka ndéve Mozilla mba’ekuaarã og̃uahẽva Telemetry rupive.
about-telemetry-telemetry-probe-dictionary = Pe <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> ome’ẽ mba’emimi ha ñemoha’anga Telemetry ombyatyva’ekue sónda.
about-telemetry-show-in-Firefox-json-viewer = Eike JSON hechahápe
about-telemetry-home-section = Ñepyrũ
about-telemetry-general-data-section = Opaichagua marandu
about-telemetry-environment-data-section = Mba’ekuaarã tekohápe g̃uarã
about-telemetry-session-info-section = Marandu tembiapo rehegua
about-telemetry-scalar-section = Jejupi
about-telemetry-keyed-scalar-section = Jupikuaa papapýva
about-telemetry-histograms-section = Histograma
about-telemetry-keyed-histogram-section = Histograma ñemiguáva
about-telemetry-events-section = Tembiaporã
about-telemetry-simple-measurements-section = Ha’ãha hypy’ũ’ỹva
about-telemetry-slow-sql-section = Je’etepyre SQL imbegue
about-telemetry-addon-details-section = Moĩmbaha mba’emimi
about-telemetry-captured-stacks-section = Japyhypyre mbojo’a
about-telemetry-late-writes-section = Jehaipy mbotapykuéva
about-telemetry-raw-payload-section = Hetepy ojehecha’ỹva gueteri
about-telemetry-raw = Raw JSON
about-telemetry-full-sql-warning = HAIPYRE’I: SQL ñemopotĩ imbeguéva hendýma. Ikatu ohechauka joajuha opaichagua SQL rehegua hákatu noñemondomo’ãi Telemetry-pe.
about-telemetry-fetch-stack-symbols = Eguerujey tembiapoite réra jepytaite ojo’áva rehegua
about-telemetry-hide-stack-symbols = Ehechauka mba’ekuaarã mbojo’áva oĩmba’ỹva
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] mba’ekuaarã ñemyerakuã
       *[prerelease] mba’ekuaarã ñemyerakuã mirĩ
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] ijurujáma
       *[disabled] jejokopyre
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } techaukarã, mombyte = { $prettyAverage }, mboheta ={ $sum }
       *[other] { $sampleCount } techaukarã, mombyte = { $prettyAverage }, mboheta ={ $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ko kuatiarogue ohechauka marandu tembiapokue rehegua, hardware, jeporu ha ñemomba’etee ombyatýva Telemetry. Ko marandu oñemondo { $telemetryServerOwner }-pe oipytyvõ { -brand-full-name }-pe oiko porãve hag̃ua.
about-telemetry-settings-explanation = Telemetría ombyaty hína { about-telemetry-data-type } ha iñemyenyhẽ oĩ <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Marandu peteĩteĩva oñemondo “<a data-l10n-name="ping-link">Turuñe’ẽ</a>”-pe. Ehecha hína { $name }, { $timestamp } turuñe’ẽ.
about-telemetry-data-details-current = Marandu peteĩteĩva oñemondo “<a data-l10n-name="ping-link">“-pe. Ojehecha mba’ekuaarã ag̃agua.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Ejuhu { $selectedTitle }-pe
about-telemetry-filter-all-placeholder =
    .placeholder = Eheka opaite hendápe
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Apopyre { $searchTerms } pe g̃uarã
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ¡Rombyasy! Ndaipóri apopyre { $sectionName } pe “{ $currentSearchText }” pe g̃uarã
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ¡Rombyasy! Ndojejuhúi apopyre mamovete “{ $searchTerms }” pe g̃uarã
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ¡Rombyasy! Ndaipói mba’ekuaarã ojepurukuaáva ko’ag̃aite “{ $sectionName }”-pe
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = mba’ekuaarã ag̃agua
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = opavave
# button label to copy the histogram
about-telemetry-histogram-copy = Emomokõi
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Je’etepyre SQL imbeguéva pe tembiapoitépe
about-telemetry-slow-sql-other = Je’etepyre SQL imbeguéva pe tembiapo mokõiguávape
about-telemetry-slow-sql-hits = Jejapoporã
about-telemetry-slow-sql-average = Aravo ohasáva (ms)
about-telemetry-slow-sql-statement = Je’etepyre
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID moĩmbaha rehegua
about-telemetry-addon-table-details = Mba’emimi
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Me’ẽhára { $addonProvider }
about-telemetry-keys-header = Mba’etee
about-telemetry-names-header = Téra
about-telemetry-values-header = Tepykue
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (japyhypyre rehegua: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Jehaipy itapykuéva #{ $lateWriteCount }
about-telemetry-stack-title = Mbojo’apy:
about-telemetry-memory-map-title = Mandu’arenda mba’era’ãnga:
about-telemetry-error-fetching-symbols = Oiko peteĩ jejavy eguerusejeývo umi ta’ãnga’i. Ehechajey eimépa ñandutípe ha eha’ãjey upe rire.
about-telemetry-time-stamp-header = ára papaha
about-telemetry-category-header = mba’éichagua
about-telemetry-method-header = tapereko
about-telemetry-object-header = g̃uahẽseha
about-telemetry-extra-header = mbohetapy
about-telemetry-origin-section = Telemetría ñepyrũha
about-telemetry-origin-origin = Ñepyrũha
about-telemetry-origin-count = papa
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> ombopapapy mba’ekuaarã ojegueraha’ỹre { $telemetryServerOwner }-pe ikatúva omombe’u, hákatu ndoikuaái peteĩva { -brand-product-name } oipytyvõpa pe jepapápe. <a data-l10n-name="prio-blog-link">maranduve</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Tapereko { $process }
