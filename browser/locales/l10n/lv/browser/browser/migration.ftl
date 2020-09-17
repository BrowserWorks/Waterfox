# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importēšanas vednis

import-from =
    { PLATFORM() ->
        [windows] Importēt iestatījumus, grāmatzīmes, vēsturi, paroles un citus datus no:
       *[other] Importēt iestatījumus, grāmatzīmes, vēsturi, paroles un citus datus no:
    }

import-from-bookmarks = Importēt grāmatzīmes no:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Neimportēt neko
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
    .label = Firefox
    .accesskey = x
import-from-360se =
    .label = 360 Drošs pārlūks
    .accesskey = 3

no-migration-sources = Nav atrasta neviena programma, no kuras importēt grāmatzīmes, vēsturi vai paroļu informāciju.

import-source-page-title = Importēt iestatījumus un datus
import-items-page-title = Importējamie elementi

import-items-description = Izvēlieties importējamos elementus:

import-migrating-page-title = Notiek importēšana...

import-migrating-description = Tiek importēti izvēlētie elementi...

import-select-profile-page-title = Izvēlieties profilu

import-select-profile-description = Datus var importēt no šiem profiliem:

import-done-page-title = Importēšana ir pabeigta

import-done-description = Tika sekmīgi importēti:

import-close-source-browser = Lūdzu pārliecinieties ka izvēlētais pārlūks ir aizvērts pirms turpināt.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = No { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Drošs pārlūks

imported-safari-reading-list = Lasāmo lietu saraksts (No Safari)
imported-edge-reading-list = Lasāmo lietu saraksts (No Edge)

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
    .label = Logus un cilnes
browser-data-session-label =
    .value = Logus un cilnes
