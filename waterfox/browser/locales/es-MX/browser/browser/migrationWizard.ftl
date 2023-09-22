# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importar datos del navegador
migration-wizard-selection-list = Selecciona los datos que deseas importar.

# Shown in the new migration wizard's dropdown selector for choosing the browser
# to import from. This variant is shown when the selected browser doesn't support
# user profiles, and so we only show the browser name.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
migration-wizard-selection-option-without-profile = { $sourceBrowser }

# Shown in the new migration wizard's dropdown selector for choosing the browser
# and user profile to import from. This variant is shown when the selected browser
# supports user profiles.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
#  $profileName (String): the name of the user profile to import from.
migration-wizard-selection-option-with-profile = { $sourceBrowser } — { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 Secure Browser
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Contraseñas del archivo CSV
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importar todos los datos disponibles
migration-no-selected-data-label = No hay datos seleccionados para importar
migration-selected-data-label = Importar datos seleccionados

##

migration-select-all-option-label = Seleccionar todo
migration-bookmarks-option-label = Marcadores

# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Favoritos

migration-logins-and-passwords-option-label = Inicios de sesión y contraseñas guardados
migration-history-option-label = Historial de navegación
migration-form-autofill-option-label = Datos de autocompletado de formularios

migration-passwords-from-file-progress-header = Importar archivo de contraseñas
migration-passwords-from-file-success-header = Contraseñas importadas correctamente
migration-passwords-from-file = Buscando contraseñas en el archivo
migration-passwords-new = Nuevas contraseñas
migration-passwords-updated = Contraseñas existentes

migration-passwords-from-file-picker-title = Importar archivo de contraseñas
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] Archivo CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Documento TSV
       *[other] Archivo TSV
    }

# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } agregada
       *[other] { $newEntries } agregadas
    }

# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } actualizada
       *[other] { $updatedEntries } actualizadas
    }

migration-import-button-label = Importar
migration-choose-to-import-from-file-button-label = Importar desde archivo
migration-import-from-file-button-label = Seleccionar archivo
migration-cancel-button-label = Cancelar
migration-done-button-label = Hecho
migration-continue-button-label = Continuar

migration-wizard-import-browser-no-browsers = { -brand-short-name } no ha podido encontrar ningún programa que contenga datos de marcadores, historial o contraseñas.
migration-wizard-import-browser-no-resources = Se ha producido un error. { -brand-short-name } no puede encontrar ningún dato para importar desde ese perfil de navegador.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = marcadores

# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = favoritos
migration-list-password-label = contraseñas
migration-list-history-label = historial
migration-list-autofill-label = datos de autocompletado

##

migration-wizard-progress-header = Importando datos
migration-wizard-progress-done-header = Datos importados con éxito
migration-wizard-progress-icon-in-progress =
    .aria-label = Importando…
migration-wizard-progress-icon-completed =
    .aria-label = Completado

migration-safari-password-import-header = Importar contraseñas de Safari
migration-safari-password-import-steps-header = Para importar contraseñas de Safari:
migration-safari-password-import-step1 = En Safari, abre el menú "Safari" y ve a Preferencias > Contraseñas
migration-safari-password-import-step2 = Selecciona el botón <img data-l10n-name="safari-icon-3dots"/> y elige “Exportar todas las contraseñas”
migration-safari-password-import-step3 = Guarda el archivo de contraseñas
migration-safari-password-import-step4 = Usa “Seleccionar archivo” a continuación para elegir el archivo de contraseñas que guardaste
migration-safari-password-import-skip-button = Saltar
migration-safari-password-import-select-button = Seleccionar archivo


# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } marcador
       *[other] { $quantity } marcadores
    }

# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites =
    { $quantity ->
        [one] { $quantity } favorito
       *[other] { $quantity } favoritos
    }

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } contraseña
       *[other] { $quantity } contraseñas
    }

# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Desde el último día
       *[other] De los últimos { $maxAgeInDays } días
    }

migration-wizard-progress-success-formdata = Historial de formularios

migration-wizard-safari-permissions-sub-header = Para importar marcadores e historial de navegación de Safari:
migration-wizard-safari-instructions-continue = Selecciona "Continuar"
migration-wizard-safari-instructions-folder = Selecciona la carpeta Safari en la lista y elije “Abrir”
