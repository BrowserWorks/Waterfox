# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Kasutajatunnused ja paroolid

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Võta oma paroolid kõikjale kaasa
login-app-promo-subtitle = Hangi tasuta äpp { -lockwise-brand-name }
login-app-promo-android =
    .alt = Hangi see Google Play poest
login-app-promo-apple =
    .alt = Laadi alla App Store'ist

login-filter =
    .placeholder = Otsi kasutajakontosid

create-login-button = Loo uus kasutajakonto

fxaccounts-sign-in-text = Tee paroolid kättesaadavaks ka oma teistes seadmetes
fxaccounts-sign-in-button = Logi { -sync-brand-short-name }i sisse
fxaccounts-avatar-button =
    .title = Halda kontot

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Ava menüü
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Sätted
       *[other] Eelistused
    }
about-logins-menu-menuitem-help = Abi
menu-menuitem-android-app = { -lockwise-brand-short-name } Androidile
menu-menuitem-iphone-app = { -lockwise-brand-short-name } iPhone'ile ja iPadile

## Login List

login-list =
    .aria-label = Otsingule vastavad kasutajakontod
login-list-count =
    { $count ->
        [one] üks konto
       *[other] { $count } kontot
    }
login-list-sort-label-text = Sortimine:
login-list-name-option = nimi  (A-Y)
login-list-last-changed-option = viimati muudetud
login-list-last-used-option = viimati kasutatud
login-list-intro-title = Kasutajakontosid ei leitud
login-list-intro-description = { -brand-product-name }is parooli salvestamisel ilmub see siin nähtavale.
about-logins-login-list-empty-search-title = Kasutajakontosid ei leitud
about-logins-login-list-empty-search-description = Otsingule ei leitud vasteid.
login-list-item-title-new-login = Uus kasutajakonto
login-list-item-subtitle-new-login = Sisesta oma kasutajatunnused
login-list-item-subtitle-missing-username = (kasutajanime pole)
about-logins-list-item-breach-icon =
    .title = Kasutajatunnused lekitanud sait

## Introduction screen

login-intro-heading = Otsid oma salvestatud kasutajakontosid? Seadista { -sync-brand-short-name }.

login-intro-description = Kui salvestasid oma kasutajakontod teises seadmes olevasse { -brand-product-name }i, siis nii saad need ka siia:
login-intro-instruction-fxa = Loo { -fxaccount-brand-name } või logi sisse seadmes, kus salvestatud kasutajakontod on
login-intro-instruction-fxa-settings = Veendu, et { -sync-brand-short-name }i sätetes oleks Kasutajakontod ees linnuke
about-logins-intro-instruction-help = Rohkema teabe saamiseks külasta <a data-l10n-name="help-link">{ -lockwise-brand-short-name }'i tugikeskkonda</a>

## Login

login-item-new-login-title = Uue kasutajakonto loomine
login-item-edit-button = Muuda
login-item-origin-label = Saidi aadress
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Kasutajanimi
about-logins-login-item-username =
    .placeholder = (kasutajanime pole)
login-item-copy-username-button-text = Kopeeri
login-item-copied-username-button-text = Kopeeritud!
login-item-password-label = Parool
login-item-copy-password-button-text = Kopeeri
login-item-copied-password-button-text = Kopeeritud!
login-item-save-changes-button = Salvesta muudatused
login-item-save-new-button = Salvesta
login-item-cancel-button = Loobu
login-item-time-changed = Viimati muudatud: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Loodud: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Viimati kasutatud: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

## Master Password notification

master-password-notification-message = Salvestatud kasutajatunnuste ja paroolide nägemiseks sisesta ülemparool

## Primary Password notification

master-password-reload-button =
    .label = Logi sisse
    .accesskey = L

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Soovid salvestatud kasutajakontosid kasutada kõikjal, kus kasutad { -brand-product-name }i? Mine { -sync-brand-short-name }i sätetesse ja märgi ära Kasutajakontod.
       *[other] Soovid salvestatud kasutajakontosid kasutada kõikjal, kus kasutad { -brand-product-name }i? Mine { -sync-brand-short-name }i eelistustesse ja märgi ära Kasutajakontod.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Vaata { -sync-brand-short-name }i sätteid
           *[other] Vaata { -sync-brand-short-name }i eelistusi
        }
    .accesskey = V

## Dialogs

confirmation-dialog-cancel-button = Loobu
confirmation-dialog-dismiss-button =
    .title = Loobu

confirm-delete-dialog-message = Seda tegevust pole võimalik tagasi võtta.

confirm-discard-changes-dialog-title = Kas soovid loobuda salvestamata muudatustest?
confirm-discard-changes-dialog-message = Kõik salvestamata muudatused lähevad kaduma.
confirm-discard-changes-dialog-confirm-button = Unusta

## Breach Alert notification

breach-alert-text = Sellelt saidilt lekitati või varastati kasutajatunnused pärast seda, kui sa viimati enda omi uuendasid. Oma konto kaitsmiseks muuda selle parool.

## Vulnerable Password notification

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Selle kasutajanimega kanne { $loginTitle } on juba olemas. <a data-l10n-name="duplicate-link">Kas soovid minna olemasoleva kande juurde?</a>

# This is a generic error message.
about-logins-error-message-default = Parooli salvestamisel esines viga.


## Login Export Dialog

## Login Import Dialog

