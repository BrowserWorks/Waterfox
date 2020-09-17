# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Skoazeller Enporzhiañ

import-from =
    { PLATFORM() ->
        [windows] Enporzhiañ an dibarzhioù, sinedoù, roll istor, gerioù-tremen ha roadennoù all adalek :
       *[other] Enporzhiañ an dibaboù gwellañ, sinedoù, roll istor, gerioù-tremen ha roadennoù all diouzh :
    }

import-from-bookmarks = Enporzhiañ sinedoù diouzh :
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (handelvoù kozh)
    .accesskey = M
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = B
import-from-nothing =
    .label = Na enporzhiañ tra ebet
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
    .label = Merdeer diogel 360
    .accesskey = 3

no-migration-sources = N'hall ket kavout goulev ebet a zo ennañ sinedoù, rolladoù istor pe gerioù-tremen.

import-source-page-title = Enporzhiañ arventennoù ha roadennoù diouzh …
import-items-page-title = Ergorennoù da enporzhiañ

import-items-description = Diuz pe elfennoù da enporzhiañ :

import-migrating-page-title = Oc'h enporzhiañ …

import-migrating-description = Emañ an ergorennoù da heul o vezañ enporzhiet…

import-select-profile-page-title = Diuz an aelad

import-select-profile-description = An aeladoù da heul a c'hell bezañ enporzhiet diouzh :

import-done-page-title = Echu eo an enporzhiañ

import-done-description = Enporzhiet eo bet an ergorennoù da heul gant berzh :

import-close-source-browser = Gwiriekait eo serret ar merdeer diuzet a-raok kenderc'hel.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Diouzh { $source }

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
source-name-360se = Merdeer diogel 360

imported-safari-reading-list = Roll al lennadurioù (diouzh Safari)
imported-edge-reading-list = Roll al lennadurioù (diouzh Edge)

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
    .label = Toupinoù
browser-data-cookies-label =
    .value = Toupinoù

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Roll istor merdeiñ ha sinedoù
           *[other] Roll istor merdeiñ
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Roll istor merdeiñ ha sineoù
           *[other] Roll istor merdeiñ
        }

browser-data-formdata-checkbox =
    .label = Roll istor ar furmskridoù enrollet
browser-data-formdata-label =
    .value = Roll istor ar furmskridoù enrollet

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Titouroù kennaskañ enrollet
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Titouroù kennaskañ enrollet

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Sinedoù
            [edge] Sinedoù
           *[other] Sinedoù
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Sinedoù
            [edge] Sinedoù
           *[other] Sinedoù
        }

browser-data-otherdata-checkbox =
    .label = Roadennoù all
browser-data-otherdata-label =
    .label = Roadennoù all

browser-data-session-checkbox =
    .label = Prenestroù hag ivinelloù
browser-data-session-label =
    .value = Prenestroù hag ivinelloù
