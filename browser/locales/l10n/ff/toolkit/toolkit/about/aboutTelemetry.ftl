# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ƴoɓo sewnde keɓe:
about-telemetry-show-archived-ping-data = Ƴoɓol keɓe resanaama
about-telemetry-show-subsession-data = Hollu keɓe lesnaatal
about-telemetry-choose-ping = Suɓol ƴoɓol:
about-telemetry-archive-ping-type = Sifaa Ƴoɓol
about-telemetry-archive-ping-header = Ƴoɓol
about-telemetry-option-group-today = Hannde
about-telemetry-option-group-yesterday = Janngo
about-telemetry-option-group-older = Hiiɗɗi
about-telemetry-previous-ping = < <
about-telemetry-next-ping = > >
about-telemetry-page-title = Keɓe Telemeetiri
about-telemetry-more-information = Aɗa yiyloo kabaruuji goɗɗi?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> ina waɗi dabi kollirooji no kuutorɗe keɓe amen ngollortee.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Data Documentation</a> ina waɗi firooji miijanɗe, duttorɗe e keɓe API tuugorɗe.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetry dashboards</a> ina addan maa waawde hollirde keɓe Mozilla heɓri Telemetry.
about-telemetry-show-in-Firefox-json-viewer = Uddit kolliroowel nder JSON
about-telemetry-home-section = Jaɓɓorgo
about-telemetry-general-data-section = Keɓe Kuuɓal
about-telemetry-environment-data-section = Keɓe Taariindi
about-telemetry-session-info-section = Humpito Naatal
about-telemetry-scalar-section = Ɓetiwe
about-telemetry-keyed-scalar-section = Ɓetiwe Koke
about-telemetry-histograms-section = Asdiiwe
about-telemetry-keyed-histogram-section =   Keyed Histograms
about-telemetry-events-section = Kewuuji
about-telemetry-simple-measurements-section = Ɓete Beeɓtinaaɗe
about-telemetry-slow-sql-section = Gowlaali SQL Leelɗi
about-telemetry-addon-details-section = Ɓeydude e cariika
about-telemetry-captured-stacks-section = Joowe gawtaaɗe
about-telemetry-late-writes-section = Binndi Sakket
about-telemetry-raw-payload-section = Dimngal nafowal kuuɓal
about-telemetry-raw = JSON Kecco
about-telemetry-full-sql-warning = NOTE: Buggitagol SQL Leelɗo koko hurminaa. Ɓoggi SQL timmuɗi ena mbaawi jaytineede les ɗoo kono ɗo naatnoytaake to Telemeetiri.
about-telemetry-fetch-stack-symbols = Awtano joowe ɗee inɗe gollirɗe
about-telemetry-hide-stack-symbols = Hollir keɓe joowre mawnde ndee
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] ñalngu bayyinal
       *[prerelease] keɓe ɓade-yamre
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] hurminaa
       *[disabled] ñifaa
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ngoo hello hollata ko humpito baɗte moƴƴugol, masiŋeeri, kuutorgol e keertine ngo Telemeetiri roɓindii. Ngoon humpito naatnoytee ko to { $telemetryServerOwner } ngam wallude ƴellitede { -brand-full-name }.
about-telemetry-settings-explanation = Telemetiri ndii woni ko e roɓindaade { about-telemetry-data-type } e gawtagol ngol ko <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Heen kabaaru kala neldetee ko nder “<a data-l10n-name="ping-link">pinnge</a>”. Aɗa ƴeewa ping { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Yiylo e { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Yiylo e doge fof
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Njeñtudi “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Yaafo ! Alaa njeñtudi “{ $currentSearchText }” woodi nder { $sectionName }
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Yaafo ! Alaa njeñtudi “{ $searchTerms }” woodi e hay taƴre wootere
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Yaafo ! Alaa keɓal keɓingal jooni woodi nder “{ $sectionName }”
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = fof
# button label to copy the histogram
about-telemetry-histogram-copy = Natto
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Gowlaali SQL Leelɗi e Piɓol Garwanol
about-telemetry-slow-sql-other = Gowlaali SQL Leelɗi e Piɓol Ballitol
about-telemetry-slow-sql-hits = Yilliiɓe
about-telemetry-slow-sql-average = Avg. Time (ms)
about-telemetry-slow-sql-statement = Wowlaandu
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Ɓeydu e ID
about-telemetry-addon-table-details = Cariiɗe
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Dokkiroowo { $addonProvider }
about-telemetry-keys-header = Keertinal
about-telemetry-names-header = Innde
about-telemetry-values-header = Njaru
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (limoore nokite: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Winndaa Sakket #{ $lateWriteCount }
about-telemetry-stack-title = Taakre:
about-telemetry-memory-map-title = Kartal Teskorde:
about-telemetry-error-fetching-symbols = Juumre waɗii tuma nde maalle mballetee. Ƴewto so aɗa seŋii e Enternet kisa puɗɗito-ɗaa.
about-telemetry-time-stamp-header = ñalɗingol sahaa
about-telemetry-category-header = kategori
about-telemetry-method-header = feere
about-telemetry-object-header = kuujel
about-telemetry-extra-header = cinndal
