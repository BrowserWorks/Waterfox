# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Майстер імпорту

import-from =
    { PLATFORM() ->
        [windows] Імпортувати налаштування, закладки, історію, паролі та інші дані з:
       *[other] Імпортувати налаштування, закладки, історію, паролі та інші дані з:
    }

import-from-bookmarks = Імпорт закладок з:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (застарілий)
    .accesskey = л
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Не імпортувати нічого
    .accesskey = Н
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

no-migration-sources = Не знайдено жодної програми із закладками, історією чи паролями.

import-source-page-title = Імпорт налаштувань і даних
import-items-page-title = Об’єкти для імпорту

import-items-description = Виберіть об’єкти для імпорту:

import-migrating-page-title = Триває імпорт…

import-migrating-description = Зараз імпортуються наступні об’єкти…

import-select-profile-page-title = Вибір профілю

import-select-profile-description = Імпорт можна провести з наступних профілів:

import-done-page-title = Імпорт успішно завершений

import-done-description = Наступні об’єкти успішно імпортовані:

import-close-source-browser = Перед продовженням переконайтеся, що вибраний браузер закрито.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = З { $source }

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

imported-safari-reading-list = Список читання (з Safari)
imported-edge-reading-list = Список читання (з Edge)

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
    .label = Куки
browser-data-cookies-label =
    .value = Куки

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Історія перегляду й закладки
           *[other] Історія перегляду
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Історія перегляду й закладки
           *[other] Історія перегляду
        }

browser-data-formdata-checkbox =
    .label = Історія збережених форм
browser-data-formdata-label =
    .value = Історія збережених форм

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Збережені паролі
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Збережені паролі

browser-data-bookmarks-checkbox =
    .label = Закладки
browser-data-bookmarks-label =
    .value = Закладки

browser-data-otherdata-checkbox =
    .label = Інші дані
browser-data-otherdata-label =
    .label = Інші дані

browser-data-session-checkbox =
    .label = Вікна і вкладки
browser-data-session-label =
    .value = Вікна і вкладки
