# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Assistent d'importacion

import-from =
    { PLATFORM() ->
        [windows] Importar las opcions, los marcapaginas, l'istoric, los mots de pas e las autras donadas de :
       *[other] Importar las preferéncias, los marcapaginas, l'istoric, los senhals e las autras donadas de :
    }

import-from-bookmarks = Importar los marcapaginas de :
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge ancian
    .accesskey = a
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Importar pas res
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
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Impossible de trobar un logicial que contenga de marcapaginas, un istoric o de senhals.

import-source-page-title = Importar los paramètres e las donadas
import-items-page-title = Elements d'importar

import-items-description = Seleccionatz los elements d'importar :

import-migrating-page-title = Importacion…

import-migrating-description = Los elements seguents son a s'importar…

import-select-profile-page-title = Causissètz un perfil

import-select-profile-description = Los perfils seguents son disponibles per èsser importats :

import-done-page-title = Importacion acabada

import-done-description = Los elements seguents son estats importats amb succès :

import-close-source-browser = Abans de contunhar, asseguratz-vos que lo navegador seleccionat siá tampat

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = A partir de { $source }

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
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

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
            [firefox] Istoric de navegacion e marcapaginas
           *[other] Istoric de navegacion
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Istoric de navegacion e marcapaginas
           *[other] Istoric de navegacion
        }

browser-data-formdata-checkbox =
    .label = Donadas de formularis enregistradas
browser-data-formdata-label =
    .value = Donadas de formularis enregistradas

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Identificants salvats e senhals
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Identificants salvats e senhals

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favorits
            [edge] Favorits
           *[other] Marcapaginas
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favorits
            [edge] Favorits
           *[other] Marcapaginas
        }

browser-data-otherdata-checkbox =
    .label = Autras donadas
browser-data-otherdata-label =
    .label = Autras donadas

browser-data-session-checkbox =
    .label = Fenèstras e onglets
browser-data-session-label =
    .value = Fenèstras e onglets
