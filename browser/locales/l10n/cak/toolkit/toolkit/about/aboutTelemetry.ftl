# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Kixe'el ri taq rutzij ping:
about-telemetry-show-current-data = Tzij wakami
about-telemetry-show-archived-ping-data = Yakon taq rutzij ri ping
about-telemetry-show-subsession-data = Kek'ut pe taq rutzij rachmolojri'ïl
about-telemetry-choose-ping = Ticha' ping:
about-telemetry-archive-ping-type = Ruwäch chi Ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Wakami
about-telemetry-option-group-yesterday = Iwir
about-telemetry-option-group-older = Ojer
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Taq rutzij Telemetry
about-telemetry-current-store = K'ayb'äl Wakami:
about-telemetry-more-information = ¿La nakanoj ch'aqa' chik etamab'äl?
about-telemetry-firefox-data-doc = Ri <a data-l10n-name="data-doc-link">Firefox Tzij Wujunïk</a> k'o taq rucholajem samaj chupam, akuchi' nusik'ij rub'eyal yeqasamajij ri kisamajib'al qatzij.
about-telemetry-telemetry-client-doc = Ri <a data-l10n-name="client-doc-link">Firefox Telemetry winäq wujib'äl</a> k'o taq kitzijol tzij chupam, API wujib'äl chuqa' ketal taq tzij.
about-telemetry-telemetry-dashboard = Ri <a data-l10n-name="dashboard-link">Telemetry dashboards</a> nuya' q'ij chawe ye'atz'ët ri taq tzij yeruk'ül ri Mozilla ruma Telemetry.
about-telemetry-telemetry-probe-dictionary = Ri <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> nuya' b'anikil chuqa' taq kitzijoxkil ojqanela' emolon ruma ri Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Tijaq pa JSON tz'etonel
about-telemetry-home-section = Tikirib'äl
about-telemetry-general-data-section = Chijun taq Tzij
about-telemetry-environment-data-section = Ruk'ojlib'al tzij
about-telemetry-session-info-section = Etamab'äl pa ruwi' molojri'ïl
about-telemetry-scalar-section = Jotob'enïk
about-telemetry-keyed-scalar-section = Xakb'äl rik'in ewan tzij
about-telemetry-histograms-section =   Tem K'ulwäch
about-telemetry-keyed-histogram-section =   Taq ruk'u'x Tem K'ulwäch
about-telemetry-events-section = Taq Nimaq'ij
about-telemetry-simple-measurements-section =   Relik taq etab'äl
about-telemetry-slow-sql-section =   Taq b'ab' SQL ajeqal
about-telemetry-addon-details-section =   Kib'anikil tz'aqat
about-telemetry-captured-stacks-section = Chapon tzub'aj
about-telemetry-late-writes-section =   Yaloj taq tz'ib'anïk
about-telemetry-raw-payload-section = Kutam taq tzij ütz rutzijik
about-telemetry-raw = Man samajin ta JSON
about-telemetry-full-sql-warning =   NOTA: Ri eqal chojmirisanem SQL chupül. Tikirel yek'ut pe tz'aqät taq SQL rucholajil xa xe chi man xketaq ta pa Telemetry
about-telemetry-fetch-stack-symbols = Ke'ilitäj taq ajsamaj b'i'aj pa ri taq kutam kichin taq tzub'aj
about-telemetry-hide-stack-symbols = Kek'ut pe ri taq rutzij kuta'm man esamajin ta
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] taq tzij xke'elesäx pe
       *[prerelease] taq tzij xkenab'eyisäx pe
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] tzijon
       *[disabled] chupun
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } tz'etb'äl, rukojol = { $prettyAverage }, tunuj = { $sum }
       *[other] { $sampleCount } taq tz'etb'äl, rukojol = { $prettyAverage }, tunuj = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Re ruxaq k'amaya'l re' nuk'utub'ej taq etamab'äl pa ruwi' ri rub'eyal nisamäj, ch'akulakem, rokisaxik chuqa' taq richinaxik emolon ruma ri Telemetry. Re etamab'äl re' nitaq pa { $telemetryServerOwner } richin nuto' rutzil ri { -brand-full-name }.
about-telemetry-settings-explanation = Ri etataqonel tajin numöl { about-telemetry-data-type } chuqa' ri rusamajib'exik ja ri <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Chi kijujunal ri taq rutzijol yetaq pa “<a data-l10n-name="ping-link">taq xub'anïk</a>”. Tajin natz'ët ri { $name }, { $timestamp } xub'anïk.
about-telemetry-data-details-current = Jujun peraj etamab'äl nitaq pa molaj pa “<a data-l10n-name="ping-link">pings</a>“. Natz'ët ri tzij k'o wakami.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Tikanöx pa { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Tikanöx pa konojel ri taq peraj
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Ri xq'i' pa “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ¡Kojakuyu'! Majun achike xqïl pa { $sectionName } richin ri “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ¡Kojakuyu'! Majun achike xqïl pa jujun taq peraj richin ri “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ¡Kojakuyu'! Wakami ma e k'o ta taq tzij pa “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = tzij k'o wakami
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = ronojel
# button label to copy the histogram
about-telemetry-histogram-copy = Tiwachib'ëx
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Eqal taq b'ab' SQL pa ri nïm b'ätz'
about-telemetry-slow-sql-other = Eqal taq b'ab' SQL pa taq achib'il b'ätz'
about-telemetry-slow-sql-hits = Taq ilonem
about-telemetry-slow-sql-average = Runik'ajal q'ijul (nik'q'ij)
about-telemetry-slow-sql-statement = B'ab'
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Nimaläj rub'i' tz'aqat
about-telemetry-addon-table-details = Taq b'anikil
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Ya'öl { $addonProvider }
about-telemetry-keys-header = Ichinil
about-telemetry-names-header = B'i'aj
about-telemetry-values-header = Retal
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (tajiläx chapoj:{ $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Eqal tz'ib'anïk #{ $lateWriteCount }
about-telemetry-stack-title = Tzub'aj:
about-telemetry-memory-map-title = Rutzub'al rupam rujolom:
about-telemetry-error-fetching-symbols = Xk'ulwachitäj jun sachoj toq xe'ilitäj chik ri taq tz'ib'. Tanik'oj chi okisan pa k'amaya'l, k'a ri' tatojtob'ej chik.
about-telemetry-time-stamp-header = retal q'ijul
about-telemetry-category-header = ruwäch
about-telemetry-method-header = b'eyal
about-telemetry-object-header = wachinäq
about-telemetry-extra-header = rutz'aqat
about-telemetry-origin-section = Ruxe'el Telemetri
about-telemetry-origin-origin = ruxe'el
about-telemetry-origin-count = ajilab'äl
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetri</a> ke'awewaj kisik'ixik taq tzij chuwäch yetaq richin chi ri { $telemetryServerOwner } nitikïr yerajilaj taq wachinäq, po man etaman ta we k'o jun { -brand-product-name } ri xto'on pa ri ajilanem ri'. (<a data-l10n-name="prio-blog-link">Tetamäx ch'aqa' chik</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } tajinïk
