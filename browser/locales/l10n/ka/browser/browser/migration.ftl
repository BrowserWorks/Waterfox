# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = მონაცემთა გადმოტანა

import-from =
    { PLATFORM() ->
        [windows] გადმოიტანეთ პარამეტრები, სანიშნები, ისტორია, პაროლები და სხვა მონაცემები ბრაუზერიდან:
       *[other] გადმოიტანეთ პარამეტრები, სანიშნები, ისტორია, პაროლები და სხვა მონაცემები ბრაუზერიდან:
    }

import-from-bookmarks = სანიშნების გადმოტანა:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (მოძველებული)
    .accesskey = მ
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = გადმოტანის გარეშე
    .accesskey = გ
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

no-migration-sources = სანიშნების, ისტორიის ან პაროლის მონაცემთა შემცველი პროგრამები ვერ მოიძებნა.

import-source-page-title = პარამეტრებისა და მონაცემთა გადმოტანა
import-items-page-title = გადმოსატანი მონაცემები

import-items-description = მიუთითეთ გადმოსატანი მონაცემები:

import-migrating-page-title = გადმოტანა…

import-migrating-description = გადმოვა შემდეგი მონაცემები…

import-select-profile-page-title = პროფილის არჩევა

import-select-profile-description = შემდეგი პროფილები ხელმისაწვდომია გადმოსატანად ბრაუზერიდან:

import-done-page-title = გადმოტანა დასრულდა

import-done-description = გადმოტანილია შემდეგი მონაცემები:

import-close-source-browser = სანამ განაგრძობთ დარწმუნდით, რომ არჩეული ბრაუზერი დახურულია.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source }-დან

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

imported-safari-reading-list = წასაკითხი სია (Safari-დან)
imported-edge-reading-list = წასაკითხი სია (Edge-დან)

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

browser-data-cookies-checkbox =
    .label = ფუნთუშები
browser-data-cookies-label =
    .value = ფუნთუშები

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] გვერდების ისტორია და სანიშნები
           *[other] გვერდების ისტორია
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] გვერდების ისტორია და სანიშნები
           *[other] გვერდების ისტორია
        }

browser-data-formdata-checkbox =
    .label = შევსებული ველების ისტორია
browser-data-formdata-label =
    .value = შევსებული ველების ისტორია

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = შენახული ანგარიშები და პაროლები
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = შენახული ანგარიშები და პაროლები

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] რჩეულები
            [edge] რჩეულები
           *[other] სანიშნები
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] რჩეულები
            [edge] რჩეულები
           *[other] სანიშნები
        }

browser-data-otherdata-checkbox =
    .label = სხვა მონაცემები
browser-data-otherdata-label =
    .label = სხვა მონაცემები

browser-data-session-checkbox =
    .label = ფანჯრები და ჩანართები
browser-data-session-label =
    .value = ფანჯრები და ჩანართები
