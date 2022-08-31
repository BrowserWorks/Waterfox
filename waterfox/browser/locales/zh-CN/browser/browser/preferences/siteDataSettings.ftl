# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = 管理 Cookie 和网站数据

site-data-settings-description = 以下网站在您的计算机上存储了 Cookie 和网站数据。{ -brand-short-name } 会永久存储网站的数据，直至您删除，或者在需要空间时删除非持久存储的网站数据。

site-data-search-textbox =
    .placeholder = 搜索网站
    .accesskey = S

site-data-column-host =
    .label = 站点
site-data-column-cookies =
    .label = Cookie
site-data-column-storage =
    .label = 存储
site-data-column-last-used =
    .label = 上次使用

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = （本地文件）

site-data-remove-selected =
    .label = 移除选中
    .accesskey = r

site-data-settings-dialog =
    .buttonlabelaccept = 保存更改
    .buttonaccesskeyaccept = a

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value }（持久）

site-data-remove-all =
    .label = 全部移除
    .accesskey = e

site-data-remove-shown =
    .label = 移除筛选出的项目
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = 移除

site-data-removing-header = 移除 Cookie 和网站数据

site-data-removing-desc = 移除 Cookie 和网站数据可能使您的网站登录状态丢失。确定执行？

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = 移除 Cookie 和网站数据后，可能会退出登录大部分网站。确定要移除 <strong>{ $baseDomain }</strong> 的 Cookie 和网站数据吗？

site-data-removing-table = 下列网站的 Cookie 和网站数据将被移除
