# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Identificacións e contrasinais

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Leve os seus contrasinais a todas partes
login-app-promo-subtitle = Obter a aplicación gratuíta { -lockwise-brand-name }
login-app-promo-android =
    .alt = Obtela a través de Google Play
login-app-promo-apple =
    .alt = Descárguea da App Store
login-filter =
    .placeholder = Buscar sesións
create-login-button = Crear novo inicio de sesión
fxaccounts-sign-in-text = Obteña os seus contrasinais doutros dispositivos seus
fxaccounts-sign-in-button = Conectarse a { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Xestionar conta

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Abrir menú
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importar desde outro navegador…
about-logins-menu-menuitem-import-from-a-file = Importar dun ficheiro ...
about-logins-menu-menuitem-export-logins = Exportar sesións ...
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opcións
       *[other] Preferencias
    }
about-logins-menu-menuitem-help = Axuda
menu-menuitem-android-app = { -lockwise-brand-short-name } para Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } para iPhone e iPad

## Login List

login-list =
    .aria-label = Inicios de sesión que coinciden coa consulta de busca
login-list-count =
    { $count ->
        [one] { $count } sesión
       *[other] { $count } sesións
    }
login-list-sort-label-text = Ordenar por:
login-list-name-option = Nome (A-Z)
login-list-name-reverse-option = Nome (Z-A)
about-logins-login-list-alerts-option = Alertas
login-list-last-changed-option = Última modificación
login-list-last-used-option = Usado por última vez
login-list-intro-title = Non se atoparon inicios de sesión
login-list-intro-description = Cando garde un contrasinal en { -brand-product-name }, aparecerá aquí.
about-logins-login-list-empty-search-title = Non se atoparon inicios de sesión
about-logins-login-list-empty-search-description = Non hai resultados que coincidan coa súa busca.
login-list-item-title-new-login = Novo inicio de sesión
login-list-item-subtitle-new-login = Insira as súas credenciais de inicio de sesión
login-list-item-subtitle-missing-username = (sen nome de usuario)
about-logins-list-item-breach-icon =
    .title = Sitio web comprometido
about-logins-list-item-vulnerable-password-icon =
    .title = Contrasinal vulnerable

## Introduction screen

login-intro-heading = Busca os seus inicios de sesión gardados? Configure { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = Busca os seus inicios de sesión gardados? Configure { -sync-brand-short-name } ou impórteos.
about-logins-login-intro-heading-logged-in = Non se atoparon outras sesións sincronizadas.
login-intro-description = Se gardou os seus inicios de sesión en { -brand-product-name } noutro dispositivo, velaquí como conseguilos:
login-intro-instruction-fxa = Cree ou inicie sesión no seu { -fxaccount-brand-name } no dispositivo onde se garden os seus inicios de sesión
login-intro-instruction-fxa-settings = Asegúrese de que seleccionou a caixa de verificación de Iniciar sesión en Configuración de { -sync-brand-short-name }
about-logins-intro-instruction-help = Visite <a data-l10n-name="help-link">{ -lockwise-brand-short-name } Vaia ao soporte </a> para obter máis axuda
about-logins-intro-import = Se os seus inicios de sesión están gardados noutro navegador, pode <a data-l10n-name="import-link"> importalos a { -lockwise-brand-short-name } </a>
about-logins-intro-import2 = Se os seus inicios de sesión están gardados fóra de { -brand-product-name }, pode <a data-l10n-name="import-browser-link">importalos desde outro navegador</a> ou <a data-l10n-name="import-file-link">dun ficheiro</a>

## Login

login-item-new-login-title = Crear novo inicio de sesión
login-item-edit-button = Editar
about-logins-login-item-remove-button = Eliminar
login-item-origin-label = Enderezo do sitio web
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nome de usuario
about-logins-login-item-username =
    .placeholder = (sen nome de usuario)
login-item-copy-username-button-text = Copiar
login-item-copied-username-button-text = Copiouse!
login-item-password-label = Contrasinal
login-item-password-reveal-checkbox =
    .aria-label = Amosar contrasinal
login-item-copy-password-button-text = Copiar
login-item-copied-password-button-text = Copiouse!
login-item-save-changes-button = Gardar cambios
login-item-save-new-button = Gardar
login-item-cancel-button = Cancelar
login-item-time-changed = Última modificación: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Creado: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Última utilización: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Para editar o seu inicio de sesión, insira as súas credenciais de inicio de sesión de Windows. Isto axuda a protexer a seguridade das súas contas.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = editar o inicio de sesión gardado
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Para ver o seu contrasinal, insira as súas credenciais de inicio de sesión en Windows. Isto axuda a protexer a seguridade das súas contas.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = revelar o contrasinal gardado
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Para copiar o seu contrasinal, insira as súas credenciais de inicio de sesión en Windows. Isto axuda a protexer a seguridade das súas contas.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiar o contrasinal gardado

## Master Password notification

master-password-notification-message = Introduza o seu contrasinal principal para ver as sesións e contrasinais gardados
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Para exportar os seus inicios de sesión, insira as súas credenciais de inicio de sesión en Windows. Isto axuda a protexer a seguridade das súas contas.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportar sesións e contrasinais gardados

## Primary Password notification

about-logins-primary-password-notification-message = Introduza o seu contrasinal principal para ver as sesións e os contrasinais gardados
master-password-reload-button =
    .label = Iniciar sesión
    .accesskey = I

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Quere os seus inicios de sesión en calquera lugar que empregue { -brand-product-name }? Vaia ás súas opcións { -sync-brand-short-name } e seleccione a caixa de verificación Iniciar sesión.
       *[other] Quere os seus inicios de sesión en calquera lugar que empregue { -brand-product-name }? Vaia ás súas preferencias { -sync-brand-short-name } e seleccione a caixa de verificación Iniciar sesión.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Visitar { -sync-brand-short-name } Opcións
           *[other] Visitar { -sync-brand-short-name } Preferencias
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Non preguntar de novo
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Cancelar
confirmation-dialog-dismiss-button =
    .title = Cancelar
about-logins-confirm-remove-dialog-title = Eliminar esta identificación?
confirm-delete-dialog-message = Non é posíbel desfacer esta acción.
about-logins-confirm-remove-dialog-confirm-button = Eliminar
about-logins-confirm-export-dialog-title = Exportar inicios de sesión e contrasinais
about-logins-confirm-export-dialog-message = Os seus contrasinais gardaranse como texto lexible (por exemplo, ConTR@sinaLmaL0) para que calquera que poida abrir o ficheiro exportado poida velos.
about-logins-confirm-export-dialog-confirm-button = Exportar…
confirm-discard-changes-dialog-title = Descartar os cambios non gardados?
confirm-discard-changes-dialog-message = Perderanse todos os cambios non gardados.
confirm-discard-changes-dialog-confirm-button = Descartar

## Breach Alert notification

about-logins-breach-alert-title = Compromiso do sitio web
breach-alert-text = Os contrasinais foron filtrados ou roubados deste sitio web desde que vostede actualizou os seus datos de inicio de sesión por última vez. Cambie o seu contrasinal para protexer a súa conta.
about-logins-breach-alert-date = Este comoromiso produciuse o { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Vaia a { $hostname }
about-logins-breach-alert-learn-more-link = Máis información

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Contrasinal vulnerable
about-logins-vulnerable-alert-text2 = Este contrasinal empregouse noutra conta que probablemente se viu inmersa nun compromiso de datos. Reutilizar as credenciais pon en risco todas as súas contas. Cambie este contrasinal.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ir a { $hostname }
about-logins-vulnerable-alert-learn-more-link = Máis información

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Xa existe unha entrada para { $loginTitle } con ese nome de usuario. <a data-l10n-name="duplicate-link">Ir á entrada existente? </a>
# This is a generic error message.
about-logins-error-message-default = Produciuse un erro ao intentar gardar este contrasinal.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportar ficheiro de inicios de sesión
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Exportar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Ficheiro CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importar ficheiro de inicios de sesión
about-logins-import-file-picker-import-button = Importar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Ficheiro CSV
    }
