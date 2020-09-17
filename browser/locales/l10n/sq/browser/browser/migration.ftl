# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Ndihmës Importimesh

import-from =
    { PLATFORM() ->
        [windows] Importo Mundësi, Faqerojtës, Historik, Fjalëkalime dhe të dhëna të tjera nga:
       *[other] Importo Parapëlqime, Faqerojtës, Historik, Fjalëkalime dhe të dhëna të tjera prej:
    }

import-from-bookmarks = Importo Faqerojtës nga:
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
    .label = Mos importo gjë
    .accesskey = J
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
    .accesskey = F
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Nuk u gjetën dot programe që përmbajnë faqerojtës, historik apo fjalëkalime.

import-source-page-title = Importo Rregullime dhe Të dhëna
import-items-page-title = Objekte për Importim

import-items-description = Përzgjidhni cilët objekte të importohen:

import-migrating-page-title = Po importohet…

import-migrating-description = Po importohen objektet vijuese…

import-select-profile-page-title = Përzgjidhni Profil

import-select-profile-description = Është e mundur të importohen profilet vijues:

import-done-page-title = Importim i Plotësuar

import-done-description = Objektet vijuese u importuan me sukses:

import-close-source-browser = Ju lutemi, para se të vazhdohet, sigurohuni që shfletuesi i përzgjedhur të jetë i mbyllur.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Nga { $source }

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

imported-safari-reading-list = Listë Leximesh (Prej Safari-t)
imported-edge-reading-list = Listë Leximesh (Prej Edge-it)

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
    .label = Cookies
browser-data-cookies-label =
    .value = Cookies

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Historik Shfletimi dhe Faqerojtës
           *[other] Historik Shfletimi
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Historik Shfletimi dhe Faqerojtës
           *[other] Historik Shfletimi
        }

browser-data-formdata-checkbox =
    .label = Historik Formularësh të Ruajtur
browser-data-formdata-label =
    .value = Historik Formularësh të Ruajtur

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Kredenciale Hyrjesh dhe Fjalëkalime të Ruajtur
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Kredenciale Hyrjesh dhe Fjalëkalime të Ruajtur

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Të parapëlqyer
            [edge] Të parapëlqyer
           *[other] Faqerojtës
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Të parapëlqyer
            [edge] Të parapëlqyer
           *[other] Faqerojtës
        }

browser-data-otherdata-checkbox =
    .label = Të dhëna të Tjera
browser-data-otherdata-label =
    .label = Të dhëna të Tjera

browser-data-session-checkbox =
    .label = Dritare dhe Skeda
browser-data-session-label =
    .value = Dritare dhe Skeda
