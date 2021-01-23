# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = लॉगिन और पासवर्ड

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = हर जगह अपना पासवर्ड लेकर चलें
login-app-promo-subtitle = मुफ्त { -lockwise-brand-name } ऐप प्राप्त करें
login-app-promo-android =
    .alt = इसे Google Play पर पायें
login-app-promo-apple =
    .alt = App Store पर डाउनलोड करें
login-filter =
    .placeholder = लॉगिन खोजें
create-login-button = नई लॉगिन बनाएँ
fxaccounts-sign-in-text = अपने पासवर्ड को अपने अन्य उपकरणों पर प्राप्त करें
fxaccounts-sign-in-button = { -sync-brand-short-name } में साइन इन करें
fxaccounts-avatar-button =
    .title = खाता प्रबंधित करें

## The ⋯ menu that is in the top corner of the page

menu =
    .title = मेन्यू खोलें
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = दूसरे ब्राउज़र से आयात करें…
about-logins-menu-menuitem-import-from-a-file = इस फ़ाइल से आयात करें…
about-logins-menu-menuitem-export-logins = लॉगिंस निर्यात करें…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] विकल्प
       *[other] प्राथमिकताएँ
    }
about-logins-menu-menuitem-help = सहायता
menu-menuitem-android-app = Android के लिए { -lockwise-brand-short-name }
menu-menuitem-iphone-app = iPhone और iPad के लिए { -lockwise-brand-short-name }

## Login List

login-list =
    .aria-label = खोजे गए प्रश्न से मेल खाते लॉगिन
login-list-count =
    { $count ->
        [one] { $count } लॉगिन
       *[other] { $count } लॉगिन
    }
login-list-sort-label-text = इसके अनुसार:
login-list-name-option = नाम (A-Z)
login-list-name-reverse-option = नाम (Z-A)
about-logins-login-list-alerts-option = चेतावनी
login-list-last-changed-option = अंतिम परिवर्तन
login-list-last-used-option = अंतिम प्रयुक्त
login-list-intro-title = कोई लॉग इन नहीं मिला
login-list-intro-description = जब आप { -brand-product-name } में पासवर्ड सहेजते हैं, तो वह यहाँ दिखाई देगा।
about-logins-login-list-empty-search-title = कोई लॉगिन नहीं मिला
about-logins-login-list-empty-search-description = आपकी खोज के अनुरूप कोई परिणाम नहीं मिला है।
login-list-item-title-new-login = नया लॉगिन
login-list-item-subtitle-new-login = अपनी लॉगिन जानकारी दर्ज करें
login-list-item-subtitle-missing-username = (कोई उपयोगकर्ता नाम नहीं)
about-logins-list-item-breach-icon =
    .title = उलंघित वेबसाइट
about-logins-list-item-vulnerable-password-icon =
    .title = असुरक्षित पासवर्ड

## Introduction screen

login-intro-heading = अपने सहेजे गए लॉगिन की खोज़ है? { -sync-brand-short-name } सेट करें।
about-logins-login-intro-heading-logged-out = अपने सहेजे लॉगिंस खोज रहे हैं? { -sync-brand-short-name } को सेटअप करें या उन्हें आयात करें।
about-logins-login-intro-heading-logged-in = कोई संकलित लॉगिन नहीं मिला।
login-intro-description = यदि आपने अपने लॉगिन को एक अलग डिवाइस पर { -brand-product-name } में सहेजा है, तो उन्हें यहां ऐसे प्राप्त करें:
login-intro-instruction-fxa = उस उपकरण पर अपना { -fxaccount-brand-name } बनाएं या साइन इन करें जिसपर आपके लॉगिन सहेजे गए हैं
login-intro-instruction-fxa-settings = सुनिश्चित करें कि आपने { -sync-brand-short-name } सेटिंग्स में लॉगिन चेकबॉक्स का चयन किया है
about-logins-intro-instruction-help = अधिक मदद के लिए <a data-l10n-name="help-link">{ -lockwise-brand-short-name } सहायता </a> पर जाएं
about-logins-intro-import = यदि आपके लॉगिन किसी अन्य ब्राउज़र में सहेजे गए हैं, तो आप उन्हें { -lockwise-brand-short-name } में <a data-l10n-name="import-link"> आयात </a> कर सकते हैं
about-logins-intro-import2 = अगर आपके लॉगिन { -brand-product-name } के बाहर सहेजे गए हैं, तो आप उन्हें <a data-l10n-name="import-browser-link">किसी दूसरे ब्राउज़र से</a> या <a data-l10n-name="import-file-link"> फ़ाइल से आयात करें</a>

## Login

login-item-new-login-title = नया लॉगिन बनाएं
login-item-edit-button = संपादित करें
about-logins-login-item-remove-button = हटाएँ
login-item-origin-label = वेबसाइट का पता
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = उपयोक्ता नाम
about-logins-login-item-username =
    .placeholder = (कोई उपयोक्तानाम नहीं)
login-item-copy-username-button-text = कॉपी करें
login-item-copied-username-button-text = कॉपी हो गया!
login-item-password-label = पासवर्ड
login-item-password-reveal-checkbox =
    .aria-label = पासवर्ड दिखाएं
login-item-copy-password-button-text = कॉपी करें
login-item-copied-password-button-text = कॉपी हो गया!
login-item-save-changes-button = परिवर्तनों को सहेजें
login-item-save-new-button = सहेजें
login-item-cancel-button = रद्द करें
login-item-time-changed = अंतिम परिवर्तन: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = निर्मित: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = अंतिम बार उपयोग: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = अपने लॉगिन को संपादित करने के लिए, अपनी Windows लॉगिन क्रेडेंशियल्स दर्ज करें। यह आपके खातों की सुरक्षा को बनाए रखने में मदद करता है।
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = सहेजे गए लॉगिन को संपादित करें
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = अपना पासवर्ड देखने के लिए, अपनी Windows लॉगिन क्रेडेंशियल्स दर्ज करें। यह आपके खातों की सुरक्षा को बनाए रखने में मदद करता है।
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = सहेजे गए पासवर्ड देखें
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = अपने पासवर्ड को कॉपी करने के लिए, अपनी Windows लॉगिन क्रेडेंशियल्स दर्ज करें। यह आपके खातों की सुरक्षा को बनाए रखने में मदद करता है।
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = सहेजे गए पासवर्ड को कॉपी करें

## Master Password notification

master-password-notification-message = सहेजे गए लॉगिन और पासवर्ड देखने के लिए कृपया अपना मास्टर पासवर्ड दर्ज करें
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = अपने लॉगिंस को निर्यात करने के लिए, अपनी Windows लॉगिन क्रेडेंशियल्स दर्ज करें। यह आपके खातों की सुरक्षा को बनाए रखने में मदद करता है।
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = सहेजे गए लॉगिन और पासवर्ड निर्यात करें

## Primary Password notification

about-logins-primary-password-notification-message = सहेजे गए लॉगिन और पासवर्ड देखने के लिए कृपया प्राईमरी पासवर्ड दर्ज करें
master-password-reload-button =
    .label = लॉग इन
    .accesskey = L

## Password Sync notification

enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name } विकल्प पर जाएँ
           *[other] { -sync-brand-short-name } वरीयताएँ पर जाएँ
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = मुझसे फिर न पूछें
    .accesskey = न

## Dialogs

confirmation-dialog-cancel-button = रद्द करें
confirmation-dialog-dismiss-button =
    .title = रद्द करें
about-logins-confirm-remove-dialog-title = इस लॉगिन को हटाएँ?
confirm-delete-dialog-message = इस क्रिया को पहले जैसा नहीं किया जा सकता।
about-logins-confirm-remove-dialog-confirm-button = हटाएँ
about-logins-confirm-export-dialog-title = लॉगिन और पासवर्ड निर्यात करें
about-logins-confirm-export-dialog-message = आपके पासवर्ड पढ़ने योग्य टेक्स्ट (जैसे BadP@ssw0rd) के रूप में सहेजे जाएंगे ताकि जो भी निर्यात की गई फ़ाइल को खोल पाएंगे, उन्हें देख सकते हैं।
about-logins-confirm-export-dialog-confirm-button = निर्यात करें…
confirm-discard-changes-dialog-title = न सहेजे गए परिवर्तनों को छोड़ें?
confirm-discard-changes-dialog-message = सभी सहेजे न गए परिवर्तन खो जाएंगे।
confirm-discard-changes-dialog-confirm-button = छोड़ें

## Breach Alert notification

about-logins-breach-alert-title = वेबसाइट उल्लंघन
breach-alert-text = आपके अंतिम बार अपना लॉगिन विवरण अपडेट करते समय पासवर्ड इस वेबसाइट से लीक या चोरी हो गए थे। अपने खाते की सुरक्षा के लिए अपना पासवर्ड बदलें।
about-logins-breach-alert-date = यह उल्लंघन { DATETIME($date, day: "numeric", month: "long", year: "numeric") } पर हुआ
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname } पर जाएं
about-logins-breach-alert-learn-more-link = अधिक जानें

## Vulnerable Password notification

about-logins-vulnerable-alert-title = कमजोर पासवर्ड
about-logins-vulnerable-alert-text2 = यह पासवर्ड किसी अन्य खाते पर उपयोग किया गया है जिसकी डेटा ब्रीच में होने की संभावना थी। क्रेडेंशियल का दोबारा उपयोग करना आपके सभी खातों को जोखिम में डालता है। इस पासवर्ड को बदलें।
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = { $hostname } पर जाएं
about-logins-vulnerable-alert-learn-more-link = अधिक जानें

## Error Messages

# This is a generic error message.
about-logins-error-message-default = पासवर्ड सहेजने का प्रयास करते समय एक त्रुटि हुई।

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = लॉगिंस फ़ाइल निर्यात करें
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = निर्यात करें
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV दस्तावेज़
       *[other] CSV फाइल
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = लॉगिंस फ़ाइल को आयात करें
about-logins-import-file-picker-import-button = आयात करें
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV दस्तावेज़
       *[other] CSV फ़ाइल
    }
