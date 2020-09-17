# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Treoraí Iompórtála

import-from =
    { PLATFORM() ->
        [windows] Iompórtáil Roghanna, Leabharmharcanna, Stair, Focail Fhaire agus sonraí eile ó:
       *[other] Iompórtáil Sainroghanna, Leabharmharcanna, Stair, Focail Fhaire agus sonraí eile ó:
    }

import-from-bookmarks = Iompórtáil comhad leabharmharc ó:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Ná hiompórtáil rud ar bith
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
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Firefox
    .accesskey = x
import-from-360se =
    .label = Brabhsálaí Slán 360
    .accesskey = 3

no-migration-sources = Níorbh fhéidir ríomhchláir ina bhfuil leabharmharcanna, stair nó sonraí focal faire a aimsiú.

import-source-page-title = Iompórtáil Socruithe agus Sonraí
import-items-page-title = Rudaí le hIompórtáil

import-items-description = Roghnaigh na rudaí le hiompórtáil:

import-migrating-page-title = Á nIompórtáil…

import-migrating-description = Tá na rudaí seo á n-iompórtáil faoi láthair…

import-select-profile-page-title = Roghnaigh Próifíl

import-select-profile-description = Próifílí le fáil ónar féidir a iompórtáil:

import-done-page-title = Iompórtáil curtha i gcrích

import-done-description = Iompórtáladh na rudaí seo go rathúil:

import-close-source-browser = Bí cinnte go bhfuil an brabhsálaí a roghnaigh tú dúnta sula leanfaidh tú ar aghaidh.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Ó { $source }:

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = Brabhsálaí Slán 360

imported-safari-reading-list = Liosta Léitheoireachta (ó Safari)
imported-edge-reading-list = Liosta Léitheoireachta (ó Edge)

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
    .label = Fuinneoga agus Cluaisíní
browser-data-session-label =
    .value = Fuinneoga agus Cluaisíní
