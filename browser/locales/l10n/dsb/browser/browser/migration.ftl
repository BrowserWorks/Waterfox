# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importowy zastojnik

import-from =
    { PLATFORM() ->
        [windows] Nastajenja, cytańske znamjenja, historiju, gronidła a hynakše daty importěrowaś z:
       *[other] Nastajenja, cytańske znamjenja, historiju, gronidła a hynakše daty importěrowaś z:
    }

import-from-bookmarks = Cytańske znamjenja importěrowaś z:
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
    .label = Nic njeimportěrowaś
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
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Žedne programy namakane, kótarež wopśimuju cytańske znamjenja, historiju abo gronidła.

import-source-page-title = Daty a nastajenja importěrowaś
import-items-page-title = Objekty za importěrowanje

import-items-description = Wubjeŕśo objekty za importěrowanje:

import-migrating-page-title = Importěrujo se…

import-migrating-description = Slědujuce objekty se rowno importěruju…

import-select-profile-page-title = Profil wubraś

import-select-profile-description = Slědujuce profile stoje k dispoziciji za importěrowanje z:

import-done-page-title = Importěrowanje dokóńćone

import-done-description = Slědujuce objekty su se z wuspěchom importěrowali:

import-close-source-browser = Pšosym zawěsććo, až wubrany wobglědowak jo zacynjony, nježli až pókšacujośo.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Z { $source }

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

imported-safari-reading-list = Cytańska lisćina (ze Safari)
imported-edge-reading-list = Cytańska lisćina (z Edge)

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
    .label = Cookieje
browser-data-cookies-label =
    .value = Cookieje

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Pśeglědowańska historija a cytańske znamjenja
           *[other] Pśeglědowańska historija
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Pśeglědowańska historija cytańske znamjenja
           *[other] Pśeglědowańska historija
        }

browser-data-formdata-checkbox =
    .label = Skłaźona formularna historija
browser-data-formdata-label =
    .value = Skłaźona formularna historija

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Skłaźone pśizjawjenja a gronidła
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Skłaźone pśizjawjenja a gronidła

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Fawority
            [edge] Fawority
           *[other] Cytańske znamjenja
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Fawority
            [edge] Fawority
           *[other] Cytańske znamjenja
        }

browser-data-otherdata-checkbox =
    .label = Druge daty
browser-data-otherdata-label =
    .label = Druge daty

browser-data-session-checkbox =
    .label = Wokna a rejtariki
browser-data-session-label =
    .value = Wokna a rejtariki
