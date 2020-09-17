# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Ohjattu profiilin tuonti

import-from =
    { PLATFORM() ->
        [windows] Tuo asetukset, kirjanmerkit, sivuhistoria, salasanat ja muut tiedot ohjelmasta:
       *[other] Tuo asetukset, kirjanmerkit, sivuhistoria, salasanat ja muut tiedot ohjelmasta:
    }

import-from-bookmarks = Tuo kirjanmerkit ohjelmasta:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge, vanhennettu versio
    .accesskey = v
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Älä tuo mitään
    .accesskey = Ä
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

no-migration-sources = Ei löydetty ohjelmia, joista voitaisiin hakea kirjanmerkkejä, sivuhistoriaa tai salasanoja.

import-source-page-title = Asetusten ja tietojen tuonti ohjelmasta
import-items-page-title = Tuotavat tiedot

import-items-description = Valitse tuotavat tiedot:

import-migrating-page-title = Tuodaan…

import-migrating-description = Seuraavia tietoja tuodaan…

import-select-profile-page-title = Valitse profiili

import-select-profile-description = Seuraavat profiilit voidaan tuoda ohjelmista:

import-done-page-title = Tuonti valmis

import-done-description = Seuraavat tiedot tuotiin:

import-close-source-browser = Varmista, että valittu selain on suljettu ennen kuin jatkat.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Ohjelmasta { $source }

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

imported-safari-reading-list = Lukulista (Safarista)
imported-edge-reading-list = Lukulista (Edgestä)

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
    .label = Evästeet
browser-data-cookies-label =
    .value = Evästeet

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Sivuhistoria ja kirjanmerkit
           *[other] Sivuhistoria
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Sivuhistoria ja kirjanmerkit
           *[other] Sivuhistoria
        }

browser-data-formdata-checkbox =
    .label = Tallennetut lomaketiedot
browser-data-formdata-label =
    .value = Tallennetut lomaketiedot

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Tallennetut käyttäjätunnukset ja salasanat
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Tallennetut käyttäjätunnukset ja salasanat

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Suosikit
            [edge] Suosikit
           *[other] Kirjanmerkit
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Suosikit
            [edge] Suosikit
           *[other] Kirjanmerkit
        }

browser-data-otherdata-checkbox =
    .label = Muut tiedot
browser-data-otherdata-label =
    .label = Muut tiedot

browser-data-session-checkbox =
    .label = Ikkunat ja välilehdet
browser-data-session-label =
    .value = Ikkunat ja välilehdet
