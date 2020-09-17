# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Импорт шебері

import-from =
    { PLATFORM() ->
        [windows] Баптаулар, бетбелгілер, тарихы, парольдерді және т.б. ақпаратты импорттау келесіден:
       *[other] Баптаулар, бетбелгілер, тарихы, парольдерді және т.б. ақпаратты импорттау келесіден:
    }

import-from-bookmarks = Бетбелгілерді келесіден импорттау:
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
    .accesskey = д
import-from-nothing =
    .label = Импорт керек емес
    .accesskey = к
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
    .label = 360 қауіпсіз браузері
    .accesskey = 3

no-migration-sources = Құрамында бетбелгілер, тарихы немесе парольдері бар бірде-бір бағдарлама табылмаған.

import-source-page-title = Баптаулар мен мәліметтер импорты
import-items-page-title = Импортталатын объектілер

import-items-description = Импортталатын объектілерді таңдаңыз:

import-migrating-page-title = Импорт жүріп жатыр…

import-migrating-description = Қазір келесі объектілер импортталуда…

import-select-profile-page-title = Профильді таңдау

import-select-profile-description = Келесі профильдер импортталуы мүмкін:

import-done-page-title = Импорт сәтті аяқталды

import-done-description = Келесі объектілер сәтті импортталды:

import-close-source-browser = Жалғастыру алдында таңдалған браузер жабылғанын тексеріңіз.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } - дан (ден)

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
source-name-360se = 360 қауіпсіз браузері

imported-safari-reading-list = Оқу тізімі (Safari ішінен)
imported-edge-reading-list = Оқу тізімі (Edge ішінен)

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
    .label = Cookie файлдары
browser-data-cookies-label =
    .value = Cookie файлдары

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Шолу тарихы мен бетбелгілер
           *[other] Шолу тарихы
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Шолу тарихы мен бетбелгілер
           *[other] Шолу тарихы
        }

browser-data-formdata-checkbox =
    .label = Сақталған формалар тарихы
browser-data-formdata-label =
    .value = Сақталған формалар тарихы

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Сақталған логиндер мен парольдер
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Сақталған логиндер мен парольдер

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Таңдамалылар
            [edge] Таңдамалылар
           *[other] Бетбелгілер
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Таңдамалылар
            [edge] Таңдамалылар
           *[other] Бетбелгілер
        }

browser-data-otherdata-checkbox =
    .label = Басқа деректер
browser-data-otherdata-label =
    .label = Басқа деректер

browser-data-session-checkbox =
    .label = Терезелер мен беттер
browser-data-session-label =
    .value = Терезелер мен беттер
