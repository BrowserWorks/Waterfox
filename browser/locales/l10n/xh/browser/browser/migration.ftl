# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Thatha Ngaphandle Umncedi

import-from =
    { PLATFORM() ->
        [windows] Thumela ekunokukhethwa kuko, iibhukhmakhi, imbali, ipasiwedi nezinye iingcombolo kwi-:
       *[other] Thumela iipriferensi, iibhukhmakhi, imbali, ipasiwedi nezinye iingcombolo kwi-:
    }

import-from-bookmarks = Thatha Ngaphandle Izalathisi Eziphawulayo ezivela:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = Musa ukuthatha nantoni ngaphandle
    .accesskey = M
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
    .label = I-360 ibhrawuza ekhuselekileyo
    .accesskey = 3

no-migration-sources = Akukho ziprogram ziqulethe iibhukhmakhi, imbali okanye iingcombolo zepasiwedi zifumanekayo.

import-source-page-title = Ngenisa iiSethingi neNgcombolo
import-items-page-title = Amanqaku afanele Ukuthathwa Ngaphandle

import-items-description = Khetha ukuba ngawaphi amanqaku anokuthathwa ngaphandle:

import-migrating-page-title = Kuthathwa ngaphandle…

import-migrating-description = Amanqaku alandelayo athathwa ngaphandle okwangoku…

import-select-profile-page-title = Khetha Inkangeleko Yesimo

import-select-profile-description = Ezi profayile zilandelayo ziyafumaneka ukuba zingathunyelwa kwi-:

import-done-page-title = Ukuthatha Ngaphandle Kugqityiwe

import-done-description = Amanqaku alandelayo athathwe ngaphandle ngempumelelo:

import-close-source-browser = Sicela uqiniseke ukuba ukhethe ibhrawza ivaliwe ngaphambi kokuqhubeka.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Ukusuka kwi-{ $source }

source-name-ie = I-Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = I-Safari
source-name-canary = Google Chrome Canary
source-name-chrome = I-Google Chrome
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = I-360 ibhrawuza ekhuselekileyo

imported-safari-reading-list = Uludwe lokufunda (ukusuka kwiSafari)
imported-edge-reading-list = Uludwe Lokufunda (ukusuka Ekupheleni)

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
    .label = I-Windows neethebhu
browser-data-session-label =
    .value = I-Windows neethebhu
