# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Asistanto de importado

import-from =
    { PLATFORM() ->
        [windows] Importi preferojn, legosignojn, historion, pasvortojn kaj aliajn datumojn el:
       *[other] Importi preferojn, legosignojn, historion, pasvortojn kaj aliajn datumojn el:
    }

import-from-bookmarks = Importi legosignojn el:
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
    .label = Importi nenion
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
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Neniu programo, enhavanta legosignojn, historion aŭ pasvortajn datumojn, estis trovita.

import-source-page-title = Importi agordojn kaj datumojn
import-items-page-title = Elementoj importotaj

import-items-description = Elekti elementojn importotajn:

import-migrating-page-title = Importanta…

import-migrating-description = La jenaj elementoj estas nuntempe importataj…

import-select-profile-page-title = Elekti profilon

import-select-profile-description = Eblas importi el la jenaj profiloj:

import-done-page-title = Importado finita

import-done-description = La jenaj elementoj estis sukcese importitaj:

import-close-source-browser = Bonvolu certi ke la elektita retumilo estu fermita antaŭ ol daŭrigi.

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

imported-safari-reading-list = Legolisto (de Safari)
imported-edge-reading-list = Legolisto (de Edge)

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
    .label = Kuketoj
browser-data-cookies-label =
    .value = Kuketoj

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Historio de retumo kaj legosignoj
           *[other] Historio de retumo
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Historio de retumo kaj legosignoj
           *[other] Historio de retumo
        }

browser-data-formdata-checkbox =
    .label = Historio de formularoj konservita
browser-data-formdata-label =
    .value = Historio de formularoj konservita

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Legitimiloj kaj pasvortoj konservitaj
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Legitimiloj kaj pasvortoj konservitaj

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Legosignoj
            [edge] Legosignoj
           *[other] Legosignoj
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Legosignoj
            [edge] Legosignoj
           *[other] Legosignoj
        }

browser-data-otherdata-checkbox =
    .label = Aliaj datumoj
browser-data-otherdata-label =
    .label = Aliaj datumoj

browser-data-session-checkbox =
    .label = Fenestroj kaj langetoj
browser-data-session-label =
    .value = Fenestroj kaj langetoj
