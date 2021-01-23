# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = పింగ్ డేటా మూలం :
about-telemetry-show-archived-ping-data = భద్రపరచిన పింగ్ డేటా
about-telemetry-show-subsession-data = ఉప సెషన్ డేటా చూపించు
about-telemetry-choose-ping = పింగ్ ఎంచుకోండి:
about-telemetry-archive-ping-type = పింగ్ రకం
about-telemetry-archive-ping-header = పింగ్
about-telemetry-option-group-today = నేడు
about-telemetry-option-group-yesterday = నిన్న
about-telemetry-option-group-older = పాతవి
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = టెలీమెట్రీ సమాచారం
about-telemetry-more-information = మరింత సమాచారం కోసం చూస్తున్నారా?
about-telemetry-show-in-Firefox-json-viewer = JSON వ్యూయర్లో తెరవండి
about-telemetry-home-section = ముంగిలి
about-telemetry-general-data-section = సాధారణ దత్తాంశం
about-telemetry-environment-data-section = పర్యావరణ దత్తాంశం
about-telemetry-session-info-section = సెషేన్ యొక్క సమాచారం
about-telemetry-scalar-section = స్కేలార్ లు
about-telemetry-keyed-scalar-section = Keyed Scalars
about-telemetry-histograms-section = హిస్టోగ్రామ్స్
about-telemetry-keyed-histogram-section = కీ ఇవ్వబడిన హిస్టోగ్రాములు
about-telemetry-events-section = చర్యలు
about-telemetry-simple-measurements-section = మాదిరి కొలతలు
about-telemetry-slow-sql-section = నిదానమైన SQL వాక్యాలు
about-telemetry-addon-details-section = పొడిగింత వివరాలు
about-telemetry-captured-stacks-section = పట్టుబడిన స్టాక్స్
about-telemetry-late-writes-section = లేట్ వ్రైట్స్
about-telemetry-raw-payload-section = ముడి పేలోడు
about-telemetry-raw = ముడి JSON
about-telemetry-full-sql-warning = గమనిక: నిదానమైన SQL డీబగ్గింగ్ చేతనమైంది. పూర్తి SQL స్ట్రింగ్స్ కిందన ప్రదర్శించవచ్చు అయితే అవి టెలీమెట్రీకు సమర్పించబడవు.
about-telemetry-fetch-stack-symbols = స్టాక్స్ కొరకు ఫంక్షన్ పేర్లను వెతికితెమ్ము
about-telemetry-hide-stack-symbols = ముడి స్టాక్ డేటాను చూపించు
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] చేతనమైనది
       *[disabled] అచేతనమైనది
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = ఈ పేజీ టెలీమెట్రీచే సేకరించబడిన పనితనం, హార్డువేర్, వినియోగం మరియు మలచుకొనే విధానం గురించిన సమాచారం చూపును. ఈ సమాచారం { $telemetryServerOwner } సమర్పించబడింది { -brand-full-name } మెరుగుదలలో సహాయం కొరకు.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } లో కనుగొనండి
about-telemetry-filter-all-placeholder =
    .placeholder = అన్ని విభాగాలలో కనుగొనండి
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” కోసం ఫలితాలు
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = క్షమించాలి! { $sectionName }లో “{ $currentSearchText }” కోసం ఫలితాలు లేవు
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = క్షమించాలి! “{ $searchTerms }” కు ఏ విభాగాలలో ఫలితాలు లేవు
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = క్షమించాలి! “{ $sectionName }” లో ప్రస్తుతం ఏ సమాచారం అందుబాటులో లేదు
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = అన్నీ
# button label to copy the histogram
about-telemetry-histogram-copy = కాపీ చేయి
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = ముఖ్య త్రెడ్ పైన నిదానమైన SQL వాక్యాలు
about-telemetry-slow-sql-other = సహాయక త్రెడ్లపై నిదానమైన SQL వాక్యాలు
about-telemetry-slow-sql-hits = హిట్లు
about-telemetry-slow-sql-average = సగటు సమయం (ms)
about-telemetry-slow-sql-statement = వాక్యము
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = పొడిగింత ఐడి
about-telemetry-addon-table-details = వివరాలు
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } ఉత్పాదకి
about-telemetry-keys-header = లక్షణం
about-telemetry-names-header = పేరు
about-telemetry-values-header = విలువ
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (సంగ్రహణ సంఖ్య: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = లేట్ వ్రైట్ #{ $lateWriteCount }
about-telemetry-stack-title = స్టాక్:
about-telemetry-memory-map-title = మెమొరీ మాప్:
about-telemetry-error-fetching-symbols = చిహ్నాలను వెతికితెచ్చునప్పుడు ఒక దోషం యెదురైంది. మీరు యింటర్నెట్‌కు అనుసంధానమై వున్నారేమో పరిశీలించి మరలా ప్రయత్నించు.
about-telemetry-time-stamp-header = కాలముద్ర
about-telemetry-category-header = వర్గం
about-telemetry-method-header = పద్ధతి
about-telemetry-object-header = అంశం
about-telemetry-extra-header = అదనపు
