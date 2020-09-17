# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping tùs an dàta:
about-telemetry-show-archived-ping-data = Dàta nam ping tasglannaichte
about-telemetry-show-subsession-data = Seall dàta nam fo-sheiseanan
about-telemetry-choose-ping = Tagh ping:
about-telemetry-archive-ping-type = Seòrsa a’ phing
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = An-diugh
about-telemetry-option-group-yesterday = An-dè
about-telemetry-option-group-older = Nas sine
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Dàta telemeatraidh
about-telemetry-more-information = Barrachd fiosrachaidh a dhìth ort?
about-telemetry-firefox-data-doc = Tha treòirean ann am <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> a dh’innseas dhut mar a dh’obraicheas tu leis na h-innealan dàta againn.
about-telemetry-telemetry-client-doc = Gheibh thu deifiniseanan choincheapan, docamaideadh API agus reifreansan dàta san docamaidean <a data-l10n-name="client-doc-link">Firefox Telemetry Client</a>.
about-telemetry-telemetry-dashboard = Bheir <a data-l10n-name="dashboard-link">deas-bhùird an telemeatraidh</a> comas dhut dealbh a dhèanamh dhen dàta a gheibh Mozilla slighe gleus an telemeatraidh.
about-telemetry-telemetry-probe-dictionary = Tha am <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> a’ toirt dhut mion-fhiosrachadh is tuairisgeulan mun fhiosrachadh a chruinnich an telemeatraidh.
about-telemetry-show-in-Firefox-json-viewer = Fosgail san t-sealladair JSON
about-telemetry-home-section = Dhachaidh
about-telemetry-general-data-section = Dàta coitcheann
about-telemetry-environment-data-section = Dàta na h-àrainneachd
about-telemetry-session-info-section = Fiosrachadh mun t‑seisean
about-telemetry-scalar-section = Scalars
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = Histograms
about-telemetry-keyed-histogram-section =   Keyed Histograms
about-telemetry-events-section = Tachartasan
about-telemetry-simple-measurements-section = Tomhaisean simplidh
about-telemetry-slow-sql-section = SQL Statements slaodach
about-telemetry-addon-details-section = Mion-fhiosrachadh an tuilleadain
about-telemetry-captured-stacks-section = Stacan glacte
about-telemetry-late-writes-section = Sgrìobhaidhean fadalach
about-telemetry-raw-payload-section = Raw Payload
about-telemetry-raw = JSON amh
about-telemetry-full-sql-warning = AN AIRE: Tha Slow SQL Debugging an comas. Ma dh'fhaoidte gum faic thu sreangan SQL slàna gu h-ìosal ach cha dèid a chur gu gleus an telemeatraidh.
about-telemetry-fetch-stack-symbols = Faigh ainmean nam foincseanan aig na stacaichean
about-telemetry-hide-stack-symbols = Seall dàta amh nan stacaichean
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] dàta sgaoilidh
       *[prerelease] dàta ro-sgaoilidh
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] an comas
       *[disabled] à comas
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } sample, average = { $prettyAverage }, sum = { $sum }
        [two] { $sampleCount } sample, average = { $prettyAverage }, sum = { $sum }
        [few] { $sampleCount } sample, average = { $prettyAverage }, sum = { $sum }
       *[other] { $sampleCount } sample, average = { $prettyAverage }, sum = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Tha an duilleag seo a' sealltainn dhut fiosrachadh air dèanadas, bathar-cruaidh, cleachdadh is gnàthachadh a tha gleus an telemeatraidh a' cruinneachadh. Thèid an dàta seo a chur gu { $telemetryServerOwner } a chum leasachadh { -brand-full-name }.
about-telemetry-settings-explanation = Tha gleus an telemeatraidh a’ cruinneachadh { about-telemetry-data-type } agus tha a luchdadh suas <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Tha gach pìos de dh’fhiosrachadh gu chur paisgte ann an “<a data-l10n-name="ping-link">pings</a>”. Tha thu a’ coimhead air ping { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Lorg ann an { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Lorg anns gach earrann
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Toraidhean airson “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Tha sinn duilich ach cha eil toradh sam bith ann an { $sectionName } airson “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Tha sinn duilich ach chan eil toradh sam bith ann an earrann sam bith airson “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Tha sinn duilich ach chan eil dàta sam bith ri làimh ann an “{ $sectionName }” aig an àm seo
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = na h-uile
# button label to copy the histogram
about-telemetry-histogram-copy = Dèan lethbhreac
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = SQL Statements slaodadh sa phrìomh shnàithlean
about-telemetry-slow-sql-other = SQL Statements slaodadh ann an snàithleanan taice
about-telemetry-slow-sql-hits = Buillean
about-telemetry-slow-sql-average = Cuibheas an ama (ms)
about-telemetry-slow-sql-statement = Aithris
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID an tuilleadain
about-telemetry-addon-table-details = Mion-fhiosrachadh
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Solaraiche { $addonProvider }
about-telemetry-keys-header = Roghainn
about-telemetry-names-header = Ainm
about-telemetry-values-header = Luach
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (cunntas glacaidh: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Sgrìobhadh fadalach #{ $lateWriteCount }
about-telemetry-stack-title = Staca:
about-telemetry-memory-map-title = Mapa cuimhne:
about-telemetry-error-fetching-symbols = Thachair mearachd nuair a dh'fheuch sinn ris na samhlaidhean fhaighinn dhut. Dèan cinnteach gu bheil ceangal agad ris an eadar-lìon is feuch ris a-rithist.
about-telemetry-time-stamp-header = stampa-ama
about-telemetry-category-header = roinn
about-telemetry-method-header = dòigh
about-telemetry-object-header = oibseact
about-telemetry-extra-header = extra
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = origin
about-telemetry-origin-count = count
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> encodes data before it is sent so that { $telemetryServerOwner } can count things, but not know whether or not any given { -brand-product-name } contributed to that count. (<a data-l10n-name="prio-blog-link">learn more</a>)
