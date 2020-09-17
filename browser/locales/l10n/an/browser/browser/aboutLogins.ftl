# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Inicios de sesión y claus

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Leva-te las tuyas claus ta qualsequier cabo
login-app-promo-subtitle = Instala l'aplicación gratuita { -lockwise-brand-name }
login-app-promo-android =
    .alt = Baixa-te-la de Google Play
login-app-promo-apple =
    .alt = Baixa-te-la de l'App Store
login-filter =
    .placeholder = Buscar nombres d'usuario
create-login-button = Creyar un nuevo nombre d'usuario
fxaccounts-sign-in-text = Acceder a las claus dende totz los tuyos dispositivos
fxaccounts-sign-in-button = Inicia la sesión en { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Chestionar la cuenta

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Ubrir lo menú
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importar dende belatro navegador…
about-logins-menu-menuitem-import-from-a-file = Importar dende un fichero…
about-logins-menu-menuitem-export-logins = Exportar os inicios de sesión…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opcions
       *[other] Preferencias
    }
about-logins-menu-menuitem-help = Aduya
menu-menuitem-android-app = { -lockwise-brand-short-name } pa Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } pa iPhone y iPad

## Login List

login-list =
    .aria-label = Nombres d'usuario que coinciden con la busqueda
login-list-count =
    { $count ->
        [one] { $count } nombre d'usuario
       *[other] { $count } nombres d'usuario
    }
login-list-sort-label-text = Ordenar per:
login-list-name-option = Nombre (A-Z)
login-list-name-reverse-option = Nombre (Z-A)
about-logins-login-list-alerts-option = Alertas
login-list-last-changed-option = Zaguera modificación
login-list-last-used-option = Zaguer uso
login-list-intro-title = No s'ha trobau garra nombre d'usuario
login-list-intro-description = Quan alces una clau en { -brand-product-name }, s'amostrará aquí
about-logins-login-list-empty-search-title = No s'ha trobau garra nombre d'usuario
about-logins-login-list-empty-search-description = No i hai garra resultau que coincida con a busqueda
login-list-item-title-new-login = Nuevo nombre d'usuario
login-list-item-subtitle-new-login = Escribe la tuya información d'inicio de sesión
login-list-item-subtitle-missing-username = (garra nombre d'usuario)
about-logins-list-item-breach-icon =
    .title = Puesto web con filtración de datos
about-logins-list-item-vulnerable-password-icon =
    .title = Clau vulnerable

## Introduction screen

login-intro-heading = Yes mirando los inicios de sesión que has alzaus? Configura { -sync-brand-short-name }
about-logins-login-intro-heading-logged-out = Yes mirando los inicios de sesión que has alzau? Configura { -sync-brand-short-name } u importar-los
about-logins-login-intro-heading-logged-in = No s'ha trobau garra inicio de sesión sincronizau.
login-intro-description = Si has alzau inicios de sesión en { -brand-product-name } en belatro dispositivo, esta ye la manera de tener-los tamién aquí:
login-intro-instruction-fxa = Crea un { -fxaccount-brand-name } u inicia-ie la sesión dende lo dispositivo an que tiens alzaus los inicios de sesión
login-intro-instruction-fxa-settings = Asegura-te de que has triau la casilla de selección Inicios de sesión en os achustes de { -sync-brand-short-name }
about-logins-intro-instruction-help = Pa obtener mas aduya, visita l' <a data-l10n-name="help-link">asistencia de { -lockwise-brand-short-name }</a>.
about-logins-intro-import = Si los inicios de sesión s'han alzau en belatro ordinador, puetz <a data-l10n-name="import-link">importar-los en { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Si os tuyos inicios de sesión son guardaus defuera de { -brand-product-name }, puetz <a data-l10n-name="import-browser-link"> importar-los dende atro navegador</a> u <a data-l10n-name="import-file-link"> dende un archivo</a>

## Login

login-item-new-login-title = Creyar un nuevo nombre d'usuario
login-item-edit-button = Editar
about-logins-login-item-remove-button = Eliminar
login-item-origin-label = Adreza d'o puesto web
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nombre d'usuario
about-logins-login-item-username =
    .placeholder = (garra nombre d'usuario)
login-item-copy-username-button-text = Copiar
login-item-copied-username-button-text = S'ha copiau!
login-item-password-label = Clau
login-item-password-reveal-checkbox =
    .aria-label = Amostrar a clau
login-item-copy-password-button-text = Copiar
login-item-copied-password-button-text = S'ha copiau!
login-item-save-changes-button = Alzar los cambios
login-item-save-new-button = Alzar
login-item-cancel-button = Cancelar
login-item-time-changed = Zaguera modificación: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Creau: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Zaguer uso: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Pa editar tu inicio de sesión, escribe las tuyas credencias d'acceso a Windows. Esto te aduya a protecher la seguranza d'as tuyas cuentas.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = editar l'inicio de sesión alzau
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Ta veyer a tuya clau, escribe las tuyas credencials d'acceso a Windows. Esto t'aduya a protecher la seguranza d'as tuyas cuentas.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = amostrar la clau alzada
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Pa veyer a tuya clau, escribe las tuyas credencials d'acceso a Windows. Esto t'aduya a protecher la seguranza d'as tuyas cuentas.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copia la clau alzada

## Master Password notification

master-password-notification-message = Escribe la clau mayestra pa veyer los inicios de sesión y claus alzaus
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Pa exportar los tuyos inicios de sesión, escribe las tuyas credencials d'acceso a Windows. Esto t'aduya a protecher la seguranza d'as tuyas cuentas.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportar los inicios de sesión y claus

## Primary Password notification

about-logins-primary-password-notification-message = Escribe la clau primaria pa veyer los inicios de sesión y as claus alzaus
master-password-reload-button =
    .label = Iniciar sesión
    .accesskey = I

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Quiers acceder a los tuyos inicios de sesión astí an que usas { -brand-product-name }? Ves ta las Opcions de { -sync-brand-short-name } y marca la caixeta de selección Inicios de sesión.
       *[other] Quiers acceder a los tuyos inicios de sesión astí an que usas { -brand-product-name }? Ves ta las Preferencias de { -sync-brand-short-name } y marca la caixeta de selección Inicios de sesión.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Visitar las opcions de { -sync-brand-short-name }
           *[other] Visitar las preferencias de { -sync-brand-short-name }
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = No tornar a preguntar-me-lo
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Cancelar
confirmation-dialog-dismiss-button =
    .title = Cancelar
about-logins-confirm-remove-dialog-title = Eliminar este nombre d'usuario?
confirm-delete-dialog-message = Esta acción no se puet desfer.
about-logins-confirm-remove-dialog-confirm-button = Eliminar
about-logins-confirm-export-dialog-title = Exportar inicios de sesión y claus
about-logins-confirm-export-dialog-message = Las tuyas claus s'han alzau como testo lechible (exemplo, BadP@ssw0rd) asinas que qualsiquiera que pueda ubrir lo archivo alzau podrá leyer-las.
about-logins-confirm-export-dialog-confirm-button = Exportar…
confirm-discard-changes-dialog-title = Descartar los cambios sin alzar?
confirm-discard-changes-dialog-message = Totz los cambios sin alzar se pueden perder.
confirm-discard-changes-dialog-confirm-button = Escartar

## Breach Alert notification

about-logins-breach-alert-title = Trenque en a pachina web
breach-alert-text = Bellas claus d'este puesto s'han filtrau u robau dende que esviellés los tuyos detalles d'inicio de sesión. Cambia la tuya clau pa protecher la tuya cuenta.
about-logins-breach-alert-date = Iste trenque ha ocurriu en { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Ir ta { $hostname }
about-logins-breach-alert-learn-more-link = Saber-ne mas

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Clau vulnerable
about-logins-vulnerable-alert-text2 = Esta clau s'ha usau con atra cuenta que ha amaneixiu en un robo de datos. Reusar credencials mete las tuyas cuentas en periglo. Cambia esta clau.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ir ta  { $hostname }
about-logins-vulnerable-alert-learn-more-link = Saber-ne mas

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Ya existe una dentrada pa { $loginTitle } con ixe nombre d'usuario. <a data-l10n-name="duplicate-link">Quirs ir ta la dentrada existent?</a>
# This is a generic error message.
about-logins-error-message-default = S'ha produciu una error quan se miraba d'alzar esta clau.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportar lo fichero d'inicios de sesión
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Exportar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Archivo CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importar lo fichero d'inicios de sesión
about-logins-import-file-picker-import-button = Importar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Archivo CSV
    }
