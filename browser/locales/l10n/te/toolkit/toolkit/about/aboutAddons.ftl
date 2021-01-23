# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = పొడిగింతల నిర్వాహకి
addons-page-title = పొడిగింతల నిర్వాహకి

search-header =
    .placeholder = addons.mozilla.orgలో వెతకండి
    .searchbuttonlabel = వెతుకు

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = మీ వద్ద ఈ రకమైన పొడిగింతలేమీ స్థాపించి లేవు

list-empty-available-updates =
    .value = ఏ నవీకరణలు కనుగొనలేదు

list-empty-recent-updates =
    .value = మీరు ఇటీవల ఏ పొడిగింతలు నవీకరించలేదు

list-empty-find-updates =
    .label = నవీకరణల కొరకు పరిశీలించు

list-empty-button =
    .label = పొడిగింతలు గురించి మరింత తెలుసుకొనండి

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } ఎంపికలు
       *[other] { -brand-short-name } అభిరుచులు
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } ఎంపికలు
           *[other] { -brand-short-name } అభిరుచులు
        }

show-unsigned-extensions-button =
    .label = కొన్ని పొడగింతలను తనిఖీ చేయలేకపోయాం

show-all-extensions-button =
    .label = అన్ని పొడగింతలను చూపించు

cmd-show-details =
    .label = మరింత సమాచారం చూపించు
    .accesskey = S

cmd-find-updates =
    .label = నవీకరణలను కనుగొను
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] ఎంపికలు
           *[other] అభిరుచులు
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = ఐచ్ఛిక ధీముని దరించు
    .accesskey = W

cmd-disable-theme =
    .label = ఎంపిక శైలిని దరించుటను ఆపు
    .accesskey = W

cmd-install-addon =
    .label = స్థాపించు
    .accesskey = I

cmd-contribute =
    .label = తోడ్పడండి
    .accesskey = C
    .tooltiptext = ఈ పొడిగింత అభివృద్దిలో పాల్గొనుము

detail-version =
    .label = వెర్షను

detail-last-updated =
    .label = చివరిగా నవీకరించింది

detail-contributions-description = ఈ పొడిగింతను అభివృద్దికారి దాని తదుపరి అభివృద్ది కొనసాగింపు కొరకు మీ నుండి కొద్ది మొత్తంలో సహాయంను కోరుచున్నారు.

detail-update-type =
    .value = స్వయంచాలక నవీకరణలు

detail-update-default =
    .label = అప్రమేయం
    .tooltiptext = తాజాకరణలను స్థాపిచడం అప్రమేయమైతే వాటిని స్వయంచాలంకగా స్థాపించు

detail-update-automatic =
    .label = ఆన్ చేయి
    .tooltiptext = తాజాకరణలను స్వయంచాలకంగా స్థాపించు

detail-update-manual =
    .label = ఆఫ్ చేయి
    .tooltiptext = తాజాకరణలను స్వయంచాలకంగా స్థాపించవద్దు

detail-private-browsing-on =
    .label = అనుమతించు
    .tooltiptext = అంతరంగిక విహరణలో చేతనంచేయి

detail-private-browsing-off =
    .label = అనుమతించ వద్దు
    .tooltiptext = అంతరంగిక విహరణలో అచేతనించు

detail-home =
    .label = ముంగిలిపేజీ

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = పొడిగింత పరిచయపత్రం

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = నవీకరణల కొరకు పరిశీలించు
    .accesskey = F
    .tooltiptext = ఈ పొడిగింత కొరకు నవీకరణలను పరిశీలించు

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] ఎంపికలు
           *[other] అభిరుచులు
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] ఈ పొడిగింత యొక్క ఎంపికలను మార్చు
           *[other] ఈ పొడిగింత యొక్క అభీష్టాలను మార్చు
        }

detail-rating =
    .value = శ్రేష్టత

addon-restart-now =
    .label = ఇప్పుడే పునఃప్రారంభించు

disabled-unsigned-heading =
    .value = కొన్ని పొడిగింతలు అచేతనించబడ్డాయి

disabled-unsigned-description = { -brand-short-name }‌లో వాడటానికి ఈ కింది పొడిగింతలు తనిఖీ చేయబడలేదు. మీరు <label data-l10n-name="find-addons">ప్రత్యామ్నాయాలు కనుగొను</label> లేదా డెవలపర్లను వాటిని తనిఖీ చేయించమని అడగవచ్చు.

disabled-unsigned-learn-more = ఆన్‌లైన్లో మిమ్మల్ని సురక్షితంగా ఉంచడానికి మేం చేసే కృషి గురించి తెలుసుకోండి.

disabled-unsigned-devinfo = తమ పొడిగింతలను తనిఖీ చేయించుకోవాలనుకునే డెవలపర్లు మా  చదివి కొనసాగించవచ్చు<label data-l10n-name="learn-more">మానవీయం</label>.

plugin-deprecation-description = ఏదైనా లేదా? కొన్ని ప్లగిన్లకు { -brand-short-name } ఇకపై తోడ్పాటు లేదు. <label data-l10n-name="learn-more">ఇంకా తెలుసుకోండి.</label>

legacy-warning-show-legacy = లెగసీ పొడగింతలను చూపించు

legacy-extensions =
    .value = పాత పొడగింతలు

legacy-extensions-description = ఈ పొడిగింతలు ప్రస్తుత { -brand-short-name } ప్రమాణాలను చేరుకోవు కాబట్టి అవి క్రియారహితం చేయబడ్డాయి. <label data-l10n-name="legacy-learn-more">పొడిగింతల మార్పుల గురించి తెలుసుకోండి</label>

addon-category-discover = సిఫారసులు
addon-category-discover-title =
    .title = సిఫారసులు
addon-category-extension = పొడగింతలు
addon-category-extension-title =
    .title = పొడగింతలు
addon-category-theme = అలంకారాలు
addon-category-theme-title =
    .title = అలంకారాలు
addon-category-plugin = చొప్పింతలు
addon-category-plugin-title =
    .title = చొప్పింతలు
addon-category-dictionary = నిఘంటువులు
addon-category-dictionary-title =
    .title = నిఘంటువులు
addon-category-locale = భాషలు
addon-category-locale-title =
    .title = భాషలు
addon-category-available-updates = అందుబాటులోని నవీకరణలు
addon-category-available-updates-title =
    .title = అందుబాటులోని నవీకరణలు
addon-category-recent-updates = ఇటీవలి నవీకరణలు
addon-category-recent-updates-title =
    .title = ఇటీవలి నవీకరణలు

## These are global warnings

extensions-warning-safe-mode = అన్ని పొడిగింతలు సేఫ్ మోడ్ చేత అచేతనపరచబడినవి.
extensions-warning-check-compatibility = పొడిగింత సారూప్యతా పరిశీలన అచేతనమైంది. మీరు సారూప్యతలేని పొడిగింతలు కలిగివుండవచ్చును.
extensions-warning-check-compatibility-button = చేతనపరచు
    .title = పొడిగింత సారూప్యతా పరిశీలనను చేతనపరచు
extensions-warning-update-security = పొడిగింత నవీకరణ రక్షణ పరిశీలన అచేతనమైంది. మీ జోక్యం లేకుండా నవీకరణలు జరుగవచ్చు.
extensions-warning-update-security-button = చేతనపరచు
    .title = పొడిగింత నవీకరణ రక్షణ పరిశీలనను చేతనముచేయి


## Strings connected to add-on updates

addon-updates-check-for-updates = నవీకరణల కొరకు పరిశీలించు
    .accesskey = C
addon-updates-view-updates = ఇటీవలి తాజాకరణలను చూడండి
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = పొడిగింతలను స్వయంచాలకంగా నవీకరించు
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = స్వయంచాలకంగా నవీకరించుటకు అన్ని పొడిగింతలును రీసెట్ చేయు
    .accesskey = R
addon-updates-reset-updates-to-manual = పొడగింతలన్నీ మానవీయంగా తాజాపరచుకునేలా మార్చు
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = పొడిగింతలను నవీకరిస్తున్నది
addon-updates-installed = మీ పొడిగింతలు తాజాకరించబడ్డాయి.
addon-updates-none-found = తాజాకరణలు ఏమీ లేవు
addon-updates-manual-updates-found = అందుబాటులోని తాజాకరణలను చూడండి

## Add-on install/debug strings for page options menu

addon-install-from-file = ఫైలు నుండి పొడిగింతను స్థాపించు…
    .accesskey = I
addon-install-from-file-dialog-title = స్థాపించాల్సిన పొడిగింతను ఎంచుకోండి
addon-install-from-file-filter-name = పొడిగింతలు
addon-open-about-debugging = పొడిగింతలను డీబగ్ చేయుము
    .accesskey = B

## Extension shortcut management

shortcuts-card-collapse-button = తక్కువ చూపించు

header-back-button =
    .title = వెనుకకు వెళ్ళు

## Recommended add-ons page

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    వీటిలో కొన్ని పొడగింతలు వ్యక్తిగతీకరించబడ్డాయి. అవి మీరు స్థాపించుకున్న
    ఇతర పొడగింతలు, ప్రొఫైలు అభిరుచులు, వాడుక గణాంకాలపై ఆధారపడినవి.
discopane-notice-learn-more = ఇంకా తెలుసుకోండి

# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = వాడుకరులు: { $dailyUsers }
install-theme-button = అలంకారాన్ని స్థాపించు
find-more-addons = మరిన్ని పొడగింతలను కనుగొనండి

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = మరిన్ని ఎంపికలు

## Add-on actions

report-addon-button = నివేదించు
remove-addon-button = తొలగించు
disable-addon-button = అచేతనించు
enable-addon-button = చేతనించు
preferences-addon-button =
    { PLATFORM() ->
        [windows] ఎంపికలు
       *[other] అభిరుచులు
    }
details-addon-button = వివరాలు
permissions-addon-button = అనుమతులు

extension-enabled-heading = చేతనం
extension-disabled-heading = అచేతనం

theme-enabled-heading = చేతనం
theme-disabled-heading = అచేతనం

plugin-enabled-heading = చేతనం
plugin-disabled-heading = అచేతనం

dictionary-enabled-heading = చేతనం
dictionary-disabled-heading = అచేతనం

locale-enabled-heading = చేతనం
locale-disabled-heading = అచేతనం

addon-detail-author-label = రచయిత
addon-detail-version-label = వెర్షను
addon-detail-homepage-label = ముంగిలిపేజీ

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (అచేతనం)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } సమీక్ష
       *[other] { $numberOfReviews } సమీక్షలు
    }

## Pending uninstall message bar

addon-detail-updates-radio-default = అప్రమేయం
addon-detail-update-check-label = తాజాకరణలకై చూడు

addon-detail-private-browsing-allow = అనుమతించు
addon-detail-private-browsing-disallow = అనుమతించ వద్దు

available-updates-heading = అందుబాటులో ఉన్న తాజాకరణలు
recent-updates-heading = ఇటీవలి తాజాకరణలు

## Page headings

extension-heading = మీ పొడగింతలను నిర్వహించుకోండి
theme-heading = మీ అలంకారాలను నిర్వహించుకోండి
plugin-heading = మీ చొప్పింతలను నిర్వహించుకోండి
discover-heading = మీ { -brand-short-name }‌ను వ్యక్తిగతీకరించుకోండి

default-heading-search-label = మరిన్ని పొడగింతలను కనుగొనండి
addons-heading-search-input =
    .placeholder = addons.mozilla.orgలో వెతకండి

addon-page-options-button =
    .title = అన్ని పొడిగింతలు కొరకు సాధనములు
