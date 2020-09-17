# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Jiggo Ɗoworde

import-from =
    { PLATFORM() ->
        [windows] Jiggo Cuɓe, Maantore, Aslol, Finndeeji e keɓe goɗɗe iwdi e:
       *[other] Jiggo Cuɓoraaɗe, Maantore, Aslol, Finndeeji e keɓe goɗɗe iwdi e:
    }

import-from-bookmarks = Jiggo Maantore iwɗe e:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Hoto jiggo hay baɗte
    .accesskey = H
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
    .label = Chrome Gol
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

no-migration-sources = Alaa jaaɓnirɗe jogiiɗe maantore, aslol walla finndeeji njiytaa.

import-source-page-title = Jiggo Teelte e Keɓe
import-items-page-title = Teme Jiggeteeɗe

import-items-description = Suɓo hol teme njiggetee:

import-migrating-page-title = Nana jiggoo…

import-migrating-description = Ɗee-ɗoo teme ngoni ko e jiggeede…

import-select-profile-page-title = Labo Heftinirde

import-select-profile-description = Ɗee-ɗoo keftinirɗe ena ngoodi ngam jiggaade e mum'en:

import-done-page-title = Jiggagol Gasii

import-done-description = Ɗee-ɗoo teme njiggoraama no moƴƴirta:

import-close-source-browser = Tiiɗno teeŋtin wonde wanngorde suɓaande ndee ko uddiinde hade maa jokkude.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Iwde e { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Nana Tara Doggol (Iwde e Safari)
imported-edge-reading-list = Doggol Tarol (Iwde e Safari)

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
    .label = Kenorɗe e Tabbe
browser-data-session-label =
    .value = Kenorɗe e Tabbe
