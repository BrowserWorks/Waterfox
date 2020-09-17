# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Oanmeldingen en wachtwurden

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Nim jo wachtwurden oeral mei hinne
login-app-promo-subtitle = Download de fergeze { -lockwise-brand-name }-app
login-app-promo-android =
    .alt = Downloade op Google Play
login-app-promo-apple =
    .alt = Downloade yn de App Store

login-filter =
    .placeholder = Oanmeldingen sykje

create-login-button = Nij oanmelding meitsje

fxaccounts-sign-in-text = Bring jo wachtwurden nei jo oare apparaten
fxaccounts-sign-in-button = Meld jo oan by { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Account beheare

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Iepenje menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Ymportearje fan in oare browser út…
about-logins-menu-menuitem-import-from-a-file = Ut in bestân ymportearje…
about-logins-menu-menuitem-export-logins = Oanmeldingen eksportearje…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opsjes
       *[other] Foarkarren
    }
about-logins-menu-menuitem-help = Help
menu-menuitem-android-app = { -lockwise-brand-short-name } foar Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } foar iPhone en iPad

## Login List

login-list =
    .aria-label = Oanmeldingen dy't oerienkomme mei de sykterm
login-list-count =
    { $count ->
        [one] { $count } oanmelding
       *[other] { $count } oanmeldingen
    }
login-list-sort-label-text = Sortearje op:
login-list-name-option = Namme (A-Z)
login-list-name-reverse-option = Namme (Z-A)
about-logins-login-list-alerts-option = Warskôgingen
login-list-last-changed-option = Lêst wizige
login-list-last-used-option = Lêst brûkt
login-list-intro-title = Gjin oanmeldingen fûn
login-list-intro-description = Wannear jo in wachtwurd bewarje yn { -brand-product-name }, wurdt dit hjir werjûn.
about-logins-login-list-empty-search-title = Gjin oanmeldingen fûn
about-logins-login-list-empty-search-description = Jo sykopdracht hat gjin resultaten oplevere.
login-list-item-title-new-login = Nije oanmelding
login-list-item-subtitle-new-login = Fier jo oanmeldgegevens yn
login-list-item-subtitle-missing-username = (gjin brûkersnamme)
about-logins-list-item-breach-icon =
    .title = Troffen website
about-logins-list-item-vulnerable-password-icon =
    .title = Kwetsber wachtwurd

## Introduction screen

login-intro-heading = Sykje jo bewarre oanmeldingen? Stel { -sync-brand-short-name } yn.

about-logins-login-intro-heading-logged-out = Op syk nei jo bewarre oanmeldingen? Stel { -sync-brand-short-name } yn of ymportearje se.
about-logins-login-intro-heading-logged-in = Gjin syngronisearre oanmeldingen fûn.
login-intro-description = As jo jo oanmeldgegevens by { -brand-product-name } op in oar apparaat bewarre hawwe, kinne jo se sa ophelje:
login-intro-instruction-fxa = Meitsje op it apparaat wêrop jo oanmeldgegevens stean in { -fxaccount-brand-name } of meld jo oan
login-intro-instruction-fxa-settings = Soargje derfoar dat jo it fjild Oanmeldingen yn de ynstellingen fan { -sync-brand-short-name } oanfinkt hawwe
about-logins-intro-instruction-help = Besykje <a data-l10n-name="help-link">Stipe foar { -lockwise-brand-short-name }</a> foar mear help
about-logins-intro-import = As jo oanmeldingen yn in oare browser bewarre wurde, kinne jo <a data-l10n-name="import-link">se ymportearje yn { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = As jo oanmeldingen bûten { -brand-product-name } bewarre binne, dan kinne jo se ymportearje <a data-l10n-name="import-browser-link">fan in oare browser út</a> of <a data-l10n-name = "import-file-link">fan in bestân út</a>

## Login

login-item-new-login-title = Nij oanmelding meitsje
login-item-edit-button = Bewurkje
about-logins-login-item-remove-button = Fuortsmite
login-item-origin-label = Websiteadres
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Brûkersnamme
about-logins-login-item-username =
    .placeholder = (gjin brûkersnamme)
login-item-copy-username-button-text = Kopiearje
login-item-copied-username-button-text = Kopiearre!
login-item-password-label = Wachtwurd
login-item-password-reveal-checkbox =
    .aria-label = Wachtwurd toane
login-item-copy-password-button-text = Kopiearje
login-item-copied-password-button-text = Kopiearre!
login-item-save-changes-button = Wizigingen bewarje
login-item-save-new-button = Bewarje
login-item-cancel-button = Annulearje
login-item-time-changed = Lêst wizige: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Oanmakke: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Lêst brûkt: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Fier jo oanmeldgegevens foar Windows yn om jo oanmelding te bewurkjen. Hjirtroch wurdt de befeiliging fan jo accounts beskerme.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = bewurkje de bewarre oanmelding

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Fier jo oanmeldgegevens foar Windows yn om jo wachtwurd te besjen. Hjirtroch wurdt de befeiliging fan jo accounts beskerme.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = toan it bewarre wachtwurd

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Fier jo oanmeldgegevens foar Windows yn om jo wachtwurd te kopiearjen. Hjirtroch wurdt de befeiliging fan jo accounts beskerme.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = kopiearje it bewarre wachtwurd

## Master Password notification

master-password-notification-message = Fier jo haadwachtwurd yn om bewarre oanmeldingen en wachtwurden te besjen

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Fier jo oanmeldgegevens foar Windows yn om jo oanmelding te eksportearjen. Hjirtroch wurdt de befeiliging fan jo accounts beskerme.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = bewarren oanmeldingen en wachtwurden te eksportearjen

## Primary Password notification

about-logins-primary-password-notification-message = Fier jo haadwachtwurd yn om bewarre oanmeldingen en wachtwurden te besjen
master-password-reload-button =
    .label = Oanmelde
    .accesskey = O

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Wolle jo jo oanmeldingen oeral wêr't jo { -brand-product-name } brûke? Gean nei de opsjes fan { -sync-brand-short-name } en finkje it fjild Oanmeldingen oan.
       *[other] Wolle jo jo oanmeldingen oeral wêr't jo { -brand-product-name } brûke? Gean nei de foarkarren fan { -sync-brand-short-name } en finkje it fjild Oanmeldingen oan.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name }-opsjes besjen
           *[other] { -sync-brand-short-name }-foarkarren besjen
        }
    .accesskey = b
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Dit net mear freegje
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = Annulearje
confirmation-dialog-dismiss-button =
    .title = Annulearje

about-logins-confirm-remove-dialog-title = Dizze oanmelding fuortsmite?
confirm-delete-dialog-message = Dizze aksje kin net ûngedien makke wurde.
about-logins-confirm-remove-dialog-confirm-button = Fuortsmite

about-logins-confirm-export-dialog-title = Oanmeldingen en wachtwurden eksportearje
about-logins-confirm-export-dialog-message = Jo wachtwurden wurde bewarre as lêsbere tekst (bygelyks BadP@ssw0rd), dus elkenien dy't it eksportearre bestân iepenje kin, kin se besjen.
about-logins-confirm-export-dialog-confirm-button = Eksportearje…

confirm-discard-changes-dialog-title = Dizze wizigingen ferwerpe?
confirm-discard-changes-dialog-message = Alle net-bewarre wizigingen gean ferlern.
confirm-discard-changes-dialog-confirm-button = Ferwerpe

## Breach Alert notification

about-logins-breach-alert-title = Websitedatalek
breach-alert-text = Wachtwurden út dizze website binne lekt of stellen sûnt jo foar it lêst jo oanmeldgegevens bywurke hawwe. Wizigje jo wachtwurd om jo account te beskermjen.
about-logins-breach-alert-date = Dit lek is bard op { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Nei { $hostname }
about-logins-breach-alert-learn-more-link = Mear ynfo

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Kwetsber wachtwurd
about-logins-vulnerable-alert-text2 = Dit wachtwurd is brûkt op in oare account, dy't wierskynlik troch in datalek troffen is. It opnij brûken fan oanmeldgegevens bringt al jo accounts yn gefaar. Wizigje dit wachtwurd.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Nei { $hostname }
about-logins-vulnerable-alert-learn-more-link = Mear ynfo

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Der bestiet al in fermelding foar { $loginTitle } mei dy brûkersnamme. <a data-l10n-name="duplicate-link">Nei besteande fermelding gean?</a>

# This is a generic error message.
about-logins-error-message-default = Der is in flater bard wylst it bewarjen fan dit wachtwurd.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Bestân mei oanmeldingen eksportearje
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Eksportearje
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokumint
       *[other] CSV-bestân
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Bestân mei oanmeldingen ymportearje
about-logins-import-file-picker-import-button = Ymportearje
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokumint
       *[other] CSV-bestân
    }
