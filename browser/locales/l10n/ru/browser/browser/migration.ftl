# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Мастер импорта

import-from =
    { PLATFORM() ->
        [windows] Импортировать настройки, закладки, журнал, пароли и другие данные из:
       *[other] Импортировать настройки, закладки, журнал, пароли и другие данные из:
    }

import-from-bookmarks = Импортировать закладки из:
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
    .label = Не импортировать ничего
    .accesskey = н
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
    .label = Chrome Бета
    .accesskey = е
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Ни одной программы, содержащей закладки, журнал или пароли, не найдено.

import-source-page-title = Импорт настроек и данных
import-items-page-title = Объекты для импорта

import-items-description = Выберите объекты для импортирования:

import-permissions-page-title = Предоставьте разрешения для { -brand-short-name }

# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS требует, чтобы вы явно разрешили { -brand-short-name } доступ к закладкам Safari. Щёлкните «Продолжить» и выберите файл «Bookmarks.plist» на открывшейся панели «Открыть файл».

import-migrating-page-title = Идёт импорт…

import-migrating-description = В данное время импортируются следующие объекты…

import-select-profile-page-title = Выбор профиля

import-select-profile-description = Импорт может быть произведен из следующих профилей:

import-done-page-title = Импорт успешно завершён

import-done-description = Следующие объекты были успешно импортированы:

import-close-source-browser = Прежде чем продолжить, убедитесь, что выбранный вами браузер закрыт.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Из { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Бета
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Waterfox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Список для чтения (из Safari)
imported-edge-reading-list = Список для чтения (из Edge)

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
            [firefox] Журнал посещений и закладки
           *[other] Журнал посещений
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Журнал посещений и закладки
           *[other] Журнал посещений
        }

browser-data-formdata-checkbox =
    .label = Журнал сохранённых форм
browser-data-formdata-label =
    .value = Журнал сохранённых форм

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Сохранённые логины и пароли
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Сохранённые логины и пароли

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Избранное
            [edge] Избранное
           *[other] Закладки
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Избранное
            [edge] Избранное
           *[other] Закладки
        }

browser-data-otherdata-checkbox =
    .label = Другие данные
browser-data-otherdata-label =
    .label = Другие данные

browser-data-session-checkbox =
    .label = Окна и вкладки
browser-data-session-label =
    .value = Окна и вкладки
