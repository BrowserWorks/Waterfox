# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Ruto'onel K'amoj

import-from =
    { PLATFORM() ->
        [windows] Kejik' taq cha'oj, taq yaketal, natab'äl, ewan taq tzij chuqa' juley chik taq rutzij:
       *[other] Kejik' taq cha'oj, taq yaketal, natab'äl, ewan taq tzij chuqa' juley chik taq rutzij:
    }

import-from-bookmarks = Kek'am taq ch'aoj pa:
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
    .label = Majun tijik' pe
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
    .label = 360 Ütz chi K'amaya'l
    .accesskey = 3

no-migration-sources = Man tikirel ta xe'ilitäj taq cholkema' ri k'o taq yaketal, natab'äl o taq ruwäch ewan taq tzij.

import-source-page-title = Kek'am runuk'ulem chuqa' taq tzij
import-items-page-title = Taq ruch'akulal xkek'am

import-items-description = Ke'acha' achike taq ruch'akulal xekek'am:

import-migrating-page-title = Nijik…

import-migrating-description = Tajin nik'am re taq ruch'akulal re'…

import-select-profile-page-title = Tichax rub'anikil

import-select-profile-description = Tikirel yek'am taq tzij chi kikojol re taq rub'anikil re':

import-done-page-title = Xtz'aqät ruk'amik

import-done-description = Pa rub'eyal xek'am re jujun taq ruch'akulal re':

import-close-source-browser = Tab'ana' utzil, tajikib'a' awi' chi ri okik'amaya'l xacha' k'o chi tz'apäl chuwäch xtachäp chik samaj.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Richin { $source }

source-name-ie = Explorer K'amaya'l
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Ütz chi K'amaya'l

imported-safari-reading-list = Rucholajem taq sik'inem (richin ri Safari)
imported-edge-reading-list = Rucholajem taq sik'inem (richin Edge)

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
    .label = Taq kuki
browser-data-cookies-label =
    .value = Taq kuki

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Runatab'al Okem pa K'amaya'l chuqa' taq Yaketal
           *[other] Runatab'al Okem pa K'amaya'l
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Runatab'al Okem pa K'amaya'l chuqa' taq Yaketal
           *[other] Runatab'al Okem pa K'amaya'l
        }

browser-data-formdata-checkbox =
    .label = Xyak Runojwuj Natab'äl
browser-data-formdata-label =
    .value = Xyak Runojwuj Natab'äl

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Yakon Kitikirisaxik Molojri'ïl chuqa' Ewan taq Tzij
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Yakon Kitikirisaxik Molojri'ïl chuqa' Ewan taq Tzij

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Taq Ajowab'äl
            [edge] Taq Ajowab'äl
           *[other] Taq Yaketal
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Taq Ajowab'äl
            [edge] Taq Ajowab'äl
           *[other] Taq Yaketal
        }

browser-data-otherdata-checkbox =
    .label = Juley chik taq Tzij
browser-data-otherdata-label =
    .label = Juley chik taq Tzij

browser-data-session-checkbox =
    .label = Taq ruwäch chuqa' taq ruwi'
browser-data-session-label =
    .value = Taq ruwäch chuqa' taq ruwi'
