# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = 封鎖清單
    .style = width: 55em
blocklist-description = 請選擇 { -brand-short-name } 要用來封鎖線上追蹤器的清單。清單內容是由 <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a> 提供。
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = 清單
blocklist-button-cancel =
    .label = 取消
    .accesskey = C
blocklist-button-ok =
    .label = 儲存變更
    .accesskey = S
blocklist-dialog =
    .buttonlabelaccept = 儲存變更
    .buttonaccesskeyaccept = S
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = 第一級封鎖清單（推薦）。
blocklist-item-moz-std-description = 允許一些追蹤器，會故障的網站比較少。
blocklist-item-moz-full-listName = 第二級封鎖清單。
blocklist-item-moz-full-description = 封鎖所有偵測到的追蹤器。可能無法正常載入部分網站或內容。
