# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = पिङ डाटा स्रोत:
about-telemetry-show-archived-ping-data = अभिलेख गरिएको पिङ डाटा
about-telemetry-show-subsession-data = उपसत्र डाटा देखाउनुहोस्
about-telemetry-choose-ping = पिङ छान्नुहोस्:
about-telemetry-archive-ping-type = पिङ प्रकार
about-telemetry-archive-ping-header = पिङ
about-telemetry-option-group-today = आज
about-telemetry-option-group-yesterday = हिजो
about-telemetry-option-group-older = पुरानो
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = टेलीमेटरी डाटा
about-telemetry-more-information = थप जानकारी खोज्दै हुनुहुन्छ ?
about-telemetry-firefox-data-doc = हाम्रो डाटा उपकरणहरू सँग कसरि काम गर्ने बारेको गाइडहरु <a data-l10n-name="data-doc-link">Firefox डाटा प्रलेखन </a> मा समावेश छ ।
about-telemetry-telemetry-client-doc = अवधारणाहरुको लागि परिभाषाहरू, API प्रलेखन र डाटा सन्दर्भहरू <a data-l10n-name="client-doc-link">Firefox टेलीमेट्री क्लाइन्ट प्रलेखन</a> ले समावेश गरेको छ ।
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">टेलीमेट्री ड्याशबोर्ड</a> ले तपाईँलाई टेलीमेट्री मार्फत Mozilla ले प्राप्त गर्ने डाटाहरू हेर्ने अनुमति दिन्छ ।
about-telemetry-show-in-Firefox-json-viewer = JSON दर्शकमा खोल्नुहोस्
about-telemetry-home-section = गृहपृष्ठ
about-telemetry-general-data-section = सामान्य डाटा
about-telemetry-environment-data-section = परिवेश डाटा
about-telemetry-session-info-section = सत्र जानकारी
about-telemetry-scalar-section = अदिष्टहरू
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = आयतचित्रहरू
about-telemetry-keyed-histogram-section = प्रमुख हिस्टोग्रामहरु
about-telemetry-events-section = घटनाहरू
about-telemetry-simple-measurements-section = सामान्य नापहरू
about-telemetry-slow-sql-section = सुस्त SQL विवरणहरू
about-telemetry-addon-details-section = Add-on विवरणहरू
about-telemetry-captured-stacks-section = कैद गरिएका स्ट्याकहरू
about-telemetry-late-writes-section = ढिलो लेखन
about-telemetry-raw-payload-section = कच्चा पेलोड
about-telemetry-raw = कच्चा JSON
about-telemetry-full-sql-warning = NOTE: ढिलो SQL त्रुटि सच्याउन सक्षम पारिएको छ। पूर्ण SQL स्ट्रिङहरू तल प्रदर्शित हुन सक्छ तर तिनीहरू टेलीमेटरीमा पेश गरिने छैन।
about-telemetry-fetch-stack-symbols = स्ट्याकहरूको लागि प्रकार्य नाम ल्याउनुहोस्
about-telemetry-hide-stack-symbols = कच्चा स्ट्याक डाटा देखाउनुहोस्
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] जारी डेटा
       *[prerelease] पूर्व-जारी डेटा
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] सक्षम गरियो
       *[disabled] अक्षम गरियो
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = यो पेज टेलीमेटरी सङ्कलन प्रदर्शन, हार्डवेयर, उपयोग र अनुकुल गर्न बारेमा जानकारी देखाउँछ। यो जानकारी { -brand-full-name } सुधार्न { $telemetryServerOwner } पेश छ।
about-telemetry-settings-explanation = टेलिमेट्री { about-telemetry-data-type } सङ्कलन गरिरहेको छ र अपलोड <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> छ।
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = जानकारीको प्रत्येक टुक्रालाई बन्डल गरेर “<a data-l10n-name="ping-link">पिङहरू</a>” मा पठाइएको छ । तपाईँ { $name }, { $timestamp } पिङ हेर्दै हुनुहुन्छ ।
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } मा खोज्नुहोस्
about-telemetry-filter-all-placeholder =
    .placeholder = सबै खण्डहरूमा फेला पार्नुहोस्
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” को लागि नतिजाहरू
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = माफ गर्नुहोस्! त्यहाँ “{ $currentSearchText }” को लागि { $sectionName } मा कुनै नतिजा छैन
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = माफ गर्नुहोस्! त्यहाँ “{ $searchTerms }” को लागि कुनैपनि खण्डहरूमा नतिजा छैन
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = माफ गर्नुहोस्! त्यहाँ “{ $sectionName }” मा हाल कुनै डाटा उपलब्ध छैन
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = सबै
# button label to copy the histogram
about-telemetry-histogram-copy = प्रतिलिपि गर्नुहोस्
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = मुख्य थ्रेडमा सुस्त SQL विवरणहरू
about-telemetry-slow-sql-other = सहयोगी थ्रेडमा सुस्त SQL विवरणहरू
about-telemetry-slow-sql-hits = हिट
about-telemetry-slow-sql-average = मध्यम समय (ms)
about-telemetry-slow-sql-statement = कथन
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Add-on आइडी
about-telemetry-addon-table-details = विवरणहरू
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } प्रदायक
about-telemetry-keys-header = गुण
about-telemetry-names-header = नाम
about-telemetry-values-header = मान
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (कैद गणना: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = ढिलो लेखन #{ $lateWriteCount }
about-telemetry-stack-title = थाक:
about-telemetry-memory-map-title = स्मृति मानचित्र:
about-telemetry-error-fetching-symbols = प्रतीक तान्न खोज्दा एउटा त्रुटि आउन पुग्यो। तपाईँ इन्टरनेटमा जडित हुनुभएको छ भन्ने कुरा जाँच गरी पुनः प्रयास गर्नुहोस्।
about-telemetry-time-stamp-header = समयाङ्कन
about-telemetry-category-header = कोटि
about-telemetry-method-header = विधि
about-telemetry-object-header = वस्तु
about-telemetry-extra-header = अतिरिक्त
