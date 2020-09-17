# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = విజార్డు దిగుమతిచేయి

import-from =
    { PLATFORM() ->
        [windows] ఎంపికలను, ఇష్టాంశాలను, చరిత్రను, సంకేతపదాలను మరియు ఇతర డేటాను దిగుమతి చేయండి:
       *[other] అభిరుచులను, ఇష్టాంశాలను, చరిత్రను, సంకేతపదాలను, ఇతర డాటాను దిగుమతి చేయి:
    }

import-from-bookmarks = ఇష్టాంశాలను దిగుమతిచేయి:
import-from-ie =
    .label = మైక్రోసాఫ్ట్ ఇంటర్నెట్‌ ఎక్స్‌ప్లోరర్
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge లెగసీ
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge బీటా
    .accesskey = d
import-from-nothing =
    .label = దేనిని దిగుమతి చేయవద్దు
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
    .label = క్రోమ్ బీటా
    .accesskey = B
import-from-chrome-dev =
    .label = క్రోమ్ డెవ్
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Firefox
    .accesskey = x
import-from-360se =
    .label = 360 సురక్షిత విహారిణి
    .accesskey = 3

no-migration-sources = ఇష్టాంశములు, చరిత్ర లేదా సంకేతపద డాటాను కలిగివున్న ప్రొగ్రాము కనుగొనబడలేదు.

import-source-page-title = డేటాను, అమరికలను దిగుమతిచేయి
import-items-page-title = దిగుమతి కావడానికి అంశములు

import-items-description = ఏయే అంశాలు దిగుమతి కావాలో ఎంచుకోండి:

import-migrating-page-title = దిగుమతవుతున్నది...

import-migrating-description = ఈ క్రింది అంశములు ప్రస్తుతం దిగుమతవుతున్నవి...

import-select-profile-page-title = ప్రొఫైలు ఎంచుకోండి

import-select-profile-description = ఈ క్రింది ప్రొఫైల్సు దిగుమతికి అందుబాటులో వున్నాయి నుండి:

import-done-page-title = పూర్తిగా దిగుమతిచేయి

import-done-description = ఈ క్రింది అంశములు సమర్ధంగా దిగుమతైనవి:

import-close-source-browser = కొనసాగే ముందు ఎంచుకున్న విహారిణి మూసివుందని నిర్ధారించుకోండి.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } నుండి

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge బీటా
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = గూగుల్ క్రోమ్ బీటా
source-name-chrome-dev = గూగుల్ క్రోమ్ డెవ్
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 సురక్షిత విహారిణి

imported-safari-reading-list = జాబితాను చదువుతోంది (సఫారీ నుండి)
imported-edge-reading-list = చదవాల్సిన జాబితా (ఎడ్జ్ నుండి)

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
    .label = కుకీలు
browser-data-cookies-label =
    .value = కుకీలు

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] విహరణ చరిత్ర, ఇష్టాంశాలు
           *[other] విహరణ చరిత్ర
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] విహరణ చరిత్ర, ఇష్టాంశాలు
           *[other] విహరణ చరిత్ర
        }

browser-data-formdata-checkbox =
    .label = భద్రపరచిన ఫారాల చరిత్ర
browser-data-formdata-label =
    .value = భద్రపరచిన ఫారాల చరిత్ర

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = భద్రపరచిన ప్రవేశాలు, సంకేతపదాలు
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = భద్రపరచిన ప్రవేశాలు, సంకేతపదాలు

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] ఇష్టాంశాలు
            [edge] ఇష్టాంశాలు
           *[other] ఇష్టాంశాలు
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] ఇష్టాంశాలు
            [edge] ఇష్టాంశాలు
           *[other] ఇష్టాంశాలు
        }

browser-data-otherdata-checkbox =
    .label = ఇతర డేటా
browser-data-otherdata-label =
    .label = ఇతర డేటా

browser-data-session-checkbox =
    .label = విండోలు, ట్యాబులు
browser-data-session-label =
    .value = విండోలు, ట్యాబులు
