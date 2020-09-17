# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Ustani import qilish

import-from =
    { PLATFORM() ->
        [windows] Moslamalar, xatchoʻplar, tarix, parollar va boshqa ma`lumotlarni ushbu brauzerdan import qilish:
       *[other] Parametrlar, xatchoʻplar, tarix, parollar va boshqa ma`lumotlarni ushbu brauzerdan import qilish:
    }

import-from-bookmarks = Xatchoʻplarni ushbu brauzerdan import qilish:
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
    .label = Hech narsa import qilinmasin
    .accesskey = i
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
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Xatchoʻplar, tarix yoki parollar ma`lumotlari bor birorda dastur topilmadi.

import-source-page-title = Moslamalar va ma`lumotlarni import qilish
import-items-page-title = Import qilinadiganlar

import-items-description = Import qilinadiganlarni tanlash:

import-migrating-page-title = Import qilinmoqda...

import-migrating-description = Quyidagilar hozirda import qilinadi...

import-select-profile-page-title = Profilni tanlash

import-select-profile-description = Quyidagi profillar ushbu dasturdan import qilish uchun mavjud:

import-done-page-title = Butunlay import qilish

import-done-description = Quyidagilar muvaffaqiyatli import qilindi:

import-close-source-browser = Davom etishdan oldin tanlangan brauzer yopilganligiga ishonch hosil qiling.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source }dan

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Roʻyxat ("Safari"dan) oʻqilmoqda
imported-edge-reading-list = O‘qish ro‘yxati (Edge brauzeridan)

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
    .label = Oynalar va varaqlar
browser-data-session-label =
    .value = Oynalar va varaqlar
