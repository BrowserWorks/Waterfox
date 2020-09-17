# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Ներմուծման Օգնական

import-from =
    { PLATFORM() ->
        [windows] Ներմուծել ընտրանքները, էջանիշերը, պատմությունը, գաղտնաբառերը և այլ տվյալներ այստեղից՝
       *[other] Ներմուծել կարգավորումները, էջանիշները, գաղտնաբառերը և այլ տվյալներ՝
    }

import-from-bookmarks = Ներմուծել էջանիշները՝
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Ոչինչ չներմուծել
    .accesskey = D
import-from-safari =
    .label = Safari­
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
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Չգտնվեց ծրագիր, որը պարունակում է էջանիշեր, պատմություն կամ գաղտնաբառ:

import-source-page-title = Ներմուծել կարգավորումները ու տվյալները
import-items-page-title = Ինչն է ներմուծվելու

import-items-description = Ընտրեք, թե ինչ պետք է ներմուծվի՝

import-migrating-page-title = Ներմուծվում է…

import-migrating-description = Հետևյալ բաղադրիչները ներմուծվում են…

import-select-profile-page-title = Ընտրեք հաշիվը

import-select-profile-description = Կարող եք ներմուծել հետևյալ հաշիվներից՝

import-done-page-title = Ներմուծումն ավարտվեց

import-done-description = Հետևյալ բաղադրիչները հաջողությամբ ներմուծվեցին՝

import-close-source-browser = Շարունակելուց առաջ խնդրում ենք համոզվել, որ ընտրված դիտարկիչը փակ է:

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source }-ից

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

imported-safari-reading-list = Ընթերցացուցակ (Safari-ից)
imported-edge-reading-list = Ընթերցացուցակ (Edge-ից)

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
    .label = Թխուկներ
browser-data-cookies-label =
    .value = Թխուկներ

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Զննարկման պատմություն և Էջանիշեր
           *[other] Զննարկման պատմություն
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Զննարկման պատմություն և Էջանիշեր
           *[other] Զննարկման պատմություն
        }

browser-data-formdata-checkbox =
    .label = Պահպանված Պատմությունից
browser-data-formdata-label =
    .value = Պահպանված Պատմությունից

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Պահպանել մուտքագրումներ և գաղտնաբառեր
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Պահպանել մուտքագրումներ և գաղտնաբառեր

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Ընտրյալներ
            [edge] Ընտրյալներ
           *[other] Էջանիշեր
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Ընտրյալներ
            [edge] Ընտրյալներ
           *[other] Էջանիշեր
        }

browser-data-otherdata-checkbox =
    .label = Այլ տվյալներ
browser-data-otherdata-label =
    .label = Այլ տվյալներ

browser-data-session-checkbox =
    .label = Պատուհաններ և ներդիրներ
browser-data-session-label =
    .value = Պատուհաններ և ներդիրներ
