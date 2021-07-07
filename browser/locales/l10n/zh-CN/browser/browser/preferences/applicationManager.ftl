# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

app-manager-window =
    .title = 应用程序详细信息
    .style = width: 30em; min-height: 20em;

app-manager-remove =
    .label = 移除
    .accesskey = R

# Variables:
#   $type (String) - the URI scheme of the link (e.g. mailto:)
app-manager-handle-protocol = 如下应用程序可用来处理“{ $type } 链接”。

# Variables:
#   $type (String) - the MIME type (e.g. application/binary)
app-manager-handle-file = 如下应用程序可用来处理“{ $type } 内容”。

## These strings are followed, on a new line,
## by the URL or path of the application.

app-manager-web-app-info = 此网页应用程序位于：
app-manager-local-app-info = 此应用程序位于：
