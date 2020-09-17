# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = पिंग डाटा स्रोत:
about-telemetry-show-archived-ping-data = संग्रहित पिंग डाटा
about-telemetry-show-subsession-data = सबसेशन डाटा दाखवा
about-telemetry-choose-ping = पिंग निवडा:
about-telemetry-archive-ping-type = पिंग प्रकार
about-telemetry-archive-ping-header = पिंग
about-telemetry-option-group-today = आज
about-telemetry-option-group-yesterday = काल
about-telemetry-option-group-older = जुने
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetry माहिती
about-telemetry-more-information = अधिक माहिती शोधत आहात?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox डेटा डॉक्युमेंटेशन</a> मध्ये डेटा टूल्ससह कार्य कसे करावे त्याविषयी मार्गदर्शिका आहेत.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetry क्लायंट दस्तऐवजीकरण</a> मध्ये संकल्पना, API दस्तऐवजीकरण आणि डेटा संदर्भांची परिभाषा समाविष्ट आहे.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetry डॅशबोर्ड</a> आपल्याला Mozilla ला Telemetry द्वारे प्राप्त डेटाची कल्पना करण्यास अनुमती देतात.
about-telemetry-show-in-Firefox-json-viewer = JSON दर्शकामध्ये उघडा
about-telemetry-home-section = मुख्य पटल
about-telemetry-general-data-section = सामान्य माहिती
about-telemetry-environment-data-section = वातावरण डाटा
about-telemetry-session-info-section = सत्र माहिती
about-telemetry-scalar-section = स्केलर
about-telemetry-keyed-scalar-section = दिलेले स्केलर्स
about-telemetry-histograms-section = हिस्टोग्राम्स
about-telemetry-keyed-histogram-section = भडक रंग असलेला स्तंभालेख
about-telemetry-events-section = घटना
about-telemetry-simple-measurements-section = सोपे मापन
about-telemetry-slow-sql-section = हळू SQL विधाने
about-telemetry-addon-details-section =   ॲड-ऑन तपशील
about-telemetry-captured-stacks-section = पकडलेले स्टॅक
about-telemetry-late-writes-section = विलंबीत लिखाणे
about-telemetry-raw-payload-section = रॉ पेलोड
about-telemetry-raw = मूळ JSON
about-telemetry-full-sql-warning = टीप: हळू SQL डीबगिंग सुरू आहे. पूर्ण SQL स्ट्रींग्स दाखवणे शक्य आहे परंतु ते Telemetryकडे सुपूर्द होणार नाही.
about-telemetry-fetch-stack-symbols = स्टॅक्सकरिता फंक्शन नावे घ्या
about-telemetry-hide-stack-symbols = स्टॅक मधील कच्ची माहिती दाखवा
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] प्रकाशन मजकूर
       *[prerelease] प्रकाशनपूर्व मजकूर
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] सक्षम केलेले
       *[disabled] असमर्थ केलेले
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = हे पृष्ठ Telemetry द्वारा एकत्रीत केलेली कामगिरी, हार्डवेअर, वापर, आणि स्वपसंतीकरणाबद्दल माहिती पुरवते. { $telemetryServerOwner } कडे ही माहिती सुपूर्द केली जाते, { -brand-full-name } ला सुधारण्यासाठी.
about-telemetry-settings-explanation = Telemetry { about-telemetry-data-type } गोळा करत आहे आणि अपलोड <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> आहे.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = माहितीचा प्रत्येक भाग “<a data-l10n-name="ping-link">पिंग</a>” मध्ये गुंडाळुन पाठवला जातो. आपण { $name }, { $timestamp } कडे बघत आहात.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } मध्ये शोधा
about-telemetry-filter-all-placeholder =
    .placeholder = सर्व विभागांमध्ये शोधा
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” करिता परिणाम
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = क्षमस्व! “{ $currentSearchText }” साठी { $sectionName } मध्ये कोणतेही परिणाम नाहीत
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = माफ करा! “{ $searchTerms }” साठी कोणत्याही विभागात परिणाम नाहीत
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = क्षमस्व! सध्या “{ $sectionName }” मध्ये कोणताही डेटा उपलब्ध नाही
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = सर्व
# button label to copy the histogram
about-telemetry-histogram-copy = प्रत बनवा
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = मेन थ्रेड्सवरील हळू SQL विधाने
about-telemetry-slow-sql-other = सहाय्यक थ्रेड्सवरील हळू SQL विधाने
about-telemetry-slow-sql-hits = हिट्स
about-telemetry-slow-sql-average = सरा. वेळ (मिली सेकंद)
about-telemetry-slow-sql-statement = विधान
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ॲड-ऑन ID
about-telemetry-addon-table-details = तपशील
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } प्रोव्हाइडर
about-telemetry-keys-header = गुणधर्म
about-telemetry-names-header = नाव
about-telemetry-values-header = मूल्य
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (पकड मोजणी: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = विलंबीत लिखाण #{ $lateWriteCount }
about-telemetry-stack-title = स्टॅक:
about-telemetry-memory-map-title = मेमरि नकाशा:
about-telemetry-error-fetching-symbols = चिन्हे घेतांना त्रुटी आढळली. आपण इंटरनेटसह जोडलेले आहात याची तपासणी करा आणि पुन्हा प्रयत्न करा.
about-telemetry-time-stamp-header = कालमुद्रा
about-telemetry-category-header = श्रेणी
about-telemetry-method-header = पद्धत
about-telemetry-object-header = घटक
about-telemetry-extra-header = अधिक
about-telemetry-origin-origin = स्त्रोत
about-telemetry-origin-count = गणना
