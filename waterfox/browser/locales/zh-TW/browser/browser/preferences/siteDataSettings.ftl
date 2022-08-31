# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = 管理 Cookie 與網站資料

site-data-settings-description = 下列網站在您的電腦上儲存了 Cookie 及網站資料。{ -brand-short-name } 會將來自這些網站的資料保留於持續性儲存空間，到您主動刪除為止。也會在需要磁碟空間時，就刪除保留於非持續性儲存空間的資料。

site-data-search-textbox =
    .placeholder = 搜尋網站
    .accesskey = S

site-data-column-host =
    .label = 網站
site-data-column-cookies =
    .label = Cookie
site-data-column-storage =
    .label = 儲存空間
site-data-column-last-used =
    .label = 上次使用

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (本機檔案)

site-data-remove-selected =
    .label = 移除選擇項目
    .accesskey = r

site-data-settings-dialog =
    .buttonlabelaccept = 儲存變更
    .buttonaccesskeyaccept = a

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value }（持續）

site-data-remove-all =
    .label = 移除全部
    .accesskey = e

site-data-remove-shown =
    .label = 移除全部顯示項目
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = 移除

site-data-removing-header = 移除 Cookie 與網站資料

site-data-removing-desc = 移除 Cookie 與網站資料後，可能會將您從大部分網站登出。確定要移除嗎？

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = 移除 Cookie 與網站資料後，可能會將您從大部分網站登出。確定要移除來自 <strong>{ $baseDomain }</strong> 的 Cookie 與網站資料嗎？

site-data-removing-table = 將移除下列網站的 Cookie 與網站資料
