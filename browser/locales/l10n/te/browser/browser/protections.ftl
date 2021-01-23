# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] గత వారంలో { -brand-short-name }  { $count } ట్రాకరును నిరోధించింది
       *[other] గత వారంలో { -brand-short-name } { $count } ట్రాకర్లను నిరోధించింది
    }
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = ఈ వారం { -brand-short-name } నిరోధించిన ట్రాకర్లు
protection-report-webpage-title = సంరక్షణల డాష్‌బోర్డ్
protection-report-page-content-title = సంరక్షణల డాష్‌బోర్డ్
protection-report-settings-link = మీ అంతరంగికత, భద్రత అమరికలను నిర్వహించుకోండి
etp-card-title-always = మెరుగైన ట్రాకింగ్ సంరక్షణ: ఎల్లప్పుడూ చేతనం
etp-card-title-custom-not-blocking = మెరుగైన ట్రాకింగ్ సంరక్షణ: అచేతనం
protection-report-manage-protections = అమరికలను నిర్వహించుకోండి
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = ఈరోజు
social-tab-title = సామాజిక మాధ్యమాల ట్రాకర్లు
cookie-tab-title = క్రాస్-సైట్ ట్రాకింగ్ కుకీలు
fingerprinter-tab-title = ఫింగర్‌ప్రింటర్లు
cryptominer-tab-title = క్రిప్టోమైనర్లు
protections-close-button2 =
    .aria-label = మూసివేయి
    .title = మూసివేయి
lockwise-title = ఇంకెప్పుడూ సంకేతపదాలను మర్చిపోకండి
lockwise-title-logged-in2 = సంకేతపదాల నిర్వాహణ
protection-report-save-passwords-button = సంతేతపదాలను భద్రపరుచు
    .title = { -lockwise-brand-short-name }లో సంకేతపదాలను భద్రపరుచు
protection-report-manage-passwords-button = సంకేతపదాలను నిర్వహించుకోండి
    .title = { -lockwise-brand-short-name }‌లో సంకేతపదాలను నిర్వహించుకోండి
lockwise-mobile-app-title = మీ సంకేతపదాలను ఎక్కడికైనా తీసుకెళ్ళండి
lockwise-no-logins-card-content = { -brand-short-name }లో భద్రపరచిన సంకేతపదాలను ఏ పరికరంలోనైనా వాడుకోండి.
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 సంకేతపదం సురక్షితంగా భద్రపరచబడింది.
       *[other] మీ సంకేతపదాలు సురక్షితంగా భద్రమవుతున్నాయి.
    }
lockwise-how-it-works-link = ఇది ఎలా పనిచేస్తుంది
monitor-link = ఇది ఎలా పనిచేస్తుంది
monitor-no-breaches-title = శుభవార్త!
monitor-view-report-link = నివేదికను చూడండి
    .title = { -monitor-brand-short-name }లో ఉల్లంఘనలను పరిష్కరించుకోండి
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% పూర్తి
monitor-partial-breaches-motivation-title-start = గొప్ప ఆరంభం!

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = సామాజిక మాధ్యమాల ట్రాకర్లు
    .aria-label =
        { $count ->
            [one] { $count } సామాజిక మాధ్యమాల ట్రాకరు ({ $percentage }%)
           *[other] { $count } సామాజిక మాధ్యమాల ట్రాకర్లు ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = క్రాస్-సైట్ ట్రాకింగ్ కుకీలు
    .aria-label =
        { $count ->
            [one] { $count } క్రాస్-సైట్ ట్రాకింగ్ కుకీ ({ $percentage }%)
           *[other] { $count } క్రాస్-సైట్ ట్రాకింగ్ కుకీలు ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = ట్రాకింగ్ విషయం
    .aria-label =
        { $count ->
            [one] { $count } ట్రాకింగ్ విషయం ({ $percentage }%)
           *[other] { $count } ట్రాకింగ్ విషయాలు ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = ఫింగర్‌ప్రింటర్లు
    .aria-label =
        { $count ->
            [one] { $count } ఫింగర్‌ప్రింటర్ ({ $percentage }%)
           *[other] { $count } ఫింగర్‌ప్రింటర్లు ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = క్రిప్టోమైనర్లు
    .aria-label =
        { $count ->
            [one] { $count } క్రిప్టోమైనరు ({ $percentage }%)
           *[other] { $count } క్రిప్టోమైనర్లు ({ $percentage }%)
        }
