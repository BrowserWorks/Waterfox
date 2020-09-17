# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Kel Wizard ki woko

import-from =
    { PLATFORM() ->
        [windows] Gin ayera me Kelo ki woko, Alama me buk, Gin mukato, Mung me donyo kacel ki tic mogo ki bot:
       *[other] Kel ki woko ter, Alama me buk, Gin mukato, Mung me donyo kacel ki tic mogo kibot:
    }

import-from-bookmarks = Kel Alama buk kiwoko ki bot:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Pe ikel gin mo ki woko
    .accesskey = P
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
    .label = 360 layeny ma tye ki ber bedo
    .accesskey = 3

no-migration-sources = Pe tye purugram mo matye ki tic me alama buk, gin mukato onyo mung me donyo ma kiromo nongo.

import-source-page-title = Kel Ter kacel ki Tic ki woko
import-items-page-title = Jami me akela ki woko

import-items-description = Yer jami me akela ki woko:

import-migrating-page-title = Kelo ki woko…

import-migrating-description = Jami magi kombedi kitye ka kelo ki woko…

import-select-profile-page-title = Yer Profile

import-select-profile-description = Profile magi nonge me kel ki iye:

import-done-page-title = Kel ki woko otum

import-done-description = Jami magi okele maber ki woko:

import-close-source-browser = Tim ber inen ni layeny ma kiyero ni kiloro woko mapud pe imede anyim.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Ki i { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 layeny ma tye ki ber bedo

imported-safari-reading-list = Kwano nying (Ki i Safari)
imported-edge-reading-list = Jami akwana (Ki i Edge)

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
    .label = Dirica ki dirica matino
browser-data-session-label =
    .value = Dirica ki dirica matino
