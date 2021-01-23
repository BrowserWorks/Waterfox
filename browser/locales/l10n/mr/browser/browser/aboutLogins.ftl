# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = लॉगिन व संकेतशब्द

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = आपले पासवर्ड सर्वत्र न्या
login-app-promo-subtitle = विनामूल्य { -lockwise-brand-name } अॅप मिळवा
login-app-promo-android =
    .alt = Google Play वर मिळवा
login-app-promo-apple =
    .alt = App Store वरुन डाउनलोड करा

login-filter =
    .placeholder = लॉगिन शोधा

create-login-button = नविन लॉगिन बनवा

fxaccounts-sign-in-text = आपल्या इतर उपकरणांवर आपले पासवर्ड मिळवा
fxaccounts-sign-in-button = { -sync-brand-short-name } मध्ये साइन इन करा
fxaccounts-avatar-button =
    .title = खाते व्यवस्थापित करा

## The ⋯ menu that is in the top corner of the page

menu =
    .title = मेनू उघडा
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] पर्याय
       *[other] प्राधान्ये
    }
about-logins-menu-menuitem-help = मदत
menu-menuitem-android-app = { -lockwise-brand-short-name } Android साठी
menu-menuitem-iphone-app = { -lockwise-brand-short-name } iPhone and iPad साठी

## Login List

login-list =
    .aria-label = शोध क्वेरीशी जुळणारे लॉगिन
login-list-count =
    { $count ->
        [one] { $count } लॉगिन
       *[other] { $count } लॉगिन्स
    }
login-list-sort-label-text = यानुसार क्रमवारी लावा:
login-list-name-option = नाव (A-Z)
login-list-last-changed-option = शेवटचा बदल
login-list-last-used-option = शेवटचा वापर
login-list-intro-title = कुठलेही लॉगिन सापडले नाही
about-logins-login-list-empty-search-title = कुठलेही लॉगिन सापडले नाही
about-logins-login-list-empty-search-description = आपल्या शोधाशी जुळणारे कोणतेही परिणाम नाहीत.
login-list-item-title-new-login = नविन लॉगीन
login-list-item-subtitle-new-login = तुमचे लॉगीन संकेतशब्द टाका
login-list-item-subtitle-missing-username = (कुठलेही वापरकर्तानाव नाही)

## Introduction screen


## Login

login-item-new-login-title = नविन लॉगिन बनवा
login-item-edit-button = संपादन करा
login-item-origin-label = संकेतस्थळ पत्ता
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = वापरकर्तानाव
about-logins-login-item-username =
    .placeholder = (वापरकर्तानाव नाही)
login-item-copy-username-button-text = प्रत बनवा
login-item-copied-username-button-text = प्रत बनवली!
login-item-password-label = संकेतशब्द
login-item-copy-password-button-text = प्रत करा
login-item-copied-password-button-text = प्रत बनवली!
login-item-save-changes-button = बदल जतन करा
login-item-save-new-button = जतन करा
login-item-cancel-button = रद्द करा
login-item-time-changed = शेवटचा सुधार: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = बनवले: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = शेवटचा वापर: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog


## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.


## Master Password notification

master-password-notification-message = साठवलेले लॉगिन आणि संकेतशब्द बघायला तुमचा मास्टर संकेतशब्द टाका

## Primary Password notification

master-password-reload-button =
    .label = लॉग इन
    .accesskey = L

## Password Sync notification

about-logins-enable-password-sync-dont-ask-again-button =
    .label = मला पुन्हा विचारू नका
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = रद्द करा
confirmation-dialog-dismiss-button =
    .title = रद्द करा

confirm-delete-dialog-message = ही कृती बदलू शकत नाही

confirm-discard-changes-dialog-title = जतन न केलेले बदल टाकून द्यायचे?
confirm-discard-changes-dialog-message = सर्व जतन न केलेले बदल गमावले जातील.
confirm-discard-changes-dialog-confirm-button = रद्द करा

## Breach Alert notification

# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname } वर जा
about-logins-breach-alert-learn-more-link = अधिक जाणा

## Vulnerable Password notification


## Error Messages

# This is a generic error message.
about-logins-error-message-default = हा पासवर्ड साठवताना त्रुटी आली.


## Login Export Dialog

## Login Import Dialog

