# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importimise nõustaja

import-from =
    { PLATFORM() ->
        [windows] Sätete, järjehoidjate, ajaloo, paroolide ja muude andmete importimine rakendusest:
       *[other] Eelistuste, järjehoidjate, ajaloo, paroolide ja muude andmete importimine rakendusest:
    }

import-from-bookmarks = Järjehoidjate importimine rakendusest:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Midagi ei impordita
    .accesskey = d
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

no-migration-sources = Rakendusi, mis sisaldavad järjehoidjaid, ajalugu või paroole, ei leitud.

import-source-page-title = Sätete ja andmete importimine
import-items-page-title = Imporditavad elemendid

import-items-description = Vali, millised elemendid imporditakse:

import-migrating-page-title = Importimine...

import-migrating-description = Toimub järgnevate elementide importimine...

import-select-profile-page-title = Profiili valimine

import-select-profile-description = Importimiseks on saadaval järgnevad profiilid:

import-done-page-title = Importimine on lõpetatud

import-done-description = Järgnevate elementide importimine õnnestus:

import-close-source-browser = Enne jätkamist kontrolli, et valitud brauser oleks suletud.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Rakendusest { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Lugemisnimekiri (Safarist)
imported-edge-reading-list = Lugemisnimekiri (Edge'ist)

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
    .label = Aknad ja kaardid
browser-data-session-label =
    .value = Aknad ja kaardid
