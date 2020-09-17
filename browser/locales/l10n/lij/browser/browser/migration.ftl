# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Proçedua goidâ de inportaçion

import-from =
    { PLATFORM() ->
        [windows] Inportaçion de preferense, segnalibbri, stöia, paròlle segrete e atri dæti da:
       *[other] Inpòrta preferense, segnalibbri, stöia, paròlle segrete e atri dæti da:
    }

import-from-bookmarks = Inpòrta segnalibbri da:
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
    .accesskey = B
import-from-nothing =
    .label = No inportâ ninte
    .accesskey = N
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = h
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
    .label = Navegatô Seguo 360
    .accesskey = 3

no-migration-sources = Nisciunn-a aplicaçion che a contegne di segnalibbri, stöia ò paròlle segrete peu ese trova.

import-source-page-title = Inportaçion de preferense e dæti
import-items-page-title = Ògetti da inportâ

import-items-description = Seleçionn-a i ògetti da inporta:

import-migrating-page-title = Inpòrto…

import-migrating-description = Sti ògetti son li pe ese inportæ…

import-select-profile-page-title = Seleçionn-a profî

import-select-profile-description = Sti profî se peuan inportâ da:

import-done-page-title = Inportaçion terminâ

import-done-description = Sti ògetti son stæti inportæ:

import-close-source-browser = Aseguase che o navegatô seleçionou o segge serou primma de anâ avanti.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Da { $source }

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

imported-safari-reading-list = lista de letue (Da Safari)
imported-edge-reading-list = lista de letue (da Edge)

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
    .label = Cookie
browser-data-cookies-label =
    .value = Cookie

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Segnalibbri
            [edge] Segnalibbri
           *[other] Segnalibbri
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Segnalibbri
            [edge] Segnalibbri
           *[other] Segnalibbri
        }

browser-data-otherdata-checkbox =
    .label = Atri dæti
browser-data-otherdata-label =
    .label = Atri dæti

browser-data-session-checkbox =
    .label = Barcoin e feuggi
browser-data-session-label =
    .value = Barcoin e feuggi
