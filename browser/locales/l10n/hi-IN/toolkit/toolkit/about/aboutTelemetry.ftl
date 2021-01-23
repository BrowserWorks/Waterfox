# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = डेटा स्रोत को पिंग करे:
about-telemetry-show-current-data = मौजूदा डेटा
about-telemetry-show-archived-ping-data = पिंग डेटा का अभिलेख किया गया
about-telemetry-show-subsession-data = उपसत्र डेटा दिखाएँ
about-telemetry-choose-ping = पिंग चुनें:
about-telemetry-archive-ping-type = पिंग प्रकार
about-telemetry-archive-ping-header = पिंग
about-telemetry-option-group-today = आज
about-telemetry-option-group-yesterday = कल (बीता)
about-telemetry-option-group-older = पुराना
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = दूरमापी आंकड़ा
about-telemetry-more-information = और अधिक जानकारी खोज रहे हैं?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox डेटा दस्तावेज़ीकरण</a> में हमारे डेटा उपकरणों के साथ काम करने के तरीक़े हैं.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox दूरमापी ग्राहक प्रलेखन</a> में संकल्पनाओं, API प्रलेखन और आँकड़ों के संदर्भ के लिए परिभाषाएँ शामिल हैं.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">दूरमापी नियंत्रण-पट्ट</a> आपको दूरमापी के माध्यम से Mozilla को प्राप्त होने वाले आँकड़ों को देखने का अवसर देता है.
about-telemetry-show-in-Firefox-json-viewer = JSON दर्शक में खोलें
about-telemetry-home-section = मुख पृष्ठ
about-telemetry-general-data-section =         सामान्य आंकड़ा
about-telemetry-environment-data-section = वातावरण डेटा
about-telemetry-session-info-section = तंत्र जानकारी
about-telemetry-scalar-section = अदिश
about-telemetry-keyed-scalar-section = की स्केलर
about-telemetry-histograms-section = आयत छवि
about-telemetry-keyed-histogram-section =     keyed histograms
about-telemetry-events-section = घटनाएँ
about-telemetry-simple-measurements-section = साधारण  माप
about-telemetry-slow-sql-section = धीरे sql निवेदन
about-telemetry-addon-details-section = सहयुक्ति विवरण
about-telemetry-captured-stacks-section = कैप्चर किए गए स्टैक
about-telemetry-late-writes-section = कुछ देर से लिखें
about-telemetry-raw-payload-section = कच्चा पेलोड
about-telemetry-raw = कच्चा JSON
about-telemetry-full-sql-warning = टिप्पणी: धीरे sql दोषसुधार सक्षम है. पूर्ण रूप से sql  वाक्यांश नीचे दिखाई  दे सकता है लेकिन वे दूरमापी को जमा किये जा सकते है
about-telemetry-fetch-stack-symbols = स्टैक के लिए फ़ंक्शनों के नाम प्राप्त करें
about-telemetry-hide-stack-symbols = कच्चा स्टैक डेटा दिखाएं
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] निर्गमित डेटा
       *[prerelease] पूर्व-निर्गमित डेटा
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] सक्षम किया गया
       *[disabled] अक्षम किया गया
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = यह पृष्ठ प्रदर्शन, हार्डवेयर, उपयोग और मनपसंदीकरण के बारे मे दिखाता है  जो दूरमापी द्वारा एकत्रित है . यह  जानकारी { $telemetryServerOwner } में जमा है { -brand-full-name } में सुधार करने के लिए
about-telemetry-settings-explanation = दूरमापी { about-telemetry-data-type } एकत्रण है और अपलोड <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> है.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = सूचना का प्रत्येक अंश “<a data-l10n-name="ping-link">पिंग</a>” में पुलिंदों में भेजा जाता है. आप { $name }, { $timestamp } स्पंदन को देख रहे हैं.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } में पाएँ
about-telemetry-filter-all-placeholder =
    .placeholder = सभी अनुभागों में खोजें
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” के लिए परिणाम
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = माफ़ कीजिए! “{ $currentSearchText }” के लिए { $sectionName } में कोई परिणाम नहीं है
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = माफ़ कीजिए! “{ $searchTerms }” के लिए किसी अनुभाग में कोई परिणाम नहीं है
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = माफ़ कीजिए! “{ $sectionName }” के लिए फ़िलहाल कोई डेटा उपलब्ध नहीं है
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = सभी
# button label to copy the histogram
about-telemetry-histogram-copy = नक़ल करें
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = धीरे sql निवेदन मुख्य क्रम पर
about-telemetry-slow-sql-other = धीरे sql निवेदन सहायक क्रम पर
about-telemetry-slow-sql-hits = हिट्स
about-telemetry-slow-sql-average = औसत समय (मिलीसेकंड)
about-telemetry-slow-sql-statement = स्थिति
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Add-on ID
about-telemetry-addon-table-details = विवरण
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } प्रदाता
about-telemetry-keys-header = गुण
about-telemetry-names-header = नाम
about-telemetry-values-header = मान
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (कैप्चर संख्या: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = विलंब लेखन #{ $lateWriteCount }
about-telemetry-stack-title = ढेरी
about-telemetry-memory-map-title = स्मृति मानचित्र
about-telemetry-error-fetching-symbols = एक त्रुटि हुई प्रतीक पाने वक्त . जाँचें जुडे हुए है इन्टरनेट से और फिर से कोशिश करे.
about-telemetry-time-stamp-header = समय-चिह्न
about-telemetry-category-header = श्रेणी
about-telemetry-method-header = विधि
about-telemetry-object-header = वस्तु
about-telemetry-extra-header = अतिरिक्त
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } प्रक्रिया
