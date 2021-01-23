# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = புகுபதிகைககளும் கடவுச்சொற்களும்

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = உங்கள் கடவுச்சொற்களை உங்களுடன் எடுத்துச் செல்லுங்கள்
login-app-promo-subtitle = இலவசமாக { -lockwise-brand-name } செயிலியைப் பெறுக
login-app-promo-android =
    .alt = Google Play இல் பெற
login-app-promo-apple =
    .alt = செயலி கடையிலிந்து பதிவிறக்குக

login-filter =
    .placeholder = புகுபதிகைகளைத் தேடு

create-login-button = புதிய புகுபதிகையை உருவாக்கு

fxaccounts-sign-in-text = உங்கள் கடவுச்சொற்களை மற்ற சாதனங்களில் பெறுங்கள்
fxaccounts-sign-in-button = { -sync-brand-short-name } உள்நுழைக
fxaccounts-avatar-button =
    .title = கணக்கை நிர்வகி

## The ⋯ menu that is in the top corner of the page

menu =
    .title = பட்டியைத் திற
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = மற்றொரு உலாவியிலிருந்து இறக்குமதி செய்க…
about-logins-menu-menuitem-export-logins = உள்நுழைவுகளை ஏற்றுமதிச்செய் …
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] விருப்பங்கள்
       *[other] முன்னுரிமைகள்
    }
about-logins-menu-menuitem-help = உதவி
menu-menuitem-android-app = ஆண்ட்ராய்டிற்கான { -lockwise-brand-short-name }
menu-menuitem-iphone-app = ஐபோன் மற்றம் ஐபேட்டுக்கான { -lockwise-brand-short-name }

## Login List

login-list =
    .aria-label = தேடல் வினவலுடன் பொருந்தக்கூடிய உள்நுழைவுகள்
login-list-count =
    { $count ->
        [one] { $count } நுழைவு
       *[other] { $count } நுழைவுகள்
    }
login-list-sort-label-text = வரிசைப்படுத்து:
login-list-name-option = பெயர் (அ-ஃ)
login-list-name-reverse-option = பெயர் (ஃ-அ)
about-logins-login-list-alerts-option = விழிப்பூட்டல்
login-list-last-changed-option = கடைசியாக மாற்ற‌ப்பட்டது:
login-list-last-used-option = இறுதியாக பயன்படுத்தியது
login-list-intro-title = உள்நுழைவுகள் ஏதுமில்லை
login-list-intro-description = கடவுச்சொல்லை { -brand-product-name } என்பதில் சேமிக்கும் பொருட்டு, இங்கே காட்டும்
about-logins-login-list-empty-search-title = உள்நுழைவுகள் ஏதுமில்லை
about-logins-login-list-empty-search-description = உங்கள் தேடலுடன் பொருந்தக்கூடிய முடிவுகள் எதுவும் இல்லை.
login-list-item-title-new-login = புதிய உள்நுழைவு
login-list-item-subtitle-new-login = உங்கள் உள்நுழைவு சான்றுகளை உள்ளிடவும்
login-list-item-subtitle-missing-username = (பயனர் பெயர் இல்லை)

## Introduction screen

login-intro-heading = உங்கள் சேமித்த உள்நுழைவுகளைத் தேடுகிறீர்களா? { -sync-brand-short-name } அமை

about-logins-login-intro-heading-logged-in = ஒத்திசைக்கப்பட்ட உள்நுழைவுகள் எதுமில்லை.

## Login

login-item-new-login-title = புதிய உள்நுழைவை உருவாக்கவும்
login-item-edit-button = தொகு
about-logins-login-item-remove-button = நீக்கு
login-item-origin-label = வலைத்தள முகவரி
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = பயனர்பெயர்
about-logins-login-item-username =
    .placeholder = (பயனர் பெயர் இல்லை)
login-item-copy-username-button-text = நகலெடு
login-item-copied-username-button-text = நகலெடுக்கப்பட்டது!
login-item-password-label = கடவுச்சொல்
login-item-copy-password-button-text = நகலெடு
login-item-copied-password-button-text = நகலெடுக்கப்பட்டது
login-item-save-changes-button = மாற்றங்களைச் சேமி
login-item-save-new-button = சேமி
login-item-cancel-button = இரத்து
login-item-time-changed = கடைசி மாற்றம்: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = தோற்றம்: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = கடைசியாகப் பயனில் இருந்த நேரம்: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog


## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.


## Master Password notification

master-password-notification-message = சேமித்த உள்நுழைவுகளையும் கடவுச்சொற்களையும் காண உங்களின் முதன்மை கடவுச்சொல்லை உள்ளிடவும்

## Primary Password notification

master-password-reload-button =
    .label = உள் நுழை
    .accesskey = L

## Password Sync notification

enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name } தேர்வுகளைப் பார்
           *[other] { -sync-brand-short-name } விருப்பங்களைப் பார்
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = மீண்டும் கேட்காதே
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = இரத்து
confirmation-dialog-dismiss-button =
    .title = இரத்து

about-logins-confirm-remove-dialog-title = இந்த உள்நுழைவை நீக்கவா?
confirm-delete-dialog-message = இச்செயலை மீட்க முடியாது.
about-logins-confirm-remove-dialog-confirm-button = நீக்கு

about-logins-confirm-export-dialog-title = உள்நுழைவுகளையும் கடவுச்சொற்களையும் ஏற்றுமதி செய்
about-logins-confirm-export-dialog-confirm-button = ஏற்றுமதி...

confirm-discard-changes-dialog-title = சேமிக்காத மாற்றங்களை நிராகரிக்கவா?
confirm-discard-changes-dialog-message = சேமிக்கப்படாத அனைத்து மாற்றங்களும் இழக்கப்படும்.
confirm-discard-changes-dialog-confirm-button = நிராகரி

## Breach Alert notification

about-logins-breach-alert-title = வலைத்தள அத்மீறல்
breach-alert-text = உங்கள் உள்நுழைவு விவரங்களைக் கடைசியாகப் புதுப்பித்ததிலிருந்து இந்த வலைத்தளத்திலிருந்து கடவுச்சொற்கள் கசிந்தன அல்லது திருடப்பட்டன. உங்கள் கணக்கைப் பாதுகாக்க கடவுச்சொல்லை மாற்றவும்.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname } தளத்திற்குச் செல்க
about-logins-breach-alert-learn-more-link = மேலும் அறிக

## Vulnerable Password notification

about-logins-vulnerable-alert-title = பாதிப்பிற்குள்ளாகும் கடவுச்சொல்
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = { $hostname } தளத்திற்குச் செல்க
about-logins-vulnerable-alert-learn-more-link = மேலும் அறிக

## Error Messages


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = உள்நுழைவுகளுள்ள கோப்பை ஏற்றுமதிச் செய்
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = உ்ள்நுழைவுகள்.csv
about-logins-export-file-picker-export-button = ஏற்றுமதி
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV ஆவணம்
       *[other] CSV கோப்பு
    }

## Login Import Dialog

