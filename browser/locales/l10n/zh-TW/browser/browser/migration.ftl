# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = 匯入精靈
import-from =
    { PLATFORM() ->
        [windows] 由下列來源匯入選項、書籤、歷史記錄、已存密碼及其他資料:
       *[other] 由下列來源匯入偏好設定、書籤、記錄、密碼等資料:
    }
import-from-bookmarks = 由下列來源匯入書籤:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge 傳統版
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = 不要匯入任何東西
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
    .accesskey = X
import-from-360se =
    .label = 360 安全瀏覽器
    .accesskey = 3
no-migration-sources = 找不到包含書籤、瀏覽記錄或密碼等個人資訊的瀏覽程式。
import-source-page-title = 匯入設定與個人資料
import-items-page-title = 要匯入的項目
import-items-description = 選取要匯入的項目:
import-permissions-page-title = 請授權 { -brand-short-name }
# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS 要求您明確允許 { -brand-short-name } 存取 Safari 的書籤才能繼續。請點擊「繼續」，並從顯示的開啟檔案面板選擇「Bookmarks.plist」檔案。
import-migrating-page-title = 匯入中…
import-migrating-description = 正在匯入下列項目…
import-select-profile-page-title = 選取設定檔
import-select-profile-description = 可匯入下列設定檔的內容:
import-done-page-title = 匯入完成
import-done-description = 成功匯入下列項目:
import-close-source-browser = 請確定已關閉選擇的瀏覽器後繼續。
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = 由 { $source }
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
source-name-360se = 360 安全瀏覽器
imported-safari-reading-list = 閱讀列表（來自 Safari）
imported-edge-reading-list = 閱讀清單（來自 Edge）

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
    .label = Cookie
browser-data-cookies-label =
    .value = Cookie
browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] 瀏覽紀錄與書籤
           *[other] 瀏覽紀錄
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] 瀏覽紀錄與書籤
           *[other] 瀏覽紀錄
        }
browser-data-formdata-checkbox =
    .label = 已存表單記錄
browser-data-formdata-label =
    .value = 已存表單記錄
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = 登入資訊與密碼
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = 登入資訊與密碼
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] 我的最愛
            [edge] 我的最愛
           *[other] 書籤
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] 我的最愛
            [edge] 我的最愛
           *[other] 書籤
        }
browser-data-otherdata-checkbox =
    .label = 其他資料
browser-data-otherdata-label =
    .label = 其他資料
browser-data-session-checkbox =
    .label = 視窗與分頁
browser-data-session-label =
    .value = 視窗與分頁
