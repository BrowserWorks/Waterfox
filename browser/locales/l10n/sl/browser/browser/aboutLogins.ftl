# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Prijave in gesla

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Vzemite gesla s seboj
login-app-promo-subtitle = Prenesite brezplačno aplikacijo { -lockwise-brand-name }
login-app-promo-android =
    .alt = Prenesite ga z Google Play
login-app-promo-apple =
    .alt = Prenesite ga z App Stora

login-filter =
    .placeholder = Iskanje prijav

create-login-button = Ustvari novo prijavo

fxaccounts-sign-in-text = Imejte dostop do gesel z vseh svojih naprav
fxaccounts-sign-in-button = Prijava v { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Upravljanje računa

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Odpri meni
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Uvozi iz drugega brskalnika …
about-logins-menu-menuitem-import-from-a-file = Uvozi iz datoteke …
about-logins-menu-menuitem-export-logins = Izvozi prijave …
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Možnosti
       *[other] Nastavitve
    }
about-logins-menu-menuitem-help = Pomoč
menu-menuitem-android-app = { -lockwise-brand-short-name } za Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } za iPhone in iPad

## Login List

login-list =
    .aria-label = Prijave, ki ustrezajo iskalni poizvedbi
login-list-count =
    { $count ->
        [one] { $count } prijava
        [two] { $count } prijavi
        [few] { $count } prijave
       *[other] { $count } prijav
    }
login-list-sort-label-text = Razvrsti po:
login-list-name-option = Imenu (A–Ž)
login-list-name-reverse-option = Imenu (Ž–A)
about-logins-login-list-alerts-option = Opozorila
login-list-last-changed-option = Času zadnje spremembe
login-list-last-used-option = Času zadnje uporabe
login-list-intro-title = Ni prijav
login-list-intro-description = Ko geslo shranite v { -brand-product-name }, se bo prikazalo tukaj.
about-logins-login-list-empty-search-title = Ni prijav
about-logins-login-list-empty-search-description = Ni rezultatov, ki bi ustrezali vašemu iskanju.
login-list-item-title-new-login = Nova prijava
login-list-item-subtitle-new-login = Vnesite podatke za prijavo
login-list-item-subtitle-missing-username = (ni uporabniškega imena)
about-logins-list-item-breach-icon =
    .title = Ogrožena spletna stran
about-logins-list-item-vulnerable-password-icon =
    .title = Ranljivo geslo

## Introduction screen

login-intro-heading = Iščete shranjene prijave? Nastavite { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Iščete shranjene prijave? Nastavite { -sync-brand-short-name } ali jih uvozite.
about-logins-login-intro-heading-logged-in = Ni najdenih sinhroniziranih prijav.
login-intro-description = Če ste svoje prijave shranili v { -brand-product-name } v drugi napravi, jih lahko prenesete sem, tako da:
login-intro-instruction-fxa = Ustvarite { -fxaccount-brand-name } ali se prijavite na napravi, kjer so shranjene vaše prijave
login-intro-instruction-fxa-settings = Prepričajte se, da ste v Nastavitvah { -sync-brand-short-name }a označili polje Prijave
about-logins-intro-instruction-help = Za dodatno pomoč obiščite <a data-l10n-name="help-link">Podporo { -lockwise-brand-short-name }</a>
about-logins-intro-import = Če so vaše prijave shranjene v drugem brskalniku, jih lahko <a data-l10n-name="import-link">uvozite v { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Če so vaše prijave shranjene izven { -brand-product-name }a, jih lahko <a data-l10n-name="import-browser-link">uvozite iz drugega brskalnika</a> ali <a data-l10n-name="import-file-link">datoteke</a>

## Login

login-item-new-login-title = Ustvari novo prijavo
login-item-edit-button = Uredi
about-logins-login-item-remove-button = Odstrani
login-item-origin-label = Naslov spletnega mesta
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Uporabniško ime
about-logins-login-item-username =
    .placeholder = (brez uporabniškega imena)
login-item-copy-username-button-text = Kopiraj
login-item-copied-username-button-text = Kopirano!
login-item-password-label = Geslo
login-item-password-reveal-checkbox =
    .aria-label = Prikaži geslo
login-item-copy-password-button-text = Kopiraj
login-item-copied-password-button-text = Kopirano!
login-item-save-changes-button = Shrani spremembe
login-item-save-new-button = Shrani
login-item-cancel-button = Prekliči
login-item-time-changed = Zadnja sprememba: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Ustvarjeno: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Nazadnje uporabljeno: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Če želite urediti svojo prijavo, vnesite svoje podatke za prijavo v sistem Windows. To pomaga zaščititi varnost vaših računov.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = edit the saved login

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Če si želite ogledati geslo, vnesite svoje podatke za prijavo v sistem Windows. To pomaga zaščititi varnost vaših računov.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = reveal the saved password

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Če želite kopirati geslo, vnesite svoje podatke za prijavo v sistem Windows. To pomaga zaščititi varnost vaših računov.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copy the saved password

## Master Password notification

master-password-notification-message = Za ogled shranjenih prijav in gesel vnesite svoje glavno geslo

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Pred izvozom prijav vnesite svoje podatke za prijavo v sistem Windows. To pomaga zaščititi varnost vaših računov.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = export saved logins and passwords

## Primary Password notification

about-logins-primary-password-notification-message = Za ogled shranjenih prijav in gesel vnesite svoje glavno geslo
master-password-reload-button =
    .label = Prijava
    .accesskey = P

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Želite imeti svoje prijave povsod, kjer uporabljate { -brand-product-name }? Pojdite na Možnosti { -sync-brand-short-name }a in izberite polje Prijave.
       *[other] Želite imeti svoje prijave povsod, kjer uporabljate { -brand-product-name }? Pojdite na Nastavitve { -sync-brand-short-name }a in izberite polje Prijave.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Obišči možnosti { -sync-brand-short-name }a
           *[other] Obišči nastavitve { -sync-brand-short-name }a
        }
    .accesskey = š
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Ne sprašuj več
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Prekliči
confirmation-dialog-dismiss-button =
    .title = Prekliči

about-logins-confirm-remove-dialog-title = Odstranim to prijavo?
confirm-delete-dialog-message = Tega dejanja ni mogoče razveljaviti.
about-logins-confirm-remove-dialog-confirm-button = Odstrani

about-logins-confirm-export-dialog-title = Izvozite prijave in gesla
about-logins-confirm-export-dialog-message = Vaša gesla bodo shranjena kot berljivo besedilo (npr. Sl@boG3slo), zato bodo vidna vsakomur, ki bo lahko odprl izvoženo datoteko.
about-logins-confirm-export-dialog-confirm-button = Izvozi …

confirm-discard-changes-dialog-title = Zavržem neshranjene spremembe?
confirm-discard-changes-dialog-message = Vse neshranjene spremembe bodo izgubljene.
confirm-discard-changes-dialog-confirm-button = Prezri

## Breach Alert notification

about-logins-breach-alert-title = Kraja podatkov spletne strani
breach-alert-text = Gesla so bila ogrožena ali ukradena s te spletne strani, odkar ste nazadnje posodobili podatke za prijavo. Spremenite geslo, da zaščitite svoj račun.
about-logins-breach-alert-date = Do kraje podatkov je prišlo dne { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Pojdi na { $hostname }
about-logins-breach-alert-learn-more-link = Več o tem

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Ranljivo geslo
about-logins-vulnerable-alert-text2 = To geslo uporablja tudi drug račun, ki je bil verjetno izpostavljen v kraji podatkov. Uporaba enakih poverilnic na več mestih ogroža vse vaše račune. Spremenite to geslo.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Pojdi na { $hostname }
about-logins-vulnerable-alert-learn-more-link = Več o tem

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Vnos za { $loginTitle } s tem uporabniškim imenom že obstaja. <a data-l10n-name="duplicate-link">Odprem obstoječi vnos?</a>

# This is a generic error message.
about-logins-error-message-default = Med poskusom shranjevanja tega gesla se je pojavila napaka.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Izvozi datoteko s prijavami
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = prijave.csv
about-logins-export-file-picker-export-button = Izvozi
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Datoteka CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Uvozi datoteko s prijavami
about-logins-import-file-picker-import-button = Uvozi
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Datoteka CSV
    }
