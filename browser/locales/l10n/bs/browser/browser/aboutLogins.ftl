# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Prijave & lozinke

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Ponesite svoje lozinke svugdje
login-app-promo-subtitle = Preuzmite besplatnu { -lockwise-brand-name } app
login-app-promo-android =
    .alt = Preuzmite na Google Play
login-app-promo-apple =
    .alt = Preuzmite na App Store
login-filter =
    .placeholder = Pretraži prijave
create-login-button = Kreiraj novu prijavu
fxaccounts-sign-in-text = Pristupite lozinkama na drugim uređajima
fxaccounts-sign-in-button = Prijava na { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Upravljanje računom

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Otvori meni
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Uvoz iz drugog browsera…
about-logins-menu-menuitem-import-from-a-file = Uvezi iz fajla…
about-logins-menu-menuitem-export-logins = Izvezi prijave…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opcije
       *[other] Postavke
    }
about-logins-menu-menuitem-help = Pomoć
menu-menuitem-android-app = { -lockwise-brand-short-name } za Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } za iPhone i iPad

## Login List

login-list =
    .aria-label = Prijave koje odgovaraju pretrazi
login-list-sort-label-text = Sortiraj po:
login-list-name-option = Nazivu (A-Z)
login-list-name-reverse-option = Naziv (A-Z)
about-logins-login-list-alerts-option = Upozorenja
login-list-last-changed-option = Zadnja promjena
login-list-last-used-option = Zadnja upotreba
login-list-intro-title = Nema pronađenih prijava
login-list-intro-description = Kada spasite lozinku u { -brand-product-name }, ona će biti prikazana ovdje.
about-logins-login-list-empty-search-title = Nema pronađenih prijava
about-logins-login-list-empty-search-description = Nema odgovarajućih rezultata za vašu pretragu.
login-list-item-title-new-login = Nova prijava
login-list-item-subtitle-new-login = Unesite vaše podatke za prijavu
login-list-item-subtitle-missing-username = (nema korisničkog imena)
about-logins-list-item-vulnerable-password-icon =
    .title = Ranjiva lozinka

## Introduction screen

login-intro-heading = Tražite vaše spašene prijave? Podesite { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-in = Nema pronađenih sinhronizovanih prijava.
login-intro-description = Ako ste spasili prijave u { -brand-product-name } na drugom uređaju, evo kako im možete pristupiti:
login-intro-instruction-fxa = Kreirajte ili se prijavite na vaš { -fxaccount-brand-name } na uređaju na kojem ste spasili prijave

## Login

login-item-new-login-title = Kreiraj novu prijavu
login-item-edit-button = Uredi
about-logins-login-item-remove-button = Ukloni
login-item-origin-label = Adresa web stranice
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Korisničko ime
about-logins-login-item-username =
    .placeholder = (nema korisničkog imena)
login-item-copy-username-button-text = Kopiraj
login-item-copied-username-button-text = Kopirano!
login-item-password-label = Lozinka
login-item-password-reveal-checkbox =
    .aria-label = Prikaži lozinku
login-item-copy-password-button-text = Kopiraj
login-item-copied-password-button-text = Kopirano!
login-item-save-changes-button = Spasi promjene
login-item-save-new-button = Spasi
login-item-cancel-button = Otkaži

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = uredite sačuvanu prijavu
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = prikaži spašenu lozinku
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = kopiraj spašenu lozinku

## Master Password notification

# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = izvezi spašene prijave i lozinke

## Primary Password notification

master-password-reload-button =
    .label = Prijavi
    .accesskey = P

## Password Sync notification

about-logins-enable-password-sync-dont-ask-again-button =
    .label = Ne pitaj me ponovo
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Otkaži
confirmation-dialog-dismiss-button =
    .title = Otkaži
about-logins-confirm-remove-dialog-title = Ukloniti ovu prijavu?
confirm-delete-dialog-message = Ova radnja se ne može poništiti.
about-logins-confirm-remove-dialog-confirm-button = Ukloni
about-logins-confirm-export-dialog-title = Izvezi prijave i lozinke
about-logins-confirm-export-dialog-confirm-button = Izvoz…
confirm-discard-changes-dialog-title = Odbaci nespašene promjene?
confirm-discard-changes-dialog-message = Sve nespašene promjene će biti izgubljene.
confirm-discard-changes-dialog-confirm-button = Odbaci

## Breach Alert notification

# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Posjeti { $hostname }
about-logins-breach-alert-learn-more-link = Saznajte više

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Ranjiva lozinka
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Posjeti { $hostname }
about-logins-vulnerable-alert-learn-more-link = Saznajte više

## Error Messages

# This is a generic error message.
about-logins-error-message-default = Desila se greška prilikom spašavanja ove lozinke.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Izvezi fajl s prijavama
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = prijave.csv
about-logins-export-file-picker-export-button = Izvezi
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV dokument
       *[other] CSV fajl
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Uvezi fajl s prijavama
about-logins-import-file-picker-import-button = Uvezi
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV dokument
       *[other] CSV fajl
    }
