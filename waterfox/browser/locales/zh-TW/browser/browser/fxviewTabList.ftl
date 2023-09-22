# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = 開啟選單
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = 用新分頁開啟 { $targetURI }
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = 關閉 { $tabTitle }
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = 剛剛

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = 刪除
    .accesskey = D
fxviewtabrow-forget-about-this-site = 忘記此網站…
    .accesskey = F
fxviewtabrow-open-in-window = 用新視窗開啟
    .accesskey = N
fxviewtabrow-open-in-private-window = 用新隱私視窗開啟
    .accesskey = P
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = 加入書籤…
    .accesskey = B
fxviewtabrow-save-to-pocket = 儲存至 { -pocket-brand-name }
    .accesskey = o
fxviewtabrow-copy-link = 複製鏈結
    .accesskey = L
fxviewtabrow-close-tab = 關閉分頁
    .accesskey = C
# Variables:
#   $tabTitle (string) - Title of the tab to which the context menu is associated
fxviewtabrow-options-menu-button =
    .title = { $tabTitle } 的選項
