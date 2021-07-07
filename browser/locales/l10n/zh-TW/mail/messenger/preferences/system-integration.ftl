# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = 系統整合

system-integration-dialog =
    .buttonlabelaccept = 設為預設帳號
    .buttonlabelcancel = 略過整合
    .buttonlabelcancel2 = 取消

default-client-intro = 使用 { -brand-short-name } 作為預設用戶端:

unset-default-tooltip = 您無法在 { -brand-short-name } 當中將 { -brand-short-name } 作為預設郵件軟體的設定取消。若您要將其他軟體作為預設郵件軟體，請使用該軟體自己的「設為預設值」對話框。

checkbox-email-label =
    .label = 電子郵件
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = 新聞群組
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = 消息來源
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = 行事曆
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows 搜尋
       *[other] { "" }
    }

system-search-integration-label =
    .label = 允許 { system-search-engine-name } 搜尋訊息
    .accesskey = s

check-on-startup-label =
    .label = 每次啟動 { -brand-short-name } 時都重新檢查
    .accesskey = a
