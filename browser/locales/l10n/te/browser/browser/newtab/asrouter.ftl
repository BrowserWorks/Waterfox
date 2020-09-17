# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = సిఫార్సు చేయబడిన పొడగింత
cfr-doorhanger-feature-heading = సిఫార్సు చేసిన సౌలభ్యం
cfr-doorhanger-pintab-heading = ఇది ప్రయత్నించండి: ట్యాబును పిన్ చెయ్యడం

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ఇది నేను ఎందుకు చూస్తున్నాను
cfr-doorhanger-extension-cancel-button = ఇప్పుడు వద్దు
    .accesskey = N
cfr-doorhanger-extension-ok-button = ఇప్పుడే చేర్చు
    .accesskey = A
cfr-doorhanger-pintab-ok-button = ఈ ట్యాబును పిన్ చేయి
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = సిఫారసు అమరికలను నిర్వహించండి
    .accesskey = M
cfr-doorhanger-extension-never-show-recommendation = ఈ సిఫార్సును నాకు చూపించవద్దు
    .accesskey = S
cfr-doorhanger-extension-learn-more-link = ఇంకా తెలుసుకోండి
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } నుండి
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = సిఫార్సు
cfr-doorhanger-extension-notification2 = సిఫార్సు
    .tooltiptext = పొడగింత సిఫార్సు
    .a11y-announcement = పొడగింత సిఫార్సు అందుబాటులో ఉంది
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = సిఫార్సు
    .tooltiptext = సౌలభ్యపు సిఫార్సు
    .a11y-announcement = సౌలభ్యపు సిఫార్సు అందుబాటులో ఉంది

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } నక్షత్రం
           *[other] { $total } నక్షత్రాలు
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } వాడుకరి
       *[other] { $total } వాడుకరులు
    }
cfr-doorhanger-pintab-description = మీరు ఎక్కువగా వాడే సైట్లకు తేలికగా చేరుకోండి. సైట్లను ట్యాబులో తెరిచి ఉంచండి (మీరు పునఃప్రారంభించినప్పుడు కూడా).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = పిన్ను చేయాలనుకుంటున్న ట్యాబు మీద <b>కుడి-నొక్కు</b> నొక్కండి.
cfr-doorhanger-pintab-step2 = మెనూ నుండి <b>ట్యాబును పిన్ చేయి<b>‌ని ఎంచుకోండి.
cfr-doorhanger-pintab-step3 = సైటులో తాజాకరణ ఉంటే, పిన్ చేసిన ట్యాబు మీద నీలిరంగు బిందువు కనిపిస్తుంది.
cfr-doorhanger-pintab-animation-pause = నిలుపు
cfr-doorhanger-pintab-animation-resume = కొనసాగించు

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = మీ ఇష్టాంశాలను ప్రతిచోటా సింక్రనించుకోండి.
cfr-doorhanger-bookmark-fxa-body = భలే కనుక్కొన్నారు! ఇప్పుడు మీ చరవాణి పరికరాల్లో ఈ ఇష్టాంశం లేకుండా ఉండకండి. { -fxaccount-brand-name } మొదలుపెట్టండి.
cfr-doorhanger-bookmark-fxa-link-text = ఇష్టాంశాలను ఇప్పుడు సింక్రనించు…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = మూసివేయు బొత్తం
    .title = మూసివేయి

## Protections panel

cfr-protections-panel-header = అనుసరింపబడకుండా విహరించండి
cfr-protections-panel-body = మీ డేటాను మీ వద్దనే ఉంచుకోండి. ఆన్‌లైన్‌లో మీ జాడ తెలుసుకునే చాలా సామాన్య ట్రాకర్ల నుండి { -brand-short-name } మిమ్మల్ని కాపాడుతుంది.
cfr-protections-panel-link-text = ఇంకా తెలుసుకోండి

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = కొత్త విశేషం:
cfr-whatsnew-button =
    .label = కొత్తవి ఏమిటి
    .tooltiptext = కొత్తవి ఏమిటి
cfr-whatsnew-panel-header = కొత్తవి ఏమిటి
cfr-whatsnew-release-notes-link-text = విడుదల గమనికలను చదవండి
cfr-whatsnew-fx70-title = మీ గోప్యత కోసం { -brand-short-name } ఇప్పుడు మరింత గట్టిగా పోరాడుతుంది
cfr-whatsnew-tracking-protect-title = ట్రాకర్ల నుండి మిమ్మల్ని మీరు రక్షించుకోండి
cfr-whatsnew-tracking-protect-link-text = మీ నివేదికను చూడండి
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] ట్రాకరు నిరోధించబడింది
       *[other] ట్రాకర్లు నిరోధించబడ్డాయి
    }
cfr-whatsnew-tracking-blocked-subtitle = { DATETIME($earliestDate, month: "long", year: "numeric") } నుండి
cfr-whatsnew-tracking-blocked-link-text = నివేదికను చూడండి
cfr-whatsnew-lockwise-backup-title = మీ సంకేతపదాలను బ్యాకప్ తీసుకోండి
cfr-whatsnew-lockwise-backup-link-text = బ్యాకప్‌లను చేతనించండి
cfr-whatsnew-lockwise-take-title = మీ సంకేతపదాలను మీతో తీసుకెళ్ళండి
cfr-whatsnew-lockwise-take-link-text = అనువర్తనాన్ని పొందండి

## Search Bar

cfr-whatsnew-searchbar-title = తక్కువ టైప్ చేయండి, చిరునామా పట్టీతో ఎక్కువ కనుగొనండి
cfr-whatsnew-searchbar-body-topsites = ఇప్పుడు, కేవలం చిరునామా పట్టీని ఎంచుకోండి, మీ మేటి సైట్లతో ఒక పెట్టె తెరుచుకుంటుంది.
cfr-whatsnew-searchbar-icon-alt-text = భూతద్దపు ప్రతీకం

## Picture-in-Picture

cfr-whatsnew-pip-header = విహరిస్తూ కూడా వీడియోలు చూడండి
cfr-whatsnew-pip-cta = ఇంకా తెలుసుకోండి

## Permission Prompt

cfr-whatsnew-permission-prompt-header = విసిగించే పాప్-అప్స్ తక్కువవుతాయి
cfr-whatsnew-permission-prompt-cta = ఇంకా తెలుసుకోండి

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] నిరోధించిన ఫింగర్‌ప్రింటరు
       *[other] నిరోధించిన ఫింగర్‌ప్రింటర్లు
    }
cfr-whatsnew-fingerprinter-counter-body = మీ పరికరం, కార్యకలాపం గురించి గోప్యంగా సమాచారం సేకరించి మీ వ్యాపారప్రకటనల ప్రొఫైలును తయారుచేసే చాలా ఫింగర్‌ప్రింటర్లను { -brand-shorter-name } నిరోధిస్తుంది.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = ఫింగర్‌ప్రింటర్లు
cfr-whatsnew-fingerprinter-counter-body-alt = మీ పరికరం, కార్యకలాపం గురించి గోప్యంగా సమాచారం సేకరించి మీ వ్యాపారప్రకటనల ప్రొఫైలును తయారుచేసే ఫింగర్‌ప్రింటర్లను { -brand-shorter-name } నిరోధించగలదు.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = ఈ ఇష్టాంశాన్ని మీ ఫోనులో పొందండి
cfr-doorhanger-sync-bookmarks-body = మీరు { -brand-product-name }‌లో ప్రవేశించిన ప్రతీచోటుకీ మీ ఇష్టాంశాలను, సంకేతపదాలను, చరిత్ర, ఇంకా ఎన్నో తీసుకెళ్ళండి.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name }‌ను చేతనించు
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = ఇంకెప్పుడూ సంకేతపదాల్ని కోల్పోవద్దు
cfr-doorhanger-sync-logins-body = మీ సంకేతపదాలను సురక్షితంగా భద్రపరచుకొని మీ పరికరాలన్నింటిలోనూ సింక్రనించుకోండి.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name }ను చేతనించు
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = ప్రయాణంలో ఉన్నప్పుడు దీన్ని చదవండి
cfr-doorhanger-send-tab-recipe-header = ఈ రెసిపీని వంటగదికి తీసుకెళ్ళండి
cfr-doorhanger-send-tab-ok-button = ట్యాబు పంపడాన్ని ప్రయత్నించండి
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = ఈ PDFని సురక్షితంగా పంచుకోండి
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name }ని ప్రయత్నించండి
    .accesskey = ప

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = రక్షణలు చూడండి
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = మూసివేయి
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = ఇలాంటి సందేశాలను నాకు మళ్ళీ చూపించకు
    .accesskey = D
cfr-doorhanger-socialtracking-heading = ఇక్కడ మిమ్మల్ని ట్రాక్ చేయకుండా ఒక సామాజిక నెట్‌వర్క్‌ని { -brand-short-name } ఆపివేసింది
cfr-doorhanger-fingerprinters-heading = ఈ పేజీలో ఒక పింగర్‌ప్రింటర్ని { -brand-short-name } నిరోధించింది
cfr-doorhanger-cryptominers-heading = ఈ పేజీలో ఒక క్రిప్టోమైనరును { -brand-short-name } నిరోధించింది

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { $date } నుండి { -brand-short-name } <b>{ $blockedCount }</b> పైగా ట్రాకర్లకు నిరోధించింది!
       *[other] { $date } నుండి { -brand-short-name } <b>{ $blockedCount }</b> పైగా ట్రాకర్లకు నిరోధించింది!
    }
cfr-doorhanger-milestone-ok-button = అన్నింటినీ చూడండి
    .accesskey = S
cfr-doorhanger-milestone-close-button = మూసివేయి
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = సురక్షితమైన సంకేతపదాలను తేలికగా సృష్టించుకోండి
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } ప్రతీకం

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = బలహీనమైన సంకేతపదాల గురించి హెచ్చరికలను పొందండి
cfr-whatsnew-passwords-icon-alt = బలహీన సంకేతపదపు తాళంచెవి ప్రతీకం

## Picture-in-Picture fullscreen message


## Protections Dashboard message

cfr-whatsnew-protections-header = ఒక్కచూపులో సంరక్షణలు
cfr-whatsnew-protections-cta-link = సంరక్షణల డాష్‌బోర్డ్ చూడండి

## Better PDF message

cfr-whatsnew-better-pdf-header = మెరుగైన PDF అనుభవం

## DOH Message

cfr-doorhanger-doh-header = మరింత సురక్షితం, ఎన్‌క్రిప్ట్ అయిన DNS శోధనలు
cfr-doorhanger-doh-primary-button = సరే, అర్థమయ్యింది
    .accesskey = O
cfr-doorhanger-doh-secondary-button = అచేతనించు
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = ట్రాకింగ్ జిత్తుల నుండి స్వయంచాలక సంరక్షణ
