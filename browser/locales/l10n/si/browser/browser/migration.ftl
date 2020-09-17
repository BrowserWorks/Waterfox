# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = ආයාත විශාරද

import-from =
    { PLATFORM() ->
        [windows] වරණ, පිටු සලකුණු, පෙරදෑ, රහස්පද සහ අනෙකුත් දත්ත ආයාත කළ යුත්තේ:
       *[other] මනාපයන්, පිටු සලකුණු, පෙරදෑ, රහස්පද සහ අනෙකුත් දත්ත ආයාත කළ යුත්තේ:
    }

import-from-bookmarks = පිටු සලකුණු ආයාත කිරීම:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = කිසිවක් ආයාත නොකරන්න
    .accesskey = D
import-from-safari =
    .label = සෆාරි (Safari)
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = ක්‍රෝම් (Chrome)
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

no-migration-sources = පිටු සලකුණු, අතීතය හෝ රහස්පද දත්ත අඩංගු වන කිසිදු වැඩසටහනක් සොයාගත නොහැකි විය.

import-source-page-title = සැකසුම් සහ දත්ත ආයාත කිරීම
import-items-page-title = ආයාත කරන අයිතමයන්

import-items-description = ආයාත කරන්නේ කුමක් දැයි තෝරන්න:

import-migrating-page-title = ආයාත කරමින්...

import-migrating-description = පහත අයිතමයන් ආයාත කරමින් සිටියි...

import-select-profile-page-title = පැතිකඩ තෝරන්න

import-select-profile-description = පහත සඳහන් පැතිකඩ ආයාත කිරිම සඳහා භාවිතයට ඇත:

import-done-page-title = ආයාත කිරීම සම්පූර්ණයි

import-done-description = පහත අයිතමයන් සාර්ථකව ආයාත කරන ලදී:

import-close-source-browser = ඉදිරියට ක්‍රියාත්මක වීමට පෙර තෝරාගත් ගවේශකය වසා ඇති බව තහවුරු කරගන්න.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } වෙතින්

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = සෆාරි (Safari)
source-name-canary = Google Chrome Canary
source-name-chrome = ගූග්ල් ක්‍රෝම් (Google Chrome)
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 ආරක්ෂිත ගවේෂකය

imported-safari-reading-list = කියවීම් ලැයිස්තුව (Safari වෙතින්)
imported-edge-reading-list = කියවීම් ලැයිස්තුව (Edge වෙතින්)

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
    .label = කවුළු සහ ටැබ්
browser-data-session-label =
    .value = කවුළු සහ ටැබ්
