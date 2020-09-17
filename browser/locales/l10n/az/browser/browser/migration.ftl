# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = İdxal sehirbazı

import-from =
    { PLATFORM() ->
        [windows] Seçimləri, Əlfəcinləri, Tarixçəni, Parolları və digər məlumatları buradan idxal et:
       *[other] Nizamlamaları, Əlfəcinləri, Tarixçəni, Parolları və digər məlumatları buradan idxal et:
    }

import-from-bookmarks = Əlfəcinləri buradan idxal et:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Heç nə idxal etmə
    .accesskey = m
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

no-migration-sources = Əlfəcinlərin, tarixçənin və ya parol məlumatlarının qeyd edildiyi heç bir proqram tapılmadı.

import-source-page-title = Nizamlamaları və məlumatları idxal etmə
import-items-page-title = İdxal ediləcək obyektlər

import-items-description = İdxal ediləcək obyektləri seçin:

import-migrating-page-title = İdxal edilir…

import-migrating-description = Aşağıdakı obyektlər uğurla idxal edildi…

import-select-profile-page-title = Profil Seçin

import-select-profile-description = Aşağıdakı profilləri buradan idxal edilə bilər:

import-done-page-title = İdxal tamamlandı

import-done-description = Aşağıdakı obyektlər uğurla idxal edildi:

import-close-source-browser = Davam etməzdən əvvəl seçilən səyyahın qapalı olduğundan əmin olun.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Buradan: { $source }

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

imported-safari-reading-list = Oxuma siyahısı (Safaridən)
imported-edge-reading-list = Oxuma siyahısı (Edge-dən)

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
    .label = Pəncərələr və vərəqlər
browser-data-session-label =
    .value = Pəncərələr və vərəqlər
