# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = ప్రవేశాలు & సంకేతపదాలు

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = మీ సంకేతపదాలను ఎక్కడికైనా తీసుకెళ్ళండి
login-app-promo-subtitle = ఉచిత { -lockwise-brand-name } అనువర్తనాన్ని పొందండి
login-app-promo-android =
    .alt = దీన్ని గూగుల్ ప్లే నుండి పొందండి
login-app-promo-apple =
    .alt = App Store నుండి దింపుకోండి
login-filter =
    .placeholder = ప్రవేశాలను వెతకండి
create-login-button = కొత్త ప్రవేశాన్ని సృష్టించు
fxaccounts-sign-in-text = మీ సంకేతపదాలను ఇతర పరికరాల్లో పొందండి
fxaccounts-sign-in-button = { -sync-brand-short-name } లోనికి ప్రవేశించండి
fxaccounts-avatar-button =
    .title = ఖాతా నిర్వహించు

## The ⋯ menu that is in the top corner of the page

menu =
    .title = మెనూని తెరవండి
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = మరో విహారిణి నుండి దిగుమతిచేయి…
about-logins-menu-menuitem-import-from-a-file = ఒక దస్త్రం నుండి దిగుమతించు…
about-logins-menu-menuitem-export-logins = ప్రవేశాలను ఎగుమతించు…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] ఎంపికలు
       *[other] అభిరుచులు
    }
about-logins-menu-menuitem-help = సహాయం
menu-menuitem-android-app = ఆండ్రాయిడ్ కొరకు { -lockwise-brand-short-name }
menu-menuitem-iphone-app = iPhone, iPad కొరకు { -lockwise-brand-short-name }

## Login List

login-list =
    .aria-label = వెతుకులాటకు సరిపోయే ప్రవేశాలు
login-list-count =
    { $count ->
        [one] { $count } ప్రవేశం
       *[other] { $count } ప్రవేశాలు
    }
login-list-sort-label-text = క్రమం:
login-list-name-option = పేరు (A-Z)
login-list-name-reverse-option = పేరు (Z-A)
about-logins-login-list-alerts-option = హెచ్చరికలు
login-list-last-changed-option = చివరి మార్పు
login-list-last-used-option = చివరగా వాడినది
login-list-intro-title = ప్రవేశాలేమీ కనబడలేదు
login-list-intro-description = మీరు { -brand-product-name }‌లో సంకేతపదాలను భద్రపరచినపుడు, అవి ఇక్కడ కనిపిస్తాయి.
about-logins-login-list-empty-search-title = ప్రవేశాలేమీ కనబడలేదు
about-logins-login-list-empty-search-description = మీ వెతుకుడుకు సరిపోయే ఫలితాలు లేవు.
login-list-item-title-new-login = కొత్త ప్రవేశం
login-list-item-subtitle-new-login = మీ ప్రవేశ వివరాలు ఇవ్వండి
login-list-item-subtitle-missing-username = (వాడుకరి పేరు లేదు)
about-logins-list-item-breach-icon =
    .title = ఉల్లంఘిత వెబ్‌సైటు
about-logins-list-item-vulnerable-password-icon =
    .title = బలహీనమైన సంకేతపదం

## Introduction screen

login-intro-heading = మీరు భద్రపరుచుకొన్న ప్రవేశాల కోసం వెతుకుతున్నారా? { -sync-brand-short-name } అమర్చుకోండి.
about-logins-login-intro-heading-logged-out = మీరు భద్రపరుచుకొన్న ప్రవేశాల కోసం వెతుకుతున్నారా? { -sync-brand-short-name } అమర్చుకోండి లేదా వాటిని దిగుమతి చేసుకోండి.
about-logins-login-intro-heading-logged-in = సింక్రనిత ప్రవేశాలేమీ కనబడలేదు.
login-intro-description = మరో పరికరంలో మీ ప్రవేశాలను { -brand-product-name }‌లో భద్రపరచుకొని ఉంటే, వాటిని ఇక్కడకు తెచ్చుకోవడం ఇలా:
login-intro-instruction-fxa = మీ ప్రవేశాలు ఉన్న పరికరంలో { -fxaccount-brand-name } సృష్టించుకోండి లేదా మీ ఖాతా లోనికి ప్రవేశించండి
login-intro-instruction-fxa-settings = { -sync-brand-short-name } అమరికలలో మీరు ప్రవేశాలు ఎంపిక వద్ద టిక్కు పెట్టారని నిర్ధారించుకోండి
about-logins-intro-instruction-help = మరింత సహాయం కోసం <a data-l10n-name="help-link">{ -lockwise-brand-short-name } తోడ్పాటు</a>‌ని చూడండి
about-logins-intro-import = మీ ప్రవేశాలు వేరే విహారిణిలో భద్రమైవుంటే, వాటిని <a data-l10n-name="import-link">{ -lockwise-brand-short-name } లోనికి దిగుమతి చేసుకోండి</a>

## Login

login-item-new-login-title = కొత్త ప్రవేశాన్ని సృష్టించు
login-item-edit-button = మార్చు
about-logins-login-item-remove-button = తొలగించు
login-item-origin-label = వెబ్‌సైటు చిరునామా
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = వాడుకరి పేరు
about-logins-login-item-username =
    .placeholder = (వాడుకరి పేరు లేదు)
login-item-copy-username-button-text = కాపీచేయి
login-item-copied-username-button-text = కాపీ అయ్యింది!
login-item-password-label = సంకేతపదం
login-item-password-reveal-checkbox =
    .aria-label = సంకేతపదాన్ని చూపించు
login-item-copy-password-button-text = కాపీచేయి
login-item-copied-password-button-text = కాపీ అయ్యింది!
login-item-save-changes-button = మార్పులను భద్రపరుచు
login-item-save-new-button = భద్రపరుచు
login-item-cancel-button = రద్దుచేయి
login-item-time-changed = చివరి మార్పు: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = సృష్టితం: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = చివరి వాడుక: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = భద్రపరచిన సంకేతపదాన్ని చూపించడానికి
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = భద్రపరచిన సంకేతపదాన్ని కాపీచేయడానికి

## Master Password notification


## Primary Password notification

master-password-reload-button =
    .label = ప్రవేశించండి
    .accesskey = L

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] మీరు { -brand-product-name } వాడుతున్న చోటల్లా మీ ప్రవేశాలు కావాలనుకుంటున్నారా? మీ { -sync-brand-short-name } ఎంపికలకు వెళ్ళి, ప్రవేశాలు అనేచోట టిక్కుపెట్టండి.
       *[other] మీరు { -brand-product-name } వాడుతున్న చోటల్లా మీ ప్రవేశాలు కావాలనుకుంటున్నారా? మీ { -sync-brand-short-name } అభిరుచులకు వెళ్ళి, ప్రవేశాలు అనేచోట టిక్కుపెట్టండి.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name } ఎంపికలను చూడండి
           *[other] { -sync-brand-short-name } అభిరుచులను చూడండి
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = నన్ను మళ్లీ అడగవద్దు
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = రద్దుచేయి
confirmation-dialog-dismiss-button =
    .title = రద్దుచేయి
about-logins-confirm-remove-dialog-title = ఈ ప్రవేశాన్ని తొలగించాలా?
confirm-delete-dialog-message = ఈ చర్యను రద్దు చేయలేరు.
about-logins-confirm-remove-dialog-confirm-button = తొలగించు
about-logins-confirm-export-dialog-title = ప్రవేశాలను, సంకేతపదాలను ఎగుమతిచేయి
about-logins-confirm-export-dialog-confirm-button = ఎగుమతించు…
confirm-discard-changes-dialog-title = భద్రపరచని మార్పులను విస్మరించాలా?
confirm-discard-changes-dialog-message = భద్రపరచని మార్పులన్నీ కోల్పోతారు.
confirm-discard-changes-dialog-confirm-button = విస్మరించు

## Breach Alert notification

breach-alert-text = మీరు చివరిసారి మీ ప్రవేశ వివరాలను తాజాకరించిన తర్వాత ఈ వెబ్‌సైటు నుండి సంకేతపదాలు బయల్పడ్డాయి లేదా దొంగిలించబడ్డాయి. మీ ఖాతాను సంరక్షించుకోడానికి మీ సంకేపదాన్ని మార్చుకోండి.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname }కు వెళ్ళండి
about-logins-breach-alert-learn-more-link = ఇంకా తెలుసుకోండి

## Vulnerable Password notification

about-logins-vulnerable-alert-title = బలహీనమైన సంకేతపదం
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = { $hostname }కు వెళ్ళండి
about-logins-vulnerable-alert-learn-more-link = ఇంకా తెలుసుకోండి

## Error Messages

# This is a generic error message.
about-logins-error-message-default = ఈ సంకేతపదాన్ని భద్రపరచడానికి ప్రయత్నిస్తున్నప్పుడు ఏదో పొరపాటు జరిగింది.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = ప్రవేశాల ఎగుమతి దస్త్రం
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = ఎగుమతించు
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV పత్రం
       *[other] CSV దస్త్రం
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = ప్రవేశాల దిగుమతి దస్త్రం
about-logins-import-file-picker-import-button = దిగుమతించు
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV పత్రం
       *[other] CSV దస్త్రం
    }
