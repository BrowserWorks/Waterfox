# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = 导入向导
import-from =
    { PLATFORM() ->
        [windows] 从下列来源导入选项、书签、历史记录、密码以及其他数据：
       *[other] 从下列来源导入首选项、书签、历史记录、密码以及其他数据：
    }
import-from-bookmarks = 从下列来源导入书签：
import-from-ie =
    .label = 微软 IE 浏览器
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge 旧版
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = 不导入任何数据
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
    .label = 360 安全浏览器
    .accesskey = 3
no-migration-sources = 找不到存有书签、历史记录或密码数据的浏览器。
import-source-page-title = 导入设置及数据
import-items-page-title = 要导入的项目
import-items-description = 请选择要导入的项目：
import-permissions-page-title = 请授权 { -brand-short-name }
# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS 要求您明确允许 { -brand-short-name } 访问 Safari 书签才能继续。请点击“继续”，并从显示的打开文件面板中选择“Bookmarks.plist”文件。
import-migrating-page-title = 正在导入…
import-migrating-description = 正在导入下列项目…
import-select-profile-page-title = 选择配置文件
import-select-profile-description = 下列配置文件可以导入：
import-done-page-title = 导入完成
import-done-description = 成功导入下列各项：
import-close-source-browser = 请先关闭选定的浏览器，再继续操作。
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = 来自 { $source }
source-name-ie = 微软 IE 浏览器
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 安全浏览器
imported-safari-reading-list = 阅读列表（来自 Safari）
imported-edge-reading-list = 阅读列表（来自 Edge）

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
            [firefox] 浏览历史和书签
           *[other] 浏览历史
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] 浏览历史
           *[other] 浏览历史和书签
        }
browser-data-formdata-checkbox =
    .label = 已保存的表单记录
browser-data-formdata-label =
    .value = 已保存的表单记录
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = 登录名和密码
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = 登录名和密码
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] 收藏夹
            [edge] 收藏夹
           *[other] 书签
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] 收藏夹
            [edge] 收藏夹
           *[other] 书签
        }
browser-data-otherdata-checkbox =
    .label = 其他数据
browser-data-otherdata-label =
    .label = 其他数据
browser-data-session-checkbox =
    .label = 窗口和标签页
browser-data-session-label =
    .value = 窗口和标签页
