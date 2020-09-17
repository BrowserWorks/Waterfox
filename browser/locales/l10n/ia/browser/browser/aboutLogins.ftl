# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Contos e contrasignos

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Porta tu contrasignos sempre con te
login-app-promo-subtitle = Installa le app gratuite { -lockwise-brand-name }
login-app-promo-android =
    .alt = Discarga lo de Google Play
login-app-promo-apple =
    .alt = Discarga lo de App Store

login-filter =
    .placeholder = Cercar credentiales

create-login-button = Crear nove credentiales

fxaccounts-sign-in-text = Accede a tu credentiales sur tote tu apparatos
fxaccounts-sign-in-button = Aperir session in { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Gerer conto

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Aperir menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importar ab un altere navigator…
about-logins-menu-menuitem-import-from-a-file = Importar ab un file…
about-logins-menu-menuitem-export-logins = Exportar credentiales…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Optiones
       *[other] Preferentias
    }
about-logins-menu-menuitem-help = Adjuta
menu-menuitem-android-app = { -lockwise-brand-short-name } pro Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } pro iPhone e iPad

## Login List

login-list =
    .aria-label = Credentiales resultante del recerca
login-list-count =
    { $count ->
        [one] { $count } conto
       *[other] { $count } contos
    }
login-list-sort-label-text = Ordinar per:
login-list-name-option = Nomine (A-Z)
login-list-name-reverse-option = Nomine (Z-A)
about-logins-login-list-alerts-option = Alertas
login-list-last-changed-option = Ultime modification
login-list-last-used-option = Ultime uso
login-list-intro-title = Nulle credentiales trovate
login-list-intro-description = Le contrasignos salvate in { -brand-product-name } apparera hic.
about-logins-login-list-empty-search-title = Nulle credentiales trovate
about-logins-login-list-empty-search-description = Le recerca non ha producite resultatos.
login-list-item-title-new-login = Nove credentiales
login-list-item-subtitle-new-login = Insere le credentiales de accesso
login-list-item-subtitle-missing-username = (nulle nomine de usator)
about-logins-list-item-breach-icon =
    .title = Sito web violate
about-logins-list-item-vulnerable-password-icon =
    .title = Contrasigno vulnerabile

## Introduction screen

login-intro-heading = Cerca tu le credentiales salvate? Configura { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Cerca tu le credentiales salvate? Configura { -sync-brand-short-name }  o importa los.
about-logins-login-intro-heading-logged-in = Nulle credentiales synchronisate trovate.
login-intro-description = Si tu ha salvate tu credentiales in { -brand-product-name } sur un altere apparato, ecce como render los disponibile hic:
login-intro-instruction-fxa = Crea o identifica te a tu { -fxaccount-brand-name } sur le apparato ubi tu credentiales es salvate
login-intro-instruction-fxa-settings = Assecura te que le quadrato Credentiales es seligite in le parametros de { -sync-brand-short-name }
about-logins-intro-instruction-help = Visita le <a data-l10n-name="help-link">supporto pro { -lockwise-brand-short-name }</a> pro plus adjuta
about-logins-intro-import = Si tu credentiales es salvate in un altere navigator, tu pote <a data-l10n-name="import-link">importar los in { -lockwise-brand-short-name }</a

about-logins-intro-import2 = Si tu credentiales es salvate foras de { -brand-product-name }, tu pote <a data-l10n-name="import-browser-link">importar los ab un altere navigator</a> o <a data-l10n-name="import-file-link">ab un file</a>

## Login

login-item-new-login-title = Crear nove credentiales
login-item-edit-button = Modificar
about-logins-login-item-remove-button = Remover
login-item-origin-label = Adresse web
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nomine de usator
about-logins-login-item-username =
    .placeholder = (nulle nomine de usator)
login-item-copy-username-button-text = Copiar
login-item-copied-username-button-text = Copiate!
login-item-password-label = Contrasigno
login-item-password-reveal-checkbox =
    .aria-label = Monstrar contrasigno
login-item-copy-password-button-text = Copiar
login-item-copied-password-button-text = Copiate!
login-item-save-changes-button = Salvar le cambiamentos
login-item-save-new-button = Salvar
login-item-cancel-button = Cancellar
login-item-time-changed = Ultime modification : { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Create: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Ultime uso: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Pro modificar le conto, insere tu credentiales de accesso a Windows. Isto adjuta a proteger le securitate de tu contos.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = verifica le credentiales salvate

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Pro vider le contrasigno, insere tu credentiales de accesso a Windows. Isto adjuta a proteger le securitate de tu contos.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = monstrar le contrasigno salvate

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Pro copiar le contrasigno, insere tu credentiales de accesso a Windows. Isto adjuta a proteger le securitate de tu contos.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiar le contrasigno salvate

## Master Password notification

master-password-notification-message = Insere tu contrasigno maestro pro vider le credentiales e contrasignos salvate

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Pro exportar tu credentiales de accesso, insere tu credentiales de accesso Windows. Isto adjuta proteger le securitate de tu contos.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exporta credentiales e contrasignos salvate

## Primary Password notification

about-logins-primary-password-notification-message = Insere tu contrasigno primari pro vider le credentiales e contrasignos salvate
master-password-reload-button =
    .label = Aperir session
    .accesskey = A

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Credentiales disponibile ubique tu usa { -brand-product-name }? Va al Optiones de tu { -sync-brand-short-name } e selige le quadrato Credentiales.
       *[other] Credentiales disponibile ubique tu usa { -brand-product-name }? Va al Preferentias de tu { -sync-brand-short-name } e selige le quadrato Credentiales.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Visita Parametros de { -sync-brand-short-name }
           *[other] Visita Preferentias de { -sync-brand-short-name }
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Non plus demandar me isto
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Cancellar
confirmation-dialog-dismiss-button =
    .title = Cancellar

about-logins-confirm-remove-dialog-title = Remover iste credentiales?
confirm-delete-dialog-message = Iste action es irreversibile.
about-logins-confirm-remove-dialog-confirm-button = Remover

about-logins-confirm-export-dialog-title = Exportar credentiales e contrasignos
about-logins-confirm-export-dialog-message = Tu contrasignos sera salvate como texto legibile (e.g., "P@ssw0rd123"), assi quicunque pote aperir le file exportate, pote vider los.
about-logins-confirm-export-dialog-confirm-button = Exportar…

confirm-discard-changes-dialog-title = Abandonar le modificationes non salvate?
confirm-discard-changes-dialog-message = Tote le modificationes non salvate essera perdite.
confirm-discard-changes-dialog-confirm-button = Abandonar

## Breach Alert notification

about-logins-breach-alert-title = Violation de sitos web
breach-alert-text = Le contrasignos de iste sito web ha essite divulgate o robate desde le ultime vice que tu cambiava tu credentiales. Cambia ora tu contrasigno pro proteger tu conto!
about-logins-breach-alert-date = Iste violation occurreva le { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Ir a { $hostname }
about-logins-breach-alert-learn-more-link = Saper plus

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Contrasigno vulnerabile
about-logins-vulnerable-alert-text2 = Iste contrasigno ha essite usate pro un altere conto que ha probabilemente essite colpate de un violation de datos. Le reuso de credentiales mitte tote tu contos in periculo. Tu debe cambiar iste contrasigno.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ir a { $hostname }
about-logins-vulnerable-alert-learn-more-link = Saper plus

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Un entrata pro { $loginTitle } con ille nomine de usator existe jam. <a data-l10n-name="duplicate-link">Ir al entrata existente?</a>

# This is a generic error message.
about-logins-error-message-default = Un error occurreva durante le tentativa de salvar iste contrasigno.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportar file de credentiales
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = credenziales.csv
about-logins-export-file-picker-export-button = Exportar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] File CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importar file de credentiales
about-logins-import-file-picker-import-button = Importar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] File CSV
    }
