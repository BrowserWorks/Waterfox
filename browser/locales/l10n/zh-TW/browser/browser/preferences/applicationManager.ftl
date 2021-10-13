# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

app-manager-window =
    .title = 程式詳細資訊
    .style = width: 30em; min-height: 20em;

app-manager-remove =
    .label = 移除
    .accesskey = R

# Variables:
#   $type (String) - the URI scheme of the link (e.g. mailto:)
app-manager-handle-protocol = 下列程式可用來處理 { $type } 鏈結。

# Variables:
#   $type (String) - the MIME type (e.g. application/binary)
app-manager-handle-file = 下列程式可用來處理 { $type } 內容。

## These strings are followed, on a new line,
## by the URL or path of the application.

app-manager-web-app-info = 此網路應用程式架設在:
app-manager-local-app-info = 此程式位於:
