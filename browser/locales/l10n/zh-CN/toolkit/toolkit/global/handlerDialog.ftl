# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = 要允许此网站打开 { $scheme } 链接吗？
permission-dialog-description-file = 要允许此文件打开 { $scheme } 链接吗？
permission-dialog-description-host = 要允许 { $host } 打开 { $scheme } 链接吗？
permission-dialog-description-app = 要允许此网站使用 { $appName } 打开 { $scheme } 链接吗？
permission-dialog-description-host-app = 要允许 { $host } 使用 { $appName } 打开 { $scheme } 链接吗？
permission-dialog-description-file-app = 要允许此文件使用 { $appName } 打开 { $scheme } 链接吗？

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = 一律允许 <strong>{ $host }</strong> 打开 <strong>{ $scheme }</strong> 链接
permission-dialog-remember-file = 一律允许此文件打开 <strong>{ $scheme }</strong> 链接

##

permission-dialog-btn-open-link =
    .label = 打开链接
    .accessKey = O
permission-dialog-btn-choose-app =
    .label = 选择应用程序
    .accessKey = A
permission-dialog-unset-description = 您需要选择一个应用程序。
permission-dialog-set-change-app-link = 选择其他应用程序。

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = 选择应用程序
    .style = min-width: 26em; min-height: 26em;
chooser-dialog =
    .buttonlabelaccept = 打开链接
    .buttonaccesskeyaccept = O
chooser-dialog-description = 选择用于打开 { $scheme } 链接的应用程序。
# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = 一律使用此应用程序打开 <strong>{ $scheme }</strong> 链接
chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] 可在 { -brand-short-name } 的选项中进行更改。
       *[other] 可在 { -brand-short-name } 的首选项中进行更改。
    }
choose-other-app-description = 选择其他应用程序
choose-app-btn =
    .label = 选择…
    .accessKey = C
choose-other-app-window-title = 其他应用程序…
# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = 已在隐私窗口中禁用
