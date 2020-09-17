# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Čarovnik za uvoz

import-from =
    { PLATFORM() ->
        [windows] Uvozi možnosti, zaznamke, zgodovino, gesla in ostale podatke iz:
       *[other] Uvozi nastavitve, zaznamke, zgodovino, gesla in ostale podatke iz:
    }

import-from-bookmarks = Uvozi zaznamke iz:
import-from-ie =
    .label = Microsoft Internet Explorerja
    .accesskey = M
import-from-edge =
    .label = Microsoft Edga
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (starejše različice)
    .accesskey = s
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = B
import-from-nothing =
    .label = Ne uvozi ničesar
    .accesskey = N
import-from-safari =
    .label = Safarija
    .accesskey = S
import-from-canary =
    .label = Chrome Canaryja
    .accesskey = n
import-from-chrome =
    .label = Chroma
    .accesskey = C
import-from-chrome-beta =
    .label = Chroma Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chroma Dev
    .accesskey = D
import-from-chromium =
    .label = Chromiuma
    .accesskey = u
import-from-firefox =
    .label = Firefoxa
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Ni bilo mogoče najti nobenega programa z zaznamki, zgodovino ali gesli za uvoz.

import-source-page-title = Uvoz nastavitev in podatkov
import-items-page-title = Možnosti uvoza

import-items-description = Izberite, kaj želite uvoziti:

import-migrating-page-title = Uvoz ...

import-migrating-description = Trenutno se uvaža ...

import-select-profile-page-title = Izbira profila

import-select-profile-description = Uvoz je možen iz naslednjih profilov:

import-done-page-title = Konec uvoza

import-done-description = Uspešno je bilo uvoženo naslednje:

import-close-source-browser = Pred nadaljevanjem se prepričajte, da je izbrani brskalnik zaprt.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Od { $source }

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

imported-safari-reading-list = Bralni seznam (iz Safarija)
imported-edge-reading-list = Bralni seznam (iz Edgea)

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
    .label = Piškotke
browser-data-cookies-label =
    .value = Piškotke

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Zgodovino brskanja in zaznamke
           *[other] Zgodovino brskanja
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Zgodovino brskanja in zaznamke
           *[other] Zgodovino brskanja
        }

browser-data-formdata-checkbox =
    .label = Shranjene obrazce
browser-data-formdata-label =
    .value = Shranjene obrazce

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Shranjene prijave in gesla
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Shranjene prijave in gesla

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Priljubljene
            [edge] Priljubljene
           *[other] Zaznamke
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Priljubljene
            [edge] Priljubljene
           *[other] Zaznamke
        }

browser-data-otherdata-checkbox =
    .label = Druge podatke
browser-data-otherdata-label =
    .label = Druge podatke

browser-data-session-checkbox =
    .label = Okna in zavihki
browser-data-session-label =
    .value = Okna in zavihki
