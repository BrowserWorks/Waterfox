# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Import Wizard
import-from =
    { PLATFORM() ->
        [windows] Mag-import ng mga Option, Bookmark, Kasaysayan, Password at iba pang data mula sa:
       *[other] I-import ang mga Kagustuhan, Bookmarks, History, Passwords atbp. mula sa:
    }
import-from-bookmarks = I-angkat ang mga Bookmark mula sa:
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
    .label = Don't import anything
    .accesskey = D
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
    .label = 360 Ligtas na Browser
    .accesskey = 3
no-migration-sources = Walang mahanap na application na naglalaman ng bookmark, history o password data.
import-source-page-title = Mag-import ng mga Setting at Data
import-items-page-title = Mga item na Iimport
import-items-description = Pumili kung aling item ang i-import:
import-migrating-page-title = Ini-import...
import-migrating-description = Ang mga sumusunod na mga bagay ay kasalukuyang inaangkat
import-select-profile-page-title = Piliin ang Profile
import-select-profile-description = Ang mga sumusunod na mga profile ay pweden i-import mula sa:
import-done-page-title = Nakumpleto na ang Pag-angkat
import-done-description = Ang mga sumusunod na mga bagay ay matagumpay na naiangkat :
import-close-source-browser = Siguruhing ang piniling browser ay nakasara bago magpatuloy.
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Mula sa { $source }
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
imported-safari-reading-list = Listahan ng Babasahin (Mula sa Safari)
imported-edge-reading-list = Listahan ng Babasahin (Mula sa Edge)

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
    .label = Mga cookie
browser-data-cookies-label =
    .value = Cookies
browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Kasaysayan at mga Bookmark
           *[other] Kasaysayan
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Kasaysayan at mga Bookmark
           *[other] Kasaysayan
        }
browser-data-formdata-checkbox =
    .label = Naka-save na Form History
browser-data-formdata-label =
    .value = Naka-save na Form History
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Naka-save na mga Login at Password
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Naka-save na mga Login at Password
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Mga Favorite
            [edge] Mga Favorite
           *[other] Mga Bookmark
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Mga Favorite
            [edge] Mga Favorite
           *[other] Mga Bookmark
        }
browser-data-otherdata-checkbox =
    .label = Iba Pang Data
browser-data-otherdata-label =
    .label = Iba Pang Data
browser-data-session-checkbox =
    .label = Mga Window at mga tab
browser-data-session-label =
    .value = Mga Window at mga tab
