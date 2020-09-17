# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Ganukuo' ga'an

import-from =
    { PLATFORM() ->
        [windows] Ganukuo' markador, riña gaché nu', da'ngà huìi ni a'ngò si dato:
       *[other] Ganukuo', preferensia, markador, riña gaché nu', da'ngà huìi ni a'ngò si dato:
    }

import-from-bookmarks = Ganukuo' markador:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Nitaj si gahuin
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
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Nū nari' ma nej programa nikaj markador, riña gaché nu' nej si da'ngà huìi.

import-source-page-title = Ganukuo' konfigurasiôn ni nej dato
import-items-page-title = Nej sa ganukuo'

import-items-description = Ganahui nej sa hui ruat ganukuajt:

import-migrating-page-title = 'Ngà anukuaj ma...

import-migrating-description = Nej na huin sa 'ngà ganukuaj ma...

import-select-profile-page-title = Nagui Perfil

import-select-profile-description = Ga'ue ganukuo' nej sa ma ñuna:

import-done-page-title = 'Ngà gisij ganukuaj ma

import-done-description = Hue'ê chre ganukuaj ma:

import-close-source-browser = Gi'iaj suntuj u ni gini'iaj si 'ngà arán navegador na hìaj ni gachin ga'anjt ne'ñaan.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Riña { $source }

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

imported-safari-reading-list = Nej sa ahio' (si'iaj Safari)
imported-edge-reading-list = Nej sa ahio' (si'iaj Edge)

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
    .label = Ventana ni rakïj nanj
browser-data-session-label =
    .value = Ventana ni rakïj nanj
