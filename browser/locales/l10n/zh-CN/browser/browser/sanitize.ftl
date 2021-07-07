# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = 清除历史记录设置
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = 清除最近的历史记录
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = 清除全部历史
    .style = width: 34em

clear-data-settings-label = 退出后，{ -brand-short-name } 会自动清除所有

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = 要清除的时间范围：
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = 最近一小时

clear-time-duration-value-last-2-hours =
    .label = 最近两小时

clear-time-duration-value-last-4-hours =
    .label = 最近四小时

clear-time-duration-value-today =
    .label = 今天

clear-time-duration-value-everything =
    .label = 全部

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = 历史记录

item-history-and-downloads =
    .label = 浏览和下载历史
    .accesskey = B

item-cookies =
    .label = Cookie
    .accesskey = C

item-active-logins =
    .label = 登录状态
    .accesskey = L

item-cache =
    .label = 缓存
    .accesskey = a

item-form-search-history =
    .label = 表单和搜索历史
    .accesskey = F

data-section-label = 数据

item-site-preferences =
    .label = 站点设置
    .accesskey = S

item-offline-apps =
    .label = 脱机网站数据
    .accesskey = O

sanitize-everything-undo-warning = 此操作不可撤销。

window-close =
    .key = w

sanitize-button-ok =
    .label = 立即清除

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = 清除

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = 全部历史记录会被清空。

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = 将清空选中的项目内容。
