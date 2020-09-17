# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Inicis de sessió i contrasenyes

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Accediu a les vostres contrasenyes des de qualsevol lloc
login-app-promo-subtitle = Instal·leu l'aplicació { -lockwise-brand-name } gratuïta
login-app-promo-android =
    .alt = Disponible a Google Play
login-app-promo-apple =
    .alt = Baixeu-lo de l'App Store

login-filter =
    .placeholder = Cerca els inicis de sessió

create-login-button = Crea un inici de sessió

fxaccounts-sign-in-text = Accediu a les contrasenyes en tots els vostres dispositius
fxaccounts-sign-in-button = Inicia la sessió al { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Gestiona el compte

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Obre el menú
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importa d'un altre navegador…
about-logins-menu-menuitem-import-from-a-file = Importa d'un fitxer…
about-logins-menu-menuitem-export-logins = Exporta els inicis de sessió…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opcions
       *[other] Preferències
    }
about-logins-menu-menuitem-help = Ajuda
menu-menuitem-android-app = { -lockwise-brand-short-name } per a l'Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } per a l'iPhone i iPad

## Login List

login-list =
    .aria-label = Inicis de sessió que coincideixen amb els criteris de cerca
login-list-count =
    { $count ->
        [one] { $count } inici de sessió
       *[other] { $count } inicis de sessió
    }
login-list-sort-label-text = Ordena per:
login-list-name-option = Nom (A-Z)
login-list-name-reverse-option = Nom (Z-A)
about-logins-login-list-alerts-option = Alertes
login-list-last-changed-option = Darrera modificació
login-list-last-used-option = Darrer ús
login-list-intro-title = No s'ha trobat cap inici de sessió
login-list-intro-description = Aquí es mostren les contrasenyes que deseu en el { -brand-product-name }.
about-logins-login-list-empty-search-title = No s'ha trobat cap inici de sessió
about-logins-login-list-empty-search-description = No hi ha cap resultat que coincideixi amb la cerca.
login-list-item-title-new-login = Inici de sessió nou
login-list-item-subtitle-new-login = Introduïu les credencials d'inici de sessió
login-list-item-subtitle-missing-username = (cap nom d'usuari)
about-logins-list-item-breach-icon =
    .title = Lloc web amb filtració de dades
about-logins-list-item-vulnerable-password-icon =
    .title = Contrasenya vulnerable

## Introduction screen

login-intro-heading = Esteu cercant els inicis de sessió que heu desat? Configureu el { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Esteu cercant els inicis de sessió que heu desat? Configureu el { -sync-brand-short-name } o importeu-los.
about-logins-login-intro-heading-logged-in = No s'ha trobat cap inici de sessió sincronitzat.
login-intro-description = Si heu desat els vostres inicis de sessió en el { -brand-product-name } des d'un altre dispositiu, aquesta és la manera de tenir-los també aquí:
login-intro-instruction-fxa = Creeu un { -fxaccount-brand-name } o inicieu-hi la sessió des del dispositiu on teniu desats els vostres inicis de sessió
login-intro-instruction-fxa-settings = Assegureu-vos que heu seleccionat la casella de selecció Inicis de sessió en els paràmetres del { -sync-brand-short-name }
about-logins-intro-instruction-help = Visiteu l'<a data-l10n-name="help-link">assistència del { -lockwise-brand-short-name }</a> per obtenir més ajuda
about-logins-intro-import = Si els vostres inicis de sessió estan desats en un altre navegador, podeu <a data-l10n-name="import-link">importar-los al { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Si els vostres inicis de sessió estan desats fora del { -brand-product-name }, podeu <a data-l10n-name="import-browser-link">importar-los d'un altre navegador</a> o <a data-l10n-name="import-file-link">d'un fitxer</a>

## Login

login-item-new-login-title = Crea un inici de sessió
login-item-edit-button = Edita
about-logins-login-item-remove-button = Elimina
login-item-origin-label = Adreça del lloc web
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nom d'usuari
about-logins-login-item-username =
    .placeholder = (cap nom d'usuari)
login-item-copy-username-button-text = Copia
login-item-copied-username-button-text = S'ha copiat
login-item-password-label = Contrasenya
login-item-password-reveal-checkbox =
    .aria-label = Mostra la contrasenya
login-item-copy-password-button-text = Copia
login-item-copied-password-button-text = S'ha copiat
login-item-save-changes-button = Desa els canvis
login-item-save-new-button = Desa
login-item-cancel-button = Cancel·la
login-item-time-changed = Darrera modificació: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Creat: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Darrer ús: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Per editar l'inici de sessió, introduïu les vostres credencials d'inici de sessió al Windows. Això ajuda a protegir la seguretat dels vostres comptes.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = editar l'inici de sessió desat

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Per veure la contrasenya, introduïu les vostres credencials d'inici de sessió al Windows. Això ajuda a protegir la seguretat dels vostres comptes.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = mostrar la contrasenya desada

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Per copiar la contrasenya, introduïu les vostres credencials d'inici de sessió al Windows. Això ajuda a protegir la seguretat dels vostres comptes.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiar la contrasenya desada

## Master Password notification

master-password-notification-message = Introduïu la contrasenya mestra per veure els inicis de sessió i les contrasenyes desats

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Per exportar els inicis de sessió, introduïu les vostres credencials d'inici de sessió al Windows. Això ajuda a protegir la seguretat dels vostres comptes.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportar els inicis de sessió i les contrasenyes desats

## Primary Password notification

about-logins-primary-password-notification-message = Introduïu la contrasenya principal per veure els inicis de sessió i les contrasenyes desats
master-password-reload-button =
    .label = Inicia la sessió
    .accesskey = I

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Voleu accedir als vostres inicis de sessió arreu on utilitzeu el { -brand-product-name }? Aneu a les Opcions del { -sync-brand-short-name } i marqueu la casella de selecció Inicis de sessió.
       *[other] Voleu accedir als vostres inicis de sessió arreu on utilitzeu el { -brand-product-name }? Aneu a les Preferències del { -sync-brand-short-name } i marqueu la casella de selecció Inicis de sessió.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Vés a les Opcions del { -sync-brand-short-name }
           *[other] Vés a les Preferències del { -sync-brand-short-name }
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = No m'ho tornis a demanar
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Cancel·la
confirmation-dialog-dismiss-button =
    .title = Cancel·la

about-logins-confirm-remove-dialog-title = Voleu eliminar aquest inici de sessió?
confirm-delete-dialog-message = Aquesta acció no es pot desfer.
about-logins-confirm-remove-dialog-confirm-button = Elimina

about-logins-confirm-export-dialog-title = Exporta els inicis de sessió i contrasenyes
about-logins-confirm-export-dialog-message = Les contrasenyes es desaran com a text llegible (per exemple, «malaC0ntr@senya»), de manera que qualsevol que pugui obrir el fitxer exportat les podrà veure.
about-logins-confirm-export-dialog-confirm-button = Exporta…

confirm-discard-changes-dialog-title = Voleu descartar els canvis no desats?
confirm-discard-changes-dialog-message = Es perdran tots els canvis que no hàgiu desat.
confirm-discard-changes-dialog-confirm-button = Descarta

## Breach Alert notification

about-logins-breach-alert-title = Filtració de dades del lloc web
breach-alert-text = S'han filtrat o robat contrasenyes d'aquest lloc web des de la darrera vegada que en vàreu actualitzar les vostres dades d'inici de sessió. Canvieu la contrasenya per protegir el vostre compte.
about-logins-breach-alert-date = Data de la filtració: { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Vés a { $hostname }
about-logins-breach-alert-learn-more-link = Més informació

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Contrasenya vulnerable
about-logins-vulnerable-alert-text2 = Aquesta contrasenya s'ha utilitzat en un altre compte que probablement ha estat compromès. Reutilitzar credencials posa tots els vostres comptes en perill. Canvieu aquesta contrasenya.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Vés a { $hostname }
about-logins-vulnerable-alert-learn-more-link = Més informació

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Ja existeix una entrada per a { $loginTitle } amb aquest nom d'usuari. <a data-l10n-name="duplicate-link">Voleu anar a l'entrada existent?</a>

# This is a generic error message.
about-logins-error-message-default = S'ha produït un error en intentar desar aquesta contrasenya.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exporta el fitxer d'inicis de sessió
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = inicis_sessio.csv
about-logins-export-file-picker-export-button = Exporta
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Document CSV
       *[other] Fitxer CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importa el fitxer d'inicis de sessió
about-logins-import-file-picker-import-button = Importa
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Document CSV
       *[other] Fitxer CSV
    }
