# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = આયાત વિઝાર્ડ

import-from =
    { PLATFORM() ->
        [windows] વિકલ્પો, બુકમાર્કો, ઇતિહાસ, પાસવર્ડો, અહીંથી આયાત કરો:
       *[other] પસંદગીઓ, બુકમાર્કો, ઇતિહાસ, પાસવર્ડો, અહીંથી આયાત કરો:
    }

import-from-bookmarks = બુકમાર્કો આયાત કરો:
import-from-ie =
    .label = ઈન્ટરનેટ એક્સપ્લોરર
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = કંઇ આયાત ન કરો
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
    .accesskey = x
import-from-360se =
    .label = 360 સુરક્ષિત બ્રાઉઝર
    .accesskey = 3

no-migration-sources = બુકમાર્કો, ઇતિહાસ અથવા પાસવર્ડ માહિતીઓ સમાવતા કોઈ કાર્યક્રમો શોધી શક્યા નહિં.

import-source-page-title = સેટીંગ અને માહિતી અહીંથી આયાત કરો
import-items-page-title = આયાત કરવાની વસ્તુઓ

import-items-description = કઇ વસ્તુઓ આયાત કરવાની છે તે પસંદ કરો:

import-migrating-page-title = આયાત કરે છે...

import-migrating-description = નીચેની વસ્તુઓ અત્યારે આયાત થઇ રહી છે...

import-select-profile-page-title = રુપરેખા પસંદ કરો

import-select-profile-description = પોતાના માંથી નિકાસ કરવા માટે નીચેની રુપરેખાઓ પ્રાપ્ત છે:

import-done-page-title = આયાત પૂર્ણ

import-done-description = નીચેની વસ્તુઓ સફળતાપૂર્વક આયાત કરાઇ છે:

import-close-source-browser = ચાલુ રાખતાં પહેલાં કૃપા કરીને ખાતરી કરો કે પસંદ કરેલ બ્રાઉઝર બંધ છે.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } માંથી

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

imported-safari-reading-list = યાદીને વાંચી રહ્યા છે (સફારી માંથી)
imported-edge-reading-list = વાંચનની સૂચિ (Edge પરથી)

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
    .label = વિન્ડો અને ટૅબ્સ
browser-data-session-label =
    .value = વિન્ડો અને ટૅબ્સ
