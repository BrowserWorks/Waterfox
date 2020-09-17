# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Assistente de importation

import-from =
    { PLATFORM() ->
        [windows] Importar le optiones, marcapaginas, chronologia, contrasignos e altere datos de:
       *[other] Importar preferentias, marcapaginas, chronologia, contrasignos e altere datos de:
    }

import-from-bookmarks = Importar le marcapaginas de:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (ancian versiones)
    .accesskey = a
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Importar nihil
    .accesskey = n
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
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Nulle programmas que contine marcapaginas, chronologia o contrasigno ha essite trovate.

import-source-page-title = Importar parametros e datos
import-items-page-title = Elementos a importar

import-items-description = Selige le datos a importar:

import-migrating-page-title = Importante…

import-migrating-description = Le importation del elementos sequente es in curso…

import-select-profile-page-title = Seliger un profilo

import-select-profile-description = Le profilos sequente es disponibile a importar:

import-done-page-title = Importation complete

import-done-description = Le elementos sequente ha essite importate con successo:

import-close-source-browser = Per favor assecura te que le navigator seligite es claudite ante de continuar.

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
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Lista de lectura (ab Safari)
imported-edge-reading-list = Lista de lectura (ab Edge)

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
            [firefox] Chronologia de navigation e marcapaginas
           *[other] Chronologia de navigation
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Chronologia de navigation e marcapaginas
           *[other] Chronologia de navigation
        }

browser-data-formdata-checkbox =
    .label = Chronologia de formularios salvate
browser-data-formdata-label =
    .value = Chronologia de formularios salvate

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Credentiales e contrasignos salvate
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Credentiales e contrasignos salvate

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favorite
            [edge] Favorite
           *[other] Marcapaginas
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favorite
            [edge] Favorite
           *[other] Marcapaginas
        }

browser-data-otherdata-checkbox =
    .label = Altere datos
browser-data-otherdata-label =
    .label = Altere datos

browser-data-session-checkbox =
    .label = Fenestras e schedas
browser-data-session-label =
    .value = Fenestras e schedas
