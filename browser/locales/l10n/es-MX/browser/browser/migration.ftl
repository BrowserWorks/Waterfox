# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Asistente de importación

import-from =
    { PLATFORM() ->
        [windows] Importar opciones, marcadores, historial, claves y otros datos de:
       *[other] Importar preferencias, marcadores, historial, claves y otros datos de:
    }

import-from-bookmarks = Importar marcadores de:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = No importar nada
    .accesskey = N
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = No se encontraron programas que contengan marcadores, historial o contraseñas.

import-source-page-title = Importar configuraciones y datos
import-items-page-title = Elementos a importar

import-items-description = Selecciona los elementos que se importarán:

import-permissions-page-title = Por favor, dale permisos a { -brand-short-name }

# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS requiere que permitas explícitamente a { -brand-short-name } acceder a los marcadores de Safari. Haz clic en “Continuar” y selecciona el archivo “Bookmarks.plist” en el panel de abrir archivo que se mostrará.

import-migrating-page-title = Importando…

import-migrating-description = Ya se importaron los siguientes elementos…

import-select-profile-page-title = Seleccionar perfil

import-select-profile-description = Se pueden importar datos de los siguientes perfiles:

import-done-page-title = Importación completa

import-done-description = Los siguientes elementos se importaron satisfactoriamente:

import-close-source-browser = Por favor, asegúrate que el navegador seleccionado está cerrado antes de continuar.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = De { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Waterfox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Lista de lectura (de Safari)
imported-edge-reading-list = Lista de lectura (de Edge)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = Cookies
browser-data-cookies-label =
    .value = Cookies

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Historial de navegación y marcadores
           *[other] Historial de navegación
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Historial de navegación y marcadores
           *[other] Historial de navegación
        }

browser-data-formdata-checkbox =
    .label = Historial de formularios guardados
browser-data-formdata-label =
    .value = Historial de formularios guardados

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Inicios de sesión y contraseñas guardados
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Inicios de sesión y contraseñas guardados

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Marcadores
            [edge] Marcadores
           *[other] Marcadores
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Marcadores
            [edge] Marcadores
           *[other] Marcadores
        }

browser-data-otherdata-checkbox =
    .label = Otros datos
browser-data-otherdata-label =
    .label = Otros datos

browser-data-session-checkbox =
    .label = Ventanas y pestañas
browser-data-session-label =
    .value = Ventanas y pestañas
