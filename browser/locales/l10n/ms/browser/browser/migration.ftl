# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Bestari Import

import-from =
    { PLATFORM() ->
        [windows] Import Pilihan, Tandabuku, Sejarah, Kata laluan dan lain-lain data dari:
       *[other] Import Keutamaan, Tandabuku, Sejarah, Kata laluan dan lain-lain data dari:
    }

import-from-bookmarks = Import Tandabuku dari:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Jangan import apa-apa
    .accesskey = t
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
    .label = 360 Pelayar Selamat
    .accesskey = 3

no-migration-sources = Tiada atur cara yang mengandungi tandabuku, sejarah atau data kata laluan yang dapat ditemui.

import-source-page-title = Import Tetapan dan Data
import-items-page-title = Item untuk Diimport

import-items-description = Pilih item yang mahu diimport:

import-migrating-page-title = Mengimport…

import-migrating-description = Item berikut sedang diimport…

import-select-profile-page-title = Pilih Profil

import-select-profile-description = Profil berikut tersedia untuk diimport dari:

import-done-page-title = Selesai Mengimport

import-done-description = Item berikut telah berjaya diimport:

import-close-source-browser = Sila pastikan pelayar yang dipilih telah ditutup sebelum meneruskan.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Dari { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Pelayar Selamat

imported-safari-reading-list = Senarai Membaca (Dari Safari)
imported-edge-reading-list = Senarai Membaca (Dari Safari)

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
    .label = Tetingkap dan Tab
browser-data-session-label =
    .value = Tetingkap dan Tab
