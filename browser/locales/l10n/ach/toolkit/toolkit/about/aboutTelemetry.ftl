# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Nong kama data oa iye:
about-telemetry-show-archived-ping-data = Data me nong ma okato
about-telemetry-show-subsession-data = Nyut data me but kare
about-telemetry-choose-ping = Yer nong:
about-telemetry-archive-ping-header = Nong
about-telemetry-option-group-today = Tin
about-telemetry-option-group-yesterday = Lawo
about-telemetry-option-group-older = Macon
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Pimo tic ki kama bor
about-telemetry-more-information = Itye ka yenyo ngec mapol?
about-telemetry-home-section = Acakki
about-telemetry-general-data-section = Tic lumuku
about-telemetry-environment-data-section = Data me kama orumu wa
about-telemetry-session-info-section = Ngec me Kare
about-telemetry-histograms-section = Cura me tic
about-telemetry-keyed-histogram-section = Wel ma kimungo
about-telemetry-events-section = Gin matime
about-telemetry-simple-measurements-section = Pim mayot
about-telemetry-slow-sql-section = Lok me SQL ma woto mot
about-telemetry-addon-details-section = Matut ikom med-ikome
about-telemetry-late-writes-section = Nyoc me lacen
about-telemetry-full-sql-warning = Ngec: Nongo bal i SQL mawoto mot kiye. Tol SQL ma opong mogo ki romo yaro piny ento pe ki bicwalo bot pimo tic.
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] kicako
       *[disabled] kijuko
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Pot buk man nyutu ngec ikom kit matic woto kwede, nyonyo, tic kwede kadong yik ma Pimo tic ocoko. Ngec man kicwalo bot { $telemetryServerOwner } me konyo yubo { -brand-full-name }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Nong i { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Nong i bute weng
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Adwogi pi “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Timwa kica! Adwogi mo pe i { $sectionName } pi “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Timwa kica! Adwogi mo pe i bute mo keken pi “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Timwa kica! Kombedi data mo pe tye i “{ $sectionName }”
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = weng
# button label to copy the histogram
about-telemetry-histogram-copy = Lok
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Lok me SQL ma woto mot i Tol mapire tek
about-telemetry-slow-sql-other = Lok me SQL ma woto mot i Tol me kony
about-telemetry-slow-sql-hits = Kube ma otime
about-telemetry-slow-sql-average = Ayere. Cawa (ms)
about-telemetry-slow-sql-statement = Lok
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID me med-ikome
about-telemetry-addon-table-details = Matut
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } Lami ne
about-telemetry-keys-header = Jami me tic
about-telemetry-names-header = Nying
about-telemetry-values-header = Wel
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Coc ma lacen #{ $lateWriteCount }
about-telemetry-stack-title = Can me matangula:
about-telemetry-memory-map-title = Cal me kakano:
about-telemetry-error-fetching-symbols = Bal otime ma kitye ka omo lanen. Ngi me neno ni ikube bot intanet kadong tem doki.
about-telemetry-time-stamp-header = cawa me gin matime
about-telemetry-extra-header = mukene
