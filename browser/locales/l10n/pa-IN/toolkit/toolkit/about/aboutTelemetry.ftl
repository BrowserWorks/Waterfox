# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = ਪਿੰਗ ਡਾਟਾ ਸਰੋਤ:
about-telemetry-show-current-data = ਮੌਜੂਦਾ ਡਾਟਾ
about-telemetry-show-archived-ping-data = ਅਕਾਇਵ ਕੀਤਾ ਪਿੰਗ ਡਾਟਾ
about-telemetry-show-subsession-data = ਸਬ-ਸ਼ੈਸ਼ਨ ਡਾਟਾ ਦੇਖੋ
about-telemetry-choose-ping = ਪਿੰਗ ਨੂੰ ਚੁਣੋ:
about-telemetry-archive-ping-type = ਪਿੰਗ ਕਿਸਮ
about-telemetry-archive-ping-header = ਪਿੰਗ
about-telemetry-option-group-today = ਅੱਜ
about-telemetry-option-group-yesterday = ਕੱਲ੍ਹ
about-telemetry-option-group-older = ਹੋਰ ਪੁਰਾਣੇ
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = ਟੈਲੀਮੈਂਟਰੀ ਡਾਟਾ
about-telemetry-current-store = ਮੌਜੂਦਾ ਸਟੋਰ:
about-telemetry-more-information = ਹੋਰ ਜਾਣਕਾਰੀ ਲਈ ਖੋਜਣਾ ਹੈ?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">ਫਾਇਰਫਾਕਸ ਡਾਟਾ ਦਸਤਾਵੇਜ਼ (ਅੰਗਰੇਜ਼ੀ)</a> ਵਿੱਚ ਗਾਈਡਾਂ ਹਨ, ਜੋ ਕਿ ਸਾਡੇ ਡਾਟਾ ਟੂਲ ਨਾਲ ਕੰਮ ਕਰਨ ਬਾਰੇ ਜਾਣਕਾਰੀ ਦਿੰਦੀਆਂ ਹਨ।
about-telemetry-show-in-Firefox-json-viewer = JSON ਦਰਸ਼ਕ 'ਚ ਖੋਲ੍ਹੋ
about-telemetry-home-section = ਘਰ
about-telemetry-general-data-section = ਆਮ ਡਾਟਾ
about-telemetry-environment-data-section = ਇੰਵਾਇਰਨਮੈਂਟ ਡਾਟਾ
about-telemetry-session-info-section = ਸ਼ੈਸ਼ਨ ਜਾਣਕਾਰੀ
about-telemetry-scalar-section = ਸਕੇਲਰ
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = ਹਿਸਟੋਗਰਾਮ
about-telemetry-keyed-histogram-section = ਕੀਡ ਹਿਸਟੋਗਰਾਮ
about-telemetry-events-section = Events
about-telemetry-simple-measurements-section = ਸਧਾਰਨ ਮਾਪ
about-telemetry-slow-sql-section = ਹੌਲੀ SQL ਸਟੇਟਮੈਂਟਾਂ
about-telemetry-addon-details-section = ਐਡ-ਆਨ ਵੇਰਵੇ
about-telemetry-captured-stacks-section = Captured Stacks
about-telemetry-late-writes-section = ਦੇਰੀ ਨਾਲ ਰਾਇਟਰ
about-telemetry-raw-payload-section = ਕੱਚਾ ਪੇਅਲੋਡ
about-telemetry-raw = ਅਣਘੜ JSON
about-telemetry-full-sql-warning = ਸੂਚਨਾ: ਹੌਲੀ SQL ਡੀਬੱਗ ਕਰਨਾ ਸਮਰੱਥ ਹੈ। ਪੂਰੀਆਂ SQL ਸਤਰਾਂ ਨੂੰ ਹੇਠਾਂ ਦੇਖਾਇਆ ਜਾ ਸਕਦਾ ਹੈ, ਪਰ ਉਹਨਾਂ ਨੂੰ ਟੈਲੀਮੈਂਟਰੀ ਨੂੰ ਭੇਜਿਆ ਨਹੀਂ ਜਾਵੇਗਾ।
about-telemetry-fetch-stack-symbols = Fetch function names for stacks
about-telemetry-hide-stack-symbols = Show raw stack data
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] ਰੀਲਿਜ਼ ਡਾਟਾ
       *[prerelease] ਪ੍ਰੀ-ਰੀਲਿਜ਼ ਡਾਟਾ
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] ਸਮਰੱਥ ਹੈ
       *[disabled] ਅਸਮਰੱਥ ਹੈ
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = ਇਹ ਸਫ਼ਾ ਟੈਲੀਮੈਂਟਰੀ ਵਲੋਂ ਕਾਰਗੁਜ਼ਾਰੀ, ਹਾਰਡਵੇਅਰ, ਵਰਤੋਂ ਅਤੇ ਪਸੰਦ ਬਾਰੇ ਇੱਕਠੀ ਕੀਤੀ ਜਾਣਕਾਰੀ ਵੇਖਾਉਂਦਾ ਹੈ। ਇਹ ਜਾਣਕਾਰੀ ਨੂੰ { $telemetryServerOwner } ਨੂੰ ਭੇਜਿਆ ਜਾਂਦਾ ਹੈ ਤਾਂ ਕਿ { -brand-full-name } ਨੂੰ ਸੁਧਾਰਿਆ ਜਾ ਸਕੇ।
about-telemetry-settings-explanation = ਟੈਲੀਮੈਂਟਰੀ { about-telemetry-data-type } ਇਕੱਤਰ ਕਰ ਰਿਹਾ ਹੈ ਅਤੇ <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> ਅੱਪਲੋਡ ਕਰਦਾ ਹੈ।
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } 'ਚ ਲੱਭੋ
about-telemetry-filter-all-placeholder =
    .placeholder = ਸਾਰੇ ਭਾਗਾਂ 'ਚ ਲੱਭੋ
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” ਲਈ ਨਤੀਜੇ
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ਅਫ਼ਸੋਸ! “{ $currentSearchText }” ਲਈ { $sectionName } ਵਿੱਚ ਕੋਈ ਨਤੀਜੇ ਨਹੀਂ ਹਨ
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ਅਫ਼ਸੋਸ! “{ $searchTerms }” ਲਈ ਕਿਸੇ ਭਾਗ ਵਿੱਚ ਕੋਈ ਨਤੀਜੇ ਨਹੀਂ ਹਨ
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ਅਫ਼ਸੋਸ! ਇਸ ਵੇਲੇ “{ $sectionName }” ਵਿੱਚ ਕੋਈ ਵੀ ਡਾਟਾ ਉਪਲਬਧ ਨਹੀਂ ਹੈ
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = ਸਾਰੇ
# button label to copy the histogram
about-telemetry-histogram-copy = ਕਾਪੀ ਕਰੋ
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = ਮੁੱਖ ਥਰਿਡ ਵਿੱਚ ਹੌਲੀ SQL ਸਟੇਟਮੈਂਟ
about-telemetry-slow-sql-other = ਹੈਲਪਰ ਥਰਿਡ ਵਿੱਚ ਹੌਲੀ SQL ਸਟੇਟਮੈਂਟ
about-telemetry-slow-sql-hits = ਹਿਟ
about-telemetry-slow-sql-average = ਔਸਤ ਸਮਾਂ (ms)
about-telemetry-slow-sql-statement = ਸਟੇਟਮੈਂਟ
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ਐਡ-ਆਨ ID
about-telemetry-addon-table-details = ਵੇਰਵਾ
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } ਪਰੋਵਾਈਡਰ
about-telemetry-keys-header = ਵਿਸ਼ੇਸ਼ਤਾ
about-telemetry-names-header = ਨਾਂ
about-telemetry-values-header = ਮੁੱਲ
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (ਪ੍ਰਾਪਤੀ ਦੀ ਗਿਣਤੀ: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = ਲੇਟ ਲਿਖਣਾ #{ $lateWriteCount }
about-telemetry-stack-title = ਸਟੈਕ:
about-telemetry-memory-map-title = ਮੈਮੋਰੀ ਨਕਸ਼ਾ:
about-telemetry-error-fetching-symbols = ਸਿੰਬਲ ਲੈਣ ਦੌਰਾਨ ਗਲਤੀ ਆਈ ਹੈ। ਜਾਂਚ ਕਰੋ ਕਿ ਤੁਸੀਂ ਇੰਟਰਨੈੱਟ ਨਾਲ ਕੁਨੈਕਟ ਹੋ ਅਤੇ ਫੇਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ।
about-telemetry-time-stamp-header = ਸਮਾਂ-ਮੋਹਰ
about-telemetry-category-header = ਵਰਗ
about-telemetry-method-header = ਢੰਗ
about-telemetry-object-header = ਆਬਜੈਕਟ
about-telemetry-extra-header = ਵਾਧੂ
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } ਪਰੋਸੈਸ
