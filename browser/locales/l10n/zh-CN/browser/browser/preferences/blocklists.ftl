# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = 拦截列表
    .style = width: 50em
blocklist-description = 选择 { -brand-short-name } 用于拦截在线跟踪器的列表。列表由 <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a> 提供。
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = 列表
blocklist-button-cancel =
    .label = 取消
    .accesskey = C
blocklist-button-ok =
    .label = 保存更改
    .accesskey = S
blocklist-dialog =
    .buttonlabelaccept = 保存更改
    .buttonaccesskeyaccept = S
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = 一级拦截列表（推荐）。
blocklist-item-moz-std-description = 允许部分跟踪器，以减少网站故障率。
blocklist-item-moz-full-listName = 二级拦截列表。
blocklist-item-moz-full-description = 拦截检测到的所有跟踪器。可能无法正常载入部分网站或内容。
