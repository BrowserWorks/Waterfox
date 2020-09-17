# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Amarag n ukter

import-from =
    { PLATFORM() ->
        [windows] Kter iɣewwaṛen, ticṛaḍ n isebtar, azray, awalen uffiren d isefka-nniḍen seg:
       *[other] Kter ismenyifen, ticṛaḍ n isebtar, azray, awalen uffiren d isefka-nniḍen seg:
    }

import-from-bookmarks = Kter ticṛaḍ n isebtar seg:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (Ileqman iqbuṛen)
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Ur keter ara kan
    .accesskey = U
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
    .label = Chrome Beta
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Firefox
    .accesskey = x
import-from-360se =
    .label = 360 Iminig aɣelsan
    .accesskey = 3

no-migration-sources = Ulac aseɣẓan i igebren ticraḍ n yisebtar, azray, neɣ awalen uffiren ikelsen.

import-source-page-title = Aktar n iɣewwaṛen d isefka
import-items-page-title = Iferdisen ara yettwaketren

import-items-description = Fren iferdisen ara yettwaketren:

import-migrating-page-title = Aktar…

import-migrating-description = Iferdisen-a la d-ttwaktaren akka tura…

import-select-profile-page-title = Fren amaɣnu

import-select-profile-description = Imaɣnuten-a heggan iwakken ad ttwaketren seg:

import-done-page-title = Aktar immed

import-done-description = Iferdisen-a ttwaketren akken iwata:

import-close-source-browser = Ma ulac aɣilif, wali ma yella iminig-inek yemdel send ad tedduḍ deg umahil-inek.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Sɣur { $source }

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
source-name-360se = 360 Iminig aɣelsan

imported-safari-reading-list = Tabdart n tɣuṛi (seg Safari)
imported-edge-reading-list = Tabdart n tɣuṛi (seg Safari)

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
    .label = Inagan n tuqqna
browser-data-cookies-label =
    .value = Inagan n tuqqna

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Azray n tunigin d tecraḍ n yisebtar
           *[other] Azray n tunigin
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Azray n tunigin d tecraḍ n yisebtar
           *[other] Azray n tunigin
        }

browser-data-formdata-checkbox =
    .label = Yettwakles seg uzray
browser-data-formdata-label =
    .value = Yettwakles seg uzray

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Inekcam d wawalen uffiren ttwaskelsen
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Inekcam d wawalen uffiren ttwaskelsen

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Ismenyifen
            [edge] Ismenyifen
           *[other] Ticraḍ n yisebtar
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Ismenyifen
            [edge] Ismenyifen
           *[other] Ticraḍ n yisebtar
        }

browser-data-otherdata-checkbox =
    .label = Isefka-nniḍen
browser-data-otherdata-label =
    .label = Isefka-nniḍen

browser-data-session-checkbox =
    .label = Isfuyla d yiccaren
browser-data-session-label =
    .value = Isfuyla d yiccaren
