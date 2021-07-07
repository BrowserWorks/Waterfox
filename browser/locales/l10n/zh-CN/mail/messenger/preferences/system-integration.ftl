# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = 系统集成
system-integration-dialog =
    .buttonlabelaccept = 设为默认值
    .buttonlabelcancel = 跳过整合
    .buttonlabelcancel2 = 取消
default-client-intro = 使用 { -brand-short-name } 作为下列应用的默认客户端：
unset-default-tooltip = 无法在 { -brand-short-name } 中取消 { -brand-short-name } 的默认程序设置，要将另一个应用程序设置为默认，你必须使用它自己的“设置为默认”对话框。
checkbox-email-label =
    .label = 电子邮件
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = 新闻组
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = 收取点
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = 日历
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows 搜索
       *[other] { "" }
    }
system-search-integration-label =
    .label = 允许 { system-search-engine-name } 搜索邮件
    .accesskey = s
check-on-startup-label =
    .label = 每次启动 { -brand-short-name } 时都进行此项检查
    .accesskey = A
