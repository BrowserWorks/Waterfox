# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Bida cendi ka dam

import-from =
    { PLATFORM() ->
        [windows] Suubarey, doo-šilbawey, šennikufaley nda bayhaya tanayaŋ bere ka hun ne:
       *[other] Ibaayey, doo-šilbawey, šennikufaley nda bayhaya tanayaŋ bere ka hun ne:
    }

import-from-bookmarks = Doo-šilbawey bere ka hun ne:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = War ma ši haya kul zaa
    .accesskey = W
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
    .label = 360 Ceecikaw saajante
    .accesskey = 3

no-migration-sources = Porogaramey kul ši kaŋ goo nda doo-šilbayyaŋ, taariki wala šennikufal kaŋ ga duwandi.

import-source-page-title = Cendi ka zaa kayandiyaney nda bayhayey
import-items-page-title = Hayiizey kaŋ ga cendi ka zaandi

import-items-description = Suuba hayiizey kaŋ ga cendi ka zaandi:

import-migrating-page-title = Cendi ga zaandi…

import-migrating-description = Hayiizey wey goo ma cenda ka zaandi…

import-select-profile-page-title = Alhal suuba

import-select-profile-description = Alhaaley wey goo no cendi ka zaa ne se:

import-done-page-title = Cendi ka zaayan timme

import-done-description = Hayiizey wey n' ka bere ka ben:

import-close-source-browser = Soobay ka ceecikaw suubantaa daabu jina ka koy jine.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Hun { $source } ra

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Ceecikaw saajante

imported-safari-reading-list = Cawhaya maašeede (Safari ra)
imported-edge-reading-list = Cawhaya maašeede (From Edge)

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
    .label = Zanfuney nda kanjey
browser-data-session-label =
    .value = Zanfuney nda kanjey
