# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = विझार्ड आयात करा

import-from =
    { PLATFORM() ->
        [windows] पर्याय, वाचनखूणा, इतिहास, पासवर्ड व इतर माहिती येथून आयात करा:
       *[other] याअाधी वापरात असलेली आवडीनिवडी, वाचनखूणा, इतिहास, पासवर्ड व इतर) माहिती येथून आयात करा:
    }

import-from-bookmarks = वाचनखूणा येथून आयात करा:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = काहिही आयात करू नका
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
    .label = Chrome बीटा
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
    .label = 360 सुरक्षित ब्राउझर
    .accesskey = 3

no-migration-sources = वाचनखूणा, इतिहास किंवा पासवर्ड विषयी माहिती देणारे कुठलेही कार्यक्रम आढळले नाही.

import-source-page-title = आवडीनिवडी आणि माहिती येथून आयात करा
import-items-page-title = आयात करण्यासाठीचे घटक

import-items-description = कोणते घटक आयात करायचे ते निवडा:

import-migrating-page-title = आयात करत आहे…

import-migrating-description = खालील घटक सध्या आयात केले जात आहेत…

import-select-profile-page-title = निवडसंच निवडा

import-select-profile-description = आयात करण्यासाठी पुढील निवडसंच उपलब्ध आहेत:

import-done-page-title = आयात करणे पुर्ण झाले

import-done-description = खालील घटक यशस्वीरित्या आयात केले गेले:

import-close-source-browser = कृपया पुढे जायच्या पहिले निवडलेला ब्राउझर बंद आहे याची खात्री करा.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } पासून

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = सफारि
source-name-canary = Google Chrome Canary
source-name-chrome = गूगल क्रोम
source-name-chrome-beta = Google Chrome बीटा
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 सुरक्षित ब्राउझर

imported-safari-reading-list = सूची वाचत आहे (सफारीपासून)
imported-edge-reading-list = सूची वाचत आहे (Edge मधून)

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
    .label = चौकट व टॅब
browser-data-session-label =
    .value = चौकट व टॅब
