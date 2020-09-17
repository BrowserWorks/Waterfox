# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Asistent d'importación

import-from =
    { PLATFORM() ->
        [windows] Importar opcions, marcapachinas, historial, claus y atros datos de:
       *[other] Importar preferencias, marcapachinas, historial, claus y atros datos de:
    }

import-from-bookmarks = Importar os marcapachinas de:
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
    .label = No importar cosa
    .accesskey = p
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
    .label = Firefox
    .accesskey = x
import-from-360se =
    .label = Navegador seguro 360
    .accesskey = 3

no-migration-sources = No s'ha trobau garra programa que contenese marcapachinas, historial u datos de claus.

import-source-page-title = Importar a configuración y os datos
import-items-page-title = Elementos a importar

import-items-description = Seleccione qué elementos quiere importar:

import-migrating-page-title = Se ye importando…

import-migrating-description = Os siguients elementos se son importando agora…

import-select-profile-page-title = Seleccionar perfil

import-select-profile-description = Os siguients perfils son disponibles ta importar-los dende:

import-done-page-title = Fin d'a importación

import-done-description = Os siguients elementos s'han importau correctament:

import-close-source-browser = Asegure-se de que o navegador trigau ye zarrau antes de continar.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Dende o { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = Navegador seguro 360

imported-safari-reading-list = Lista de lectura (dende o Safari)
imported-edge-reading-list = Lista de lectura (dende Edge)

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
            [firefox] Historial de navegación y marcapachinas
           *[other] Historial de navegación
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] HIstorial de navegación y marcapachinas
           *[other] Historial de navegación
        }

browser-data-formdata-checkbox =
    .label = Historial de formularios alzaus
browser-data-formdata-label =
    .value = Historial de formularios alzaus

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Inicios de sesión y claus alzaus
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Inicios de sesión y claus alzaus

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favoritos
            [edge] Favoritos
           *[other] Marcapachinas
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favoritos
            [edge] Favoritos
           *[other] Marcapachinas
        }

browser-data-otherdata-checkbox =
    .label = Atros datos
browser-data-otherdata-label =
    .label = Atros datos

browser-data-session-checkbox =
    .label = Finestras y pestanyas
browser-data-session-label =
    .value = Finestras y pestanyas
