# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Invoerslimmerd

import-from =
    { PLATFORM() ->
        [windows] Voer opsies, boekmerke, geskiedenis, wagwoorde en ander data in vanaf:
       *[other] Voer voorkeure, boekmerke, geskiedenis, wagwoorde en ander data in vanaf:
    }

import-from-bookmarks = Voer boekmerke in vanaf:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Moenie enigiets invoer nie
    .accesskey = M
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
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Geen programme wat boekmerke, geskiedenis of wagwoorddata bevat, kon gevind word nie.

import-source-page-title = Voer opstelling en data in
import-items-page-title = Items om in te voer

import-items-description = Merk watter items ingevoer moet word:

import-migrating-page-title = Voer tans in…

import-migrating-description = Die volgende items word tans ingevoer…

import-select-profile-page-title = Kies profiel

import-select-profile-description = Die volgende profiele kan ingevoer word vanaf:

import-done-page-title = Invoer afgehandel

import-done-description = Die volgende items is suksesvol ingevoer:

import-close-source-browser = Maak seker dat die gekose blaaier toe is voordat u voortgaan.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Vanaf { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Leeslys (van Safari)
imported-edge-reading-list = Leeslys (van Edge)

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
    .label = Vensters en oortjies
browser-data-session-label =
    .value = Vensters en oortjies
