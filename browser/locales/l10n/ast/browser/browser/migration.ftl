# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Encontu pa importar

import-from =
    { PLATFORM() ->
        [windows] Importar opciones, marcadores, historial, contraseñes y otros datos de:
       *[other] Importar preferencies, marcadores, historial, contraseñes y otros datos de:
    }

import-from-bookmarks = Importar marcadores de:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Nun importar nada
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
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Firefox
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Nun pudieron alcontrase programes que contuvieran marcadores, historial o datos de contraseñes.

import-source-page-title = Importar axustes y datos
import-items-page-title = Elementos a importar

import-items-description = Esbilla qué elementos importar:

import-migrating-page-title = Importando…

import-migrating-description = Anguaño tán importándose los elementos de darréu…

import-select-profile-page-title = Esbillar perfil

import-select-profile-description = Los perfiles de darréu tán disponibles pa importar dende:

import-done-page-title = Importación completada

import-done-description = Importáronse con ésitu los elementos de darréu:

import-close-source-browser = Asegúrate que'l restolador esbilláu ta zarráu enantes de siguir, por favor.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = De { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Llista de llectura (de Safari)
imported-edge-reading-list = Llista de llectura (d'Edge)

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

browser-data-session-checkbox =
    .label = Ventanes y llingüetes
browser-data-session-label =
    .value = Ventanes y llingüetes
