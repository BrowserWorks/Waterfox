# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Inicios de sesión y contraseñas
login-filter =
    .placeholder = Buscar inicios de sesión
create-login-button = Crear nuevo inicio de sesión
fxaccounts-sign-in-text = Obtén tus contraseñas para tus otros dispositivos
fxaccounts-sign-in-sync-button = Inicia sesión para sincronizar
fxaccounts-avatar-button =
    .title = Administrar cuenta

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Abrir menú
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importar desde otro navegador...
about-logins-menu-menuitem-import-from-a-file = Importar desde un archivo…
about-logins-menu-menuitem-export-logins = Exportar inicios de sesión...
about-logins-menu-menuitem-remove-all-logins = Eliminar todos los inicios de sesión…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opciones
       *[other] Preferencias
    }
about-logins-menu-menuitem-help = Ayuda

## Login List

login-list =
    .aria-label = Inicios de sesión que coinciden con la consulta de búsqueda
login-list-count =
    { $count ->
        [one] { $count } inicio de sesión
       *[other] { $count } inicios de sesión
    }
login-list-sort-label-text = Ordenar por:
login-list-name-option = Nombre (A-Z)
login-list-name-reverse-option = Nombre (Z-A)
login-list-username-option = Nombre de usuario (A-Z)
login-list-username-reverse-option = Nombre de usuario (Z-A)
about-logins-login-list-alerts-option = Alertas
login-list-last-changed-option = Última modificación
login-list-last-used-option = Último uso
login-list-intro-title = No se encontraron inicios de sesión
login-list-intro-description = Cuando guardas una contraseña en { -brand-product-name }, se mostrará aquí.
about-logins-login-list-empty-search-title = No se encontraron credenciales
about-logins-login-list-empty-search-description = No hay resultados que coincidan con tu búsqueda
login-list-item-title-new-login = Nuevo inicio de sesión
login-list-item-subtitle-new-login = Ingresa tus credenciales de inicio de sesión
login-list-item-subtitle-missing-username = (sin nombre de usuario)
about-logins-list-item-breach-icon =
    .title = Sitio web vulnerado
about-logins-list-item-vulnerable-password-icon =
    .title = Contraseña vulnerable
about-logins-list-section-breach = Sitios web vulnerados
about-logins-list-section-vulnerable = Contraseñas vulnerables
about-logins-list-section-nothing = Sin alerta
about-logins-list-section-today = Hoy
about-logins-list-section-yesterday = Ayer
about-logins-list-section-week = Últimos 7 días

## Introduction screen

about-logins-login-intro-heading-logged-out2 = ¿Buscas tus inicios de sesión guardados? Activa la sincronización o impórtalos.
about-logins-login-intro-heading-logged-in = No se encontraron inicios de sesión sincronizados.
login-intro-description = Si salvaste tus inicios de sesión en { -brand-product-name } en un dispositivo diferente, aquí se muestra como obtenerlas para aquí también:
login-intro-instructions-fxa = Crea o inicia sesión en tu { -fxaccount-brand-name } en el dispositivo donde se guardan tus inicios de sesión.
login-intro-instructions-fxa-settings = Ve a Configuración> Sincronizar > Activar sincronización… Marca la casilla Inicios de sesión y contraseñas.
login-intro-instructions-fxa-help = Visita <a data-l10n-name="help-link">{ -lockwise-brand-short-name } Soporte</a> para más ayuda.
about-logins-intro-import = Si tus inicios de sesión están guardados en otro navegador, puedes <a data-l10n-name="import-link">importarlos a { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Si tus credenciales se guardan fuera de { -brand-product-name }, puedes <a data-l10n-name="import-browser-link">importarlas desde otro navegador</a> o <a data-l10n-name="import-file-link">desde un archivo</a>

## Login

login-item-new-login-title = Crear nuevo inicio de sesión
login-item-edit-button = Editar
about-logins-login-item-remove-button = Eliminar
login-item-origin-label = Dirección de sitio web
login-item-tooltip-message = Asegúrate de que coincida exactamente con la dirección del sitio web en donde inicias sesión.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nombre de usuario
about-logins-login-item-username =
    .placeholder = (sin nombre de usuario)
login-item-copy-username-button-text = Copiar
login-item-copied-username-button-text = ¡Copiado!
login-item-password-label = Contraseña
login-item-password-reveal-checkbox =
    .aria-label = Mostrar contraseña
login-item-copy-password-button-text = Copiar
login-item-copied-password-button-text = ¡Copiado!
login-item-save-changes-button = Guardar cambios
login-item-save-new-button = Guardar
login-item-cancel-button = Cancelar
login-item-time-changed = Última modificación: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Creado: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Último uso: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Para editar tu inicio de sesión, ingresa tus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de tus cuentas.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = editar el inicio de sesión guardado
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Para ver tu contraseña, ingresa tus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de tus cuentas.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = mostrar la contraseña guardada
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Para copiar tu contraseña, ingresa tus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de tus cuentas.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiar la contraseña guardada
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Para exportar tus inicios de sesión, ingresa tus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de tus cuentas.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportar inicios de sesión y contraseñas guardadas

## Primary Password notification

about-logins-primary-password-notification-message = Ingresa tu contraseña principal para ver los inicios de sesión y las contraseñas guardadas
master-password-reload-button =
    .label = Iniciar sesión
    .accesskey = L

## Dialogs

confirmation-dialog-cancel-button = Cancelar
confirmation-dialog-dismiss-button =
    .title = Cancelar
about-logins-confirm-remove-dialog-title = ¿Eliminar este inicio de sesión?
confirm-delete-dialog-message = Esta acción no se puede deshacer
about-logins-confirm-remove-dialog-confirm-button = Eliminar
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Eliminar
        [one] Eliminar
       *[other] Eliminar todas
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Sí, eliminar este inicio de sesión
        [one] Sí, eliminar este inicio de sesión
       *[other] Sí, eliminar estos inicios de sesión
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] ¿Eliminar inicio de sesión de { $count }?
       *[other] ¿Eliminar todos los inicios de sesión de { $count }?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Esto eliminará el inicio de sesión que guardó con { -brand-short-name } y cualquier alerta de filtración que aparezca aquí. No podrá deshacer esta acción.
        [one] Esto eliminará el inicio de sesión que guardó con { -brand-short-name } y cualquier alerta de filtración que aparezca aquí. No podrá deshacer esta acción.
       *[other] Esto eliminará los inicios de sesión que guardó con { -brand-short-name } y cualquier alerta de filtración que aparezca aquí. No podrá deshacer esta acción.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] ¿Eliminar { $count } inicio de sesión de todos los dispositivos?
       *[other] ¿Eliminar los { $count } inicios de sesión de todos los dispositivos?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Esto eliminará el inicio de sesión que guardó en { -brand-short-name } en todos los dispositivos sincronizados con su { -fxaccount-brand-name }. Esto también eliminará las alertas de filtraciones que aparecen aquí. No podrá deshacer esta acción.
        [one] Esto eliminará el inicio de sesión que guardó en { -brand-short-name } en todos los dispositivos sincronizados con su { -fxaccount-brand-name }. Esto también eliminará las alertas de filtraciones que aparecen aquí. No podrá deshacer esta acción.
       *[other] Esto eliminará todos los inicios de sesión que guardó en { -brand-short-name } en todos los dispositivos sincronizados con su { -fxaccount-brand-name }. Esto también eliminará las alertas de filtraciones que aparecen aquí. No podrá deshacer esta acción.
    }
about-logins-confirm-export-dialog-title = Exportar inicios de sesión y contraseñas
about-logins-confirm-export-dialog-message = Tus contraseñas se guardarán como texto legible (por ejemplo, BadP@ssw0rd) de modo que cualquiera que abra el archivo exportado podrá verlas.
about-logins-confirm-export-dialog-confirm-button = Exportar...
about-logins-alert-import-title = Importación completa
about-logins-alert-import-message = Ver resumen detallado de la importación
confirm-discard-changes-dialog-title = ¿Descartar cambios no guardados?
confirm-discard-changes-dialog-message = Todos los cambios no guardados se perderán.
confirm-discard-changes-dialog-confirm-button = Descartar

## Breach Alert notification

about-logins-breach-alert-title = Filtración del sitio web
breach-alert-text = Las contraseñas fueron filtradas o robadas de este sitio web desde la última vez que actualizaste tus datos de inicio de sesión. Cambia tu contraseña para proteger tu cuenta.
about-logins-breach-alert-date = La filtración ocurrió el { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Ir a { $hostname }
about-logins-breach-alert-learn-more-link = Saber más

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Contraseña vulnerable
about-logins-vulnerable-alert-text2 = Esta contraseña ha sido usada en otra cuenta que al parecer se vio afectada en una filtración. Reutilizar credenciales pone en peligro a todas sus cuentas. Cambie esta contraseña.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ir a { $hostname }
about-logins-vulnerable-alert-learn-more-link = Saber más

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Ya hay una entrada para { $loginTitle } con ese nombre de usuario. <a data-l10n-name="duplicate-link">¿Quieres ir a esa entrada?</a>
# This is a generic error message.
about-logins-error-message-default = Se produjo un error al intentar guardar esta contraseña.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportar archivo de inicios de sesión
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
about-logins-import-file-picker-title = Importar archivos de inicio de sesión
about-logins-import-file-picker-import-button = Importar
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Archivo CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Documento TSV
       *[other] Archivo TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importación completa
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span>Se agregaron nuevos inicios de sesión:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Se agregaron nuevos inicios de sesión:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span>Se actualizaron los inicios de sesión :</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Se actualizaron los inicios de sesión :</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span>Se encontraron inicios de sesión duplicados:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(no importado)</span>
       *[other] <span>Se encontraron inicios de sesión duplicados:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(no importados)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span>Errores:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(no importado)</span>
       *[other] <span>Errores:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(no importados)</span>
    }
about-logins-import-dialog-done = Hecho
about-logins-import-dialog-error-title = Error de importación
about-logins-import-dialog-error-conflicting-values-title = Múltiples valores contradictorios para un mismo inicio de sesión
about-logins-import-dialog-error-conflicting-values-description = Por ejemplo: múltiples nombres de usuario, contraseñas, URLs, etc. para un mismo inicio de sesión.
about-logins-import-dialog-error-file-format-title = Problema de formato de archivo
about-logins-import-dialog-error-file-format-description = Encabezados de columna incorrectos o faltantes. Asegúrate de que el archivo incluye columnas para nombre de usuario, contraseña y URL.
about-logins-import-dialog-error-file-permission-title = Imposible leer el archivo
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } no tiene permiso para leer el archivo. Intente cambiar los permisos del archivo.
about-logins-import-dialog-error-unable-to-read-title = No se puede analizar el archivo
about-logins-import-dialog-error-unable-to-read-description = Asegúrate de haber seleccionado un archivo CSV o TSV.
about-logins-import-dialog-error-no-logins-imported = No se importaron los inicios de sesión
about-logins-import-dialog-error-learn-more = Aprender más
about-logins-import-dialog-error-try-import-again = Intenta importar de nuevo…
about-logins-import-dialog-error-cancel = Cancelar
about-logins-import-report-title = Resumen de importación
about-logins-import-report-description = Inicios de sesión y contraseñas importadas a { -brand-short-name }.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Fila { $number }
about-logins-import-report-row-description-no-change = Duplicado: Coincidencia exacta con inicio de sesión existente
about-logins-import-report-row-description-modified = Inicio de sesión existente actualizado
about-logins-import-report-row-description-added = Nuevo inicio de sesión agregado
about-logins-import-report-row-description-error = Error: campo faltante

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Error: múltiples valores para { $field }
about-logins-import-report-row-description-error-missing-field = Error: falta { $field }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Nuevos inicios de sesión agregados</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nuevos inicios de sesión agregados</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Inicios de sesión existentes actualizados</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Inicios de sesión existentes actualizados</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Inicios de sesión duplicados</div> <div data-l10n-name="not-imported">No importados</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Inicios de sesión duplicados</div> <div data-l10n-name="not-imported">No importados</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Errores</div> <div data-l10n-name="not-imported">(no importados)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Errores</div> <div data-l10n-name="not-imported">(no importados)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Importar informe de resumen
