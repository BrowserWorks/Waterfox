# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Infurmaziuns d'annunzia & pleds-clav

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Prenda tes pleds-clav adina cun tai
login-app-promo-subtitle = Va per l'app gratuita da { -lockwise-brand-name }
login-app-promo-android =
    .alt = Telechargiar da Google Play
login-app-promo-apple =
    .alt = Telechargiar da l'App Store

login-filter =
    .placeholder = Tschertgar datas d'annunzia

create-login-button = Crear datas d'annunzia

fxaccounts-sign-in-text = Acceda a tes pleds-clav cun tut tes apparats
fxaccounts-sign-in-button = Connectar cun { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Administrar il conto

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Avrir il menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importar dad in auter navigatur…
about-logins-menu-menuitem-import-from-a-file = Importar dad ina datoteca…
about-logins-menu-menuitem-export-logins = Exportar infurmaziuns d'annunzia…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Preferenzas
       *[other] Preferenzas
    }
about-logins-menu-menuitem-help = Agid
menu-menuitem-android-app = { -lockwise-brand-short-name } per Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } per iPhone ed iPad

## Login List

login-list =
    .aria-label = Infurmaziuns d'annunzia tenor la tschertga
login-list-count =
    { $count ->
        [one] { $count } infurmaziun d'annunzia
       *[other] { $count } infurmaziuns d'annunzia
    }
login-list-sort-label-text = Zavrar tenor:
login-list-name-option = Num (A-Z)
login-list-name-reverse-option = Num (Z-A)
about-logins-login-list-alerts-option = Avertiments
login-list-last-changed-option = Ultima midada
login-list-last-used-option = Ultima utilisaziun
login-list-intro-title = Chattà naginas infurmaziuns d'annunzia
login-list-intro-description = Pleds-clav memorisads en { -brand-product-name } cumparan qua.
about-logins-login-list-empty-search-title = Chattà naginas infurmaziuns d'annunzia
about-logins-login-list-empty-search-description = I na dat nagins resultats che correspundan a tia tschertga.
login-list-item-title-new-login = Nova infurmaziun d'annunzia
login-list-item-subtitle-new-login = Endatescha tias infurmaziuns d'annunzia
login-list-item-subtitle-missing-username = (nagin num d'utilisader)
about-logins-list-item-breach-icon =
    .title = Website che ha pers datas
about-logins-list-item-vulnerable-password-icon =
    .title = Pled-clav periclità

## Introduction screen

login-intro-heading = Tschertgas ti tias infurmaziuns d'annunzia memorisadas? Configurescha { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Tschertgas ti tias infurmaziuns d'annunzia memorisadas? Configurescha { -sync-brand-short-name } u las importescha.
about-logins-login-intro-heading-logged-in = Chattà naginas infurmaziuns d'annunzia sincronisadas.
login-intro-description = Sche ti has memorisà tias infurmaziuns d'annunzia en { -brand-product-name } sin in auter apparat, vegns ti a savair qua co acceder ad ellas:
login-intro-instruction-fxa = Acceda al u creescha in { -fxaccount-brand-name } cun l'apparat nua che las infurmaziuns d'annunzia èn memorisadas
login-intro-instruction-fxa-settings = Controllescha che la chaschetta da controlla «Infurmaziuns d'annunzia» saja activada en las preferenzas da { -sync-brand-short-name }
about-logins-intro-instruction-help = Per agid, visitar <a data-l10n-name="help-link">il support da { -lockwise-brand-short-name }</a>
about-logins-intro-import = En cas che las infurmaziuns d'annunzia èn memorisadas en in auter navigatur èsi pussaivel da las <a data-l10n-name="import-link">importar en { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Sche tias infurmaziuns d'annunzia èn memorisadas ordaifer { -brand-product-name }, pos ti <a data-l10n-name="import-browser-link">las importar dad in auter navigatur</a> u <a data-l10n-name="import-file-link">dad ina datoteca</a>

## Login

login-item-new-login-title = Creescha ina nova infurmaziun d'annunzia
login-item-edit-button = Modifitgar
about-logins-login-item-remove-button = Allontanar
login-item-origin-label = Adressa da la website
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Num d'utilisader
about-logins-login-item-username =
    .placeholder = (nagin num d'utilisader)
login-item-copy-username-button-text = Copiar
login-item-copied-username-button-text = Copià!
login-item-password-label = Pled-clav
login-item-password-reveal-checkbox =
    .aria-label = Mussar il pled-clav
login-item-copy-password-button-text = Copiar
login-item-copied-password-button-text = Copià!
login-item-save-changes-button = Memorisar las midadas
login-item-save-new-button = Memorisar
login-item-cancel-button = Interrumper
login-item-time-changed = Ultima midada: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Creà: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Ultima utilisaziun: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Per modifitgar tia infurmaziun d'annunzia, endatescha tias datas d'annunzia per Windows. Quai gida a garantir la segirezza da tes contos.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = modifitgar l'infurmaziun d'annunzia memorisada

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Per mussar tes pled-clav, endatescha tias datas d'annunzia per Windows. Quai gida a garantir la segirezza da tes contos.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = mussar il pled-clav memorisà

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Per copiar tes pled-clav, endatescha tias datas d'annunzia per Windows. Quai gida a garantir la segirezza da tes contos.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiar il pled-clav memorisà

## Master Password notification

master-password-notification-message = Per plaschair endatar tes pled-clav universal per vesair las infurmaziuns d'annunzia memorisadas & ils pleds-clav

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Per exportar tias infurmaziuns d'annunzia, endatescha tias datas d'annunzia per Windows. Quai gida a garantir la segirezza da tes contos.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportar las infurmaziuns d'annunzia memorisadas ed ils pleds-clav

## Primary Password notification

about-logins-primary-password-notification-message = Per plaschair endatar tes pled-clav universal per vesair las infurmaziuns d'annunzia memorisadas & ils pleds-clav
master-password-reload-button =
    .label = Annunzia
    .accesskey = A

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Vuls ti avair a disposiziun tias infurmaziuns d'annunzia dapertut là nua che ti utiliseschas { -brand-product-name }? Acceda a las preferenzas da { -sync-brand-short-name } e tscherna la chaschetta da controlla «Infurmaziuns d'annunzia».
       *[other] Vuls ti avair a disposiziun tias infurmaziuns d'annunzia dapertut là nua che ti utiliseschas { -brand-product-name }? Acceda a las preferenzas da { -sync-brand-short-name } e tscherna la chaschetta da controlla «Infurmaziuns d'annunzia».
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Avrir las preferenzas da { -sync-brand-short-name }
           *[other] Avrir las preferenzas da { -sync-brand-short-name }
        }
    .accesskey = A
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Betg pli dumandar
    .accesskey = B

## Dialogs

confirmation-dialog-cancel-button = Interrumper
confirmation-dialog-dismiss-button =
    .title = Interrumper

about-logins-confirm-remove-dialog-title = Allontanar questas infurmaziuns d'annunzia?
confirm-delete-dialog-message = Questa acziun na po betg vegnir revocada.
about-logins-confirm-remove-dialog-confirm-button = Allontanar

about-logins-confirm-export-dialog-title = Exportar infurmaziuns d'annunzia e pleds-clav
about-logins-confirm-export-dialog-message = Tes pleds-clav vegnan memorisads sco text legibel (p.ex. «M@lPledc1av»), uschia che mintgin che po avrir la datoteca exportada als po vesair.
about-logins-confirm-export-dialog-confirm-button = Exportar…

confirm-discard-changes-dialog-title = Ignorar las modificaziuns betg memorisadas?
confirm-discard-changes-dialog-message = Tut las modificaziuns betg memorisadas van a perder.
confirm-discard-changes-dialog-confirm-button = Ignorar

## Breach Alert notification

about-logins-breach-alert-title = Website ha pers datas
breach-alert-text = Ils pleds-clav da questa website èn stads visibels publicamain u èn vegnids engulads dapi l'ultima actualisaziun da las infurmaziuns d'annunzia. Mida tes pled-clav per proteger tes conto.
about-logins-breach-alert-date = Questa perdita da datas è capitada ils { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Acceder a { $hostname }
about-logins-breach-alert-learn-more-link = Ulteriuras infurmaziuns

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Pled-clav periclità
about-logins-vulnerable-alert-text2 = Quest pled-clav è vegnì utilisà per in auter conto pertutgà dad ina sperdita da datas. La reutilisaziun da pleds-clav periclitescha tut tes contos. Mida quest pled-clav.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Acceder { $hostname }
about-logins-vulnerable-alert-learn-more-link = Ulteriuras infurmaziuns

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Igl exista gia ina endataziun per { $loginTitle } cun quest num d'utilisader. <a data-l10n-name="duplicate-link">Ir a l'endataziun existenta?</a>

# This is a generic error message.
about-logins-error-message-default = Ina errur è succedida durant l'emprova da memorisar quest pled-clav.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportar la datoteca da las infurmaziuns d'annunzia
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = datas-annunzia.csv
about-logins-export-file-picker-export-button = Exportar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Document CSV
       *[other] Datoteca CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importar ina datoteca cun infurmaziuns d'annunzia
about-logins-import-file-picker-import-button = Importar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Document CSV
       *[other] Datoteca CSV
    }
