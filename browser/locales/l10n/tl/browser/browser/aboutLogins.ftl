# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Mga Login at Password

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Dalhin kahit saan ang mga password mo
login-app-promo-subtitle = Kunin ang libreng { -lockwise-brand-name } app
login-app-promo-android =
    .alt = Kunin sa Google Play
login-app-promo-apple =
    .alt = I-download sa App Store
login-filter =
    .placeholder = Hanapin sa mga Login
create-login-button = Gumawa ng panibagong Login
fxaccounts-sign-in-text = Kuhanin ang iyong mga password sa iba mong mga device
fxaccounts-sign-in-button = Mag-sign in sa { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = I-manage ang account

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Buksan ang menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Mag-import mula sa Ibang Browser…
about-logins-menu-menuitem-import-from-a-file = Kunin mula sa File…
about-logins-menu-menuitem-export-logins = i-Export ang mga Login…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Mga Kagustuhan
       *[other] Mga Kagustuhan
    }
about-logins-menu-menuitem-help = Tulong
menu-menuitem-android-app = { -lockwise-brand-short-name } para sa Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } para sa iPhone at iPad

## Login List

login-list =
    .aria-label = Mga login na tumutugma sa hinahanap
login-list-count =
    { $count ->
        [one] { $count } login
       *[other] { $count } login
    }
login-list-sort-label-text = Pagsunud-sunurin ayon sa:
login-list-name-option = Pangalan (A-Z)
login-list-name-reverse-option = Pangalan (Z-A)
about-logins-login-list-alerts-option = Mga Alerto
login-list-last-changed-option = Huling Binago
login-list-last-used-option = Huling Ginamit
login-list-intro-title = Walang natagpuang mga login
login-list-intro-description = Kapag nagse-save ka ng isang password sa { -brand-product-name }, lalabas iyon dito.
about-logins-login-list-empty-search-title = Walang natagpuang mga login
about-logins-login-list-empty-search-description = Walang resultang tumugma sa iyong hinahanap.
login-list-item-title-new-login = Bagong Login
login-list-item-subtitle-new-login = Ipasok ang iyong mga login credential
login-list-item-subtitle-missing-username = (walang username)
about-logins-list-item-breach-icon =
    .title = Breached website
about-logins-list-item-vulnerable-password-icon =
    .title = Vulnerable password

## Introduction screen

login-intro-heading = Hinahanap mo ba ang iyong naka-save na mga login? I-set up ang { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = Hinahanap mo ang iyong mga naka-save na login? I-setup ang { -sync-brand-short-name } o i-import ang mga ito.
about-logins-login-intro-heading-logged-in = Walang natagpuang naka-sync na mga login.
login-intro-description = Kung nag-save ka ng mga login mo sa { -brand-product-name } sa ibang device, ganito ang dapat gawin para makuha mo sila rito:
login-intro-instruction-fxa = Gumawa ng o mag-sign in sa iyong { -fxaccount-brand-name } sa device kung saan naka-save ang mga login mo
login-intro-instruction-fxa-settings = Siguruhin na napili mo ang checkbox na Mga Login sa Mga { -sync-brand-short-name } Setting
about-logins-intro-instruction-help = Bisitahin ang <a data-l10n-name="help-link">{ -lockwise-brand-short-name } Support</a> para sa karagdagang tulong
about-logins-intro-import = Kung ang iyong mga login ay naka-save sa ibang browser, maaari mong <a data-l10n-name="import-link"> ilipat ang mga ito sa { -lockwise-brand-short-name } </a>
about-logins-intro-import2 = Kung naka-save ang mga login mo sa labas ng { -brand-product-name }, maaari mo <a data-l10n-name="import-browser-link">i-import ang mga ito mula sa ibang browser</a> o <a data-l10n-name="import-file-link">mula sa isang file</a>

## Login

login-item-new-login-title = Gumawa ng Panibagong Login
login-item-edit-button = Baguhin
about-logins-login-item-remove-button = Tanggalin
login-item-origin-label = Website Address
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Username
about-logins-login-item-username =
    .placeholder = (walang username)
login-item-copy-username-button-text = Kopyahin
login-item-copied-username-button-text = Nakopya na!
login-item-password-label = Password
login-item-password-reveal-checkbox =
    .aria-label = Ipakita ang password
login-item-copy-password-button-text = Kopyahin
login-item-copied-password-button-text = Nakopya na!
login-item-save-changes-button = I-Save ang mga Pagbabago
login-item-save-new-button = I-Save
login-item-cancel-button = Ikansela
login-item-time-changed = Huling binago: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Ginawa: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Huling ginamit: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Para mabago ang iyong login, ipasok ang iyong mga Windows login credential. Nakatutulong ito protektahan ang seguridad ng iyong mga account.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = i-edit ang naka-save na login
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Para makita ang iyong password, ipasok ang iyong mga Windows login credential. Nakatutulong ito protektahan ang seguridad ng iyong mga account.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = ipakita ang naka-save na password
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Para makopya ang iyong password, ipasok ang iyong mga Windows login credential. Nakatutulong ito protektahan ang seguridad ng iyong mga account.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = kopyahin ang naka-save na password

## Master Password notification

master-password-notification-message = Pakipasok ang iyong master password para makita ang mga naka-save na login at password
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Para ma-export ang iyong mga login, ipasok ang iyong mga Windows login credential. Nakatutulong ito protektahan ang seguridad ng iyong mga account.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = mag-export ng mga naka-save na login at password

## Primary Password notification

about-logins-primary-password-notification-message = Pakilagay ang iyong Primary Password para makita ang naka-save na mga login at password
master-password-reload-button =
    .label = Mag-log in
    .accesskey = L

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Gusto mo bang magamit ang mga login mo kahit saan mo dalhin ang { -brand-product-name }? Puntahan ang iyong mga Pagpipilian sa { -sync-brand-short-name } at piliin ang Mga Login na checkbox.
       *[other] Gusto mo bang magamit ang mga login mo kahit saan mo dalhin ang { -brand-product-name }? Puntahan ang iyong mga Kagustuhan sa { -sync-brand-short-name } at piliin ang Mga Login na checkbox.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Tingnan ang mga kagustuhan para sa { -sync-brand-short-name }
           *[other] Tingnan ang mga kagustuhan para sa { -sync-brand-short-name }
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Huwag nang muling itanong
    .accesskey = H

## Dialogs

confirmation-dialog-cancel-button = Kanselahin
confirmation-dialog-dismiss-button =
    .title = Kanselahin
about-logins-confirm-remove-dialog-title = Alisin ang login?
confirm-delete-dialog-message = Itong action ay hindi na mababawi.
about-logins-confirm-remove-dialog-confirm-button = Tanggalin
about-logins-confirm-export-dialog-title = Mag-export ng mga login at password
about-logins-confirm-export-dialog-message = Mase-save ang mga password mo bilang readable text (hal., PangitNaP@ssw0rd) kaya pwede itong makita ng kahit sinong makakapagbukas ng na-export na file.
about-logins-confirm-export-dialog-confirm-button = i-Export…
confirm-discard-changes-dialog-title = Itapon ang mga hindi nai-save na pagbabago?
confirm-discard-changes-dialog-message = Lahat ng hindi nai-save na mga pagbabago ay mawawala.
confirm-discard-changes-dialog-confirm-button = Balewalain

## Breach Alert notification

about-logins-breach-alert-title = Website Breach
breach-alert-text = May mga password na nabunyag o ninakaw sa website na ito mula noong huli mong na-update ang iyong mga login detail. Baguhin mo ang password mo para maprotektahan ang iyong account.
about-logins-breach-alert-date = Naganap ang breach na ito noong { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Pumunta sa { $hostname }
about-logins-breach-alert-learn-more-link = Alamin

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Vulnerable Password
about-logins-vulnerable-alert-text2 = Ang password na ito ay nagamit na sa ibang account na malamang ay nasangkot na sa isang data breach. Malalagay sa panganib ang mga account mo kapag ginamit muli ang mga credential. Baguhin ang password na ito.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Pumunta sa { $hostname }
about-logins-vulnerable-alert-learn-more-link = Alamin

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = May entry na sa { $loginTitle } na may ganyang username. <a data-l10n-name="duplicate-link">Puntahan ang entry na ito?</a>
# This is a generic error message.
about-logins-error-message-default = Nagkaroon ng problema habang sine-save ang password na ito.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = I-export ang Login File
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = i-Export
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV Document
       *[other] CSV File
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Kunin ang Logins File
about-logins-import-file-picker-import-button = i-Import
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV Document
       *[other] CSV File
    }
